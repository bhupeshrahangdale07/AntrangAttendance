@istest
public class InterestDetailsHandlerTest {
    @TestSetup
    static void createData(){
		 
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Mumbai';
        sm.Name = 'Mumbai Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'description';
        insert sm;
                
        State_Govt_Body_Level__c state1 = new State_Govt_Body_Level__c();
        state1.Name='GOA';
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
        
        Id saf1recordTypeId = Schema.SObjectType.Self_Awareness_and_Feedback__c.getRecordTypeInfosByName()
                        .get('Baseline').getRecordTypeId();

        Self_Awareness_and_Feedback__c saf1 = new Self_Awareness_and_Feedback__c();
        saf1.Created_from_Form__c = true;
        saf1.Interest_1__c = 'Artistic';
        saf1.Interest_2__c = 'Conventional';
        saf1.Interest_3__c = 'Creative';
        saf1.Interest_Form_Submitted__c = true;
        saf1.Form_Submitted__c = false;
        saf1.Student__c = con1.id;
        insert saf1;


        //Extra Record for Code Coverage

        // Batch__c btch2 = new Batch__c();
        // btch2.Name='Test Batch  02';
        // btch2.Preferred_Language__c='English';
        // btch2.Grade__c='Grade 10';
        // btch2.School_Name__c = sch1.id;
        // insert btch2;

        // Contact con2 = new Contact();
        // con2.LastName = 'Test Contact 02';
        // con2.Batch_Code__c = btch2.id;
        // con2.Bar_Code__c = '210000010';
        // con2.RecordtypeId=contactrecordTypeId;
        // insert con2;

        // Batch__c btch3 = new Batch__c();
        // btch3.Name='Test Batch  03';
        // btch3.Preferred_Language__c='English';
        // btch3.Grade__c='Grade 11';
        // btch3.School_Name__c = sch1.id;
        // insert btch3;
        
        // Contact con3 = new Contact();
        // con3.LastName = 'Test Contact 03';
        // con3.Batch_Code__c = btch3.id;
        // con3.Bar_Code__c = '210000011';
        // con3.RecordtypeId=contactrecordTypeId;
        // insert con3;

    }

    @istest
    static void searchStudentRecordsTest(){
        Batch__c qbtch1 = [SELECT id,name FROM Batch__c where Name='Test Batch  01' limit 1];
        System.debug('### Batch : '+qbtch1);
        Test.startTest();
            InterestDetailsHandler.responseWrapper rspWrap =  InterestDetailsHandler.searchStudentRecords('Test',qbtch1.id,'Grade 9');
        Test.stopTest();
        System.debug('### rspWrap : '+rspWrap);
        System.debug('### rspWrap batchTotalStudents: '+rspWrap.batchTotalStudents);
        System.assertEquals(1,rspWrap.batchTotalStudents,'Contact Size Not Matched');
        
    }
	   
    @istest
    static void getStudentDataTest(){
        Batch__c qbtch1 = [SELECT id,name FROM Batch__c where Name='Test Batch  01' limit 1];
        System.debug('### Batch : '+qbtch1);
        Test.startTest();
            InterestDetailsHandler.studentDataWrapper stdWrap =  InterestDetailsHandler.getStudentData(qbtch1.id);
        Test.stopTest();
        System.debug('### stdWrap : '+stdWrap);
        System.debug('### stdWrap countStudent: '+stdWrap.countStudent);
        System.assertEquals(1,stdWrap.countStudent,'Contact Size Not Matched');
    }
    
     
    @istest
    static void getRecordAptTest(){
        contact stud1 = [Select name,RecordType.Name, Batch_Code__c from Contact  where Name='Test Contact 01' and RecordType.Name='CA Student' limit 1];
        Test.startTest();
            Self_Awareness_and_Feedback__c resSAF1 =  InterestDetailsHandler.getRecordApt(stud1.Batch_Code__c, stud1.id);
        Test.stopTest();
        System.debug('### resSAF1 : '+resSAF1);
        System.debug('### resSAF1 Created_from_Form__c: '+resSAF1.Created_from_Form__c);
        //System.assertEquals(true,resSAF1.Created_from_Form__c,'resSAF1.Created_from_Form__c is not true');
    }

    
    //---------------------------------------- Save Data Update Scenarios ------------------------------------//

