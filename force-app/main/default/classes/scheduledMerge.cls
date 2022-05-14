global class scheduledMerge implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        List<Credit_Card__c> cards = new List<Credit_Card__c>();

        for(Credit_Card__c card : [SELECT Id, Card_Type__c, Credit_Card_Limit__c from Credit_Card__c]) {
            card.Credit_Card_Limit__c = card.Credit_Card_Limit__c + 100;
            cards.add(card);
        }
        UPDATE cards;
    }
    
}

/*
scheduledMerge m = new scheduledMerge();
String sch = '0 0 5 * * ?'; //Run 5am everyday;
String jobID = system.schedule('Scheduled Job', sch, m);
*/