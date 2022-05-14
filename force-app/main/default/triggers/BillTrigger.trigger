trigger BillTrigger on Bill__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {  
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
           BillTriggerHandler.calculateBillAmount(Trigger.new, false);    
        }
        if(Trigger.isUpdate) {
            //On Update of Bill calculate the Total Bill Amount
            BillTriggerHandler.calculateBillAmount(Trigger.new, false);
        }
        if(Trigger.isDelete) {
            
        }
    }
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            //Send the email to the Finance team whenever bills are created
            BillTriggerHandler.invokeSendEmailToFinanceTeam(BillTriggerHandler.extractBillIds(Trigger.new));
            
            //Update the last bill number on the Customer
            BillTriggerHandler.updateBillNameOnCustomer(Trigger.new);
        }
        if(Trigger.isUpdate) {
            //Check if the Bill Amount got changed, and enter the Audit Bills against customer accordingly
            BillTriggerHandler.createAuditBillOnCustomer(Trigger.newMap, Trigger.oldMap);
        }
        if(Trigger.isDelete) {
            
        }
        if(Trigger.isUndelete) {
            
        }
    }
}