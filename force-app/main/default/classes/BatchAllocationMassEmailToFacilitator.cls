public class BatchAllocationMassEmailToFacilitator {
    
    public id ContactId;
    public List<Contact> lstContact;
    public static boolean isError {get;set;}
    public static string errorMsg {get;set;}
    public static boolean showSuccessMsg {get;set;} 
    public static String successMsg {get;set;}
    public static boolean isAnyBatchMsgs {get;set;}
        
    public BatchAllocationMassEmailToFacilitator(ApexPages.StandardSetController controller)
    {   
        lstContact = [SELECT Id, Academic_Year__c, npe01__WorkEmail__c, Name FROM Contact 
                      WHERE Id IN :controller.getSelected()];
    }
    
    public PageReference sendMasssEmailToOneContacts(){
        Decimal CurrentAcademicYear = AntarangSetting__c.getOrgDefaults().Academic_Year__c;
        Decimal NextAcadYear = AntarangSetting__c.getOrgDefaults().Next_Academic_Year__c;	
        Decimal Acadyear = 0.0;
        string strErrorMessage = 'Trainer is not available or Email is not populated. Batches: '; 
        boolean isAnyBatchMsgs = false;
        if(lstContact.size() < 1){
            isError = true;
            errorMsg = 'Please Select a contact';
            isAnyBatchMsgs = true;
            return null;
        }else{
            
            List<Messaging.SingleEmailMessage> lstEmailMesages = new List<Messaging.SingleEmailMessage>();
            
            errorMsg='';
            List<String> str = new List<String>();
            List<String> successString = new List<String>();
            List<String> noBatchString =  new List<String>();
            List<String> inactiveFacilitator =  new List<String>();
            
            for(Contact con: lstContact) { 
                if(String.isNotBlank( con.npe01__WorkEmail__c) && (con.Academic_Year__c == CurrentAcademicYear || con.Academic_Year__c == NextAcadYear)){
                    Acadyear = con.Academic_Year__c;
                    List<Messaging.SingleEmailMessage> email = BatchAllocationEmailToFacilitator.sendMail(con.Id);
                    
                    if(email != null) {
                        successString.add(con.Name);
                        lstEmailMesages.addAll(email);
                    } else {
                        //isAnyBatchError = true;
                        if(validateBatches(con.Id, Acadyear)){
                            isAnyBatchMsgs = true;
                            noBatchString.add(con.Name);
                        }
                        strErrorMessage += ' ' + con.Name;
                    }
                }else{
                    isAnyBatchMsgs = true;
                    if(con.Academic_Year__c != CurrentAcademicYear && con.Academic_Year__c != NextAcadYear){
                        inactiveFacilitator.add(con.Name);
                    }
                    if(String.isBlank( con.npe01__WorkEmail__c)){
                        isAnyBatchMsgs = true;
                        str.add(con.Name);                      
                    }
                }
            }
            if(lstEmailMesages.size() > 0) {
                Messaging.sendEmail(lstEmailMesages);
                isAnyBatchMsgs = true; 
            }
            
            if(isAnyBatchMsgs) { 
                if(str.size() > 0){
                    isError = true;
                    errorMsg = 'Work Email is not Populated in '+ String.join(str,', ');
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMsg));
                }
                if(inactiveFacilitator.size() > 0){
                    isError = true;
                    errorMsg = String.join(inactiveFacilitator,', ')+' Facilitator is inactive for this year ';
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMsg));
                    
                }
                /*else {
                    
                    PageReference pg = new PageReference('/'+Contact.sobjecttype.getDescribe().getKeyPrefix());
                    pg.setRedirect(true);
                    return pg;
                }*/
                if(successString.size() > 0){
                    showSuccessMsg = true;
                    successMsg = 'Email sent successfully to  '+ String.join(successString,', ');
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,successMsg));
                }
                
                if(noBatchString.size() > 0){
                    isError = true;
                    errorMsg = 'Batches not found in '+ String.join(noBatchString,', ');
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMsg));
                }
                return null;
            } else {            
                PageReference pg = new PageReference('/'+Contact.sobjecttype.getDescribe().getKeyPrefix());
                pg.setRedirect(true);
                return pg;
            }
        }
    }
    public static Boolean validateBatches(Id ContactId, Decimal Acadyear){
        Decimal CurrentAcademicYear = AntarangSetting__c.getOrgDefaults().Academic_Year__c;
            List<Batch__c> lstBatch = [SELECT Id
                                       FROM Batch__c
                                       WHERE Allocation_Email_Sent__c = null AND Academic_Year__c =:CurrentAcademicYear 
                                       //AND School_Name__r.Academic_Year__c =:CurrentAcademicYear
                                       //AND Trainer_Name__r.Academic_Year__c =:CurrentAcademicYear
                                       AND School_Name__r.Academic_Year__c =:Acadyear
                                       AND Trainer_Name__r.Academic_Year__c =:Acadyear                                       
                                       AND Trainer_Name__c =: ContactId ];
        if(lstBatch.size() > 0){
            return false;
        }
        return true;
        
    }
    
    public PageReference backToList()
    {
        system.debug(Contact.sobjecttype.getDescribe().getKeyPrefix());
        PageReference pg = new PageReference('/'+Contact.sobjecttype.getDescribe().getKeyPrefix());
        pg.setRedirect(true);
        return pg;
    }
    

}