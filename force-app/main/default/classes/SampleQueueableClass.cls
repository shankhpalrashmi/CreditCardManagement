public class SampleQueueableClass implements Queueable {
    public void execute(QueueableContext context) {
        Credit_Card_Customer__c newCustomer = new Credit_Card_Customer__c();
        newCustomer.Name = 'Queueable Customer';
        newCustomer.Email_Address__c = 'queue@email.com';
        newCustomer.Location__c = 'Australia';
        newCustomer.Phone_Number__c = '1234567890';
        INSERT newCustomer;
    }
}

/*
System.enqueueJob(new SampleQueueableClass());
*/