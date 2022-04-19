/*
    Created by: Jared Longnecker
    Last Updated: 03/17/2022
    Description: Mock for testing SOAP callouts 
*/

// We only use this for testing, so use @isTest here
// class and methods must be public or global

@isTest
public class SOAPMock implements WebServiceMock {
	
    // We need to implement the doInvoke method to work with this
    public void DoInvoke(Object stub, Object request, Map<String, Object> response,
      String endpoint, String soapAction, String requestName,
      String responseNamespace, String responseName, String responseType) {
        
          
          SampleWSDLClass.SayHelloResponse responseEl = new SampleWSDLClass.SayHelloResponse();
          responseEl.HelloResponse = new SampleWSDLClass.HelloResponse();
          responseEl.HelloResponse.Message = 'Response Here!';
          response.put('response_x', responseEl);
    }
}