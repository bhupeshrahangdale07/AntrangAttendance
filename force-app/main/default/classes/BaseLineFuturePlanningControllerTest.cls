@isTest 
public class BaseLineFuturePlanningControllerTest {
	
    @testSetup
    public static void setupData(){
        
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
        student.Bar_Code__c = '2403960032';
        student.Grade_9_Barcode__c = '2403960032';
        student.Grade_10_Barcode__c = '2403960032';
        student.Grade_11_Barcode__c = '2403960032';
        student.Batch_Code__c = batch1.Id;
        Insert student;
        
        Future_Planning__c objFuturePlan = new Future_Planning__c(Student__c = student.Id, Barcode__c = '2403960032',Q_17__c = 'A',Q_18_1__c='A',Q_18_2__c='A',
                                                                  Q_18_4__c='A',Q_18_6__c='A',Q_18_8__c='A',Q_18_10__c='A',Q_18_11__c='A',
                                                                  Q_19__c ='C',Q_20__c='D',Q_21__c='A',Q_22__c='A');
        insert objFuturePlan ;
        
        
    }
    
    @isTest
    public static void getRecordAptTest(){
        BaseLineFuturePlanningController.getRecordApt([Select id from contact limit 1].Id, [Select id from Batch__c limit 1].Id, 'Grade 10');
    }
    
    @isTest
    public static void submitNCalculateTest(){
        BaseLineFuturePlanningController.submitNCalculate([Select id from Future_Planning__c limit 1].Id);
    }
    
    @isTest
    public static void getObjectIdTest(){
        BaseLineFuturePlanningController.getObjectId([Select id from contact limit 1].Id, 'Future_Planning__c');
    }
    
    @isTest
    public static void autoSaveDataTest(){
        BaseLineFuturePlanningController.autoSaveData([Select id from contact limit 1].Id, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*',
                                                      '*', '*', '*', '*', '*', '*', true, 'Grade 9', 'Form v2', 'English',
                                                     [Select id from Batch__c limit 1].Id);
    }
}