@istest
public class ApptitudeControllerTest {
 
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
        
        Question_Bank__c bank = new Question_Bank__c();
        bank.Category1__c = 'Spatial';
        bank.Category__c = 'A';
        bank.Name = 'test';
        insert bank;
        
        Question_Bank__c bank2 = new Question_Bank__c();
        bank2.Category1__c = 'Spatial';
        bank2.Category__c = 'A';
        bank2.Name = 'test';
        insert bank2;
        
        Question_Bank__c bank3 = new Question_Bank__c();
        bank3.Category1__c = 'Spatial';
        bank3.Category__c = 'A';
        bank3.Name = 'test';
        insert bank3;
        
        Question_Bank__c bank4 = new Question_Bank__c();
        bank4.Category1__c = 'Spatial';
        bank4.Category__c = 'A';
        bank4.Name = 'test';
        insert bank4;
        
        Question_Bank__c bank5 = new Question_Bank__c();
        bank5.Category1__c = 'Spatial';
        bank5.Category__c = 'A';
        bank5.Name = 'test';
        insert bank5;
        
        Question_Bank__c bank6 = new Question_Bank__c();
        bank6.Category1__c = 'Spatial';
        bank6.Category__c = 'A';
        bank6.Name = 'test';
        insert bank6;
        
        Question_Bank__c bank7 = new Question_Bank__c();
        bank7.Category1__c = 'Spatial';
        bank7.Category__c = 'A';
        bank7.Name = 'test';
        insert bank7;
        
        Question_Bank__c bank8 = new Question_Bank__c();
        bank8.Category1__c = 'Spatial';
        bank8.Category__c = 'A';
        bank8.Name = 'test';
        insert bank8;
        
        Question_Bank__c bank9 = new Question_Bank__c();
        bank9.Category1__c = 'Numerical';
        bank9.Category__c = 'A';
        bank9.Name = 'test';
        insert bank9;
        
        Question_Bank__c bank10 = new Question_Bank__c();
        bank10.Category1__c = 'Numerical';
        bank10.Category__c = 'A';
        bank10.Name = 'test';
        insert bank10;
        
        Question_Bank__c bank11 = new Question_Bank__c();
        bank11.Category1__c = 'Numerical';
        bank11.Category__c = 'A';
        bank11.Name = 'test';
        insert bank11;
        
        Question_Bank__c bank12 = new Question_Bank__c();
        bank12.Category1__c = 'Numerical';
        bank12.Category__c = 'A';
        bank12.Name = 'test';
        insert bank12;
        
        Question_Bank__c bank13 = new Question_Bank__c();
        bank13.Category1__c = 'Numerical';
        bank13.Category__c = 'A';
        bank13.Name = 'test';
        insert bank13;
        
        Question_Bank__c bank14 = new Question_Bank__c();
        bank14.Category1__c = 'Numerical';
        bank14.Category__c = 'A';
        bank14.Name = 'test';
        insert bank14;
        
        Question_Bank__c bank15 = new Question_Bank__c();
        bank15.Category1__c = 'Numerical';
        bank15.Category__c = 'A';
        bank15.Name = 'test';
        insert bank15;
        
        Question_Bank__c bank16 = new Question_Bank__c();
        bank16.Category1__c = 'Numerical';
        bank16.Category__c = 'A';
        bank16.Name = 'test';
        insert bank16;
        
        Question_Bank__c bank17 = new Question_Bank__c();
        bank17.Category1__c = 'Abstract';
        bank17.Category__c = 'A';
        bank17.Name = 'test';
        insert bank17;
        
        Question_Bank__c bank18 = new Question_Bank__c();
        bank18.Category1__c = 'Abstract';
        bank18.Category__c = 'A';
        bank18.Name = 'test';
        insert bank18;
        
        Question_Bank__c bank19 = new Question_Bank__c();
        bank19.Category1__c = 'Abstract';
        bank19.Category__c = 'A';
        bank19.Name = 'test';
        insert bank19;
        
        Question_Bank__c bank20 = new Question_Bank__c();
        bank20.Category1__c = 'Abstract';
        bank20.Category__c = 'A';
        bank20.Name = 'test';
        insert bank20;
        
