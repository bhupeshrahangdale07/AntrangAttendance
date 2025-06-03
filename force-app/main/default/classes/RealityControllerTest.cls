@isTest
public class RealityControllerTest {
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

        Id rRecordTypeId = Schema.SObjectType.Self_Awareness_Realities__c.getRecordTypeInfosByDeveloperName().get('Baseline').getRecordTypeId();
        List<Self_Awareness_Realities__c> sarList = new List<Self_Awareness_Realities__c>{
            new Self_Awareness_Realities__c(Student__c = studentList[0].Id, Barcode__c = '000001', Created_from_Form__c = true, 
                                               Form_Submitted__c = true, Reality_Form_Submitted__c = true, RecordTypeId = rRecordTypeId),
            new Self_Awareness_Realities__c(Student__c = studentList[1].Id, Barcode__c = '000001', Created_from_Form__c = true, 
                                               Form_Submitted__c = true, Reality_Form_Submitted__c = true, RecordTypeId = rRecordTypeId)
        };
            insert sarList;
    }
    
    @isTest
    public static void test_searchStudentRecords(){
       	List<Contact> conList = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		Contact con1 = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last2' AND Bar_Code__c = 'Test0009'];
        
        test.startTest();
        RealityController.responseWrapper rspWrap1 = RealityController.searchStudentRecords('First', conList[0].Batch_Code__c, 'Grade 9');
        RealityController.responseWrapper rspWrap2 = RealityController.searchStudentRecords('First2', con1.Batch_Code__c, 'Grade 10');
        RealityController.searchStudentRecords('First', conList[0].Batch_Code__c, 'Grade 11');
        test.stopTest();
        System.assertEquals(1,rspWrap1.batchTotalStudents,'Contact Size is Not Matched');
        System.assertEquals(1,rspWrap2.batchTotalStudents,'Contact Size is Not Matched');
    }
    
    @isTest
    public static void test_getStudentData(){
       	List<Contact> conList = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];

        test.startTest();
        RealityController.studentDataWrapper stdWrap = RealityController.getStudentData(conList[0].Batch_Code__c, 'Grade 9');
        string stdWrap1 = RealityController.getRealityRecord(conList[0].id, 'Grade 9',conList[0].Batch_Code__c);
        test.stopTest();
        
		System.assertEquals(1,stdWrap.countStudent,'Contact Size is Not Matched');        
    }
    
    @isTest
    public static void test_getRecordApt(){
        List<Contact> conList = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];

        test.startTest();
        Self_Awareness_Realities__c resSAR = RealityController.getRecordApt(conList[0].id, 'Grade 9',conList[0].Batch_Code__c);
        test.stopTest();
        
        System.assertEquals(true,resSAR.Created_from_Form__c,'resSAR.Created_from_Form__c is false');
    }
    
    /*@isTest
    public static void test_dataPrepare(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
        Self_Awareness_Realities__c sar =[SELECT Id FROM Self_Awareness_Realities__c WHERE Student__c = :conList[0].Id];
        test.startTest();
        RealityController.dataPrepare(true, sar, 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a');
        test.stopTest();
    }*/
    
    @isTest
    public static void test_submitAndCalculate(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
        Self_Awareness_Realities__c sar =[SELECT Id FROM Self_Awareness_Realities__c WHERE Student__c = :conList[0].Id];
        test.startTest();
        String response = RealityController.submitAndCalculate(sar.Id);
        test.stopTest();
        
        System.assertEquals('success', response);
    }
    
    @isTest
    public static void test_saveData(){
        List<Contact> conList = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
    	Contact con1 = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last2' AND Bar_Code__c = 'Test0009'];
        
        test.startTest();
        String response1 = RealityController.saveData(conList[0].Batch_Code__c, conList[0].Id, 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', true, 'Grade 9', '', 'English');
        String response2 = RealityController.saveData(conList[0].Batch_Code__c, con1.Id , 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', true, 'Grade 9', '', 'Hindi');
        test.stopTest();
        
        //System.assertEquals('Update', response1);
		//System.assertEquals('Insert', response2);
    }
}