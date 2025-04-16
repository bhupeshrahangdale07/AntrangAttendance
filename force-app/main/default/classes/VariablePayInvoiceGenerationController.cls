public without sharing class VariablePayInvoiceGenerationController {
    public id contactId{get;set;}
    public string tempstring{get;set;}
    public string total{get;set;}
    public string selectedMonthYear{get;set;}
    public list<VariablePayController.wrapResult> reslst{get;set;}
    public string invoiceDate{get;set;}
    public string inNum{get;set;}
    public contentversion conv{get;set;}
    public string strOrgId{get;set;}
    public string fullRecordURL{get;set;}
    public date invoiceNum{get;set;}
    
    public Contact contact {set;get;}

    public VariablePayInvoiceGenerationController() {
        //contact = (contact) controller.getRecord();
        contactId = System.currentPagereference().getParameters().get('Id');
        contact = [select id,name,MailingStreet,MailingCity,MailingState,MailingPostalCode,npe01__WorkEmail__c,MobilePhone,Bank_Account_No__c,IFSC_Code__c,PAN_Number__c,Document_Id__c from contact where id = :contactId];
        system.debug('contact = '+contact);
        if(contact.Bank_Account_No__c != null){
        	contact.Bank_Account_No__c = contact.Bank_Account_No__c.replaceAll('\'','');
        }
        
        contactId = System.currentPagereference().getParameters().get('Id');
        total = System.currentPagereference().getParameters().get('Total');
        tempstring = System.currentPagereference().getParameters().get('Map');
        selectedMonthYear = System.currentPagereference().getParameters().get('selectedMonthYear');
        if(selectedMonthYear != null){
            selectedMonthYear = selectedMonthYear.replaceAll('/', '-');
            date dt  = date.valueof(selectedMonthYear); 
            selectedMonthYear = dt.month()+'/'+dt.year();
            system.debug('selectedMonthYear :: '+selectedMonthYear);
        }
        
        
        inNum = System.currentPagereference().getParameters().get('invNum');
        
        //invoiceDate = String.valueOf(system.today().day()).leftPad(2, '0')+'-'+String.valueOf(system.today().month()).leftPad(2, '0')+'-'+system.today().year() ;//string.valueOf(system.today());
        invoiceDate = System.currentPagereference().getParameters().get('invDate');
        
        strOrgId = UserInfo.getOrganizationId();
        fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm();
        // system.debug('#### : '+JSON.deserializeStrict(tempstring , list<SendPayOutInvoiceDetailsController.wrapResult>.class));
        reslst = (list<VariablePayController.wrapResult>)JSON.deserializeStrict(tempstring , list<VariablePayController.wrapResult>.class);
        // system.debug('#### reslst : '+reslst);
    }
}