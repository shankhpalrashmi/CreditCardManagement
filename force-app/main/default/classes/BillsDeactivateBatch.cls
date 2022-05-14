/*
* Virtual Classes in Apex
* Abstract Classes in Apex
* Interfaces in Apex
*/
public class BillsDeactivateBatch implements Database.Batchable<sObject> {
 
    //Typically in start you query records, a max of 50 million ---> Actually we get 4 records
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT ID, Active__c FROM Bill__c');
    }
 
    //Execute method breaks all the records queried in start method into chunks of your specified size
    public void execute(Database.BatchableContext BC, List<Bill__c> bills){
        List<Bill__c> billsToBeUpdated = new List<Bill__c>();
        for(Integer i=0; i<bills.size(); i++) {
            bills[i].Active__c = false;
            billsToBeUpdated.add(bills[i]);
        }
        UPDATE billsToBeUpdated;
    }
 
    public void finish(Database.BatchableContext BC) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        List<String> sendTo = new List<String>();
        sendTo.add('shankhpalrashmi@gmail.com');
        mail.setToAddresses(sendTo);
        
        mail.setReplyTo('DO-NOT-REPLY@gmail.com');
        mail.setSenderDisplayName('Salesforce Bill Deactivate Batch Notification');
        
        List<String> ccTo = new List<String>();
        ccTo.add('shankhpalrashmi@gmail.com');
        mail.setCcAddresses(ccTo);
        
        mail.setSubject('SampleBatchJob Notification');
        String body = 'Dear Sir, Madam, <br/><br/>';
        body += 'We want to notify that the batch ran successfully, please check the results in the system. <br/><br/>';
        body += 'Regards,<br/>Rashmi';
        mail.setHtmlBody(body);
        
        mails.add(mail);
        Messaging.sendEmail(mails);
    }

}

/*
BillsDeactivateBatch o = new BillsDeactivateBatch();
Database.executeBatch(o, 2);
*/