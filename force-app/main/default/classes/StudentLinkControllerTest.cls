@isTest
public class StudentLinkControllerTest {

    @testSetup
    public static void testData(){
        
        List<Contact> conLst = new List<Contact>();
        
        AntarangSetting__c setting = new AntarangSetting__c(Academic_Year__c = 2023, Next_Academic_Year__c = 2024,Max_Batch_Size__c=2);
        insert setting;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Mumbai';
        sm.Name = 'Mumbai Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'description';
        insert sm;
        
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='GOA';
        state.State_Code__c = 7;
        insert state;
         
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Mumbai';
        distict.Academic_Year__c = setting.Academic_Year__c;
        distict.Barcode_starts_with__c = '1';
        insert distict;
        
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('School_Account')
            .getRecordTypeId();
        acc.Name = 'test 01';
        acc.District__c = distict.Id;
        acc.State__c = state.Id;
        Insert acc;
               
        batch__c bat = new batch__c();
        bat.Name = 'test batch';
        bat.Preferred_Language__c = 'English';
        bat.School_Name__c = acc.Id;
        bat.Date_of_facilitation_starting__c = system.today();
        bat.Grade__c = 'Grade 9';
        bat.Academic_Year__c = 2023;
        Insert bat;
        
        batch__c bat1 = new batch__c();
        bat1.Name = 'test batch 10';
        bat1.Preferred_Language__c = 'English';
        bat1.School_Name__c = acc.Id;
        bat1.Date_of_facilitation_starting__c = system.today();
        bat1.Grade__c = 'Grade 10';
        bat1.Academic_Year__c = 2024;
        Insert bat1;
        
        Contact con = new Contact();
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('CA_Student')
            .getRecordTypeId();
        con.LastName = 'test';
        con.Email = 'test@gmail.com';
        con.Academic_Year__c = setting.Academic_Year__c;
        con.Currently_Studying_In__c = 'Grade 11';
        con.G11_Batch_Code__c = bat.Id;
        //Insert con;
        conLst.add(con);
        
        Contact con1 = new Contact();
        con1.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('CA_Student')
            .getRecordTypeId();
        con1.LastName = 'test1';
        con1.Email = 'test1@gmail.com';
        con1.Academic_Year__c = setting.Academic_Year__c;
        con1.Currently_Studying_In__c = 'Grade 10';
        con1.G10_Batch_Code__c = bat.Id;
        //Insert con1;
        conLst.add(con1);
        
        Contact con2 = new Contact();
        con2.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('CA_Student')
            .getRecordTypeId();
        con2.LastName = 'test2';
        con2.Email = 'test2@gmail.com';
        con2.Academic_Year__c = setting.Academic_Year__c;
        con2.Currently_Studying_In__c = 'Grade 9';
        con2.Batch_Code__c = bat.Id;
        //Insert con2;
        conLst.add(con2);
        
        insert conLst;
        
        Session__c sess = new Session__c();
        sess.Name = 'test';
        sess.Batch__c = bat.Id;
        sess.Session_Grade__c = 'Grade 9';
        Insert sess;
    }
    
    @isTest
    public static void test(){
        
        Contact con = [select id from contact where Currently_Studying_In__c = 'Grade 11' limit 1];
        batch__c bat = [select id from batch__c limit 1];
        Test.startTest();
        
        StudentLinkController.getUnLinkedStudents('Grade 12', bat.Id);
        StudentLinkController.saveLinkStudents(new list<String>{con.Id}, bat.Id, 'Grade 12');
        //StudentLinkController.saveLinkStudents(new list<String>{con1.Id}, bat.Id, 'Grade 11');
        //StudentLinkController.saveLinkStudents(new list<String>{con2.Id}, bat.Id, 'Grade 10');
        
        con.G12_Whatsapp_Number__c = '8899554466';
        StudentLinkController.updateLinkedStudents(new List<Contact>{con});
        Test.stopTest();
    }
    
    @isTest
    public static void test1(){
        
        Contact con = [select id from contact where Currently_Studying_In__c = 'Grade 9' limit 1];
        batch__c bat = [select id from batch__c where Name ='test batch 10' limit 1];
        Test.startTest();
        
        StudentLinkController.getUnLinkedStudents('Grade 11', bat.Id);
        StudentLinkController.saveLinkStudents(new list<String>{con.Id}, bat.Id, 'Grade 10');
        //StudentLinkController.saveLinkStudents(new list<String>{con1.Id}, bat.Id, 'Grade 11');
        //StudentLinkController.saveLinkStudents(new list<String>{con2.Id}, bat.Id, 'Grade 10');
        
        con.G10_Whatsapp_Number__c = '8899554466';
        StudentLinkController.updateLinkedStudents(new List<Contact>{con});
        Test.stopTest();
    }
    
    @isTest
    public static void test2(){
        
        Contact con = [select id from contact where Currently_Studying_In__c = 'Grade 10' limit 1];
        batch__c bat = [select id from batch__c where Name ='test batch 10' limit 1];
        Test.startTest();
        
        StudentLinkController.getUnLinkedStudents('Grade 10', bat.Id);
        StudentLinkController.saveLinkStudents(new list<String>{con.Id}, bat.Id, 'Grade 11');
        //StudentLinkController.saveLinkStudents(new list<String>{con1.Id}, bat.Id, 'Grade 11');
        //StudentLinkController.saveLinkStudents(new list<String>{con2.Id}, bat.Id, 'Grade 10');
        
        con.G11_Whatsapp_Number__c = '8899554466';
        StudentLinkController.updateLinkedStudents(new List<Contact>{con});
        Test.stopTest();
    }
}