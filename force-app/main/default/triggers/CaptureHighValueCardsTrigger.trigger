trigger CaptureHighValueCardsTrigger on Capture_High_Value_Cards__e (after insert) {
    
    Capture_High_Value_Cards__e cardEvent = new Capture_High_Value_Cards__e();
    cardEvent = Trigger.new[0];

    Credit_Card__c card = new Credit_Card__c();
    card = (Credit_Card__c) JSON.deserialize(cardEvent.Card_Detail__c, Credit_Card__c.class);

    card.Card_Value__c = 'High';
    
    TriggerExecutionController.executeCreditCardTrigger = false;
    UPDATE card;
    
}