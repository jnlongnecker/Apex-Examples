/* * * * * * * * * * * * * * *
 * Created by Jared Longnecker
 * Updated 3/17/2022
 * * * * * * * * * * * * * * */

public class MyFirstClass {
    
    // Primitives
    public String stringContainer = '\'\\Dun$_1geon';
    public Integer num = 3;
    public Boolean myValue = !(true || false) == (false && true);
    public Boolean isValid = num < 18 && num != 4;
    public Boolean isPositive = num > 0;
    public Boolean totalCondition = isValid && isPositive;
    
    // Objects/sObjects
    public Account myAccount = new Account();
    public Floor__c myFloor;
    
    // Collections
    public List<String> myStringList = new List<String>{'Element 1', 'Element 2'};
        public Set<Integer> myIntegerSet = new Set<Integer>();
    public Map<String, Integer > myStringMap = new Map<String, Integer >();
    
    // Enum
    public enum Season { SUMMER, FALL, WINTER, SPRING }
    
    // PRIMITIVE DATA TYPES
    // - String
    // - Boolean
    // - Integer
    // - Long
    // - Decimal
    // - Double
    // - Date
    // - Datetime
    // - Time
    // - Blob
    // - ID 
    
    // Object and sObjects
    // - Account
    // - Contact
    // - Case
    // - Order
    // - Custom Objects
    
    // Collections
    // - List
    // - Set
    // - Map
    
    // Enums
    
    public MyFirstClass() {
        System.debug(stringContainer);
        myAccount.name = 'This is an Account name';
        
        myStringList.add('Some String');
        System.debug(myStringList[0]);
        
        myStringMap.put('Key 1', 100);
        System.debug(myStringMap.get('Key 1'));
        
        Season fall = Season.FALL;
        System.debug(Season.FALL);
    }
    
    public void ChangeNumToSpecifiedValue(Integer otherNum) {
        num = otherNum;
    }
    
    public void PrintNum() {
        System.debug(num);
    }
    
    public void PrintInputIfSpecial(Integer input) {
        Boolean isSpecial = Math.mod(input, 2) == 0;
        Boolean kindaSpecial = input < 50;
        
        if (isSpecial) {
            // Execute some code
            System.debug('This number, ' + input + ', is special!');
        }
        else if (kindaSpecial) {
            System.debug('This number, ' + input + ', is kinda special.');
        }
        else {
            System.debug('This number is not special at all!');
        }
    }
    
    public void PrintIfInputMatchesSpecificNumbers(Integer input) {
        // 50, 42, 17, 8, 1, 36, 25
        
        switch on input {
            when 50, 42, 17 {
                System.debug(input);
            }
            when 8, 1, 36, 25 {
                // do something else
                System.debug('This number was kinda different: ' + input);
            }
            when else {
                System.debug('There was no matches!');
            }
        }
    }
    
    public void FunWithLoops(Integer input) {
        // while
        // do while
        // for
        Integer count = 0;
        while (count < input) {
            count = count + 1;
            //count += 1;
            //count++;
            
            System.debug('The current count is: ' + count);
            
            //count = count + 1;
        }
        
        do {
            System.debug('The current count is: ' + count);
        }
        while (count < input);
        
        for (Integer index = 0; index < input; index++) {
            System.debug('The current count is: ' + index);
        }
        
        for (Integer index = 0; index < myStringList.Size(); index++) {
            if (Math.mod(index, 2) == 0) {
                continue;
            }
            System.debug(myStringList[index]);
            
        }
        
        for (String currentString : myStringList) {
            if (currentString == 'Element 2') {
                System.debug(currentString);
                break;
            }
        }
        
    }
}