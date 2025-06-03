@isTest
public class careerSkillsBaselineTest {
	
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

        Id csRecordTypeId = Schema.SObjectType.Career_Skill__c.getRecordTypeInfosByDeveloperName().get('Endline').getRecordTypeId();
        Career_Skill__c cs = new Career_Skill__c(RecordTypeId = csRecordTypeId);
        cs.Student__c = student.Id;
        cs.Barcode__c = 'Test009';
        cs.Created_from_Form__c = true;
        cs.Grade__c = 'Grade 9';
        Insert cs;
    }
    
    @isTest
    public static void getApexRecordTest(){
        careerSkillsBaseline.getApexRecord([select id from Contact limit 1].Id, 'Grade 9', '');
        careerSkillsBaseline.getApexRecord([select id from Contact limit 1].Id, 'Grade 9',[Select id from Batch__c limit 1].Id);
    }
    
    @isTest
    public static void submitAndCalculateTest(){
        careerSkillsBaseline.submitAndCalculate([select id from Career_Skill__c limit 1].Id);
    }
    
    @isTest
    public static void saveAllQATest(){
        careerSkillsBaseline.saveAllQA([select id from Career_Skill__c limit 1].Id, [select id from Contact limit 1].Id, 'Test009', new careerSkillsBaseline.qAnswerAll(), 'English', 'Form v2',[Select id from Batch__c limit 1].Id);
		careerSkillsBaseline.saveAllQA([select id from Career_Skill__c limit 1].Id, [select id from Contact limit 1].Id, 'Test009', new careerSkillsBaseline.qAnswerAll(), 'English', 'Form v2','');
        careerSkillsBaseline.saveAllQA(null, [select id from Contact limit 1].Id, 'Test009', new careerSkillsBaseline.qAnswerAll(), 'English', 'Form v2',[Select id from Batch__c limit 1].Id);
    }
    
    @isTest
    public static void saveQuestion11Test(){
        careerSkillsBaseline.saveQuestion11([select id from Career_Skill__c limit 1].Id, [select id from Contact limit 1].Id, 'Test009', new careerSkillsBaseline.comboAnswer(), 'English', 'Form v2');
    }
    
    @isTest
    public static void saveQuestion15Test(){
        careerSkillsBaseline.saveQuestion15([select id from Career_Skill__c limit 1].Id, [select id from Contact limit 1].Id, 'Test009', new careerSkillsBaseline.comboAnswer(), 'English', 'Form v2');
    }
    
    @isTest
    public static void saveQuestion12Test(){
        careerSkillsBaseline.saveQuestion12([select id from Career_Skill__c limit 1].Id, [select id from Contact limit 1].Id, 'Test009', new careerSkillsBaseline.q12Answer(), 'English', 'Form v2');
    }
    
    @isTest
    public static void saveSingleTest(){
        careerSkillsBaseline.saveSingle([select id from Career_Skill__c limit 1].Id, [select id from Contact limit 1].Id, 'Test009', '15_09', new careerSkillsBaseline.qAnswer(), 'English', 'Form v2');
    }
}