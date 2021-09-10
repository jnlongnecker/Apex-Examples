public class APICallout {
	
    // Making requests is much more straightforward with REST API's
    public static void QueryPokemon(String pokemonName) {
        
        pokemonName.toLowerCase();
        
        // Create the HTTP class, which sends the request
        HTTP http = new HTTP();
        
        // Build the request, similar to the ajaxRequest.open() method
        HttpRequest hRequest = new HttpRequest();
        hRequest.setEndpoint('https://pokeapi.co/api/v2/pokemon/' + pokemonName);
        hRequest.setMethod('GET');
        
        // Send the request and store the response
        HttpResponse response = http.send(hRequest);
        
        // Still gotta check that status code
        if (response.getStatusCode() != 200) return;
        
        // Parse JSON
        JSONParser parser = JSON.createParser(response.getBody());
        
        // Parsing JSON is heavily dependent on the response you get
        // Be aware REST can also return XML
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