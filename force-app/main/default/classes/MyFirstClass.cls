// Your classes that you write should contain a header comment
/*
    Created by: Jared Longnecker
    Last Updated: 12/7/2021
    Description: Introductory Apex topics
*/

/*
    What is Apex? Apex is a cloud-hosted, strongly typed, object-oriented programming language proprietary to Salesforce. It is specifically crafted to work
    optimally with the Salesforce platform and seemlessly integrate with the database. Apex is not case sensitive, and has a testing framework built into
    the platform.
*/

// Naming convention of classes is CamelCase, also referred to as PascalCase or UpperCamelNotation
public class MyFirstClass {
    
    // Strings are a sequence of characters. We can use \ to escape a character
    public String stringContainer = '\'\\Dun$_1geon';

    // Integers are whole numbers, positive or negative
    public Integer num = 3;

    // Booleans hold true/false values. Be sure to give your booleans good names, as logic can be very complex
    public Boolean myValue = !(true || false) == (false && true);
    public Boolean isValid = num < 18 && num != 4;
    public Boolean isPositive = num > 0;
    public Boolean totalCondition = isValid && isPositive;
    
    // Objects/sObjects
    public Account myAccount = new Account();
    public Floor__c myFloor;
    
    // Lists are an ordered sequence of values
    public List<String> myStringList = new List<String>{'Element 1', 'Element 2'};

    // Sets are an unordered collection of non-repeating values
    public Set<Integer> myIntegerSet = new Set<Integer>();

    // Maps are a collection of key-value pairs
    public Map<String, Integer > myStringMap = new Map<String, Integer>();
    
    // Enums are used to represent static choices
    public enum Season { SUMMER, FALL, WINTER, SPRING }
    public Season mySeason = Season.FALL;
    
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
    // - Blob (Binary Large Object)
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

    // An initialization block runs before the constructor. This is typically only used in special cases, such as when you must run logic prior to the constructor
    {
        System.debug('Before the constructor!');
    }
    
    // A method with no return type and the same name as the class is called the Constructor, and runs whenever an object is created from the class
    public MyFirstClass() {

        // We can set field values via Apex
        System.debug(stringContainer);
        myAccount.name = 'This is an Account name';
        
        // We access list items through [] notation, and can use list.add() to add new items to the list
        myStringList.add('Some String');
        System.debug(myStringList[0]);
        
        // Maps use the .put() method to insert key-value pairs, and the .get() method to retrieve a value at a key
        myStringMap.put('Key 1', 100);
        System.debug(myStringMap.get('Key 1'));
        
        Season fall = Season.FALL;
        System.debug(Season.FALL);
    }
    
    // Methods have an access modifier, return type, and signature comprised of the name and parameter list
    public void ChangeNumToSpecifiedValue(Integer otherNum) {

        // Within the curly braces, we have the method body
        num = otherNum;
    }
    
    public void PrintNum() {
        
        // When we pass a value into a method, that value is called an argument
        System.debug(num);
    }
    
    public void PrintInputIfSpecial(Integer input) {

        // Conditional statements should be very simple
        Boolean isSpecial = Math.mod(input, 2) == 0;
        Boolean kindaSpecial = input < 50;

        // Here, we use a variable to describe the intention of the conditional statement        
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
        
        // We can use a switch-case to simplify complex if/else chains
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
        // while loops run while a conditional is true
        // do while loops run once and continue to run while a conditional is true
        // for loops run over a range and increment
        Integer count = 0;
        while (count < input) {

            // There are many ways to increment
            count = count + 1;
            //count += 1;
            //count++;
            
            System.debug('The current count is: ' + count);
        }
        
        do {
            System.debug('The current count is: ' + count);
        }
        while (count < input);
        
        for (Integer index = 0; index < input; index++) {
            System.debug('The current count is: ' + index);
        }
        
        // A common way of iterating over a collection is iterating from 0 to .size()
        for (Integer index = 0; index < myStringList.size(); index++) {
            if (Math.mod(index, 2) == 0) {
                continue;
            }
            System.debug(myStringList[index]);
            
        }
        
        // Additionally, we can use the enhanced for loop to loop over a list or set
        for (String currentString : myStringList) {
            if (currentString == 'Element 2') {
                System.debug(currentString);
                break;
            }
        }
        
    }
}

/*
    For your reference, the operators and their precedence:
        == Precedence Group 1 == 
        --x (Prefix decrement)
        ++x (Prefix increment)
        {} (Grouping)
        () (Grouping)

        == Precedence Group 2 == 
        new (Object instantiation)
        (type) (type cast)
        - (Unary negation)
        ! (Logical complement)
        
        == Precedence Group 3 == 
        / (Division)
        * (Multiplication)

        == Precedence Group 4 == 
        + (Addition)
        - (Subtraction)
        
        == Precedence Group 5 == 
        instanceof (Polymorphic type comparison)
        <= (less than or equal)
        >= (greater than or equal)
        < (less than)
        > (greater than)
        
        == Precedence Group 6 == 
        == (equality)
        != (inequality)
        
        == Precedence Group 7 == 
        || (Logical OR) 
        
        == Precedence Group 8 == 
        && (Logical AND)

        == Precedence Group 9 == 
        = (assignment)
        += (addition assignment)
        -= (subtraction assignment)
        *= (multiplication assignment)
        /= (division assignment)
        &= (and assignment)
        |= (Or assignment)

  







*/