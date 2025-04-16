@isTest
public class BaselineAssessmentControllerTest {
	@testsetup
    public static void testData(){
        AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();   
        setting.Next_Academic_Year__c = 2022;
        insert setting;
        
        State_Govt_Body_Level__c st = new State_Govt_Body_Level__c();
        st.Name = 'test';
        st.State_Code__c = 1;
        insert st;
        
        Account account=new Account();
        account.Name='Shreeram School';
        account.State__c = st.id;
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
        student.G12_Batch_Code__c = b.Id;
        student.Grade_9_Barcode__c = '2201000001';
        student.Grade_10_Barcode__c = '2201000002';
        student.Grade_11_Barcode__c = '2201000003';
        student.Bar_Code__c = '2201000001';
        Insert student;

        Id rRecordTypeId = Schema.SObjectType.Self_Awareness_Realities__c.getRecordTypeInfosByDeveloperName().get('Baseline').getRecordTypeId();
        Self_Awareness_Realities__c saaf = new Self_Awareness_Realities__c(RecordTypeId = rRecordTypeId);
        saaf.Student__c = student.Id;
        saaf.Barcode__c = 'Test009';
        saaf.Created_from_Form__c = true;
        saaf.Form_Submitted__c = true;
        saaf.Reality_Form_Submitted__c = true;
        Insert saaf;
        
        Id cdm1RecordTypeId = Schema.SObjectType.OMR_Assessment__c.getRecordTypeInfosByDeveloperName().get('Baseline').getRecordTypeId();
        OMR_Assessment__c cdm1 = new OMR_Assessment__c(RecordTypeId = cdm1RecordTypeId);
        cdm1.Student__c = student.Id;
        cdm1.Barcode__c = 'Test009';
        cdm1.Created_from_Form__c = true;
        cdm1.Form_Submitted__c = true;
        Insert cdm1;
        
        Id cdm2RecordTypeId = Schema.SObjectType.CDM2__c.getRecordTypeInfosByDeveloperName().get('Baseline').getRecordTypeId();
        CDM2__c cdm2 = new CDM2__c(RecordTypeId = cdm2RecordTypeId);
        cdm2.Student__c = student.Id;
        cdm2.Barcode__c = 'Test009';
        cdm2.Created_from_Form__c = true;
        cdm2.Form_Submitted__c = true;
        Insert cdm2;
    }
    
    @isTest
    public static void test_getStudentDataV2(){
        Contact con = [select id, Batch_Code__c from contact limit 1];
        
        test.startTest();
        
        BaselineAssessmentController.getStudentDataV2(con.Batch_Code__c, 'Grade 9', 'MPF');
        BaselineAssessmentController.getStudentDataV2(con.Batch_Code__c, 'Grade 10', 'CP');
        BaselineAssessmentController.getStudentDataV2(con.Batch_Code__c, 'Grade 11', 'CS');
        BaselineAssessmentController.getStudentDataV2(con.Batch_Code__c, 'Grade 12', 'PFF');
        BaselineAssessmentController.getStudentDataV2(con.Batch_Code__c, 'Grade 12', 'CDM2');
        BaselineAssessmentController.getStudentDataV2(con.Batch_Code__c, 'Grade 12', 'CDM1');
        
        BaselineAssessmentController.getBaselineRecord(con.id, 'Grade 9','MPF',con.Batch_Code__c);
        BaselineAssessmentController.getBaselineRecord(con.id,'Grade 10', 'CP',con.Batch_Code__c);
        BaselineAssessmentController.getBaselineRecord(con.id,'Grade 11', 'CS',con.Batch_Code__c);
        BaselineAssessmentController.getBaselineRecord(con.id,'Grade 12', 'PFF',con.Batch_Code__c);
        BaselineAssessmentController.getBaselineRecord(con.id,'Grade 12', 'CDM2',con.Batch_Code__c);
        BaselineAssessmentController.getBaselineRecord(con.id,'Grade 12', 'CDM1',con.Batch_Code__c);
        
        test.stopTest();
    }
    
    
}