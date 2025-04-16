@isTest
public class studentAttendanceControllerTest {

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
        Insert con;
        conLst.add(con);
        
        batch__c bat = new batch__c();
        bat.Name = 'test batch';
        bat.Preferred_Language__c = 'English';
        bat.School_Name__c = acc.Id;
        bat.Trainer_Name__c = con.Id;
        bat.Date_of_facilitation_starting__c = system.today();
        Insert bat;
        
        Contact std1 = new Contact();
        std1.LastName = 'Test 01';
        std1.Batch_Code__c = bat.Id;
        Insert std1;
        
        Session__c sess = new Session__c();
        sess.Name = 'test';
        sess.Batch__c = bat.Id;
        sess.Session_Delivery__c = 'Synchronous';
        sess.Session_Grade__c = 'Grade 9';
        sess.SessionDate__c = system.today();
        Insert sess;
        seesionIds.add(sess.Id);
        
        Test.startTest();
        studentAttendanceController.checkEmailExist('test@gmail.com');
        //studentAttendanceController.sessionRecords(bat.Id);
        studentAttendanceController.lstsessionRecords(bat.Id, con.Id, 'Grade 9');
        Map<String, object> data = (Map<String, object>)studentAttendanceController.prepareMatrix(bat.Id,con.Id,seesionIds,'Grade 9');
        studentAttendanceController.saveStudentAttendance((List<studentAttendanceController.studentAttendance>)data.get('studentdata'));
        studentAttendanceController.showAllStudentSessionData(bat.Id,con.Id);
        studentAttendanceController.submitAttendance(sess.Id,'');
        //studentAttendanceController.getBatchList(acc.Id,'Grade 9');
        studentAttendanceController.savePresentedStudentCount(sess.Id,1,1);
        studentAttendanceController.findSessionAtt(acc.Id,'Grade 9',con.Id);
        Test.stopTest();
        
    }
    
}