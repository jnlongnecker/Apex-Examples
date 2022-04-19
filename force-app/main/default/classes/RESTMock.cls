/*
    Created by: Jared Longnecker
    Last Updated: 03/17/2022
    Description: Mock for testing REST callouts 
*/

// Again in testing, so use @isTest
// class and methods still must be public or global

@isTest
public class RESTMock implements HttpCalloutMock {
	
    // Well this is much easier isn't it
    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        
        // Now we just fill out the body here and boom
        response.SetHeader('Content-Type', 'application/json');
        response.SetBody('{"message":"Success!"}');
        response.SetStatusCode(200);
        
        return response;
    }
}