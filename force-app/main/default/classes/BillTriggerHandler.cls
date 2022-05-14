public class BillTriggerHandler {
    
    public static Set<Id> extractBillIds(List<Bill__c> bills) {
        Set<Id> billIds = new Set<Id>();
        for(Integer i=0; i<bills.size(); i++) {
            billIds.add(bills[0].Id);
        }
        return billIds;
    }
    
    public static void calculateBillAmount(List<Bill__c> bills, Boolean otherSObjectContext) {	
        //Step 1 - Get all the Credit Cards associated to the bills
        Set<Id> creditCardIds = new Set<Id>();
        for(Integer i=0; i<bills.size(); i++) {
        	creditCardIds.add(bills[i].Credit_Card__c);    
        }
        
        //Step 2 - Get the financial details on the credit card needed for bill amount calculation 
        Map<Id, Credit_Card__c> creditCardMap = new Map<Id, Credit_Card__c>();
        List<Credit_Card__c> creditCards = new List<Credit_Card__c>();
        creditCards = [SELECT ID, Transaction_Charge__c, Credit_Card_Limit__c, Monthly_Card_Fees__c 
                      	FROM Credit_Card__c
							WHERE ID in :creditCardIds];
        for(Integer i=0; i<creditCards.size(); i++) {
            creditCardMap.put(creditCards[i].Id, creditCards[i]);
        }
        
        //Step 3 - Calculate the total bill amount and fill that in the amount field before bill goes to the database 
        for(Integer i=0; i<bills.size(); i++) {
        	bills[i].Total_Bill__c = bills[i].Cash_Withdrawal__c + 
                						bills[i].Card_Swiped__c * creditCardMap.get(bills[i].Credit_Card__c).Transaction_Charge__c + 
                						creditCardMap.get(bills[i].Credit_Card__c).Credit_Card_Limit__c + 
                						creditCardMap.get(bills[i].Credit_Card__c).Monthly_Card_Fees__c;
        }  
        if(otherSObjectContext) {
        	UPDATE bills; //before update and after update of the bill trigger gets called 
        }
    }
    
    public static void createAuditBillOnCustomer (Map<Id, Bill__c> newBillMap, Map<Id, Bill__c> oldBillMap) {
        //Step 0 - Just take out all the bills from the map as list 
        List<Bill__c> bills = new List<Bill__c>();
        bills = newBillMap.values();
  		
        //Step 1 - Collect the bills which have their total bill amount changed and collect a list of audits to insert
        List<Audit_Bill__c> auditBills = new List<Audit_Bill__c>();
        for(Integer i=0; i<bills.size(); i++) {
            if(bills[i].Total_Bill__c != oldBillMap.get(bills[i].ID).Total_Bill__c) {
                Audit_Bill__c au = new Audit_Bill__c();
                au.Bill_Number__c = bills[i].Name;
                au.Credit_Card_Customer__c = bills[i].Credit_Card_Customer__c;
                au.Old_Bill_Amount__c = oldBillMap.get(bills[i].ID).Total_Bill__c;
                au.New_Bill_Amount__c = bills[i].Total_Bill__c;
                auditBills.add(au);
            }
        }
        
        //Step 2 - Insert the Audit Bills
        INSERT auditBills;
    }

    public static void invokeSendEmailToFinanceTeam(Set<Id> billIds) {
        if(Test.isRunningTest()) {
            sendEmailWithoutFuture(billIds);
        } else {
            sendEmailWithFuture(billIds);
        }
    }

    @future
    public static void sendEmailWithFuture(Set<Id> billIds) {
        sendEmailToFinanceTeam(billIds);
    }

    public static void sendEmailWithoutFuture(Set<Id> billIds) {
        sendEmailToFinanceTeam(billIds);
    }

    public static void sendEmailToFinanceTeam(Set<Id> billIds) {
        List<Bill__c> bills = new List<Bill__c>();
        bills = [SELECT ID, Total_Bill__c FROM Bill__c WHERE ID in :billIds];
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        List<String> sendTo = new List<String>();
        sendTo.add('shankhpalrashmi@gmail.com');
        mail.setToAddresses(sendTo);
        
        mail.setReplyTo('DO-NOT-REPLY@gmail.com');
        mail.setSenderDisplayName('Salesforce Bill Trigger Notification');
        
        List<String> ccTo = new List<String>();
        ccTo.add('shankhpalrashmi@gmail.com');
        mail.setCcAddresses(ccTo);
        
        mail.setSubject('Bill Creation Notification');
        String body = 'Dear Sir, Madam, <br/><br/>';
        body += 'We want to notify that new bills got created in the system successfully, please find below <br/><br/>';
        body += '<table><tr><th>Bill Number</th><th>Total Bill Amount</th></tr>';
        for(Integer i=0; i<bills.size(); i++) {
            body += '<tr><td>'+bills[i].Name+'</td><td>'+bills[i].Total_Bill__c+'</td></tr></table><br/><br/>';
        }
        body += 'Regards,<br/>Arjun';
        mail.setHtmlBody(body);
        
        mails.add(mail);
        Messaging.sendEmail(mails);
    }
    
    public static void updateBillNameOnCustomer(List<Bill__c> bills) {
        UpdateBillNameOnCustomerQueueable o = new UpdateBillNameOnCustomerQueueable(bills);
        System.enqueueJob(o);
    }
}