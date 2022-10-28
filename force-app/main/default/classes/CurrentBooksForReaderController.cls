public with sharing class CurrentBooksForReaderController {
    
    @AuraEnabled(cacheable=true)
    public static List<Book__c> getCurrentBookForReader(String readerId) {
        return [
            SELECT Id, Name, Author__c
            FROM Book__c 
            WHERE Id IN
                (SELECT Book__c 
                FROM Subscription__c 
                WHERE Start_Date__c = THIS_YEAR 
                AND Reader__c = :readerId
                )
        ];
    }
}
