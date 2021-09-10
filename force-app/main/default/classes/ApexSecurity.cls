public with sharing class ApexSecurity {
	// Record level security:
	// - Use sharing keywords on the class
	// - 3 Kinds:
	//   - with sharing
	//   - without sharing
	//   - inherited sharing
	// - If none specified, default is without sharing if it starts the transaction and inherited sharing otherwise
	// - If inherited sharing starts our transaction, it acts as with sharing
	
    public static void ObjectAndField() {
        
        // Our first option is the ugly, naive option of WITH SECURITY_ENFORCED
        // This technically works, but it just throws an exception if we don't have the proper permissions
        try {
        	List<Account> uglySolution = [SELECT name, rating, taxBracket__c FROM Account WITH SECURITY_ENFORCED];            
        }
        catch (System.QueryException e) {
            System.debug('Ugly');
        }
        
        // The more elegant solution is to use Security.StripInaccessible()
        // This will simply remove the fields we don't have access to
		List<Account> prettierSolution = [SELECT name, rating, taxBracket__c FROM Account];
        
        // We can specify READABLE, CREATEABLE, UPDATABLE, or UPSERTABLE
        SObjectAccessDecision filtered = Security.StripInaccessible(AccessType.UPDATABLE, prettierSolution);
		prettierSolution = (List<Account>)filtered.getRecords();
        
        System.debug(prettierSolution);
        
        // The most precise solution is to use the Schema class once more
        // We can specify isAccessible(), isCreateable(), and isUpdateable() for any object describe or field describe
        if (Schema.sObjectType.Account.isCreateable()) {
            System.debug('The context user has Create access on Accounts!');
        }
        else {
            System.debug('The context user does not have Create access on Accounts!');
        }
        
        // The same can be done for all field describe
        if (Schema.sObjectType.Account.fields.taxBracket__c.isUpdateable()) {
            System.debug('The context user has Edit access on Tax Bracket!');
        }
        else {
            System.debug('The context user does not have Edit access on Tax Bracket!');
        }
        
        // Lastly, we can also programatically share records in Apex
        Account toShare = prettierSolution[0];
        User toShareWith = [SELECT id FROM User WHERE name = 'Bob The Minion'];
        
        // This is faciliated through the _Share class. A custom object share is denoted as: Custom__Share
        AccountShare newShare = new AccountShare();
        newShare.AccountAccessLevel = 'Read'; // Can also be Edit or All
        newShare.AccountId = toShare.id;
        newShare.UserOrGroupId = toShareWith.id;
        
        // Because Accounts and Opportunities are tightly coupled, we also must define access for Opportunities
        newShare.OpportunityAccessLevel = 'Read';
        
        // RowCause is our reason for sharing. We can add more than Manual, but only for Custom Objects
        // We have to go into SF Classic to make this change, because we can't have nice things
        newShare.RowCause = Schema.AccountShare.RowCause.Manual; // This can be omitted, as this is the default
        
        // Finally, we insert the new share
        Insert newShare;
    }
}