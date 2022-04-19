/*
    Created by: Jared Longnecker
    Last Updated: 03/17/2022
    Description: Example SOAP service 
*/

// A SOAP webservice must be global
global class SOAPService {
	
    // Variables can be exposed too, but these are not static
    webservice Integer someNum = 50;
    
    // Exposed methods must be static with webservice in place of the access modifier
    webservice static String Get50AccountNames() {
        List<Account> accounts = [SELECT name FROM Account LIMIT 50];
        String closer = accounts.Size() == 50 ? '' : '\nRan out of Accounts';
        
        String ret = '';
        for (Account a : accounts) {
            ret += a.name + ', ';
        }
        ret = ret.Substring(0, ret.Length() - 2);
        
        return ret + '.' + closer;
    }
    
    // From here, we test these methods just like any other
    // We'll also need to generate our own WSDL in the Apex Classes tab for our clients
}