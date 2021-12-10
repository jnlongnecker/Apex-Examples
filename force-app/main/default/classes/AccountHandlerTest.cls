// In order to deploy Apex to your org or to put it in a package for the appExchange, your code coverage
// Must be at least 75% for any apex classes
// Must be at least 75% average overall code coverage
// This metric does not include test classes
// Triggers must have at least 1% code coverage

// All test methods begin with the @isTest annotation
// @isTest(SeeAllData=true) uses org data [bad practice]
// Test classes can be private, public or global
@isTest 
public class AccountHandlerTest {
    
    @testSetup
    public static void SetupTests() {
        
        // You can only have 1 @testSetup per class
        // Disabled if the class or any class methods have @isTest(SeeAllData=true)
        // Run once before all test methods and changes to the data is rolled back after the method completes
        // This makes them the most efficient way of creating and using test data
        
        // Here, we create our testing data
        List<Account> accountsToInsert = new List<Account>();
        for(Integer num = 0; num < 151; num++) {
            accountsToInsert.add(new Account(name = 'Test Account ' + num));
        }
        
        Insert accountsToInsert;
        
        // Remember, ID's do not exist until inserted into the database
        // Triggers will still fire on DML statements
    }
    
    // Test methods can be private, public, or global and must be static
    @isTest
    public static void TP_IsValid() {
        
        // We can test private methods using the @testVisible annotation
        // Where appropriate, we should test 5 conditions:
        // Test Positive
        // Test Negative
        // Test Single
        // Test Bulk
        // Test Restricted User
        
        // Test.startTest() gives us a new set of governor limits for the test
        // 1 allowed per test method
        Test.startTest();
        
        // We should test our method robustly, and can use multiple System.assert statements
        Account testAcc = TestHelper.CreateAccounts(1)[0];
        Boolean result = AccountHandler.IsValid(testAcc);
        
        // System.assertEquals() - Value one: expected, Value 2: actual
        System.assertEquals(true, result);
        
        testAcc.name = 'Acc 6';
        result = AccountHandler.IsValid(testAcc);
        
        System.assertEquals(true, result);
        
        testAcc.name = 'Acc 3';
        result = AccountHandler.IsValid(testAcc);

        
        System.assertEquals(false, result);
        
        // Other System.assert methods:
        // System.assert( conditional )
        // System.assertNotEquals( expected, actual )
        
        // Test.stopTest() returns us to our original set of governor limits
        // All asynchronous code after Test.startTest() gets ran now, but synchronously
        // 1 allowed per test method
        Test.stopTest();
    }
    
    @isTest
    public static void TP_ValidateAccounts() {
        Test.startTest();
        
        // Testing with good data means we should get a good output
        List<Account> someAccounts = TestHelper.CreateAccounts(16);
        AccountHandler.ValidateAccounts(someAccounts);
        
        Integer numValid = 0;
        for(Account currAccount : someAccounts) {
            if (currAccount.name.Contains('was selected!')) {
                numValid++;
            }
        }
        
        System.assertEquals(3, numValid);
        
        Test.stopTest();
    }
    
    @isTest
    public static void TN_ValidateAccounts() {
        
        // Not only are we testing with bad data, but we are also testing in bulk as we created 151 accounts
        List<Account> someAccounts = [SELECT name FROM Account];
        Test.startTest();

        AccountHandler.ValidateAccounts(someAccounts);
        
        Integer numValid = 0;
        for(Account currAccount : someAccounts) {
            if (currAccount.name.Contains('was selected!')) {
                numValid++;
            }
        }
        
        System.assertEquals(0, numValid);
        
        Test.stopTest();
    }
    
    @isTest
    public static void TS_ValidateAccounts() {
        Test.startTest();
        
        // Test single here to make sure the code works for a single account
        List<Account> someAccounts = TestHelper.CreateAccounts(1);
        AccountHandler.ValidateAccounts(someAccounts);
        
        Integer numValid = 0;
        for(Account currAccount : someAccounts) {
            if (currAccount.name.Contains('was selected!')) {
                numValid++;
            }
        }
        
        System.assertEquals(1, numValid);
        
        Test.stopTest();
    }
    
    @isTest
    public static void TRU_ValidateAccounts() {
        User admin = [SELECT name FROM User WHERE Profile.name = 'System Administrator' LIMIT 1];
        List<Account> someAccounts = TestHelper.CreateAccounts(16);
        
        Test.startTest();
        
        // Runs code as a specified user with that user's permissions
        System.runAs(admin) {
            AccountHandler.ValidateAccounts(someAccounts);
            
            Integer numValid = 0;
            for(Account currAccount : someAccounts) {
                if (currAccount.name.Contains('was selected!')) {
                    numValid++;
                }
            }
            
            System.assertEquals(3, numValid);
        }
        
        Test.stopTest();
    }
}