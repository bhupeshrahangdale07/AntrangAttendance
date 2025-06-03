@isTest
public class Quiz1ControllerTest {
	@testsetup
    public static void testData(){
        Account account=new Account();
        account.Name='Shreeram School';
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId() ;
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;

        RecordType CA_Student_RecordType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Contact' AND Name = 'CA Student'];
        Contact student = new Contact(RecordTypeId = CA_Student_RecordType.Id);
        student.AccountId = account.Id;
        student.FirstName = 'First';
        student.LastName = 'Last';
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
        student1.Bar_Code__c = 'Test001';
        student1.Grade_9_Barcode__c = 'Test002';
        student1.Grade_10_Barcode__c = 'Test003';
        student1.Grade_11_Barcode__c = 'Test004';
        Insert student1;

        Id q1RecordTypeId = Schema.SObjectType.Self_Awareness_and_Feedback__c.getRecordTypeInfosByDeveloperName().get('Baseline').getRecordTypeId();
        Self_Awareness_and_Feedback__c saaf = new Self_Awareness_and_Feedback__c(RecordTypeId = q1RecordTypeId);
        saaf.Student__c = student.Id;
        saaf.Barcode__c = 'Test009';
        saaf.Created_from_Form__c = true;
        saaf.Error_Status__c = 'No Error';
        Insert saaf;
    }

    @isTest
    public static void test_Constructor(){

        test.startTest();
        Quiz1Controller q1G10 = new Quiz1Controller();
        Quiz1Controller.qAnswerAll qSaveAll = new Quiz1Controller.qAnswerAll();
        test.stopTest();
    }
    
   @isTest
    public static void testAll(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
        List<Self_Awareness_and_Feedback__c> saafList =[SELECT Id FROM Self_Awareness_and_Feedback__c WHERE Student__c = :conList[0].Id];
        
        test.startTest();
        Quiz1Controller q1G10 = new Quiz1Controller();
        Quiz1Controller.qAnswerAll qSaveAll = new Quiz1Controller.qAnswerAll();    
        
        qAnswer qAns = new qAnswer();
        qAns.answer = 'A';
        
        qAnswerAll qAnsAll = new qAnswerAll();
        qAnsAll.q01.answer = 'A';
        qAnsAll.q02.answer = 'A';
        qAnsAll.q03.answer = 'A';
        qAnsAll.q04.answer = 'A';
        qAnsAll.q05.answer = 'A';
        
        Quiz1Controller.saveAllQA(conList[0].Id, '1', '1', '1', '1', '1', 'Grade 10', 'English', 'Form v2','');
        
        Quiz1Controller.submitAndCalculate(saafList[0].Id);
        test.stopTest();
        
    }
    
	public class qAnswer{
        String answer;
    }
    
    @isTest
    public static void test_saveAllQA(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last1' AND Bar_Code__c = 'Test001'];

        qAnswerAll qAnsAll = new qAnswerAll();
        qAnsAll.q01.answer = 'A';
        qAnsAll.q02.answer = 'A';
        qAnsAll.q03.answer = 'A';
        qAnsAll.q04.answer = 'A';
        qAnsAll.q05.answer = 'A';
        
        test.startTest();
        Quiz1Controller.saveAllQA(conList[0].Id, '1', '1', '1', '1', '1', 'Grade 10', 'English', 'Form v2','');
        test.stopTest();
    }
    public class qAnswerAll{
        qAnswer q01;
        qAnswer q02;
        qAnswer q03;
        qAnswer q04;
        qAnswer q05;

        public qAnswerAll(){
            q01 = new qAnswer();
            q02 = new qAnswer();
            q03 = new qAnswer();
            q04 = new qAnswer();
            q05 = new qAnswer();
        }
    }
    
    /*@isTest
    public static void test_submitAndCalculate(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		List<Self_Awareness_and_Feedback__c> saafList =[SELECT Id FROM Self_Awareness_and_Feedback__c WHERE Student__c = :conList[0].Id];
        
        test.startTest();
        Quiz1Controller.submitAndCalculate(saafList[0].Id);
        test.stopTest();
    }*/
    
    @isTest
    public static void test_getStudentName(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
        
        test.startTest();
        Contact c= Quiz1Controller.getStudentName(conList[0].Id);
        test.stopTest();
    }
}