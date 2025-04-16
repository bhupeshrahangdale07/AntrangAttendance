/*
* Test class for trigger SendPayOutInvoiceDetailsController
*/
@isTest
public class SendPayoutControllerTest {
    
    @isTest
    public static void sendemailTest(){
        
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='maharashtra';
        insert distict;
        
        City_Master__c city =new City_Master__c();
        city.District__c=distict.id;
        city.Name='Mumbai'; 
        insert city;
        
        Ward_Master__c ward=new Ward_Master__c();
        ward.City__c=city.id;
        ward.Name='Anderi';
        insert ward;
        
        Account account=new Account();
        account.Name='Shreeram School';
        account.State__c=state.id;
        account.Ward__c=ward.id;
        account.City__c=city.id;
        account.School_Timing__c = 'morning';
        account.District__c=distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        account.Medium_Language_of_Instruction__c = 'English';
        account.School_Location__c = 'Test Principal address';
        account.Principal_Name__c = 'Test Principal';
        account.X2021_22_Grade_10_counseling_completed__c = 'Yes';
        insert account;
        
        Account account1=new Account();
        account1.Name='Shreeram School Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId=RecordTypeIdAccount1;
        account1.Number_of_batches_pending__c=1.0;
        account1.Number_of_batches_allocated__c=2.0;
        account1.Number_of_batches_funded__c=1.0;
        insert account1;
        
        
        
        
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
        
        Batch__c batch1 = new Batch__c();
        batch1.Name = 'batch 1';
        batch1.School_Name__c=account.id;
        batch1.Preferred_Language__c = 'Hindi';
        batch1.Medium_Language_of_Instruction__c = 'English';
        batch1.Trainer_Name__c = contact.Id;
        batch1.Donor_Name__c = account1.Id;
        insert batch1;
        
        session__c session = new session__c();
        session.Batch__c = batch1.Id;
        session.Name='test 1';
        session.Session_Grade__c = 'class 10';
        session.Session_Type__c = 'student';
        session.Assigned_facilitator__c = contact.Id;
        session.SessionDate__c = date.valueOf('2021-03-27');
        session.Payment_Status__c = 'Ready For Payment';
        insert session;
        
        session__c session1 = new session__c();
        session1.Batch__c = batch1.Id;
        session1.Name='test';
        session1.Session_Grade__c = 'class 10';
        session1.Assigned_facilitator__c = contact.Id;
        session1.Session_Type__c = 'Counseling';
        session1.SessionDate__c = date.valueOf('2021-03-27');
        session1.Payment_Status__c = 'Ready For Payment';
        session1.No_of_batches_for_counseling__c = 3;
        insert session1;
        
        
        PageReference pageRef = Page.SendPayOutInvoiceDetails;
        pageRef.getParameters().put('id', String.valueOf(contact.Id));
        Test.setCurrentPage(pageRef);
        
        SendPayoutController sendemail = new SendPayoutController(new ApexPages.StandardController(contact));
        sendemail.monthAndYear = '04-2021';
        List<SelectOption> lstoption = sendemail.getMonthAndYearOptions();
        sendemail.conIds.add(contact.Id);
        sendemail.submitSingle();
        sendemail.backToAccount();
        
    }
}