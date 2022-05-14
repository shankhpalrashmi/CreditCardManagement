public class BillCreateCtr {
  
    public Bill__c billRecord {get;set;}
    public Boolean readMode {get;set;}
    public Boolean editMode {get;set;}
    
    /*
     * Whenever a VF page is loaded, constructor is automatically invoked
     * The reason for that is because the class object is created by the VF page in the background by the Salesforce framework, 
     * which calls the constructor 
  */
    public BillCreateCtr() {
        billRecord = new Bill__c();
        displayEditMode();
    }

    public void displayEditMode() {
        editMode = true;
        readMode = false;
    }

    public void displayReadMode() {
        editMode = false;
        readMode = true;
    }

    //This method saves the get set variable of the visiaforce page to the Database
    public void saveBill() {
        INSERT billRecord;

        displayReadMode();

        String successMessage = 'Bill Created Successfully';
        //ERROR SUCCESS INFO
        ApexPages.Message o = new ApexPages.Message(Apexpages.Severity.INFO, successMessage);
        Apexpages.addMessage(o);
    }
    
}

/*
public class ApexPages {

    public class message {

    }

    public class Heart {

    }

}
*/