        Question_Bank__c bank21 = new Question_Bank__c();
        bank21.Category1__c = 'Abstract';
        bank21.Category__c = 'A';
        bank21.Name = 'test';
        insert bank21;
        
        Question_Bank__c bank22 = new Question_Bank__c();
        bank22.Category1__c = 'Abstract';
        bank22.Category__c = 'A';
        bank22.Name = 'test';
        insert bank22;
        
        Question_Bank__c bank23 = new Question_Bank__c();
        bank23.Category1__c = 'Abstract';
        bank23.Category__c = 'A';
        bank23.Name = 'test';
        insert bank23;
        
        Question_Bank__c bank24 = new Question_Bank__c();
        bank24.Category1__c = 'Abstract';
        bank24.Category__c = 'A';
        bank24.Name = 'test';
        insert bank24;
        
        Question_Bank__c bank25 = new Question_Bank__c();
        bank25.Category1__c = 'Creative';
        bank25.Category__c = 'A';
        bank25.Name = 'test';
        insert bank25;
        
        Question_Bank__c bank26 = new Question_Bank__c();
        bank26.Category1__c = 'Creative';
        bank26.Category__c = 'A';
        bank26.Name = 'test';
        insert bank26;
        
        Question_Bank__c bank27 = new Question_Bank__c();
        bank27.Category1__c = 'Creative';
        bank27.Category__c = 'A';
        bank27.Name = 'test';
        insert bank27;
        
        Question_Bank__c bank28 = new Question_Bank__c();
        bank28.Category1__c = 'Creative';
        bank28.Category__c = 'A';
        bank28.Name = 'test';
        insert bank28;
        
        Question_Bank__c bank29 = new Question_Bank__c();
        bank29.Category1__c = 'Creative';
        bank29.Category__c = 'A';
        bank29.Name = 'test';
        insert bank29;
        
        Question_Bank__c bank30 = new Question_Bank__c();
        bank30.Category1__c = 'Creative';
        bank30.Category__c = 'A';
        bank30.Name = 'test';
        insert bank30;
        
        Question_Bank__c bank31 = new Question_Bank__c();
        bank31.Category1__c = 'Creative';
        bank31.Category__c = 'A';
        bank31.Name = 'test';
        insert bank31;
        
        Question_Bank__c bank32 = new Question_Bank__c();
        bank32.Category1__c = 'Creative';
        bank32.Category__c = 'A';
        bank32.Name = 'test';
        insert bank32;
        
        Question_Bank__c bank33 = new Question_Bank__c();
        bank33.Category1__c = 'Mechanical';
        bank33.Category__c = 'A';
        bank33.Name = 'test';
        insert bank33;
        
        Question_Bank__c bank34 = new Question_Bank__c();
        bank34.Category1__c = 'Mechanical';
        bank34.Category__c = 'A';
        bank34.Name = 'test';
        insert bank34;
        
        Question_Bank__c bank35 = new Question_Bank__c();
        bank35.Category1__c = 'Mechanical';
        bank35.Category__c = 'A';
        bank35.Name = 'test';
        insert bank35;
        
        Question_Bank__c bank36 = new Question_Bank__c();
        bank36.Category1__c = 'Mechanical';
        bank36.Category__c = 'A';
        bank36.Name = 'test';
        insert bank36;
        
        Question_Bank__c bank37 = new Question_Bank__c();
        bank37.Category1__c = 'Mechanical';
        bank37.Category__c = 'A';
        bank37.Name = 'test';
        insert bank37;
        
        Question_Bank__c bank38 = new Question_Bank__c();
        bank38.Category1__c = 'Mechanical';
        bank38.Category__c = 'A';
        bank38.Name = 'test';
        insert bank38;
        
        Question_Bank__c bank39 = new Question_Bank__c();
        bank39.Category1__c = 'Mechanical';
        bank39.Category__c = 'A';
        bank39.Name = 'test';
        insert bank39;
        
