@RestResource(urlMapping='/products')
global class RestResourceExample {
	@HttpPost
    global static void doPost(){
        RestRequest req = RestContext.request;
        System.debug(JSON.serializePretty(req.requestBody));
    }
}