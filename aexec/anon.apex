// If you're interested in an easy setup for anonymous apex logging in VS Code, set up a folder like this and run the following command to run your code:
// sfdx force:apex:execute -f anonymous/anon.apex | Select-String -Pattern '(USER_DEBUG)|(error)' > anonymous/log.txt
// All of your anonymous apex code should be placed within the apex file, like below

List<sObject> sList = [SELECT name FROM Account];
SObjectProcessor sObj = new AccountProcessor(sList);
sObj.ProcessList();
System.debug(sObj.CreateOutput());

AccountProcessor accProcessor = (AccountProcessor)sObj;
accProcessor.OnlyOneProcessor();

accProcessor.StringifyMe();

accProcessor = new AccountProcessor(sList);

accProcessor.OnlyOneProcessor(2);