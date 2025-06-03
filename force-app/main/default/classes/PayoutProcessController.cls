public with sharing class PayoutProcessController {
    public static Map<Id,contact> contactMap;
    
    public PayoutProcessController() {
        contactMap = new Map<Id,contact>();
    }
    
    @AuraEnabled(cacheable=true) 
    public static Contact getFacilitator(Id contactId){
        //contact con = 
        return [Select Id,Email,npe01__WorkEmail__c From Contact Where Id=:contactId Limit 1];
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
    public static Object  getSessions(Date invoiceDate, String Facilitator, String DonorId, String SchoolId, String BatchId, String Grade, string district){
        AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
        set<Decimal> setAcademicYear = new set<Decimal>();
        if(setting.Academic_Year__c != null){setAcademicYear.add(setting.Academic_Year__c);}
        if(setting.Next_Academic_Year__c != null){setAcademicYear.add(setting.Next_Academic_Year__c);}
        List<sessionWrapper> sessionWrapperLst = new List<sessionWrapper>();
        Map<String, Object> result = new Map<String, Object>();
        try {
            system.debug('invoiceDate : '+invoiceDate);
            
            String query = 'SELECT id, Name, Number_of_Sessions_No_of_Units__c, Session_Code__c, Copy_of_Session__c, Present_Count__c, Dummy_Session_Created__c,Session_Amount__c, Parent_Session_Code__c, SessionDate__c, Session_Grade__c, Attendance_Count__c, Dummy_Session__c, Total_Student_Present__c, Batch__r.Name, Batch__r.Batch_Number__c, Assigned_Facilitator__c, Deferred_Reason__c, Assigned_Facilitator__r.Name, Payment_Status__c FROM Session__c WHERE Payment_Status__c IN (\'Ready For Payment\', \'Deferred for Payment\') AND SessionDate__c <=:invoiceDate AND Batch__r.Academic_Year__c IN :setAcademicYear AND Batch__r.Dummy_Batch__c = false AND Assigned_Facilitator__r.Payment_Type__c = \'Session\' AND Batch__r.School_Name__r.District__c = :district';
            if(String.isNotBlank(Facilitator)){
                system.debug('1');
                query = query+' AND Assigned_Facilitator__c = :Facilitator';
            }
            if(String.isNotBlank(DonorId)){
                system.debug('2');
                query = query+' AND batch__r.Donor_Name__c = :DonorId';
            }
            if(String.isNotBlank(SchoolId)){
                system.debug('3');
                query = query+' AND batch__r.School_Name__c = :SchoolId';
            }
            if(String.isNotBlank(BatchId)){
                system.debug('4');
                query = query+' AND Batch__c  = :BatchId';
            }
            if(String.isNotBlank(Grade)){
                system.debug('5');
                query = query+' AND Session_Grade__c = :Grade';
            }
            
            //query = query+' ORDER BY Batch__r.Batch_Number__c';
            query = query+' ORDER BY Parent_Session_Code__c,Name ';
            system.debug('query : '+query);
            List<Session__c> sessionLst = Database.query(query);
            system.debug('sessionLst = '+sessionLst);
            Set<Id> sessionIds = new Set<Id>();
            for(Session__c s:sessionLst){
                
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
                wrap.DeferredReason = s.Deferred_Reason__c;
                wrap.errorMessage = 'Complete this field.';
                wrap.showError = false;
                wrap.Checkbox = true;
                
                system.debug('tet : '+wrap);
                sessionWrapperLst.add(wrap);
                
                
            }
            result.put('sessionData', sessionWrapperLst);
            result.put('deferredReason', StudentOMRManagerController.getdynamicpicklistval('Session__c','Deferred_Reason__c'));
            return result;
            
        } catch (Exception e) {
            system.debug('te : '+e);
            throw new AuraHandledException(e.getMessage());
            //return null;
        }
    }
    
    @AuraEnabled
    public static String updateSessions(List<sessionWrapper> wrapList){
        List<Session__c> updateLst = new List<Session__c>();
        for(sessionWrapper wrap:wrapList){
            Session__c s = new Session__c();
            s.Id = wrap.SessionId;
            s.Payment_Status__c = 'Deferred for Payment';
            /*if(wrap.DummySession && wrap.DeferredReason == 'Parent/Main batch attendance is lower than40' ){
                s.Payment_Status__c = 'Do not pay';
            }*/
            s.Deferred_Reason__c = wrap.DeferredReason;
            updateLst.add(s);
        }
        
        if(updateLst.size() > 0){
            system.debug('test updates sessions : '+updateLst);
            try{
                update updateLst;
                return 'SUCCESS';
            }catch(Exception e){
                return e.getMessage();
            }
        }
        
        return 'NO RECORDS TO UPDATE';
    }
    
    
    @AuraEnabled
    public static void sendInvoicetoFinance(Date invoiceDate){
        system.debug('invDate : ' + invoiceDate);
        
        String header1 ='Session Id, Session Code, School Grade, School Type, School Name, School Date, School Start Date, School End Date, Payment Status, Attendance Count, Total Student Present, Total Parent Present, Batch Grade, Batch Number, Batch Name,  Date of facilitation starting, Date of facilitation completion,  Donor Name, Dummy Batch Created, Dummy Batch, copy of Batch, Assigned Facilitator, Assigned Facilitator Work Email, PAN Number, MailingAddress, MailingCity, Bank Account No., IFSC Code, Branch Name, Bank City, TDS Applicable,TDS Deduction, Bank Name \n';
        
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
                                                            Assigned_Facilitator__c,Proposal_Date__c,status__c from Session__c  Where Invoice_Date__c =: invoiceDate ORDER BY Assigned_Facilitator__r.name, Session_Grade__c , Session_Number__c 
                                                           ]);
        system.debug('sessionLST : ' + sessionLST);
        
        Set<Id> assignedFacilitatorIds = new Set<Id>();
        
        
        //String header ='Batch Number, Batch Name, School Grade, School Type, Session Name, Session Date, Session Start Time, Invoice Date, Total Amount, Payment Status, Attendance Count, Total Student Present, Total Parent Present, Batch Grade, Batch Number, Batch Name,  Date of facilitation starting, Date of facilitation completion,  Donor Name, Dummy Batch Created, Dummy Batch, Copy of Batch, School District, Enrolled Grade 9, Enrolled Grade 10, Enrolled Grade 11, Assigned Facilitator, Assigned Facilitator Work Email, PAN Number, MailingAddress, MailingCity, Bank Account No., IFSC Code, Branch Name, Bank City, TDS Applicable,TDS Deduction, Bank Name \n';
        string header = 'Session Id,Session Code,Session Type,Session Grade,Session Name,Session Date,Total Student Present,Individual Attendance,No.of Batch,Rate (Per Session),Total Amount,Invoice Date,Payment Status,Batch Number,Batch Name,Donor Name,School District,Assigned Facilitator,Assigned Facilitator Work Email,PAN Number,MailingAddress,MailingCity,Bank Account No.,IFSC Code,Branch Name,Bank City,TDS Applicable,TDS Deduction,Bank Name \n';
        String finalstr = header;
        for(Session__c obj:sessionLST){
            assignedFacilitatorIds.add(obj.Assigned_Facilitator__c);
            
            String mailingAddress = obj.Assigned_Facilitator__r.MailingStreet+', '+obj.Assigned_Facilitator__r.MailingCity+', '+obj.Assigned_Facilitator__r.MailingState+', '+obj.Assigned_Facilitator__r.MailingPostalCode;
            
            String accNumber = '';
            if(obj.Assigned_Facilitator__r.Bank_Account_No__c != null){
                system.debug('Account number : '+obj.Assigned_Facilitator__r.Bank_Account_No__c);
                accNumber = obj.Assigned_Facilitator__r.Bank_Account_No__c.replaceAll('\'', '');
                system.debug('Account number : '+accNumber);
            }
            /*
String sessionDate = String.valueOf(obj.SessionDate__c.day()).leftPad(2, '0')+'-'+String.valueOf(obj.SessionDate__c.month()).leftPad(2, '0')+'-'+obj.SessionDate__c.year();

String sessionStartDate = String.valueOf(obj.Session_Start_Time__c.day()).leftPad(2, '0')+'-'+String.valueOf(obj.Session_Start_Time__c.month()).leftPad(2, '0')+'-'+obj.Session_Start_Time__c.year();
String sessionEndDate = String.valueOf(obj.Session_End_Time__c.day()).leftPad(2, '0')+'-'+String.valueOf(obj.Session_End_Time__c.month()).leftPad(2, '0')+'-'+obj.Session_End_Time__c.year();
String invoiceDate = String.valueOf(obj.Invoice_Date__c.day()).leftPad(2, '0')+'-'+String.valueOf(obj.Invoice_Date__c.month()).leftPad(2, '0')+'-'+obj.Invoice_Date__c.year();

String dateOfFacilitation = String.valueOf(obj.Batch__r.Date_of_facilitation_completion__c.day()).leftPad(2, '0')+'-'+String.valueOf(obj.Batch__r.Date_of_facilitation_completion__c.month()).leftPad(2, '0')+'-'+obj.Batch__r.Date_of_facilitation_completion__c.year();
*/
            String Recordstring = '"'+obj.Id+'","'+obj.Session_Code__c+'","'+obj.Session_Type__c+'",'+obj.Session_Grade__c+'","'+obj.Name+'","'+obj.SessionDate__c+'","'+obj.Total_Student_Present__c+'","'+obj.Attendance_Count__c+'","'+obj.Number_of_Sessions_No_of_Units__c+'","'+'INR'+obj.Total_Amount__c+'","'+'INR'+obj.Session_Amount__c+'","'+obj.Invoice_Date__c+'","'+obj.Payment_Status__c+'","'+obj.Batch__r.Batch_Number__c+'","'+obj.Batch__r.Name+'","'+obj.Batch__r.Donor_Name__r.Name+'","'+obj.Batch__r.School_Name__r.District__r.name+'","'+obj.Assigned_Facilitator__r.Name+'","'+obj.Assigned_Facilitator__r.npe01__WorkEmail__c+'","'+obj.Assigned_Facilitator__r.PAN_Number__c+'","'+obj.Assigned_Facilitator__r.MailingStreet+'","'+obj.Assigned_Facilitator__r.MailingCity+'","'+obj.Assigned_Facilitator__r.Bank_Account_No__c+'","'+obj.Assigned_Facilitator__r.IFSC_Code__c+'","'+obj.Assigned_Facilitator__r.Branch_Name__c+'","'+obj.Assigned_Facilitator__r.Bank_City__c+'","'+obj.Assigned_Facilitator__r.TDS_Applicable__c+'","10%","'+obj.Assigned_Facilitator__r.Bank_Name__c+'",\n';
            finalstr = finalstr+Recordstring;
        }
        finalstr = finalstr.replace('null','');
        
        system.debug('asf lst : '+assignedFacilitatorIds);
        String str = 'Consultancy_Bill_'+String.valueOf(invoiceDate.day()).leftPad(2, '0')+'/'+String.valueOf(invoiceDate.month()).leftPad(2, '0')+'/'+String.valueOf(invoiceDate.year())+'%';            
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        
        if(assignedFacilitatorIds.size() > 0){
            List<ContentDocumentLink> cdl = new List<ContentDocumentLink>([SELECT Id, ContentDocumentId, ContentDocument.Title  FROM ContentDocumentLink WHERE LinkedEntityId IN :assignedFacilitatorIds AND ContentDocument.title LIKE :str]);
            Set<Id> ContentDocumentIds = new Set<Id>();
            for(ContentDocumentLink c:cdl){
                ContentDocumentIds.add(c.ContentDocumentId);
            }
            

        
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        blob excel = blob.valueOf(finalstr);
        attach.setBody(excel);
        attach.setFileName('ExcelfileSC.csv');
        attach.setContentType('text/csv');
        
        attachments.add(attach);
            
            if(ContentDocumentIds.size() > 0){
                List<ContentVersion> cv  = new List<ContentVersion>([SELECT Id, Title, Record_Id__c, VersionData, Description, FileExtension FROM ContentVersion WHERE ContentDocumentId IN :ContentDocumentIds ]);            
                if(cv.size() > 0){
                    for(ContentVersion c: cv){
                        Messaging.EmailFileAttachment attach1 = new Messaging.EmailFileAttachment();
                        blob body = c.VersionData;
                        attach1.setBody(body);
                        attach1.setFileName(c.Title+'.pdf');
                        attach1.setContentType('application/pdf');
                        attachments.add(attach1);
                    }
                }
            }
        }
        
        String body = 'Dear Finance Team,<br/> Please find the attached Invoices and Session details for the date: <b>'+String.valueOf(invoiceDate.day()).leftPad(2, '0')+'/'+String.valueOf(invoiceDate.month()).leftPad(2, '0')+'/'+String.valueOf(invoiceDate.year())+'</b>. <br/> <br/> Thanks,';
        
        
        String Subject = System.Label.Finance_Team_Email_Subject;
        
        Messaging.singleEmailMessage Emailwithattch = new Messaging.singleEmailMessage();
        
        
        string toEmails = System.Label.Finance_Team_Email;
        List<String> sendingToEmailAdd = new List<String>();
        if(String.isNotBlank(toEmails)){
            sendingToEmailAdd = toEmails.split(';');
        }
        if(sendingToEmailAdd.size() > 0){
            Emailwithattch.setToaddresses(sendingToEmailAdd);   
        }
        
        
        string ccEmails = System.Label.Finance_CC_Emails;
        List<String> sendingTocAdd = new List<String>();
        if(String.isNotBlank(ccEmails)){
            sendingTocAdd = ccEmails.split(';');
        }
        if(sendingTocAdd.size() > 0){
            Emailwithattch.setCcAddresses(sendingTocAdd);   
        }
        
        String owa = [select id, Address, DisplayName from OrgWideEmailAddress where Address='sfcareeraware@antarangfoundation.org'].Id;
        Emailwithattch.setOrgWideEmailAddressId(owa);
        
        Emailwithattch.setSubject(Subject);
        Emailwithattch.setHtmlBody(body);
        Emailwithattch.setFileAttachments(attachments);
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {Emailwithattch});
    }
    
    
    @AuraEnabled
    public static String generateInvoiceAndSendEmail(List<sessionWrapper> wrapList, Date invoiceDate, string district){
        system.debug('time : '+invoiceDate);
        system.debug('wrapList : '+wrapList);
        District_Master__c dist = [select id,Payout_Admin_Username__c from District_Master__c where id = :district];
        list<contentVersion>  contentVerLSt = new list<contentVersion>();
        Date d = invoiceDate;
        date tempdate = d.addMonths(-1);
        date dt = tempdate;
        
        Set<Id> conIds = new Set<Id>();
        Set<Id> sessionIds = new Set<Id>();
        for(sessionWrapper wrap:wrapList){
            
            if(wrap.Checkbox){
                sessionIds.add(wrap.SessionId);
                if(wrap.FacilitatorId != null){
                    conIds.add(wrap.FacilitatorId);
                }
            }
        }
        
        contactMap = new Map<Id,Contact>([select Id,Name, npe01__WorkEmail__c, Email,Batch_Code__c from contact where Id IN: conIds]);
        
        List<Session__c> sessionLst = new List<Session__c>();
        Map<Id,list<Session__c>> facilitatorSessionMap = new Map<Id,list<session__c>>();
        
        System.debug('Line sessionIds '+sessionIds); 
        
        for(Session__c s : [select id, Number_of_Sessions_No_of_Units__c,Session_Amount__c,Session_Type__c, Name, No_of_batches_for_counseling__c, Dummy_Session__c, Total_Amount__c,Batch__r.Donor_Name__c,Session_Grade__c,
                            Batch__r.School_Name__c,Batch__r.School_Name__r.Name,Assigned_facilitator__c,Assigned_facilitator__r.Fixed_Amount__c, Assigned_facilitator__r.npe01__WorkEmail__c
                            from Session__c WHERE Id IN:sessionIds AND Payment_Status__c IN ('Ready For Payment', 'Deferred for Payment') order by Session_Grade__c ,Session_Code__c ]){
                                
                                System.debug('Line Session__c '+s);
                                if(!facilitatorSessionMap.containsKey(s.Assigned_facilitator__c))
                                    facilitatorSessionMap.put(s.Assigned_Facilitator__c, new List<session__c>());
                                facilitatorSessionMap.get(s.Assigned_Facilitator__c).add(s);
                                sessionLst.add(s);
                            }
        
        if(facilitatorSessionMap.keyset().size()>0){
            
            List<Messaging.SingleEmailMessage> lstEmailMesages = new List<Messaging.SingleEmailMessage>();
            
            
            Map<Id, List<ContentDocumentLink>> ContentDocumentLnkMap = new Map<Id, List<ContentDocumentLink> >();
            Map<Id, Integer> num = new Map<Id, Integer>();
            
            for(ContentDocumentLink cd : [SELECT id, ContentDocument.title, LinkedEntityId from ContentDocumentLink where ContentDocument.title Like 'Consultancy_Bill_%' AND LinkedEntityId IN :facilitatorSessionMap.keyset() ORDER BY ContentDocument.createdDate DESC ] ){
                if(ContentDocumentLnkMap.containsKey(cd.LinkedEntityId)){
                    ContentDocumentLnkMap.get(cd.LinkedEntityId).add(cd);
                }else{                    
                    ContentDocumentLnkMap.put(cd.LinkedEntityId,new List<ContentDocumentLink>{cd});
                }
            }
            
            
            for(Id facilitator : facilitatorSessionMap.keyset()){
                
                Integer count = ContentDocumentLnkMap.containsKey(facilitator)? ContentDocumentLnkMap.get(facilitator).size():0;
                system.debug('count : '+count);
                
                
                wrapContentVersionAndEmail w = emailBody(contactMap.get(facilitator), count,facilitatorSessionMap.get(facilitator),d,dt,dist.Payout_Admin_Username__c);
                contentVerLSt.addAll(w.contentVersionLst);
                system.debug('Mail : '+w.singleEmail);
                lstEmailMesages.add(w.singleEmail); 
            }
            
            
            try{
                
                List<Session__c> sessionToUpdate = new List<Session__c>();
                for(Session__c objSession : sessionLst){
                    objSession.Payment_Status__c = 'Payment Made';
                    objSession.Invoice_Date__c = invoiceDate; 
                    
                    system.debug('objSession '+objSession);
                    /*
if(!objSession.Dummy_Session__c ){
system.debug('objSession '+objSession);
sessionToUpdate.add(objSession);
} */
                    sessionToUpdate.add(objSession);
                }
                if(sessionToUpdate.size()>0){
                    update sessionToUpdate;
                }
                
                if(contentVerLSt.size()>0){
                    system.debug(contentVerLSt);
                    insert contentVerLSt;
                    
                    list<ContentDocumentLink> cdlLst = new list<ContentDocumentLink>();
                    for(ContentVersion cv : [SELECT ContentDocumentId,Record_Id__c FROM ContentVersion WHERE Id IN: contentVerLSt]){
                        ContentDocumentLink cDe = new ContentDocumentLink();
                        cDe.ContentDocumentId = cv.ContentDocumentId;
                        cDe.LinkedEntityId = cv.Record_Id__c; //  objectId
                        cDe.ShareType = 'I'; // Inferred permission
                        cDe.Visibility = 'InternalUsers';
                        cdlLst.add(cde);
                    }
                    
                    insert cdlLst;
                }                                                    
                
                Messaging.sendEmail(lstEmailMesages);
                return 'SUCCESS';
                
            }
            catch(exception e){
                system.debug('test : '+e.getMessage());
                return e.getMessage();
            }            
        }
        else{
            system.debug('ELSE');
            //isError = true;
            return 'INFO :Changes saved and no records found for Payout Process. Click on "Show Session" button to check the changes"  ';
        }
        
        
        
    }
    
    @AuraEnabled
    public static String sendInvoiceToFacilitator(Date invoiceDate, String facilitatorEmail){
        // Date d = invoiceDate;
        DateTime d = invoiceDate;
        DateTime tempdate = d.addMonths(-1);
        DateTime dt = tempdate;
        
        Contact con = [Select Id,Name,npe01__WorkEmail__c  from Contact where npe01__WorkEmail__c =:facilitatorEmail Limit 1];
        system.debug('ttt con : '+con);
        
        if(con != null){
            
            String str = '\'Consultancy_Bill_'+String.valueOf(invoiceDate.day()).leftPad(2, '0')+'/'+String.valueOf(invoiceDate.month()).leftPad(2, '0')+'/'+String.valueOf(invoiceDate.year())+'%\'';
            system.debug('ttt str : '+str);
            
            String query = 'SELECT id, ContentDocumentId, ContentDocument.title,LinkedEntityId from ContentDocumentLink'+ 
                ' where LinkedEntityId = \''+con.Id+'\' AND ContentDocument.title LIKE '+str+' ORDER BY ContentDocument.CreatedDate DESC ';
            
            system.debug('ttt query : '+query);
            
            List<ContentDocumentLink> cdl = Database.query(query);
            
            Set<Id> cdIdSet = new Set<Id>();
            
            for(ContentDocumentLink c: cdl){
                cdIdSet.add(c.ContentDocumentId);
            }
            
            system.debug('ttt ContentDocumentLink : '+cdl);
            
            String cvQuery = 'SELECT Id, Title, Record_Id__c, VersionData, Description, FileExtension FROM ContentVersion WHERE ContentDocumentId IN :cdIdSet AND Record_Id__c = \''+con.Id+'\' AND title LIKE '+str;
            List<ContentVersion> cv = Database.query(cvQuery);
            
            system.debug('tets : '+cv);
            
            list<Session__c> SessionList = [select id, Session_Amount__c,Session_Type__c, Name, No_of_batches_for_counseling__c, Dummy_Session__c, Total_Amount__c,Batch__r.Donor_Name__c,Session_Grade__c,
                                            Batch__r.School_Name__c,Batch__r.School_Name__r.Name,Assigned_facilitator__c, Assigned_facilitator__r.npe01__WorkEmail__c
                                            from Session__c WHERE Assigned_facilitator__c =: con.Id AND Payment_Status__c ='Payment Made' AND Invoice_Date__c =: invoiceDate ];
            
            if(SessionList.size() < 1){
                return 'ERROR : No Sessions Found with this Invoice Date';
            }
            
            try{
                wrapContentVersionAndEmail wrapCVE = new wrapContentVersionAndEmail();
                wrapCVE.contentVersionLst = new List<ContentVersion>();
                Messaging.SingleEmailMessage  email = new Messaging.SingleEmailMessage();
                string[] to = new string[] {con.npe01__WorkEmail__c};
                    //string[] to = new string[] {contactMap.get(facilitator).Email};
                    email.setToAddresses(to);
                email.setSubject('Payout mail');
                
                
                map<id,list<Session__c>> schoolsessionMap = new Map<id,list<Session__c>>();
                map<id,map<string,integer>> sesionMap = new map<id,map<string,integer>>();
                
                map<string,decimal> gradeRateMap = new map<string,decimal>();
                map<string,integer> tempMap = new map<string,integer>();        
                Map<string,Map<string,integer>> tempdonorTotalSessionMap = new Map<string,Map<string,integer>>();
                
                for(Session__c s : SessionList){
                    System.debug('Line');
                    if(!schoolsessionMap.containsKey(s.Batch__r.School_Name__c))
                        schoolsessionMap.put(s.Batch__r.School_Name__c, new list<Session__c>());
                    schoolsessionMap.get(s.Batch__r.School_Name__c).add(s);
                    
                    gradeRateMap.put(s.Session_Grade__c, s.Total_Amount__c);
                    
                    
                    
                    if(!tempMap.containsKey(s.Batch__r.Donor_Name__c+'_'+s.Session_Grade__c.replaceAll( '\\s+', '').toLowercase()))
                        tempMap.put(s.Batch__r.Donor_Name__c+'_'+s.Session_Grade__c.replaceAll( '\\s+', '').toLowercase(),0);
                    
                    tempMap.put(s.Batch__r.Donor_Name__c+'_'+s.Session_Grade__c.replaceAll( '\\s+', '').toLowercase() ,tempMap.get(s.Batch__r.Donor_Name__c+'_'+s.Session_Grade__c.replaceAll( '\\s+', '').toLowercase())+1);
                    
                    
                    
                    if(!sesionMap.containsKey(s.Batch__r.Donor_Name__c))
                        sesionMap.put(s.Batch__r.Donor_Name__c , new map<string,integer>());
                    
                    sesionMap.get(s.Batch__r.Donor_Name__c).put(s.Session_Grade__c,tempMap.get(s.Batch__r.Donor_Name__c+'_'+s.Session_Grade__c.replaceAll( '\\s+', '').toLowercase()));
                    
                    system.debug('sesionMap.get(s.Batch__r.Donor_Name__c)'+sesionMap.get(s.Batch__r.Donor_Name__c));
                }
                
                
                string htmlBody = 'Dear '+con.Name+',<br/>Thank you for your engagement with us and with our students last month.<br/><br/>';
                htmlBody += 'Please find your payment details for the month of '+d.format('MMMMM')+' '+d.year();
                htmlBody+= '<br/><br/><table border="1" style="table-layout: fixed;border-collapse: collapse;width:80%"><tr><th align="center"><b>Sr.No</b></th><th align="center" width="30%"><b>School Name</b></th><th align="center"><b>Grade</b></th><th align="center" width="30%"><b>Session Name</b></th><th align="center"><b>No. of Sessions</b></th><th align="center"><b>Amount</b></th></tr>';
                integer num=1;
                double totalAmountpaid = 0;
                Map<String,wrapSessionEmailBody> wrapSessionEmailBodyMap = new Map<String,wrapSessionEmailBody>();
                for(Session__c se : SessionList){
                    if(!wrapSessionEmailBodyMap.containsKey(se.Batch__r.School_Name__r.Name+'_'+se.Session_Grade__c+'_'+se.Name)){
                        wrapSessionEmailBody wrap = new  wrapSessionEmailBody();
                        wrap.schoolName = se.Batch__r.School_Name__r.Name;
                        wrap.Grade = se.Session_Grade__c;
                        wrap.SessionName = se.Name;
                        wrap.NumberOfSessions = 1;
                        //wrap.NumberOfSessions = se.Number_of_Sessions_No_of_Units__c.intValue();
                        system.debug('tt');
                        system.debug('tt'+ se.Total_Amount__c);
                        system.debug('tt'+ se.Session_Amount__c);
                        system.debug('tt'+ se.No_of_batches_for_counseling__c);
                        
                        wrap.PaidAmt = se.Total_Amount__c != null ? se.Total_Amount__c * wrap.NumberOfSessions: 0;
                        //wrap.PaidAmt = se.Session_Amount__c != null ? se.Session_Amount__c: 0;
                        system.debug('tt');
                        wrapSessionEmailBodyMap.put(se.Batch__r.School_Name__r.Name+'_'+se.Session_Grade__c+'_'+se.Name, wrap);
                    } else {
                        wrapSessionEmailBody wrap = wrapSessionEmailBodyMap.get(se.Batch__r.School_Name__r.Name+'_'+se.Session_Grade__c+'_'+se.Name);
                        system.debug('tt'+ se.Session_Amount__c);
                        wrap.NumberOfSessions    += 1;
                        wrap.PaidAmt            += se.Total_Amount__c != null ? se.Total_Amount__c : 0;
                        //wrap.NumberOfSessions += se.Number_of_Sessions_No_of_Units__c.intValue();
                        //wrap.PaidAmt += se.Session_Amount__c != null ? se.Session_Amount__c: 0;
                        /*
if(!wrap.SessionName.contains(se.Name)){
wrap.SessionName 		+= ', '+se.Name; 
}
*/
                        wrapSessionEmailBodyMap.put(se.Batch__r.School_Name__r.Name+'_'+se.Session_Grade__c+'_'+se.Name , wrap);
                    }
                }
                Integer cnt = 1;
                system.debug('wrapSessionEmailBodyMap = '+wrapSessionEmailBodyMap);
                for(String wstr : wrapSessionEmailBodyMap.keySet()){
                    htmlBody+= '<tr><td align="center">'+cnt+'</td><td align="center">'+wrapSessionEmailBodyMap.get(wstr).schoolName+'</td><td align="center">'+wrapSessionEmailBodyMap.get(wstr).Grade+'</td><td align="center";width: 60px;>'+String.valueOf(wrapSessionEmailBodyMap.get(wstr).SessionName)+'</td><td align="center">'+wrapSessionEmailBodyMap.get(wstr).NumberOfSessions+'</td><td align="center">'+wrapSessionEmailBodyMap.get(wstr).PaidAmt+'</td></tr>';
                    cnt++;
                    totalAmountpaid+=wrapSessionEmailBodyMap.get(wstr).PaidAmt;
                }
                
                
                /* for(Id i :schoolsessionMap.keyset()){
integer totalSession = 0;
double Total = 0;
string SchoolName;
// for(Batch__c b : schoolBatchMap.get(i)){
totalSession+= schoolsessionMap.get(i).size();
//SchoolName = schoolBatchMap.get(i)[0]Batch__r.School_Name__r.Name;
for(Session__c se : schoolsessionMap.get(i)){
system.debug('session school  : '+se);
SchoolName = se.Batch__r.School_Name__r.Name;
system.debug('session school : '+SchoolName);
total+= se.Total_Amount__c != null ? se.Total_Amount__c :0;
}
//}
totalAmountpaid+=total;
htmlBody+= '<tr><td align="center">'+num+'</td><td align="center">'+SchoolName+'</td><td align="center">'+totalSession+'</td><td align="center">'+Total+'</td></tr>';
num++;
}
*/
                
                htmlBody+='</table><br/><br/>';
                //htmlBody+='There will be a 10% TDS deduction on every batch payment.<br/><br/>';// The total amount paid to you for the month of '+d.format('MMMMM')+' '+d.year()+' is '+totalAmountpaid+'.<br/><br/>';
                htmlBody+= '<b><u>NOTE</u></b><br/>';
                htmlBody+='<ul><li>There will be a 10% TDS deduction on every session payment.</li>';
                htmlBody+='<li>Payment cycle starts from 23rd of '+dt.format('MMMMM')+' to 22nd of '+d.format('MMMMM')+'.</li>';
                //htmlBody+='<ul><li>Payment cycle starts from 26th of the '+dt.format('MMMMM')+' to 25th of the '+d.format('MMMMM')+'</li>';
                htmlBody+='<li>Sessions where the data submitted before the 22nd of the month has been considered for the payout.</li>';
                htmlBody+='<li>Sessions which end after the 22nd of the month and where data submission hasn’t happened before 22nd of the month will be added into the next month’s payment cycle.</li></ul><br/>'; 
                
                
                //htmlBody+='<li>Sessions/Schools which are ending after the 25th of the month or the schools where data submission hasn’t happened before 25th of the month will be added into the next month’s payment cycle.</li></ul><br/><br/>';
                htmlBody+='Thanks and Regards,<br/>CareerAware Team';
                
                
                List<Messaging.EmailFileAttachment > lstEmailAttachment = new List<Messaging.EmailFileAttachment >();          
                for(ContentVersion c:cv){
                    blob WOCFbody = c.versiondata;
                    system.debug('body : '+WOCFbody+'-----------'+c.title);
                    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                    efa.setFileName(c.title+'.pdf');
                    efa.setBody(WOCFbody);
                    lstEmailAttachment.add(efa);
                }
                
                email.setFileAttachments(lstEmailAttachment); 
                
                
                system.debug('htmlBody :: '+htmlBody);
                
                email.setHtmlBody(htmlBody);
                
                string ccEmails = System.Label.Payout_CC_Emails;
                List<String> sendingTocAdd = new List<String>();
                if(String.isNotBlank(ccEmails))
                {
                    sendingTocAdd = ccEmails.split(';');
                }
                if(sendingTocAdd.size() > 0)
                {
                    email.setCcAddresses(sendingTocAdd);   
                }
                
                String owa = [select id, Address, DisplayName from OrgWideEmailAddress where Address='sfcareeraware@antarangfoundation.org'].Id;
                email.setOrgWideEmailAddressId(owa);
                
                
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ email });
                return 'SUCCESS';
            }catch(Exception E){
                System.debug('Error. '+E.getMessage());
                System.debug('Line No. '+E.getLineNumber());
                return E.getMessage();
            }
        }else{
            return 'No facilitator found with this Email';
        }
        
    }
    
    
    public static wrapContentVersionAndEmail emailBody(Contact con, Integer fileCount, list<Session__c> SessionList,datetime d,datetime dt, string adminEmail ){
        
        wrapContentVersionAndEmail wrapCVE = new wrapContentVersionAndEmail();
        wrapCVE.contentVersionLst = new List<ContentVersion>();
        
        Messaging.SingleEmailMessage  email = new Messaging.SingleEmailMessage();
        string[] to = new string[] {con.npe01__WorkEmail__c};
            system.debug('tt to email : '+con.npe01__WorkEmail__c);
        email.setToAddresses(to);
        string payout  = System.Label.Payout_Email_Subject;
        if(payout != null ){
            email.setSubject(payout);
        }
        else{
            email.setSubject('Payout mail');
        }    
        
        
        map<String, List<Session__c>> sessInvoiceMap = new Map<String, List<Session__c>>();
        map<String, List<Session__c>> sessInvoicePDFMap = new Map<String, List<Session__c>>();       
        
        for(Session__c s : SessionList)
        {
            if(!sessInvoicePDFMap.containsKey(s.Batch__r.Donor_Name__c))
                sessInvoicePDFMap.put(s.Batch__r.Donor_Name__c , new List<Session__c>());
            sessInvoicePDFMap.get(s.Batch__r.Donor_Name__c).add(s);
        }
        
        string htmlBody = 'Dear '+con.Name+',<br/>Thank you for your engagement with us and with our students last month.<br/><br/>';
        htmlBody += 'Please find your payment details for the month of '+d.format('MMMMM')+' '+d.year()+'.';
        htmlBody+= '<br/><br/><table border="1" style="table-layout: fixed;border-collapse: collapse;width:80%"><tr><th align="center"><b>Sr.No</b></th><th align="center" width="30%"><b>School Name</b></th><th align="center"><b>Grade</b></th><th align="center" width="30%"><b>Session Name</b></th><th align="center"><b>No. of Sessions</b></th><th align="center"><b>Amount</b></th></tr>';
        
        double totalAmountpaid = 0;
        
        Map<String,wrapSessionEmailBody> wrapSessionEmailBodyMap = new Map<String,wrapSessionEmailBody>();
        for(Session__c se : SessionList){
            system.debug('se = '+se);
            if(!wrapSessionEmailBodyMap.containsKey(se.Batch__r.School_Name__r.Name+'_'+se.Session_Grade__c+'_'+se.Name)){
                wrapSessionEmailBody wrap = new  wrapSessionEmailBody();
                wrap.schoolName = se.Batch__r.School_Name__r.Name;
                wrap.Grade = se.Session_Grade__c;
                wrap.SessionName = se.Name;
                //wrap.NumberOfSessions = 1;
                wrap.NumberOfSessions = se.Number_of_Sessions_No_of_Units__c.intValue();
                system.debug('tt');
                system.debug('tt'+ se.Total_Amount__c);
                system.debug('tt'+ se.No_of_batches_for_counseling__c);
                
                //wrap.PaidAmt  = se.Total_Amount__c != null ? se.Total_Amount__c : 0;
                wrap.PaidAmt  = se.Session_Amount__c != null ? se.Session_Amount__c : 0;
                
                system.debug('tt');
                wrapSessionEmailBodyMap.put(se.Batch__r.School_Name__r.Name+'_'+se.Session_Grade__c+'_'+se.Name, wrap);
            } else {
                wrapSessionEmailBody wrap = wrapSessionEmailBodyMap.get(se.Batch__r.School_Name__r.Name+'_'+se.Session_Grade__c+'_'+se.Name);
                
                //wrap.NumberOfSessions    += 1;
                //wrap.NumberOfSessions = se.Number_of_Sessions_No_of_Units__c.intValue();
                //wrap.PaidAmt            += se.Total_Amount__c != null ? se.Total_Amount__c : 0;
                wrap.PaidAmt  += se.Session_Amount__c;
                wrap.NumberOfSessions += se.Number_of_Sessions_No_of_Units__c.intValue();
                system.debug('wrap.PaidAmt = '+se.Total_Amount__c);
                /*
if(!wrap.SessionName.contains(se.Name)){
wrap.SessionName 		+= ', '+se.Name; 
}
*/
                wrapSessionEmailBodyMap.put(se.Batch__r.School_Name__r.Name+'_'+se.Session_Grade__c+'_'+se.Name , wrap);
            }
        }
        Integer cnt = 1;
        for(String wstr : wrapSessionEmailBodyMap.keySet()){
            htmlBody+= '<tr><td align="center">'+cnt+'</td><td align="center">'+wrapSessionEmailBodyMap.get(wstr).schoolName+'</td><td align="center">'+wrapSessionEmailBodyMap.get(wstr).Grade+'</td><td align="center";width: 60px;>'+String.valueOf(wrapSessionEmailBodyMap.get(wstr).SessionName)+'</td><td align="center">'+wrapSessionEmailBodyMap.get(wstr).NumberOfSessions+'</td><td align="center">'+wrapSessionEmailBodyMap.get(wstr).PaidAmt+'</td></tr>';
            cnt++;
            totalAmountpaid+=wrapSessionEmailBodyMap.get(wstr).PaidAmt;
        }
        
        
        htmlBody+='</table><br/><br/>';
        //htmlBody+='There will be a 10% TDS deduction on every batch payment.';
        //htmlBody+=' The total amount that will be paid to you (excluding TDS deductions) for the month of <b>'+d.format('MMMMM')+' '+d.year()+'</b> is <b>'+totalAmountpaid+'</b>.<br/>';
        htmlBody+= '<br/><b><u>NOTE</u></b><br/>';
        htmlBody+='<ul><li>There will be a 10% TDS deduction on every session payment.</li>';
        htmlBody+='<li>Payment cycle starts from 23rd of '+dt.format('MMMMM')+' to 22nd of '+d.format('MMMMM')+'.</li>';
        htmlBody+='<li>Only Sessions where the Data submitted before the 22nd of the month has been considered for the payout.</li>';
        htmlBody+='<li>Your consultancy fee shall be payable provided that you submit the deliverables including the accurate student data within a month of the date of the session.</li>';
        htmlBody+='<li>If the delay in submitting OMR sheets or other applicable school documents is beyond 1 month then payment for that particular batch/session will be withheld. Any further a decision on the same will be upto Antarang Foundation’s discretion.</li>';
        htmlBody+='<li>Please Resend the Signed Invoices to '+adminEmail+' .</li>';
        htmlBody+='<li>Refer to the <a target="_blank" href="https://docs.google.com/document/d/14kPi1L9w7XnDP1Zj_bqFq4G2FiyfPMfoeJAicFYQd0M/edit">Operational Guidelines Document"</a> to know the steps for signing the invoices. </li></ul><br/>'; 
        
        //htmlBody+='<li>Sessions/Schools which end after the 22nd of the month or the schools where data submission hasn’t happened before 22nd of the month will be added into the next month’s payment cycle.</li>';
        //htmlBody+='<li>Final no.of batches that have been considered for payment are based on the actual number of students attending the sessions</li></ul><br/>';       
        htmlBody+='Thanks and Regards,<br/>CareerAware Team';
        
        
        List<Messaging.EmailFileAttachment > lstEmailAttachment = new List<Messaging.EmailFileAttachment >();          
        
        
        Map<string,Map<String,List<Session__c>>> donorSessionMap = new Map<string,Map<String,List<Session__c>>> ();
        Map<string,Integer> CounselingMap = new Map<string,Integer> ();
        
        for(String str : sessInvoicePDFMap.keySet()){
            Map<String,List<Session__c>> tempMApSessionTypeGrade = new Map<String,List<Session__c>>();
            Map<String,Integer> tempCounseling = new  Map<String,Integer>();
            Integer CounselingCount = 0 ;
            Map<String,String> tempbatchIdMap = new  Map<String,String>();
            for(Session__c se : sessInvoicePDFMap.get(str)){
                if(!tempMApSessionTypeGrade.containsKey(se.Session_Type__c+'_'+se.Session_Grade__c))
                    tempMApSessionTypeGrade.put(se.Session_Type__c+'_'+se.Session_Grade__c,new list<Session__c>());
                
                tempMApSessionTypeGrade.get(se.Session_Type__c+'_'+se.Session_Grade__c).add(se);
                
                if(se.Session_Type__c  == 'Counseling' && !tempbatchIdMap.containskey(se.Batch__r.School_Name__c)){
                    CounselingCount += se.No_of_batches_for_counseling__c != null ? Integer.valueOf(se.No_of_batches_for_counseling__c) : 0;
                    CounselingMap.put(str,CounselingCount);
                    tempbatchIdMap.put(se.Batch__r.School_Name__c,se.Batch__r.School_Name__c);
                }
                
            }
            donorSessionMap.put(str,tempMApSessionTypeGrade);
        }
        
        Map<string,List<wrapResult>> erpdonor = new Map<string,List<wrapResult>>();
        Map<string,decimal> donorWiseTotal = new Map<string,decimal>();
        
        for(String str : donorSessionMap.keySet()){
            Map<String,List<Session__c>> tempMApSessionTypeGrade = donorSessionMap.get(str);
            list<wrapResult> wplst = new list<wrapResult>();
            decimal Total = 0;
           
            system.debug('tempMApSessionTypeGrade = '+tempMApSessionTypeGrade.values());
            system.debug('tempMApSessionTypeGrade.keySet() = '+tempMApSessionTypeGrade.keySet());
            for(String key : tempMApSessionTypeGrade.keySet()){
                wrapResult w = new wrapResult();
                w.description = key.split('_')[1];
                w.SessionType = key.split('_')[0];
                if(tempMApSessionTypeGrade.get(key)[0].Session_Type__c == 'counseling')
                	w.rate = tempMApSessionTypeGrade.get(key)[0].Total_Amount__c;
                else
                   w.rate =  tempMApSessionTypeGrade.get(key)[0].Assigned_Facilitator__r.Fixed_Amount__c;
                List<Session__c> sessionListNo = tempMApSessionTypeGrade.get(key);
                Integer noOfSession = 0;
            	decimal amount = 0;
                for (Session__c session : sessionListNo) {
                    noOfSession += session.Number_of_Sessions_No_of_Units__c.intValue();
                    amount += session.Session_Amount__c;
                }
                //w.amount = w.rate != null ? tempMApSessionTypeGrade.get(key).size() * w.rate :0;
                w.amount = amount;
                //noOfSession += tempMApSessionTypeGrade.get(key)[0].Number_of_Sessions_No_of_Units__c.intValue();
                //w.NumOfSession = tempMApSessionTypeGrade.get(key)[0].Number_of_Sessions_No_of_Units__c.intValue();
                system.debug('w.NumOfSession = '+w.NumOfSession);
                system.debug('w.amount = '+w.amount);
                w.NumOfSession = noOfSession;
                wplst.add(w);
                Total+=w.amount;
               
                donorWiseTotal.put(str,Total);
            }
            erpdonor.put(str , wplst);
            
        }
        system.debug('erpdonor = '+erpdonor);
        integer c = fileCount;
        String count;
        for(string str : erpdonor.keyset()){
            c++; 
            count = String.valueOf(c).leftPad(3, '0');
            
            PageReference word = Page.CATrainerInvoice;
            word.getParameters().put('Id',con.Id);
            word.getParameters().put('Map',JSON.serialize(erpdonor.get(str)));
            word.getParameters().put('Total',String.valueOf(donorWiseTotal.get(str)));
            word.getParameters().put('selectedMonthYear',String.valueOf(date.newInstance(d.year(),d.month(),d.day())));
            word.getParameters().put('invDate',String.valueOf(d.day()).leftPad(2, '0')+'-'+String.valueOf(d.month()).leftPad(2, '0')+'-'+d.year());
            word.getParameters().put('invNum',String.valueOf(count));
            
            Blob body;
            blob pdfbody;
            if(!test.isRunningTest()){
                body = word.getContent();
                pdfbody = word.getContentAsPDF();
            }else{
                body = blob.valueof('TEST');
                pdfbody = blob.valueof('TEST');
            }
            
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer.PathOnClient = 'Consultancy_Bill_'+String.valueOf(d.day()).leftPad(2, '0')+'/'+String.valueOf(d.month()).leftPad(2, '0')+'/'+d.year()+'_'+con.Name+'.pdf'; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = 'Consultancy_Bill_'+String.valueOf(d.day()).leftPad(2, '0')+'/'+String.valueOf(d.month()).leftPad(2, '0')+'/'+d.year()+'_'+con.Name+'_'+count;
            conVer.VersionData = pdfbody; 
            conVer.Record_Id__c = con.Id;
            wrapCVE.contentVersionLst.add(conVer);
            
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName('Consultancy_Bill_'+String.valueOf(d.day()).leftPad(2, '0')+'/'+String.valueOf(d.month()).leftPad(2, '0')+'/'+d.year()+'_'+con.Name+'_'+count+'.pdf');
            attach.setInline(false);
            attach.Body = pdfbody;
            lstEmailAttachment.add(attach);
            
        }
        system.debug('@@@@ erpdonor.keySet() ::'+erpdonor.keySet());
        
        
        email.setFileAttachments(lstEmailAttachment); 
        system.debug('htmlBody :: '+htmlBody);
        email.setHtmlBody(htmlBody);
        
        string ccEmails = System.Label.Payout_CC_Emails;
        List<String> sendingTocAdd = new List<String>();
        if(String.isNotBlank(ccEmails))
        {
            sendingTocAdd = ccEmails.split(';');
        }
        if(sendingTocAdd.size() > 0)
        {
            email.setCcAddresses(sendingTocAdd);   
        }
        
        String owa = [select id, Address, DisplayName from OrgWideEmailAddress where Address='sfcareeraware@antarangfoundation.org'].Id;
        email.setOrgWideEmailAddressId(owa);
        
        
        if(email != null){
            //return email;
            wrapCVE.singleEmail = email;
            return wrapCVE;
        }
        else{
            return null;
        }
    }
    
    
    public class wrapContentVersionAndEmail{
        public list<contentVersion>  contentVersionLst;
        public Messaging.SingleEmailMessage  singleEmail;
    }
    
    public class wrapResult{
        public string description{get;set;}
        public string SessionType{get;set;}
        public integer NumOfSession{get;set;}
        public decimal rate{get;set;}
        public decimal amount{get;set;}
    }
    public class wrapSessionEmailBody{
        public String schoolName;
        public String Grade;
        public String SessionName;
        public Integer NumberOfSessions;
        public Decimal PaidAmt;
    }
    
    public class sessionWrapper{
        @AuraEnabled public String SessionId 					{set;get;}
        @AuraEnabled public String Name 			   			{set;get;}		
        @AuraEnabled public Date SessionDate 					{set;get;}
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
    
}