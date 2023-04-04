/*
    Created by: Jared Longnecker
    Last Updated: 03/17/2022
    Description: A look at enforcing security VIA Apex and sharing records
*/

public with sharing class ApexSecurity {
	// Record level security:
	// - Use sharing keywords on the class
	// - 3 Kinds:
	//   - with sharing
	//   - without sharing
	//   - inherited sharing
	// - If none specified, default is without sharing if it starts the transaction and inherited sharing otherwise
	// - If inherited sharing starts our transaction, it acts as with sharing
    // - Can impact rows returned by SOSL or SOQL
    // - Can prevent DML from working because of not having access to a foreign key
	
    public static void ObjectAndField() {
        
        // Our first option is the ugly, naive option of WITH SECURITY_ENFORCED
        // This technically works, but it just throws an exception if we don't have the proper permissions
        // Does not enforce polymorphic relationships except owner, createdBy and lastModifiedBy
        // Only enforces data returned from SELECT and FROM
        try {
        	List<Account> uglySolution = [SELECT name, rating FROM Account WITH SECURITY_ENFORCED];            
        }
        catch (System.QueryException e) {
            System.debug('Ugly');
        }

        /*
            WITH USER_MODE takes into consideration polymorphic fields and runs for all clauses
            It also will catch all errors instead of the first one
        */
        try {
            List<Account> ugly2 = [SELECT Name, Rating FROM Account WITH USER_MODE];
        }
        catch(System.QueryException e) {
            System.debug(e.getInaccessibleFields());
        }

        
        // The more elegant solution is to use Security.StripInaccessible()
        // This will simply remove the fields we don't have access to
		List<Account> prettierSolution = [SELECT name, rating FROM Account];
        
        // We can specify READABLE, CREATEABLE, UPDATABLE, or UPSERTABLE
        // We can optionally not check object security
        // If we check object security and it fails, it throws an exception
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
        if (Schema.sObjectType.Account.fields.rating.isUpdateable()) {
            System.debug('The context user has Edit access on Rating!');
        }
        else {
            System.debug('The context user does not have Edit access on Rating!');
        }
        
        // Lastly, we can also programatically share records in Apex
        Account toShare = prettierSolution[0];
        User toShareWith = [SELECT id FROM User WHERE name = 'Devon Demo'];
        
        // This is faciliated through the _Share class. A custom object share is denoted as: Custom__Share
        AccountShare newShare = new AccountShare();
        newShare.AccountAccessLevel = 'Read'; // Can also be Edit or All
        newShare.AccountId = toShare.id;
        newShare.UserOrGroupId = toShareWith.id;
        
        // Because Accounts and Opportunities are tightly coupled, we also must define access for Opportunities
        newShare.OpportunityAccessLevel = 'Read';
        
        // RowCause is our reason for sharing. We can add more than Manual, but only for Custom Objects
        // Other RowCause values include: Owner, Rule, and ImplicitChild
        // We have to go into SF Classic to make this change, because we can't have nice things
        newShare.RowCause = Schema.AccountShare.RowCause.Manual; // This can be omitted, as this is the default
        
        // Finally, we insert the new share
        Insert newShare;
    }
}

/*
    DescribeFieldResult r = Schema.sObjectType.Account.fields.getMap().get(accFieldName).getDescribe();
*/