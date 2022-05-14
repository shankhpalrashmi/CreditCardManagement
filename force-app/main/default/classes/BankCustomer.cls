public class BankCustomer {
    public List<Credit_Card_Customer__c> customerList;
    
    /* public void insertCustomer(String nameInput, String emailInput, String phoneInput){
customer = new Credit_Card_Customer__c();
this.customer.Name = nameInput;
this.customer.Email_Address__c = emailInput;
this.customer.Phone_Number__c = phoneInput;
INSERT this.customer;
}*/
    
    public BankCustomer(){
        customerList = new List<Credit_Card_Customer__c>();
    }
    
    public List<Credit_Card_Customer__c> insertCustomer(){
        for(Integer i=0; i<2; i++){
            Credit_Card_Customer__c cust = new Credit_Card_Customer__c();
            cust.Name = 'Nikhita'+i;
            cust.Email_Address__c = 'Nikhita'+i+'@email.com';
            cust.Phone_Number__c = '9897237287'+i;
            customerList.add(cust);
        }
        INSERT customerList;
        RETURN customerList;
    }   
    
    public void updateCustomer(List<Credit_Card_Customer__c> custList){
        customerList = new List<Credit_Card_Customer__c>();
        for(Integer i = 0; i<2;i++){
            Credit_Card_Customer__c customer = new Credit_card_customer__c();
            customer = custList[i];
            customer.Name = customer.Name+' Shetty';
            customerList.add(customer);
        }
        UPDATE customerList;
    }
}