public class SendPayoutController {
    
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
    
    //detail view
    public SendPayoutController(ApexPages.StandardController controller) {
        conIds = new List<Id>();
        conIds.add(controller.getId());
        isError = false;
        showSuccessMsg = false;
        contactMap = new Map<Id,contact>();
        
        contentVerLSt = new List<contentVersion>();
    }
    
    //list view
    public SendPayoutController(ApexPages.StandardSetController controller) {
        
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
    
    public void sendEmail(){ 
        isError = false;
        date d = date.newInstance(y,m,25);
        date tempdate = d.addMonths(-1);
        date dt = tempdate.addDays(1);
        system.debug('d:'+d + '   :::: dt '+dt);
        contactMap = new Map<Id,Contact>([select id,Name,email,Batch_Code__c from contact where id =: conIds]);
        
        Map<String,list<Session__c>> facilitatorWithSession = new Map<String,list<Session__c>>();
        Set<Id> schoolIds = new Set<Id>();
        
        List<Session__c> sessionLst = new List<Session__c>();
        
        for(Session__c s : [Select id,Name,Total_Amount__c,Batch__r.Donor_Name__c,Session_Grade__c,
                            Batch__r.School_Name__c,Batch__r.School_Name__r.Name,Assigned_facilitator__r.Email,
                            Batch__r.Batch_Number_edit__c,Session_Type__c,No_of_batches_for_counseling__c,
                            Batch__r.School_Name__r.X2021_22_Grade_10_counseling_completed__c
                            From Session__c
                            WHERE SessionDate__c <=:d AND SessionDate__c >=:dt 
                            AND Assigned_facilitator__c IN: contactMap.keyset() AND Assigned_facilitator__r.Email != NULL 
                            AND Batch__r.Donor_Name__c != NULL AND Session_Grade__c != NULL
                            AND Payment_Status__c = 'Ready For Payment' AND Is_Inactive_Session__c = false AND Session_Type__c != ''
                            Order By Batch__r.School_Name__r.Name, Session_Grade__c, Name, Batch__r.Donor_Name__r.Name  ASC])
        {
            
            schoolIds.add(s.Batch__r.School_Name__c);
            
            if(s.Session_Type__c == 'Counseling') {
                if(s.Batch__r.School_Name__r.X2021_22_Grade_10_counseling_completed__c == 'Yes'){
                    if(!facilitatorWithSession.containsKey(s.Assigned_Facilitator__c))
                        facilitatorWithSession.put(s.Assigned_Facilitator__c, new List<Session__c>());
                    facilitatorWithSession.get(s.Assigned_Facilitator__c).add(s);
                }
            } else {
                if(!facilitatorWithSession.containsKey(s.Assigned_Facilitator__c))
                    facilitatorWithSession.put(s.Assigned_Facilitator__c, new List<Session__c>());
                facilitatorWithSession.get(s.Assigned_Facilitator__c).add(s);
            }
            
            sessionLst.add(s);
        }
        
        
        if(facilitatorWithSession.size() > 0){
            List<Messaging.SingleEmailMessage> lstEmailMesages = new List<Messaging.SingleEmailMessage>();
            
            for(String bId : facilitatorWithSession.keyset()){
                lstEmailMesages.add(emailBody(bId,facilitatorWithSession.get(bId),d,dt));
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
    
    
    public  Messaging.SingleEmailMessage emailBody(Id facilitator,list<Session__c> SessionList,datetime d,datetime dt ){
        
        
        Messaging.SingleEmailMessage  email = new Messaging.SingleEmailMessage();
        string[] to = new string[] {contactMap.get(facilitator).Email};
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
        
        string htmlBody = 'Dear '+contactMap.get(facilitator).Name+',<br/>Thank you for your engagement with us and with our students last month.<br/><br/>';
        htmlBody += 'Please find your payment details for the month of '+d.format('MMMMM')+' '+y;
        htmlBody+= '<br/><br/><table border="1" style="table-layout: fixed;border-collapse: collapse;width:50%"><tr><th align="center"><b>Sr.No</b></th><th width="20%"><b>School Name</b></th><th align="center"><b>Grade</b></th><th align="center" width="30%"><b>Session Name</b></th><th align="center"><b>No. of Batches</b></th><th align="center"><b>Amount</b></th></tr>';
        
        double totalAmountpaid = 0;
        
        Map<String,wrapSessionEmailBody> wrapSessionEmailBodyMap = new Map<String,wrapSessionEmailBody>();
        for(Session__c se : SessionList){
            if(!wrapSessionEmailBodyMap.containsKey(se.Batch__r.School_Name__r.Name+'_'+se.Session_Grade__c+'_'+se.Name)){
                wrapSessionEmailBody wrap = new  wrapSessionEmailBody();
                wrap.schoolName = se.Batch__r.School_Name__r.Name;
                wrap.Grade = se.Session_Grade__c;
                wrap.SessionName = se.Name;
                if(se.Session_Type__c != 'Counseling'){
                    wrap.NumberOfBatches = 1;
                    wrap.PaidAmt = se.Total_Amount__c != null ? se.Total_Amount__c : 0;
                } else {
                    wrap.NumberOfBatches = Integer.valueOf(se.No_of_batches_for_counseling__c);
                    wrap.PaidAmt = se.Total_Amount__c != null ? se.Total_Amount__c * se.No_of_batches_for_counseling__c : 0;
                }
                wrapSessionEmailBodyMap.put(se.Batch__r.School_Name__r.Name+'_'+se.Session_Grade__c+'_'+se.Name, wrap);
            } else {
                    wrapSessionEmailBody wrap = wrapSessionEmailBodyMap.get(se.Batch__r.School_Name__r.Name+'_'+se.Session_Grade__c+'_'+se.Name);
                    if(se.Session_Type__c != 'Counseling'){
                        wrap.NumberOfBatches	+= 1;
                        wrap.PaidAmt 			+= se.Total_Amount__c != null ? se.Total_Amount__c : 0;
                        wrapSessionEmailBodyMap.put(se.Batch__r.School_Name__r.Name+'_'+se.Session_Grade__c+'_'+se.Name , wrap);
                    }
                   }
        }
        Integer cnt = 1;
        for(String wstr : wrapSessionEmailBodyMap.keySet()){
            htmlBody+= '<tr><td align="center">'+cnt+'</td><td>'+wrapSessionEmailBodyMap.get(wstr).schoolName+'</td><td align="center">'+wrapSessionEmailBodyMap.get(wstr).Grade+'</td><td align="center";width: 50px;>'+String.valueOf(wrapSessionEmailBodyMap.get(wstr).SessionName)+'</td><td align="center">'+wrapSessionEmailBodyMap.get(wstr).NumberOfBatches+'</td><td align="center">'+wrapSessionEmailBodyMap.get(wstr).PaidAmt+'</td></tr>';
            cnt++;
            totalAmountpaid+=wrapSessionEmailBodyMap.get(wstr).PaidAmt;
        }
        
        
        htmlBody+='</table><br/><br/>';
        htmlBody+='The total amount for the month of <b>'+d.format('MMMMM')+' '+y+'</b> is <b>'+totalAmountpaid+'</b>. There will be a <b>10% TDS deduction</b> on every batch payment. <br/><br/>';
        htmlBody+= '<b><u>NOTE</u></b><br/>';
        htmlBody+='<ul><li>Payment cycle starts from 26th of '+dt.format('MMMMM')+' to 25th of '+d.format('MMMMM')+'</li>';
        htmlBody+='<li>Sessions/Schools which are ending after the 25th of the month or the schools where data submission hasn’t happened before 25th of the month will be added into the next month’s payment cycle.</li></ul><br/><br/>';
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
            for(String key : tempMApSessionTypeGrade.keySet()){
                wrapResult w = new wrapResult();
                w.description = key.split('_')[1];
                w.SessionType = key.split('_')[0];
                w.rate = tempMApSessionTypeGrade.get(key)[0].Total_Amount__c;
                if(tempMApSessionTypeGrade.get(key)[0].Session_Type__c == 'Counseling'){
                    system.debug('Counseling :: '+tempMApSessionTypeGrade.get(key)[0].No_of_batches_for_counseling__c);
                    w.NumOfSession = CounselingMap.get(str); //Integer.valueOf(tempMApSessionTypeGrade.get(key)[0].No_of_batches_for_counseling__c);    
                    w.amount = w.rate != null ? CounselingMap.get(str) * w.rate :0; //w.rate != null ? tempMApSessionTypeGrade.get(key)[0].No_of_batches_for_counseling__c * w.rate :0;
                } else {
                    w.NumOfSession = tempMApSessionTypeGrade.get(key).size();    
                    w.amount = w.rate != null ? tempMApSessionTypeGrade.get(key).size() * w.rate :0;
                }
                
                wplst.add(w);
                Total+=w.amount;
                donorWiseTotal.put(str,Total);
            }
            erpdonor.put(str , wplst);
            
        }
        
        integer count = 0;
        for(string str : erpdonor.keyset()){
            
            PageReference word = Page.CATrainerInvoice;
            word.getParameters().put('Id',facilitator);
            word.getParameters().put('Map',JSON.serialize(erpdonor.get(str)));
            word.getParameters().put('Total',String.valueOf(donorWiseTotal.get(str)));
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
        
        if(email != null){
            return email;
        }
        else{
            return null;
        }
    }
    
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
            }
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
        public string SessionType{get;set;}
        public integer NumOfSession{get;set;}
        public decimal rate{get;set;}
        public decimal amount{get;set;}
    }
    
    public class wrapSessionEmailBody{
        public String schoolName;
        public String Grade;
        public String SessionName;
        public Integer NumberOfBatches;
        public Decimal PaidAmt;
    } 

}