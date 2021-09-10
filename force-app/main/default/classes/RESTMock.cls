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