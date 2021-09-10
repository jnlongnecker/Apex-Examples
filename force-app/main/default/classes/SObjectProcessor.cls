// Global - Means that the data can be accessed in any namespace
// Public - Mean that the data can only be accessed within the same namespace
// Protected - Means that only the parent and child classes can access the data
// Private - Means that only the owning class can access the data

// We have our base class as abstract as it will be extended and contains an abstract method
public abstract class SObjectProcessor {
    
    // We would like to make sure this value only gets incremented when a certain method is called, 
    // so we make this a private instance variable
    private Integer internalCounter = 0;
    
    // We set this list to protected so that our child classes can access it
    protected List<sObject> listToProcess {get; 
    set {
        
        // We override the standard set method to the property to do data validation
        if (value == null) {
            listToProcess = new List<sObject>();
            return;
        }

        // We can do a deep copy of a list to change values in one list without affecting the other
        listToProcess = new List<sObject>();
        for (sObject obj : value) {
            
            // The first boolean in clone() is whether to copy ID's, the second is whether to do a deep copy
            listToProcess.add(obj.clone(true, true));
        }
    } }
    
    // This unprocessed list we will allow anyone to manipulate how they wish, so it's public.
    public List<sObject> unprocessedList {get; set;}
    
    // Let's say we want to track how many processors we make. We can use an initialization block and a static variable
    // to do so
    public static Integer numProcessors = 0;
    
    {
        numProcessors++;
    }
    
    // We can perform constructor chaining using the this() keyword
    public SObjectProcessor() {
        this(null);
    }
    
    public SObjectProcessor(List<sObject> objectList) {
        
        // Constructor chaining allows us to have a single place to perform our setup
        listToProcess = objectList;
        unprocessedList = objectList;
    }
    
    // By default, classes and methods are final. This method cannot be overridden
    protected Integer GetCounter() {
        return internalCounter;
    }
    
    // Using the virtual keyword allows a method to be overridden
    public virtual void ProcessRecord(SObject record) {
        internalCounter++;
    }
    
    // An abstract method is one with no body
    public abstract String CreateOutput();
    
    // We can use these to create the implementation at a later point in the child classes
    public abstract void ProcessList();
}