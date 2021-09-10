public class SOSLExtension {
    
    private List<List<SObject>> queryResult;
    
    public SOSLExtension(ApexPages.StandardSetController sController) {
        queryResult = [FIND '*0*0*' IN Phone FIELDS RETURNING Account(name, FORMAT(SLAExpirationDate__c)), 
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
		 * 

         */
    }
    
    public List<Account> getAccounts() {
        return queryResult[0];
    }
    
    public List<Contact> getContacts() {
        return queryResult[1];
    }
}