@isTest
public class careerPlanning_A_EndlineTest {
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

        Id cpRecordTypeId = Schema.SObjectType.Career_Planning__c.getRecordTypeInfosByDeveloperName().get('Endline').getRecordTypeId();
        Career_Planning__c cp = new Career_Planning__c(RecordTypeId = cpRecordTypeId);
        cp.Student__c = student.Id;
        cp.Barcode__c = 'Test009';
        cp.Created_from_Form__c = true;
        Insert cp;
        
        Id cdm1RecordTypeId = Schema.SObjectType.OMR_Assessment__c.getRecordTypeInfosByDeveloperName().get('Endline').getRecordTypeId();
        OMR_Assessment__c cdm1 = new OMR_Assessment__c(RecordTypeId = cdm1RecordTypeId);
        cdm1.Student__c = student.Id;
        cdm1.Barcode__c = 'Test009';
        cdm1.Created_from_Form__c = true;
        Insert cdm1;
        
        Id cdm2RecordTypeId = Schema.SObjectType.CDM2__c.getRecordTypeInfosByDeveloperName().get('Endline').getRecordTypeId();
        CDM2__c cdm2 = new CDM2__c(RecordTypeId = cdm2RecordTypeId);
        cdm2.Student__c = student.Id;
        cdm2.Barcode__c = 'Test009';
        cdm2.Created_from_Form__c = true;
        Insert cdm2;
    }
    
    @isTest
    public static void test_Constructor(){

        test.startTest();
        careerPlanning_A_Endline cp = new careerPlanning_A_Endline();
        careerPlanning_A_Endline.qAnswerAll qSaveAll = new careerPlanning_A_Endline.qAnswerAll();
        test.stopTest();
    }
    
    @isTest
    public static void test_getApexRecord(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];

        test.startTest();
        careerPlanning_A_Endline.getApexRecord(conList[0].Id, 'Grade 9','');
        careerPlanning_A_Endline.getApexRecord(conList[0].Id, 'Grade 10','');
        careerPlanning_A_Endline.getApexRecord(conList[0].Id, 'Grade 11','');
        test.stopTest();
    }
    
    @isTest
    public static void test_saveSingle(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		List<Career_Planning__c> cpList =[SELECT Id FROM Career_Planning__c WHERE Student__c = :conList[0].Id];

        qAnswer qAns = new qAnswer();
        qAns.answer = 'A';
        test.startTest();
        careerPlanning_A_Endline.saveSingle(cpList[0].Id, conList[0].Id, 'Test009', '07', qAns);
        careerPlanning_A_Endline.saveSingle(cpList[0].Id, conList[0].Id, 'Test009', '08', qAns);
        careerPlanning_A_Endline.saveSingle(cpList[0].Id, conList[0].Id, 'Test009', '10', qAns);
        careerPlanning_A_Endline.saveSingle(null, conList[0].Id, 'Test009', '07', qAns);
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
        careerPlanning_A_Endline.saveQuestion09(cpList[0].Id, conList[0].Id, 'Test009', q09);
        careerPlanning_A_Endline.saveQuestion09(null, conList[0].Id, 'Test009', q09);
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
        careerPlanning_A_Endline.saveAllQA('',cpList[0].Id, conList[0].Id, 'Test009', qAnsAll, 'English', 'Form V2');
        //careerPlanning_A_Endline.saveAllQA('',null, conList[0].Id, 'Test009', qAnsAll, 'English', 'Form V2');
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
        careerPlanning_A_Endline.submitAndCalculate(cpList[0].Id, cdm1List[0].Id, cdm2List[0].Id);
        test.stopTest();
    }
}