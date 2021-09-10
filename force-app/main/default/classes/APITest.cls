public class APITest {
	
    public static void Run() {
        HTTP req = new HTTP();
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://curious-shark-abdp3a-dev-ed.my.salesforce.com/services/apexrest/learning/');
        request.setMethod('GET');
        
        HttpResponse response = req.send(request);
        
        System.debug(response.getBody());
    }
}