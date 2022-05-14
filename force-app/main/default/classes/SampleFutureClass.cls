global class SampleFutureClass {
    
    @future
    public static void myFutureMethod() {   
      Credit_Card__c card = new Credit_Card__c();
        card.Card_Type__c = 'Future Card';
        card.Monthly_Card_Fees__c = 10.10;
        card.Credit_Card_Limit__c = 20.20;      
        card.Transaction_Charge__c = 1.1; 
        INSERT card;
    }
    
}

//SampleFutureClass.myFutureMethod();