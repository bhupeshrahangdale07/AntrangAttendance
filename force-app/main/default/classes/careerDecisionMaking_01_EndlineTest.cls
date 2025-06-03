@isTest
public class careerDecisionMaking_01_EndlineTest {
	@testsetup
    public static void testData()
    {
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId() ;
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

        Id cdm1RecordTypeId = Schema.SObjectType.OMR_Assessment__c.getRecordTypeInfosByDeveloperName().get('Endline').getRecordTypeId();
        OMR_Assessment__c cdm1 = new OMR_Assessment__c(RecordTypeId = cdm1RecordTypeId);
        cdm1.Student__c = student.Id;
        cdm1.Barcode__c = 'Test009';
        cdm1.Created_from_Form__c = true;
        Insert cdm1;
    }

    @isTest
    public static void test_Constructor()
    {
        test.startTest();
        careerDecisionMaking_01_Endline cdm1 = new careerDecisionMaking_01_Endline();
        careerDecisionMaking_01_Endline.qAnswerAll qSaveAll = new careerDecisionMaking_01_Endline.qAnswerAll();
        test.stopTest();
    }

    @isTest
    public static void test_getRecordCDM1()
    {
        List<Contact> conList = new List<Contact>([
            SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'
        ]);

        test.startTest();
        careerDecisionMaking_01_Endline.getRecordCDM1(conList[0].Id, 'Grade 9','');
        test.stopTest();
    }

    private class q01Answer{
        String answer;
    }

    @isTest
    public static void test_saveQuestion01()
    {
        List<Contact> conList = new List<Contact>([
            SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'
        ]);
        
        List<OMR_Assessment__c> cdm1List = new List<OMR_Assessment__c>([
            SELECT Id FROM OMR_Assessment__c WHERE Student__c = :conList[0].Id
        ]);

        q01Answer q01 = new q01Answer();
        q01.answer = 'A';
        test.startTest();
        careerDecisionMaking_01_Endline.saveQuestion01(cdm1List[0].Id, conList[0].Id, 'Test009', q01);
        careerDecisionMaking_01_Endline.saveQuestion01(null, conList[0].Id, 'Test009', q01);
        test.stopTest();
    }

    private class q02Answer{
        String answer_2_1;
        String answer_2_2;
        String answer_2_3; 
        String answer_2_4;
        String answer_2_5;
        String answer_2_6; 
        String answer_2_7;
    }

    @isTest
    public static void test_saveQuestion02()
    {
        List<Contact> conList = new List<Contact>([
            SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'
        ]);
        
        List<OMR_Assessment__c> cdm1List = new List<OMR_Assessment__c>([
            SELECT Id FROM OMR_Assessment__c WHERE Student__c = :conList[0].Id
        ]);

        q02Answer q02 = new q02Answer();
        q02.answer_2_1 = 'A';
        q02.answer_2_6 = 'F';
        test.startTest();
        careerDecisionMaking_01_Endline.saveQuestion02(cdm1List[0].Id, conList[0].Id, 'Test009', q02);
        careerDecisionMaking_01_Endline.saveQuestion02(null, conList[0].Id, 'Test009', q02);
        test.stopTest();
    }

    private class q03Answer{
        String answer_3_1;
        String answer_3_2;
        String answer_3_3; 
        String answer_3_4;
        String answer_3_5;
        String answer_3_6; 
        String answer_3_7;
    }

    @isTest
    public static void test_saveQuestion03()
    {
        List<Contact> conList = new List<Contact>([
            SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'
        ]);
        
        List<OMR_Assessment__c> cdm1List = new List<OMR_Assessment__c>([
            SELECT Id FROM OMR_Assessment__c WHERE Student__c = :conList[0].Id
        ]);

        q03Answer q03 = new q03Answer();
        q03.answer_3_1 = 'A';
        q03.answer_3_7 = 'G';
        test.startTest();
        careerDecisionMaking_01_Endline.saveQuestion03(cdm1List[0].Id, conList[0].Id, 'Test009', q03);
        careerDecisionMaking_01_Endline.saveQuestion03(null, conList[0].Id, 'Test009', q03);
        test.stopTest();
    }

