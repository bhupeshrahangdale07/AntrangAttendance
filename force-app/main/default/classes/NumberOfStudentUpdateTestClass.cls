/* Getting the code coverage for NumberOfStudentUpdate trigger  */
@isTest(seealldata=false)
public class NumberOfStudentUpdateTestClass {
    
    @testsetup
    public static void datasetup(){
        
        List<CareerAware_Next_Step_Mapping__c> lstCareerAwareStepMapping = new List<CareerAware_Next_Step_Mapping__c>();
        CareerAware_Next_Step_Mapping__c mapping = new CareerAware_Next_Step_Mapping__c();
        mapping.Name = 'Accountant - HSC-Science';
        mapping.Aspiration__c = 'Accountant';
        mapping.Step_1__c  = 'HSC-Science';
        lstCareerAwareStepMapping.add(mapping);
        
        CareerAware_Next_Step_Mapping__c mapping1 = new CareerAware_Next_Step_Mapping__c();
        mapping1.Name = 'Accountant - Other';
        mapping1.Aspiration__c = 'Accountant';
        mapping1.Step_1__c  = 'Other';
        lstCareerAwareStepMapping.add(mapping1);
        
        CareerAware_Next_Step_Mapping__c mapping2 = new CareerAware_Next_Step_Mapping__c();
        mapping2.Name = 'Accountant - Complete Class 10';
        mapping2.Aspiration__c = 'Accountant';
        mapping2.Step_1__c  = 'Complete Class 10';
        lstCareerAwareStepMapping.add(mapping2);
        
        CareerAware_Next_Step_Mapping__c mapping3 = new CareerAware_Next_Step_Mapping__c();
        mapping3.Name = 'Accountant - I do not know';
        mapping3.Aspiration__c = 'Accountant';
        mapping3.Step_1__c  = 'I do not know';
        lstCareerAwareStepMapping.add(mapping3);
        
        Insert lstCareerAwareStepMapping;
        Career_Aware_FUP_Aspiration_mapping__c CAfup = new Career_Aware_FUP_Aspiration_mapping__c();
        CAfup.name ='Test';
        CAfup.FUP_Aspiration__c ='Accountant';
        CAfup.Aspiration_via_conf_call__c ='Accountant';
        insert CAfup;
    }
    
    @isTest
    public static void checkMappingForYes(){
        AntarangSetting__c CS = AntarangSetting__c.getOrgDefaults();
        CS.Enable_Contact_Trigger__c = true;
        Upsert cs AntarangSetting__c.Id;
        
        
        contact con = new Contact();
        con.FirstName = 'fname';
        con.LastName = 'lname';
        con.Followup1Aspiration__c = 'Accountant';
        con.Follow_up_1_Step_1__c = 'HSC-Science';
        con.Aspiration_via_conf_call__c ='Accountant';
        
        Test.startTest();
        Insert con;
        ContactTriggerHandler.recurssionOfPB = false;
        con.Follow_up_1_Step_1__c = 'I do not know';
        Update con;
        Test.stopTest();
    }
    
    @isTest
    public static void checkMappingForNo(){
        AntarangSetting__c CS = AntarangSetting__c.getOrgDefaults();
        CS.Enable_Contact_Trigger__c = true;
        Upsert cs AntarangSetting__c.Id;
        
        ContactTriggerHandler.recurssionOfPB = false;
        
        contact con = new Contact();
        con.FirstName = 'fname';
        con.LastName = 'lname';
        con.Followup1Aspiration__c = 'Accountant';
        con.Follow_up_1_Step_1__c = 'HSC-Commerce';
        
        Test.startTest();
        Insert con;
        Test.stopTest();
    }
    
    @isTest
    public static void checkMappingForDataNotAvailable(){
        AntarangSetting__c CS = AntarangSetting__c.getOrgDefaults();
        CS.Enable_Contact_Trigger__c = true;
        Upsert cs AntarangSetting__c.Id;
        ContactTriggerHandler.recurssionOfPB = false;
        
        contact con = new Contact();
        con.FirstName = 'fname';
        con.LastName = 'lname';
        con.Followup1Aspiration__c = 'Accountant';
        
        Test.startTest();
        Insert con;
        Test.stopTest();
    }
    
    @isTest
    public static void checkForEduStatus(){
        AntarangSetting__c CS = AntarangSetting__c.getOrgDefaults();
        CS.Enable_Contact_Trigger__c = true;
        CS.Disable_Placements_re_engage__c = true;
        CS.PlanA_B_Industry_Check__c = true;
        Upsert cs AntarangSetting__c.Id;
        
        ContactTriggerHandler.recurssionOfPB = false;
        
        contact con = new Contact();
        con.FirstName = 'fname';
        con.LastName = 'lname';
        con.Followup1Aspiration__c = 'Accountant';
        con.Follow_up_1_Step_1__c = 'Complete Class 10';
        con.Education_status_at_fup__c =  'Grade 9';
        
        Test.startTest();
        Insert con;
        con.Education_status_at_fup__c =  'Grade 10';
        Update con;
        Test.stopTest();
    }
    
    public static testMethod void test(){
        AntarangSetting__c CS = new AntarangSetting__c();
        CS.Enable_Contact_Trigger__c = True;
        insert CS;
        ContactTriggerHandler.recurssionOfPB = false;
        
        TriggerCheck triggerCheck=new TriggerCheck();
        Batch__c batch=new Batch__c();
        batch.Preferred_Language__c='Hindi';
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.Name = 'Goa';
        sm.District__c = 'Goa';
        sm.Session_Number__c = 1;
        sm.Grade__c = 'Grade 10';
        sm.Description__c = 'Test';
        insert sm;
        
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Goa';
        insert distict;
        
        City_Master__c city=new City_Master__c();
        city.District__c=distict.id;
        city.Name='Kalyan'; 
        //  city.City_Code__c='2';
        insert city;
        
        triggerCheck.setVariable(true);
        // triggerCheck.calculateCityCode(city.id);
        
        Ward_Master__c ward=new Ward_Master__c();
        ward.City__c=city.id;
        ward.Name='West';
        // ward.Ward_Code__c='1';
        insert ward;
        
        triggerCheck.setVariable(true);
        //triggerCheck.calculateWardCode(ward.id);
        
        Account account=new Account();
        account.Name='Shreeram School';
        // account.School_Code__c='1';
        account.State__c=state.id;
        account.Ward__c=ward.id;
        account.City__c=city.id;
        account.District__c=distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
        
        triggerCheck.setVariable(true);
        //triggerCheck.calculateSchoolCode(account.id);
        
        batch.School_Name__c=account.id;
        
        Account account1=new Account();
        account1.Name='Shreeram School Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId=RecordTypeIdAccount1;
        account1.Number_of_batches_funded__c=100;
        account1.Number_of_batches_allocated__c=50;
        account1.Number_of_batches_pending__c=1.0;
        insert account1;
        
        triggerCheck.setVariable(true);
        
        batch.Donor_Name__c=account1.id;
        
        batch.Name='Batch 7';
        batch.Number_of_students_facilitated__c=0.0;
        insert batch;
        
        
        Contact con=new Contact();
        con.FirstName='Web';
        con.LastName='Check';
        con.Batch_Code__c=batch.id;
        //con.Recommedation_Status__c='Not Processed';
        insert con;
        
        Contact condata=[select Batch_Code__c from Contact];
        System.assert(condata.Batch_Code__c !=null);
        
    }
    
