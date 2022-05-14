trigger SamplePlatformEventTrigger on Sample_Platform_Event__e (after insert) {
    for(Sample_Platform_Event__e pe : Trigger.new) {
    	//We should ideally provide another field value (have one more field on PE, to say what object API name is being called)
    	//That would help us identity what is the identifier to deserialize, currently i am deserializing everything for customer
    	Credit_Card_Customer__c customer = (Credit_Card_Customer__c) JSON.deserialize(pe.Message__c, Credit_Card_Customer__c.class);
        Credit_Card__c card = new Credit_Card__c();
        card.Card_Type__c = card.Card_Type__c + ' Card';
        card.Monthly_Card_Fees__c = 100;
        card.Credit_Card_Limit__c = 10;
        card.Transaction_Charge__c = 5;
        INSERT card;
    }
}