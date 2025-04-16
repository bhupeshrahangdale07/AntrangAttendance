/*
Description: Send Email to Batch Trainer from batch.
*/
public class SendEmailToBatchTrainerCtrl {
    
    public static id batchId;
    public static boolean isError {get; set;}
    
    public SendEmailToBatchTrainerCtrl(ApexPages.StandardController controller) {
        batchId = controller.getId();
        isError = false;
    }
    
    public PageReference sendEmailToOneTrainer()
    {
        List<Batch__c> lstBatch = [SELECT Id, Trainer_Name__c,Batch__c.Trainer_Name__r.Email,Batch__c.Trainer_Name__r.FirstName, Batch__c.Trainer_Name__r.LastName, 
                                   Batch__c.School_Name__r.Medium_Language_of_Instruction__c,Batch__c.Preferred_Language__c, Batch__c.Date_of_facilitation_starting__c, Batch__c.Date_of_facilitation_completion__c, 
                                   Batch__c.School_Name__r.Est_Number_of_Students_in_Grade_9_19_20__c, Batch__c.Batch_Number__c, School_Name__c,Combined_Batch_no__c,Batch__c.School_Name__r.Approx_school_attendance_20_21__c,
                                   Batch__c.School_Name__r.School_Location__c,Batch__c.School_Name__r.Principal_Name__c,Batch__c.School_Name__r.Name,
                                   Batch__c.School_Name__r.Phone,Batch__c.School_Name__r.Principal_Contact_2__c,Batch__c.School_Name__r.Principal_Contact_3__c,Batch__c.School_Name__r.Estimated_Number_Of_Students__c
                                   FROM Batch__c
                                   WHERE Id = : batchId Limit 1];
                                   
        if(lstBatch.size() > 0) {
            List<Messaging.SingleEmailMessage> lstEmailMesages = new List<Messaging.SingleEmailMessage>();
            
            Messaging.SingleEmailMessage email = sendMail(lstBatch[0]);
            system.debug('email :: ' + email);
            if(email != null) {
                lstEmailMesages.add(email);
            } else {
                isError = true;
            }
            if(lstEmailMesages.size() > 0) {
                Messaging.sendEmail(lstEmailMesages);
            }
            if(isError) {    
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Trainer is not available or Email is not populated.'));
                return null;
            } else {
                PageReference pg = new PageReference('/'+batchId);
                pg.setRedirect(true);
                return pg;
            }
        }
        return null;
    }
    
