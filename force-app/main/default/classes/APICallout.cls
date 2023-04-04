/*
    Created by: Jared Longnecker
    Last Updated: 03/17/2022
    Description: Demonstrating a callout to the REST Pokeapi
*/

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

        Principles of REST:
        - Client-Server architecture through HTTP
        - Uniform Interface (send back data in a standardized format)
        - Statelessness (requests are independent)
        - Layered System (system has other processes obfuscated from the user)
        - Cacheability (allow caching of commonly accessed and static resources)
    */
	
    // Making requests is much more straightforward with REST API's
    public static void QueryPokemon(String pokemonName) {
        
        pokemonName.toLowerCase();
        
        // Create the HTTP class, which sends the request
        HTTP http = new HTTP();
        
        // Build the request
        HttpRequest hRequest = new HttpRequest();
        hRequest.setEndpoint('https://pokeapi.co/api/v2/pokemon/' + pokemonName);

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
        
        // Can also convert the JSON to a map
        Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        
        // Parsing JSON is heavily dependent on the response you get
        // Be aware REST can also return other data formats
        String pkmName = '';
        while (parser.NextToken() != null) { // Tokens are fields, values, or syntax characters
            
            // Pick through field tokens
            // Tokens can be FIELD_NAME, END_ARRAY, END_OBJECT, START_ARRAY, START_OBJECT, NOT_AVAILABLE, or the data type
            // Data type values: VALUE_FALSE, VALUE_EMBEDDED_OBJECT, VALUE_TRUE, VALUE_STRING, VALUE_NULL, VALUE_NUMBER_INT, VALUE_NUMBER_FLOAT, VALUE_STRING
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
        
        // If parsing isn't your jam, use the mapped values
        String name = (String)jsonMap.get('name');
        List<Object> pkmTypes = (List<Object>)jsonMap.get('types');
        Integer exp = Integer.valueOf(jsonMap.get('base_experience'));
        List<Object> abilities = (List<Object>)jsonMap.get('abilities');
        
        // These are easy for surface values, but values in embedded objects can be nasty
        System.debug('Pokemon name: ' + name);
        System.debug('Base experience: ' + exp);
        for (Object ability : abilities) {
            String jString = JSON.serialize(ability);
            Map<String, Object> abilityMap = (Map<String, Object>)JSON.deserializeUntyped(jString);
            jString = JSON.serialize(abilityMap.get('ability'));
            Map<String, Object> abilityData = (Map<String, Object>)JSON.deserializeUntyped(jString);
            System.debug('Ability: ' + abilityData.get('name'));
        }
        for (Object pkmType : pkmTypes) {
            String jString = JSON.serialize(pkmType);
            Map<String, Object> typeMap = (Map<String, Object>)JSON.deserializeUntyped(jString);
            jString = JSON.serialize(typeMap.get('type'));
            Map<String, Object> typeData = (Map<String, Object>)JSON.deserializeUntyped(jString);
            System.debug('Type: ' + typeData.get('name'));
        }
    }
}