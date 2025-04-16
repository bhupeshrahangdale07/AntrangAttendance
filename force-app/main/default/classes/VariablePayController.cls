public without sharing class VariablePayController {
    public static Map<Id,contact> contactMap;
    public static boolean recursionHandler = true;
     @AuraEnabled
    public static string financeVariablePayoutFile(Date invoiceDate, String email){
        try{
            List<Session__c> sessionLST = new List<Session__c>([SELECT Id,Batch__r.School_Name__r.District__r.name, Session_Code__c, Session__c.Number_of_Sessions_No_of_Units__c,Session__c.Session_Amount__c,Session_Grade__c,  Session_Type__c, Name, SessionDate__c, Session_Start_Time__c,Invoice_Date__c,Total_Amount__c,  
                                                            Payment_Status__c, Attendance_Count__c, Total_Student_Present__c, Total_Parent_Present__c  , 
                                                            Batch__r.Grade__c, Batch__r.Batch_Number__c, Batch__r.Name, Batch__r.Date_of_facilitation_starting__c, Batch__r.Date_of_facilitation_completion__c,
                                                            Batch__r.Donor_Name__r.Name, Batch__r.Dummy_Batch_Created__c, Batch__r.Dummy_Batch__c, Batch__r.Copy_of_Batch__c,  
                                                            
                                                            Batch__r.School_District__c,  Batch__r.School_Name__r.Enrolled_Grade_9__c, Batch__r.School_Name__r.Enrolled_Grade_10__c,Batch__r.School_Name__r.Enrolled_Grade_11__c, 
                                                            
                                                            Assigned_Facilitator__r.Name, Assigned_Facilitator__r.npe01__WorkEmail__c, 
                                                            Assigned_Facilitator__r.PAN_Number__c, Assigned_Facilitator__r.MailingAddress, Assigned_Facilitator__r.MailingCity, Assigned_Facilitator__r.Bank_Account_No__c,
                                                            Assigned_Facilitator__r.IFSC_Code__c, Assigned_Facilitator__r.Branch_Name__c, Assigned_Facilitator__r.Bank_City__c, Assigned_Facilitator__r.TDS_Applicable__c,
                                                            TDS_Deduction__c,Assigned_Facilitator__r.Bank_Name__c, 
                                                            Assigned_Facilitator__r.MailingStreet, Assigned_Facilitator__r.MailingState, Assigned_Facilitator__r.MailingPostalCode,
                                                            Assigned_Facilitator__c,Proposal_Date__c,status__c  from Session__c  Where Proposal_Date__c  =: invoiceDate and status__c = 'Invoice Generated'
                                                           ]);
        	system.debug('sessionLST : ' + sessionLST);
            Set<Id> assignedFacilitatorIds = new Set<Id>();
            String header ='Session Id,Session Code,Session Type,Session Grade,Session Name,Session Date,Individual Attendance,No.of Batch,Rate (Per Session),Total Amount,Invoice Date,Payment Status,Batch Number	,Batch Name,Donor Name,	School District,Assigned Facilitator,Work Email,PAN Number,MailingAddress,MailingCity,Bank Account No.,IFSC Code,Branch Name,Bank City,TDS Applicable,TDS Deduction,Bank Name \n';
            String finalstr = header;
            if(sessionLST.size() > 0){
                for(Session__c obj:sessionLST){
                    assignedFacilitatorIds.add(obj.Assigned_Facilitator__c);
                    String mailingAddress = obj.Assigned_Facilitator__r.MailingStreet+', '+obj.Assigned_Facilitator__r.MailingCity+', '+obj.Assigned_Facilitator__r.MailingState+', '+obj.Assigned_Facilitator__r.MailingPostalCode;
                    String accNumber = '';
                    if(obj.Assigned_Facilitator__r.Bank_Account_No__c != null){
                        system.debug('Account number : '+obj.Assigned_Facilitator__r.Bank_Account_No__c);
                        accNumber = obj.Assigned_Facilitator__r.Bank_Account_No__c.replaceAll('\'', '');
                        system.debug('Account number : '+accNumber);
                    }
                    String Recordstring = '"'+obj.Id+'","'+obj.Session_Code__c+'","'+obj.Session_Type__c+'","'+obj.Session_Grade__c+'","';
                    Recordstring += obj.Name+'","'+obj.SessionDate__c+'","'+obj.Attendance_Count__c+'","'+obj.Number_of_Sessions_No_of_Units__c+'","'+'INR'+obj.Total_Amount__c+'","'+'INR'+obj.Session_Amount__c+'","'+obj.Invoice_Date__c+'","';
                    Recordstring += obj.Payment_Status__c+'","'+obj.Batch__r.Batch_Number__c+'","'+obj.Batch__r.Name+'","'+obj.Batch__r.Donor_Name__r.Name+'","'+obj.Batch__r.School_Name__r.District__r.name+'","';
                    Recordstring += obj.Assigned_Facilitator__r.Name+'","'+obj.Assigned_Facilitator__r.npe01__WorkEmail__c+'","'+obj.Assigned_Facilitator__r.PAN_Number__c+'","'+obj.Assigned_Facilitator__r.MailingStreet+'","'+obj.Assigned_Facilitator__r.MailingCity+'","'+obj.Assigned_Facilitator__r.Bank_Account_No__c+'","';
                    Recordstring += obj.Assigned_Facilitator__r.IFSC_Code__c+'","'+obj.Assigned_Facilitator__r.Branch_Name__c+'","'+obj.Assigned_Facilitator__r.Bank_City__c+'","'+obj.Assigned_Facilitator__r.TDS_Applicable__c+'","10%","'+obj.Assigned_Facilitator__r.Bank_Name__c+'",\n';
                    finalstr = finalstr+Recordstring;
                }
                finalstr = finalstr.replace('null', ' ');
                String[] toAddresses = new String[]{email};
                String[] ccAddresses = Label.Facilitator_Var_Payment_Finance_CC.split(',');
                String subject = 'Email for Payout Proposal';
                string body = 'Dear Finance Team,<br/><br/>Please find the attached Invoices and Session details for the date: <b>'+String.valueOf(invoiceDate.day()).leftPad(2, '0')+'/'+String.valueOf(invoiceDate.month()).leftPad(2, '0')+'/'+String.valueOf(invoiceDate.year())+'</b><br/><br/>Thanks and Regards,<br/>CareerAware Team';
                String attachmentFileName = 'payoutProposalOfConsultancy_Bill_'+String.valueOf(invoiceDate.day()).leftPad(2, '0')+'_'+String.valueOf(invoiceDate.month()).leftPad(2, '0')+'_'+String.valueOf(invoiceDate.year())+'.csv';
                Blob attachmentBody = blob.valueOf(finalstr);
                String attachmentContentType = 'text/csv';
                Messaging.SingleEmailMessage mail = sendEmailWithAttachment(toAddresses, subject, body, attachmentFileName, attachmentBody, attachmentContentType,true,ccAddresses);
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                for (Messaging.SendEmailResult mr : r) {
                    if (mr.isSuccess()) {
                        return 'success';
                    }else{
                        for(Messaging.SendEmailError err : mr.getErrors()) {
                            system.debug('The following error has occurred.');                    
                            system.debug(err.getStatusCode() + ': ' + err.getMessage());
                            system.debug('fields that affected this error: ' + err.getFields());
                            return 'Error while sending mail: ' + err.getMessage();
                        }
                    }
                }
            }else{
                return 'No records found';
            }
            
        }catch(exception e){
            system.debug('VariablePayController.financeVariablePayoutFile, e.getMessage() : ' + e.getMessage());
            system.debug('VariablePayController.financeVariablePayoutFile, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        return '';
    }
	@AuraEnabled
    public static string approveRejectPayout(string jsonData,string status, datetime invoiceDate,string email) {
        try{
            Date d = invoiceDate.date();
            date tempdate = d.addMonths(-1);
            date dt = tempdate;
            boolean recursionHandler = false;
            DateTime currentDateTime = DateTime.now();
            list<ContentVersion> contentVersionLst = new List<ContentVersion>();
            set<Id> conIds = new set<Id>();
            Set<Id> sessionIds = new Set<Id>();
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            list<session__c> sessionList = new list<session__c>();
            list<sessionWrapper> wrpData = (list<sessionWrapper>) JSON.deserialize(jsonData, list<sessionWrapper>.class);
            for(sessionWrapper wrp : wrpData){
                session__c sessionData = new session__c();
                sessionData.Id = wrp.SessionId;
                if(status == 'rejected'){
                    sessionData.Status__c = 'Proposal Rejected';
                }else{
                    date inv = invoiceDate.date();
                    sessionData.Invoice_Date__c = inv;
                    if(wrp.Checkbox == true && wrp.DeferredReason != 'Not to be Paid'){
                        sessionData.Status__c = 'Invoice Generated';
                        sessionData.Payment_Status__c = 'Payment Made'; 
                        sessionIds.add(wrp.SessionId);
                        if(wrp.FacilitatorId != null){
                            conIds.add(wrp.FacilitatorId);
                        }
                    }else if(wrp.DeferredReason =='Not to be Paid'){
                        SessionData.Payment_Status__c = 'Do not pay'; 
                    }
                    else{
                        sessionData.Status__c = 'Proposal Approved';
                        sessionData.Payment_Status__c = 'Deferred for payment';
                    }
                }
                sessionList.add(sessionData);
            }
            if(sessionList.size() > 0){
                District_Master__c dist = [select id, Payout_Admin_Password__c, Payout_Admin_Username__c, Payout_Supervisor_Password__c, 
                                       Payout_Supervisor_Username__c, name from District_Master__c  where Payout_Supervisor_Username__c = :email limit 1];
                if(status == 'rejected'){
                    
                    String[] toAddresses = new String[]{dist.Payout_Admin_Username__c};
                    String[] ccAddresses = Label.Facilitator_Var_Payment_Admin_CC.split(',');
                    String subject = 'Email for Payout Proposal';
                    string body = 'Dear Admin ,<br/><br/>Your Payout Proposal is rejected for date: <b>' + String.valueOf(invoiceDate.day()).leftPad(2, '0')+'/'+String.valueOf(invoiceDate.month()).leftPad(2, '0')+'/'+String.valueOf(invoiceDate.year()) +'<br/><br/>Thanks and Regards,<br/>CareerAware Team';
                    String attachmentFileName = '';
                    Blob attachmentBody = Blob.valueOf('');
                    String attachmentContentType = '';
                    Messaging.SingleEmailMessage aminMail = sendEmailWithAttachment(toAddresses, subject, body, attachmentFileName, attachmentBody, attachmentContentType, false,ccAddresses);
                    
                    mailList.add(aminMail);
                }else{
                    contactMap = new Map<Id,Contact>([select Id,Name, npe01__WorkEmail__c, Email,Batch_Code__c from contact where Id IN: conIds]);
					Map<Id,list<Session__c>> facilitatorSessionMap = new Map<Id,list<session__c>>();
                    for(Session__c s : [select id, Session_Type__c, Name, No_of_batches_for_counseling__c, Dummy_Session__c, Total_Amount__c,Batch__r.Donor_Name__c,Session_Grade__c,
                            Batch__r.School_Name__c,Batch__r.School_Name__r.Name,Assigned_facilitator__c,Session_Amount__c,Number_of_Sessions_No_of_Units__c, Assigned_facilitator__r.npe01__WorkEmail__c
                            from Session__c WHERE Id IN:sessionIds AND Payment_Status__c IN ('Ready For Payment', 'Deferred for Payment') ]){
                                if(!facilitatorSessionMap.containsKey(s.Assigned_facilitator__c))
                                    facilitatorSessionMap.put(s.Assigned_Facilitator__c, new List<session__c>());
                                facilitatorSessionMap.get(s.Assigned_Facilitator__c).add(s);
                    }
                    if(facilitatorSessionMap.keyset().size()>0){
                        Map<Id, List<ContentDocumentLink>> ContentDocumentLnkMap = new Map<Id, List<ContentDocumentLink> >();
                        for(ContentDocumentLink cd : [SELECT id, ContentDocument.title, LinkedEntityId from ContentDocumentLink where ContentDocument.title Like 'Consultancy_Bill_%' AND LinkedEntityId IN :facilitatorSessionMap.keyset() ORDER BY ContentDocument.createdDate DESC ] ){
                            if(ContentDocumentLnkMap.containsKey(cd.LinkedEntityId)){
                                ContentDocumentLnkMap.get(cd.LinkedEntityId).add(cd);
                            }else{                    
                                ContentDocumentLnkMap.put(cd.LinkedEntityId,new List<ContentDocumentLink>{cd});
                            }
                        }
                        for(Id facilitator : facilitatorSessionMap.keyset()){
                            Integer count = ContentDocumentLnkMap.containsKey(facilitator)? ContentDocumentLnkMap.get(facilitator).size():0;
                            count++;
                            List<Session__c> sessionLst = facilitatorSessionMap.get(facilitator);
                            list<wrapResult> wplst = new list<wrapResult>();
                            decimal Total = 0;
                            for (Session__c session : sessionLst) {
                                wrapResult w = new wrapResult();
                                w.description = session.Session_Grade__c;
                                w.SessionType = session.Session_Type__c;
                                w.rate = session.Total_Amount__c;
                                w.schoolName = session.Batch__r.School_Name__r.Name;
                                w.NumOfSession =  integer.valueOf(session.Number_of_Sessions_No_of_Units__c);    
                                w.amount = session.Session_Amount__c;
                                w.sessionName = session.Name;
                                
                                wplst.add(w);
                                Total+=w.amount;
                            }
                            PageReference word = Page.VariablePayInvoiceGenerationPage;
                            word.getParameters().put('Id',contactMap.get(facilitator).id);
                            word.getParameters().put('month', String.valueOf(invoicedate.month()));
                            word.getParameters().put('Map',JSON.serialize(wplst));
                            word.getParameters().put('Total',String.valueOf(Total));
                            word.getParameters().put('selectedMonthYear',String.valueOf(date.newInstance(d.year(),d.month(),d.day())));
                            word.getParameters().put('invoicedate',String.valueOf(d.day()).leftPad(2, '0')+'-'+String.valueOf(d.month()).leftPad(2, '0')+'-'+d.year());
                            word.getParameters().put('invNum',String.valueOf(String.valueOf(count).leftPad(3, '0')));
                            Blob body;
                            blob pdfbody;
                            if(!test.isRunningTest()){
                                //body = word.getContent();
                                system.debug('word = '+word);
                                pdfbody = word.getContentAsPDF();
                            }else{
                                //body = blob.valueof('TEST');
                                pdfbody = blob.valueof('TEST');
                            }
                            ContentVersion conVer = new ContentVersion();
                            conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
                            conVer.PathOnClient = 'Consultancy_Bill_'+String.valueOf(d.day()).leftPad(2, '0')+'/'+String.valueOf(d.month()).leftPad(2, '0')+'/'+d.year()+'_'+contactMap.get(facilitator).Name+'.pdf'; // The files name, extension is very important here which will help the file in preview.
                            conVer.Title = 'Consultancy_Bill_'+String.valueOf(d.day()).leftPad(2, '0')+'/'+String.valueOf(d.month()).leftPad(2, '0')+'/'+d.year()+'_'+contactMap.get(facilitator).Name+'_'+String.valueOf(count).leftPad(3, '0');
                            conVer.VersionData = pdfbody; 
                            conVer.Record_Id__c = contactMap.get(facilitator).Id;
                            contentVersionLst.add(conVer);
                            
                            string htmlBody = 'Dear '+contactMap.get(facilitator).Name+',<br/><br/>Thank you for your engagement with us and with our students last month.';
                            htmlBody += '<br/><br/>Please find your payment details for the month of '+invoiceDate.format('MMMM')+' '+invoiceDate.year();
                            htmlBody += '<br/><br/><table border="1" style="text-align:center" width="100%"><tr><th>Sr.No</th><th>School Name</th><th>Grade</th><th>Session Name</th><th>No. of Sessions</th><th>Amount</th></tr>';
                            integer k = 0;
                            for(wrapResult wrp :wplst){
                                htmlBody += '<tr><td>'+(k+1)+'</td><td>'+wrp.schoolName+'</td><td>'+wrp.description+'</td><td>'+wrp.sessionName+'</td><td>'+wrp.NumOfSession+'</td><td>'+wrp.amount+'</td></tr>';
                            }
                            htmlBody += '</table>';
                            htmlBody += '<br/><br/> <b style="text-decoration: underline;">NOTE:-</b><ul><li>There will be a 10% TDS deduction on every session payment.</li><li>Payment cycle starts from 23rd of May to 22nd of June.</li><li>Only sessions where the data submitted by the 22nd of the month EOD has been considered for the payout.</li><li>Your consultancy fee has been calculated based on whether you have submitted the deliverable including the accurate student data as per the timelines mentioned in the "Operational Guidelines Document".</li><li>If the delay in submitting OMR sheets or other applicable school documents is beyond the timeline mentioned in the "Operational Guidelines Document", then payment for that particular session might be withheld. Any further a decision on the same will be upto Antarang Foundation’s discretion.</li></ul>';
                            htmlBody += '<br/><br/> <b style="text-decoration: underline;">Next Steps (for you):-</b><ul><li>Please Resend the Signed Invoices to '+dist.Payout_Admin_Username__c+' ,  failing which we cannot proceed with the payment.</li><li>Refer to the <a href="https://docs.google.com/document/d/14kPi1L9w7XnDP1Zj_bqFq4G2FiyfPMfoeJAicFYQd0M/edit">Operational Guidelines 2023-24</a> to know the steps for signing the invoices, timelines for students data submission.</li></ul>';
                            htmlBody += '<br/><br/>Thanks and Regards,<br/>CareerAware Team';
                            
                            String[] toAddresses = new String[]{contactMap.get(facilitator).npe01__WorkEmail__c};
                                String[] ccAddresses = Label.Facilitator_Var_Payment_InvoiceGenerated_CC.split(',');
                            String subject = 'Invoice for the month of '+invoiceDate.format('MMMM');
                            String attachmentFileName = 'Invoice_for_'+invoiceDate.format('MMMM')+'_'+invoiceDate.year()+'_'+contactMap.get(facilitator).Name+'_'+String.valueOf(count).leftPad(3, '0')+'.pdf';
                            Blob attachmentBody = pdfbody;
                            String attachmentContentType = 'application/pdf';
                            Messaging.SingleEmailMessage mail = sendEmailWithAttachment(toAddresses, subject, htmlBody, attachmentFileName, attachmentBody, attachmentContentType, true,ccAddresses);                                
                            mailList.add(mail);
                        }
                    }
                }
                recursionHandler = true;
                if(sessionList.size() > 0) update sessionList;
                if(mailList.size() > 0){
                    
                    if(contentVersionLst.size()>0) {
                        insert contentVersionLst;
                        list<ContentDocumentLink> cdlLst = new list<ContentDocumentLink>();
                        for(ContentVersion cv : [SELECT ContentDocumentId,Record_Id__c FROM ContentVersion WHERE Id IN: contentVersionLst]){
                            ContentDocumentLink cDe = new ContentDocumentLink();
                            cDe.ContentDocumentId = cv.ContentDocumentId;
                            cDe.LinkedEntityId = cv.Record_Id__c; //  objectId
                            cDe.ShareType = 'V'; // Inferred permission
                            cDe.Visibility = 'AllUsers';
                            cdlLst.add(cde);
                        }
                        insert cdlLst;   
                    }
                     
                	
                    Messaging.sendEmail(mailList);
                    
                }
                return 'success';
            }else{
                return 'fail';
            }
        }catch(exception e){
            system.debug('VariablePayController.approveRejectPayout, e.getMessage() : ' + e.getMessage());
            system.debug('VariablePayController.approveRejectPayout, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static Object  getSessions(Date invoiceDate, String Facilitator, String DonorId, String SchoolId, String BatchId, String Grade){
        try{
            AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
            set<Decimal> setAcademicYear = new set<Decimal>();
            if(setting.Academic_Year__c != null){setAcademicYear.add(setting.Academic_Year__c);}
            if(setting.Next_Academic_Year__c != null){setAcademicYear.add(setting.Next_Academic_Year__c);}
            List<sessionWrapper> sessionWrapperLst = new List<sessionWrapper>();
            Map<String, Object> result = new Map<String, Object>();
            list<session__c> lstUpdatedSession = [select id from session__c where Proposal_Date__c = :invoiceDate];
            String query;
            if(lstUpdatedSession.size() != 0){
                query = 'SELECT id, Name, Number_of_Sessions_No_of_Units__c,Proposal_Date__c, Session_Amount__c, Session_Code__c, Copy_of_Session__c, Present_Count__c, Dummy_Session_Created__c, Parent_Session_Code__c, SessionDate__c, Session_Grade__c, Attendance_Count__c, Dummy_Session__c, Total_Student_Present__c, Batch__r.Name, Batch__r.Batch_Number__c, Assigned_Facilitator__c, Deferred_Reason__c, Assigned_Facilitator__r.Name, Payment_Status__c,Total_Amount__c,Status__c,Active_Checkbox__c FROM Session__c WHERE Proposal_Date__c =:invoiceDate'; /*AND Batch__r.Academic_Year__c in: setAcademicYear*/
            }else{
                query = 'SELECT id, Name, Number_of_Sessions_No_of_Units__c, Proposal_Date__c,Session_Amount__c, Session_Code__c, Copy_of_Session__c, Present_Count__c, Dummy_Session_Created__c, Parent_Session_Code__c, SessionDate__c, Session_Grade__c, Attendance_Count__c, Dummy_Session__c, Total_Student_Present__c, Batch__r.Name, Batch__r.Batch_Number__c, Assigned_Facilitator__c, Deferred_Reason__c, Assigned_Facilitator__r.Name, Payment_Status__c,Total_Amount__c,Status__c,Active_Checkbox__c FROM Session__c WHERE Payment_Status__c IN (\'Ready For Payment\', \'Deferred for Payment\') AND SessionDate__c <=:invoiceDate AND Assigned_Facilitator__r.Academic_Year__c in: setAcademicYear';
            }
            if(String.isNotBlank(Facilitator)){
                query = query+' AND Assigned_Facilitator__c = :Facilitator';
            }
            if(String.isNotBlank(DonorId)){
                query = query+' AND batch__r.Donor_Name__c = :DonorId';
            }
            if(String.isNotBlank(SchoolId)){
                query = query+' AND batch__r.School_Name__c = :SchoolId';
            }
            if(String.isNotBlank(BatchId)){
                query = query+' AND Batch__c  = :BatchId';
            }
            if(String.isNotBlank(Grade)){
                query = query+' AND Session_Grade__c = :Grade';
            }
            query = query+' ORDER BY Parent_Session_Code__c,Name ';
            List<Session__c> sessionLst = Database.query(query);
            for(Session__c s:sessionLst){   
                sessionWrapper wrap = new sessionWrapper();
                wrap.SessionId = s.Id;
                wrap.Name = s.Name;
                wrap.SessionDate = s.SessionDate__c;
                
                wrap.SessionGrade = s.Session_Grade__c;
                wrap.PresentCount = s.Present_Count__c;
                wrap.AttendanceCount = s.Attendance_Count__c;
                 wrap.ProposalDate = s.Proposal_Date__c;
                wrap.TotalStudentsPresent = s.Total_Student_Present__c;
                
                wrap.NumberofSessionsNoofUnits = s.Number_of_Sessions_No_of_Units__c;
                wrap.SessionAmount = s.Session_Amount__c;
                
                wrap.SessionCode = s.Session_Code__c;
                wrap.DummySession = s.Dummy_Session__c;
                wrap.DummySessionAvailable = s.Dummy_Session_Created__c;
                wrap.ParentSessionCode = s.Copy_of_Session__c;
                
                wrap.BatchId = s.Batch__c;
                wrap.BatchName = s.Batch__c != null ?s.Batch__r.Name:'';
                wrap.BatchNumber = s.Batch__c != null ?s.Batch__r.Batch_Number__c:'';
                wrap.FacilitatorName = s.Assigned_Facilitator__c != null ? s.Assigned_Facilitator__r.Name:'';
                wrap.FacilitatorId = s.Assigned_Facilitator__c;
                wrap.PaymentStatus = s.Payment_Status__c;
                wrap.Rate = s.Total_Amount__c;
                wrap.Status = s.Status__c;
                wrap.DeferredReason = s.Deferred_Reason__c;
                wrap.errorMessage = 'Complete this field.';
                wrap.showError = false;
                wrap.Checkbox = s.Active_Checkbox__c;
                system.debug('tet : '+wrap);
                sessionWrapperLst.add(wrap);   
            }
            result.put('sessionData', sessionWrapperLst);
            result.put('deferredReason', StudentOMRManagerController.getdynamicpicklistval('Session__c','Deferred_Reason__c'));
            system.debug('result = '+result);
            return result;
        } catch (Exception e) {
            system.debug('te : '+e);
            throw new AuraHandledException(e.getMessage());
            //return null;
        }
    }
    @AuraEnabled
    public static List<String> getPicklistValues() {
        List<String> picklistValues = new List<String>();
        String objectApiName = 'Batch__c'; // API name of the object
        String fieldApiName = 'Grade__c'; // API name of the picklist field
        try {
            Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap().get(fieldApiName).getDescribe();
            if (fieldResult.isAccessible() && fieldResult.getType() == Schema.DisplayType.PICKLIST) {
                List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
                for (Schema.PicklistEntry picklistEntry : picklistEntries) {
                    picklistValues.add(picklistEntry.getValue());
                }
            }
        } catch (Exception e) {
            System.debug('Error retrieving picklist values: ' + e.getMessage());
        }
        
        return picklistValues;
    }
    @AuraEnabled
    public static String saveSessions(List<sessionWrapper> wrapList, string checkAction, date invoiceDate, string email){
        District_Master__c dist = [select id, Payout_Admin_Password__c, Payout_Admin_Username__c, Payout_Supervisor_Password__c, 
                                       Payout_Supervisor_Username__c, name from District_Master__c  where Payout_Admin_Username__c = :email limit 1];
        boolean recursionHandler = false;
        String header ='Batch Number, Batch Name, Facilitator Name, Session Name, Session Date, Session Grade, Present Count, Attendance Count, Number of Students Attending, Calculated number of sessions (No of Units) ,Rate, Payment , Deferred Reason, Status \n';
        String finalstr = header;
        List<Session__c> updateLst = new List<Session__c>();
        system.debug('Save session');
        for(sessionWrapper obj:wrapList){
            Session__c s = new Session__c();
            s.Id = obj.SessionId;
            s.Active_Checkbox__c = obj.Checkbox;
            s.Deferred_Reason__c = obj.DeferredReason;
            if(checkAction== 'save'){
                s.Status__c = 'Proposal Saved';
            }else if(checkAction == 'submit'){
                s.Status__c = 'Proposal Submitted';
                s.Proposal_Date__c= invoiceDate;
                String Recordstring = '"'+obj.BatchNumber+'","'+obj.BatchName+'","'+obj.FacilitatorName+'","'+obj.Name+'","'+obj.SessionDate+'","'+obj.SessionGrade+'","'+obj.PresentCount+'","'+obj.AttendanceCount+'","'+obj.TotalStudentsPresent+'","'+obj.NumberofSessionsNoofUnits+'","'+obj.SessionAmount+'","'+obj.Rate+'","'+obj.DeferredReason+'","'+s.Status__c+'",\n';
                finalstr = finalstr+Recordstring;
                finalstr = finalstr.replace('null','');
            }
            
            // if(wrap.DummySession && wrap.DeferredReason == 'Parent/Main batch attendance is lower than40' ){
            //     s.Payment_Status__c = 'Do not pay';
            // }
            //s.Deferred_Reason__c = wrap.DeferredReason;
            
            updateLst.add(s);
        }
        
        if(updateLst.size() > 0){
            system.debug('test updates sessions : '+updateLst);
            try{
                recursionHandler = true;
                update updateLst;
                if(checkAction == 'submit'){
                    String[] toAddresses = new String[]{dist.Payout_Supervisor_Username__c};
                    String[] ccAddresses = Label.Facilitator_Var_Payment_Supervisor_CC.split(',');
                    String subject = 'Email for Payout Proposal';
                    String body = 'Dear Supervisor,<br/><br/>Please find attached payout proposal for the Consultancy Bill date: <b>'+String.valueOf(invoiceDate.day()).leftPad(2, '0')+'/'+String.valueOf(invoiceDate.month()).leftPad(2, '0')+'/'+String.valueOf(invoiceDate.year())+'</b><br/><br/>Thanks and Regards,<br/>CareerAware Team';
                    String attachmentFileName = 'payoutProposalOfConsultancyBill__'+String.valueOf(invoiceDate.day()).leftPad(2, '0')+'_'+String.valueOf(invoiceDate.month()).leftPad(2, '0')+'_'+String.valueOf(invoiceDate.year())+'.csv';
                    Blob attachmentBody = blob.valueOf(finalstr);
                    String attachmentContentType = 'text/csv';
                    Messaging.SingleEmailMessage mail = sendEmailWithAttachment(toAddresses, subject, body, attachmentFileName, attachmentBody, attachmentContentType,true,ccAddresses);
                    Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                }
                
                return 'SUCCESS';
            }catch(Exception e){
                system.debug('VariablePayController.saveSessions, e.getMessage() : ' + e.getMessage());
                system.debug('VariablePayController.saveSessions, e.getLineNumber() : ' + e.getLineNumber());
                throw new AuraHandledException(e.getMessage());
            }
        }
        
        return 'NO RECORDS TO UPDATE';
    }
    
    public static Messaging.SingleEmailMessage sendEmailWithAttachment(String[] toAddresses, String subject, String body, String attachmentFileName, Blob attachmentBody, String attachmentContentType, boolean attachments, string[] ccAddresses) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String owa = [select id, Address, DisplayName from OrgWideEmailAddress where Address='sfcareeraware@antarangfoundation.org'].Id;
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
        mail.setSubject(subject);
        mail.setHtmlBody(body);
        mail.setOrgWideEmailAddressId(owa);
        if(attachments == true){
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setBody(attachmentBody);
            attachment.setFileName(attachmentFileName);
            attachment.setContentType(attachmentContentType);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment});
        }
        
        return mail;
    }
    @AuraEnabled
    public static Object  getSessionDataForSupervisor(Date inputDate){
        system.debug('Input date-'+inputDate);
        
        List<sessionWrapper> sessionWrapperLst = new List<sessionWrapper>();
        Map<String, Object> result = new Map<String, Object>();
        try {
            
            // String query = 'SELECT id, Name, Number_of_Sessions_No_of_Units__c, Session_Amount__c, Session_Code__c, Copy_of_Session__c, Present_Count__c, Dummy_Session_Created__c, Parent_Session_Code__c, SessionDate__c, Session_Grade__c, Attendance_Count__c, Dummy_Session__c, Total_Student_Present__c, Batch__r.Name, Batch__r.Batch_Number__c, Assigned_Facilitator__c, Deferred_Reason__c, Assigned_Facilitator__r.Name, Payment_Status__c,Total_Amount__c,Status__c,Active_Checkbox__c,Proposal_Date__c FROM Session__c WHERE Proposal_Date__c =: inputDate';
            
            
            //query = query+' ORDER BY Batch__r.Batch_Number__c';
            //  query = query+' ORDER BY Parent_Session_Code__c,Name ';
            // system.debug('query : '+query);
            
            //  List<Session__c> sessionLst = Database.query(query);
            
            Set<Id> sessionIds = new Set<Id>();
            for(Session__c s:[SELECT id, Name, Number_of_Sessions_No_of_Units__c, Session_Amount__c, Session_Code__c, Copy_of_Session__c, 
                              Present_Count__c, Dummy_Session_Created__c, Parent_Session_Code__c, SessionDate__c, Session_Grade__c, 
                              Attendance_Count__c, Dummy_Session__c, Total_Student_Present__c, Batch__r.Name, Batch__r.Batch_Number__c, 
                              Assigned_Facilitator__c, Deferred_Reason__c, Assigned_Facilitator__r.Name, Payment_Status__c,
                              Total_Amount__c,Status__c,Active_Checkbox__c,Proposal_Date__c FROM Session__c WHERE 
                              Proposal_Date__c =: inputDate]){
                
                sessionWrapper wrap = new sessionWrapper();
                wrap.SessionId = s.Id;
                wrap.Name = s.Name;
                wrap.SessionDate = s.SessionDate__c;
                
                wrap.SessionGrade = s.Session_Grade__c;
                wrap.PresentCount = s.Present_Count__c;
                wrap.AttendanceCount = s.Attendance_Count__c;
                
                wrap.TotalStudentsPresent = s.Total_Student_Present__c;
                
                wrap.NumberofSessionsNoofUnits = s.Number_of_Sessions_No_of_Units__c;
                wrap.SessionAmount = s.Session_Amount__c;
                
                wrap.SessionCode = s.Session_Code__c;
                wrap.DummySession = s.Dummy_Session__c;
                wrap.DummySessionAvailable = s.Dummy_Session_Created__c;
                wrap.ParentSessionCode = s.Copy_of_Session__c;
                
                wrap.BatchId = s.Batch__c;
                wrap.BatchName = s.Batch__c != null ?s.Batch__r.Name:'';
                wrap.BatchNumber = s.Batch__c != null ?s.Batch__r.Batch_Number__c:'';
                wrap.FacilitatorName = s.Assigned_Facilitator__c != null ? s.Assigned_Facilitator__r.Name:'';
                wrap.FacilitatorId = s.Assigned_Facilitator__c;
                wrap.PaymentStatus = s.Payment_Status__c;
                wrap.Rate = s.Total_Amount__c;
                wrap.Status = s.Status__c;
                wrap.DeferredReason = s.Deferred_Reason__c;
                wrap.Checkbox = s.Active_Checkbox__c;
                wrap.ProposalDate = s.Proposal_Date__c;
                /*if(s.Status__c == 'Proposal Saved' || s.Status__c == 'Proposal Submitted')
wrap.Checkbox = s.Active_Checkbox__c;
else wrap.Checkbox = tr*/
                system.debug('tet : '+wrap);
                sessionWrapperLst.add(wrap);
                
                
            }
            result.put('sessionData', sessionWrapperLst);
            // result.put('deferredReason', StudentOMRManagerController.getdynamicpicklistval('Session__c','Deferred_Reason__c'));
            return result;
            
        } catch (Exception e) {
            system.debug('te : '+e);
            throw new AuraHandledException(e.getMessage());
            //return null;
        }
    }
    public class wrapContentVersionAndEmail{
        public list<contentVersion>  contentVersionLst;
        public Messaging.SingleEmailMessage  singleEmail;
    }
    
    public class sessionWrapper{
        @AuraEnabled public String SessionId 					{set;get;}
        @AuraEnabled public String Name 			   			{set;get;}		
        @AuraEnabled public Date SessionDate 					{set;get;}
        @AuraEnabled public Date ProposalDate 					{set;get;}
        @AuraEnabled public String SessionGrade 				{set;get;}
        @AuraEnabled public Decimal AttendanceCount 			{set;get;}
        @AuraEnabled public Decimal PresentCount 				{set;get;}
        
        @AuraEnabled public String SessionCode 					{set;get;}        
        @AuraEnabled public Boolean DummySessionAvailable 		{set;get;}
        @AuraEnabled public Boolean DummySession 				{set;get;}
        @AuraEnabled public String ParentSessionCode 			{set;get;}
        @AuraEnabled public Decimal TotalStudentsPresent 		{set;get;}
        
        @AuraEnabled public Decimal NumberofSessionsNoofUnits 	{set;get;}
        @AuraEnabled public Decimal SessionAmount        		{set;get;}
        @AuraEnabled public Decimal Rate        		{set;get;}
        @AuraEnabled public String Status        		{set;get;}
        
        @AuraEnabled public String BatchId 						{set;get;}
        @AuraEnabled public String BatchName    				{set;get;}
        @AuraEnabled public String BatchNumber 					{set;get;}
        @AuraEnabled public String FacilitatorName 				{set;get;}
        @AuraEnabled public String FacilitatorId 				{set;get;}
        @AuraEnabled public String PaymentStatus 				{set;get;}		
        @AuraEnabled public String DeferredReason 				{set;get;}
        @AuraEnabled public String errorMessage 				{set;get;}
        @AuraEnabled public Boolean showError 					{set;get;}
        @AuraEnabled public Boolean Checkbox 					{set;get;}
        
    }
    public class wrapResult{
        public string description{get;set;}
        public string SessionType{get;set;}
        public integer NumOfSession{get;set;}
        public decimal rate{get;set;}
        public decimal amount{get;set;}
        public string schoolName{get;set;}
        public string sessionName{get;set;}
    }
}