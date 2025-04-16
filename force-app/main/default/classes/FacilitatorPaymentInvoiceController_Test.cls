@isTest
public class FacilitatorPaymentInvoiceController_Test {
    
    private static Date invoiceDate = Date.today()-1;
    private static String selectedMonthYear = '25/05/2023';
	@testSetup
    public static void testData() {
        Id conRtId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Trainer').getRecordTypeId();
        
        Contact con1 = new Contact(LastName = 'Contact 1', Payment_Type__c = 'Salary', RecordTypeId = conRtId, Trainer_Status__c = 'Morning',
                                   Fixed_Amount__c = 8000, Academic_Year__c = 2023, npe01__WorkEmail__c = 'test@test.com', 
                                   Payment_Start_Date__c = invoiceDate-180);
        Contact con2 = new Contact(LastName = 'Contact 2', Payment_Type__c = 'Salary', RecordTypeId = conRtId, Trainer_Status__c = 'Afternoon',
                                   Fixed_Amount__c = 9000, Academic_Year__c = 2023, npe01__WorkEmail__c = 'test@test.com', 
                                   Payment_Start_Date__c = invoiceDate-120);
        insert new List<Contact>{con1, con2};
    }
    
    @isTest
    public static void FacilitatorPaymentInvoiceControllerTest(){
        try{ 
            Contact con = [SELECT Id , Name FROM Contact WHERE Name = 'Contact 1'];
            PageReference pageRef = Page.FacilitatorPaymentInvForExperienceSite;
            pageRef.getParameters().put('Map', '[{"rate":500.00,"NumOfSession":1,"description":"Class 10","amount":500.00}]');
            pageRef.getParameters().put('Id', String.valueOf(con.Id));
            pageRef.getParameters().put('selectedMonthYear', '2020-03-26');
            Test.setCurrentPage(pageRef);            
            Test.startTest();
       			FacilitatorPaymentInvoiceController fpic = new FacilitatorPaymentInvoiceController();
            Test.stopTest();         
        }catch(Exception ex){
            system.debug('FacilitatorPaymentInvoiceControllerTest : ' + ex.getMessage());
            system.debug('FacilitatorPaymentInvoiceControllerTest : ' + ex.getLineNumber());
        }
    }
}