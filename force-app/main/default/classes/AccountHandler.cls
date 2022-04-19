/*
    Created by: Jared Longnecker
    Last Updated: 03/17/2022
    Description: Handler class for the Account Trigger
*/

public class AccountHandler {
	
    // In a before trigger, we can modify the records before they are committed
    // Another best practice is to bulkify your trigger
    public static void ValidateAccounts(List<Account> modifiedAccounts) {
        
        // Trigger is set up to work for multiple records, no DML or SOQL in loops
        for(Account currAccount : modifiedAccounts) {
            if(!MatchesFormat(currAccount)) {
                continue;
            }
            if(!IsValid(currAccount)) {
                currAccount.addError('Account not selected.');
            }
            else {
                currAccount.name += ' was selected!';
            }
        }
        // Note that we don't insert here. This would cause the before insert trigger to fire again
        // Which leads us to our final best practice: avoid trigger recursion
    }
    
    // This would contain your complex validation logic
    @testVisible private static Boolean IsValid(Account currAccount) {
        
        // Simple validation logic should be handled in a validation rule
        String name = currAccount.name;
        Integer value = Integer.valueOf(name.substring(4));
        return Math.mod(value, 2) == 0 && Math.mod(value, 6) == 0;
    }
    
    private static Boolean MatchesFormat(Account currAccount) {
        String name = currAccount.name;
        return name.IndexOf('Acc ') == 0;
    }
    
    
    // -------- AFTER TRIGGER ---------
    
    
    // In an after trigger, fields are read only but we can modify other objects and access system fields
    public static void ChangeContacts(List<Account> modifiedAccounts) {
        
        // Consolidate all the changed contacts to do a single DML statement at the end
        List<Contact> newContacts = new List<Contact>();
        for(Account currAccount : modifiedAccounts) {
            
            // Perform our logic
            newContacts.add(CreateLinkedContact(currAccount));
        }
        
        Insert newContacts;
    }
    
    // Keep our complex logic outside of the loop to simplify our method
    private static Contact CreateLinkedContact(Account acc) {
        Contact newContact = new Contact();
        
        // Common uses of after triggers are to change other objects or access system fields and IDs
        newContact.firstName = 'Contact for';
        newContact.lastName = acc.name;
        newContact.accountId = acc.id;
        return newContact;
    }
}

/*
    When to use what kind of trigger?
    Before
        You need to perform complex validation
        You need to modify/adjust a value before it gets saved
        You need to do complex calculation of a field that cannot be done in a formula field
    After
        You need to access system fields
        You need to access the ID of your records
        You need to see the value of your fields before your records are committed
        You need to check what a field was changed to

    Best Practices of Triggers
    1. Keep your trigger logicless
    2. 1 trigger per object
    3. Bulkify your trigger
    4. Avoid trigger recursion
*/


/*
Execute Anonymous Code:
List<Account> toDelete = [SELECT id FROM Account WHERE name LIKE 'Acc %'];
Delete toDelete;

List<Account> myAccounts = new List<Account>();

for(Integer i = 0; i < 25; i++) {
    myAccounts.add(new Account(name = 'Acc ' + i));
}

Database.insert(myAccounts, false);
*/