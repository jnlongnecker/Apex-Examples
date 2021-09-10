public with sharing class DemoExtension {

    public Account myAccount {get; set;}
    
    transient public String primValue {
        get{
            if (primValue == null) 
                primValue = 'Default Value'; 
            return primValue;
        } set;}
    
    public List<Wrap> wrappedContacts {get; set;}
    
    transient private List<String> randomValues = null;
    private String currentSelection = 'No Selection Yet';
    transient public Integer value {get; set;}
    
    public DemoExtension(ApexPages.StandardController sController) {
        PageReference currPage = ApexPages.currentPage();
        if (currPage.getParameters().get('id') == null) {
            try {
                myAccount = [SELECT (SELECT name, lastName, firstName FROM Contacts), name, annualRevenue, type, accountNumber 
                             FROM Account LIMIT 1 OFFSET 4];
            }
            catch(System.QueryException e) {
                myAccount = new Account(name = 'Demo Account', annualRevenue = 12543265, type = 'Customer - Direct', accountNumber = '1');
            }
        }
        else {
            myAccount = (Account)sController.getRecord();
        }
        
        primValue = null;
        wrappedContacts = new List<Wrap>();
        Integer index = 0;
        for (Contact c : myAccount.Contacts) {
            wrappedContacts.add(new Wrap(++index, c));
        }
    }
    
    public String getComboValue() {
        return myAccount.name + '\'s account number is: ' + myAccount.AccountNumber;
    }
    
    public String getGuitarist() {
        return 'My current guitarist is: ' + currentSelection;
    }
    
    public String getRandomGuitarist() {
        return 'A random guitarist is: ' + SelectRandomGuitarist();
    }
    
    public Component.Apex.OutputText getDynamic() {
        Component.Apex.OutputText output = new Component.Apex.OutputText();
        if (value > 10) {
            output.value = 'Input value is greater than 10!';
        }
        else {
            output.value = 'Input value is less than or equal to 10!';
        }
        return output;
    }
    
    public void CustomAction() {
        currentSelection = SelectRandomGuitarist();
    }
    
    private String SelectRandomGuitarist() {
        if (randomValues == null) {
            randomValues = new List<String>{'John Petrucci', 'Tim Henson', 'Tosin Abasi', 'Steve Vai', 'Stevie Ray Vaughn', 'B.B. King', 'Jimi Hendrix', 'Jeff Loomis'};
                }
        return randomValues[Integer.valueOf(Math.random() * randomValues.size())];
    }

    private class Wrap {
        public Integer contactNumber {get; set;}
        public Contact wrappedContact {get; set;}
        
        public Wrap(Integer num, Contact c) {
            contactNumber = num;
            wrappedContact = c;
        }
    }
}