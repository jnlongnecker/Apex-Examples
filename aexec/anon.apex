// If you're interested in an easy setup for anonymous apex logging in VS Code, set up a folder like this and run the following command to run your code:
// sfdx force:apex:execute -f anonymous/anon.apex | Select-String -Pattern '(USER_DEBUG)|(error)' > anonymous/log.txt
// All of your anonymous apex code should be placed within the apex file, like below

System.debug('Running!');