    public static Messaging.SingleEmailMessage sendMail(Batch__c batch) {
        Messaging.SingleEmailMessage email;
        system.debug(batch.Trainer_Name__r.Email);
        if(batch != null && batch.Trainer_Name__c != null && string.isnotblank(batch.Trainer_Name__r.Email)) {
            email = new Messaging.SingleEmailMessage();
            string[] to = new string[] {batch.Trainer_Name__r.Email};
                
            email.setToAddresses(to);
            
            //email.setSubject('School Details for Career-Week');
            email.setSubject('School details for grade 9 sessions'); //changed subject on 21st July 2021
            string htmlBody = 'Dear ' + (batch.Trainer_Name__r.FirstName != null ? batch.Trainer_Name__r.FirstName : '') + ' ' + (batch.Trainer_Name__r.LastName != null ? batch.Trainer_Name__r.LastName : '') + ', <br/><br/>Please find below the school details of your grade 9 sessions. ';
            /*if(batch.Date_of_facilitation_starting__c != null) {
                htmlBody += batch.Date_of_facilitation_starting__c.format('dd-MM-yyyy');
            } else {
                htmlBody += '-';
            }
            htmlBody += ' to ';
            if(batch.Date_of_facilitation_completion__c != null) {
                htmlBody += batch.Date_of_facilitation_completion__c.format('dd-MM-yyyy');
            } else {
                htmlBody += '-';
            }*/
            htmlBody += '<br/><br/>Name of the School: ' + batch.School_Name__r.Name + '<br/>Principal\'s Contact: ';
            
            if(batch.School_Name__r.Principal_Name__c != null) {
                htmlBody += batch.School_Name__r.Principal_Name__c;
            } 
            
            if(batch.School_Name__r.Phone != null){
                //system.debug('%%% ' + batch.School_Name__r.Phone);
                htmlBody += ' - ' + batch.School_Name__r.Phone;
            }
            
            if(String.isNotBlank(batch.School_Name__r.Principal_Contact_2__c)){
                //system.debug('&&& ' + batch.School_Name__r.Principal_Contact_2__c);
                if(batch.School_Name__r.Phone == null) { htmlBody += ' - ' + batch.School_Name__r.Principal_Contact_2__c; }
                else { htmlBody += ', ' + batch.School_Name__r.Principal_Contact_2__c; }
            }
            
            if(String.isNotBlank(batch.School_Name__r.Principal_Contact_3__c)){
                //system.debug('$$$ ' + batch.School_Name__r.Principal_Contact_3__c);
                if(batch.School_Name__r.Phone == null && batch.School_Name__r.Principal_Contact_2__c == null) { htmlBody += ' - ' + batch.School_Name__r.Principal_Contact_3__c; }
                else { htmlBody += ', ' + batch.School_Name__r.Principal_Contact_3__c; }
            }
            
            htmlBody += '<br/>Address: ';
            
            if(batch.School_Name__r.School_Location__c != null) {
                htmlBody += batch.School_Name__r.School_Location__c;
            }
            
            htmlBody += '<br/>Language: ';
            
            if(String.isNotBlank(batch.School_Name__r.Medium_Language_of_Instruction__c))
            {
                htmlBody += batch.School_Name__r.Medium_Language_of_Instruction__c;
            } else {
                htmlBody += '-';
            }
            
            /*htmlBody += '<br/>Approx. school attendance :  ';
            
            if(batch.School_Name__r.Approx_school_attendance_20_21__c != null)
            {
                htmlBody += batch.School_Name__r.Approx_school_attendance_20_21__c;
            } else {
                htmlBody += '-';
            }*/
            
            /*htmlBody+= '<br/>Time: ';
            if(batch.Date_of_facilitation_starting__c != null) {
                htmlBody += batch.Date_of_facilitation_starting__c.format('hh:mm a');
            } else {
                htmlBody += '-';
            }
            htmlBody += ' to ';
            
            if(batch.Date_of_facilitation_completion__c != null) {
                htmlBody += batch.Date_of_facilitation_completion__c.format('hh:mm a');
            } else {
                htmlBody += '-';
            }*/
            
            string ccEmails = System.Label.Batch_Details_CC_Emails;
            List<String> sendingTocAdd = new List<String>();
            if(String.isNotBlank(ccEmails))
            {
                sendingTocAdd = ccEmails.split(';');
            }
            if(sendingTocAdd.size() > 0)
            {
                email.setCcAddresses(sendingTocAdd);   
            }
            
            htmlBody += '<br/>Batch code: '+ batch.Batch_Number__c + '<br/>';//Additional details will be communicated to you in a separate email.<br/><br/>';
            if(batch.Combined_Batch_no__c != null ){
                htmlBody += '<br/><b><i>**This batch has been merged with ' + string.valueof(batch.Combined_Batch_no__c ) +' due to the small batch size.**</i></b><br/>';
            }
            //htmlBody += '<br/>Further details will be communicated to you in a separate mail.<br/><br/>';
            htmlBody += '<br/><br/><i style="color:red;">This is an auto-generated email. Please do not reply to it. In case of any concerns or queries, please contact the Program Team.</i>';
            htmlBody += '<br/><br/>Thanks and Regards,<br/>CareerAware Program Team';
            email.setHtmlBody(htmlBody);
            try{
                //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
                return email;
            }catch(exception e){
                isError = true;
                apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
            }
        } 
        return email;
    }
}