@isTest
public class counsellingFormControllerTest {

    @isTest
    public static void testCounseling(){
        List<Contact> conLst = new List<Contact>();
        List<String> seesionIds = new List<String>();
        
        AntarangSetting__c antarangSett = new AntarangSetting__c();
        antarangSett.Max_Batch_Size__c = 30;
        antarangSett.Academic_Year__c = 2021;
        Insert antarangSett;
        
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
        bat.Grade__c = 'Grade 9';
        bat.Academic_Year__c = antarangSett.Academic_Year__c;
        bat.Date_of_facilitation_starting__c = date.newInstance(System.Today().year()-1,6,15);
        Insert bat;
        
        Contact con = new Contact();
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('CA_Trainer')
            .getRecordTypeId();
        con.LastName = 'test';
        con.Email = 'test@antarangfoundation.org';
        con.Batch_Code__c = bat.id;
        con.Academic_Year__c = 2021;
        Insert con;
        conLst.add(con);
        
        Session__c sess = new Session__c();
        sess.Name = 'test';
        sess.Batch__c = bat.Id;
        sess.Session_Grade__c = 'Grade 9';
        sess.Session_Type__c = 'Counseling';
        sess.Assigned_Facilitator__c = con.Id;
        Insert sess;
        seesionIds.add(sess.Id);
        
        Session_Attendance__c sessionAttedance = new Session_Attendance__c();
        sessionAttedance.Contact__c = con.Id;
        sessionAttedance.Session__c = sess.Id;
        sessionAttedance.Reason__c = 'General Likes & Strengths;It is easy to pursue the career/ get a job';
        Insert sessionAttedance;
        
        Test.startTest();
        counsellingFormController.checkEmailExist('test@antarangfoundation.org');
        counsellingFormController.saveCounselingStaus(bat.Id);
        counsellingFormController.fetchbatch(acc.Id,'Grade 9',con.Id);
        Map<String, Object> res = (Map<String, Object>)counsellingFormController.fetchStudent(bat.Id, con.Id,'Grade 9');
        counsellingFormController.saveCounselling(JSON.serialize(res.get('StdData')));
        updateContactOtherPhoneForCounseling bc = new updateContactOtherPhoneForCounseling(conLst);
        Id batchId = Database.executeBatch(bc, 25);
        Test.stopTest();
    }
    
    @isTest
    public static void testCounselingWithoutAttendanceG11(){
        List<Contact> conLst = new List<Contact>();
        List<String> seesionIds = new List<String>();
        
        AntarangSetting__c antarangSett = new AntarangSetting__c();
        antarangSett.Max_Batch_Size__c = 30;
        antarangSett.Academic_Year__c = 2021;
        Insert antarangSett;
        
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
        bat.Grade__c = 'Grade 11';
        bat.Academic_Year__c = antarangSett.Academic_Year__c;
        bat.Date_of_facilitation_starting__c = date.newInstance(System.Today().year()-1,6,15);
        Insert bat;
        
        Contact con = new Contact();
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('CA_Trainer')
            .getRecordTypeId();
        con.LastName = 'test';
        con.Email = 'test@antarangfoundation.org';
        con.Batch_Code__c = bat.id;
        Insert con;
        conLst.add(con);
        
        Session__c sess = new Session__c();
        sess.Name = 'test';
        sess.Batch__c = bat.Id;
        sess.Session_Grade__c = 'Grade 11';
        sess.Session_Type__c = 'Counseling';
        sess.Assigned_Facilitator__c = con.Id;
        Insert sess;
        seesionIds.add(sess.Id);
        
        Session_Attendance__c sessionAttedance = new Session_Attendance__c();
        sessionAttedance.Contact__c = con.Id;
        sessionAttedance.Session__c = sess.Id;
        sessionAttedance.Reason__c = 'General Likes & Strengths;It is easy to pursue the career/ get a job';
        Insert sessionAttedance;
        
        Test.startTest();
        counsellingFormController.checkEmailExist('test@antarangfoundation.org');
        counsellingFormController.saveCounselingStaus(bat.Id);
        counsellingFormController.fetchbatch(acc.Id,'Grade 11',con.Id);
        Map<String, Object> res = (Map<String, Object>)counsellingFormController.fetchStudent(bat.Id, con.Id,'Grade 11');
        counsellingFormController.saveCounselling(JSON.serialize(res.get('StdData')));
        updateContactOtherPhoneForCounseling bc = new updateContactOtherPhoneForCounseling(conLst);
        Id batchId = Database.executeBatch(bc, 25);
        Test.stopTest();
    }
    
    public static void testCounselingWithoutAttendanceG9(){
        List<Contact> conLst = new List<Contact>();
        List<String> seesionIds = new List<String>();
        
        AntarangSetting__c antarangSett = new AntarangSetting__c();
        antarangSett.Max_Batch_Size__c = 30;
        antarangSett.Academic_Year__c = 2021;
        Insert antarangSett;
        
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
        bat.Grade__c = 'Grade 11';
        bat.Academic_Year__c = antarangSett.Academic_Year__c;
        bat.Date_of_facilitation_starting__c = date.newInstance(System.Today().year()-1,6,15);
        Insert bat;
        
        Contact con = new Contact();
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('CA_Trainer')
            .getRecordTypeId();
        con.LastName = 'test';
        con.Email = 'test@antarangfoundation.org';
        con.Batch_Code__c = bat.id;
        Insert con;
        conLst.add(con);
        
        Session__c sess = new Session__c();
        sess.Name = 'test';
        sess.Batch__c = bat.Id;
        sess.Session_Grade__c = 'Grade 11';
        sess.Session_Type__c = 'Counseling';
        sess.Assigned_Facilitator__c = con.Id;
        Insert sess;
        seesionIds.add(sess.Id);
        
        Session_Attendance__c sessionAttedance = new Session_Attendance__c();
        sessionAttedance.Contact__c = con.Id;
        sessionAttedance.Session__c = sess.Id;
        sessionAttedance.Reason__c = 'General Likes & Strengths;It is easy to pursue the career/ get a job';
        Insert sessionAttedance;
        
        Test.startTest();
        counsellingFormController.checkEmailExist('test@antarangfoundation.org');
        counsellingFormController.saveCounselingStaus(bat.Id);
        counsellingFormController.fetchbatch(acc.Id,'Grade 11',con.Id);
        Map<String, Object> res = (Map<String, Object>)counsellingFormController.fetchStudent(bat.Id, con.Id,'Grade 11');
        counsellingFormController.saveCounselling(JSON.serialize(res.get('StdData')));
        updateContactOtherPhoneForCounseling bc = new updateContactOtherPhoneForCounseling(conLst);
        Id batchId = Database.executeBatch(bc, 25);
        Test.stopTest();
    }
}