trigger OrderItemTrigger on OrderItem (before insert, after insert, after update, after delete) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            OrderItemHelper.preventInvalidFeeAddition();
        }
        when AFTER_INSERT, AFTER_UPDATE {
            OrderItemHelper.addEnvironmentalFee();
        }
        when AFTER_DELETE {
            OrderItemHelper.removeEnvironmentalFee();
        }
    }
}