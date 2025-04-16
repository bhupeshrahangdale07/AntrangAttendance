@isTest
public class careerDecisionMaking_02Test {
	@testsetup
    public static void testData()
    {
        Account account = new Account();
        account.Name ='Shreeram School';
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId = RecordTypeIdAccount;
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

        Id cdm2RecordTypeId = Schema.SObjectType.CDM2__c.getRecordTypeInfosByDeveloperName().get('Baseline').getRecordTypeId();

        CDM2__c cdm2 = new CDM2__c(RecordTypeId = cdm2RecordTypeId);
        cdm2.Student__c = student.Id;
        cdm2.Barcode__c = 'Test009';
        cdm2.Created_from_Form__c = true;
        Insert cdm2;
    }
	 
    @isTest
    public static void test_Constructor()
    {
        test.startTest();
        careerDecisionMaking_02 cdm1 = new careerDecisionMaking_02();
        careerDecisionMaking_02.qAnswerAll qSaveAll = new careerDecisionMaking_02.qAnswerAll();
        test.stopTest();
    }
    
    @isTest
    public static void test_getRecordCDM2()
    {
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
        test.startTest();
        careerDecisionMaking_02.singleRecordWrapper rspWrap = careerDecisionMaking_02.getRecordCDM2(conList[0].Id, 'Grade 9');
        careerDecisionMaking_02.getRecordCDM2(conList[0].Id, 'Grade 10');
        careerDecisionMaking_02.getRecordCDM2(conList[0].Id, 'Grade 11');
        test.stopTest();
        
        System.assertEquals('First Last',rspWrap.studentName,'Contact Size is Not Matched');
    }
    
    @isTest
    public static void test_saveQuestion05()
    {
        List<Contact> conList = [SELECT Id, Grade_9_Barcode__c FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
        List<CDM2__c> cdm2List = new List<CDM2__c>([
            SELECT Id FROM CDM2__c WHERE Student__c = :conList[0].Id
        ]);

        q05Answer q05 = new q05Answer();
        q05.answer = 'A';
        
        test.startTest();
        careerDecisionMaking_02.saveQuestion05(cdm2List[0].Id, conList[0].Id , 'Test009', q05, 'English', 'Form V2');
        careerDecisionMaking_02.saveQuestion05(null, conList[0].Id , 'Test009', q05, 'English', 'Form V2');
        test.stopTest();
    }
    public class q05Answer{
        String answer;
    }
    
    @isTest
    public static void test_saveQuestion06(){
        
    	List<Contact> conList = [SELECT Id, Grade_9_Barcode__c FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
        List<CDM2__c> cdm2List = [SELECT Id FROM CDM2__c WHERE Student__c = :conList[0].Id];

        q06Answer q06 = new q06Answer();
        q06.answer = 'A';
        
        test.startTest();
        careerDecisionMaking_02.saveQuestion06(cdm2List[0].Id, conList[0].Id , 'Test009', q06, '1', 'English', 'Form V2');
        careerDecisionMaking_02.saveQuestion06(null, conList[0].Id , 'Test009', q06, '1', 'English', 'Form V2');
        test.stopTest();
    }
    public class q06Answer{
        String answer;
    }
    
    @isTest
    public static void test_saveAllQA(){
        List<Contact> conList = [SELECT Id, Grade_9_Barcode__c FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
        List<CDM2__c> cdm2List = [SELECT Id FROM CDM2__c WHERE Student__c = :conList[0].Id];

        qAnswerAll qAll = new qAnswerAll();
        qAll.q05.answer = 'A';

        qAll.q06_01.answer = 'A';
        qAll.q06_02.answer = 'A';
        qAll.q06_03.answer = 'A';
        qAll.q06_04.answer = 'A';
        qAll.q06_05.answer = 'A';
        qAll.q06_06.answer = 'A';
        qAll.q06_07.answer = 'A';
        qAll.q06_08.answer = 'A';
        qAll.q06_09.answer = 'A';
        qAll.q06_10.answer = 'A';
        qAll.q06_11.answer = 'A';
        qAll.q06_12.answer = 'A';
        
        test.startTest();
        careerDecisionMaking_02.saveAllQA(cdm2List[0].Id, conList[0].Id , 'Test009', qAll, 'English', 'Form V2');
        careerDecisionMaking_02.saveAllQA(null, conList[0].Id , 'Test009', qAll, 'English', 'Form V2');
        test.stopTest();
    }
    
    public class qAnswerAll{
        q05Answer q05;
        q06Answer q06_01;
        q06Answer q06_02;
        q06Answer q06_03;
        q06Answer q06_04;
        q06Answer q06_05;
        q06Answer q06_06;
        q06Answer q06_07;
        q06Answer q06_08;
        q06Answer q06_09;
        q06Answer q06_10;
        q06Answer q06_11;
        q06Answer q06_12;
        
        public qAnswerAll(){
            q05 = new q05Answer();
            q06_01 = new q06Answer();
            q06_02 = new q06Answer();
            q06_03 = new q06Answer();
            q06_04 = new q06Answer();
            q06_05 = new q06Answer();
            q06_06 = new q06Answer();
            q06_07 = new q06Answer();
            q06_08 = new q06Answer();
            q06_09 = new q06Answer();
            q06_10 = new q06Answer();
            q06_11 = new q06Answer();
            q06_12 = new q06Answer();
        }
    }
    
    @isTest
    public static void test_submitAndCalculate(){
        List<Contact> conList = [SELECT Id, Grade_9_Barcode__c FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
        List<CDM2__c> cdm2List = [SELECT Id FROM CDM2__c WHERE Student__c = :conList[0].Id];
  
        test.startTest();
        careerDecisionMaking_02.submitAndCalculate(cdm2List[0].Id);
        test.stopTest();
    }
}