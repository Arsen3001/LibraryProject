public class OrderMoreBooksBatch implements
    Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return database.getQueryLocator(
            'SELECT Id, Name, Quantity__c,' +
                '(SELECT Id, Book__c FROM Subscriptions__r)' +
            'FROM Book__c'    
        );
    }

    public void execute(Database.BatchableContext bc, List<Book__c> scope) {
        List<Book__c> booksToOrder = new List<Book__c>();
        for(Book__c book : scope) {
            if(book.Quantity__c <= book.Subscriptions__r.size()) {
                book.Quantity__c += 3;
                booksToOrder.add(book);
            }            
        }    
        update booksToOrder;
    }

    public void finish(Database.BatchableContext bc) {
    }
}  

