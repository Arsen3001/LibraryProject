public with sharing class BookTriggerHandler {
    public static void markRelatedReadersAsDebtors(List<Book__c> deletedBooks) {
        Set<Id> bookIds = new Set<Id>();
        
        for(Book__c book : deletedBooks) {
            bookIds.add(book.Id);
        }
        
        List<Reader__c> relatedReaders = getReadersRelatedToBooks(bookIds);

        for(Reader__c reader : relatedReaders) {
            reader.Debtor__c = true;
        }   
        
        update relatedReaders;
    }

    private static List<Reader__c> getReadersRelatedToBooks(Set<Id> bookIds) {
        return [
            SELECT Id, Debtor__c 
            FROM Reader__c 
            WHERE Id IN 
                (SELECT Reader__c 
                 FROM Subscription__c 
                 WHERE Book__c IN :bookIds)];
    }
}
