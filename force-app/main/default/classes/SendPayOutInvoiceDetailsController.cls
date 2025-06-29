public class SendPayOutInvoiceDetailsController {
    
    public boolean isError {get; set;}
    public  Integer m {get;set;}
    public  Integer y {get;set;}
    public string msg{get;set;}
    public String monthAndYear {get;set;}
    public List<Id> conIds {get;set;}
    public Map<Id,contact> contactMap;
    public list<contentVersion>  contentVerLSt;
    public boolean showSuccessMsg {get;set;}
    public boolean trainerNotSelected{get;set;}
    
    //detail page
    public SendPayOutInvoiceDetailsController(ApexPages.StandardController controller) {
        conIds = new List<Id>();
        conIds.add(controller.getId());
        isError = false;
        showSuccessMsg = false;
        contactMap = new Map<Id,contact>();
        
        contentVerLSt = new List<contentVersion>();
    }
    
    //list view
    public SendPayOutInvoiceDetailsController(ApexPages.StandardSetController controller) {
        
        isError = false;
        if(controller.getSelected() == NULL || controller.getSelected().size()<=0){
            
            trainerNotSelected = false;
            apexpages.addmessage(new apexpages.message(apexpages.severity.error, 'Please select Trainer to send Payout!'));  
        }
        else{
            trainerNotSelected = true;
            contactMap = new Map<Id,contact>();
            conIds = new List<Id>();
            contentVerLSt = new List<contentVersion>();
            for (contact con : (List<contact>)controller.getSelected()){
                conIds.add(con.Id);
            }
            
        }
        
        
    }
    
    //redirect to list view once email sent
    public pageReference backToAccount(){
        PageReference pg = new PageReference('/'+contact.sobjecttype.getDescribe().getKeyPrefix());
        pg.setRedirect(true);
        return pg;
    }
    
    //Email Send
    public void sendEmail(){
        isError = false;
        
        
        date d = date.newInstance(y,m,25);
        date tempdate = d.addMonths(-1);
        date dt = tempdate.addDays(1);
        system.debug('d:'+d + '   :::: dt '+dt);
        contactMap = new Map<Id,Contact>([select id,Name,email,Batch_Code__c from contact where id =: conIds]);
        
        Map<Id,list<Session__c>> facilitatorSessionMap = new Map<Id,list<session__c>>();
        List<Session__c> sessionLst = new List<Session__c>();
        for(Session__c s : [select id,Total_Amount__c,Batch__r.Donor_Name__c,Session_Grade__c,
                            Batch__r.School_Name__c,Batch__r.School_Name__r.Name,Assigned_facilitator__r.Email
                            from Session__c WHERE SessionDate__c <=:d AND SessionDate__c >=:dt 
                            AND Assigned_facilitator__c IN: contactMap.keyset() AND Session_Grade__c != NULL 
                            AND Assigned_facilitator__r.Email != NULL AND Batch__r.Donor_Name__c != NULL
                            AND Payment_Status__c = 'Ready For Payment'])
        {
            
            if(!facilitatorSessionMap.containsKey(s.Assigned_facilitator__c))
                facilitatorSessionMap.put(s.Assigned_Facilitator__c, new List<session__c>());
            facilitatorSessionMap.get(s.Assigned_Facilitator__c).add(s);
            
            sessionLst.add(s);
        }
        
        if(facilitatorSessionMap.keyset().size()>0){
            
            List<Messaging.SingleEmailMessage> lstEmailMesages = new List<Messaging.SingleEmailMessage>();
            
            for(Id facilitator : facilitatorSessionMap.keyset()){
                
                lstEmailMesages.add(emailBody(facilitator,facilitatorSessionMap.get(facilitator),d,dt)); 
            }
            
            
            try{
                Messaging.sendEmail(lstEmailMesages); 
                if(contentVerLSt.size()>0){
                    
                    insert contentVerLSt;
                    
                    /////
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
                    List<Session__c> sessionToUpdate = new List<Session__c>();
                    for(Session__c objSession : sessionLst){
                        objSession.Payment_Status__c = 'Payment Made';
                        sessionToUpdate.add(objSession);
                    }
                    
                    if(sessionToUpdate.size()>0){
                        update sessionToUpdate;
                        showSuccessMsg=true;
                    }
                    
                }
                
            }
            catch(exception e){
                apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
            }
            
        }
        else{
            system.debug('ELSE');
            isError = true;
            msg = 'No record meet criteria! Please check if Donor is populate, Seassion Date fall in selected month, Payment status is ready for payment of session record ';
            //   apexpages.addmessage(new apexpages.message(apexpages.severity.info,'No record meet criteria!'));
        }
        
    }
    
    //email body and content version 
    public  Messaging.SingleEmailMessage emailBody(Id facilitator,list<Session__c> SessionList,datetime d,datetime dt ){
        
        
        Messaging.SingleEmailMessage  email = new Messaging.SingleEmailMessage();
        string[] to = new string[] {contactMap.get(facilitator).Email};
            email.setToAddresses(to);
        email.setSubject('Payout mail');
        
        
        map<id,list<Session__c>> schoolsessionMap = new Map<id,list<Session__c>>();
        map<id,map<string,integer>> sesionMap = new map<id,map<string,integer>>();
        
        map<string,decimal> gradeRateMap = new map<string,decimal>();
        map<string,integer> tempMap = new map<string,integer>();        
        Map<string,Map<string,integer>> tempdonorTotalSessionMap = new Map<string,Map<string,integer>>();
        
        for(Session__c s : SessionList)
        {
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
            
        }
        
        
        string htmlBody = 'Dear '+contactMap.get(facilitator).Name+',<br/>Thank you for your engagement with us and with our students last month.<br/><br/>';
        htmlBody += 'Please find your payment details for the month of '+d.format('MMMMM')+' '+y;
        htmlBody+= '<br/><br/><table border="1" style="table-layout: fixed;border-collapse: collapse;width:50%"><tr><th align="center"><b>Sr.No</b></th><th align="center"><b>School Name</b></th><th align="center"><b>No. of sessions</b></th><th align="center"><b>Amount Paid</b></th></tr>';
        integer num=1;
        double totalAmountpaid = 0;
        for(Id i :schoolsessionMap.keyset()){
            integer totalSession = 0;
            double Total = 0;
            string SchoolName;
            // for(Batch__c b : schoolBatchMap.get(i)){
            totalSession+= schoolsessionMap.get(i).size();
            //SchoolName = schoolBatchMap.get(i)[0]Batch__r.School_Name__r.Name;
            for(Session__c se : schoolsessionMap.get(i)){
                SchoolName = se.Batch__r.School_Name__r.Name;
                total+= se.Total_Amount__c != null ? se.Total_Amount__c :0;
            }
            //}
            totalAmountpaid+=total;
            htmlBody+= '<tr><td align="center">'+num+'</td><td align="center">'+SchoolName+'</td><td align="center">'+totalSession+'</td><td align="center">'+Total+'</td></tr>';
            num++;
        }
        htmlBody+='</table><br/><br/>';
        htmlBody+='There will be a <b>10% TDS deduction</b> on every batch payment. The total amount paid to you for the month of '+d.format('MMMMM')+' '+y+' is '+totalAmountpaid+'.<br/><br/>';
        htmlBody+= '<b><u>NOTE</u></b><br/>';
        htmlBody+='<ul><li>Payment cycle starts from 26th of the '+dt.format('MMMMM')+' to 25th of the '+d.format('MMMMM')+'</li>';
        htmlBody+='<li>Sessions/Schools which are ending after the 25th of the month or the schools where data submission hasn’t happened before 25th of the month will be added into the next month’s payment cycle.</li></ul><br/><br/>';
        htmlBody+='Thanks and Regards,<br/>CareerAware Team';
        
        
        List<Messaging.EmailFileAttachment > lstEmailAttachment = new List<Messaging.EmailFileAttachment >();          
        integer count = 0;
        for(id se : sesionMap.keyset()){
            count++; 
            list<wrapResult> wplst = new list<wrapResult>();
            decimal Total = 0;
            for(string m : sesionMap.get(se).keyset()){
                wrapResult w = new wrapResult();
                w.description = m;
                w.NumOfSession = sesionMap.get(se).get(m);
                w.rate = gradeRateMap.get(m);
                w.amount = w.rate != null ? w.NumOfSession * w.rate :0;
                wplst.add(w);
                total+=w.amount;
            }
            
            PageReference word = Page.CATrainerInvoice;
            word.getParameters().put('Id',facilitator);
            word.getParameters().put('Map',JSON.serialize(wplst));
            word.getParameters().put('Total',String.valueOf(total));
            word.getParameters().put('selectedMonthYear',String.valueOf(date.newInstance(y,m,1)));
            //word.getParameters().put('selectedMonthYear',String.valueOf(y)+'/'+String.valueOf(m));
            word.getParameters().put('invNum',String.valueOf(count));
            
            // pdf.setRedirect(true);
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
            conVer.PathOnClient = 'Invoice_'+contactMap.get(facilitator).Name+'_'+d+' '+y+'.doc'; // The files name, extension is very important here which will help the file in preview.
            //conVer.Title = 'Invoice_'+c.Name+'_'+d+' '+y; // Display name of the files
            conVer.Title = 'Invoice_'+contactMap.get(facilitator).Name+'_'+String.valueOf(date.newInstance(y,m,1))+'/'+count;
            conVer.VersionData = body; 
            conVer.Record_Id__c = facilitator;
            contentVerLSt.add(conVer);
            
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName('Invoice_'+contactMap.get(facilitator).Name+'_'+String.valueOf(date.newInstance(y,m,1))+'/'+count+'.pdf');
            attach.setInline(false);
            attach.Body = pdfbody;
            lstEmailAttachment.add(attach);
            
            
            
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
        
        if(email != null){
            return email;
        }
        else{
            return null;
        }
        //try{
        //}catch(exception e){
        //isError = true;
        //msg = e.getMessage();
        //}
        // return email;
        
        
        
        
        
    }
    
    
    //send email button 
    public PageReference submitSingle(){
        system.debug('monthAndYear :'+monthAndYear);
        if(String.isNotBlank(monthAndYear) && monthAndYear.contains('-')){
            List<String> temp = monthAndYear.split('-');
            m = Integer.valueOf(temp[0]);
            y = Integer.valueOf(temp[1]);
            sendemail();
            
            if(isError) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
                return null;
            } //else {                
            //PageReference pg = new PageReference('/'+contact.sobjecttype.getDescribe().getKeyPrefix());
            //pg.setRedirect(true);
            //return pg;
            //}
        }
        return null;
    }
    
    public List<SelectOption> getMonthAndYearOptions(){
        List<SelectOption> ret = new List<SelectOption>();
        Date thisMonth = System.today().toStartOfMonth(), 
            januaryLastYear = Date.newInstance(System.today().year() -1, 1, 1);
        dateTime d = System.today();
        ret.add(new selectoption('--None--','--None--'));
        while(d >= januaryLastYear){
            ret.add(new SelectOption(d.format('MM-YYYY'), d.format('MMMM YYYY'))); 
            d = d.addMonths(-1);
        }
        return ret;
    }
    
    public class wrapResult{
        public string description{get;set;}
        public integer NumOfSession{get;set;}
        public decimal rate{get;set;}
        public decimal amount{get;set;}
    }
    
}