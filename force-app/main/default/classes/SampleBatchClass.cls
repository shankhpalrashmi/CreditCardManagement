public class SampleBatchClass implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(
            [SELECT ID, Name, Email_Address__c, Phone_Number__c, Location__c FROM Credit_Card_Customer__c]
        );
    }
    
    //Each Execution of this method is treated as an independent Apex Transaction, respecting the governor limits of transaction
    public void execute(Database.BatchableContext BC, List<Credit_Card_Customer__c> scopedCustomers){
        List<Credit_Card_Customer__c> customersToUpdate = new List<Credit_Card_Customer__c>();
        for(Credit_Card_Customer__c customer : scopedCustomers){
            customer.Phone_Number__c = '9999999999';
            customersToUpdate.add(customer);
        }
        UPDATE scopedCustomers;
    }
    
    public void finish(Database.BatchableContext BC) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        List<String> sendTo = new List<String>();
        sendTo.add('shankhpalrashmi@gmail.com');
        mail.setToAddresses(sendTo);
        
        mail.setReplyTo('DO-NOT-REPLY@gmail.com');
        mail.setSenderDisplayName('Salesforce Org Batch Notification');
        
        List<String> ccTo = new List<String>();
        ccTo.add('shankhpalrashmi@gmail.com');
        mail.setCcAddresses(ccTo);
        
        mail.setSubject('SampleBatchJob Notification');
        String body = 'Dear Sir, Madam, <br/><br/>';
        body += 'We want to notify that the batch ran successfully, please check the results in the system. <br/><br/>';
        body += 'Regards,<br/>Arjun';
        mail.setHtmlBody(body);
        
        mails.add(mail);
        Messaging.sendEmail(mails);
    }
    
}

//Database.executeBatch(new SampleBatchClass());