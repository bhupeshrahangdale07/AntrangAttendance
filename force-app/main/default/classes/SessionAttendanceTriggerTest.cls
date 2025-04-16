@isTest
public class SessionAttendanceTriggerTest {

    @isTest
    public static void SessionAttendanceInsertTest(){
        
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('School_Account')
            .getRecordTypeId();
        acc.Name = 'test 01';
        Insert acc;
        
        
        
        
        batch__c bat = new batch__c();
        bat.Name = 'test batch';
        bat.Preferred_Language__c = 'English';
        bat.School_Name__c = acc.Id;
        bat.Date_of_facilitation_starting__c = system.today();
        Insert bat;
        
        Contact con = new Contact();
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('CA_Student')
            .getRecordTypeId();
        con.LastName = 'test';
        con.Email = 'test@gmail.com';
        con.batch_Code__c = bat.Id;
        Insert con;
        
        
        
        Session__c sess = new Session__c();
        sess.Name = 'test';
        sess.Batch__c = bat.Id;
        sess.Session_Grade__c = 'Grade 9';
        sess.SessionDate__c = date.today();
        Insert sess;
        /*
        Session_Attendance__c sessionAttedance1 = new Session_Attendance__c();
        sessionAttedance1.Contact__c = con.Id;
        sessionAttedance1.Session__c = sess.Id;
        insert sessionAttedance1;
		*/
        
        Session_Attendance__c sessionAttedance = new Session_Attendance__c();
        sessionAttedance.Contact__c = con.Id;
        sessionAttedance.Session__c = sess.Id;
        sessionAttedance.Attendance__c = 'Present';
        
        test.startTest();
        insert sessionAttedance;
        
        delete sessionAttedance;
        test.stopTest();
    }
}