@isTest
public class quiz1Grade9Test {
	@testsetup
    public static void testData(){
        Account account=new Account();
        account.Name='Shreeram School';
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
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

        Id cpRecordTypeId = Schema.SObjectType.Self_Awareness_and_Feedback__c.getRecordTypeInfosByDeveloperName().get('Baseline').getRecordTypeId();
        Self_Awareness_and_Feedback__c saaf = new Self_Awareness_and_Feedback__c(RecordTypeId = cpRecordTypeId);
        saaf.Student__c = student.Id;
        saaf.Barcode__c = 'Test009';
        saaf.Created_from_Form__c = true;
        Insert saaf;
    }
    
    @isTest
    public static void test_Constructor(){

        test.startTest();
        quiz1Grade9 q1G9 = new quiz1Grade9();
        quiz1Grade9.qAnswerAll qSaveAll = new quiz1Grade9.qAnswerAll();
        test.stopTest();
    }
    
    @isTest
    public static void test_getApexRecord(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];

        test.startTest();
        quiz1Grade9.getApexRecord(conList[0].Id, 'Grade 9');
        quiz1Grade9.getApexRecord(conList[0].Id, 'Grade 10');
        quiz1Grade9.getApexRecord(conList[0].Id, 'Grade 11');
        test.stopTest();
    }
    
    @isTest
    public static void test_saveSingle(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		List<Self_Awareness_and_Feedback__c> saafList =[SELECT Id FROM Self_Awareness_and_Feedback__c WHERE Student__c = :conList[0].Id];

        qAnswer qAns = new qAnswer();
        qAns.answer = 'A';
        test.startTest();
        quiz1Grade9.saveSingle(saafList[0].Id, conList[0].Id, 'Test009', '01', qAns);
        quiz1Grade9.saveSingle(saafList[0].Id, conList[0].Id, 'Test009', '02', qAns);
        quiz1Grade9.saveSingle(saafList[0].Id, conList[0].Id, 'Test009', '03', qAns);
        quiz1Grade9.saveSingle(saafList[0].Id, conList[0].Id, 'Test009', '04', qAns);
        quiz1Grade9.saveSingle(saafList[0].Id, conList[0].Id, 'Test009', '05', qAns);
        test.stopTest();
    }    
	public class qAnswer{
        String answer;
    }
    
    @isTest
    public static void test_saveAllQA(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		List<Self_Awareness_and_Feedback__c> saafList =[SELECT Id FROM Self_Awareness_and_Feedback__c WHERE Student__c = :conList[0].Id];

        qAnswerAll qAnsAll = new qAnswerAll();
        qAnsAll.q01.answer = 'A';
        qAnsAll.q02.answer = 'A';
        qAnsAll.q03.answer = 'A';
        qAnsAll.q04.answer = 'A';
        qAnsAll.q05.answer = 'A';
        
        test.startTest();
        quiz1Grade9.saveAllQA(saafList[0].Id, conList[0].Id, 'Test009', qAnsAll, 'English', '');
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
    
    @isTest
    public static void test_submitAndCalculate(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		List<Self_Awareness_and_Feedback__c> saafList =[SELECT Id FROM Self_Awareness_and_Feedback__c WHERE Student__c = :conList[0].Id];
        
        test.startTest();
        quiz1Grade9.submitAndCalculate(saafList[0].Id);
        test.stopTest();
    }
    
    @isTest
    public static void testAll(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
        List<Self_Awareness_and_Feedback__c> saafList =[SELECT Id FROM Self_Awareness_and_Feedback__c WHERE Student__c = :conList[0].Id];

        qAnswer qAns = new qAnswer();
        qAns.answer = 'A';

        test.startTest();
        quiz1Grade9 q1G9 = new quiz1Grade9();
        quiz1Grade9.qAnswerAll qSaveAll = new quiz1Grade9.qAnswerAll();
        
        quiz1Grade9.getApexRecord(conList[0].Id, 'Grade 9');
        quiz1Grade9.getApexRecord(conList[0].Id, 'Grade 10');
        quiz1Grade9.getApexRecord(conList[0].Id, 'Grade 11');
        
        quiz1Grade9.saveSingle(saafList[0].Id, conList[0].Id, 'Test009', '01', qAns);
        quiz1Grade9.saveSingle(saafList[0].Id, conList[0].Id, 'Test009', '02', qAns);
        quiz1Grade9.saveSingle(saafList[0].Id, conList[0].Id, 'Test009', '03', qAns);
        quiz1Grade9.saveSingle(saafList[0].Id, conList[0].Id, 'Test009', '04', qAns);
        quiz1Grade9.saveSingle(saafList[0].Id, conList[0].Id, 'Test009', '05', qAns);
        
        qAnswerAll qAnsAll = new qAnswerAll();
        qAnsAll.q01.answer = 'A';
        qAnsAll.q02.answer = 'A';
        qAnsAll.q03.answer = 'A';
        qAnsAll.q04.answer = 'A';
        qAnsAll.q05.answer = 'A';
        
        
        quiz1Grade9.saveAllQA(saafList[0].Id, conList[0].Id, 'Test009', qAnsAll, 'English', '');
        quiz1Grade9.submitAndCalculate(saafList[0].Id);
        test.stopTest();
    }
}