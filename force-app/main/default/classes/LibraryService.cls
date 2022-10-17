public with sharing class LibraryService {
    public static void createSubscription(Id bookId, Id readerId, String name) {
        try {
            Subscription__c newSub = new Subscription__c();
            newSub.Book__c = bookId;
            newSub.Reader__c = readerId;
            newSub.Name = name;
            newSub.Start_date__c = date.today();
            insert newSub;
        } catch (DmlException e) {
            System.debug('A DML exception has occured: ' +  e.getMessage());
          }
    }

    public static void closeSubscription(Id subscriptionId) {
        try {
            Subscription__c sub = [SELECT Id, Name, Returned_Date__c FROM Subscription__c WHERE Id = :subscriptionId LIMIT 1];
            sub.Returned_Date__c = date.today();
            update sub;
        } catch (DmlException e) {
            System.debug('A DML exception has occured: ' +  e.getMessage());
        }
    }



    public static void createReader(String name, String subscriptionType) {
        try {
            Reader__c newReader = new Reader__c();
            newReader.name = name;
            newReader.Subscription_Type__c = subscriptionType;
            insert newReader;
            System.debug('Subscription has been created.');
        } catch (DmlException e) {
            System.debug('A DML exception has occured: ' +  e.getMessage());
        }
    }

    public static void upgradeReader(List<Id> readerIds, String subscriptionType) {
        try {
            List<Reader__c> listToUpdate = new List<Reader__c>();
            for(Reader__c reader : [SELECT Id, Subscription_Type__c FROM Reader__c WHERE Id IN :readerIds]) {
                reader.Subscription_Type__c = subscriptionType;
                listToUpdate.add(reader);
            }
            update listToUpdate;
        } catch (DmlException e) {
            System.debug('A DML exception has occured: ' +  e.getMessage());
        }
        
    }

    public static void deleteBooks(List<Id> bookIds) {
        try {
            List<Book__c> booksToDelete = new List<Book__c>();
            for(Book__c book : [SELECT Id FROM Book__c WHERE Id IN :bookIds]) {
                booksToDelete.add(book);
            }
            delete booksToDelete;
        } catch (DmlException e) {
            System.debug('A DML exception has occured: ' +  e.getMessage());
        }
        
    }
}
