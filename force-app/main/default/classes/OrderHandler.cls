public class OrderHandler {

    public static void ModifyHaul(List<Order> oldOrders, List<Order> changedOrders) {
        List<Account> updatedAccounts = new List<Account>();
        Map<Account, List<Order>> accountMap = GetAccountMap(changedOrders);
        
        for (Account currAccount : accountMap.KeySet()) {
            //currAccount.haulWorth__c = CalculateTotalWorth(accountMap.get(currAccount));
            updatedAccounts.add(currAccount);
        }

        Update updatedAccounts;
    }
    
    private static Map<Account, List<Order>> GetAccountMap(List<Order> orders) {
        Set<ID> accountIDs = new Set<ID>();
        for (Order o : orders) {
            accountIDs.add(o.accountId);
        }
        List<Account> relevantAccounts = [SELECT (SELECT totalAmount FROM Orders WHERE status = 'Activated') FROM Account WHERE id IN : accountIDs];
        Map<Account, List<Order>> accountMap = new Map<Account, List<Order>>();
        for (Account acc : relevantAccounts) {
            accountMap.put(acc, acc.Orders);
        }
        return accountMap;
    }
    
    private static Double CalculateTotalWorth(List<Order> allOrders) {
        Double totalWorth = 0;
        for (Order o : allOrders) {
            totalWorth += o.totalAmount;
        }
        
        return totalWorth;
    }
}