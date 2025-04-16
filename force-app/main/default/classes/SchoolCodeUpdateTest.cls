/*
* Test class for trigger SchoolCodeUpdate
*/
@isTest
public class SchoolCodeUpdateTest {
    
    @isTest
    public static void DonorInsertTest(){    
        Account account1=new Account();
        account1.Name='Shreeram School Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId=RecordTypeIdAccount1;
        account1.Number_of_batches_funded__c=100;
        account1.Number_of_batches_allocated__c=50;
        account1.Number_of_batches_pending__c=1.0;
        insert account1;
    }
    
    @isTest
    public static void InsertTest(){
        
        AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();   
        //setting.Min_batch_size__c = 35;
        setting.Max_batch_size__c = 40;
        insert setting;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Pune';
        sm.Name = 'Pune Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'description';
        insert sm;
        
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='GOA';
        insert state;
        
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Pune';
        insert distict;
        
        City_Master__c city=new City_Master__c();
        city.District__c=distict.id;
        city.Name='Kalyan'; 
        // city.City_Code__c='2';
        insert city;
        
        
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        
        Account account=new Account();
        account.Name='test school';
        account.Medium_Language_of_Instruction__c = 'english';
        account.total_student_count_21_22__c = 50;
        account.Enrolled_Grade_9__c = 50;
        account.RecordTypeId=RecordTypeIdAccount;
        test.startTest();
        insert account;
        
        Account acc = new Account(Id = account.Id);
        acc.Enrolled_Grade_10__c = 50;
        update acc;
        test.stopTest();
        
        
        list<batch__c> batchLst = [select id from batch__c where school_Name__c =:account.Id];
        system.assertEquals(4, batchLst.size());
        
    }
    
    @isTest
    public static void UpdateTest(){
        AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();   
        //setting.Min_batch_size__c = 35;
        setting.Max_batch_size__c = 40;
        insert setting;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Pune';
        sm.Name = 'Pune Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'description';
        insert sm;
        
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='GOA';
        insert state;
        
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Pune';
        insert distict;
        
        City_Master__c city=new City_Master__c();
        city.District__c=distict.id;
        city.Name='Kalyan'; 
        // city.City_Code__c='2';
        insert city;
        
        
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        
        Account account=new Account();
        account.Name='test school'; 
        account.total_student_count_21_22__c = 50;
        account.Enrolled_Grade_9__c = 120;
        account.RecordTypeId=RecordTypeIdAccount;
        account.Medium_Language_of_Instruction__c = 'english';
        
        insert account;
        
        test.startTest();
        account.total_student_count_21_22__c = 105;
        update account;
        test.stopTest();
        
        list<batch__c> batchLst = [select id from batch__c where school_Name__c =:account.Id];
        system.assertEquals(3, batchLst.size());
    }
    
}