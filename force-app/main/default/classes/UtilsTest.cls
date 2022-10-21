@isTest
public with sharing class UtilsTest {
    @TestSetup
    static void setup(){
        List<Reader__c> readers = new List<Reader__c>();
        readers.addAll(createReaders(5, 'testName', 'testMailVIP@g.com', 'VIP'));
        readers.addAll(createReaders(5, 'testName', 'testMailOne-Time@g.com', 'one-time'));
        insert readers;
    }

    @isTest 
    static void groupRecordsByFieldTest() {
        List<Reader__c> readersToGroup = getReaders();
        Map<String, List<sObject>> result = new Map<String, List<sObject>>();

        Test.startTest();
        result = Utils.groupRecordsByField(readersToGroup, 'Subscription_Type__c');
        Test.stopTest();

        Assert.isTrue(result.containsKey('VIP'));
        Assert.isTrue(result.containsKey('one-time'));
        Assert.areEqual(5, result.get('VIP').size());
        Assert.areEqual(5, result.get('one-time').size());
    }

    @isTest 
    static void groupRecordsAndGetSobjectFieldValueTest() {
        List<Reader__c> readers = getReaders();
        Map<String, Set<String>> result = new Map<String, Set<String>>();

        Test.startTest();
        result = Utils.groupRecordsAndGetSobjectFieldValue(readers, 'Subscription_Type__c', 'Subscription_Type__c');
        Test.stopTest();

        Assert.isTrue(result.containsKey('Subscription_Type__c'));
        Assert.isTrue(result.get('Subscription_Type__c').size() > 0);
        System.debug(result);
    }

    @isTest 
    static void getFieldValueFromSobjectListTest() {
        List<Reader__c> readers = getReaders();
        Set<String> result = new Set<String>();

        Test.startTest();
        result = Utils.getFieldValueFromSobjectList(readers, 'Email__c');
        Test.stopTest();

        Assert.isTrue(result.size() == 10);


    }
    


    private static List<Reader__c> getReaders() {
        return [SELECT Id, Subscription_Type__c, Email__c
        FROM Reader__c];
    }
    
    private static List<Reader__c> createReaders(Integer amountOfReaders, String name, String email, String subscriptionType) {
        List<Reader__c> newReaders = new List<Reader__c>();

        for(Integer i=0; i < amountOfReaders; i++) {
            Reader__c reader = new Reader__c(Name = name + i, Email__c = email + i, Subscription_Type__c = subscriptionType);
            newReaders.add(reader);
        }
        
        return newReaders;
    }
}
