// This processor class is going to take our SObjectProcessor and then get more specific and implement abstract methods
public class AccountProcessor extends SObjectProcessor {
    
    // Again we take advantage of constructor chaining to keep our logic in a single place
    public AccountProcessor() {
        this(null);
    }
    
    // Note the change of parameter: we now only accept a list of Accounts
    public AccountProcessor(List<Account> accountList) {
        super(accountList);
    }
    
    // We now give functionality to our ProcessList method so it is no longer abstract
    // Note the use of the override keyword
    override public void ProcessList() {
        
        // Note here all our method does is process the list. So all extra functionality should be moved
        // to another method
        for (SObject account : listToProcess) {
            ProcessRecord(account);
        }
    }
    
    // We seperate the processing of a single record out to a method for ease of reading
    override public void ProcessRecord(SObject record) {
        
        // We want to still leverage the parent functionality of incrementing the counter, so we can call super here
        super.ProcessRecord(record);
        
        // Now let's actually do our processing
        String processedName = record.get('Name') + ', process rank: ' + GetCounter();
        record.put('Name', processedName);
    }
    
    // Our other abstract method is to create an output, so we have to implement that functionality
    override public String CreateOutput() {
        String outputString = '';
        
        // We've allowed our unprocessed list to be public, so we must consider that it can be anything
        // Here, we ensure our loop doesn't go over the smaller sized list so our index doesn't go out of bounds
        Integer sizeLimit = Math.min(listToProcess.size(), unprocessedList.size());
        for (Integer index = 0; index < sizeLimit; index++) {
            
            // There's some complicated logic in creating an output line, so we pop that into another method
            outputString += CreateOutputLine(index);
            
            // This line is for formatting, it ensures each output line is on another line and doesn't end in a new line
            if (index + 1 < sizeLimit)
                outputString += '\n';
        }
        return outputString;
    }
    
    // Here, we define a private helper method to hold our logic to create a single line of output
    private String CreateOutputLine(Integer index) {
        
        // First, we retrieve the names of our two lists. Since the text to do so is very long, it's easier to read when we define
        // our own variables for these values
        String processedValue = (String)listToProcess[index].get('Name');
        String unprocessedValue;
        
        // It is possible that the unprocessed list does not hold Accounts, or even an sObject with a 'Name' field.
        // In this case, we would get an exception we need to handle
        try {
            unprocessedValue = (String)unprocessedList[index].get('Name');
        }
        catch(System.SObjectException noFieldException) {
            System.debug('sObject with no Name field provided in unprocessedList.');
            System.debug(noFieldException.getMessage());
            unprocessedValue = 'No Name Field';
        }
        catch(System.NullPointerException nullException) {
            
        }
        catch(System.Exception anyOtherException) {
            
        }
        finally {
            System.debug('Hello World!');
        }

        
        // Since we have done the logic to get the values we need, at the end we have a nicely readable return statement
        return 'Unprocessed value: ' + unprocessedValue + ', Processed value: ' + processedValue;
    }
    
    public class InnerException extends System.Exception {
        // Here we have defined our own custom exception using an inner class
        // Using an inner class is not required to have a custom exception
        // but it does often happen.
        // We can throw these custom exceptions if we want to
        // Here are some common methods exceptions have:
        // getLineNumber() - Returns line number that caused exception to fire
        // getMessage() - Returns the exception message the user can see
        // getStackTraceString() - Returns the stack trace of the exception as a string
        // setMessage() - Sets the exception message the user can see
    }
    
    // We can then throw our custom exception, and it can be caught and handled like any exception.
    public void OnlyOneProcessor() {
        if (numProcessors > 1)
        	throw new InnerException('A horrible exception has occurred, there are too many processors.');
        else {
            System.debug('There is, and can be, only one.');
        }
    }

	// Our final bit of polymorphism: overloading a method    
    public void OnlyOneProcessor(Integer num) {
        if (numProcessors > num)
            throw new InnerException('A horrible exception has occurred, there are too many processors.');
        else {
            System.debug('There is less than, and can only be ' + num);
        }
    }
}

/*
Execute Anonymous Code:
--------------------------------------------------------
List<sObject> sList = [SELECT name FROM Account];
SObjectProcessor sObj = new AccountProcessor(sList);
sObj.ProcessList();
System.debug(sObj.CreateOutput());

AccountProcessor accProcessor = (AccountProcessor)sObj;
accProcessor.OnlyOneProcessor();

accProcessor = new AccountProcessor(sList);

accProcessor.OnlyOneProcessor();
*/