        Question_Bank__c bank40 = new Question_Bank__c();
        bank40.Category1__c = 'Mechanical';
        bank40.Category__c = 'A';
        bank40.Name = 'test';
        insert bank40;
        
        Question_Bank__c bank41 = new Question_Bank__c();
        bank41.Category1__c = 'Verbal';
        bank41.Category__c = 'A';
        bank41.Name = 'test';
        insert bank41;
        
        Question_Bank__c bank42 = new Question_Bank__c();
        bank42.Category1__c = 'Verbal';
        bank42.Category__c = 'A';
        bank42.Name = 'test';
        insert bank42;
        
        Question_Bank__c bank43 = new Question_Bank__c();
        bank43.Category1__c = 'Verbal';
        bank43.Category__c = 'A';
        bank43.Name = 'test';
        insert bank43;
        
        Question_Bank__c bank44 = new Question_Bank__c();
        bank44.Category1__c = 'Verbal';
        bank44.Category__c = 'A';
        bank44.Name = 'test';
        insert bank44;
        
        Question_Bank__c bank45 = new Question_Bank__c();
        bank45.Category1__c = 'Verbal';
        bank45.Category__c = 'A';
        bank45.Name = 'test';
        insert bank45;
        
        Question_Bank__c bank46 = new Question_Bank__c();
        bank46.Category1__c = 'Verbal';
        bank46.Category__c = 'A';
        bank46.Name = 'test';
        insert bank46;
        
        Question_Bank__c bank47 = new Question_Bank__c();
        bank47.Category1__c = 'Verbal';
        bank47.Category__c = 'A';
        bank47.Name = 'test';
        insert bank47;
        
        Question_Bank__c bank48 = new Question_Bank__c();
        bank48.Category1__c = 'Verbal';
        bank48.Category__c = 'A';
        bank48.Name = 'test';
        insert bank48;

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
        saf1.Aptitude_1__c = '*';
        saf1.Aptitude_2__c = '*';
        saf1.Aptitude_3__c = 'Verbal';
        
        saf1.Aptitude_1__c =  ''; 
        saf1.Aptitude_2__c =  '';  
        saf1.Aptitude_3__c =  '*'; 

        
        saf1.Spatial_Ability_Q_1__c =  ''; 
        saf1.Spatial_Ability_Q_2__c =  ''; 
        saf1.Spatial_Ability_Q_3__c =  ''; 
        saf1.Spatial_Ability_Q_4__c =  '';  
        saf1.Spatial_Ability_Q_5__c =  '';  
        saf1.Spatial_Ability_Q_6__c =  '';  
        saf1.Spatial_Ability_Q_7__c =  '';
        saf1.Spatial_Ability_Q_8__c =  '*'; 
        
        saf1.Numerical_1__c =  '';     
        saf1.Numerical_2__c =  '';  
        saf1.Numerical_3__c =  '';  
        saf1.Numerical_4__c =  ''; 
        saf1.Numerical_5__c =  ''; 
        saf1.Numerical_6__c =  ''; 
        saf1.Numerical_7__c =  ''; 
        saf1.Numerical_8__c =  '*';  
        
        saf1.Aptitude_1_Selected_By_Student__c =  '';
        saf1.Aptitude_2_Selected_By_Student__c =  '';   
        saf1.Aptitude_3_Selected_By_Student__c =  '*';  
        
        saf1.Mechanical_1__c =  '';  
        saf1.Mechanical_2__c =  '';   
        saf1.Mechanical_3__c =  '';   
        saf1.Mechanical_4__c =  '';   
        saf1.Mechanical_5__c =  '';  
        saf1.Mechanical_6__c =  '';    
        saf1.Mechanical_7__c =  '';  
        saf1.Mechanical_8__c =  '*';  
        
        saf1.Abstract_Reasoning_Q_1__c =  ''; 
        saf1.Abstract_Reasoning_Q_2__c =  '';  
        saf1.Abstract_Reasoning_Q_3__c =  ''; 
        saf1.Abstract_Reasoning_Q_4__c =  '';  
        saf1.Abstract_Reasoning_Q_5__c =  '';    
        saf1.Abstract_Reasoning_Q_6__c =  '';     
        saf1.Abstract_Reasoning_Q_7__c =  '';   
        saf1.Abstract_Reasoning_Q_8__c =  '*';   
        
