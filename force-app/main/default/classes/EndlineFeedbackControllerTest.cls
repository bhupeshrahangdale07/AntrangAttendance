@isTest
public class EndlineFeedbackControllerTest {
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
                        G10_Batch_Code__c = null, G11_Batch_Code__c = null,G12_Batch_Code__c = null,
                        Bar_Code__c = 'Test009', Grade_9_Barcode__c = 'Test009', Grade_10_Barcode__c = 'Test010', 
                        Grade_11_Barcode__c = 'Test011', RecordTypeId = CA_Student_RecordType.Id),
        	new Contact(AccountId = account.Id, FirstName = 'First2', LastName = 'Last2', G10_Batch_Code__c = batchList[1].Id, 
                        Bar_Code__c = 'Test0009', Grade_9_Barcode__c = 'Test0009', Grade_10_Barcode__c = 'Test0010', 
                        Grade_11_Barcode__c = 'Test0011', RecordTypeId = CA_Student_RecordType.Id)
                };
            insert studentList;

        Id fpRecordTypeId = Schema.SObjectType.Future_Planning__c.getRecordTypeInfosByDeveloperName().get('Endline').getRecordTypeId();
        List<Future_Planning__c> fpList = new List<Future_Planning__c>{
            new Future_Planning__c(Student__c = studentList[0].Id, Barcode__c = 'Test009', Created_from_Form__c = true, 
                                               Form_Submitted__c = true, Future_Planning_form_submitted__c = true, RecordTypeId = fpRecordTypeId)
        };
            insert fpList;
    }
    
    @isTest
    public static void test_saveData(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
    	Contact con1 = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last2' AND Bar_Code__c = 'Test0009'];
        
        test.startTest();
        String response1 = EndlineFeedbackController.saveData(conList[0].Id, 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', true, 'Grade 9');
        String response2 = EndlineFeedbackController.saveData(con1.Id, 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', true, 'Grade 9');
        test.stopTest();
        
        System.assertEquals('Update', response1);
        System.assertEquals('Insert', response2);
    }
    
     @isTest
    public static void test_getRecordApt(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		Contact con1 = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last2' AND Bar_Code__c = 'Test0009'];
        
        test.startTest();
        Future_Planning__c resFP1 = EndlineFeedbackController.getRecordApt(conList[0].Id);
        Future_Planning__c resFP2 = EndlineFeedbackController.getRecordApt(con1.Id);
        test.stopTest();
        
        System.assertEquals(true,resFP1.Created_from_Form__c,'resFP1.Created_from_Form__c is false');
        System.assertEquals(false,resFP2.Created_from_Form__c,'resFP2.Created_from_Form__c is true');
    }
    
    @isTest
    public static void test_getStudentRecord(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		Contact con1 = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last2' AND Bar_Code__c = 'Test0009'];
        
        test.startTest();
        Future_Planning__c resFP1 = EndlineFeedbackController.getStudentRecord(conList[0].Id);
        Future_Planning__c resFP2 = EndlineFeedbackController.getStudentRecord(con1.Id);
        test.stopTest();
        
        System.assertEquals(true,resFP1.Created_from_Form__c,'resFP1.Created_from_Form__c is false');
        System.assertEquals(false,resFP2.Created_from_Form__c,'resFP2.Created_from_Form__c is true');
    }
    
    @isTest
    public static void test_SaveAllData(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
    	Contact con1 = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last2' AND Bar_Code__c = 'Test0009'];
        
        map<string, string> formDetails = new map<string, string>();
        formDetails.put('lng', 'English');
        formDetails.put('typ', 'Form v2');
        
        test.startTest();
        String response1 = EndlineFeedbackController.SaveAllData(conList[0].Id, 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', true, 'Grade 9',JSON.serialize(formDetails), 'Endline');
        String response2 = EndlineFeedbackController.SaveAllData(con1.Id, 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', true, 'Grade 9', JSON.serialize(formDetails), 'Endline');
        test.stopTest();
        
        //System.assertEquals('Insert', response1);
       // System.assertEquals('Insert', response2);
    }
    @istest
    static void getStudentName_Test(){
        contact stud1 = [Select Id,name,RecordType.Name from Contact  where FirstName='First' and RecordType.Name='CA Student' limit 1];
        Test.startTest();
        Contact c = EndlineFeedbackController.getStudentName(stud1.Id);
        Test.stopTest();    
    }
}