    private class q04Answer{
        String answer_4_1;
        String answer_4_2;
        String answer_4_3; 
        String answer_4_4;
        String answer_4_5;
        String answer_4_6; 
        String answer_4_7;
        String answer_4_8; 
        String answer_4_9;
        String answer_4_10;
        String answer_4_11;
        String answer_4_12;
        String answer_4_13; 
        String answer_4_14;
        String answer_4_15;
        String answer_4_16; 
        String answer_4_17;
        String answer_4_18; 
        String answer_4_19;
        String answer_4_20;
        String answer_4_21;
        String answer_4_22;
        String answer_4_23; 
        String answer_4_24;
        String answer_4_25;
        String answer_4_26; 
        String answer_4_27;
        String answer_4_28; 
        String answer_4_29;
        String answer_4_30;
        String answer_4_31;
        String answer_4_32;
        String answer_4_33; 
        String answer_4_34;
        String answer_4_35;
        String answer_4_36; 
        String answer_4_37;
        String answer_4_38; 
        String answer_4_39;
        String answer_4_40;
        String answer_4_41;
        String answer_4_42;
        String answer_4_43; 
        String answer_4_44;
        String answer_4_45;
        String answer_4_46; 
        String answer_4_47;
        String answer_4_48; 
        String answer_4_49;
        String answer_4_50;
        String answer_4_51;
        String answer_4_52;
        String answer_4_53; 
    }

    @isTest
    public static void test_saveQuestion04()
    {
        List<Contact> conList = new List<Contact>([
            SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'
        ]);
        
        List<OMR_Assessment__c> cdm1List = new List<OMR_Assessment__c>([
            SELECT Id FROM OMR_Assessment__c WHERE Student__c = :conList[0].Id
        ]);

        q04Answer q04 = new q04Answer();
        q04.answer_4_25 = 'A';
        q04.answer_4_50 = 'B';
        test.startTest();
        careerDecisionMaking_01_Endline.saveQuestion04(cdm1List[0].Id, conList[0].Id, 'Test009', q04);
        careerDecisionMaking_01_Endline.saveQuestion04(null, conList[0].Id, 'Test009', q04);
        test.stopTest();
    }

    private class qAnswerAll{
        q01Answer q01;
        q02Answer q02;
        q03Answer q03;
        q04Answer q04;

        private qAnswerAll(){
            q01 = new q01Answer();
            q02 = new q02Answer();
            q03 = new q03Answer();
            q04 = new q04Answer();
        }
    }

    @isTest
    public static void test_saveAllQA()
    {
        List<Contact> conList = new List<Contact>([
            SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'
        ]);
        
        List<OMR_Assessment__c> cdm1List = new List<OMR_Assessment__c>([
            SELECT Id FROM OMR_Assessment__c WHERE Student__c = :conList[0].Id
        ]);

        qAnswerAll qAll = new qAnswerAll();
        qAll.q01.answer = 'A';

        qAll.q02.answer_2_1 = 'A';
        qAll.q02.answer_2_6 = 'F';
		
		qAll.q03.answer_3_1 = 'A';
        qAll.q03.answer_3_7 = 'G';
		
		qAll.q04.answer_4_25 = 'A';
        qAll.q04.answer_4_50 = 'B';

        test.startTest();
        careerDecisionMaking_01_Endline.saveAllQA(cdm1List[0].Id, conList[0].Id, 'Test009', qAll, 'English', 'Form V2','' );
        //careerDecisionMaking_01_Endline.saveAllQA(null, conList[0].Id, 'Test009', qAll, 'English', 'Form V2','' );
        test.stopTest();
    } 

    @isTest
    public static void test_submitAndCalculate()
    {
        List<Contact> conList = new List<Contact>([
            SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'
        ]);
        
        List<OMR_Assessment__c> cdm1List = new List<OMR_Assessment__c>([
            SELECT Id FROM OMR_Assessment__c WHERE Student__c = :conList[0].Id
        ]);

        test.startTest();
        careerDecisionMaking_01_Endline.submitAndCalculate(cdm1List[0].Id);
        test.stopTest();
    }

    @isTest
    public static void test_getBatchInfo()
    {
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Shreeram School' LIMIT 1];
        Batch__c bch = [SELECT Id FROM Batch__c WHERE School_Name__c = :acc.id];

        test.startTest();
        careerDecisionMaking_01_Endline.getBatchInfo(bch.Id);
        test.stopTest();
    }

    @isTest
    public static void test_searchStudentRecords()
    {
        List<Contact> conList = new List<Contact>([
            SELECT Id, Grade_9_Barcode__c FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'
        ]);

        Id cpRecordTypeId = Schema.SObjectType.Career_Planning__c.getRecordTypeInfosByDeveloperName()
        .get('Baseline').getRecordTypeId();
        Career_Planning__c cpObj = new Career_Planning__c();    
        cpObj.RecordTypeId = cpRecordTypeId;     
        cpObj.Student__c = conList[0].Id;
        cpObj.Barcode__c = conList[0].Grade_9_Barcode__c;
        cpObj.Created_from_Form__c = true;
        cpObj.Form_Submitted__c = true;
        upsert cpObj;

        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Shreeram School' LIMIT 1];
        Batch__c bch = [SELECT Id FROM Batch__c WHERE School_Name__c = :acc.id];

        test.startTest();
        careerDecisionMaking_01_Endline.searchStudentRecords('First', bch.Id, 'Grade 9','Form V2');
        test.stopTest();
    }
}