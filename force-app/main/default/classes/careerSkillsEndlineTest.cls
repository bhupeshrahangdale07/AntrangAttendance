@isTest
public class careerSkillsEndlineTest {
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

        Id csRecordTypeId = Schema.SObjectType.Career_Skill__c.getRecordTypeInfosByDeveloperName().get('Endline').getRecordTypeId();
        Career_Skill__c cs = new Career_Skill__c(RecordTypeId = csRecordTypeId);
        cs.Student__c = student.Id;
        cs.Barcode__c = 'Test009';
        cs.Created_from_Form__c = true;
        Insert cs;
    }
    
    @isTest
    public static void test_Constructor(){

        test.startTest();
        careerSkillsEndline cp = new careerSkillsEndline();
        careerSkillsEndline.qAnswerAll qSaveAll = new careerSkillsEndline.qAnswerAll();
        test.stopTest();
    }
    
    @isTest
    public static void test_getApexRecord(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];

        test.startTest();
        careerSkillsEndline.getApexRecord(conList[0].Id, 'Grade 9','');
        careerSkillsEndline.getApexRecord(conList[0].Id, 'Grade 10','');
        careerSkillsEndline.getApexRecord(conList[0].Id, 'Grade 11','');
        test.stopTest();
    }
    
    @isTest
    public static void test_saveQuestion11(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		List<Career_Skill__c> csList =[SELECT Id FROM Career_Skill__c WHERE Student__c = :conList[0].Id];

        comboAnswer q11 = new comboAnswer();
        q11.answer1 = 'A';
        q11.answer2 = 'A';
        q11.answer3 = 'A';
        q11.answer4 = 'A';
        q11.answer5 = 'A';
        q11.answer6 = 'A';
        q11.answer7 = 'A';
        q11.answer8 = 'A';
        q11.answer9 = 'A';
        
        test.startTest();
        careerSkillsEndline.saveQuestion11(csList[0].Id, conList[0].Id, 'Test009', q11);
        careerSkillsEndline.saveQuestion11(null, conList[0].Id, 'Test009', q11);
        test.stopTest();
    }
    public class comboAnswer{
        String answer1;
        String answer2;
        String answer3; 
        String answer4;
        String answer5;
        String answer6; 
        String answer7;
        String answer8; 
        String answer9;
    }
    
    @isTest
    public static void test_saveQuestion15(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		List<Career_Skill__c> csList =[SELECT Id FROM Career_Skill__c WHERE Student__c = :conList[0].Id];

        comboAnswer q11 = new comboAnswer();
        q11.answer1 = 'A';
        q11.answer2 = 'A';
        q11.answer3 = 'A';
        q11.answer4 = 'A';
        q11.answer5 = 'A';
        q11.answer6 = 'A';
        q11.answer7 = 'A';
        q11.answer8 = 'A';
        q11.answer9 = 'A';
        
        test.startTest();
        careerSkillsEndline.saveQuestion15(csList[0].Id, conList[0].Id, 'Test009', q11);
        careerSkillsEndline.saveQuestion15(null, conList[0].Id, 'Test009', q11);
        test.stopTest();
    }
    
    @isTest
    public static void test_saveSingle(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		List<Career_Skill__c> csList =[SELECT Id FROM Career_Skill__c WHERE Student__c = :conList[0].Id];

        qAnswer qAns = new qAnswer();
        qAns.answer = 'A';
        
        test.startTest();
        careerSkillsEndline.saveSingle(csList[0].Id, conList[0].Id, 'Test009', '07', qAns);
        careerSkillsEndline.saveSingle(csList[0].Id, conList[0].Id, 'Test009', '08', qAns);
        careerSkillsEndline.saveSingle(csList[0].Id, conList[0].Id, 'Test009', '10', qAns);
        careerSkillsEndline.saveSingle(null, conList[0].Id, 'Test009', '07', qAns);
        test.stopTest();
    }    
	public class qAnswer{
        String answer;
    }
    
	@isTest
    public static void test_saveQuestion12(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		List<Career_Skill__c> csList =[SELECT Id FROM Career_Skill__c WHERE Student__c = :conList[0].Id];

        q12Answer q12 = new q12Answer();
        q12.answer_2_1 = 'A';
        q12.answer_2_2 = 'A';
        q12.answer_2_3 = 'A';
        q12.answer_2_4 = 'A';
        
        test.startTest();
        careerSkillsEndline.saveQuestion12(csList[0].Id, conList[0].Id, 'Test009', q12);
        careerSkillsEndline.saveQuestion12(null, conList[0].Id, 'Test009', q12);
        test.stopTest();
    }
    public class q12Answer{
        String answer_2_1;
        String answer_2_2;
        String answer_2_3; 
        String answer_2_4;
    }
    
    @isTest
    public static void test_saveAllQA(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		List<Career_Skill__c> csList =[SELECT Id FROM Career_Skill__c WHERE Student__c = :conList[0].Id];

        qAnswerAll qAnsAll = new qAnswerAll();
        qAnsAll.q11.answer1 = 'A';
        qAnsAll.q11.answer1 = 'A';
        qAnsAll.q11.answer2 = 'A';
        qAnsAll.q11.answer3 = 'A';
        qAnsAll.q11.answer4 = 'A';
        qAnsAll.q11.answer5 = 'A';
        qAnsAll.q11.answer6 = 'A';
        qAnsAll.q11.answer7 = 'A';
        qAnsAll.q11.answer8 = 'A';
        qAnsAll.q11.answer9 = 'A';
        
        qAnsAll.q12.answer_2_1 = 'A';
        qAnsAll.q12.answer_2_2 = 'A';
        qAnsAll.q12.answer_2_3 = 'A';
        qAnsAll.q12.answer_2_4 = 'A';
        
        qAnsAll.q13.answer = 'A';
        
        qAnsAll.q14.answer = 'A';
        
        qAnsAll.q15.answer1 = 'A';
        qAnsAll.q15.answer1 = 'A';
        qAnsAll.q15.answer2 = 'A';
        qAnsAll.q15.answer3 = 'A';
        qAnsAll.q15.answer4 = 'A';
        qAnsAll.q15.answer5 = 'A';
        qAnsAll.q15.answer6 = 'A';
        qAnsAll.q15.answer7 = 'A';
        qAnsAll.q15.answer8 = 'A';
        qAnsAll.q15.answer9 = 'A';
        
        qAnsAll.q16.answer = 'A';
        
        test.startTest();
        careerSkillsEndline.saveAllQA(csList[0].Id, conList[0].Id, 'Test009', qAnsAll, 'English', 'Form V2','' );
        //careerSkillsEndline.saveAllQA(null, conList[0].Id, 'Test009', qAnsAll, 'English', 'Form V2','' );
        test.stopTest();
    }
    public class qAnswerAll{
        comboAnswer q11;
        q12Answer q12;
        qAnswer q13;
        qAnswer q14;
        comboAnswer q15;
        qAnswer q16;

        public qAnswerAll(){
            q11 = new comboAnswer();
            q12 = new q12Answer();
            q13 = new qAnswer();
            q14 = new qAnswer();
            q15 = new comboAnswer();
            q16 = new qAnswer();
        }
    }
    
     @isTest
    public static void test_submitAndCalculate(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		List<Career_Skill__c> csList =[SELECT Id FROM Career_Skill__c WHERE Student__c = :conList[0].Id];
        
        test.startTest();
        careerSkillsEndline.submitAndCalculate(csList[0].Id);
        test.stopTest();
    }
    
}