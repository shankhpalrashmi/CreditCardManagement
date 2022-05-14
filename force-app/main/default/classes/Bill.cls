public class Bill {
    public Credit_Card_Customer__c customer;
    public Credit_Card__c creditCard;
    public Bill__c bills;
    
    public Id insertCustomer(String nameInput, String emailInput, String phoneInput){
        customer = new Credit_Card_Customer__c();
        this.customer.Name = nameInput;
        this.customer.Email_Address__c = emailInput;
        this.customer.Phone_Number__c = phoneInput;
        INSERT this.customer;
        return this.customer.Id;
    }
    
    public Id insertCreditCard(String cardTypeInput, Decimal transactionChargeInput, 
                               Decimal monthlyFeeInput, Decimal cCardLimitInput){
        creditCard = new Credit_Card__c();
        this.creditCard.Card_Type__c = cardTypeInput;                         
        this.creditCard.Transaction_Charge__c = transactionChargeInput;
        this.creditCard.Monthly_Card_Fees__c = monthlyFeeInput;
        this.creditCard.Credit_Card_Limit__c = cCardLimitInput;
        INSERT this.creditCard;
        return this.creditCard.Id;
    }
    
    public void insertBill(Id insertCustomer, Id insertCreditCard, Decimal cashWithdrawalInput, Decimal cardSwipedInput, 
                               Decimal totalBillInput, Date startDate, Date endDate, Date dueDate){
        bills = new Bill__c();
        this.bills.Credit_Card__c = insertCreditCard;
        this.bills.Cash_Withdrawal__c = cashWithdrawalInput;
        this.bills.Card_Swiped__c = cardSwipedInput;
        this.bills.Total_Bill__c = totalBillInput;
        this.bills.Start_Date__c = startDate;
        this.bills.End_Date__c = endDate;
        this.bills.Due_Date__c = dueDate;                           
        INSERT this.bills;
    }
}