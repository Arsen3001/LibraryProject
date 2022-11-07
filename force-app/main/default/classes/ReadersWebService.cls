@RestResource(urlMapping='/Reader__c/*')
global with sharing class ReadersWebService {
    
    @HttpGet
    global static List<Reader__c> getTop5Readers() {
        return [
            SELECT Id, Name, Number_Of_Hold_Books__c, Email__c 
            FROM Reader__c WHERE Number_Of_Hold_Books__c >= 0 ORDER BY Number_Of_Hold_Books__c DESC LIMIT 5];
    }
}