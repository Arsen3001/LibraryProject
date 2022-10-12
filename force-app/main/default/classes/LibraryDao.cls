public with sharing class LibraryDao {
    public static List<Subscription__c> getActiveSubscriptions(Id readerId) {
        return [SELECT Name, Id, reader__r.Subscription_Type__c FROM Subscription__c WHERE Reader__r.Id = :readerId AND Reader__r.Subscription_Type__c != 'one-time'];
    }



//     LibraryDao class:


    public static List<Subscription__c> getAllSubscriptions(Integer recordsLimit, Integer offset) {
        return [SELECT Name, Id FROM Subscription__c LIMIT :recordsLimit OFFSET :offset];
    }

    public static List<AggregateResult> getReadersCount() {
        return [SELECT COUNT(Id) FROM Reader__c];
    }

    public static List<Reader__c> getReadersOfBook(Id bookId) {
        // list<Subscription__c>listOfSubs = [SELECT Id, reader__r.Id FROM Subscription__c WHERE book__r.Id = :bookId];
        // Set<Id>readerId = new Set<Id>();
        // for (Subscription__c sub : listOfSubs) {
        //     readerId.add(sub.reader__r.Id);
        // }
        // return [SELECT Name, Id FROM Reader__c WHERE Id IN :readerId ];

            return [SELECT Id, Name FROM Reader__c WHERE Id IN 
                    (SELECT Reader__c FROM Subscription__c WHERE Book__r.Id = :bookID)];
    }

    public static List<Book__c> getTerminatedBooks(Integer booksLimit, Integer offset) {
        return [SELECT Name, Id FROM Book__c WHERE Id IN 
                    (SELECT Book__c FROM Subscription__c WHERE Status__c='red') 
                LIMIT :booksLimit OFFSET :offset];
    }

    public static Set<Id> getTerminatedReaders() {
        List<Subscription__c>listOfReadersSubs = [SELECT Id, Reader__c  FROM Subscription__c WHERE Status__c = 'red']; 
        Set<Id>setOfIds = new Set<Id>();
        for (Subscription__c sub : listOfReadersSubs) {
            setOfIds.add(sub.Reader__c);
        }
        return setOfIds;
    }

}
