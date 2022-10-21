@isTest
public with sharing class BookTriggerHandlerTest {
    
    @TestSetup
    static void makeData(){
        List<Reader__c> readers = createReaders(5, 'testName', 'testMailVIP@g.com', 'VIP');
        List<Book__c> books = createBooks(5, 'bookName', 'author');
        List<Subscription__c> subs = createSubscriptions('subName', readers, books, Date.today(), 365);
    
    }

    @isTest 
    static void markRelatedReadersAsDebtorsTest() {
        Set<Id> bookIds = new Set<Id>(); 
        
        List<Book__c> booksToDelete = [
            SELECT Id
            FROM Book__c
            LIMIT 2
        ];

        for(Book__c book : booksToDelete) {
            bookIds.add(book.Id);
        }

        List<Reader__c> readersRelatedToDeletedBooks = [
            SELECT Id, Debtor__c 
            FROM Reader__c 
            WHERE Id IN 
                (SELECT Reader__c 
                FROM Subscription__c 
                WHERE Book__c IN :bookIds)];

        Set<Id> readerIds = new Set<Id>();
        for(Reader__c reader : readersRelatedToDeletedBooks) {
            readerIds.add(reader.Id);
        }
            
        Test.startTest();
        delete booksToDelete;
        Test.stopTest();

        List<Reader__c> debtorReaders = [
            SELECT Id, Debtor__c 
            FROM Reader__c 
            WHERE Id IN :readerIds];

        for(Reader__c reader : debtorReaders) {
            Assert.isTrue(reader.Debtor__c);
        }
        Assert.isTrue(debtorReaders.size() == 2);
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






