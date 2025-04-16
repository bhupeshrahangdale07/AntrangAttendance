@isTest
public class careerDecisionMaking_02_EndlineTest {
	@testsetup
    public static void testData()
    {
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        Account account = new Account();
        account.Name = 'Shreeram School';  
        account.RecordTypeId = RecordTypeIdAccount;
        insert account;

        Batch__c batch1 = new Batch__c();
        batch1.Name = 'batch 1';
        batch1.School_Name__c = account.id;
        batch1.Preferred_Language__c = 'Hindi';
        batch1.Grade__c = 'Grade 9';
        batch1.Medium_Language_of_Instruction__c = 'English';
        batch1.Academic_Year__c = 2022;
        Insert batch1;

        RecordType CA_Student_RecordType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Contact' AND Name = 'CA Student'];
        Contact student = new Contact(RecordTypeId = CA_Student_RecordType.Id);
        student.AccountId = account.Id;
        student.FirstName = 'First';
        student.LastName = 'Last';
        student.Bar_Code__c = 'Test009';
        student.Grade_9_Barcode__c = 'Test009';
        student.Grade_10_Barcode__c = 'Test010';
        student.Grade_11_Barcode__c = 'Test011';
        student.Batch_Code__c = batch1.Id;
        Insert student;

        Id cdm2RecordTypeId = Schema.SObjectType.CDM2__c.getRecordTypeInfosByDeveloperName().get('Endline').getRecordTypeId();
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
        careerDecisionMaking_02_Endline cdm2 = new careerDecisionMaking_02_Endline();
        careerDecisionMaking_02_Endline.qAnswerAll qSaveAll = new careerDecisionMaking_02_Endline.qAnswerAll();
        test.stopTest();
    }

    @isTest
    public static void test_getRecordCDM2()
    {
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
        test.startTest();
        careerDecisionMaking_02_Endline.singleRecordWrapper rspWrap = careerDecisionMaking_02_Endline.getRecordCDM2(conList[0].Id, 'Grade 9');
        careerDecisionMaking_02_Endline.getRecordCDM2(conList[0].Id, 'Grade 10');
        careerDecisionMaking_02_Endline.getRecordCDM2(conList[0].Id, 'Grade 11');
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
        careerDecisionMaking_02_Endline.saveQuestion05(cdm2List[0].Id, conList[0].Id , 'Test009', q05);
        careerDecisionMaking_02_Endline.saveQuestion05(null, conList[0].Id , 'Test009', q05);
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
        careerDecisionMaking_02_Endline.saveQuestion06(cdm2List[0].Id, conList[0].Id , 'Test009', q06, '1');
        careerDecisionMaking_02_Endline.saveQuestion06(null, conList[0].Id , 'Test009', q06, '1');
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
        careerDecisionMaking_02_Endline.saveAllQA(cdm2List[0].Id, conList[0].Id , 'Test009', qAll, 'English', 'Form V2' );
        careerDecisionMaking_02_Endline.saveAllQA(null, conList[0].Id , 'Test009', qAll, 'English', 'Form V2' );
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
        careerDecisionMaking_02_Endline.submitAndCalculate(cdm2List[0].Id);
        test.stopTest();
    }
}