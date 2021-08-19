// Best practice for triggers is to have 1 trigger per object
// Because of this, we should set them up to be easily added to in the future
trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    // We should be able to handle every case
    switch on trigger.operationType {
        when BEFORE_INSERT { // Fires on Upsert
            // We use a handler class to keep our trigger logicless as a best practice
            // This makes it easier to maintain
            AccountHandler.ValidateAccounts(trigger.new);
        }
        when BEFORE_UPDATE { // Fires on Upsert and Merge
            
        }
        when BEFORE_DELETE { // Fires on Merge
            // Must use trigger.old here
        }
        when AFTER_INSERT { // Fires on Upsert
            AccountHandler.ChangeContacts(trigger.new);
        }
        when AFTER_UPDATE { // Fires on Upsert and Merge
            // Can use trigger.old here
        }
        when AFTER_DELETE { // Fires on Merge
            // Can use trigger.old here
        }
        when AFTER_UNDELETE {
            
        }
    }
    
    // Also acceptable:
    // -------------------------------------
    if (trigger.isBefore) {
        if (trigger.isInsert) {
            
        }
        else if (trigger.isUpdate) {
            
        }
        else if (trigger.isDelete) {
            
        }
    }
    else if (trigger.isAfter) {
        if (trigger.isInsert) {
            
        }
        else if (trigger.isUpdate) {
            
        }
        else if (trigger.isDelete) {
            
        }
        else if (trigger.isUndelete) {
            
        }
    }
}