public class BatchApex implements Database.Batchable<sObject>, Database.AllowsCallouts {
    // Use case for Batch Apex:
    // - Working with large amounts of records. Be this:
    //   - Lots of supplied records
    //   - Need to query for a large amount of records
    // An example would be performing database maintenance
    // 
    // You are only allowed 5 queued or active Batch jobs at a time
    // Batch Apex implements the Batchable interface, which must implement 3 methods:
    // - start
    // - execute
    // - finish
    
    private String field, value, query;
    private List<sObject> records;
    
    
    // We can accept an input for a query to process the batch over
    public BatchApex(String field, String value, String query) {
        this.field = field;
        this.value = value;
        this.query = query;
    }
    
    // We can use the Database.QueryLocator type if we want to query for the records we're working over
    public Database.QueryLocator Start(Database.BatchableContext context) {
        
        // The benefit here is we can work with up to 50 million records instead of 50 thousand
        return Database.GetQueryLocator(query);
    }
    
    /* -- USING ITERABLE -- 
	public BatchApex(String field, String value, List<sObject> records) {
		this.field = field;
		this.value = value;
		this.records = records;
	}

	// Use this version of Start in order to retrieve a collection or custom Iterable to work over
	public Iterable<sObject> Start(Database.BatchableContext context) {
		return records;
	}
	*/
    
    public void Execute(Database.BatchableContext context, List<sObject> records) {
        
        // Now we do whatever processing we want for the current batch
        for (sObject obj : records) {
            System.debug('The old value is: ' + obj.get(field));
            obj.put(field, value);
            System.debug('The new value is: ' + obj.get(field));
        }
        Update records;
    }
    
    // Finish will execute once the batch has been completed
    public void Finish(Database.BatchableContext context) {
            // This would be a good time to send an email alert or make a callout
            // Although we can just leave this empty
            // If we want to make a callout, we need to implement Database.AllowsCallouts
            // We cannot, however, call any @future methods
            // Additionally, we can choose to chain another batch using Database.executeBatch or System.scheduleBatch
    }
    
    public static id StartBatch() {
        
        // If unspecified, the scope parameter is 200. 
        // If Start() uses an iterable, there is no limit on how large this can be
        // If Start() uses Database.QueryLocator, our upper limit is 2,000
        return Database.ExecuteBatch(new BatchApex('lastName', 'BATCHED!', 'SELECT lastName FROM Contact'), 2000);
    }
    
    // We can also start the batch at a future time
    public static id StartBatchInMinutes(Integer delayInMinutes) {
        
        BatchApex newBatch = new BatchApex('lastName', 'SCHEDULED!', 'SELECT lastName FROM Contact');
        return System.ScheduleBatch(newBatch, 'Scheduled Batch', delayInMinutes, 2000);
    }
}