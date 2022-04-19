/*
    Created by: Jared Longnecker
    Last Updated: 03/17/2022
    Description: Example REST service 
*/

// The urlMapping tells us what URL to go to get this resource
// This one is https://myOrg.my.salesforce.com/services/apexrest/learning/
@restResource(urlMapping='/learning/')
global class RESTService {
	
    // Instead of webservice, we use global and annotate with the corresponding HTTP method
    // @httpGet, @httpPut, @httpPatch, @httpDelete, @httpPost
    // Can use each 1 time
    @httpGet
    global static String Get50AccountNames() {
        List<Account> accounts = [SELECT name FROM Account LIMIT 50];
        String closer = accounts.Size() == 50 ? '' : '\nRan out of Accounts';
        
        String ret = '';
        for (Account a : accounts) {
            ret += a.name + ', ';
        }
        ret = ret.Substring(0, ret.Length() - 2);
        
        return ret + '.' + closer;
    }
}