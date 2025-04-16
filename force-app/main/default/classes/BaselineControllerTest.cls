@isTest
public class BaselineControllerTest {
	@testsetup
    public static void testData(){
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
        distict.Academic_Year__c = 2024;
        distict.Barcode_starts_with__c = '1';
        insert distict;
        
        Account account=new Account();
        account.Name='Shreeram School';
        account.District__c = distict.Id;
        account.State__c = state.Id;
        account.Barcode_starts_with__c='000001';
        account.Barcode_ends_with__c='000200';
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
		
        Batch__c b = new Batch__c();
        b.Name = 'ShreeramSchoolBatch1';
        b.School_Name__c = account.Id;
        b.Preferred_Language__c = 'English';
        insert b;
        
        RecordType CA_Student_RecordType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Contact' AND Name = 'CA Student'];
        Contact student = new Contact(RecordTypeId = CA_Student_RecordType.Id);
        student.AccountId = account.Id;
        student.FirstName = 'First';
        student.LastName = 'Last';
        student.Batch_Code__c = b.Id;
        student.G10_Batch_Code__c = b.Id;
        student.G11_Batch_Code__c = b.Id;
        student.Grade_9_Barcode__c = '2407000051';
        student.Grade_10_Barcode__c = '2201000002';
        student.Grade_11_Barcode__c = '2201000003';
        student.Bar_Code__c = '2407000051';
        Insert student;
        
        Id rRecordTypeId = Schema.SObjectType.Self_Awareness_Realities__c.getRecordTypeInfosByDeveloperName().get('Baseline').getRecordTypeId();
        Self_Awareness_Realities__c saaf = new Self_Awareness_Realities__c(RecordTypeId = rRecordTypeId);
        saaf.Student__c = student.Id;
        saaf.Barcode__c = 'Test009';
        saaf.Created_from_Form__c = true;
        saaf.Form_Submitted__c = true;
        saaf.Reality_Form_Submitted__c = true;
        Insert saaf;
    }
    
    @isTest
    public static void test_createContact(){
        Contact con = [select id,FirstName,LastName,MiddleName,Batch_Code__c,Year_of_Birth__c,Gender__c,Currently_Studying_In__c,G10_Batch_Code__c,G11_Batch_Code__c,G12_Batch_Code__c,G9_Whatsapp_Number__c,G10_Whatsapp_Number__c,G11_Whatsapp_Number__c,G12_Whatsapp_Number__c,G9_Alternate_Mobile_No__c,G10_Alternate_Mobile_No__c,G11_Alternate_Mobile_No__c,G12_Alternate_Mobile_No__c from contact limit 1];
        Account acc = [select id from account limit 1];
        BaselineController.contactDataWrapper dt = new BaselineController.contactDataWrapper();
        dt.firstname = 'Test';
        dt.middlename ='test';
        dt.lastname = 'test';
        dt.batchCodeG9 = con.Batch_Code__c;
        system.debug('con.Account.Id ='+con);
		//con.FirstName = ;
        test.startTest();
        BaselineController.createContact(dt, 'Grade 9', acc.Id,con.Batch_Code__c);
        dt.batchCodeG10=con.G10_Batch_Code__c;
        BaselineController.createContact(dt, 'Grade 10', acc.Id,con.Batch_Code__c);
       // dt.batchCodeG10=con.G11_Batch_Code__c;
        //BaselineController.createContact(dt, 'Grade 11', acc.Id,con.Batch_Code__c);
        test.stopTest();
        
        /*firstname : this.firstName,
            lastname: this.lastName,
            yrOfBirth: this.yrOfBirth,
            gender: this.gender,
            whatCurrStuIn: this.whatCurrStuIn,
            currStudyIn: this.grade*/
    }
    
    /*@isTest
    public static void test_getStudentData(){
       	List<Contact> conList = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = '2201000001'];

        test.startTest();
        BaselineController.getStudentData(conList[0].Batch_Code__c);
        test.stopTest();
    }*/
    
}