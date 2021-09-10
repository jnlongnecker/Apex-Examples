public class AdvancedApex {
    
    public static Savepoint revert;
    
    // We're going to be playing around with our database, so let's set a savepoint so we can roll back at the end
    static {
        revert = Database.setSavepoint();
    }
	
    // --- System Namespace Classes ---
    // The System namespace has many, many useful classes for us to use
    // We've been using them all along, but let's take a deeper look at a few
    
    // -- Limits --
    public static void LimitsInAction() {
        // The Limits class gives us information about our governor limits
        Contact sampleContact = new Contact(lastName = 'Test');   
        
        Insert sampleContact;
        
        // Limits.getDmlStatements() will tell us how many DML statements we've used in the current transaction
        // Remember, setting a savepoint counts as a DML operation
        System.debug('DML Statements at Line 23: ' + Limits.getDmlStatements());
        
        // Limits.getLimitDmlStatements() will tell us what our governor limits for DML are
        System.debug('DML Limit: ' + Limits.getLimitDmlStatements());
        
        // These can be used in conjunction to ensure we don't go over our governor limits
        for (Integer i = 0; i < 20000; i++) {
            Contact inLoop = new Contact(lastName = 'In Loop ' + i);
            if (Limits.getDmlStatements() >= Limits.getLimitDmlStatements() - 50) {
                break;
            }
            Insert inLoop;
        }
        
        System.debug('DML Statements at Line 37: ' + Limits.getDmlStatements());
        
        // Limits exist for all governor limits, so we can dynamically handle our limits
        
        // For example, if we need to work with a large number of records from a query, we could limit our results
        // so we don't throw any exceptions
        Integer rowLimit = Limits.getLimitQueryRows() - Limits.getQueryRows();
        List<Lead> leadList = [SELECT id FROM Lead LIMIT : rowLimit];
        
        // We can also see how many SOQL queries we've issued
        System.debug('Queries Issued: ' + Limits.getQueries());
        
        // Limits.getSoslQueries() is the SOSL equivalent
		
		Database.rollback(revert);        
    }
    
    // -- Database --
    public static void DynamicQuery(String query) {
        // The main feature of the Database class that we'll look at today is Database.Query();
        
        // By using this method, we can dynamically construct a query from a string
        List<sObject> dirtyQueryResult = Database.Query(query);
        
        // If we do so, this could result in SOQL injection
        // We should use the String.EscapeSingleQuotes() method to defend against this
        List<sObject> cleanQueryResult = Database.Query(String.EscapeSingleQuotes(query));
        
        // This is only a concern with user input strings
        
        // We can also perform dynamic SOSL, although this is handled using the Search class:
        String soslString = 'FIND \'Edge\' IN All FIELDS RETURNING Account(name)';
        List<List<sObject>> soslResult = Search.Query(soslString);
        
        System.debug(soslResult[0][0].get('name'));
    }
    
    // -- Schema -- 
    public static void SchemaDescribe(sObject anyObject) {
        // Using the Schema class, we can discover a lot of useful information about an sObject
        // Anything we need to know, we retrieve through the Schema class
        
        // Once we have the describe result, we can use this to get information about the sObject
        Schema.DescribeSObjectResult describe = anyObject.GetSObjectType().GetDescribe();
        
        // If we know ahead of time the sObject we want the describe of, we can use its class to retrieve that
        // Or we can use the Schema class
        Schema.DescribeSObjectResult d1 = Account.sObjectType.GetDescribe();
        Schema.DescribeSObjectResult d2 = Schema.sObjectType.Account;
        
        System.debug('The human-readable name of your sObject is: ' + describe.GetLabel());
        System.debug('The API name of your sObject is: ' + describe.GetName());
        
        // We can also retrieve record type information about the sObject
        Map<String, Schema.RecordTypeInfo> rtInfo = describe.GetRecordTypeInfosByName();
        if (rtInfo.Values().Size() > 1) {
            String allNames = '';
            for (String key : rtInfo.KeySet()) {
                allNames += key + ', ';
            }
            allNames = allNames.substring(0, allNames.Length() - 2);
            System.debug('Your sObject has these record types: ' + allNames);
        }
        else {
            System.debug('Your sObject has no record types.');
        }
        
        // Finally, we can also retrieve information about any of the fields
        Map<String, Schema.sObjectField> fields = describe.fields.GetMap();
        
        System.debug('Here are all the fields for your sObject:');
        for (Schema.sObjectField field : fields.Values()) {
            
            // Now instead of describing the sObject, we must describe the field itself
            Schema.DescribeFieldResult fieldInfo = field.GetDescribe();
            
            // From here, we can find out anything we want about the field
            // I think you get the idea, we'll keep it simple and just get the labels and data types
            System.debug(fieldInfo.GetLabel() + ' (' + fieldInfo.GetType() + ')');
        }
        
        // Finally, we can also retrieve picklist values of a field
        List<Schema.PicklistEntry> ratings = Schema.sObjectType.Account.fields.rating.GetPicklistValues();
        
        System.debug('Here are the picklist entries for the "Rating" picklist of Account:');
        for (Schema.PicklistEntry entry : ratings) {
            System.debug(entry.GetValue());
        }
    }
    
    // Some honorable mentions:
    // - System   : Yes, there is a System class in the System namespace, and we've been using it
    // 			    Contains features to manipulate the org, system time, debug, etc
    // - UserInfo : Contains information about the current context user
}