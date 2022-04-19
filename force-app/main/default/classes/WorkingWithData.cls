/*
    Created by: Jared Longnecker
    Last Updated: 03/17/2022
    Description: Information about working with DML, TCL, SOQL and SOSL
*/

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
        //   - If you don't have access to something in the query, throws an exception
        //   
        // - FIELDS()
        //   - ALL, STANDARD, CUSTOM
        //   - This will respect field level security
        //   - Only FIELDS(STANDARD) is supported from Apex
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
        //   - SELECT name, (SELECT name FROM Contacts) FROM Account LIMIT 5
        // - Child to Parent
        //   - Contacts -> Accounts
        //   - SELECT name, Account.name FROM Contact
        //   
        // Relationship query and filtering query
        // - SELECT name, (SELECT name FROM Contacts) FROM Account WHERE id IN (SELECT accountID from Contact WHERE name LIKE 'a%')
    }

    public static void SOQLFor() {
        /*
            A slightly more advanced concept of SOQL is the SOQL for loop. This looks like an enhanced for loop
            that includes a SOQL query inside of it instead of a particular list. What this is going to do is
            efficiently query the org for records, and is thus the best way of working with a large amount of records.
            Records take up a lot of space on the heap, and in order to stay within our memory limitations, whenever
            possible use a SOQL for loop. Also because of this efficiency, a SOQL for loop can actually retrieve
            more than 2,000 records. When it does this, an error will occur if you use an Aggregate Function on such
            a query since they cannot handle that many records.
        */
        for (Account currAccount : [SELECT name, (SELECT name FROM Contacts) FROM Account]) {
            List<Contact> associatedContacts = currAccount.contacts;
        }

        /*
            While the single sObject SOQL for loop above will loop for every single record, the one below is going
            to retrieve 200 records at a time and store them in the acc200 list. While not a best practice to do so,
            if you absolutely must use DML inside of a loop this approach is the best in order to stay under
            governor limits.
        */
        for (List<Account> acc200 : [SELECT name, (SELECT name FROM Contacts) FROM Account]) {
            for (Account currAccount : acc200) {

                // If currAccount.contacts is really big (over 200 contacts) this can cause an error
                List<Contact> associatedContacts = currAccount.contacts;
            }
        }
    }

    
    public void SOSL() {
        List<List<SObject>> queryResult = [FIND '*0*0*' IN Phone FIELDS RETURNING Account(name, FORMAT(SLAExpirationDate__c)), 
                       Contact(firstName, lastName, accountID ORDER BY lastName)];
        /*
         * SOSL Information:
         * FIND 'search query': This is what you're looking for. A field you search for has to start with this query
		 * IN {fields}: This is what fields you will be searching. This can be Name, Email, Phone or All. 
		 * Default is All, which searches indexed Text, Text Area, or Text Area (Rich) fields as well
		 * RETURNING: This is where you filter what you want to return. This is optional, but differs by object you want to return
		 * WITH: This is an optional clause that can include or filter by many things, including:
		 * 		DATA CATEGORY category: A filter for knowledge article data category
		 * 		v-- NOT SUPPORTED IN APEX --v
		 * 		HIGHLIGHT: Highlights the fields that match the search critera
		 * 		METADATA meta: Returns the specified metadata alongside the query.
		 * 		PricebookID: Filters by the pricebook id specified 
		 * 		
		 * 
		 * There are more clauses to filter by, here are a few:
		 * WHERE: Works like in SOQL, only returns records where a condition is met
		 * LIMIT/OFFSET: Works like in SOQL, limits the records returned and offsets the start position
		 * ORDER BY: Works like in SOQL, reorders the records by a field
		 * USING: Filter records with a premade list view, like Recently Viewed or My Contacts
         */

         List<Account> myAccountList = queryResult[0];
         List<Contact> myContactList = queryResult[1];
        
         System.debug('Items returned from Account query: ' + queryResult[0].size());
         System.debug('Items reutrned from Contact query: ' + queryResult[1].size());
    }

    /*
        When to use SOQL
            You know which object, fields you want to retrieve
            You want to get a count of the number of records that meet a specific criteria. i.e. where OwnerId = X
            You want to sort the results as part of the query
            You want to get data from number, checkbox or date fields
            You want to get data from a single object or multiple objects that are related to each other (i.e. Accounts and Contacts)

        When to use SOSL
            You don't specifically know which object or field the data resides in but you need an efficient way to find the records
            You want to get data from multiple objects and field in the most efficient way - the objects may or may not be related to one another.
            You are trying to query data in fields that cannot be indexed yet you have a large data set

        Most circumstances will have you use SOQL
    */
    
    public static void DML() {
        
        Account myNewAccount = new Account(name = 'My Test Account', rating = 'Hot', annualRevenue = 150000000);
        System.debug(myNewAccount.id);
        Insert myNewAccount;
        System.debug(myNewAccount.id);
        
        Contact myNewContact = new Contact(lastName = 'New', accountID = myNewAccount.id);
        Insert myNewContact;

        List<Account> toDelete = [SELECT name FROM Account WHERE name = 'My Test Account'];
        Delete toDelete;

        Insert myNewAccount;
         
        Account toUpdate = [SELECT name, rating FROM Account WHERE name = 'My Test Account' LIMIT 1];
        toUpdate.rating = 'Cold';
        Update toUpdate;
        
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
        
        // SOSL and SOQL Queries also have governor limits
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
        // Discards any DML that occurs after the savepoint
        // If you rollback to a savepoint that occurs before another savepoint, that point is no longer valid
        // Rolling back to savepoint DOES NOT reset your governor limits
        // Setting a savepoint COUNTS AS A DML OPERATION
    }
}