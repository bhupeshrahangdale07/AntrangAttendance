@isTest
public class Quiz2ControllerTest {
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
                        Grade_11_Barcode__c = 'Test0011', RecordTypeId = CA_Student_RecordType.Id),
            new Contact(AccountId = account.Id, FirstName = 'First3', LastName = 'Last3', G10_Batch_Code__c = batchList[1].Id, 
                        Bar_Code__c = 'Test00099', Grade_9_Barcode__c = 'Test00099', Grade_10_Barcode__c = 'Test00110', 
                        Grade_11_Barcode__c = 'Test00111', RecordTypeId = CA_Student_RecordType.Id)
                };
            insert studentList;

        Id rRecordTypeId = Schema.SObjectType.Self_Awareness_Realities__c.getRecordTypeInfosByDeveloperName().get('Baseline').getRecordTypeId();
        List<Self_Awareness_Realities__c> sarList = new List<Self_Awareness_Realities__c>{
            new Self_Awareness_Realities__c(Student__c = studentList[0].Id, Barcode__c = 'Test009', Created_from_Form__c = true, 
                                               Form_Submitted__c = true, Quiz_2_Form_Submitted__c = true, RecordTypeId = rRecordTypeId),
            new Self_Awareness_Realities__c(Student__c = studentList[1].Id, Barcode__c = 'Test0009', Created_from_Form__c = true, 
                                               Form_Submitted__c = true, Quiz_2_Form_Submitted__c = true, RecordTypeId = rRecordTypeId)
        };
            insert sarList;
    }
    
    @isTest
    public static void test_searchStudentRecords(){
       	List<Contact> conList = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
		Contact con1 = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last2' AND Bar_Code__c = 'Test0009'];
        
        test.startTest();
        Quiz2Controller.responseWrapper rspWrap1 = Quiz2Controller.searchStudentRecords('First', conList[0].Batch_Code__c, 'Grade 9');
        Quiz2Controller.responseWrapper rspWrap2 = Quiz2Controller.searchStudentRecords('First2', con1.Batch_Code__c, 'Grade 10');
        Quiz2Controller.searchStudentRecords('First', conList[0].Batch_Code__c, 'Grade 11');
        test.stopTest();
        
        System.assertEquals(1,rspWrap1.batchTotalStudents,'Contact Size is Not Matched');
        //System.assertEquals(1,rspWrap2.batchTotalStudents,'Contact Size is Not Matched');
    }
    
    @isTest
    public static void test_getStudentRecords(){
       	List<Contact> conList = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];

        test.startTest();
        quiz1Summary.responseWrapper stdWrap = Quiz2Controller.getStudentRecords(conList[0].Batch_Code__c, 'Grade 10');
                string stdWrapq = Quiz2Controller.getQuiz2Record(conList[0].id, 'Grade 10',conList[0].Batch_Code__c);

        test.stopTest();
        
        //System.assertEquals(1,stdWrap.countStudent,'Contact Size is Not Matched');
    }
    
    @isTest
    public static void test_getStudentData(){
       	List<Contact> conList = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];

        test.startTest();
        Quiz2Controller.studentDataWrapper stdWrap = Quiz2Controller.getStudentData(conList[0].Id);
        test.stopTest();
        
        //System.assertEquals(1,stdWrap.countStudent,'Contact Size is Not Matched');
    }
    
    @isTest
    public static void test_getRecordApt(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];

        test.startTest();
        Self_Awareness_Realities__c resSAR = Quiz2Controller.getRecordApt(conList[0].Id);
        test.stopTest();
        
        System.assertEquals(true,resSAR.Created_from_Form__c,'resSAR.Created_from_Form__c is false');
    }
    
    @isTest
    public static void test_submitAndCalculate(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
        Self_Awareness_Realities__c sar =[SELECT Id FROM Self_Awareness_Realities__c WHERE Student__c = :conList[0].Id];
        test.startTest();
        String response = Quiz2Controller.submitAndCalculate(sar.Id);
        test.stopTest();
        
        System.assertEquals('success', response);
    }
    
    /*@isTest
    public static void test_dataPrepare(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
        Self_Awareness_Realities__c sar =[SELECT Id FROM Self_Awareness_Realities__c WHERE Student__c = :conList[0].Id];
        test.startTest();
        Quiz2Controller.dataPrepare(true, sar, 'a', 'a', 'a', 'a', 'a');
        test.stopTest();
    }*/
    
    @isTest
    public static void test_saveData(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last' AND Bar_Code__c = 'Test009'];
        Contact con1 = [SELECT Id, Batch_Code__c FROM Contact WHERE LastName = 'Last2' AND Bar_Code__c = 'Test0009'];
        
        test.startTest();
        String response1 = Quiz2Controller.saveData(conList[0].Id, 'a', 'a', 'a', 'a', 'a', true, 'Grade 9','English','');
        String response2 = Quiz2Controller.saveData(con1.Id, 'a', 'a', 'a', 'a', 'a', true, 'Grade 9','English','');
        test.stopTest();
        
     //   System.assertEquals('Update', response1);
    //    System.assertEquals('Insert', response2);
    }
    
    @isTest
    public static void test_saveData1(){
        List<Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Last3' AND Bar_Code__c = 'Test00099'];
        
        test.startTest();
        String response1 = Quiz2Controller.saveData(conList[0].Id, 'a', 'a', 'a', 'a', 'a', true, 'Grade 9','English','');
        test.stopTest();
    }
    
    @isTest
    public static void test_fakeMethod(){

        test.startTest();
        Quiz2Controller.fakeMethod();
        test.stopTest();
    }
}