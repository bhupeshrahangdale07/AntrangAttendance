@isTest
public class quiz1SummaryTest {
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
        
        Batch__c b1 = new Batch__c();
        b1.Name = 'ShreeramSchoolBatch11';
        b1.School_Name__c = account.Id;
        b1.Preferred_Language__c = 'English';
        insert b1;
        
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
		
        RecordType CA_Student_RecordType1 = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Contact' AND Name = 'CA Student'];
        Contact student1 = new Contact(RecordTypeId = CA_Student_RecordType1.Id);
        student1.AccountId = account.Id;
        student1.FirstName = 'First1';
        student1.LastName = 'Last1';
        student1.Batch_Code__c = null;
        student1.G10_Batch_Code__c = b1.Id;
        student1.G11_Batch_Code__c = null;
        student1.G12_Batch_Code__c = null;
        student1.Bar_Code__c = 'Test0101';
        student1.Grade_9_Barcode__c = 'Test0091';
        student1.Grade_10_Barcode__c = 'Test0101';
        student1.Grade_11_Barcode__c = 'Test0111';
        Insert student1;
        
        Id q1RecordTypeId = Schema.SObjectType.Self_Awareness_and_Feedback__c.getRecordTypeInfosByDeveloperName().get('Baseline').getRecordTypeId();
        Self_Awareness_and_Feedback__c saaf = new Self_Awareness_and_Feedback__c(RecordTypeId = q1RecordTypeId);
        saaf.Student__c = student.Id;
        saaf.Barcode__c = 'Test009';
        saaf.Created_from_Form__c = true;
        saaf.Academic_Year__c = b.Academic_Year__c;
        saaf.grade__c = b.Grade__c;
        saaf.Grade9_Quiz1_Submitted__c = true;
        saaf.Grade10_Quiz1_Submitted__c = true;
        Insert saaf;
        
        Id q1RecordTypeId1 = Schema.SObjectType.Self_Awareness_and_Feedback__c.getRecordTypeInfosByDeveloperName().get('Baseline').getRecordTypeId();
        Self_Awareness_and_Feedback__c saaf1 = new Self_Awareness_and_Feedback__c(RecordTypeId = q1RecordTypeId1);
        saaf1.Student__c = student1.Id;
        saaf1.Barcode__c = 'Test0101';
        saaf1.Created_from_Form__c = true;
        saaf1.Grade9_Quiz1_Submitted__c = true;
        saaf1.Grade10_Quiz1_Submitted__c = true;
        Insert saaf1;
    }
    
    @isTest
    public static void test_Constructor(){

        test.startTest();
        quiz1Summary q1S = new quiz1Summary();
        quiz1Summary.responseWrapper responseWrapper = new quiz1Summary.responseWrapper();
        test.stopTest();
    }
    
    @isTest
    public static void test_getStudentRecords(){
        List<Contact> conList = [SELECT Id, Batch_Code__c,G10_Batch_Code__c,G11_Batch_Code__c,G12_Batch_Code__c FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];

        test.startTest();
        quiz1Summary.getStudentRecords(conList[0].Batch_Code__c, 'Grade 9');
        quiz1Summary.getQuiz1Record(conList[0].id, 'Grade 9',conList[0].Batch_Code__c);
        quiz1Summary.getQuiz1Record(conList[0].id, 'Grade 10',conList[0].Batch_Code__c);
        quiz1Summary.getQuiz1Record(conList[0].id, 'Grade 11',conList[0].Batch_Code__c);
        quiz1Summary.getQuiz1Record(conList[0].id, 'Grade 12',conList[0].Batch_Code__c);
        test.stopTest();
    }
    @isTest
    public static void test_fakeMethod(){

        test.startTest();
        quiz1Summary.fakeMethod();
        test.stopTest();
    }
}