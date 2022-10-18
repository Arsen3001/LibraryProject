trigger SubscriptionTrigger on Subscription__c (before insert) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            SubscriptionTriggerHandler.checkSubDuplicates(Trigger.new);
        }
    }
}