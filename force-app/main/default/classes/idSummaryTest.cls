@isTest
public class idSummaryTest {
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
        b.Academic_Year__c  = 2023;
        b.Grade__c = 'Grade 9';
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
        saaf.Academic_Year__c = b.Academic_Year__c;
        saaf.grade__c = b.Grade__c;
        saaf.Grade9_Quiz1_Submitted__c = true;
        saaf.Grade10_Quiz1_Submitted__c = true;
        saaf.Interest_Form_Submitted__c = true;
        Insert saaf;
    }
    
    @isTest
    public static void test_Constructor(){

        test.startTest();
        idSummary q1S = new idSummary();
        idSummary.responseWrapper responseWrapper = new idSummary.responseWrapper();
        test.stopTest();
    }
    
    @isTest
    public static void test_getStudentRecords(){
        List<Contact> conList = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];

        test.startTest();
        idSummary.getStudentRecords(conList[0].Batch_Code__c, 'Grade 9');
        idSummary.getInterestRecord(conList[0].id, 'Grade 9',conList[0].Batch_Code__c);
        test.stopTest();
    }
    /*@istest
    static void interestFormType_Test(){
        Account schId = [Select Id, Name from Account Where Name='Shreeram School' and RecordType.Name='School' limit 1];
        Test.startTest();
        District_Master__c dm = idSummary.interestFormType(schId.Id);
        Test.stopTest();    
    }*/
}