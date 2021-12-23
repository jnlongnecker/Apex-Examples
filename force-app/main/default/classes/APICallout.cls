public class APICallout {
    /*
        REST stands for REpresentational State Transfer and make use of HTTP methods to be interacted
        with. This means we MUST write and consume REST API's via HTTP (HyperText Transfer Protocol)
        methods.

        Some benefits of REST:
        - Very common
        - Easy to write and consume
        - Supports many kinds of data formats, including JSON and XML
        - Flexible and scalable
    */
	
    // Making requests is much more straightforward with REST API's
    public static void QueryPokemon(String pokemonName) {
        
        pokemonName.toLowerCase();
        
        // Create the HTTP class, which sends the request
        HTTP http = new HTTP();
        
        // Build the request
        HttpRequest hRequest = new HttpRequest();
        hRequest.setEndpoint('https://pokeapi.co/api/v2/pokemon/' + pokemonName);

        /*
            HTTP uses several different methods, we'll detail some here again:
            - GET: Retrieves a resource at an endpoint
            - POST: Creates a new resource at an endpoint or updates a resource
            - PUT: Completely overwrites a resource at an endpoint (this can create OR update)
            - DELETE: Removes a resource at an endpoint
            - PATCH: Details instructions for partial update of a resource at an endpoint

            GET, PUT, and DELETE are idempotent, which means identical callouts will not 
            affect the server. Non-idempotent methods like POST and (sometimes) PATCH will
            cause changes on identical callouts, so extra caution must be used. The difference
            between POST and PUT is that because POST is not idempotent, duplicate calls will
            cause duplicate resources created. 
        */
        hRequest.setMethod('GET');
        
        // Send the request and store the response
        HttpResponse response = http.send(hRequest);
        
        // Check the status code
        /*
            Code Reminder:
            - 100: Informational
            - 200: Success
            - 300: Redirect
            - 400: Client-Side Error
            - 500: Server-Side Error
        */
        if (response.getStatusCode() != 200) return;
        
        // Parse JSON
        JSONParser parser = JSON.createParser(response.getBody());
        
        // Parsing JSON is heavily dependent on the response you get
        // Be aware REST can also return XML
        String pkmName = '';
        while (parser.NextToken() != null) { // Tokens are fields, values, or syntax characters
            
            // Pick through field tokens
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                switch on parser.getText() {
                    when 'ability' {

                        // Advance to the desired value
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