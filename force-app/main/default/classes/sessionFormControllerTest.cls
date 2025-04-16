@isTest
public class sessionFormControllerTest {
    
    @isTest
    public static void studentAttendance(){
        List<Contact> conLst = new List<Contact>();
        List<String> seesionIds = new List<String>();
        
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('School_Account')
            .getRecordTypeId();
        acc.Name = 'test 01';
        Insert acc;
        
        Contact con = new Contact();
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('CA_Trainer')
            .getRecordTypeId();
        con.LastName = 'test';
        con.Email = 'test@gmail.com';
        con.npe01__WorkEmail__c='test@gmail.com';
        Insert con;
        conLst.add(con);
        Contact con1 = new Contact();
        con1.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('CA_Trainer')
            .getRecordTypeId();
        con1.LastName = 'test1';
        con1.Email = 'test@antarangfoundation.org';
        con1.npe01__WorkEmail__c='test@antarangfoundation.org';
        Insert con1;
        conLst.add(con1);
        
        batch__c bat = new batch__c();
        bat.Name = 'test batch';
        bat.Preferred_Language__c = 'English';
        bat.School_Name__c = acc.Id;
        bat.Date_of_facilitation_starting__c = system.today();
        bat.Grade__c = 'Grade 9';
        Insert bat;
        
        Session__c sess = new Session__c();
        sess.Name = 'test';
        sess.Batch__c = bat.Id;
        sess.Session_Grade__c = 'Grade 9';
        Insert sess;
        seesionIds.add(sess.Id);
        
        Test.startTest();
        sessionFormController.checkEmailExist('test@gmail.com');
        
        sessionFormController.findBatch(acc.Id,'Grade 9','test@gmail.com');
        
        list<sessionFormController.wrpSession> sessionLst = sessionFormController.lstsessionRecords(bat.Id,'test@gmail.com');
        
        sessionFormController.saveSessions(JSON.serialize(sessionLst),bat.Id,'test@gmail.com');
        Test.stopTest();
        
    }
    
    
}