public with sharing class PopularBooksController {
    
    @AuraEnabled(cacheable=true)
    public static List<Book__c> getPopularBooks() {
        return [
            SELECT Id, Name, Author__c, Quantity__c
            FROM Book__c 
            ORDER BY Quantity__c DESC
            LIMIT 10
        ];
    }
}
