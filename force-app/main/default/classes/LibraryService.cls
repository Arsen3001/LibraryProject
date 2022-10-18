public with sharing class LibraryService {
    public static void createSubscription(Id bookId, Id readerId, String name) {
        try {
            Subscription__c newSub = new Subscription__c(Book__c = bookId, Reader__c = readerId, Name = name, Start_date__c = date.today());
            database.insert(newSub);
        } catch (DmlException e) {
            System.debug('A DML exception has occured: ' +  e.getMessage());
          }
    }

    public static void closeSubscription(Id subscriptionId) {
        try {
            Subscription__c sub = [SELECT Id, Name, Returned_Date__c 
                                   FROM Subscription__c 
                                   WHERE Id = :subscriptionId 
                                   LIMIT 1];
            sub.Returned_Date__c = date.today();
            update sub;
        } catch (DmlException e) {
            System.debug('A DML exception has occured: ' +  e.getMessage());
        }
    }

    public static void createReader(String name, String subscriptionType) {
        try {
            Reader__c newReader = new Reader__c(Name = name, Subscription_Type__c = subscriptionType);
            insert newReader;

        } catch (DmlException e) {
            System.debug('A DML exception has occured: ' +  e.getMessage());
        }
    }

    public static void upgradeReader(List<Id> readerIds, String subscriptionType) {
        try {
            List<Reader__c> queriedReaders = [
                SELECT Id, Subscription_Type__c
                FROM Reader__c 
                WHERE ID IN :readerIds
            ];
            
            for(Reader__c reader : queriedReaders) {
                reader.Subscription_Type__c = subscriptionType;
            }
            
            update queriedReaders;
        } catch (DmlException e) {
            System.debug('A DML exception has occured: ' +  e.getMessage());
        }
    }

    public static void deleteBooks(List<Id> bookIds) {
        try {
            Database.delete(bookIds);
        } catch (DmlException e) {
            System.debug('A DML exception has occured: ' +  e.getMessage());
        }
    }
}
