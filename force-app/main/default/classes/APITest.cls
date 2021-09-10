@isTest
public class APITest {
	
    @isTest
    public static void SoapTest() {
        
        Test.startTest();
        
        // First things first; set the mock
        Test.setMock(WebServiceMock.class, new SOAPMock());
        
        // After the mock is set, simply make the request and check the response
        SampleWSDLClass.helloRequest requestInfo = new SampleWSDLClass.helloRequest();
        SampleWSDLClass.HelloEndpointPort request = new SampleWSDLClass.HelloEndpointPort();
        SampleWSDLClass.helloResponse response = request.SayHello(requestInfo);
        
        Test.stopTest();
        
        System.assertEquals('Response Here!', response.Message);
    }
    
    @isTest
    public static void RestTest() {
        Test.startTest();
        
        // Again we start similarly, we set the mock
        Test.SetMock(HttpCalloutMock.class, new RESTMock());
        
        HTTP send = new HTTP();
        
        // Then it's just a matter of making the callout
        HTTPRequest request = new HTTPRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/pokemon/');
        request.setMethod('GET');
        
        HTTPResponse response = send.send(request);
        
        Test.stopTest();
        
        // Our response is going to be from the mock, so just make sure it matches
        System.assertEquals('{"message":"Success!"}', response.getBody());
    }
}