    public static testMethod void test1(){
        AntarangSetting__c CS = new AntarangSetting__c();
        CS.Enable_Contact_Trigger__c = True;
        insert CS;
        TriggerCheck triggerCheck=new TriggerCheck();
        Batch__c batch=new Batch__c();
        batch.Preferred_Language__c='Hindi';
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
        ContactTriggerHandler.recurssionOfPB = false;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.Name = 'Goa';
        sm.District__c = 'Goa';
        sm.Session_Number__c = 1;
        sm.Grade__c = 'Grade 10';
        sm.Description__c = 'Test';
        insert sm;
        
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Goa';
        insert distict;
        
        City_Master__c city=new City_Master__c();
        city.District__c=distict.id;
        city.Name='Kalyan'; 
        //city.City_Code__c='2';
        insert city;
        
        triggerCheck.setVariable(true);
        //triggerCheck.calculateCityCode(city.id);
        
        Ward_Master__c ward=new Ward_Master__c();
        ward.City__c=city.id;
        ward.Name='West';
        //ward.Ward_Code__c='1';
        insert ward;
        
        triggerCheck.setVariable(true);
        //triggerCheck.calculateWardCode(ward.id);
        
        Account account=new Account();
        account.Name='Shreeram School';
        //account.School_Code__c='1';
        account.State__c=state.id;
        account.Ward__c=ward.id;
        account.City__c=city.id;
        account.District__c=distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
        
        triggerCheck.setVariable(true);
        //triggerCheck.calculateSchoolCode(account.id);
        
        List<Question_Bank__c> question =new List<Question_Bank__c>{
            new Question_Bank__c(Category1__c='Spatial',Category__c='A',Name='Spatial-1'),
                new Question_Bank__c(Category1__c='Spatial',Category__c='B',Name='Spatial-2'),
                new Question_Bank__c(Category1__c='Spatial',Category__c='C',Name='Spatial-3'),
                new Question_Bank__c(Category1__c='Spatial',Category__c='A',Name='Spatial-4'),
                new Question_Bank__c(Category1__c='Spatial',Category__c='B',Name='Spatial-5'),
                new Question_Bank__c(Category1__c='Spatial',Category__c='C',Name='Spatial-6'),
                new Question_Bank__c(Category1__c='Spatial',Category__c='A',Name='Spatial-7'),
                new Question_Bank__c(Category1__c='Spatial',Category__c='B',Name='Spatial-8'), 
                new Question_Bank__c(Category1__c='Numerical',Category__c='C',Name='Numerical-1'),
                new Question_Bank__c(Category1__c='Numerical',Category__c='A',Name='Numerical-2'),
                new Question_Bank__c(Category1__c='Numerical',Category__c='B',Name='Numerical-3'),
                new Question_Bank__c(Category1__c='Numerical',Category__c='C',Name='Numerical-4'),
                new Question_Bank__c(Category1__c='Numerical',Category__c='A',Name='Numerical-5'),
                new Question_Bank__c(Category1__c='Numerical',Category__c='B',Name='Numerical-6'),
                new Question_Bank__c(Category1__c='Numerical',Category__c='C',Name='Numerical-7'),
                new Question_Bank__c(Category1__c='Numerical',Category__c='A',Name='Numerical-8'),  
                new Question_Bank__c(Category1__c='Abstract',Category__c='B'), 
                new Question_Bank__c(Category1__c='Abstract',Category__c='C'),
                new Question_Bank__c(Category1__c='Abstract',Category__c='B'), 
                new Question_Bank__c(Category1__c='Abstract',Category__c='C'),
                new Question_Bank__c(Category1__c='Abstract',Category__c='B'), 
                new Question_Bank__c(Category1__c='Abstract',Category__c='C'), 
                new Question_Bank__c(Category1__c='Abstract',Category__c='B'), 
                new Question_Bank__c(Category1__c='Abstract',Category__c='C'),  
                new Question_Bank__c(Category1__c='Creative',Category__c='B'),  
                new Question_Bank__c(Category1__c='Creative',Category__c='A'),
                new Question_Bank__c(Category1__c='Mechanical',Category__c='A'),
                new Question_Bank__c(Category1__c='Mechanical',Category__c='B'),
                new Question_Bank__c(Category1__c='Mechanical',Category__c='C'),
                new Question_Bank__c(Category1__c='Mechanical',Category__c='A'),
                new Question_Bank__c(Category1__c='Mechanical',Category__c='B'),
                new Question_Bank__c(Category1__c='Mechanical',Category__c='C'),
                new Question_Bank__c(Category1__c='Mechanical',Category__c='A'),
                new Question_Bank__c(Category1__c='Mechanical',Category__c='A'),
                new Question_Bank__c(Category1__c='Verbal',Category__c='A'),
                new Question_Bank__c(Category1__c='Verbal',Category__c='B'),
                new Question_Bank__c(Category1__c='Verbal',Category__c='C'),
                new Question_Bank__c(Category1__c='Verbal',Category__c='D'),
                new Question_Bank__c(Category1__c='Verbal',Category__c='A'),
                new Question_Bank__c(Category1__c='Verbal',Category__c='B'),
                new Question_Bank__c(Category1__c='Verbal',Category__c='C'),
                new Question_Bank__c(Category1__c='Verbal',Category__c='D'),
                new Question_Bank__c(Category1__c='Clarity',Category__c='B'),
                new Question_Bank__c(Category1__c='Clarity',Category__c='C'),
                new Question_Bank__c(Category1__c='Clarity',Category__c='D'),
                
                new Question_Bank__c(Category1__c='Design',Category__c='A'),
                new Question_Bank__c(Category1__c='Performance Arts',Category__c='A'),
                new Question_Bank__c(Category1__c='Media and communication',Category__c='A'),
                new Question_Bank__c(Category1__c='Beauty and Wellness',Category__c='A'),
                new Question_Bank__c(Category1__c='Education',Category__c='A'),
                new Question_Bank__c(Category1__c='Sports and fitness',Category__c='A'),
                new Question_Bank__c(Category1__c='Finance',Category__c='A'),
                new Question_Bank__c(Category1__c='Hospitality',Category__c='A'),
                new Question_Bank__c(Category1__c='Medical',Category__c='A'),
                new Question_Bank__c(Category1__c='Public services',Category__c='A'),
                new Question_Bank__c(Category1__c='Engineering',Category__c='A'),
                new Question_Bank__c(Category1__c='Trades',Category__c='A'),
                new Question_Bank__c(Category1__c='Environmental and biological',Category__c='A')
                
                };
                    
                    insert question; 
        
        batch.School_Name__c=account.id;
        
        Account account1=new Account();
        account1.Name='Shreeram School Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId=RecordTypeIdAccount1;
        account1.Number_of_batches_funded__c=100;
        account1.Number_of_batches_allocated__c=50;
        account1.Number_of_batches_pending__c=1.0;
        insert account1;
        
        triggerCheck.setVariable(true);
        
        batch.Donor_Name__c=account1.id;
        
        batch.Name='Batch 7';
        batch.Number_of_students_facilitated__c=0.0;
        insert batch;
        
        Contact con=new Contact();
        con.FirstName='Web';
        con.LastName='Check';
        con.Batch_Code__c=batch.id;//con.Recommedation_Status__c='Not Processed';
        insert con;
        triggerCheck.setVariableCon(true);
        
        Batch__c batchNew=new Batch__c();
        batchNew.Preferred_Language__c='Hindi';
        batchNew.School_Name__c=account.id;
        batchNew.Donor_Name__c=account1.id;
        batchNew.Name='Batch 8';
        batchNew.Number_of_students_facilitated__c=0.0;
        insert batchNew;
        
        con.Batch_Code__c=batchNew.id;
        
        update con;
        
        con.Import_Status__c = 'Career Awareness Imported';
        update con;
        
        con.Import_Status__c = 'Career Planning Imported';
        update con;
        
        con.Import_Status__c = 'Career Awareness Imported';
        con.Design__c = 'A';
        con.Performance_Arts__c = 'A';
        con.Media_Communication__c = 'A';
        con.Beauty_Wellness__c = 'A';
        con.Education__c = 'A';
        con.Sports_Fitness__c = 'A';
        con.Finance__c = 'A';
        con.Hospitality_Tourism__c = 'A';
        con.Medical__c = 'A';
        con.Public_Services__c = 'A';
        con.Enginnering_technologies__c = 'A';
        con.Trades__c = 'A';
        con.Enviomental_and_Biological_Sciences__c = 'B';
        update con;
        
        con.Import_Status__c = 'Career Planning Imported';
        con.CCP_1__c = '1';
        con.CCP_2__c = '2';
        con.CCP_3__c = '3';
        update con;
        
        Contact condata=[select Batch_Code__c from Contact];
        System.assert(condata.Batch_Code__c == batchNew.id);
        
        delete con;
        Test.startTest();
        Test.stopTest();
        
    }
    
