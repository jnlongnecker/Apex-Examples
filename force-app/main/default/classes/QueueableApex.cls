public class QueueableApex implements Queueable {
	// Use cases for Queuable Apex:
	// - To start code that will run for a long time
	// - To pass a complex type to a job
	// - To chain multiple jobs together, one after another
	
    // Queuable is similar to @future, but has some additional benefits:
    // - The System.enqueueJob() method returns an ID and can be monitored or queried for
    // - You can pass non-primitive types as a parameter
    // - You can run another job from a job, a feature you cannot do in @future methods
    // The first step already occured: implement the Queueable interface
    // Then, we need to implement 1 method: execute
    
    private Account myAccount;
    
    // If we want to pass in a complex parameter, we do so via the constructor
    public QueueableApex(Account parameter) {
        myAccount = parameter;
    }
    
    public void Execute(QueueableContext context) {
        // This is where we would perform our enqueued code
        FutureApex.FutureAndCallouts();
        System.debug(myAccount.name);
        
        // Additionally, if we wanted to enqueue another job, we could call that
        // System.enqueueJob(new QueueableApex(myAccount));
        // I've commented this out as this will recursively enqueue this method up to 50 jobs, which is the limit per transaction
        // Additionally, a job can only enqueue a single child job
    }
    
    // To enqueue a job, use the System.enqueueJob() method, passing in the Queueable class
    public static void EnqueueThis() {
        Account sampleAccount = new Account(name = 'Old Value');
        
        // This adds the class to the job queue, and will run the Execute method when reached
        System.enqueueJob(new QueueableApex(sampleAccount));
        
        sampleAccount.name = 'New Value';
    }
}