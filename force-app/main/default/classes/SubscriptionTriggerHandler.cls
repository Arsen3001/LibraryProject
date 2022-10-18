public with sharing class SubscriptionTriggerHandler {
    public static void checkSubDuplicates(List<Subscription__c> newSubscriptions) {
        Set<Id> booksIds = new Set<Id>();
        Set<Id> readersIds = new Set<Id>();
        for(Subscription__c newSub : newSubscriptions) {
            booksIds.add(newSub.Book__c);
            readersIds.add(newSub.Reader__c);
        }
        
        List<Subscription__c> existingSubscriptions = getExistingSubs(booksIds, readersIds);

        for(Subscription__c newSub : newSubscriptions) {
            for(Subscription__c exSub : existingSubscriptions) {
                if(newSub.Reader__c == exSub.Reader__c && newSub.Book__c == exSub.Book__c) {
                    newSub.addError('Duplicate found');
                }
            }
        }
    }

    private static List<Subscription__c> getExistingSubs(Set<Id> booksIds, Set<Id> readersIds) {
        return [SELECT Id, Reader__c, Book__c
        FROM Subscription__c 
        WHERE Reader__c IN :readersIds AND Book__c IN :booksIds];
    }
}