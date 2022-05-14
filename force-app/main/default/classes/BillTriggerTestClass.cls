@isTest
private class BillTriggerTestClass {

    @testSetup
    private static void createTestData() {
        Credit_Card_Customer__c customer = new Credit_Card_Customer__c();
        customer.Name = 'Test Customer';
        customer.Email_Address__c = 'testcustomer@email.com';
        customer.Phone_Number__c = '345345332';
        INSERT customer;

        Credit_Card__c card = new Credit_Card__c();
        card.Card_Type__c = 'Test Card';
        card.Transaction_Charge__c = 10;
        card.Monthly_Card_Fees__c = 50;
        card.Credit_Card_Limit__c = 2;
        INSERT card;
    }

    @isTest
    private static void testTotalBillAmtCalculation() {
        Credit_Card_Customer__c customerRecord = [SELECT Id, Name, Email_Address__c, Phone_Number__c
                                        FROM Credit_Card_Customer__c WHERE Name = 'Test Customer'];
        Credit_Card__c cardRecord = [SELECT Id, Card_Type__c, Transaction_Charge__c, Monthly_Card_Fees__c, Credit_Card_Limit__c 
                                        FROM Credit_Card__c WHERE Name = 'Test Card'];
        
        //Test Scenario 1 - Insert Bill and Test the calculation
        Bill__c billRecord = new Bill__c();
        billRecord.Credit_Card_Customer__c = customerRecord.Id; 
        billRecord.Credit_Card__c = cardRecord.Id;
        billRecord.Start_Date__c = Date.newInstance(2022,1,1);
        billRecord.End_Date__c = Date.newInstance(2022,1,31);
        billRecord.Cash_Withdrawal__c = 1000;
        billRecord.Card_Swiped__c = 10;
        billRecord.Comments__c = 'Test Comments';
        INSERT billRecord; 

        Bill__c billRecordInserted = [SELECT ID, Name, Total_Bill__c FROM Bill__c WHERE Credit_Card_Customer__c = :customerRecord.Id];
        System.assertEquals(1152.00, billRecordInserted.Total_Bill__c);

        billRecord.Cash_Withdrawal__c = 1100;
        UPDATE billRecord;
        
        billRecordInserted = [SELECT ID, Name, Total_Bill__c FROM Bill__c WHERE Credit_Card_Customer__c = :customerRecord.Id];
        System.assertEquals(1252.00, billRecordInserted.Total_Bill__c);

        cardRecord.Credit_Card_Limit__c = 12;
        UPDATE cardRecord;

        billRecordInserted = [SELECT ID, Name, Total_Bill__c FROM Bill__c WHERE Credit_Card_Customer__c = :customerRecord.Id];
        System.assertEquals(1262.00, billRecordInserted.Total_Bill__c);

        //Test Scenario 4 - Update Credit Card and Test the calculation by changing transaction cost
        cardRecord.Transaction_Charge__c = 20;
        UPDATE cardRecord; //before update and after update of Credit Card Trigger 

        billRecordInserted = [SELECT ID, Name, Total_Bill__c FROM Bill__c WHERE Credit_Card_Customer__c = :customerRecord.Id];
        System.assertEquals(1362.00, billRecordInserted.Total_Bill__c);
    }

    @isTest 
    private static void testSendingEmailToFinance() {
        Credit_Card_Customer__c customerRecord = [SELECT Id, Name, Email_Address__c, Phone_Number__c 
                                        FROM Credit_Card_Customer__c WHERE Name = 'Test Customer'];
        Credit_Card__c cardRecord = [SELECT Id, Card_Type__c, Transaction_Charge__c, Monthly_Card_Fees__c, Credit_Card_Limit__c 
                                        FROM Credit_Card__c WHERE Name = 'Test Card'];
        
        Bill__c billRecord = new Bill__c();
        billRecord.Credit_Card_Customer__c = customerRecord.Id; 
        billRecord.Credit_Card__c = cardRecord.Id;
        billRecord.Start_Date__c = Date.newInstance(2022,1,1);
        billRecord.End_Date__c = Date.newInstance(2022,1,31);
        billRecord.Cash_Withdrawal__c = 1000;
        billRecord.Card_Swiped__c = 10;
        billRecord.Comments__c = 'Test Comments';
        INSERT billRecord; 
        
        System.assertEquals(1, Limits.getEmailInvocations());
    }

    @isTest 
    private static void testCreateAuditBillOnCustomer() {
        Credit_Card_Customer__c customerRecord = [SELECT Id, Name, Email_Address__c, Phone_Number__c
                                        FROM Credit_Card_Customer__c WHERE Name = 'Test Customer'];
        Credit_Card__c cardRecord = [SELECT Id, Card_Type__c, Transaction_Charge__c, Monthly_Card_Fees__c, Credit_Card_Limit__c 
                                        FROM Credit_Card__c WHERE Name = 'Test Card'];       
        Bill__c billRecord = new Bill__c();
        billRecord.Credit_Card_Customer__c = customerRecord.Id; 
        billRecord.Credit_Card__c = cardRecord.Id;
        billRecord.Start_Date__c = Date.newInstance(2022,1,1);
        billRecord.End_Date__c = Date.newInstance(2022,1,31);
        billRecord.Cash_Withdrawal__c = 1000;
        billRecord.Card_Swiped__c = 10;
        billRecord.Comments__c = 'Test Comments';
        INSERT billRecord;

        //Test Scenario - On changing bill total amount, there should be an audit maintained against the related customer 
        billRecord.Cash_Withdrawal__c = 2000;
        UPDATE billRecord; //This should run the audit functionality on Bill after update trigger 
        Bill__c billRecordUpdated = [SELECT Name, Total_Bill__c FROM Bill__c WHERE Credit_Card_Customer__c = :customerRecord.Id];

        Audit_Bill__c au = new Audit_Bill__c();
        au = [SELECT ID, Name, Old_Bill_Amount__c, New_Bill_Amount__c, Credit_Card_Customer__c, Bill_Number__c 
                FROM Audit_Bill__c WHERE Credit_Card_Customer__c = :customerRecord.Id AND Bill_Number__c = :billRecordUpdated.Name];

        System.assertEquals(au.Bill_Number__c, billRecordUpdated.Name);
        System.assertEquals(1152.00, au.Old_Bill_Amount__c);
        System.assertEquals(2152.00, au.New_Bill_Amount__c);
    }

}