@isTest
public class AssesementQuestionControllerTest {
	
    @testSetup
    public static void setupData(){
        Assessment_Question__c q = new Assessment_Question__c();
        q.Sequence_Number__c = 1;
        q.Question_Label_English__c = 'Q1';
        q.Question_Label_Hindi__c = 'Q1';
        q.Assesment_Object__c = 'Self Awareness Realities';
        q.Form_Category__c = 'Form V2';
        q.Grade__c = 'Grade 9';
        
        insert q;
         
        Assessment_Question_Option__c  o = new Assessment_Question_Option__c();
        o.Option_Label_English__c = 'opt1';
        o.Option_Label_Hindi__c = 'opt1';
        o.Sequence_Number__c = 1;
        o.Question__c = q.Id;
		insert o;
    }
    
    @isTest
    public static void getAssesmentQuestionTest(){
        AssesementQuestionController.getAssesmentQuestion('Self Awareness Realities', 'Form V2', 'Grade 9');
    }
    
    @isTest
    public static void getStudentNameTest(){
         Account account=new Account();
        account.Name='Shreeram School';
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
		
        Batch__c b = new Batch__c();
        b.Name = 'ShreeramSchoolBatch1';
        b.School_Name__c = account.Id;
        b.Preferred_Language__c = 'English';
        insert b;
        
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
        
        AssesementQuestionController.getStudentName(student.Id);
    }
    
}