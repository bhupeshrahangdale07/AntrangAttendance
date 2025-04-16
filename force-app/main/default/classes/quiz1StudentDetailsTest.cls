@isTest
public class quiz1StudentDetailsTest {
	@testsetup
    public static void testData(){
        Account account=new Account();
        account.Name='Shreeram School';
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
        student.G10_Batch_Code__c = null;
        student.G11_Batch_Code__c = null;
        student.G12_Batch_Code__c = null;
        student.Bar_Code__c = 'Test009';
        student.Grade_9_Barcode__c = 'Test009';
        student.Grade_10_Barcode__c = 'Test010';
        student.Grade_11_Barcode__c = 'Test011';
        Insert student;

        Id q1RecordTypeId = Schema.SObjectType.Self_Awareness_and_Feedback__c.getRecordTypeInfosByDeveloperName().get('Baseline').getRecordTypeId();
        Self_Awareness_and_Feedback__c saaf = new Self_Awareness_and_Feedback__c(RecordTypeId = q1RecordTypeId);
        saaf.Student__c = student.Id;
        saaf.Barcode__c = 'Test009';
        saaf.Created_from_Form__c = true;
        saaf.Grade9_Quiz1_Submitted__c = true;
        saaf.Grade10_Quiz1_Submitted__c = true;
        Insert saaf;
    }
    
    @isTest
    public static void test_Constructor(){

        test.startTest();
        quiz1StudentDetails q1SD = new quiz1StudentDetails();
        test.stopTest();
    }
    
    @isTest
    public static void test_getBatchInfo(){
        List<Contact> conList = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];

        test.startTest();
        quiz1StudentDetails.getBatchInfo(conList[0].Batch_Code__c);
        test.stopTest();
    }
    
    @isTest
    public static void test_searchStudentRecords(){
        List<Contact> conList = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];

        test.startTest();
        quiz1StudentDetails.searchStudentRecords('First', conList[0].Batch_Code__c, 'Grade 9');
        test.stopTest();
    }
}