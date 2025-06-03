@isTest
public class BarcodeGenerationQueueableTest {
	@testSetup
    public static void testData(){
        AntarangSetting__c setting = new AntarangSetting__c(Academic_Year__c = 2023, Next_Academic_Year__c = 2024,Max_Batch_Size__c=2);
        insert setting;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Mumbai';
        sm.Name = 'Mumbai Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'description';
        insert sm;
        
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='GOA';
        state.State_Code__c = 7;
        insert state;
         
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Mumbai';
        distict.Academic_Year__c = 2024;
        distict.Barcode_starts_with__c = '1';
        insert distict;
        
        Account account=new Account();
        account.Name='Shreeram School';
        account.District__c = distict.Id;
        account.State__c = state.Id;
        account.Barcode_starts_with__c='000001';
        account.Barcode_ends_with__c='000200';
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
        student.G10_Batch_Code__c = b.Id;
        student.G11_Batch_Code__c = b.Id;
        student.Grade_9_Barcode__c = '2407000051';
        student.Grade_10_Barcode__c = '2201000002';
        student.Grade_11_Barcode__c = '2201000003';
        student.Bar_Code__c = '2407000051';
        Insert student;
        
        Id rRecordTypeId = Schema.SObjectType.Self_Awareness_Realities__c.getRecordTypeInfosByDeveloperName().get('Baseline').getRecordTypeId();
        Self_Awareness_Realities__c saaf = new Self_Awareness_Realities__c(RecordTypeId = rRecordTypeId);
        saaf.Student__c = student.Id;
        saaf.Barcode__c = 'Test009';
        saaf.Created_from_Form__c = true;
        saaf.Form_Submitted__c = true;
        saaf.Reality_Form_Submitted__c = true;
        Insert saaf;
    }
    @isTest
    public static void testMethod01() {
		list<contact> lstContact = [SELECT Id, LastName, Grade_9_Barcode__c FROM Contact];
        batch__c batch = [select id from batch__c limit 1];
        batch__c bt =  BaselineController.getBatchCodeName(batch.id);
        Map<Id, Integer> retryCountMap = new Map<Id, Integer>();
        Test.startTest();
         System.enqueueJob(new BarcodeGenerationQueueable(lstContact, 'Grade 9', bt, 'Form V2',retryCountMap));
        Test.stopTest();
    }
    @isTest
    public static void testMethod01_grade10() {
		list<contact> lstContact = [SELECT Id, LastName, Grade_10_Barcode__c FROM Contact];
        batch__c batch = [select id from batch__c limit 1];
        batch__c bt =  BaselineController.getBatchCodeName(batch.id);
        Map<Id, Integer> retryCountMap = new Map<Id, Integer>();
        Test.startTest();
         System.enqueueJob(new BarcodeGenerationQueueable(lstContact, 'Grade 10', bt, 'Form V2',retryCountMap));
        Test.stopTest();
    }
    @isTest
    public static void testMethod01_grade11() {
		list<contact> lstContact = [SELECT Id, LastName, Grade_11_Barcode__c FROM Contact];
        batch__c batch = [select id from batch__c limit 1];
        batch__c bt =  BaselineController.getBatchCodeName(batch.id);
        Map<Id, Integer> retryCountMap = new Map<Id, Integer>();
        Test.startTest();
         System.enqueueJob(new BarcodeGenerationQueueable(lstContact, 'Grade 11', bt, 'Form V2',retryCountMap));
        Test.stopTest();
    }
    @isTest
    public static void testMethod01_grade12() {
		list<contact> lstContact = [SELECT Id, LastName, Grade_12_Barcode__c FROM Contact];
        batch__c batch = [select id from batch__c limit 1];
        batch__c bt =  BaselineController.getBatchCodeName(batch.id);
        Map<Id, Integer> retryCountMap = new Map<Id, Integer>();
        Test.startTest();
         System.enqueueJob(new BarcodeGenerationQueueable(lstContact, 'Grade 12', bt, 'Form V2',retryCountMap));
        Test.stopTest();
    }
    @isTest
    public static void testMethod02() {
		list<contact> lstContact = [SELECT Id, LastName, Grade_9_Barcode__c FROM Contact];
        batch__c batch = [select id from batch__c limit 1];
        batch__c bt =  BaselineController.getBatchCodeName(batch.id);
        Map<Id, Integer> retryCountMap = new Map<Id, Integer>();
        Test.startTest();
         System.enqueueJob(new BarcodeGenerationQueueable(lstContact, 'Grade 9', bt, 'Form V1',retryCountMap));
        Test.stopTest();
    }
    @isTest
    public static void testMethod03() {
		list<contact> lstContact = [SELECT Id, LastName, Grade_9_Barcode__c FROM Contact];
        batch__c batch = [select id from batch__c limit 1];
        batch__c bt =  BaselineController.getBatchCodeName(batch.id);
        Map<Id, Integer> retryCountMap = new Map<Id, Integer>();
        Test.startTest();
         System.enqueueJob(new BarcodeGenerationQueueable(lstContact, 'Grade 9', bt, 'Form V1',true,retryCountMap));
        Test.stopTest();
    }
     @isTest
    static void testQueueableExceptionHandling() {
        Map<Id, Integer> retryCountMap = new Map<Id, Integer>();
        District_Master__c dist = [select id from District_Master__c];
        dist.Academic_Year__c = null;
        update dist;
        Test.startTest();
        try {
            list<contact> lstContact = [SELECT Id, LastName, Grade_9_Barcode__c FROM Contact];
            batch__c bt =  [SELECT Name, School_Name__c, School_Name__r.name, Grade__c, Batch_Number__c, Academic_Year__c,
                                    School_Name__r.District__r.Academic_Year__c, School_Name__r.State__r.State_Code__c, 
                                   School_Name__r.District__r.Barcode_starts_with__c FROM Batch__c ];
            System.enqueueJob(new BarcodeGenerationQueueable(lstContact, '', bt, 'Form V1',true,retryCountMap)); // Passing null to cause an exception
        } catch (Exception e) {
        }
        Test.stopTest();
    }

     @isTest
    static void testQueueableCount5() {
        list<contact> lstContact = [SELECT Id, LastName, Grade_9_Barcode__c FROM Contact];
        Map<Id, Integer> retryCountMap = new Map<Id, Integer>();
        retryCountMap.put(lstContact[0].id, 5);
       
        Test.startTest();
        try {
            
            batch__c bt =  [SELECT Name, School_Name__c, School_Name__r.name, Grade__c, Batch_Number__c, Academic_Year__c,
                                    School_Name__r.District__r.Academic_Year__c, School_Name__r.State__r.State_Code__c, 
                                   School_Name__r.District__r.Barcode_starts_with__c FROM Batch__c ];
            System.enqueueJob(new BarcodeGenerationQueueable(lstContact, '', bt, 'Form V1',true,retryCountMap)); // Passing null to cause an exception
        } catch (Exception e) {
        }
        Test.stopTest();
    }

}