@isTest
public class endlineSummaryTest {
	@testsetup
    public static void testData(){
        Account account=new Account();
        account.Name='Shreeram School';
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
		
        List<Batch__c> batchList = new List<Batch__c>{
            new Batch__c(Name = 'ShreeramSchoolBatch1', School_Name__c = account.Id, Preferred_Language__c = 'English'),
            new Batch__c(Name = 'ShreeramSchoolBatch2', School_Name__c = account.Id, Preferred_Language__c = 'English'),
            new Batch__c(Name = 'ShreeramSchoolBatch3', School_Name__c = account.Id, Preferred_Language__c = 'English')
                };
        insert batchList;
        
        RecordType CA_Student_RecordType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Contact' AND Name = 'CA Student'];
        List<Contact> studentList = new List<Contact>{
            new Contact(AccountId = account.Id, FirstName = 'First', LastName = 'Last', Batch_Code__c = batchList[0].Id, 
                        G10_Batch_Code__c = batchList[1].Id, G11_Batch_Code__c = batchList[2].Id, G12_Batch_Code__c = null,
                        Bar_Code__c = 'Test009', Grade_9_Barcode__c = 'Test009', Grade_10_Barcode__c = 'Test010', 
                        Grade_11_Barcode__c = 'Test011', RecordTypeId = CA_Student_RecordType.Id)
                };
        insert studentList;

        Id pffRecordTypeId = Schema.SObjectType.Future_Planning__c	.getRecordTypeInfosByDeveloperName().get('Endline').getRecordTypeId();
        List<Future_Planning__c	> pafList = new List<Future_Planning__c	>{
            new Future_Planning__c(Student__c = studentList[0].Id, Barcode__c = 'Test009', Created_from_Form__c = true, 
                                               Feedback_form_submitted__c = true, Future_Planning_form_submitted__c = true, RecordTypeId = pffRecordTypeId)
        };
        insert pafList;
    }
    
    @isTest
    public static void test_Constructor(){

        test.startTest();
        endlineSummary eS = new endlineSummary();
        test.stopTest();
    }
    
    @isTest
    public static void test_getStudentRecords(){
        List<Contact> conList = [SELECT Id, Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c 
                                 FROM Contact 
                                 WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];

        test.startTest();
        endlineSummary.getStudentRecords(conList[0].Batch_Code__c, 'Grade 9','Form V2');
        endlineSummary.getStudentRecords(conList[0].G10_Batch_Code__c, 'Grade 10','Form V2');
        endlineSummary.getStudentRecords(conList[0].G11_Batch_Code__c, 'Grade 11','Form V2');
        test.stopTest();
    }
}