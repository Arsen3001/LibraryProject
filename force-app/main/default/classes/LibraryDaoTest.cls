@isTest
public with sharing class LibraryDaoTest {
    @TestSetup
    static void setup(){
        List<Reader__c> readers = createReaders(5, 'testName', 'testMailVIP@g.com', 'VIP');
        List<Book__c> books = createBooks(5, 'bookName', 'author');
        List<Book__c> terminatedBooks = createBooks(5, 'bookName', 'author');
        List<Subscription__c> subs = createSubscriptions('subName', readers, books, Date.today(), 365);
        List<Subscription__c> terminatedSubs = createSubscriptions('Sub', readers, terminatedBooks, date.today() - 50, 10);
        
    }

    @isTest 
    static void getActiveSubscriptionsTest() {
        Id readerId = [
            SELECT Id
            FROM Reader__c 
            LIMIT 1
        ].Id;
        
        List<Subscription__c> result = new List<Subscription__c>();
        
        Test.startTest();
        result = LibraryDao.getActiveSubscriptions(readerId);
        Test.stopTest();
        
        Assert.isTrue(result.size() == 2);
    }

    @isTest 
    static void getAllSubscriptionsTest() {
        List<Subscription__c> result = new List<Subscription__c>();

        Test.startTest();
        result = LibraryDao.getAllSubscriptions(5, 3);
        Test.stopTest();
        Assert.isTrue(result.size() == 5);
    }

    @isTest
    static void getReadersCountTest() {
        Integer result = 0;

        Test.startTest();
        result = (Integer)LibraryDao.getReadersCount()[0].get('expr0');
        Test.stopTest();

        Assert.areEqual(5, result);
    }

    @isTest 
    static void getReadersOfBookTest() {
        Id bookId = [
            SELECT Id
            FROM Book__c 
            LIMIT 1
        ].Id;
        
        List<Reader__c> result = new List<Reader__c>();

        Test.startTest();
        result = LibraryDao.getReadersOfBook(bookId);
        Test.stopTest();

        Assert.isTrue(result.size() == 1);
    }
    
    @isTest 
    static void getTerminatedBooksTest() {
        List<Book__c> result = new List<Book__c>();
        
        Test.startTest();
        result = LibraryDao.getTerminatedBooks(5, 3);
        Test.stopTest();

        Assert.isTrue(result.size() == 2);
    }

    @isTest 
    static void getTerminatedReadersTest() {
        Set<Id> result = new Set<Id>();

        Test.startTest();
        result = LibraryDao.getTerminatedReaders();
        Test.stopTest();

        Assert.isTrue(result.size() == 5);
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
