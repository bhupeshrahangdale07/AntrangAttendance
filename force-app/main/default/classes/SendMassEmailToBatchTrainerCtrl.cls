public class SendMassEmailToBatchTrainerCtrl {
    
    public id batchId;
    public List<Batch__c> lstBatch;
    public static boolean isError {get; set;}
    public SendMassEmailToBatchTrainerCtrl(ApexPages.StandardSetController controller)
    {   
        lstBatch = [SELECT Id,Name, Trainer_Name__c,Batch__c.Trainer_Name__r.Email,Batch__c.Trainer_Name__r.FirstName, Batch__c.Trainer_Name__r.LastName, 
                    Batch__c.School_Name__r.Medium_Language_of_Instruction__c,Batch__c.Preferred_Language__c, Batch__c.Date_of_facilitation_starting__c, Batch__c.Date_of_facilitation_completion__c, 
                    Batch__c.School_Name__r.Est_Number_of_Students_in_Grade_9_19_20__c, Batch__c.Batch_Number__c, School_Name__c, Combined_Batch_no__c, School_Name__r.Approx_school_attendance_20_21__c,
                    Batch__c.School_Name__r.School_Location__c,Batch__c.School_Name__r.Principal_Name__c,Batch__c.School_Name__r.Name,
                    Batch__c.School_Name__r.Phone,Batch__c.School_Name__r.Principal_Contact_2__c,Batch__c.School_Name__r.Principal_Contact_3__c,Batch__c.School_Name__r.Estimated_Number_Of_Students__c
                    FROM Batch__c
                    WHERE Id IN :controller.getSelected()];
    }
    
    public PageReference sendMasssEmailToOneTrainer(){
        List<Messaging.SingleEmailMessage> lstEmailMesages = new List<Messaging.SingleEmailMessage>();
        string strErrorMessage = 'Trainer is not available or Email is not populated. Batches: '; 
        boolean isAnyBatchError = false;
        for(Batch__c batch: lstBatch) {    
            Messaging.SingleEmailMessage email = SendEmailToBatchTrainerCtrl.sendMail(batch);
            if(email != null) {
                lstEmailMesages.add(email);
            } else {
                isAnyBatchError = true;
                strErrorMessage += ' ' + batch.Name;
            }
        }
        if(lstEmailMesages.size() > 0) {
            Messaging.sendEmail(lstEmailMesages);
        }
        if(isAnyBatchError) { 
            isError = true;   
            apexpages.addmessage(new apexpages.message(apexpages.severity.error, strErrorMessage));
            return null;
        } else {
            PageReference pg = new PageReference('/'+Batch__c.sobjecttype.getDescribe().getKeyPrefix());
            pg.setRedirect(true);
            return pg;
        }
    }
    
    public PageReference backToList()
    {
        system.debug(Batch__c.sobjecttype.getDescribe().getKeyPrefix());
        PageReference pg = new PageReference('/'+Batch__c.sobjecttype.getDescribe().getKeyPrefix());
        pg.setRedirect(true);
        return pg;
    }
    
}