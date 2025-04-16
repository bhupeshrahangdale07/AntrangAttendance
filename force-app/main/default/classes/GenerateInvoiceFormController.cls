public without sharing class GenerateInvoiceFormController {
    @AuraEnabled(cacheable=true)
    public static list<District_Master__c> getDistrict() {
        return [select id, name from District_Master__c];
    }
    @AuraEnabled
    public static string generateInvoice(string jsonData, string salaryMonth, date invoiceDate, string district) {
        try{
            string finalstr = 'Fac. Name,Month,Fixed Amount,Amount Paid,Amount to be Paid this Month,Reason \n';
            system.debug('district = '+district);
            District_Master__c dist = [select id, Payout_Admin_Password__c, Payout_Admin_Username__c, Payout_Supervisor_Password__c, 
                                       Payout_Supervisor_Username__c, name from District_Master__c  where id = :district limit 1];
            system.debug('$$$ dist' +dist);
            Date today = date.today();
            Date d = invoiceDate;
            list<salary__c> salaryToBeInsert = new list<salary__c>();
            list<salary__c> selectedFacilitator = new list<salary__c>();
            list<facilitatorWrapper> wrpData = (list<facilitatorWrapper>) JSON.deserialize(jsonData, list<facilitatorWrapper>.class);
            system.debug('wrpData === '+wrpData);
            string htmlBody;
            Set<String> reasonSet = new Set<String>{'Not to be paid'};
                for(facilitatorWrapper wrp : wrpData){
                    //system.debug('wrp = '+wrp);
                    salary__c sal = new salary__c();
                    if(wrp.SalaryStatus == 'Proposal Rejected'){
                        sal.id = wrp.SalaryId;
                    }
                    sal.Previous_Amount_Paid__c = wrp.PreviousAmountPaid;
                    sal.Salary_Month__c = wrp.SalaryMonth;
                    sal.Salary_Year__c = wrp.SalaryYear;
                    sal.Academic_Year__c = wrp.AcademicYear;
                    sal.Invoice_Date__c = invoiceDate;
                    sal.Fixed_Amount__c = wrp.FacilitatorFixedAmount;
                    sal.Contact__c = wrp.FacilitatorId;
                    sal.Active__c = wrp.Checkbox;
                    decimal amtPaidThisMonth=0;
                    if(wrp.Reason != 'Not to be Paid')
                        amtPaidThisMonth = wrp.FacilitatorAmtToBePaid;
                    if(wrp.Reason == '' && wrp.FacilitatorAmtToBePaid == 0)
                        amtPaidThisMonth = wrp.FacilitatorFixedAmount;
                    if(!reasonSet.contains(wrp.Reason))
                        amtPaidThisMonth = 0; 
                    sal.Amount_to_be_paid_this_month__c = (wrp.Reason != 'Not to be Paid') ? wrp.FacilitatorAmtToBePaid : 0;
                    decimal amtPaid=0;
                    if(wrp.Reason != 'Not to be Paid') amtPaid=  wrp.FacilitatorAmtToBePaid + wrp.AmountPaid; else amtPaid=0;
                    if(wrp.FacilitatorAmtToBePaid > wrp.FacilitatorFixedAmount)  amtPaid= wrp.FacilitatorAmtToBePaid;
                    sal.Amount_Paid__c = (wrp.Reason != 'Not to be Paid') ? wrp.FacilitatorAmtToBePaid + wrp.AmountPaid : wrp.FacilitatorFixedAmount;
                    sal.Reason__c = wrp.Reason;
                    decimal amtToBePaid = 0 ;
                    sal.District_Master__c = district;
                    if(wrp.Reason != 'Not to be Paid') amtToBePaid=wrp.FacilitatorFixedAmount - sal.Amount_Paid__c; else amtToBePaid=wrp.FacilitatorFixedAmount;
                    if(wrp.FacilitatorAmtToBePaid > wrp.FacilitatorFixedAmount)  amtToBePaid= 0;
                    sal.Amount_to_be_paid__c =  (wrp.Reason != 'Not to be Paid') ? amtToBePaid : 0;
                    String Recordstring = '"'+wrp.FacilitatorName+'","'+wrp.MonthYear+'","'+wrp.FacilitatorFixedAmount+'","'+wrp.PreviousAmountPaid+'","'+sal.Amount_to_be_paid_this_month__c +'","'+wrp.Reason+'",\n';
                    finalstr = finalstr+Recordstring;
                    sal.Status__c = 'Proposal Submitted';
                    if(wrp.Checkbox == true){
                        selectedFacilitator.add(sal);
                    }else{
                        sal.Amount_Paid__c = 0;
                        sal.Amount_to_be_paid__c = wrp.FacilitatorFixedAmount ;
                    }
                    salaryToBeInsert.add(sal);                    
                }
            String[] toAddresses = new String[]{dist.Payout_Supervisor_Username__c};
            String[] ccAddresses = Label.Facilitator_Fix_Payment_Supervisor_CC.split(',');
            String subject = 'Email for Payout Proposal';
            String body = 'Dear Supervisor,<br/><br/>Please find attached payout proposal for the invoice date '+String.valueOf(invoiceDate.day()).leftPad(2, '0')+'/'+String.valueOf(invoiceDate.month()).leftPad(2, '0')+'/'+String.valueOf(invoiceDate.year())+' and district '+dist.name +'<br/><br/>Thanks and Regards,<br/>CareerAware Team';
            String attachmentFileName = 'payoutProposalOfInvoice_'+String.valueOf(invoiceDate.day()).leftPad(2, '0')+'_'+String.valueOf(invoiceDate.month()).leftPad(2, '0')+'_'+String.valueOf(invoiceDate.year())+'.csv';
            Blob attachmentBody = blob.valueOf(finalstr);
            String attachmentContentType = 'text/csv';
            Messaging.SingleEmailMessage mail = sendEmailWithAttachment(toAddresses, subject, body, attachmentFileName, attachmentBody, attachmentContentType,true,ccAddresses);
            if(salaryToBeInsert.size() > 0){
                upsert salaryToBeInsert;
                if(selectedFacilitator.size() > 0) Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                return 'success';
            }
            return 'fail';
        }catch(exception e){
            system.debug('GenerateInvoiceFormController.generateInvoice, e.getMessage() : ' + e.getMessage());
            system.debug('GenerateInvoiceFormController.generateInvoice, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    public static Messaging.SingleEmailMessage sendEmailWithAttachment(String[] toAddresses, String subject, String body, String attachmentFileName, Blob attachmentBody, String attachmentContentType, boolean attachments,String[] ccAddresses) {
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
    public static string approveRejectPayout(string jsonData,string salaryMonth,string district, string status, datetime invoiceDate) {
        //system.debug('jsonData '+jsonData);
        //system.debug('@@invoiceDate '+invoiceDate);  
        try{
            DateTime currentDateTime = DateTime.now();
            District_Master__c dist = [select id, Payout_Admin_Password__c, Payout_Admin_Username__c, Payout_Supervisor_Password__c, 
                                       Payout_Supervisor_Username__c, name from District_Master__c  where id = :district limit 1];
            String owa = [select id, Address, DisplayName from OrgWideEmailAddress where Address='sfcareeraware@antarangfoundation.org'].Id;
            list<ContentVersion> contentVersionLst = new List<ContentVersion>();
            list<salary__c> lstOfSal = new list<salary__c>();
            set<Id> setOfSalaryId = new set<Id>();
            set<Id> setOfContactId = new set<Id>();
            list<Session__c> sessionLst = new list<Session__c>();
            list<facilitatorWrapper> wrpData = (list<facilitatorWrapper>) JSON.deserialize(jsonData, list<facilitatorWrapper>.class);
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            //system.debug('wrpData = '+wrpData);
            Map<string,decimal> mapWrpDate = new Map<string,decimal> ();
            Map<string,string> mapWrpReason = new Map<string,string> ();
            Set<String> reasonSet = new Set<String>{'Not to be paid'};
            for(facilitatorWrapper wrp : wrpData){
                //system.debug('wrp.Reason = '+wrp.Reason);
                if((!reasonSet.contains(wrp.Reason) || wrp.Checkbox != true) && wrp.AmountPaidToThisMonth != 0){
                    //system.debug('create invoice');
                    setOfContactId.add(wrp.FacilitatorId);
                    if (!mapWrpDate.containsKey(wrp.FacilitatorId)) {
                        mapWrpDate.put(wrp.FacilitatorId, wrp.AmountPaidToThisMonth);
                    }else{
                        mapWrpDate.put(wrp.FacilitatorId,mapWrpDate.get(wrp.FacilitatorId) + wrp.AmountPaidToThisMonth); }
                    if(wrp.Reason != null){
                        if (!mapWrpReason.containsKey(wrp.FacilitatorId)) {
                            mapWrpReason.put(wrp.FacilitatorId, wrp.Reason);
                        }else{
                            string reason = mapWrpReason.get(wrp.FacilitatorId)+ ',' + wrp.Reason;
                            mapWrpReason.put(wrp.FacilitatorId,reason); }
                    }
                }
                setOfSalaryId.add(wrp.SalaryId);
                
            }
            //system.debug('mapWrpDate = '+mapWrpDate);
            //system.debug('setOfSalaryId = '+setOfSalaryId);
            //system.debug('setOfContactId ='+setOfContactId);
            Map<Id,Integer> MapContentNContact = new Map<Id,Integer>();
           	for (AggregateResult result : [select count(id) amt, Contact__c from salary__c where Status__c = 'Invoice generated' and Contact__c in :setOfContactId Group By Contact__c]) {
                Id contactId = (Id)result.get('Contact__c');
                Integer count = (Integer)result.get('amt');
                MapContentNContact.put(contactId, count);
            }
            //system.debug('MapContentNContact = '+MapContentNContact);
            //system.debug('setOfContactId ='+setOfContactId);
            Map<string,Map<string,Integer>> sessionMap = new Map<string,Map<string,Integer>>();
            date dt = date.newinstance(invoiceDate.year(), invoiceDate.month(), invoiceDate.day());
            Map<String, Map<String, Integer>> sessionMap1 = new Map<String, Map<String, Integer>>();

            AggregateResult[] results = [SELECT COUNT(Id) amt, Assigned_Facilitator__c, Session_Grade__c
                                         FROM Session__c
                                         WHERE Assigned_Facilitator__c in :setOfContactId and SessionDate__c <= :dt AND Payment_Status__c = 'Ready For Payment'
                                         GROUP BY Assigned_Facilitator__c, Session_Grade__c];
            
            for (AggregateResult result : results) {
                String facilitator = (String)result.get('Assigned_Facilitator__c');
                String grade = (String)result.get('Session_Grade__c');
                Integer count = (Integer)result.get('amt');
                
                if (sessionMap1.containsKey(facilitator)) {
                    Map<String, Integer> innerMap = sessionMap1.get(facilitator);
                    innerMap.put(grade, count);
                } else {
                    Map<String, Integer> innerMap = new Map<String, Integer>();
                    innerMap.put(grade, count);
                    sessionMap1.put(facilitator, innerMap);
                }
            }
            for(Session__c ses :[select id,Session_Grade__c,SessionDate__c, Payment_Status__c,Total_Amount__c,Assigned_Facilitator__c from Session__c where Assigned_Facilitator__c in :setOfContactId and SessionDate__c <= :dt AND Payment_Status__c = 'Ready For Payment']){
                ses.Payment_Status__c  = 'Payment Made';
                sessionLst.add(ses);
                /*if (!sessionMap.containsKey(ses.Session_Grade__c)) {
                    sessionMap.put(ses.Session_Grade__c, new List<Session__c>());
                }
                sessionMap.get(ses.Session_Grade__c).add(ses);*/
            }
            //list<salary__c> lstOfRejectedSal = new list<salary__c>();
            for(salary__c sal : [select id,createdDate,Active__c, Contact__c,Fixed_Amount__c,Amount_to_be_paid__c, Contact__r.Id, Salary_Month__c ,Status__c , 
                                 Amount_Paid__c,Contact__r.Fixed_Amount__c,Contact__r.ownerId,Contact__r.Academic_Year__c,
                                 Contact__r.Name, Contact__r.npe01__WorkEmail__c,Invoice_Date__c,Reason__c,Previous_Amount_Paid__c,Amount_to_be_paid_this_month__c from 
                                 salary__c where id in :setOfSalaryId]){
				if(status == ''){
                    sal.Status__c = 'Proposal Rejected';
                }else{
                    if(!reasonSet.contains(sal.Reason__c) && sal.Active__c == true && sal.Amount_to_be_paid_this_month__c != 0 ){
                        sal.Status__c = 'Invoice Generated';
                    }else{
                        sal.Status__c = 'proposal approved	';
                    }
                }
                lstOfSal.add(sal);
     		}
            
            //Map<Id,contact> contactMap = new Map<Id,contact>([select id,name,MailingStreet,MailingCity,MailingState,MailingPostalCode,npe01__WorkEmail__c,MobilePhone,Bank_Account_No__c,IFSC_Code__c,PAN_Number__c from contact where id in:setOfContactId]);
            
            if(status == 'Invoice Generated'){
                string sessionDetails = '';
                for(contact con:[select id,name,ownerId,npe01__WorkEmail__c from contact where id in:setOfContactId]){
                    list<wrapResult> wrp = new list<wrapResult>();
                   
                    if(sessionMap1.containsKey(con.id)){
                        Map<String, Integer> innerMap = sessionMap1.get(con.id);
                        for (String innerKey : innerMap.keySet()) {
                            Integer value = innerMap.get(innerKey);
                            system.debug('Inner Key: ' + innerKey + ', Value: ' + value);
                            wrapResult wp = new wrapResult();
                            wp.description = value +' sessions of '+innerKey;
                            wrp.add(wp);
                        }
                    }
                    
                    /*for (String key : sessionMap.keySet()) {
                        List<Session__c> valueList = sessionMap.get(key);
                        Integer valueSize = valueList.size();
                        sessionDetails = valueSize +' sessions of '+key + '\n' + sessionDetails;
                    }*/
                    //system.debug('mapWrpDate.get(con.id) ='+mapWrpDate.get(con.id));
                    PageReference invoicePDF = Page.FacilitatorPaymentInvForExperienceSite;
                    //invoicePDF.getParameters().put('Total',String.valueOf(totalCount));
                    invoicePDF.getParameters().put('Id',con.id);
                    invoicePDF.getParameters().put('month', String.valueOf(invoiceDate.month()));
                    integer docCount;
                    if (MapContentNContact.containsKey(con.id)) {
                        docCount = MapContentNContact.get(con.id) + 1;
                    }else{
                         docCount = 1;
                    }
                    system.debug('invoicedate = '+invoicedate);
                    system.debug('invoiceDate = '+invoiceDate);
                    invoicePDF.getParameters().put('invoicedate', String.valueOf(invoicedate.day()).leftPad(2, '0')+'-'+String.valueOf(invoicedate.month()).leftPad(2, '0')+'-'+invoicedate.year());
                    invoicePDF.getParameters().put('invNum',String.valueOf(docCount));
                    invoicePDF.getParameters().put('Map',JSON.serialize(wrp));
                    invoicePDF.getParameters().put('sessionDetails',sessionDetails);
                    invoicePDF.getParameters().put('amount',String.valueOf(mapWrpDate.get(con.id)));
                    invoicePDF.getParameters().put('selectedMonthYear',String.valueOf(date.newInstance(invoicedate.year(),invoicedate.month(),invoicedate.day())));
                    //system.debug('invoicePDF = '+invoicePDF);
                    //system.debug(' invoicePDF.getContent() = '+ invoicePDF.getContent());
                    Blob body;
                    blob pdfbody;
                    if(!test.isRunningTest()){
                        pdfbody = invoicePDF.getContentAsPDF();
                    }else{
                        pdfbody = blob.valueof('TEST');
                    }
                    
                    ContentVersion conVer = new ContentVersion();
                    conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
                    conVer.PathOnClient = 'Invoice_for_'+invoiceDate.format('MMMM')+'_'+invoiceDate.year()+'_'+con.Name+'.pdf'; // The files name, extension is very important here which will help the file in preview.
                    conVer.Title = 'Invoice_for_'+invoiceDate.format('MMMM')+'_'+invoiceDate.year()+'_'+con.Name+'_'+String.valueOf(docCount);
                    conVer.VersionData = pdfbody; 
                    conVer.OwnerId  = userinfo.getUserId(); 
                    conVer.Record_Id__c = con.Id;
                    contentVersionLst.add(conVer);
                    string htmlBody = 'Dear '+con.Name+',<br/><br/>Please find attached your consultancy bill for the month of '+currentDateTime.format('MMMM');
                    if(String.valueOf(mapWrpReason.get(con.id)) != null) htmlBody += '<br/>Reason : '+String.valueOf(mapWrpReason.get(con.id));
                    htmlBody += '<br/><br/> <b>NOTE</b><ul><li>Full payment is only made once all data is updated for every student and session conducted before 22nd of '+currentDateTime.format('MMMM')+' <br/></li><li>To be paid on time, a signed copy of the attached invoice needs to be sent to  before 27th of '+currentDateTime.format('MMMM')+' <br/></li><li>A 10% TDS will be deducted on the total monthly payment</li></ul>If the signed invoice is not received on time the payment will be considered in the next month.<br/><br/><b>NEXT STEPS: To be completed before 27th of '+currentDateTime.format('MMMM')+'</b><br/><ol><li>Download the invoice attached.</li><li>Sign the invoice and send it on email to '+dist.Payout_Admin_Username__c+' before 27th '+currentDateTime.format('MMMM')+' </li></ol><br/><br/>Thanks and Regards,<br/>CareerAware Team';
                    
                    String[] toAddresses = new String[]{con.npe01__WorkEmail__c};
                    String[] ccAddresses = Label.Facilitator_Fix_Payment_InvoiceGenerated_CC.split(',');
                    String subject = 'Invoice for the month of '+invoiceDate.format('MMMM')+' and district '+dist.name;
                    String attachmentFileName = 'Invoice_for_'+invoiceDate.format('MMMM')+'_'+invoiceDate.year()+'_'+con.Name+'_'+String.valueOf(docCount)+'.pdf';
                    Blob attachmentBody = pdfbody;
                    String attachmentContentType = 'application/pdf';
                    Messaging.SingleEmailMessage mail = sendEmailWithAttachment(toAddresses, subject, htmlBody, attachmentFileName, attachmentBody, attachmentContentType, true,ccAddresses);
                    mailList.add(mail);
                    //system.debug('mailList = '+mailList);
                    
                }
            }else{
                String[] toAddresses = new String[]{dist.Payout_Admin_Username__c};
                String[] ccAddresses = Label.Facilitator_Fix_Payment_Admin_CC.split(',');
                String subject = 'Payout Proposal Rejected for month of ' + invoiceDate.format('MMMM') + ' ' +invoiceDate.year()+' and district '+dist.name;
                string body = 'Dear Admin ,<br/>Your Payout Proposal is rejected for month of ' + invoiceDate.format('MMMM') + ' ' +invoiceDate.year()+' and district '+dist.name+'<br/><br/>Thanks and Regards,<br/>CareerAware Team';
                String attachmentFileName = '';
                Blob attachmentBody = Blob.valueOf('');
                String attachmentContentType = '';
                Messaging.SingleEmailMessage aminMail = sendEmailWithAttachment(toAddresses, subject, body, attachmentFileName, attachmentBody, attachmentContentType, false,ccAddresses);
                
                mailList.add(aminMail);
            }
            //if(lstOfSal.size() > 0) update lstOfSal;
            if(mailList.size() > 0){
                if(sessionLst.size() > 0) update sessionLst;
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
                if(lstOfSal.size() > 0) update lstOfSal;
                //if(lstOfRejectedSal.size() > 0) delete lstOfRejectedSal;
                //system.debug('mailList = '+mailList);
                Messaging.sendEmail(mailList);
                return 'success';
            }if(lstOfSal.size() > 0){
                update lstOfSal;
                return 'success';	
            }
            else return 'fail';
        }catch(exception e){
            system.debug('GenerateInvoiceFormController.approveRejectPayout, e.getMessage() : ' + e.getMessage());
            system.debug('GenerateInvoiceFormController.approveRejectPayout, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    @AuraEnabled
    public static string generateFinanceFileNSend(Date invoiceDate, String district){
        try{
            //system.debug('district ='+district);
            Map<String, list<salary__c>> mapwithConIdNSal = new Map<String, list<salary__c>>();
            string status = 'Invoice generated';
            string query = 'select id, Contact__r.MailingStreet,Contact__r.MailingState,Contact__r.MailingCity,Contact__r.MailingPostalCode,Invoice_Date__c, Salary_Month__c, Contact__r.name, District_Master__r.name, Fixed_Amount__c, Amount_Paid__c , Amount_to_be_paid__c, District_Master__c,Amount_to_be_paid_this_month__c, Status__c, Contact__r.Batch_Code__c, Contact__r.G10_Batch_Code__c, Contact__r.G11_Batch_Code__c, Contact__r.Account.name, Contact__r.Full_Name__c , Contact__r.npe01__WorkEmail__c, Contact__r.PAN_Number__c, Contact__r.MailingAddress, Contact__r.MailingCountry, Contact__r.Bank_Account_No__c, Contact__r.IFSC_Code__c, Contact__r.Branch_Name__c, Contact__r.Bank_City__c ,Contact__r.TDS_Applicable__c, Contact__r.Bank_Name__c from salary__c where Invoice_Date__c = :invoiceDate AND Status__c = :status';
            if(district == null || district == '')
                system.debug('null');
            else
                query += ' AND District_Master__c = :district';
            //system.debug('query'+query);
            //system.debug('Database.query(query) = '+Database.query(query));
            for(salary__c sal : Database.query(query) ){
                if (!mapwithConIdNSal.containsKey(sal.Contact__c)) {
                    mapwithConIdNSal.put(sal.Contact__c, new List<Salary__c>());
                }
                mapwithConIdNSal.get(sal.Contact__c).add(sal);
            }
            //system.debug('mapwithConIdNSal = '+mapwithConIdNSal);
            if(mapwithConIdNSal.size() > 0){
                string finalstr = 'Invoice Date,Total Amount,Payment  Status,Assigned Facilitator: Full Name,Assigned Facilitator: Work Email,Assigned Facilitator: PAN Number,Assigned Facilitator: Mailing Address,Assigned Facilitator: Mailing City,Assigned Facilitator: Bank Account No.,Assigned Facilitator: IFSC Code,Assigned Facilitator: Branch Name,Assigned Facilitator: Bank City,Assigned Facilitator: TDS Applicable,TDS Deduction,Assigned Facilitator: Bank Name \n';
                //system.debug('mapwithConIdNSal.values() = '+mapwithConIdNSal.values());
                for (String key : mapwithConIdNSal.keySet()) {
                    List<Salary__c> salaryList = mapwithConIdNSal.get(key);
                    String Recordstring = '';
                    decimal totalAmt = 0;
                    string grade = '';
                    for (Salary__c sal : salaryList) {
                        system.debug('salaryList = '+salaryList);
                        totalAmt = sal.Amount_to_be_paid_this_month__c + totalAmt;
                        Recordstring = '"'+sal.Invoice_Date__c+'","'+totalAmt+'","'+sal.Status__c+'","'+sal.Contact__r.Full_Name__c+'","'+sal.Contact__r.npe01__WorkEmail__c+'","'+sal.Contact__r.PAN_Number__c+'","'+sal.Contact__r.MailingStreet+' '+sal.Contact__r.MailingCity+' '+sal.Contact__r.MailingPostalCode+' '+sal.Contact__r.MailingState+' '+sal.Contact__r.MailingCountry+'","'+sal.Contact__r.MailingCity+'","'+sal.Contact__r.Bank_Account_No__c+'","'+sal.Contact__r.IFSC_Code__c+'","'+sal.Contact__r.Branch_Name__c+'","'+sal.Contact__r.Bank_City__c +'","'+sal.Contact__r.TDS_Applicable__c+'","'+'10%'+'","'+sal.Contact__r.Bank_Name__c+'",\n';
                        
                    }
                    //system.debug('totalAmt = '+totalAmt);
                    finalstr += Recordstring;
                }
                //AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
                //String[] toAddresses = new String[]{antarangSett.Finance_Login_Username__c};
                //String[] ccAddresses = new String[]{'twinkle.k@kandisatech.com','bhagyashree.k@kandisatech.com'};
                String[] toAddresses = new String[]{Label.Finance_Login_Username};
                String[] ccAddresses = Label.Facilitator_Fix_Payment_Finance_CC.split(','); 
                String subject = 'Email for Payout Proposal';
                string body = 'Dear Finance Team,<br/><br/>Please find attached for payout proposal for the invoice date '+String.valueOf(invoiceDate.day()).leftPad(2, '0')+'/'+String.valueOf(invoiceDate.month()).leftPad(2, '0')+'/'+String.valueOf(invoiceDate.year())+'<br/><br/>Thanks and Regards,<br/>CareerAware Team';
                String attachmentFileName = 'payoutProposalOfInvoice_'+String.valueOf(invoiceDate.day()).leftPad(2, '0')+'_'+String.valueOf(invoiceDate.month()).leftPad(2, '0')+'_'+String.valueOf(invoiceDate.year())+'.csv';
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
                return 'No record found';
            }
            return '';
        }catch(exception e){
            system.debug('GenerateInvoiceFormController.generateFinanceFileNSend, e.getMessage() : ' + e.getMessage());
            system.debug('GenerateInvoiceFormController.generateFinanceFileNSend, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
            
        }
        
    } 
    @AuraEnabled
    public static list<facilitatorWrapper> showFaciliatorOnEdit(string district, date invoiceDate){
        DateTime invDate =invoiceDate;
        RecordType rt = [select id, name, SobjectType from RecordType where SobjectType = 'Contact' and name = 'CA Trainer'];
        string rtId = rt.id;
        string paymentType = 'Salary';
        set<Id> setConId = new set<Id>();
        for(contact con : [select id, name, Fixed_Amount__c,Academic_Year__c,npe01__WorkEmail__c,ownerId,Payment_Start_Date__c, (select id,name, School_Name__r.District__r.name,School_Name__r.District__r.Payout_Supervisor_Username__c from Batches__r where School_Name__r.District__r.id = :district) from contact where Facilitator_Work_Status__c = 'Active' and Payment_Type__c = :paymentType and RecordTypeId = :rtId ORDER BY Name]){
            //system.debug('con.Batches__r.size() ===' + con.Batches__r.size());
            //system.debug('con ===' +con);
            if(con.Batches__r.size() > 0){
                setConId.add(con.Id);
            }
        }
        integer invoiceYr = invDate.year();
        integer invoiceMonth = invDate.month();
        list<salary__c> checkSalaryCreatedForSelectedMonth = [select id, Contact__c,Amount_to_be_paid_this_month__c,Fixed_Amount__c,Amount_to_be_paid__c, Contact__r.Id, Salary_Month__c ,Status__c , 
                                                                  Amount_Paid__c,Contact__r.Fixed_Amount__c,Contact__r.ownerId,Contact__r.Academic_Year__c,
                                                                  Contact__r.Name, Previous_Amount_Paid__c, Contact__r.npe01__WorkEmail__c,Salary_Year__c,Invoice_Date__c,Reason__c from 
                                                                  salary__c where Salary_Year__c = :String.valueOf(invoiceYr) and Salary_Month__c = :String.valueOf(invoiceMonth) and Contact__c in :setConId and District_Master__c = :district];
       
        //system.debug('invoiceYr = '+invoiceYr);
        //system.debug('invoiceMonth = '+invoiceMonth);
        string conditionCheck ='0';
        list<facilitatorWrapper> facWrpList = new list<facilitatorWrapper>();
        list<salary__c> salList = new list<salary__c>();
        if(checkSalaryCreatedForSelectedMonth.size() != 0){
          conditionCheck ='1';
        }
        //system.debug('salList = '+salList);
            for(salary__c s : [select id, Contact__c,active__c ,Fixed_Amount__c,Amount_to_be_paid__c, Contact__r.Id, Salary_Month__c ,Salary_Year__c,Status__c , Amount_Paid__c,Contact__r.Fixed_Amount__c,Contact__r.ownerId,Contact__r.Academic_Year__c,Amount_to_be_paid_this_month__c,Contact__r.Name, Contact__r.npe01__WorkEmail__c,Invoice_Date__c,Reason__c,Previous_Amount_Paid__c from salary__c where District_Master__c = :district and contact__c in :setConId]){
                //system.debug('s.Invoice_Date__c.year()  ='+s.Invoice_Date__c.year() );
                //system.debug('s.Invoice_Date__c.month() = '+s.Invoice_Date__c.month());
                facilitatorWrapper facWrp = new facilitatorWrapper();
                DateTime inv = s.Invoice_Date__c;
                facWrp.FacilitatorId = s.Contact__r.Id;
                facWrp.FacilitatorName = s.Contact__r.Name;
                facWrp.FacilitatorEmail = s.Contact__r.npe01__WorkEmail__c;
                facWrp.FacilitatorFixedAmount = s.Fixed_Amount__c;
                facWrp.FacilitatorOwner = s.Contact__r.ownerId;
                facWrp.Checkbox = s.active__c;
                facWrp.Reason = /*(checkSalaryCreatedForSelectedMonth.size() == 0) ? '' : */s.Reason__c;
                facWrp.ReasonStatus = true;
                facWrp.AcademicYear = s.Contact__r.Academic_Year__c;
                facWrp.AmountPaid = s.Amount_Paid__c;
                facWrp.FacilitatorAmtToBePaid = s.Amount_to_be_paid__c;
                //facWrp.Month =  s.Salary_Month__c + ' ' +inv.year();
                facWrp.SalaryMonth = s.Salary_Month__c;
                facWrp.SalaryYear = s.Salary_Year__c;
                facWrp.SalaryId = s.id;
                facWrp.AmountPaidToThisMonth = s.Amount_to_be_paid_this_month__c;
                facWrp.SalaryStatus = /*(checkSalaryCreatedForSelectedMonth.size() == 0) ? '' : */s.Status__c;
                facWrp.PreviousAmountPaid = s.Previous_Amount_Paid__c;
                datetime dt1 = s.Invoice_Date__c;
                facWrp.invoiceMonth = dt1.format('M');
                /*if(conditionCheck == '1' && s.Invoice_Date__c.year() == invoiceYr && s.Invoice_Date__c.month() == invoiceMonth){
                    facWrpList.add(facWrp);
                }else if(conditionCheck == '0' && Integer.valueOf(s.Salary_Month__c) <= Integer.valueOf(invDate.format('M')) /*&& s.Amount_to_be_paid__c  != 0 && s.Fixed_Amount__c <= (s.Amount_to_be_paid_this_month__c + s.Previous_Amount_Paid__c)) facWrpList.add(facWrp);*/
                if(conditionCheck == '1' && s.Invoice_Date__c.year() == invoiceYr && s.Invoice_Date__c.month() == invoiceMonth){
                    facWrpList.add(facWrp);
                }else if(conditionCheck == '0' && s.Invoice_Date__c.year() == invoiceYr && s.Invoice_Date__c.month() == (invoiceMonth-1) && s.Amount_to_be_paid__c != 0 && s.Reason__c != 'Not to be paid'/*&& s.Status__c != 'Proposal Rejected'*/) facWrpList.add(facWrp);
                else if(conditionCheck == '0' && invoiceMonth == 1 &&s.Invoice_Date__c.year() == (invoiceYr-1) && s.Invoice_Date__c.month() == 12 && s.Amount_to_be_paid__c != 0 && s.Reason__c != 'Not to be paid'/*&& s.Status__c != 'Proposal Rejected'*/) facWrpList.add(facWrp);
                
            }            
       
        if(checkSalaryCreatedForSelectedMonth.size() == 0){
            AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
            set<Decimal> setAcademicYear = new set<Decimal>();
            if(setting.Academic_Year__c != null){setAcademicYear.add(setting.Academic_Year__c);}
            if(setting.Next_Academic_Year__c != null){setAcademicYear.add(setting.Next_Academic_Year__c);}
            for(contact con : [select id, name, Fixed_Amount__c,Academic_Year__c,npe01__WorkEmail__c,ownerId,Payment_Start_Date__c, (select id,name, School_Name__r.District__r.name,School_Name__r.District__r.Payout_Supervisor_Username__c from Batches__r where School_Name__r.District__r.id = :district) from contact where Facilitator_Work_Status__c = 'Active' and Payment_Type__c = :paymentType and RecordTypeId = :rtId and Payment_Start_Date__c <= : invoiceDate and Academic_Year__c in :setAcademicYear ORDER BY Name]){
                if(con.Batches__r.size() > 0){
                    facilitatorWrapper facWrp = new facilitatorWrapper();
                    facWrp.FacilitatorId = con.Id;
                    facWrp.FacilitatorName = con.Name;
                    facWrp.FacilitatorEmail = con.npe01__WorkEmail__c;
                    facWrp.FacilitatorFixedAmount = con.Fixed_Amount__c;
                    facWrp.FacilitatorAmtToBePaid = con.Fixed_Amount__c;
                    facWrp.FacilitatorOwner = con.ownerId;
                    facWrp.Checkbox = true;
                    facWrp.Reason = '';
                    facWrp.ReasonStatus = true;
                    facWrp.AcademicYear = con.Academic_Year__c;
                    facWrp.AmountPaid = 0;
                    facWrp.AmountPaidToThisMonth = 0;
                    //facWrp.Month = invDate.format('MMMM') + ' ' +invDate.year();
                    facWrp.SalaryMonth = invDate.format('M');
                    facWrp.SalaryYear = String.valueOf(invDate.year());
                    facWrp.SalaryStatus = '';
                    facWrp.PreviousAmountPaid = 0;
                    facWrp.SalaryId = '';
                    facWrp.invoiceMonth = invDate.format('M');
                    facWrpList.add(facWrp);
                }
            }
        }
        //system.debug('facWrpList = '+facWrpList);
        return facWrpList;
    }
    @AuraEnabled
	public static List<String> getPicklistValues() {
        List<String> picklistValues = new List<String>();
		String objectApiName = 'Salary__c'; // API name of the object
    	String fieldApiName = 'Reason__c'; // API name of the picklist field
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
    public class facilitatorWrapper{
        @AuraEnabled public String FacilitatorId {set;get;}
        @AuraEnabled public String FacilitatorEmail {set;get;}
        @AuraEnabled public String FacilitatorName {set;get;}
        @AuraEnabled public String FacilitatorOwner {set;get;}
        @AuraEnabled public decimal FacilitatorFixedAmount {set;get;}
        @AuraEnabled public boolean Checkbox {set;get;}
        @AuraEnabled public decimal FacilitatorAmtToBePaid {set;get;}
        @AuraEnabled public string Reason {set;get;}
        @AuraEnabled public boolean ReasonStatus {set;get;}
        @AuraEnabled public decimal AcademicYear {set;get;}
        @AuraEnabled public decimal AmountPaid {set;get;}
        @AuraEnabled public string MonthYear {set;get;}
        @AuraEnabled public string SalaryMonth {set;get;}
        @AuraEnabled public string SalaryYear {set;get;}
        @AuraEnabled public string SalaryStatus {set;get;}
        @AuraEnabled public string SalaryId {set;get;}
        @AuraEnabled public decimal AmountPaidToThisMonth {set;get;}
        @AuraEnabled public decimal PreviousAmountPaid{set;get;}
        @AuraEnabled public string invoiceMonth{set;get;}
    }
    public class wrapResult{
        public string description{get;set;}
        //public decimal rate{get;set;}
    }
}