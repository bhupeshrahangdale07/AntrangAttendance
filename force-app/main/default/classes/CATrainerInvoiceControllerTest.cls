@isTest
public class CATrainerInvoiceControllerTest {

    @istest
    public static void testCATrainerInvoiceController(){
        
        Contact contact=new Contact();
        contact.FirstName='Test';
        contact.LastName='LName';
        contact.Email = 'test@gmail.com';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Trainer').getRecordTypeId();
        contact.RecordTypeId=RecordTypeIdContact;
        contact.Language__c='English;Hindi';
        contact.Cities_of_Operation__c = 'Thane';
        contact.Trainer_Status__c = 'morning';
        insert contact;  
        
        PageReference pageRef = Page.SendPayOutInvoiceDetails;
        pageRef.getParameters().put('Id', String.valueOf(contact.Id));
        pageRef.getParameters().put('Total', '500');
        pageRef.getParameters().put('Map', '[{"rate":500.00,"NumOfSession":1,"description":"Class 10","amount":500.00}]');
        pageRef.getParameters().put('selectedMonthYear', '2020-03-26');
         Test.setCurrentPage(pageRef);
        
        CATrainerInvoiceController sendemail = new CATrainerInvoiceController(new ApexPages.StandardController(contact));
        
        
        
    }
}