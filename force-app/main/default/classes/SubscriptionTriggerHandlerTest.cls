@isTest
public with sharing class SubscriptionTriggerHandlerTest {
    
    @TestSetup
    static void setup(){
        List<Reader__c> readers = createReaders(5, 'testName', 'testMailVIP@g.com', 'VIP');
        List<Book__c> books = createBooks(5, 'bookName', 'author');
        List<Subscription__c> subs = createSubscriptions('subName', readers, books, Date.today(), 365);
    }

    @isTest 
    static void checkSubDuplicatesTest() {
        String errorMessage = '';
        
        try {
            List<Reader__c> readers = [
                SELECT Id
                FROM Reader__c
            ];
            List<Book__c> books = [
                SELECT Id
                FROM Book__c
            ];
            Test.startTest();
            List<Subscription__c> subs = createSubscriptions('subName', readers, books, Date.today(), 365);
            Test.stopTest();
        } catch (DmlException error) {
            errorMessage = error.getMessage();
        }
        Assert.isTrue(errorMessage.length() > 0);
    }



    private static List<Reader__c> createReaders(Integer amountOfReaders, String name, String email, String subscriptionType) {
        List<Reader__c> newReaders = new List<Reader__c>();

        for(Integer i=0; i < amountOfReaders; i++) {
            Reader__c reader = new Reader__c(Name = name + i, Email__c = email + i, Subscription_Type__c = subscriptionType);
            newReaders.add(reader);
        }
        
        insert newReaders;
        return newReaders;
    }

    private static List<Book__c> createBooks(Integer amountOfBooks, String bookName, String author) {
        List<Book__c> newBooks = new List<Book__c>();
        
        for(Integer i=0; i < amountOfBooks; i++) {
            Book__c book = new Book__c(Name = bookName, Author__c = author);
            newBooks.add(book);
        }
        
        insert newBooks;
        return newBooks;
    }

    private static List<Subscription__c> createSubscriptions(String subName, List<Reader__c> readers, List<Book__c> books, Date startDate, Integer daysAllowed) {
        List<Subscription__c> newSubs = new List<Subscription__c>();
        
        for(Integer i=0; i < readers.size(); i++) {
            Subscription__c sub = new Subscription__c(
                Name = 'Test' + i, 
                Reader__c = readers[i].Id, 
                Book__c = books[i].Id, 
                Start_Date__c = startDate,
                Days_Of_Hold_Allowed__c = daysAllowed
            );
            newSubs.add(sub);
        }
        
        insert newSubs;
        return newSubs;
    }

}
