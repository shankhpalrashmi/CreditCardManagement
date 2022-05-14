trigger CustomerTrigger on Credit_Card_Customer__c (before insert) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
       	
        }
        if(Trigger.isUpdate) {
        	//With and Without Sharing Results Understanding------>
        	CustomerTriggerHandler.checkCustomerRecordsRetrieved();
        }
        if(Trigger.isDelete) {
            
        }
    }
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            //Let us say, we will insert a credit card using platform event async, once we insert a customer
            CustomerTriggerHandler.insertCreditCardAsyncPE(Trigger.new);
        }
        if(Trigger.isUpdate) {
            
        }
        if(Trigger.isDelete) {
            
        }
        if(Trigger.isUndelete) {
            
        }
    }
}