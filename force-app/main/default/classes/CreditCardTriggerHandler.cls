public class CreditCardTriggerHandler {
    
    public static void calculateBillAmount(List<Credit_Card__c> newCards, List<Credit_Card__c> oldCards) {
         
       	Set<Id> creditCardIds = new Set<Id>();
        for(Integer i=0; i<newCards.size(); i++) {
            for(Integer j=0; j<oldCards.size(); j++) {
                if(newCards[i].ID == oldCards[j].ID) {
                    if(newCards[i].Monthly_Card_Fees__c != oldCards[i].Monthly_Card_Fees__c ||
                      newCards[i].Credit_Card_Limit__c != oldCards[i].Credit_Card_Limit__c ||
                       newCards[i].Transaction_Charge__c != oldCards[i].Transaction_Charge__c) {
                       		creditCardIds.add(newCards[i].ID);     
                       }
                }
            }
        }
        
        List<Bill__c> bills = new List<Bill__c>();
        bills = [SELECT Id, Credit_Card__c, Cash_Withdrawal__c, Card_Swiped__c 
                	FROM Bill__c
                		WHERE Credit_Card__c in :creditCardIds]; 
        
        BillTriggerHandler.calculateBillAmount(bills, true);
        
    }
    
    public static void mailFinanceHighValueCards(List<Credit_Card__c> cards) {
        for(Integer i=0; i<cards.size(); i++) {
            if(cards[i].Credit_Card_Limit__c>10000) {
                Capture_High_Value_Cards__e captureCard = new Capture_High_Value_Cards__e();
                captureCard.Card_Detail__c = JSON.serialize(cards[i]);
                EventBus.publish(captureCard);
            }
        }
    }

}