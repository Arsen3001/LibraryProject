public with sharing class ReaderService {
    public class CustomIntegrationException extends Exception {}


    public static Map<String, Object> getReaderById(String readerId) {
        Map<String, Object> results = new Map<String, Object>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setHeader('recordId', readerId); 
        request.setHeader('objectName', 'Reader'); 
        request.setEndpoint('https://avenga-school.herokuapp.com/retrieve-record');
        HttpResponse response = http.send(request);
        
        System.debug(response.getStatusCode());
        try {
            if(response.getStatusCode() == 200) {
                results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody()); 
                List<Reader__c> readers = (List<Reader__c>) results.get('readers');
                System.debug('Results --> ' + results);
            } else {
                throw new CustomIntegrationException('An error occured. Current status code: ' + response.getStatusCode());
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        
        return results;
    }
}
