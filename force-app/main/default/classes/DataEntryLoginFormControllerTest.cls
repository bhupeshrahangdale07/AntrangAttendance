@isTest
public class DataEntryLoginFormControllerTest {
	@isTest
    public static void studentAttendance(){
        List<Contact> conLst = new List<Contact>();
        List<String> seesionIds = new List<String>();
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
        bat.Date_of_facilitation_starting__c = system.today();
        bat.Grade__c = 'Grade 9';
        bat.Academic_Year__c = 2024;
        Insert bat;
        
        Session__c sess = new Session__c();
        sess.Name = 'test';
        sess.Batch__c = bat.Id;
        sess.Session_Grade__c = 'Grade 9';
        Insert sess;
        seesionIds.add(sess.Id);
        
        Test.startTest();
        DataEntryLoginFormController.checkEmailExist('test@gmail.com', 'Form v2');
        DataEntryLoginFormController.findBatch(acc.Id,'Grade 9','test@gmail.com', true);
        list<DataEntryLoginFormController.wrpSession> sessionLst = DataEntryLoginFormController.lstsessionRecords(bat.Id,'test@gmail.com');
        DataEntryLoginFormController.saveSessions(JSON.serialize(sessionLst),bat.Id,'test@gmail.com');
        DataEntryLoginFormController.findSelectedStudentRecord(conLst[0].Id);
        DataEntryLoginFormController.batchDetails(bat.Id);
        DataEntryLoginFormController.totalStudentInBatch('Grade 10', bat.Id);
        DataEntryLoginFormController.batchOptionsbyBatchId('test@gmail.com');
        DataEntryLoginFormController.schoolnGradebyBatchId(bat.Id);
        DataEntryLoginFormController.getSchoolDistrictData(acc.Id);
        Test.stopTest();
    }    
}