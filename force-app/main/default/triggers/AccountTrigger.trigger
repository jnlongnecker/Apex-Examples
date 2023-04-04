/*
    Created by: Jared Longnecker
    Last Updated: 03/17/2022
    Description: Basic trigger on Accounts
*/

// Best practice for triggers is to have 1 trigger per object
// Because of this, we should set them up to be easily added to in the future
Trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    // The System.Trigger class holds context variables about the executing trigger
    // This isn't unique to Trigger files, and you can even check if you're in a trigger using Trigger.isExecuting.
    // However, to keep things tidy you should really only use these in Trigger files

    // We should be able to handle every case
    switch on Trigger.operationType {
        when BEFORE_INSERT { // Fires on Upsert
            // We use a handler class to keep our trigger logicless as a best practice
            // This makes it easier to maintain
            AccountHandler.ValidateAccounts(Trigger.new);
        }
        when BEFORE_UPDATE { // Fires on Upsert and Merge
            // Can use Trigger.old here
        }
        when BEFORE_DELETE { // Fires on Merge
            // Must use Trigger.old here
        }
        when AFTER_INSERT { // Fires on Upsert
            AccountHandler.ChangeContacts(Trigger.new);
        }
        when AFTER_UPDATE { // Fires on Upsert and Merge
            // Can use Trigger.old here
        }
        when AFTER_DELETE { // Fires on Merge
            // Must use Trigger.old here
        }
        when AFTER_UNDELETE {
            
        }
    }
    
    // Also acceptable:
    // -------------------------------------
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            
        }
        else if (Trigger.isUpdate) {
            
        }
        else if (Trigger.isDelete) {
            
        }
    }
    else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            
        }
        else if (Trigger.isUpdate) {
            
        }
        else if (Trigger.isDelete) {
            
        }
        else if (Trigger.isUndelete) {
            
        }
    }
}