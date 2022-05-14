public class BillsMgmtCtr {

    public List<Bill__c> bills {get;set;}
    public Boolean readMode {get;set;}
    public Boolean editMode {get;set;}
    public List<BillWrapper> wrappedBills {get;set;}

    public class BillWrapper {
        public Boolean selectBox {get;set;}
        public Bill__c billRecord {get;set;}

        public BillWrapper(Boolean selectBoxInput, Bill__c billRecordInput) {
            this.selectBox = selectBoxInput;
            this.billRecord = billRecordInput;
        }
    }

    public BillsMgmtCtr() {
        getBills();    
        displayReadMode();
    }

    public void displayReadMode() {
        readMode = true;
        editMode = false;
    }

    public void displayEditMode() {
        readMode = false;
        editMode = true;
    }

    public void getBills() {
        bills = new List<Bill__c>();
        bills = [SELECT ID, Start_Date__c, End_Date__c, Cash_Withdrawal__c, Active__c,
                     Credit_Card_Customer__c, Credit_Card__c, Total_Bill__c, Comments__c, Card_Swiped__c
                        FROM Bill__c];
        wrappedBills = new List<BillWrapper>();
        for(Integer i=0; i<bills.size(); i++) {
            BillWrapper wrapBill = new BillWrapper(false, bills[i]);
            wrappedBills.add(wrapBill);
        }
    }

    public void saveBills() {
        UPDATE bills; //This will call the trigger before update and after update events of Bill__c

        displayReadMode();

        String successMessage = 'Bills Updated Successfully';
        //ERROR SUCCESS INFO
        ApexPages.Message o = new ApexPages.Message(Apexpages.Severity.INFO, successMessage);
        Apexpages.addMessage(o);
    }

    public void deleteBills() {
        List<Bill__c> billsToBeDeleted = new List<Bill__c>();
        for(Integer i=0; i<wrappedBills.size(); i++) {
            if(wrappedBills[i].selectBox) {
                billsToBeDeleted.add(wrappedBills[i].billRecord);
            }
        }
        DELETE billsToBeDeleted;

        getBills();

        String successMessage = 'Bills Deleted Successfully';
        //ERROR SUCCESS INFO
        ApexPages.Message o = new ApexPages.Message(Apexpages.Severity.INFO, successMessage);
        Apexpages.addMessage(o);
    }

}