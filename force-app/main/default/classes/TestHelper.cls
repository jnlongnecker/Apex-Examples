@isTest
public class TestHelper {
    
    // We can outsource our data creation to a Utility method
    // This allows us to do different setup for different methods
    public static void InsertAccounts(Integer numAccounts) {
        List<Account> toInsert = new List<Account>();
        
        for(Integer num = 0; num < numAccounts; num++) {
            toInsert.add(new Account(name = 'Test Account ' + num));
        }
        
        Insert toInsert;
    }
    
    // This also enables us to create data without having to insert it
    public static List<Account> CreateAccounts(Integer numAccounts) {
        List<Account> toReturn = new List<Account>();
        
        for(Integer num = 0; num < numAccounts; num++) {
            toReturn.add(new Account(name = 'Acc ' + num));
        }
        
        return toReturn;
    }
}