@isTest
public class EndlineFuturePlanningControllerTest {
	@testsetup
    public static void testData(){
        Account account=new Account();
        account.Name='Shreeram School';
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
		
        List<Batch__c> batchList = new List<Batch__c>{
            new Batch__c(Name = 'ShreeramSchoolBatch1', School_Name__c = account.Id, Preferred_Language__c = 'English'),
            new Batch__c(Name = 'ShreeramSchoolBatch2', School_Name__c = account.Id, Preferred_Language__c = 'English')
                };
        insert batchList;
        
        RecordType CA_Student_RecordType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Contact' AND Name = 'CA Student'];
        List<Contact> studentList = new List<Contact>{
            new Contact(AccountId = account.Id, FirstName = 'First', LastName = 'Last', Batch_Code__c = batchList[0].Id, 
                        G10_Batch_Code__c = null, G11_Batch_Code__c = null, G12_Batch_Code__c = null,
                        Bar_Code__c = 'Test009', Grade_9_Barcode__c = 'Test009', Grade_10_Barcode__c = 'Test010', 
                        Grade_11_Barcode__c = 'Test011', RecordTypeId = CA_Student_RecordType.Id),
        	new Contact(AccountId = account.Id, FirstName = 'First2', LastName = 'Last2', G10_Batch_Code__c = batchList[1].Id, 
                        Bar_Code__c = 'Test0009', Grade_9_Barcode__c = 'Test0009', Grade_10_Barcode__c = 'Test0010', 
                        Grade_11_Barcode__c = 'Test0011', RecordTypeId = CA_Student_RecordType.Id)
                };
            insert studentList;
        
        Id cdm1RecordTypeId = Schema.SObjectType.OMR_Assessment__c.getRecordTypeInfosByDeveloperName().get('Endline').getRecordTypeId();
        OMR_Assessment__c cdm1 = new OMR_Assessment__c(RecordTypeId = cdm1RecordTypeId);
        cdm1.Student__c = studentList[0].Id;
        cdm1.Barcode__c = 'Test009';
        cdm1.Created_from_Form__c = true;
        Insert cdm1;

        Id cdm2RecordTypeId = Schema.SObjectType.CDM2__c.getRecordTypeInfosByDeveloperName().get('Endline').getRecordTypeId();
        CDM2__c cdm2 = new CDM2__c(RecordTypeId = cdm2RecordTypeId);
        cdm2.Student__c = studentList[0].Id;
        cdm2.Barcode__c = 'Test009';
        cdm2.Created_from_Form__c = true;
        Insert cdm2;
        
        Id csRecordTypeId = Schema.SObjectType.Career_Skill__c.getRecordTypeInfosByDeveloperName().get('Endline').getRecordTypeId();
        Career_Skill__c cs = new Career_Skill__c(RecordTypeId = csRecordTypeId);
        cs.Student__c =  studentList[0].Id;
        cs.Barcode__c = 'Test009';
        cs.Created_from_Form__c = true;
        Insert cs;
        
        Id cpRecordTypeId = Schema.SObjectType.Career_Planning__c.getRecordTypeInfosByDeveloperName().get('Endline').getRecordTypeId();
        Career_Planning__c cp = new Career_Planning__c(RecordTypeId = cpRecordTypeId);
        cp.Student__c =  studentList[0].Id;
        cp.Barcode__c = 'Test009';
        cp.Created_from_Form__c = true;
        Insert cp;
        
        Id fpRecordTypeId = Schema.SObjectType.Future_Planning__c.getRecordTypeInfosByDeveloperName().get('Endline').getRecordTypeId();
        List<Future_Planning__c> fpList = new List<Future_Planning__c>{
            new Future_Planning__c(Student__c = studentList[0].Id, Barcode__c = 'Test009', Created_from_Form__c = true, 
                                               Form_Submitted__c = true, Future_Planning_form_submitted__c = true, RecordTypeId = fpRecordTypeId)
        };
            insert fpList;
    }
    
    @isTest
    public static void test_autoSaveData(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
    	Contact con1 = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last2' AND Bar_Code__c = 'Test0009'];
        map<string, string> formType = new map<string, string>();
        formType.put('lng', 'English');
        formType.put('typ', 'Form v2');
        
        test.startTest();
        String response1 = EndlineFuturePlanningController.autoSaveData(conList[0].Id, 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', true, 'Grade 9');
        String response2 = EndlineFuturePlanningController.autoSaveData(con1.Id, 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', true, 'Grade 9');
        
        EndlineFuturePlanningController.SaveAllData(conList[0].Id, 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a',  true, 'Grade 9', JSON.serialize(formType));
          
        EndlineFuturePlanningController.calculateForms('', [Select Id from OMR_Assessment__c Limit 1].Id, [Select Id from CDM2__c Limit 1].Id, [Select Id from Career_Planning__c Limit 1].Id, [Select Id from Career_Skill__c Limit 1].Id, [Select Id from Future_Planning__c Limit 1].Id);
            
        test.stopTest();
        
        System.assertEquals('Update', response1);
        System.assertEquals('Insert', response2); 
    }
    
    @isTest
    public static void test_getRecordApt(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		Contact con1 = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last2' AND Bar_Code__c = 'Test0009'];
        
        test.startTest();
        Future_Planning__c resFP1 = EndlineFuturePlanningController.getRecordApt(conList[0].Id);
        Future_Planning__c resFP2 = EndlineFuturePlanningController.getRecordApt(con1.Id);
        test.stopTest();
        
        System.assertEquals(true,resFP1.Created_from_Form__c,'resFP1.Created_from_Form__c is false');
        System.assertEquals(false,resFP2.Created_from_Form__c,'resFP2.Created_from_Form__c is true');
    }
}