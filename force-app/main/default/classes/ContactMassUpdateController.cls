/*
    Description: Contact Mass Update, to take attendence.
*/

public with sharing class ContactMassUpdateController {
    
    public List<Contact> lstContacts {get; set;}
    
    public Id batchid;
    
    public ContactMassUpdateController(Apexpages.StandardController controller){
        batchid = controller.getId();
        lstContacts = new List<Contact>([select Id,Name,AccountId, Account.Name,Recommedation_Status__c,Current_Education__c,
                Batch_Code__r.Name, Counselling_Session_Attended__c,Recommendation_Report_Status__c,Bar_Code__c from Contact Where Batch_Code__c =: batchid 
                Order By Name]);
    }
    
    
    public PageReference Submit(){
        try {
            for(Contact objC: lstContacts){
                //we are settig student attendance as present
                if(objC.Counselling_Session_Attended__c) {
                    objC.Student_Attendance__c = 'Present';
                }
                else{
                    objC.Student_Attendance__c = null;
                }
            }
            update lstContacts;
            PageReference pg = new PageReference('/'+batchid);
            pg.setRedirect(true);
            return pg;
        } catch (Exception ex){
            Apexpages.AddMessages(ex);
            return null;
        }
    }
    
}