/*
* Test class for trigger assignFacilatorOnBatchListViewCtrl
*/
@isTest
public class assignFacilatorOnBatchControllerTest {
    
    @testSetup static void setupTestData() {
        
        AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();   
        setting.Number_of_sessions_for_Grade_9__c = 16;
        setting.Number_of_session_for_Grade_10__c = 8;
        insert setting;
        
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='maharashtra';
        insert distict;
        
        City_Master__c city =new City_Master__c();
        city.District__c=distict.id;
        city.Name='Thane'; 
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
        insert account;
        
        list<Batch__c> batchLst = new list<batch__c>();
        Batch__c batch1 = new Batch__c();
        batch1.Name = 'batch 1';
        batch1.School_Name__c=account.id;
        batch1.Preferred_Language__c = 'Hindi';
        batch1.Medium_Language_of_Instruction__c = 'English';
        batchLst.add(batch1);
        
        Batch__c batch2 = new Batch__c();
        batch2.Name = 'batch 2';
        batch2.School_Name__c=account.id;
        batch2.Preferred_Language__c = 'English';
        batch2.Medium_Language_of_Instruction__c = 'English';
        batchLst.add(batch2);
        
        insert batchLst;
        
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
    }
    
    @isTest
    public static void testprocessSelectedG9()
    {
        
        list<batch__c> batchLst = [select id from batch__c];
        
        
        Test.startTest();
        Test.setCurrentPage(Page.assignFacilatorOnBatchListView);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(batchLst);
        stdSetController.setSelected(batchLst);
        assignFacilatorOnBatchController ext = new assignFacilatorOnBatchController(stdSetController);
        ext.facilitator = 'G9';
        ext.selectedCon = ext.lstContact[0].Id;
        ext.processSelected();
        
        list<session__c> sessLst = [select id from session__c where Assigned_facilitator__c =:ext.selectedCon];
        system.assertEquals(32, sessLst.size());
        Test.stopTest();
    }
    
    @isTest
    public static void testprocessSelectedG10()
    {
        
        list<batch__c> batchLst = [select id from batch__c];
        
        
        Test.startTest();
        Test.setCurrentPage(Page.assignFacilatorOnBatchListView);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(batchLst);
        stdSetController.setSelected(batchLst);
        assignFacilatorOnBatchController ext = new assignFacilatorOnBatchController(stdSetController);
        ext.facilitator = 'G10';
        ext.selectedCon = ext.lstContact[0].Id;
        ext.processSelected();
        
        list<session__c> sessLst = [select id from session__c where Assigned_facilitator__c =:ext.selectedCon];
        system.assertEquals(16, sessLst.size());
        Test.stopTest();
    }
}