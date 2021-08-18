public class WorkingWithData {
	// SOQL
	// - Salesforce Object Query Language
	// - SQL familiar syntax, but different than SQL
	// - We can use this natively in Apex
	// - Querying for the data in our org
	//   - Using the sObjects that exist in our org
	//   - We are getting the records that exist for our org
	
    public static void SOQL() {
        List<Account> myResults = [SELECT name, rating FROM Account LIMIT 5];
        Account my1Account = [SELECT name FROM Account LIMIT 1];
        System.debug(myResults[0].name);
        
        Set<String> namesToFilter = new Set<String>();
        
        // SOQL Clauses
        // - LIMIT : Limit how many records are returned
        //   - SELECT name, rating FROM Account LIMIT 5
        // - OFFSET : Changes where the records start from
        //   - Used together to perform pagination
        // - WHERE : Adds on a filter to your query
        //   - SELECT name FROM Account WHERE name = 'Edge Communications'
        //   - SELECT name FROM Account WHERE name LIKE '%a%a%'
        //   - SELECT name FROM Account WHERE name IN :namesToFilter
        //   - NOT, OR, AND (SELECT name FROM Account WHERE NOT name = 'Edge Communications')
        // - ORDER BY
        //   - Sets the order of records
        //   - ASC or DESC, NULLS FIRST or NULLS LAST
        //   - SELECT name, rating FROM Account ORDER BY rating DESC NULLS LAST
        //   
        // - WITH SECURITY ENFORCED
        //   - If you don't have access to something in the query, throws an error
        //   
        // - FIELDS()
        //   - ALL, STANDARD, CUSTOM
        //   - This will respect field level security
        //   - SELECT FIELDS(ALL) FROM Account
        //   
        // - FORMAT()
        //   - Format number, date, time, currency fields
        //   - SELECT FORMAT(annualRevenue) FROM Account
        //   
        // - FOR
        //   - VIEW : Update the Last Viewed Date field on the records
        //   - REFERENCE : Update the Last Referenced Date field on the records
        //   - UPDATE : Locks record from being updated by anyone except the locker until the transaction ends
        //   - SELECT name FROM Account FOR VIEW
    }
    
    public static void AggregateFunctions() {
        AggregateResult myResult = [SELECT COUNT(id) numAccounts FROM Account];
        System.debug(myResult.get('numAccounts'));
        
        // When you use an aggregate function, the return type now is AggregateResult
        // Still able to use .get()
        // Can give fields an alias to reference them by, otherwise the name of the fields is expr#, starting with 0
        // Aggregate Functions
        // - AVG(), COUNT(), MIN(), MAX(), SUM(), COUNT_DISTINCT()
        // - SELECT AVG(annualRevenue) FROM Account
        // - GROUP BY
        //   - SELECT rating, AVG(annualRevenue) FROM Account GROUP BY rating
        // - HAVING
        //   - Filters the GROUP BY Clause
        //   - SELECT rating, FORMAT(AVG(annualRevenue)) FROM Account GROUP BY rating HAVING NOT rating = null
    }
    
    public static void DateFunctions() {
        // Date Functions
        // - CALENDAR_YEAR(), CALENDAR_QUARTER(), DAY_IN_MONTH(), DAY_IN_WEEK(), DAY_IN_YEAR(), DAY_ONLY(), FISCAL_MONTH(), 
        //   FISCAL_QUARTER(), FISCAL_YEAR(), HOUR_IN_DAY(), WEEK_IN_MONTH(), WEEK_IN_YEAR()
        //   - SELECT DAY_IN_WEEK(CloseDate) FROM Opportunity GROUP BY DAY_IN_WEEK(CloseDate)
    }
    
    public static void RelationshipQueries() {
        List<Account> myResults = [SELECT name, (SELECT name FROM Contacts) FROM Account];
        for (Account currAccount : myResults) {
            List<Contact> associatedContacts = currAccount.contacts;
        }
        
        // Relationship Queries
        // - Parent to Child
        //   - Accounts -> Contacts
        //   - SELECT name, (SELECT name FROM Contacts) FROM Account
        // - Child to Parent
        //   - Contacts -> Accounts
        //   - SELECT name, Account.name FROM Contact
        //   
        // Relationship query and filtering query
        // - SELECT name, (SELECT name FROM Contacts) FROM Account WHERE id IN (SELECT accountID from Contact WHERE name LIKE 'a%')
    }
    
    public static void DML() {
        
        // Account myNewAccount = new Account(name = 'My Test Account', rating = 'Hot', annualRevenue = 150000000);
        // System.debug(myNewAccount.id);
        // Insert myNewAccount;
        // System.debug(myNewAccount.id);
        
        // Contact myNewContact = new Contact(lastName = 'New', accountID = myNewAccount.id);
        // Insert myNewContact;

        // List<Account> toDelete = [SELECT name FROM Account WHERE name = 'My Test Account'];
        // Delete toDelete;
         
        // Account toUpdate = [SELECT name, rating, active__c FROM Account WHERE name = 'My Test Account' LIMIT 1];
        // toUpdate.active__c = 'Yes';
        // Update toUpdate;
        
        // Data Manipulation Language
        // - This allows us to persist changes to the database
        // - Insert
        // - Update
        // - Delete
        // - Merge
        // - Upsert
         
        List<Contact> myContactList = new List<Contact>();
        myContactList.add(new Contact(lastName = 'Valid Contact'));
        myContactList.add(new Contact(firstName = 'Invalid Contact'));
        
        Database.Insert(myContactList, false);
        
        // Database methods allow the AllOrNothing parameter to me specified as false, allowing partial DML operations to be run
    }
    
    public static void GovernorLimits() {
        List<Contact> toInsert = new List<Contact>();
        for (Integer i = 0; i < 300; i++) {
            toInsert.add(new Contact(lastName = 'This will succeed!'));
        }
        Insert toInsert;
        
        // SOQL Queries also have govnernor limits
        // We should map together records that need to be accessed together
        
        List<Account> myAccounts = [SELECT name, (SELECT name FROM Contacts) FROM Account];
        Map<Account, List<Contact> > myMap = new Map<Account, List<Contact> >();
        Integer lastPosition = myAccounts.Size() - 1;
        
        for (Integer index = 0; index < myAccounts.Size(); index++) {
            myMap.put(myAccounts[index], myAccounts[lastPosition - index].Contacts);
        }
    }
    
    public static void TCL() {
        // Transaction Control Language
        // - Set Savepoints
        // - Rollback to savepoints
         
        Savepoint sp1 = Database.SetSavepoint();
        // perform some dml
        Savepoint sp2 = Database.SetSavepoint(); // Becomes invalid
        Database.Rollback(sp1);
        
        // Does not revert ID's
        // Discard any DML that occurs after the savepoint
        // If you rollback to a savepoint that occurs before another savepoint, that point is no longer valid
        // Rolling back to savepoint DOES NOT reset your governor limits
        // Setting a savepoint COUNTS AS A DML OPERATION
    }
}