public class UpdateBillNameOnCustomerQueueable implements Queueable {
    
    public List<Bill__c> bills;
    
    public UpdateBillNameOnCustomerQueueable(List<Bill__c> billsInput) {
        bills = new List<Bill__c>();
        bills = billsInput;
    }
    
    public void execute(QueueableContext context) {
        //Step 1 - Collect the customer ids and put the bill number against their name
        Map<Id, String> mapCustomerIdToBillName = new Map<Id, String>(); 
        for(Integer i=0; i<bills.size(); i++) {
            mapCustomerIdToBillName.put(bills[i].Credit_Card_Customer__C, bills[i].Name);
        }
        
        //Step 2 - Prepare the Customer List that needs to be updated with latest Bills
        List<Credit_Card_Customer__C> customers = new List<Credit_Card_Customer__C>();
        customers = [SELECT ID, Latest_Bill_Created__c FROM Credit_Card_Customer__C WHERE ID in :mapCustomerIdToBillName.keySet()];
        for(Integer i=0; i<customers.size(); i++) {
            customers[i].Latest_Bill_Created__c = mapCustomerIdToBillName.get(customers[i].Id);
        }
        
        //Step 3 - Update the Customers List
        UPDATE customers;
    }
    
}