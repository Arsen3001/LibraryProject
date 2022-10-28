public with sharing class OrderMoreBooksScheduler implements Schedulable {
    public void execute(SchedulableContext SC) {
        OrderMoreBooksBatch orderBooksSchedulable = new OrderMoreBooksBatch();
        Id batchId = Database.executeBatch(orderBooksSchedulable);   
    }
}




 
