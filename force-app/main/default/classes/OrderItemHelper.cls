public without sharing class OrderItemHelper {

    public static void preventInvalidFeeAddition() {
        List<OrderItem> newItems = Trigger.new;
        PricebookEntry feeEntry = [
            SELECT UnitPrice, Product2Id 
            FROM PricebookEntry 
            WHERE Product2.Name = 'Environmental Fee'
        ];

        Map<Id, List<OrderItem>> orderIdToNewItems = new Map<Id, List<OrderItem>>();
        Boolean workNeeded = false;
        for (OrderItem item : newItems) {
            if (item.Product2Id == feeEntry.Product2Id) {
                workNeeded = true;
            }
            List<OrderItem> currItems = orderIdToNewItems.get(item.OrderId);
            if (currItems == null) {
                List<OrderItem> newList = new List<OrderItem>();
                newList.add(item);
                orderIdToNewItems.put(item.OrderId, newList);
            }
            else {
                currItems.add(item);
            }
        }
        if(!workNeeded) {return;}

        for (Id oid : orderIdToNewItems.keySet()) {
            List<OrderItem> newOrderItems = orderIdToNewItems.get(oid);
            OrderItem envFee = getFeeItem(newOrderItems, feeEntry.Product2Id);
            if (envFee == null) {continue;}
            if (newOrderItems.size() == 1) {
                envFee.addError('Cannot insert an environmental fee on an order without paper products');
            }
        }
    }

    private static OrderItem getFeeItem(List<OrderItem> listToCheck, Id feeId) {
        for (OrderItem item : listToCheck) {
            if (item.Product2Id == feeId) {
                return item;
            }
        }

        return null;
    }
    
    public static void addEnvironmentalFee() {
        Set<Id> relatedOrderIdsToCheck = new Set<Id>();

        List<OrderItem> newItems = Trigger.new;

        // Make a set of orders to check for the fee
        for (OrderItem item : newItems) {
            relatedOrderIdsToCheck.add(item.OrderId);
        }

        // Retrieve the PricebookEntry for the fee (has all the necessary info for the OrderItem)
        PricebookEntry feeEntry = [
            SELECT UnitPrice, Product2Id 
            FROM PricebookEntry 
            WHERE Product2.Name = 'Environmental Fee'
        ];

        // Retrieve orders related to the new order items that don't already have the fee but should
        List<Order> ordersWithoutFee = [
            SELECT Id
            FROM Order 
            WHERE Id IN :relatedOrderIdsToCheck 
            AND Id NOT IN (SELECT OrderId FROM OrderItem WHERE Product2Id = :feeEntry.Product2Id)
            AND Id IN (SELECT OrderId FROM OrderItem WHERE Product2.Name LIKE '%Paper%')
        ];

        // If we shouldn't add any fees, just exit
        if (ordersWithoutFee.isEmpty()) { return; }

        // Add the fees
        List<OrderItem> fees = new List<OrderItem>();
        for (Order ord : ordersWithoutFee) {
            fees.add(new OrderItem(
                Quantity = 1, 
                UnitPrice = feeEntry.UnitPrice,
                OrderId = ord.Id, 
                Product2Id = feeEntry.product2Id, 
                PricebookEntryId = feeEntry.Id));
        }

        insert fees;
    }

    public static void removeEnvironmentalFee() {
        Set<Id> relatedOrderIdsToCheck = new Set<Id>();
        List<OrderItem> deletedItems = Trigger.old;

        // Get a set of Ids to start the filtering off
        for (OrderItem item : deletedItems) {
            relatedOrderIdsToCheck.add(item.OrderId);
        }

        // Get orders that have the fee and should have it removed
        Map<Id, Order> removeFeeOnThese = new Map<Id, Order>([
            SELECT Id
            FROM Order
            WHERE Id IN :relatedOrderIdsToCheck
            AND Id NOT IN (SELECT OrderId FROM OrderItem WHERE Product2.Name LIKE '%Paper%')
            AND Id IN (SELECT OrderId FROM OrderItem WHERE Product2.Name = 'Environmental Fee')
        ]);

        // If no orders should have their fees removed, just exit
        if (removeFeeOnThese.isEmpty()) { return; }

        // Otherwise, delete those fees
        delete [SELECT Id FROM OrderItem WHERE OrderId IN :removeFeeOnThese.keySet() AND Product2.Name = 'Environmental Fee'];
    }
}