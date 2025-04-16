public class CATrainerInvoiceController {
    public id contactId{get;set;}
    public string tempstring{get;set;}
    public string total{get;set;}
    public string selectedMonthYear{get;set;}
    public list<SendPayoutController.wrapResult> reslst{get;set;}
    public string invoiceDate{get;set;}
    public string inNum{get;set;}
    public contentversion conv{get;set;}
    public string strOrgId{get;set;}
    public string fullRecordURL{get;set;}
    public date invoiceNum{get;set;}
    
    public Contact contact {set;get;}
        
    public CATrainerInvoiceController(ApexPages.StandardController controller) {
        contact = (contact) controller.getRecord();
        
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
        reslst = (list<SendPayoutController.wrapResult>)JSON.deserializeStrict(tempstring , list<SendPayoutController.wrapResult>.class);
        // system.debug('#### reslst : '+reslst);
        
        
    }   
}