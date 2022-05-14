public without sharing class CustomerTriggerHandler {
    
    public static void checkCustomerRecordsRetrieved() {

    }
    
    public static void insertCreditCardAsyncPE(List<Credit_Card_Customer__c> customers) {
        for(Credit_Card_Customer__c customer : customers) {
            EventBus.publish(new Sample_Platform_Event__e(Message__c=JSON.serialize(customer)));
        }
    }

}