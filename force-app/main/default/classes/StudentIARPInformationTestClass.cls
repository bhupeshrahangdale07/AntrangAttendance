/* Getting the code coverage for StudentIARPInformation Class  */
@isTest(seealldata=false)
public class StudentIARPInformationTestClass {
    public static testMethod void test(){
        
        TriggerCheck triggerCheck=new TriggerCheck();
        Batch__c batch=new Batch__c();
        
        batch.Preferred_Language__c='Hindi';
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Pune';
        sm.Name = 'Pune Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'description';
        insert sm;
        
        triggerCheck.setVariable(true);
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Pune';
        insert distict;
        
        triggerCheck.setVariable(true);
        City_Master__c city=new City_Master__c();
        city.District__c=distict.id;
        city.Name='Kalyan'; 
        // city.City_Code__c='2';
        insert city;
        
        triggerCheck.setVariable(true);
        
        Ward_Master__c ward=new Ward_Master__c();
        ward.City__c=city.id;
        ward.Name='West';
        //ward.Ward_Code__c='1';
        insert ward;
        
        triggerCheck.setVariable(true);
        
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
        triggerCheck.setVariable(true);
        
        IARP_Master__c iarp=new IARP_Master__c();
        iarp.Name='Teacher';
        iarp.Sector__c='Education';
        iarp.Is_Active__c = true;
        insert iarp;
        
        IARP_Master__c iarp1=new IARP_Master__c();
        iarp1.Name='Fitness Instructor';
        iarp1.Sector__c='Sports and Fitness';
        iarp.Is_Active__c = true;
        insert iarp1;
        
        Contact contact=new Contact();
        Id RecordTypeIdStudent = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        contact.RecordTypeId = RecordTypeIdStudent;
        contact.FirstName='Kurund';
        contact.LastName='Jalmi';
        contact.Import_Status__c ='Import Completed';
        contact.Status__c ='Not Processed';
        contact.Recommedation_Status__c='Not Processed';
        contact.Batch_Code__c=batch.id;
        
        /*contact.I_like_to_repair_mobiles__c='Yes';
        contact.I_like_to_repair_mobiles__c ='Yes';
        contact.I_like_to_build_things_like_shoe_racks__c ='Yes';
        contact.I_like_to_take_care_of_animals__c ='Yes';
        contact.I_like_to_cook__c ='Yes';
        contact.I_am_a_practical_person__c ='Yes';
        contact.I_like_working_outside__c  = 'Yes';
        contact.I_like_to_heal_or_cure_people__c  = 'Yes';
        contact.I_like_to_grow_plants__c  = 'Yes';
        contact.I_like_to_do_puzzles_like_sudoku__c  = 'Yes';
        contact.My_favourite_subject_in_school_college_i__c  = 'Yes';
        contact.I_enjoy_trying_to_gure_out_how_things__c  = 'Yes';
        contact.I_can_never_make_a_mistake_while_countin__c  = 'Yes';
        contact.I_am_good_at_calculating_how_much_to_pay__c  = 'Yes';
        contact.I_like_to_analyze_things_problems_and_s__c  = 'Yes';
        contact.I_like_working_with_numbers__c   = 'Yes';
        contact.I_am_good_at_math__c  = 'No';
        contact.I_am_good_at_working_by_myself__c  = 'No';
        contact.I_like_to_read_about_art_and_music__c  = 'No';
        contact.I_like_writing_stories_plays_and_poems__c  = 'Yes';
        contact.I_am_creative_person_I_like_to_make_gre__c  = 'Yes';
        contact.I_like_to_play_instruments_or_sing_and_d__c  = 'No';
        contact.I_like_acting_in_plays__c  = 'No';
        contact.I_like_to_draw_and_paint__c  = 'No';
        contact.My_friends_take_my_advice_on_what_to_wea__c  = 'Yes';
        contact.I_like_to_work_in_teams__c  = 'No';
        contact.I_like_to_teach_and_train_people__c  = 'No';
        contact.I_like_to_help_people_solve_their_proble__c  = 'No';
        contact.I_like_learning_about_where_people_come__c  = 'No';
        contact.I_like_to_listen_to_the_news_read_newspa__c  = 'Yes';
        contact.I_like_to_organise_and_put_things_in__c  = 'No';
        contact.I_like_helping_the_elderly__c  = 'No';
        contact.I_am_ambitious_and_set_goals_for_myself__c  = 'No';
        contact.I_like_selling_things_and_convincing_peo__c  = 'No';
        contact.I_am_quick_to_take_on_new_responsibiliti__c  = 'No';
        contact.I_am_quick_to_take_on_new_responsibiliti__c  = 'Yes';
        contact.I_would_like_to_start_my_own_business__c  = 'No';
        contact.I_like_to_lead_and_motivate_people__c  = 'No';
        contact.I_like_to_give_speeches_talk_to_a_lot_o__c  = 'Yes';
        contact.I_like_to_teach_my_friends_or_siblings__c  = 'No';
        contact.I_like_to_take_on_responsibilities__c  = 'No';
        contact.I_like_to_organise_and_put_things_in__c  = 'Yes';
        contact.I_like_to_have_clear_instructions_to_f__c  = 'Yes';
        contact.I_wouldn_t_mind_working_8hrs_per_day__c  = 'No';
        contact.I_pay_attention_to_detail_and_I_am_good__c  = 'Yes';
        contact.I_like_to_do_filling_and_typing__c  = 'No';
        contact.I_pay_attention_to_detail_and_I_am_good__c  = 'No';
        contact.I_like_to_do_filling_and_typing__c  = 'No';
        contact.I_like_putting_things_together_and_ass__c  = 'No';
        contact.I_am_good_with_keeping_records_of_my_w__c  = 'No';
        contact.I_like_working_in_an_office__c  = 'Yes';
        
        contact.S__c='A';
        contact.Spatial_Ability_Q_2__c='A';
        contact.Spatial_Ability_Q_3__c='B';
        contact.Spatial_Ability_Q_4__c='A';
        contact.Spatial_Ability_Q_5__c='C';
        contact.Spatial_Ability_Q_6__c='A';
        contact.Spatial_Ability_Q_7__c='B';
        contact.Spatial_Ability_Q_8__c='A';
        
        
        contact.X21_46__c='A';
        contact.X32_19__c='B';
        contact.X141_90__c='A';
        contact.X53_13__c='C';
        contact.X96_37__c='A';
        contact.X329_183__c='B';
        contact.X25_16_4__c='A';
        contact.X125_58_16__c='A';
        
        contact.Abstract_Reasoning__c='A';
        contact.Abstract_Reasoning_Q_2__c='B';
        contact.Abstract_Reasoning_Q_3__c='A';
        contact.Abstract_Reasoning_Q_4__c='C';
        contact.Abstract_Reasoning_Q_5__c='A';
        contact.Abstract_Reasoning_Q_6__c='B';
        contact.Abstract_Reasoning_Q_7__c='A';
        contact.Abstract_Reasoning_Q_8__c='A';
        
        contact.Creative1__c='C';
        contact.Creative2__c='D';
        contact.Creative3__c='C';
        contact.Creative4__c='D';
        contact.Creative5__c='C';
        contact.Creative6__c='D';
        contact.Creative7__c='C';
        contact.Creative8__c='D';
        
        contact.Mech1__c='A';
        contact.Mech2__c='B';
        contact.Mech3__c='A';
        contact.Mech4__c='C';
        contact.Mech5__c='A';
        contact.Mech6__c='B';
        contact.Mech7__c='A';
        contact.Mech8__c='A';
        
        contact.Verbal1__c='A';
        contact.Verbal2__c='B';
        contact.Verbal3__c='A';
        contact.Verbal4__c='C';
        contact.Verbal5__c='A';
        contact.Verbal6__c='B';
        contact.Verbal7__c='A';
        contact.Verbal8__c='A';
        
        contact.Personality_1__c = 'Introvert';
        contact.Personality_2__c = 'Sensing';
        contact.Personality_3__c = 'Thinking';
        contact.Personality_4__c = 'Perceiving';
        
        contact.Possible_Careers_1__c=iarp.id;
        contact.Possible_Careers_2__c=iarp1.id;
        contact.Possible_Careers_3__c=iarp.id;*/
        insert contact;
        
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
                new Question_Bank__c(Category1__c='Creative',Category__c='C'),
                new Question_Bank__c(Category1__c='Creative',Category__c='D'),  
                new Question_Bank__c(Category1__c='Creative',Category__c='C'),
                new Question_Bank__c(Category1__c='Creative',Category__c='D'),  
                new Question_Bank__c(Category1__c='Creative',Category__c='C'),
                new Question_Bank__c(Category1__c='Creative',Category__c='D'),  
                new Question_Bank__c(Category1__c='Creative',Category__c='C'),
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
                new Question_Bank__c(Category1__c='Clarity',Category__c='D')
            };
                    
        insert question; 
        String sch1 = '0 0 * * * ?'; 
        System.schedule('IARP 0'+ System.now(), sch1, new StudentIARPInformation());
        
        StudentIARPInformation objIARPBatch = new StudentIARPInformation();
        Database.executeBatch(objIARPBatch, 10);
        
        
        CareerAwareScheduler objCAS = new CareerAwareScheduler();
        objCAS.JobScheduling ();
        /*Contact conData=[select Clarity_Report__c from contact];
        System.assert(conData.Clarity_Report__c !=null);*/
    }
    
    
}