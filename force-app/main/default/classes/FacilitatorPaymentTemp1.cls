public class FacilitatorPaymentTemp1 {
    
    public boolean isError {get; set;}
    public  Integer selectedMonth {get;set;}
    public  Integer selectedYear {get;set;}
    public string msg{get;set;}
    public String monthAndYear {get;set;}
    public List<Id> conIds {get;set;}
    public Map<Id,contact> contactMap;
    public list<contentVersion>  contentVerLSt;
    public boolean showSuccessMsg {get;set;}
    public boolean trainerNotSelected{get;set;}
    
    public FacilitatorPaymentTemp1(ApexPages.StandardController controller) {
        conIds = new List<Id>();
        conIds.add(controller.getId());
        isError = false;
        showSuccessMsg = false;
        contactMap = new Map<Id,contact>();
        
        contentVerLSt = new List<contentVersion>();
    }
    
    //list view
    public FacilitatorPaymentTemp1(ApexPages.StandardSetController controller) {
        
        isError = false;
        if(controller.getSelected() == NULL || controller.getSelected().size()<=0){
            
            trainerNotSelected = false;
            apexpages.addmessage(new apexpages.message(apexpages.severity.error, 'Please select Trainer to send Payout!'));  
        }
        else{
            trainerNotSelected = true;
            contactMap = new Map<Id,contact>();
            conIds = new List<Id>();
            contentVerLst = new List<contentVersion>();
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
    
    public PageReference submitSingle(){
        system.debug('monthAndYear :'+monthAndYear);
        if(String.isNotBlank(monthAndYear) && monthAndYear.contains('-')){
            List<String> temp = monthAndYear.split('-');
            selectedMonth = Integer.valueOf(temp[0]);
            selectedYear = Integer.valueOf(temp[1]);
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
    
    public void sendEmail(){ 
        Map<String,list<Session__c>> facilitatorWithSession = new Map<String,list<Session__c>>();
        Set<Id> schoolIds			= new Set<Id>();
        List<Session__c> sessionLst	= new List<Session__c>();        
        isError						= false;        
        date d 						= date.newInstance(selectedYear,selectedMonth,25);//selected month
        date tempdate 				= d.addMonths(-1);
        date dt 					= tempdate.addDays(1);//last month
        system.debug('selected month-d:'+d + '   :::: last month-dt '+dt);
        
        contactMap = new Map<Id,Contact>([Select Id,Name,email,Batch_Code__c
                                          From contact
                                          Where Id =: conIds]);
        //Add all sessions of a facilitator
        for(Session__c s : [Select id,Name,Total_Amount__c,Batch__r.Donor_Name__c,Session_Grade__c,
                            Batch__r.School_Name__c,Batch__r.School_Name__r.Name,Assigned_facilitator__r.Email,
                            Batch__r.Batch_Number_edit__c,Session_Type__c,No_of_batches_for_counseling__c,
                            Batch__r.School_Name__r.X2021_22_Grade_10_counseling_completed__c
                            From Session__c
                            WHERE SessionDate__c <=:d AND SessionDate__c >=:dt 
                            AND Assigned_facilitator__c IN: contactMap.keyset() AND Assigned_facilitator__r.Email != NULL 
                            AND Batch__r.Donor_Name__c != NULL AND Session_Grade__c != NULL
                            AND Payment_Status__c = 'Ready For Payment' AND Is_Inactive_Session__c = false AND Session_Type__c != ''
                            Order By Batch__r.School_Name__r.Name, Session_Grade__c, Name, Batch__r.Donor_Name__r.Name ])
        {   
            schoolIds.add(s.Batch__r.School_Name__c);
            system.debug('s.Batch__r.School_Name__c '+s.Batch__r.School_Name__r.Name+' s.Session_Grade__c '+s.Session_Grade__c+' s.Name '+s.Name);
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
            system.debug('sessionLst '+sessionLst.size()+sessionLst);
        system.debug('facilitatorWithSession '+facilitatorWithSession.size()+facilitatorWithSession);
        if(facilitatorWithSession.size() > 0){
            List<Messaging.SingleEmailMessage> lstEmailMesages = new List<Messaging.SingleEmailMessage>();
            
             for(String bId : facilitatorWithSession.keyset()){
                lstEmailMesages.add(emailBody(bId,facilitatorWithSession.get(bId),d,dt));
            }
            
            try{
                Messaging.sendEmail(lstEmailMesages); 
                if(contentVerLSt.size()>0){                    
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
                    List<Session__c> sessionToUpdate = new List<Session__c>();
                    for(Session__c objSession : sessionLst){
                        objSession.Payment_Status__c = 'Payment Made';
                        sessionToUpdate.add(objSession);
                    }
                    
                    if(sessionToUpdate.size()>0){
                        showSuccessMsg=true;
                    }                    
                }                
            }
            catch(exception e){
                apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
            }
        }
        
    }
    
    public Messaging.SingleEmailMessage emailBody(Id facilitator, List<Session__c> SessionList, Datetime d, Datetime dt) {
        Map<String, List<Session__c>> sessInvoiceMap				= new Map<String, List<Session__c>>();
        Map<String, List<Session__c>> sessInvoicePDFMap 			= new Map<String, List<Session__c>>();
        Map<string,integer> tempMap 								= new Map<string,integer>();   
        Map<String,wrapSessionEmailBody> wrapSessionEmailBodyMap	= new Map<String,wrapSessionEmailBody>();
        List<Messaging.EmailFileAttachment > lstEmailAttachment 	= new List<Messaging.EmailFileAttachment >();
        List<wrapResult> wplst										= new list<wrapResult>();
        Map<string,List<wrapResult>> erpdonor 						= new Map<string,List<wrapResult>>();
        Decimal Total 												= 0;
        Messaging.SingleEmailMessage email 							= new Messaging.SingleEmailMessage();                
        
        String[] to = new String[] {contactMap.get(facilitator).Email};
            email.setToAddresses(to);
        email.setSubject('Payout mail');
        
        //InvoicePDFMap for each Donor
        for(Session__c s : SessionList)
        {
            if(!sessInvoicePDFMap.containsKey(s.Batch__r.Donor_Name__c))
                sessInvoicePDFMap.put(s.Batch__r.Donor_Name__c , new List<Session__c>());
            sessInvoicePDFMap.get(s.Batch__r.Donor_Name__c).add(s);
        }
        system.debug('sessInvoicePDFMap '+sessInvoicePDFMap.size()+sessInvoicePDFMap);
        
        String htmlBody	 =	'Dear '+contactMap.get(facilitator).Name+',<br/>Thank you for your engagement with us and with our students last month.<br/><br/>';
        htmlBody		+=	'Please find your payment details for the month of '+d.format('MMMMM')+' '+selectedYear;
        htmlBody		+=	'<br/><br/><table border="1" style="table-layout: fixed;border-collapse: collapse;width:50%"><tr><th align="center"><b>Sr.No</b></th><th width="20%"><b>School Name</b></th><th align="center"><b>Grade</b></th><th align="center"><b>Session Name</b></th><th align="center"><b>No. of Batches</b></th><th align="center"><b>Amount</b></th></tr>';
        Integer	num				= 1;
        Double	totalAmountpaid	= 0;
        Double	TotalAmt		= 0;
        String	SchoolName;        
        //Email Body
        for(Session__c se : SessionList){
            SchoolName	=	se.Batch__r.School_Name__r.Name;
            TotalAmt	+=	se.Total_Amount__c != null ? se.Total_Amount__c : 0;
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
            } else { system.debug('contains');
                wrapSessionEmailBody wrap = wrapSessionEmailBodyMap.get(se.Batch__r.School_Name__r.Name+'_'+se.Session_Grade__c+'_'+se.Name);
                if(se.Session_Type__c != 'Counseling'){
                    wrap.NumberOfBatches	+= 1;
                    wrap.PaidAmt 			+= se.Total_Amount__c != null ? se.Total_Amount__c : 0;
                    wrapSessionEmailBodyMap.put(se.Batch__r.School_Name__r.Name+'_'+se.Session_Grade__c+'_'+se.Name , wrap);
                }
            }
        }
        //create table data in email body
        Integer cnt = 1;
        for(String wstr : wrapSessionEmailBodyMap.keySet()){
            htmlBody+= '<tr><td align="center">'+cnt+'</td><td>'+wrapSessionEmailBodyMap.get(wstr).schoolName+'</td><td align="center">'+wrapSessionEmailBodyMap.get(wstr).Grade+'</td><td align="center">'+wrapSessionEmailBodyMap.get(wstr).SessionName+'</td><td align="center">'+wrapSessionEmailBodyMap.get(wstr).NumberOfBatches+'</td><td align="center">'+wrapSessionEmailBodyMap.get(wstr).PaidAmt+'</td></tr>';
            cnt++;
        }
        
        htmlBody+='</table><br/><br/>';
        htmlBody+='There will be a <b>10% TDS deduction</b> on every batch payment. The total amount paid to you for the month of '+d.format('MMMMM')+' '+selectedYear+' is '+totalAmountpaid+'.<br/><br/>';
        htmlBody+= '<b><u>NOTE</u></b><br/>';
        htmlBody+='<ul><li>Payment cycle starts from 26th of the '+dt.format('MMMMM')+' to 25th of the '+d.format('MMMMM')+'</li>';
        htmlBody+='<li>Sessions/Schools which are ending after the 25th of the month or the schools where data submission hasn’t happened before 25th of the month will be added into the next month’s payment cycle.</li></ul><br/><br/>';
        htmlBody+='Thanks and Regards,<br/>CareerAware Team';
        //for invoide pdf
        for(String str : sessInvoicePDFMap.keySet()) {
            Map<String,List<Session__c>> data	= new Map<String,List<Session__c>>();
            for(Session__c se : sessInvoicePDFMap.get(str)) {
                if(!erpdonor.containsKey(se.Session_Grade__c+'_'+se.Session_Type__c))
                    erpdonor.put(se.Session_Grade__c+'_'+se.Session_Type__c, new List<wrapResult>());
                else {
                    wrapResult w		= new wrapResult();
                    w.description		= se.Session_Grade__c;
                    w.SessionType		= se.Session_Type__c;
                    w.rate				= se.Total_Amount__c;
                    if(se.Session_Type__c == 'Counseling') {
                        w.NumOfSession	= Integer.valueOf(se.No_of_batches_for_counseling__c);    
                        w.amount		= w.rate != null ? se.No_of_batches_for_counseling__c * w.rate : 0;
                    } else {
                        w.NumOfSession	= sessInvoicePDFMap.get(str).size();    
                        w.amount		= w.rate != null ? sessInvoicePDFMap.get(str).size() * w.rate : 0;
                    }
                    
                    wplst.add(w);
                    total	+= w.amount;
                    
                    erpdonor.get(se.Session_Grade__c+'_'+se.Session_Type__c).add(w);
                    system.debug('erpdonor '+erpdonor);
                }
            }

        }
        Integer count = 0;
        for(String str : erpdonor.keySet()){
            count++;
            PageReference word = Page.CATrainerInvoice;
            word.getParameters().put('Id',facilitator);
            word.getParameters().put('Map',JSON.serialize(erpdonor.get(str)));
            word.getParameters().put('Total',String.valueOf(total));
            word.getParameters().put('selectedMonthYear',String.valueOf(date.newInstance(selectedYear,selectedMonth,1)));
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
            conVer.PathOnClient = 'Invoice_'+contactMap.get(facilitator).Name+'_'+d+' '+selectedYear+'.doc'; // The files name, extension is very important here which will help the file in preview.
            //conVer.Title = 'Invoice_'+c.Name+'_'+d+' '+y; // Display name of the files
            conVer.Title = 'Invoice_'+contactMap.get(facilitator).Name+'_'+String.valueOf(date.newInstance(selectedYear,selectedMonth,1))+'/'+count;
            conVer.VersionData = body; 
            conVer.Record_Id__c = facilitator;
            contentVerLSt.add(conVer);
            
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName('Invoice_'+contactMap.get(facilitator).Name+'_'+String.valueOf(date.newInstance(selectedYear,selectedMonth,1))+'/'+count+'.pdf');
            attach.setInline(false);
            attach.Body = pdfbody;
            lstEmailAttachment.add(attach);            
        }
        email.setFileAttachments(lstEmailAttachment);                 
        system.debug('htmlBody :: '+htmlBody);        
        email.setHtmlBody(htmlBody);
        
        return email;
    }
    
    public class wrapSessionEmailBody{
        public String schoolName;
        public String Grade;
        public String SessionName;
        public Integer NumberOfBatches;
        public Decimal PaidAmt;
    }
    
    public class wrapResult{
        public string description{get;set;}
        public string SessionType{get;set;}
        public integer NumOfSession{get;set;}
        public decimal rate{get;set;}
        public decimal amount{get;set;}
    }
    
}