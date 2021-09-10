public class FutureApex {
	// Use case for a @future method:
	// - Long running method that you want to avoid delaying the transaction
	// - External callouts
	// - Bypass the mixed save DML error (such as trying to insert a user with a non-null role)
	
    @future
    public static void FutureSkeleton() {
        
        // From here, code is executed synchronously
        // We can perform any functionality we so choose
    }
    
    @future
    public static void RecordsAndFuture(List<id> recordsToWorkWith) {
        
        // Records can't be passed in to @future methods. This is because the values could have changed by the time the method runs
        // Instead, pass in the ID's to get the most updated versions
        
        // Assuming we're working with Contacts:
        List<Contact> updatedContacts = [SELECT name FROM Contact WHERE id IN : recordsToWorkWith];
        
        // By the time we're executing this code, our governor limits have reset
        // Certain governor limits are also larger in asynchronous code
    }
    
    @future(callout=true)
    public static void FutureAndCallouts() {
        
        // Like with an AJAX request in JS, we can also make callouts via Apex, although there are more steps to the process
        // If we don't want to wait, we make the callout in a method marked @future(callout=true), but we could wait
        // We'll be learning how to actually make a callout later on, so we'll come back to the following syntax:
        HTTP http = new HTTP();
        HttpRequest hRequest = new HttpRequest();
        hRequest.setEndpoint('https://pokeapi.co/api/v2/pokemon/nidoking');
        hRequest.setMethod('GET');
        
        HttpResponse response = http.send(hRequest);
        
        // Parse JSON
        JSONParser parser = JSON.createParser(response.getBody());
        
        String pkmName = '';
        while (parser.NextToken() != null) {
            
            // Pick through response tokens
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                switch on parser.getText() {
                    when 'ability' {
                        parser.NextValue();
                        parser.NextValue();
                        System.debug('Ability: ' + parser.getText());
                    }
                    when 'base_experience' {
                        parser.NextValue();
                        System.debug('Base Exp Yield: ' + parser.getText());
                    }
                    when 'species' {
                        parser.NextValue();
                        parser.NextValue();
                        pkmName = parser.getText();
                        System.debug('Pokemon Name: ' + pkmName);
                    }
                    when 'type' {
                        parser.NextValue();
                        parser.NextValue();
                        System.debug('Type: ' + parser.getText());
                    }
                }
            }
        }
    }
}