    @istest
    static void saveDataFlagTrueScenario1(){
        contact stud1 = [Select name,RecordType.Name, Batch_Code__c from Contact  where Name='Test Contact 01' and RecordType.Name='CA Student' limit 1];
        Test.startTest();
            String response =  InterestDetailsHandler.saveData(stud1.Batch_Code__c, stud1.id,'Investigative','NoAnswer','Realistic',true,'Grade 9','Form v2', 'English');
        Test.stopTest();
        System.debug('### response : '+response);
        
        Self_Awareness_and_Feedback__c upSAF1 = [select id,Created_from_Form__c, Interest_1__c, Interest_2__c, Interest_3__c, Student__c,Interest_Form_Submitted__c from  Self_Awareness_and_Feedback__c
                        where Student__c =: stud1.id and Created_from_Form__c = true and RecordType.Name='Baseline' limit 1];
        // System.assertEquals('Investigative',upSAF1.Interest_1__c,'Aptitude 1 not matched');
        // System.assertEquals(null,upSAF1.Interest_2__c,'Aptitude 2 not matched');
        // System.assertEquals('Realistic',upSAF1.Interest_3__c,'Aptitude 3 not matched');        
        // System.assertEquals(true,upSAF1.Interest_Form_Submitted__c,'upSAF1.Apptitude_Form_Submitted__c not true');        
    }

     //---------------------------------------- Save Data Insert Scenarios -----------------------------------//
     @istest
     static void saveDataInsertScenario1(){
        contact stud1 = [Select name,RecordType.Name from Contact  where Name='Test Contact 01' and RecordType.Name='CA Student' limit 1];
        Self_Awareness_and_Feedback__c qSAF1 = [select id,Created_from_Form__c, Interest_1__c, Interest_2__c, Interest_3__c, Student__c,Interest_Form_Submitted__c from  Self_Awareness_and_Feedback__c
                    where Student__c =: stud1.id and Created_from_Form__c = true and RecordType.Name='Baseline' limit 1];        
        Test.startTest();
        Delete qSAF1;
        String response =  InterestDetailsHandler.saveData('', stud1.id,'Enterprising','Artistic','Investigative',true,'Grade 9','Form v2', 'English');
        Test.stopTest();
        System.debug('### saveDataInsertScenario1 response : '+response);
        
        Self_Awareness_and_Feedback__c upSAF1 = [select id,Created_from_Form__c, Interest_1__c, Interest_2__c, Interest_3__c, Student__c,Interest_Form_Submitted__c from  Self_Awareness_and_Feedback__c
                        where Student__c =: stud1.id and Created_from_Form__c = true and RecordType.Name='Baseline' limit 1];
        System.assertEquals('Enterprising',upSAF1.Interest_1__c,'Aptitude 1 not matched');
        System.assertEquals('Artistic',upSAF1.Interest_2__c,'Aptitude 2 not matched');
        System.assertEquals('Investigative',upSAF1.Interest_3__c,'Aptitude 3 not matched');           
     }
    
    @istest
    static void saveDataFlagTrueScenarioV1(){
        contact stud1 = [Select name,RecordType.Name from Contact  where Name='Test Contact 01' and RecordType.Name='CA Student' limit 1];
        Test.startTest();
        //(String studentId, List<Map<String, Object>> answerSet,boolean saveFlag, string grade, string typ, string lng, string interest1, string interest2, string interest3)
        
        List<Map<String, Object>> tetList = new List<Map<String, Object>>();
        for( integer i = 0; i<= 48; i++){
            Map<String, Object> tet = new Map<String, Object>();
            tet.put('question', 1);
            tet.put('answer', '*');
            tetList.add(tet);
        } 
        String response =  InterestDetailsHandler.saveDataForFormV2('', stud1.id, tetList, true,'Grade 9', 'Form V2', 'English', '', '', '');
        Test.stopTest();    
    }
   	
     @istest
     static void getStudentName_Test(){
        contact stud1 = [Select Id,name,RecordType.Name from Contact  where Name='Test Contact 01' and RecordType.Name='CA Student' limit 1];
        Test.startTest();
        Contact c = InterestDetailsHandler.getStudentName(stud1.Id);
        Test.stopTest();    
    }
}