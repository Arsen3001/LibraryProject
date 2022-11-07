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

    @AuraEnabled
    public static void updateReader(String readerId) {
        Map<String, Object> readerInfo = ReaderService.getReaderById(readerId);
        Reader__c readerToUpdate = getReader((String)readerInfo.get('recordId'));
        readerToUpdate.Last_Sync_Date__c = DateTime.now();
        readerToUpdate.Name = (String)readerInfo.get('name');
        readerToUpdate.Email__c = (String)readerInfo.get('email');
        readerToUpdate.Debtor__c = (Boolean)readerInfo.get('debtor');
        readerToUpdate.Subscription_Type__c = (String)readerInfo.get('subscriptionType');
        update readerToUpdate;
    }

    private static Reader__c getReader(String readerId) {
        return [
            SELECT Id, Name, Email__c, Debtor__c, Subscription_Type__c, Last_Sync_Date__c 
            FROM Reader__c 
            WHERE Id = :readerId
        ];
    }
}
