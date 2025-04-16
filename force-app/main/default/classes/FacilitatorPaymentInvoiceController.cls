public without sharing class FacilitatorPaymentInvoiceController {
    public string month{get;set;}
    public string tempstring{get;set;}
    //public string tempstringForContact{get;set;}
    public string invoicedate{get;set;}
    public id contactId{get;set;}
    public string selectedMonthYear{get;set;}
    public Contact contact {set;get;}
    public string invNum{get;set;}
    public list<GenerateInvoiceFormController.wrapResult> reslst{get;set;}
    //public string total{get;set;}
    public string strOrgId{get;set;}
    public string fullRecordURL{get;set;}
    public string sessionDetails{get;set;}
    public string amount{get;set;}   
    public FacilitatorPaymentInvoiceController() {
        tempstring = System.currentPagereference().getParameters().get('Map');
        month = System.currentPagereference().getParameters().get('month');
        invoicedate = System.currentPagereference().getParameters().get('invoicedate');
        selectedMonthYear = System.currentPagereference().getParameters().get('selectedMonthYear');
        system.debug('selectedMonthYear ' +selectedMonthYear);
        if(selectedMonthYear != null){
            selectedMonthYear = selectedMonthYear.replaceAll('/', '-');
            date dt  = date.valueof(selectedMonthYear); 
            selectedMonthYear = dt.month()+'/'+dt.year();
            //system.debug('selectedMonthYear :: '+selectedMonthYear);
        }
        invNum = System.currentPagereference().getParameters().get('invNum');
        contactId = System.currentPagereference().getParameters().get('Id');
        //system.debug('contactId = '+contactId);
        contact = [select id,name,MailingStreet,MailingCity,MailingState,MailingPostalCode,npe01__WorkEmail__c,MobilePhone,Bank_Account_No__c,IFSC_Code__c,PAN_Number__c,Document_Id__c from contact where id = :contactId];
		sessionDetails = System.currentPagereference().getParameters().get('sessionDetails');
        amount = System.currentPagereference().getParameters().get('amount');
        strOrgId = UserInfo.getOrganizationId();
        fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm();
        reslst = (list<GenerateInvoiceFormController.wrapResult>)JSON.deserializeStrict(tempstring , list<GenerateInvoiceFormController.wrapResult>.class);
    	//system.debug('contact ='+con);
    }
}