@istest
public class OmrCdm1Form5ClassTest {

    @TestSetup
    static void createData(){
		
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Mumbai';
        sm.Name = 'Mumbai Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'Test';
        insert sm;
        
        State_Govt_Body_Level__c state1 = new State_Govt_Body_Level__c();
        state1.Name='Maharashtra';
        insert state1;

        District_Master__c dist1 = new District_Master__c();
        dist1.Name='Mumbai';
        dist1.State__c=state1.id;
        insert dist1;
       
        City_Master__c city1 = new City_Master__c();
        city1.Name='Mumbai';
        city1.District__c=dist1.id;
        city1.Recommendation_Location__c='Goa';
        insert city1;

        Ward_Master__c ward1 = new Ward_Master__c();
        ward1.Name='R North';
        ward1.City__c=city1.id;
        insert ward1;

        Id schoolRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
                        .get('School').getRecordTypeId();

        Account sch1 = new Account();
        sch1.Name = 'Test School 1';
        sch1.State__c = state1.id;
        sch1.District__c = dist1.id;
        sch1.City__c = city1.id;
        sch1.Ward__c = ward1.id;
        sch1.Medium_Language_of_Instruction__c='English';
        sch1.School_Timing__c='Morning';
        sch1.RecordtypeId=schoolRecordTypeId;
        insert sch1;


        Batch__c btch1 = new Batch__c();
        btch1.Name='Test Batch  01';
        btch1.Preferred_Language__c='English';
        btch1.Grade__c='Grade 9';
        btch1.School_Name__c = sch1.id;
        insert btch1;

        Id contactrecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName()
                        .get('CA Student').getRecordTypeId();

        Contact con1 = new Contact();
        con1.LastName = 'Test Contact 01';
        con1.Batch_Code__c = btch1.id;
        con1.Bar_Code__c = '210000006';
        con1.RecordtypeId=contactrecordTypeId;
        insert con1;

        Id cdm1recordTypeId = Schema.SObjectType.OMR_Assessment__c.getRecordTypeInfosByName()
                        .get('Baseline').getRecordTypeId();

        Id cdm2recordTypeId = Schema.SObjectType.CDM2__c.getRecordTypeInfosByName()
                            .get('Baseline').getRecordTypeId();

        Id cdm3recordTypeId = Schema.SObjectType.Career_Planning__c.getRecordTypeInfosByName()
                             .get('Baseline').getRecordTypeId();

        OMR_Assessment__c cdm1 = new OMR_Assessment__c();
        cdm1.Form_Submitted__c = true;
        cdm1.Created_from_Form__c = false;
        cdm1.RecordtypeId = cdm1recordTypeId;
        cdm1.Student__c = con1.id;
        cdm1.Barcode__c = '1111111111';
        insert cdm1;

        CDM2__c cdm2 = new CDM2__c();
        cdm2.Form_Submitted__c = true;
        cdm2.Created_from_Form__c = false;
        cdm2.RecordtypeId = cdm2recordTypeId;
        cdm2.Student__c = con1.id;
        cdm2.Barcode__c = '2222222222';
        insert cdm2;

        Career_Planning__c cdm3 = new Career_Planning__c();
        cdm3.Form_Submitted__c = true;
        cdm3.Created_from_Form__c = false;
        cdm3.RecordtypeId = cdm3recordTypeId;
        cdm3.Student__c = con1.id;
        cdm3.Barcode__c = '3333333333';
        insert cdm3;
    }

    @istest
    static void fetchStudentForCmd1FormTest(){
        System.debug('contact record type : '+[Select name,RecordType.Name from Contact  where RecordType.Name='CA Student' limit 1]);
        Batch__c qbtch1 = [SELECT id,name FROM Batch__c where Name='Test Batch  01' limit 1];
        System.debug('### Batch : '+qbtch1);
        Test.startTest();
         OmrCdm1Form5Class.getStudentData(qbtch1.id);
        
        OmrCdm1Form5Class.getStudentDataV2(qbtch1.id, 'Grade 9');
        OmrCdm1Form5Class.getStudentDataV2(qbtch1.id, 'Grade 10');
        Test.stopTest();
        
    }
}