@isTest
public class CareerPlanning_ATest {
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

        Id cpRecordTypeId = Schema.SObjectType.Career_Planning__c.getRecordTypeInfosByDeveloperName().get('Baseline').getRecordTypeId();
        Career_Planning__c cp = new Career_Planning__c(RecordTypeId = cpRecordTypeId);
        cp.Student__c = student.Id;
        cp.Barcode__c = 'Test009';
        cp.Created_from_Form__c = true;
        Insert cp;
        
        Id cdm1RecordTypeId = Schema.SObjectType.OMR_Assessment__c.getRecordTypeInfosByDeveloperName().get('Baseline').getRecordTypeId();
        OMR_Assessment__c cdm1 = new OMR_Assessment__c(RecordTypeId = cdm1RecordTypeId);
        cdm1.Student__c = student.Id;
        cdm1.Barcode__c = 'Test009';
        cdm1.Created_from_Form__c = true;
        Insert cdm1;
        
        Id cdm2RecordTypeId = Schema.SObjectType.CDM2__c.getRecordTypeInfosByDeveloperName().get('Baseline').getRecordTypeId();
        CDM2__c cdm2 = new CDM2__c(RecordTypeId = cdm2RecordTypeId);
        cdm2.Student__c = student.Id;
        cdm2.Barcode__c = 'Test009';
        cdm2.Created_from_Form__c = true;
        Insert cdm2;
    }
    
    @isTest
    public static void test_Constructor(){

        test.startTest();
        CareerPlanning_A cp = new CareerPlanning_A();
        CareerPlanning_A.qAnswerAll qSaveAll = new CareerPlanning_A.qAnswerAll();
        test.stopTest();
    }
    
    @isTest
    public static void test_getApexRecord(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];

        test.startTest();
        CareerPlanning_A.getApexRecord(conList[0].Id, 'Grade 9');
        CareerPlanning_A.getApexRecord(conList[0].Id, 'Grade 10');
        CareerPlanning_A.getApexRecord(conList[0].Id, 'Grade 11');
        test.stopTest();
    }
    
    @isTest
    public static void test_saveSingle(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		List<Career_Planning__c> cpList =[SELECT Id FROM Career_Planning__c WHERE Student__c = :conList[0].Id];

        qAnswer qAns = new qAnswer();
        qAns.answer = 'A';
        test.startTest();
        CareerPlanning_A.saveSingle(cpList[0].Id, conList[0].Id, 'Test009', '07', qAns, 'English', 'Form V2');
        CareerPlanning_A.saveSingle(cpList[0].Id, conList[0].Id, 'Test009', '08', qAns, 'English', 'Form V2');
        CareerPlanning_A.saveSingle(cpList[0].Id, conList[0].Id, 'Test009', '10', qAns, 'English', 'Form V2');
        CareerPlanning_A.saveSingle(null, conList[0].Id, 'Test009', '10', qAns, 'English', 'Form V2');
        test.stopTest();
    }    
	public class qAnswer{
        String answer;
    }
    
    @isTest
    public static void test_saveQuestion09(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		List<Career_Planning__c> cpList =[SELECT Id FROM Career_Planning__c WHERE Student__c = :conList[0].Id];

        q09Answer q09 = new q09Answer();
        q09.answer1 = 'A';
        q09.answer2 = 'A';
        q09.answer3 = 'A';
        q09.answer4 = 'A';
        q09.answer5 = 'A';
        q09.answer6 = 'A';
        
        test.startTest();
        CareerPlanning_A.saveQuestion09(cpList[0].Id, conList[0].Id, 'Test009', q09, 'English', 'Form V2');
        CareerPlanning_A.saveQuestion09(null, conList[0].Id, 'Test009', q09, 'English', 'Form V2');
        test.stopTest();
    }
    public class q09Answer{
        String answer1;
        String answer2;
        String answer3; 
        String answer4;
        String answer5;
        String answer6; 
        String answer7;
    }
    
    @isTest
    public static void test_saveAllQA(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		List<Career_Planning__c> cpList =[SELECT Id FROM Career_Planning__c WHERE Student__c = :conList[0].Id];

        qAnswerAll qAnsAll = new qAnswerAll();
        qAnsAll.q07.answer = 'A';
        qAnsAll.q08.answer = 'A';
        qAnsAll.q10.answer = 'A';
        qAnsAll.q09.answer1 = 'A';
        qAnsAll.q09.answer2 = 'A';
        qAnsAll.q09.answer3 = 'A';
        qAnsAll.q09.answer4 = 'A';
        qAnsAll.q09.answer5 = 'A';
        qAnsAll.q09.answer6 = 'A';
        
        test.startTest();
        CareerPlanning_A.saveAllQA(cpList[0].Id, conList[0].Id, 'Test009', qAnsAll, 'English', 'Form V2');
        CareerPlanning_A.saveAllQA(null, conList[0].Id, 'Test009', qAnsAll, 'English', 'Form V2');
        test.stopTest();
    }
    public class qAnswerAll{
        qAnswer q07;
        qAnswer q08;
        q09Answer q09;
        qAnswer q10;

        public qAnswerAll(){
            q07 = new qAnswer();
            q08 = new qAnswer();
            q09 = new q09Answer();
            q10 = new qAnswer();
        }
    }
    
    @isTest
    public static void test_submitAndCalculate(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		List<Career_Planning__c> cpList =[SELECT Id FROM Career_Planning__c WHERE Student__c = :conList[0].Id];
        List<OMR_Assessment__c> cdm1List = [SELECT Id FROM OMR_Assessment__c WHERE Student__c = :conList[0].Id];
		List<CDM2__c> cdm2List = [SELECT Id FROM CDM2__c WHERE Student__c = :conList[0].Id];
        
        test.startTest();
        CareerPlanning_A.submitAndCalculate(cpList[0].Id, cdm1List[0].Id, cdm2List[0].Id,'Hindi','Form V2');
        test.stopTest();
    }
}