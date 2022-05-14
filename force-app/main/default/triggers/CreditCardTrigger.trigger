trigger CreditCardTrigger on Credit_Card__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) { 
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            
        }
        if(Trigger.isUpdate) {
            
        }
        if(Trigger.isDelete) {
            
        }
    }
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            //Check High Value Card
            if(TriggerExecutionController.executeCreditCardTrigger) {
            	CreditCardTriggerHandler.mailFinanceHighValueCards(Trigger.new);    
            }
        }
        if(Trigger.isUpdate) {
            if(TriggerExecutionController.executeCreditCardTrigger) {
                CreditCardTriggerHandler.calculateBillAmount(Trigger.new, Trigger.old);   
                
                CreditCardTriggerHandler.mailFinanceHighValueCards(Trigger.new);
            }
        }
        if(Trigger.isDelete) {
            
        }
        if(Trigger.isUndelete) {
            
        }
    }
}