        saf1.Verbal_1__c =  '';   
        saf1.Verbal_2__c =  ''; 
        saf1.Verbal_3__c =  '';   
        saf1.Verbal_4__c =  '';    
        saf1.Verbal_5__c =  '';   
        saf1.Verbal_6__c =  '';   
        saf1.Verbal_7__c =  '';  
        saf1.Verbal_8__c =  '*'; 
        
        saf1.Creative_1__c =  '';   
        saf1.Creative_2__c =  '';    
        saf1.Creative_3__c =  '';   
        saf1.Creative_4__c =  '';   
        saf1.Creative_5__c =  '';  
        saf1.Creative_6__c =  '';   
        saf1.Creative_7__c =  '';   
        saf1.Creative_8__c  =  '*';   
    
        saf1.Apptitude_Form_Submitted__c = true;
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
            ApptitudeController.responseWrapper rspWrap =  ApptitudeController.searchStudentRecords('Test',qbtch1.id,'Grade 9');
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
            ApptitudeController.studentDataWrapper stdWrap =  ApptitudeController.getStudentData(qbtch1.id);
        Test.stopTest();
        System.debug('### stdWrap : '+stdWrap);
        System.debug('### stdWrap countStudent: '+stdWrap.countStudent);
        System.assertEquals(1,stdWrap.countStudent,'Contact Size Not Matched');
    }
    
    @istest
    static void getRecordAptTest(){
        contact stud1 = [Select name,RecordType.Name from Contact  where Name='Test Contact 01' and RecordType.Name='CA Student' limit 1];
        Test.startTest();
        	List<Batch__c> batches = [
                SELECT Id, Name, School_Name__r.Name, Grade__c, Academic_Year__c, Batch_Number__c
                FROM Batch__c LIMIT 1];
            Self_Awareness_and_Feedback__c resSAF1 =  ApptitudeController.getRecordApt(stud1.id,batches[0].id);
        Test.stopTest();
       
    }


    //---------------------------------------- Save Data Update Scenarios -----------------------------------//

    @istest
    static void saveDataFlagTrueScenario1(){
        contact stud1 = [Select name,RecordType.Name from Contact  where Name='Test Contact 01' and RecordType.Name='CA Student' limit 1];
        Test.startTest();
            String response =  ApptitudeController.saveData(stud1.id,'Verbal','Abstract','Spatial',true, 'Form v2', 'English');
        Test.stopTest();
        System.debug('### response : '+response);
        
        Self_Awareness_and_Feedback__c upSAF1 = [select id,Created_from_Form__c, Aptitude_1__c, Aptitude_2__c, Aptitude_3__c, Student__c,Apptitude_Form_Submitted__c from  Self_Awareness_and_Feedback__c
                        where Student__c =: stud1.id and Created_from_Form__c = true and RecordType.Name='Baseline' limit 1];
        System.assertEquals('Verbal',upSAF1.Aptitude_1__c,'Aptitude 1 not matched');
        System.assertEquals('Abstract',upSAF1.Aptitude_2__c,'Aptitude 2 not matched');
        System.assertEquals('Spatial',upSAF1.Aptitude_3__c,'Aptitude 3 not matched');        
        System.assertEquals(true,upSAF1.Apptitude_Form_Submitted__c,'upSAF1.Apptitude_Form_Submitted__c not true');        
    }

    @istest
    static void saveDataFlagTrueScenario2(){
        contact stud1 = [Select name,RecordType.Name from Contact  where Name='Test Contact 01' and RecordType.Name='CA Student' limit 1];
        Test.startTest();
            String response =  ApptitudeController.saveData(stud1.id,'NoAnswer','Abstract','Spatial',true, 'Form v2', 'English');
        Test.stopTest();
        System.debug('### response : '+response);
        
        Self_Awareness_and_Feedback__c upSAF1 = [select id,Created_from_Form__c, Aptitude_1__c, Aptitude_2__c, Aptitude_3__c, Student__c,Apptitude_Form_Submitted__c from  Self_Awareness_and_Feedback__c
                        where Student__c =: stud1.id and Created_from_Form__c = true and RecordType.Name='Baseline' limit 1];
        System.assertEquals(null,upSAF1.Aptitude_1__c,'Aptitude 1 not blank');
        //System.assertEquals(null,upSAF1.Aptitude_2__c,'Aptitude 2 not blank');
        //System.assertEquals(null,upSAF1.Aptitude_3__c,'Aptitude 3 not blank');   
        System.assertEquals(true,upSAF1.Apptitude_Form_Submitted__c,'upSAF1.Apptitude_Form_Submitted__c not true');     
    }


    @istest
    static void saveDataFlagFalseScenario1(){
        contact stud1 = [Select name,RecordType.Name from Contact  where Name='Test Contact 01' and RecordType.Name='CA Student' limit 1];
        Test.startTest();
            String response =  ApptitudeController.saveData(stud1.id,'Verbal','Abstract','Spatial',false, 'Form v2', 'English');
        Test.stopTest();
        System.debug('### response : '+response);
        
        Self_Awareness_and_Feedback__c upSAF1 = [select id,Created_from_Form__c, Aptitude_1__c, Aptitude_2__c, Aptitude_3__c, Student__c,Apptitude_Form_Submitted__c from  Self_Awareness_and_Feedback__c
                        where Student__c =: stud1.id and Created_from_Form__c = true and RecordType.Name='Baseline' limit 1];
        System.assertEquals('Verbal',upSAF1.Aptitude_1__c,'Aptitude 1 not matched');
        System.assertEquals('Abstract',upSAF1.Aptitude_2__c,'Aptitude 2 not matched');
        System.assertEquals('Spatial',upSAF1.Aptitude_3__c,'Aptitude 3 not matched');                
    }

    @istest
    static void saveDataFlagFalseScenario2(){
        contact stud1 = [Select name,RecordType.Name from Contact  where Name='Test Contact 01' and RecordType.Name='CA Student' limit 1];
        Test.startTest();
            String response =  ApptitudeController.saveData(stud1.id,'NoAnswer','NoAnswer','NoAnswer',false, 'Form v2', 'English');
        Test.stopTest();
        System.debug('### saveDataFlagFalseScenario2 response : '+response);
        
        Self_Awareness_and_Feedback__c upSAF1 = [select id,Created_from_Form__c, Aptitude_1__c, Aptitude_2__c, Aptitude_3__c, Student__c,Apptitude_Form_Submitted__c from  Self_Awareness_and_Feedback__c
                        where Student__c =: stud1.id and Created_from_Form__c = true and RecordType.Name='Baseline' limit 1];
        System.assertEquals(null,upSAF1.Aptitude_1__c,'Aptitude 1 not blank');
        System.assertEquals(null,upSAF1.Aptitude_2__c,'Aptitude 2 not blank');
        System.assertEquals(null,upSAF1.Aptitude_3__c,'Aptitude 3 not blank');        
    }




     //---------------------------------------- Save Data Insert Scenarios -----------------------------------//
     @istest
     static void saveDataInsertScenario1(){
         contact stud1 = [Select name,RecordType.Name from Contact  where Name='Test Contact 01' and RecordType.Name='CA Student' limit 1];
         Self_Awareness_and_Feedback__c qSAF1 = [select id,Created_from_Form__c, Aptitude_1__c, Aptitude_2__c, Aptitude_3__c, Student__c,Apptitude_Form_Submitted__c from  Self_Awareness_and_Feedback__c
                         where Student__c =: stud1.id and Created_from_Form__c = true and RecordType.Name='Baseline' limit 1];        
         Test.startTest();
            Delete qSAF1;
            String response =  ApptitudeController.saveData(stud1.id,'Creative','Numerical','Introvert',true, 'Form v2', 'English');
         Test.stopTest();
         System.debug('### saveDataInsertScenario1 response : '+response);
         
         Self_Awareness_and_Feedback__c insSAF1 = [select id,Created_from_Form__c, Aptitude_1__c, Aptitude_2__c, Aptitude_3__c, Student__c,Apptitude_Form_Submitted__c from  Self_Awareness_and_Feedback__c
                         where Student__c =: stud1.id and Created_from_Form__c = true and RecordType.Name='Baseline' limit 1];
         System.assertEquals('Creative',insSAF1.Aptitude_1__c,'Aptitude 1 not blank');
         System.assertEquals('Numerical',insSAF1.Aptitude_2__c,'Aptitude 2 not blank');
         System.assertEquals('Introvert',insSAF1.Aptitude_3__c,'Aptitude 3 not blank');        
     }
        
    @istest
    static void saveDataFlagTrueScenarioV1(){
        contact stud1 = [Select name,RecordType.Name,Batch_Code__c from Contact  where Name='Test Contact 01' and RecordType.Name='CA Student' limit 1];
        Test.startTest();
       
        List<Map<String, Object>> tetList = new List<Map<String, Object>>();
        for( integer i = 0; i<48; i++){
            Map<String, Object> tet = new Map<String, Object>();
            tet.put('question', 1);
            tet.put('answer', '*');
            tetList.add(tet);
        } 
        List<Batch__c> batches = new List<Batch__c>([
            SELECT Id, Name, School_Name__r.Name, Grade__c, Academic_Year__c, Batch_Number__c
            FROM Batch__c LIMIT 1]);
            String response =  ApptitudeController.saveDataForFormV2(stud1.id, tetList, true,'Grade 9', 'Form v2', 'English',batches[0].id);
         String response1 =  ApptitudeController.getApptitudeRecord(stud1.id, 'Grade 9', stud1.Batch_Code__c);
        Test.stopTest();      
    }
    
    @istest
    static void saveDataFlagTrueScenarioV2(){
        contact stud1 = [Select name,RecordType.Name from Contact  where Name='Test Contact 01' and RecordType.Name='CA Student' limit 1];
        Test.startTest();
        delete [select id from  Self_Awareness_and_Feedback__c where Student__c =: stud1.Id and Created_from_Form__c = true and RecordType.Name='Baseline'];
        
        List<Map<String, Object>> tetList = new List<Map<String, Object>>();
        for( integer i = 0; i<48; i++){
            Map<String, Object> tet = new Map<String, Object>();
            tet.put('question', 1);
            tet.put('answer', '*');
            tetList.add(tet);
        } 
        List<Batch__c> batches = [
            SELECT Id, Name, School_Name__r.Name, Grade__c, Academic_Year__c, Batch_Number__c
            FROM Batch__c ];
            String response =  ApptitudeController.saveDataForFormV2(stud1.id, tetList, true,'Grade 9', 'Form v2', 'English',batches[0].id);
        Test.stopTest();
    }

	@istest
    static void getStudentRecordsTest(){
        Batch__c qbtch1 = [SELECT id,name FROM Batch__c where Name='Test Batch  01' limit 1];
        System.debug('### Batch : '+qbtch1);
        Test.startTest();
            ApptitudeController.responseWrappper rspWrap =  ApptitudeController.getStudentRecords(qbtch1.id,'Grade 9');
        Test.stopTest();
        System.debug('### rspWrap : '+rspWrap);
        System.debug('### rspWrap batchTotalStudents: '+rspWrap.batchTotalStudents);
        System.assertEquals(1,rspWrap.batchTotalStudents,'Contact Size Not Matched');
        
    }
    @istest
    static void getStudentName_Test(){
        contact stud1 = [Select Id,name,RecordType.Name from Contact  where Name='Test Contact 01' and RecordType.Name='CA Student' limit 1];
        Test.startTest();
        Contact c = ApptitudeController.getStudentName(stud1.Id);
        Test.stopTest();    
    }
    @istest
    static void aptitudeFormType_Test(){
        Account schId = [Select Id, Name from Account Where Name='Test School 1' and RecordType.Name='School' limit 1];
        Test.startTest();
        District_Master__c dm = ApptitudeController.aptitudeFormType(schId.Id);
        Test.stopTest();    
    }
}