    public static testMethod void testFollowUpDetails(){
        AntarangSetting__c CS = new AntarangSetting__c();
        CS.Enable_Contact_Trigger__c = True;
        insert CS;
        
        ContactTriggerHandler.recurssionOfPB = false;
        List<Question_Bank__c> question =new List<Question_Bank__c>{
            new Question_Bank__c(Category1__c='Followup 1',Category__c='A',Name='Baseline 1'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='B',Name='Baseline 2'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='C',Name='Baseline 3'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='A',Name='Baseline 4'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='B',Name='Baseline 5'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='C',Name='Baseline 6'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='A',Name='Endline 1'), 
                new Question_Bank__c(Category1__c='Followup 1',Category__c='B',Name='Endline 2'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='C',Name='Endline 3'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='A',Name='Endline 4'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='B',Name='Endline 5'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='C',Name='Endline 6'),
                new Question_Bank__c(Category1__c='Followup 2',Category__c='A',Name='Baseline 1'),
                new Question_Bank__c(Category1__c='Followup 2',Category__c='B',Name='Baseline 2'),
                new Question_Bank__c(Category1__c='Followup 2',Category__c='C',Name='Baseline 3'),  
                new Question_Bank__c(Category1__c='Followup 2',Category__c='A',Name='Baseline 4'), 
                new Question_Bank__c(Category1__c='Followup 2',Category__c='B',Name='Baseline 5'),
                new Question_Bank__c(Category1__c='Followup 2',Category__c='C',Name='Baseline 6'), 
                new Question_Bank__c(Category1__c='Followup 2',Category__c='A',Name='Endline 1'),
                new Question_Bank__c(Category1__c='Followup 2',Category__c='B',Name='Endline 2'), 
                new Question_Bank__c(Category1__c='Followup 2',Category__c='C',Name='Endline 3'), 
                new Question_Bank__c(Category1__c='Followup 2',Category__c='A',Name='Endline 4'), 
                new Question_Bank__c(Category1__c='Followup 2',Category__c='B',Name='Endline 5'),  
                new Question_Bank__c(Category1__c='Followup 2',Category__c='C',Name='Endline 6')
                };
                    
                    insert question;
        
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.Name = 'Goa';
        sm.District__c = 'Goa';
        sm.Session_Number__c = 1;
        sm.Grade__c = 'Grade 10';
        sm.Description__c = 'Test';
        insert sm;
        
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Goa';
        insert distict;
        
        City_Master__c city=new City_Master__c();
        city.District__c=distict.id;
        city.Name='Kalyan'; 
        //city.City_Code__c='2';
        insert city;
        
        Ward_Master__c ward=new Ward_Master__c();
        ward.City__c=city.id;
        ward.Name='West';
        //ward.Ward_Code__c='1';
        insert ward;
        
        Account account=new Account();
        account.Name='Shreeram School';
        //account.School_Code__c='1';
        account.State__c=state.id;
        account.Ward__c=ward.id;
        account.City__c=city.id;
        account.District__c=distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
        
        Account account1=new Account();
        account1.Name='Shreeram School Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId=RecordTypeIdAccount1;
        account1.Number_of_batches_funded__c=100;
        account1.Number_of_batches_allocated__c=50;
        account1.Number_of_batches_pending__c=1.0;
        insert account1;
        
        Batch__c batchNew=new Batch__c();
        batchNew.Preferred_Language__c='Hindi';
        batchNew.School_Name__c=account.id;
        batchNew.Donor_Name__c=account1.id;
        batchNew.Name='Batch 8';
        batchNew.Number_of_students_facilitated__c=0.0;
        insert batchNew;
        
        List<IARP_Master__c> IARP =new List<IARP_Master__c>{
            new IARP_Master__c(Sector__c='Design',Aspiration_1__c='Architect',Interest_1__c='Artistic',Interest_2__c='Enterprising',Aptitude_1__c='Creative',Aptitude_2__c='Spatial',Personality_1__c='Any',Personality_2__c='Any',Personality_3__c='Practical',Personality_4__c='Realist',Personality_5__c='Thoughtful',Personality_6__c='Any',Personality_7__c='Any',Personality_8__c='Any',Name='Architect',Reality_1__c='Any',Reality_2__c='Any',Reality_3__c='Yes',Reality_4__c='A',Reality_5__c='Any',Reality_6__c='Any',Reality_7__c='Any',Reality_8__c='A')
                };
                    insert IARP;
        
        
        Contact con=new Contact();
        con.FirstName='Web';
        con.LastName='Check';
        con.Batch_Code__c=batchNew.id;
        con.Followup1Aspiration__c = 'Architect';
        con.Aptitude_1__c = 'Creative';
        con.Aptitude_2__c = 'Spatial';
        con.Interest_1__c = 'Artistic';
        con.Interest_2__c = 'Enterprising'; 
        con.Student_Attendance__c = 'Present';
        con.I_agree_with_the_recommendation__c = 'Yes';
        con.I_am_clear_about_what_I_need_to_do_after__c = 'Yes';
        con.Guardian_Attendance__c = 'Present';
        con.Was_the_Program_useful_and_helpful_for_y__c = '5';
        con.Did_you_learn_something_new_about_yourse__c = '5';
        con.Did_you_learn_about_some_new_Careers__c = '5';
        con.Was_the_teacher_s_way_of_teaching_easy_t__c =  '5';
        con.Did_the_teacher_clear_all_your_doubts__c = '5';
        con.Were_you_able_to_understand_the_workbook__c = '5';
        con.Would_you_recommend_the_CareerAware_prog__c = '5';
        con.Followup_1_Baseline_1__c  = 'A';
        con.Followup_1_Baseline_2__c  = 'B';
        con.Followup_1_Baseline_3__c  = 'C';
        con.Followup_1_Baseline_4__c  = 'A';
        con.Followup_1_Baseline_5__c  = 'B';
        con.Followup_1_Baseline_6__c  = 'C';
        con.Followup_1_Endline_1__c  = 'A';
        con.Followup_1_Endline_2__c  = 'B';
        con.Followup_1_Endline_3__c  = 'C';
        con.Followup_1_Endline_4__c  = 'A';
        con.Followup_1_Endline_5__c  = 'B';
        con.Followup_1_Endline_6__c  = 'C';
        
        con.Followup_2_Baseline_1__c  = 'A';
        con.Followup_2_Baseline_2__c  = 'B';
        con.Followup_2_Baseline_3__c  = 'C';
        con.Followup_2_Baseline_4__c  = 'A';
        con.Followup_2_Baseline_5__c  = 'B';
        con.Followup_2_Baseline_6__c  = 'C';
        con.Followup_2_Endline_1__c  = 'A';
        con.Followup_2_Endline_2__c  = 'B';
        con.Followup_2_Endline_3__c  = 'C';
        con.Followup_2_Endline_4__c  = 'A';
        con.Followup_2_Endline_5__c  = 'B';
        con.Followup_2_Endline_6__c  = 'C';
        //con.Aptitude_1__c ='Abstract';
        //con.Aptitude_2__c ='Creative'; 
        con.Aptitude_3__c ='Spatial'; 
        // con.Interest_1__c ='Realist';
        //con.Interest_2__c ='Investigative';
        con.Interest_3__c ='Creative';
        /*con.Interest_1_Selected_By_Student__c ='Social';
con.Interest_2_Selected_By_Student__c ='Creative';
con.Interest_3_Selected_By_Student__c ='Social';
con.Aptitude_1_Selected_By_Student__c ='Spatial';
con.Aptitude_2_Selected_By_Student__c ='Spatial';
con.Aptitude_3_Selected_By_Student__c ='Spatial';*/
        con.Day_1__c = 'Present';
        insert con;
        
        con.Aptitude_1__c ='Numerical';
        con.Aptitude_2__c ='Numerical'; 
        con.Aptitude_3__c ='Numerical'; 
        con.Interest_1__c ='Realist';
        con.Interest_2__c ='Investigative';
        con.Interest_3__c ='Realist';
        /*con.Interest_1_Selected_By_Student__c ='Realist';
con.Interest_2_Selected_By_Student__c ='Investigative';
con.Interest_3_Selected_By_Student__c ='Realist';
con.Aptitude_1_Selected_By_Student__c ='Numerical';
con.Aptitude_2_Selected_By_Student__c ='Numerical';
con.Aptitude_3_Selected_By_Student__c ='Numerical';*/
        update con;
        test.startTest();
        test.stopTest();
    }
    public static testMethod void CalloutContact(){
        List<Question_Bank__c> question =new List<Question_Bank__c>{
            new Question_Bank__c(Category1__c='Spatial',Category__c='A',Name='Spatial-1'),
                new Question_Bank__c(Category1__c='Spatial',Category__c='B',Name='Spatial-2'),
                new Question_Bank__c(Category1__c='Spatial',Category__c='C',Name='Spatial-3'),
                new Question_Bank__c(Category1__c='Spatial',Category__c='A',Name='Spatial-4'),
                new Question_Bank__c(Category1__c='Spatial',Category__c='B',Name='Spatial-5'),
                new Question_Bank__c(Category1__c='Spatial',Category__c='C',Name='Spatial-6'),
                new Question_Bank__c(Category1__c='Spatial',Category__c='A',Name='Spatial-7'),
                new Question_Bank__c(Category1__c='Spatial',Category__c='B',Name='Spatial-8'), 
                new Question_Bank__c(Category1__c='Numerical',Category__c='C',Name='Numerical-1'),
                new Question_Bank__c(Category1__c='Numerical',Category__c='A',Name='Numerical-2'),
                new Question_Bank__c(Category1__c='Numerical',Category__c='B',Name='Numerical-3'),
                new Question_Bank__c(Category1__c='Numerical',Category__c='C',Name='Numerical-4'),
                new Question_Bank__c(Category1__c='Numerical',Category__c='A',Name='Numerical-5'),
                new Question_Bank__c(Category1__c='Numerical',Category__c='B',Name='Numerical-6'),
                new Question_Bank__c(Category1__c='Numerical',Category__c='C',Name='Numerical-7'),
                new Question_Bank__c(Category1__c='Numerical',Category__c='A',Name='Numerical-8'),  
                new Question_Bank__c(Category1__c='Abstract',Category__c='B'), 
                new Question_Bank__c(Category1__c='Abstract',Category__c='C'),
                new Question_Bank__c(Category1__c='Abstract',Category__c='B'), 
                new Question_Bank__c(Category1__c='Abstract',Category__c='C'),
                new Question_Bank__c(Category1__c='Abstract',Category__c='B'), 
                new Question_Bank__c(Category1__c='Abstract',Category__c='C'), 
                new Question_Bank__c(Category1__c='Abstract',Category__c='B'), 
                new Question_Bank__c(Category1__c='Abstract',Category__c='C'),  
                new Question_Bank__c(Category1__c='Creative',Category__c='B'),  
                new Question_Bank__c(Category1__c='Creative',Category__c='A'),
                new Question_Bank__c(Category1__c='Mechanical',Category__c='A'),
                new Question_Bank__c(Category1__c='Mechanical',Category__c='B'),
                new Question_Bank__c(Category1__c='Mechanical',Category__c='C'),
                new Question_Bank__c(Category1__c='Mechanical',Category__c='A'),
                new Question_Bank__c(Category1__c='Mechanical',Category__c='B'),
                new Question_Bank__c(Category1__c='Mechanical',Category__c='C'),
                new Question_Bank__c(Category1__c='Mechanical',Category__c='A'),
                new Question_Bank__c(Category1__c='Mechanical',Category__c='A'),
                new Question_Bank__c(Category1__c='Verbal',Category__c='A'),
                new Question_Bank__c(Category1__c='Verbal',Category__c='B'),
                new Question_Bank__c(Category1__c='Verbal',Category__c='C'),
                new Question_Bank__c(Category1__c='Verbal',Category__c='D'),
                new Question_Bank__c(Category1__c='Verbal',Category__c='A'),
                new Question_Bank__c(Category1__c='Verbal',Category__c='B'),
                new Question_Bank__c(Category1__c='Verbal',Category__c='C'),
                new Question_Bank__c(Category1__c='Verbal',Category__c='D'),
                new Question_Bank__c(Category1__c='Clarity',Category__c='B'),
                new Question_Bank__c(Category1__c='Clarity',Category__c='C'),
                new Question_Bank__c(Category1__c='Clarity',Category__c='D'),
                
                new Question_Bank__c(Category1__c='Design',Category__c='A'),
                new Question_Bank__c(Category1__c='Performance Arts',Category__c='A'),
                new Question_Bank__c(Category1__c='Media and communication',Category__c='A'),
                new Question_Bank__c(Category1__c='Beauty and Wellness',Category__c='A'),
                new Question_Bank__c(Category1__c='Education',Category__c='A'),
                new Question_Bank__c(Category1__c='Sports and fitness',Category__c='A'),
                new Question_Bank__c(Category1__c='Finance',Category__c='A'),
                new Question_Bank__c(Category1__c='Hospitality',Category__c='A'),
                new Question_Bank__c(Category1__c='Medical',Category__c='A'),
                new Question_Bank__c(Category1__c='Public services',Category__c='A'),
                new Question_Bank__c(Category1__c='Engineering',Category__c='A'),
                new Question_Bank__c(Category1__c='Trades',Category__c='A'),
                new Question_Bank__c(Category1__c='Environmental and biological',Category__c='A'),
                new Question_Bank__c(Category1__c='Industry Agnostic',Category__c='A'),
                new Question_Bank__c(Category1__c='Performance Arts',Category__c='A'),
                new Question_Bank__c(Category1__c='Healthcare',Category__c='A'),
                new Question_Bank__c(Category1__c='Tourism and Hospitality',Category__c='A'),
                new Question_Bank__c(Category1__c='Information Technology',Category__c='A'),
                new Question_Bank__c(Category1__c='Wellness and Fitness',Category__c='A'),
                new Question_Bank__c(Category1__c='Environment and Bioscience',Category__c='A'),
                new Question_Bank__c(Category1__c='Arts and Design',Category__c='A'),
                new Question_Bank__c(Category1__c='Media and Entertainment',Category__c='A'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='A',Name='Baseline 1'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='B',Name='Baseline 2'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='C',Name='Baseline 3'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='A',Name='Baseline 4'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='B',Name='Baseline 5'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='C',Name='Baseline 6'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='A',Name='Endline 1'), 
                new Question_Bank__c(Category1__c='Followup 1',Category__c='B',Name='Endline 2'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='C',Name='Endline 3'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='A',Name='Endline 4'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='B',Name='Endline 5'),
                new Question_Bank__c(Category1__c='Followup 1',Category__c='C',Name='Endline 6'),
                new Question_Bank__c(Category1__c='Followup 2',Category__c='A',Name='Baseline 1'),
                new Question_Bank__c(Category1__c='Followup 2',Category__c='B',Name='Baseline 2'),
                new Question_Bank__c(Category1__c='Followup 2',Category__c='C',Name='Baseline 3'),  
                new Question_Bank__c(Category1__c='Followup 2',Category__c='A',Name='Baseline 4'), 
                new Question_Bank__c(Category1__c='Followup 2',Category__c='B',Name='Baseline 5'),
                new Question_Bank__c(Category1__c='Followup 2',Category__c='C',Name='Baseline 6'), 
                new Question_Bank__c(Category1__c='Followup 2',Category__c='A',Name='Endline 1'),
                new Question_Bank__c(Category1__c='Followup 2',Category__c='B',Name='Endline 2'), 
                new Question_Bank__c(Category1__c='Followup 2',Category__c='C',Name='Endline 3'), 
                new Question_Bank__c(Category1__c='Followup 2',Category__c='A',Name='Endline 4'), 
                new Question_Bank__c(Category1__c='Followup 2',Category__c='B',Name='Endline 5'),  
                new Question_Bank__c(Category1__c='Followup 2',Category__c='C',Name='Endline 6')
                };
                    
                    insert question; 
        id cr = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
        AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
        setting.Enable_Contact_Trigger__c = True;
        setting.Enable_Contact_Api__c = true;
        setting.BaseApiUrl__c = 'http://dscareereadyapp.azurewebsites.net/api/apiuserlogin/validateapiuser';
        insert setting;
        
        ContactTriggerHandler.recurssionOfPB = false;
        set<id> conid = new set<id>();
        list<contact> lstcon = new list<contact>();
        list<contact> lstcon1 = new list<contact>();
        map<id,contact> mapcon = new map<id,contact>();
        map<id,contact> mapcon1 = new map<id,contact>();
        
        ContactTriggerHandler.recurssionOfPB = false;
        
        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Student').getRecordTypeId();
        
        List<IARP_Master__c> IARP =new List<IARP_Master__c>{
            new IARP_Master__c(Sector__c='Design',Aspiration_1__c='Architect',Interest_1__c='Artistic',Interest_2__c='Enterprising',Aptitude_1__c='Creative',Aptitude_2__c='Spatial',Personality_1__c='Any',Personality_2__c='Any',Personality_3__c='Practical',Personality_4__c='Realist',Personality_5__c='Thoughtful',Personality_6__c='Any',Personality_7__c='Any',Personality_8__c='Any',Name='Architect',Reality_1__c='Any',Reality_2__c='Any',Reality_3__c='Yes',Reality_4__c='A',Reality_5__c='Any',Reality_6__c='Any',Reality_7__c='Any',Reality_8__c='A')
                };
                    insert IARP;
        Contact con=new Contact();
        con.FirstName='Web';
        con.LastName='Check';
        con.recordtypeid = cr;
        con.Import_Status__c = 'Career Planning Imported';
        con.Aptitude_1__c = 'Creative';
        con.Industry_Agnostic__c = 'A';
        con.Performance_Arts__c = 'A';
        con.Media_Communication__c = 'A';
        con.Finance__c = 'A';
        con.Healthcare__c = 'A';
        con.Hospitality_Tourism__c = 'A';
        con.Information_Technology__c= 'A';
        con.Beauty_Wellness__c = 'A';
        con.Education__c = 'A';
        con.Public_Services__c = 'A';
        con.Enviomental_and_Biological_Sciences__c = 'A';
        con.Trades__c = 'A';
        con.RecordTypeId =contactRecordTypeId;
        con.Possible_Careers_1__c = IARP[0].id;
        con.Possible_Careers_2__c = IARP[0].id;
        con.Possible_Careers_3__c = IARP[0].id;
        con.Followup1Aspiration__c = 'Architect';
        con.Aptitude_1__c = 'Creative';
        con.Aptitude_2__c = 'Spatial';
        con.Interest_1__c = 'Artistic';
        con.Interest_2__c = 'Enterprising'; 
        con.Student_Attendance__c = 'Present';
        con.I_agree_with_the_recommendation__c = 'Yes';
        con.I_am_clear_about_what_I_need_to_do_after__c = 'Yes';
        con.Guardian_Attendance__c = 'Present';
        con.Was_the_Program_useful_and_helpful_for_y__c = '5';
        con.Did_you_learn_something_new_about_yourse__c = '5';
        con.Did_you_learn_about_some_new_Careers__c = '5';
        con.Was_the_teacher_s_way_of_teaching_easy_t__c =  '5';
        con.Did_the_teacher_clear_all_your_doubts__c = '5';
        con.Were_you_able_to_understand_the_workbook__c = '5';
        con.Would_you_recommend_the_CareerAware_prog__c = '5';
        con.Followup_1_Baseline_1__c  = 'A';
        con.Followup_1_Baseline_2__c  = 'B';
        con.Followup_1_Baseline_3__c  = 'C';
        con.Followup_1_Baseline_4__c  = 'A';
        con.Followup_1_Baseline_5__c  = 'B';
        con.Followup_1_Baseline_6__c  = 'C';
        con.Followup_1_Endline_1__c  = 'A';
        con.Followup_1_Endline_2__c  = 'B';
        con.Followup_1_Endline_3__c  = 'C';
        con.Followup_1_Endline_4__c  = 'A';
        con.Followup_1_Endline_5__c  = 'B';
        con.Followup_1_Endline_6__c  = 'C';
        
        con.Followup_2_Baseline_1__c  = 'A';
        con.Followup_2_Baseline_2__c  = 'B';
        con.Followup_2_Baseline_3__c  = 'C';
        con.Followup_2_Baseline_4__c  = 'A';
        con.Followup_2_Baseline_5__c  = 'B';
        con.Followup_2_Baseline_6__c  = 'C';
        con.Followup_2_Endline_1__c  = 'A';
        con.Followup_2_Endline_2__c  = 'B';
        con.Followup_2_Endline_3__c  = 'C';
        con.Followup_2_Endline_4__c  = 'A';
        con.Followup_2_Endline_5__c  = 'B';
        con.Followup_2_Endline_6__c  = 'C';
        con.Aptitude_3__c ='Spatial'; 
        con.Interest_3__c ='Creative';
        con.Day_1__c = 'Present';
        insert con;
        
        mapcon.put(con.id,con);
        con.Import_Status__c = 'Career Awareness Imported';
        con.Aptitude_1__c ='Numerical';
        con.Aptitude_2__c ='Numerical'; 
        con.Aptitude_3__c ='Numerical'; 
        con.Interest_1__c ='Realist';
        con.Interest_2__c ='Investigative';
        con.Interest_3__c ='Realist';
        update con;
        
        Contact con1=new Contact();
        con1.FirstName='Web1';
        con1.LastName='Check1';
        con1.recordtypeid = cr;
        con1.Aptitude_1__c = 'Creative';
        con1.Aptitude_1__c = 'Creative';
        con1.Industry_Agnostic__c = 'A';
        con1.Performance_Arts__c = 'A';
        con1.Media_Communication__c = 'A';
        con1.Finance__c = 'A';
        con1.Healthcare__c = 'A';
        con1.Hospitality_Tourism__c = 'A';
        con1.Information_Technology__c= 'A';
        con1.Beauty_Wellness__c = 'A';
        con1.Education__c = 'A';
        con1.Public_Services__c = 'A';
        con1.Enviomental_and_Biological_Sciences__c = 'A';
        con1.Trades__c = 'A';
        con1.Import_Status__c = 'Career Awareness Imported';
        con1.RecordTypeId =contactRecordTypeId;
        
        insert con1;
        
        mapcon1.put(con1.id,con1);
        con1.Import_Status__c = 'Career Planning Imported';
        update con1;
        
        lstcon1.add(con1);
        lstcon.add(con);
        conid.add(con.id);
        
        //insert con;
        //lstcon.add(con);
        //mapcon.put(con.id,con);
        CalloutMock conapi = new CalloutMock(setting.BaseApiUrl__c,200,'OK','[{"response": "Student profile updated successfully","StatusCode": "SUCCESS"}]',new map < string, string > {'Content-Type' => 'application/json'});
        Test.setMock(HttpCalloutMock.class, conapi );
        Test.startTest();
        ContactTriggerHandler.RealtimeContactAPI(lstcon,false,false,false,mapcon);
        ContactCalloutBatch obj = new ContactCalloutBatch(conid);
        DataBase.executeBatch(obj);
        ContactTriggerHandler.UpdateFollowupDetails(lstcon);
        ContactTriggerHandler.CounsellingAttendance(lstcon);
        ContactTriggerHandler.UpdateStatuses(lstcon,mapcon);
        ContactTriggerHandler.UpdateCareerTracksAndClarityReports(lstcon,null);
        ContactTriggerHandler.UpdateCareerTracksAndClarityReports(lstcon1,null);
        ContactTriggerHandler.updatePlanA_B(lstcon,mapcon,true);
        
        Test.stopTest();
        
        
    }
    public static testMethod void test0() {
        id cr = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
        RecordType caStudentRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'CA_Trainer' LIMIT 1]; 
        RecordType crStudentRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'CR_Student' LIMIT 1]; 
        AntarangSetting__c CS = new AntarangSetting__c();
        CS.PlanA_B_Industry_Check__c = true;
        insert CS;
        set < id > conlst = new set < id > ();
        
        Contact con = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = caStudentRT.id, Plan_A__c = 'Flight attendant',Plan_B__c = 'Flight attendant',Cities_of_Operation__c='Udaipur');
        insert con;
        conlst.add(con.id);
        Contact con1 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = caStudentRT.id, Plan_A__c = 'Tailoring',Plan_b__c = 'Tailoring',Current_Education__c = 'SY Master in Arts',Education_Status__c ='Completed');
        insert con1;
        conlst.add(con1.id);
        Contact con2 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = crStudentRT.id, Plan_A__c = 'Tour Guide',Plan_B__c = 'Tour Guide',Current_Education__c = 'SY Master in Arts',Education_Status__c ='Completed');
        insert con2;
        conlst.add(con2.id);
        PlanA_BIndustryUpdateClass PlanAB = new PlanA_BIndustryUpdateClass(conlst);
        
        Test.startTest();
        
        System.enqueueJob(PlanAB);
        Test.StopTest();
    }  
    public static testMethod void test2() {
        id cr = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
        id cr1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Trainer').getRecordTypeId();
        RecordType caStudentRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'CA_Trainer' LIMIT 1];
        RecordType crStudentRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'CR_Student' LIMIT 1];
        AntarangSetting__c CS = new AntarangSetting__c();
        CS.PlanA_B_Industry_Check__c = true;
        insert CS;
        set< id > conlst = new set< id > ();
        List<Contact> lstCon = new List<Contact>();
        map<id,contact> mapOfCon = new map<id,contact>();
        
        Contact con = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = caStudentRT.id, Plan_A__c = 'Graphic Design',Plan_B__c = 'Graphic Design',Current_Education__c = 'SY Master in Arts',Education_Status__c ='Completed');
        insert con;
        conlst.add(con.id);
        Contact con1 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = caStudentRT.id, Plan_A__c = 'School Teaching',Plan_B__c = 'School Teaching',Cities_of_Operation__c='Udaipur');
        insert con1;
        conlst.add(con1.id);
        Contact con2 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = crStudentRT.id, Plan_A__c = 'Sports person',Plan_B__c = 'Sports person',Cities_of_Operation__c='Udaipur',Current_Education__c = 'SY Master in Arts',Education_Status__c ='Completed');
        insert con2;
        /**Contact con3 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = crStudentRT.id, Plan_A__c = 'Sports person',Plan_B__c = 'Sports person',Cities_of_Operation__c='Udaipur',Current_Education__c = 'FY Master in Arts',Education_Status__c ='Completed');
        insert con3;
        Contact con4 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = crStudentRT.id, Plan_A__c = 'Sports person',Plan_B__c = 'Sports person',Cities_of_Operation__c='Udaipur',Current_Education__c = 'Engineering',Education_Status__c ='Completed');
        insert con4;
        Contact con5 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = crStudentRT.id, Plan_A__c = 'Sports person',Plan_B__c = 'Sports person',Cities_of_Operation__c='Udaipur',Current_Education__c = '12th standard- Distance Education',Education_Status__c ='Completed');
        insert con5;
        Contact con6 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = crStudentRT.id, Plan_A__c = 'Sports person',Plan_B__c = 'Sports person',Cities_of_Operation__c='Udaipur',Current_Education__c = '9th Standard',Education_Status__c ='Completed');
        insert con6;**/
        conlst.add(con2.id);
        mapOfCon.put(con.id,con);
        lstCon.add(con);
        lstCon.add(con1);
        lstCon.add(con2);
        //lstCon.add(con3);
        //lstCon.add(con4);
        //lstCon.add(con5);
        //lstCon.add(con6);
        
        PlanA_BIndustryUpdateClass PlanAB = new PlanA_BIndustryUpdateClass(conlst);
        Test.startTest();
        ContactTriggerHandler.processBuilderUpdateContact(lstCon,mapOfCon,true,true);
        System.enqueueJob(PlanAB);
        
        //ContactTriggerHandler.MapCareerAwarePost10steps(lstCon,mapOfCon,false);
        ContactTriggerHandler.MapFupAspiration(lstCon,mapOfCon,true);
        
        Test.StopTest();
    }
    public static testMethod void test3() {
        id cr = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
        AntarangSetting__c CS = new AntarangSetting__c();
        CS.PlanA_B_Industry_Check__c = true;
        insert CS;
        set< id > conlst = new set< id > ();
        
        Contact con = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = cr, Plan_A__c = 'Photography',Plan_B__c = 'Photography');
        insert con;
        conlst.add(con.id);
        Contact con1 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = cr, Plan_A__c = 'Zoology', Plan_B__c = 'Zoology');
        insert con1;
        conlst.add(con1.id);
        Contact con2 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = cr, Plan_A__c = 'Customer Service',Plan_B__c = 'Customer Service');
        insert con2;
        conlst.add(con2.id);
        
        
        PlanA_BIndustryUpdateClass PlanAB = new PlanA_BIndustryUpdateClass(conlst);
        Test.startTest();
        System.enqueueJob(PlanAB);
        
        Test.StopTest();
    }
    public static testMethod void test4() {
        id cr = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
        AntarangSetting__c CS = new AntarangSetting__c();
        CS.PlanA_B_Industry_Check__c = true;
        insert CS;
        set< id > conlst = new set< id > ();
        
        Contact con = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = cr, Plan_A__c = 'Accounting',Plan_B__c = 'Accounting');
        insert con;
        conlst.add(con.id);
        Contact con1 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = cr, Plan_A__c = 'Politics',Plan_B__c = 'Politics');
        insert con1;
        conlst.add(con1.id);
        Contact con2 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = cr, Plan_A__c = 'Retail Sales',Plan_B__c = 'Retail Sales');
        insert con2;
        conlst.add(con2.id);
        
        PlanA_BIndustryUpdateClass PlanAB = new PlanA_BIndustryUpdateClass(conlst);
        
        Test.startTest();
        System.enqueueJob(PlanAB);
        
        Test.StopTest();
    }
    public static testMethod void test5() {
        id cr = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
        AntarangSetting__c CS = new AntarangSetting__c();
        CS.PlanA_B_Industry_Check__c = true;
        insert CS;
        set< id > conlst = new set< id > ();
        
        Contact con = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = cr, Plan_A__c = 'Ethical Hacking',Plan_B__c = 'Ethical Hacking');
        insert con;
        conlst.add(con.id);
        Contact con1 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = cr, Plan_A__c = 'Lawyer',Plan_B__c = 'Lawyer');
        insert con1;
        conlst.add(con1.id);
        Contact con2 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = cr, Plan_A__c = 'Horticulture',Plan_B__c = 'Horticulture');
        insert con2;
        conlst.add(con2.id);
        
        PlanA_BIndustryUpdateClass PlanAB = new PlanA_BIndustryUpdateClass(conlst);
        Test.startTest();
        
        System.enqueueJob(PlanAB);
        
        Test.StopTest();
    }
    public static testMethod void test6() {
        id cr = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
        AntarangSetting__c CS = new AntarangSetting__c();
        CS.PlanA_B_Industry_Check__c = true;
        insert CS;
        set< id > conlst = new set< id > ();
        
        Contact con = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = cr, Plan_A__c = 'Make Up',Plan_B__c = 'Make Up');
        insert con;
        conlst.add(con.id);
        Contact con1 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = cr, Plan_A__c = 'Plumbing',Plan_B__c = 'Plumbing');
        insert con1;
        conlst.add(con1.id);
        Contact con2 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = cr, Plan_A__c = 'Driving',Plan_B__c = 'Driving');
        insert con2;
        conlst.add(con2.id);
        
        PlanA_BIndustryUpdateClass PlanAB = new PlanA_BIndustryUpdateClass(conlst);
        
        Test.startTest();
        System.enqueueJob(PlanAB);
        
        Test.StopTest();
    }
    Public static testMethod void test7() {
        id cr = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
        AntarangSetting__c CS = new AntarangSetting__c();
        CS.PlanA_B_Industry_Check__c = true;
        insert CS;
        set< id > conlst = new set< id > ();
        
        Contact con = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = cr, Plan_A__c = 'Tour Guide',Plan_B__c = 'Tour Guide');
        insert con;
        conlst.add(con.id);
        Contact con1 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = cr, Plan_A__c = 'Welding',Plan_B__c = 'Welding');
        insert con1;
        conlst.add(con1.id);
        Contact con2 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = cr, Plan_A__c = 'Veterinary',Plan_B__c = 'Veterinary');
        insert con2;
        conlst.add(con2.id);
        
        PlanA_BIndustryUpdateClass PlanAB = new PlanA_BIndustryUpdateClass(conlst);
        Test.startTest();
        System.enqueueJob(PlanAB );
        
        Test.StopTest();
    }
    Public static testMethod void test8() {
        id cr = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
        AntarangSetting__c CS = new AntarangSetting__c();
        CS.PlanA_B_Industry_Check__c = true;
        insert CS;
        set< id > conlst = new set< id > ();
        
        Contact con = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = cr, Plan_A__c = 'Mechanical engineering',Plan_B__c = 'Mechanical engineering');
        insert con;
        conlst.add(con.id);
        Contact con1 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = cr, Plan_A__c = 'Airforce',Plan_B__c = 'Airforce');
        insert con1;
        conlst.add(con1.id);
        Contact con2 = new Contact(FirstName = 'Web', LastName = 'Check', recordtypeid = cr, Plan_A__c = 'Merchant Navy', Plan_B__c = 'Merchant Navy');
        insert con2;
        conlst.add(con2.id);
        
        PlanA_BIndustryUpdateClass PlanAB = new PlanA_BIndustryUpdateClass(conlst);
        Test.startTest();
        System.enqueueJob(PlanAB);
        
        Test.StopTest();
    }
}