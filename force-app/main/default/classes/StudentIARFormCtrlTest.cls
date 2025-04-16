@isTest
public class StudentIARFormCtrlTest {

    @isTest
    public static void testIAR(){
        Contact con = new Contact();
        con.LastName = 'Test Contact';
        /*con.I_like_to_repair_mobiles__c = 'Yes';
        con.I_like_to_build_things_like_shoe_racks__c = 'Yes';
        con.I_like_to_take_care_of_animals__c = 'Yes';
        con.I_like_to_cook__c = 'Yes';
        con.I_am_a_practical_person__c = 'Yes';
        con.I_like_working_outside__c = 'Yes';
        con.I_like_to_heal_or_cure_people__c = 'Yes';
        con.I_like_to_grow_plants__c = 'Yes';
        con.I_like_to_do_puzzles_like_sudoku__c = 'Yes';
        con.My_favourite_subject_in_school_college_i__c = 'Yes';
        con.I_enjoy_trying_to_gure_out_how_things__c = 'Yes';
        con.I_can_never_make_a_mistake_while_countin__c = 'Yes';
        con.I_am_good_at_calculating_how_much_to_pay__c = 'Yes';
        con.I_like_to_analyze_things_problems_and_s__c = 'Yes';
        con.I_like_working_with_numbers__c = 'Yes';
        con.I_am_good_at_math__c = 'Yes';
        con.I_am_good_at_working_by_myself__c = 'Yes';
        con.I_like_to_read_about_art_and_music__c = 'Yes';
        con.I_like_writing_stories_plays_and_poems__c = 'Yes';
        con.I_am_creative_person_I_like_to_make_gre__c = 'Yes';
        con.I_like_to_play_instruments_or_sing_and_d__c = 'Yes';
        con.I_like_acting_in_plays__c = 'Yes';
        con.I_like_to_draw_and_paint__c = 'Yes';
        con.My_friends_take_my_advice_on_what_to_wea__c = 'Yes';
        con.I_like_to_work_in_teams__c = 'Yes';
        con.I_like_to_teach_and_train_people__c = 'Yes';
        con.I_like_to_help_people_solve_their_proble__c = 'Yes';
        con.I_like_learning_about_where_people_come__c = 'Yes';
        con.I_like_to_listen_to_the_news_read_newspa__c = 'Yes';
        con.I_like_organizing_parties_and_get_togeth__c = 'Yes';
        con.I_like_helping_the_elderly__c = 'Yes';
        con.I_like_playing_team_games__c = 'Yes';
        con.I_am_ambitious_and_set_goals_for_myself__c = 'Yes';
        con.I_like_selling_things_and_convincing_peo__c = 'Yes';
        con.I_am_quick_to_take_on_new_responsibiliti__c = 'Yes';
        con.I_would_like_to_start_my_own_business__c = 'Yes';
        con.I_like_to_lead_and_motivate_people__c = 'Yes';
        con.I_like_to_give_speeches_talk_to_a_lot_o__c = 'Yes';
        con.I_like_to_teach_my_friends_or_siblings__c = 'Yes';
        con.I_like_to_take_on_responsibilities__c = 'Yes';
        con.I_like_to_organise_and_put_things_in__c = 'Yes';
        con.I_like_to_have_clear_instructions_to_f__c = 'Yes';
        con.I_wouldn_t_mind_working_8hrs_per_day__c = 'Yes';
        con.I_pay_attention_to_detail_and_I_am_good__c = 'Yes';
        con.I_like_to_do_filling_and_typing__c = 'Yes';
        con.I_like_putting_things_together_and_ass__c = 'Yes';
        con.I_am_good_with_keeping_records_of_my_w__c = 'Yes';
        con.I_like_working_in_an_office__c = 'Yes';
        con.Reality_1__c = 'Yes';
        con.Reality_2__c = 'Yes';
        con.Reality_3__c = 'Yes';
        con.Reality_4__c = 'B';
        con.Reality_5__c = 'Yes';
        con.Reality_6__c = 'Yes';
        con.Reality_7__c = 'Yes';
        con.Reality_8__c = 'B';
        con.S__c = 'A';
        con.Spatial_Ability_Q_2__c = 'A';
        con.Spatial_Ability_Q_3__c = 'A';
        con.Spatial_Ability_Q_4__c = 'A';
        con.Spatial_Ability_Q_5__c = 'A';
        con.Spatial_Ability_Q_6__c = 'A';
        con.Spatial_Ability_Q_7__c = 'A';
        con.Spatial_Ability_Q_8__c = 'A';
        con.X21_46__c = 'A';
        con.X32_19__c = 'A';
        con.X141_90__c = 'A';
        con.X53_13__c = 'A';
        con.X96_37__c = 'A';
        con.X329_183__c = 'A';
        con.X25_16_4__c = 'A';
        con.X125_58_16__c = 'A';
        con.Abstract_Reasoning__c = 'A';
        con.Abstract_Reasoning_Q_2__c = 'A';
        con.Abstract_Reasoning_Q_3__c = 'A';
        con.Abstract_Reasoning_Q_4__c = 'A';
        con.Abstract_Reasoning_Q_5__c = 'A';
        con.Abstract_Reasoning_Q_6__c = 'A';
        con.Abstract_Reasoning_Q_7__c = 'A';
        con.Abstract_Reasoning_Q_8__c = 'A';
        con.Creative1__c = 'A';
        con.Creative2__c = 'A';
        con.Creative3__c = 'A';
        con.Creative4__c = 'A';
        con.Creative5__c = 'A';
        con.Creative6__c = 'A';
        con.Creative7__c = 'A';
        con.Creative8__c = 'A';
        con.Mech1__c = 'A';
        con.Mech2__c = 'A';
        con.Mech3__c = 'A';
        con.Mech4__c = 'A';
        con.Mech5__c = 'A';
        con.Mech6__c = 'A';
        con.Mech7__c = 'A';
        con.Mech8__c = 'A';
        con.Verbal1__c = 'A';
        con.Verbal2__c = 'A';
        con.Verbal3__c = 'A';
        con.Verbal4__c = 'A';
        con.Verbal5__c = 'A';
        con.Verbal6__c = 'A';
        con.Verbal7__c = 'A';
        con.Verbal8__c = 'A';*/
        Insert con;
        
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
        
        Student_Feedback_mapping__c stdFeedback = new Student_Feedback_mapping__c();
        stdFeedback.Day_Number__c = 'Aptitude';
        stdFeedback.Language__c = 'eng';
        stdFeedback.Question_Label__c = 'I like to repair mobiles and other electrical equipment';
        stdFeedback.Order_of_Question__c = 1;
        stdFeedback.Display_Type__c = 'RadioGroup';
        Insert stdFeedback;
        
        Picklist_Mapping__c pickMapping = new Picklist_Mapping__c();
        pickMapping.Form_value__c = 'A';
        pickMapping.Order__c = 1;
        pickMapping.Student_Feedback_mapping__c = stdFeedback.Id;
        Insert pickMapping;
        
        Temporary_Student_Data__c tempStuData = new Temporary_Student_Data__c();
        tempStuData.Question__c = stdFeedback.Id;
        tempStuData.Answer__c = pickMapping.Id;
        Insert tempStuData;
        
        Explanations__c  exp1 = new Explanations__c();
        exp1.Name = 'Realities';
        exp1.Particulars__c = 'No one in my family has completed 12th grade';
        exp1.Realities__c = 'No';
        exp1.Code__c = 'Family 1 -Have any of my family members studied till 12th grade';
        exp1.Particulars_Hindi__c = 'मेरे परिवार के किसी ने भी १२ वीं कक्षा पूरी नहीं की है।';
        exp1.Particulars_Marathi__c = 'माझ्या कुटुंबातील कुणीही १२वी पूर्ण केलेली नाही.';
        Insert exp1;
        
        Explanations__c  exp2 = new Explanations__c();
        exp2.Name = 'Realities';
        exp2.Particulars__c = 'Atleast one of my family members have studied till 12th grade';
        exp2.Realities__c = 'Yes';
        exp2.Code__c = 'Family 1 -Have any of my family members studied till 12th grade';
        exp2.Particulars_Hindi__c = 'मेरे परिवार के सदस्यों में से कम से कम एक ने १२ वीं कक्षा तक अध्ययन किया हैं।';
        exp2.Particulars_Marathi__c = 'माझ्या कुटुंबातील किमान एकाने १२वी पर्यंत शिक्षण घेतले आहे.';
        Insert exp2;
        
        Explanations__c  exp3 = new Explanations__c();
        exp3.Name = 'Realities';
        exp3.Particulars__c = 'I am allowed to work post 10pm';
        exp3.Realities__c = 'Yes';
        exp3.Code__c = 'Family 2 - Does my family allow women to work past 10 pm';
        exp3.Particulars_Hindi__c = 'मुझे रात १० बजे के बाद भी काम करने की इजाजत हैं।';
        exp3.Particulars_Marathi__c = 'मला रात्री १० वाजे नंतर काम करण्याची परवानगी आहे.';
        Insert exp3;
        
        Explanations__c  exp4 = new Explanations__c();
        exp4.Name = 'Realities';
        exp4.Particulars__c = 'I am not allowed to work post 10pm';
        exp4.Realities__c = 'No';
        exp4.Code__c = 'Family 2 - Does my family allow women to work past 10 pm';
        exp4.Particulars_Hindi__c = 'मुझे रात १० बजे के बाद काम करने की इजाजत नहीं हैं।';
        exp4.Particulars_Marathi__c = 'मला रात्री १० वाजे नंतर काम करण्याची परवानगी नाही.';
        Insert exp4;
        
        Explanations__c  exp5 = new Explanations__c();
        exp5.Name = 'Realities';
        exp5.Particulars__c = 'My family will monetarily support my education';
        exp5.Realities__c = 'Yes';
        exp5.Code__c = 'Family 3 - Will my family monetarily support my education';
        exp5.Particulars_Hindi__c = 'मेरा परिवार मेरी शिक्षा का आर्थिक भार उठाएगा।';
        exp5.Particulars_Marathi__c = 'माझे कुटुंब माझ्या शिक्षणास आर्थिक पाठिंबा देईल.';
        Insert exp5;
        
        Explanations__c  exp6 = new Explanations__c();
        exp6.Name = 'Realities';
        exp6.Particulars__c = 'I will get married before 22 years of age.';
        exp6.Realities__c = 'No';
        exp6.Code__c = 'Self 1 - I have/will get married only after 22 years of age';
        exp6.Particulars_Hindi__c = 'मेरी शादी २२ साल की उम्र से पहले हो जाएगी।';
        exp6.Particulars_Marathi__c = 'मी वयाच्या २२ व्या वर्षापूर्वी लग्न करेन.';
        Insert exp6;
        
        Explanations__c  exp7 = new Explanations__c();
        exp7.Name = 'Realities';
        exp7.Particulars__c = 'I have to contribute to my family income in the next 3 years.';
        exp7.Realities__c = 'No';
        exp7.Code__c = 'Self 2 - I dont have to contribute to my family income for at least 3 years';
        exp7.Particulars_Hindi__c = 'मुझे अगले ३ वर्षों में अपनी पारिवारिक आमदनी में योगदान देना हैं।';
        exp7.Particulars_Marathi__c = 'पुढील ३ वर्षांसाठी मला माझ्या कौटुंबिक उत्पन्नामध्ये हातभार लावायचा आहे.';
        Insert exp7;
        
        Explanations__c  exp8 = new Explanations__c();
        exp8.Name = 'Realities';
        exp8.Particulars__c = 'I have not shared my aspirations with my family';
        exp8.Realities__c = 'No';
        exp8.Code__c = 'Self 3 - I have shared my aspirations with my family';
        exp8.Particulars_Hindi__c = 'मैंने अपने परिवार के साथ अपनी आकांक्षाएं साझा नहीं की हैं।';
        exp8.Particulars_Marathi__c = 'मी माझ्या आकांक्षा माझ्या कुटुंबियांसह सामायिक केल्या नाहित.';
        Insert exp8;
        
        Explanations__c  exp9 = new Explanations__c();
        exp9.Name = 'Realities';
        exp9.Particulars__c = 'My average monthly family income is below Rs 10,000';
        exp9.Realities__c = 'A';
        exp9.Code__c = 'Family 4 - My Avg family income';
        exp9.Particulars_Hindi__c = 'मेरी परिवार की औसत मासिक आमदनी १०,००० रुपये से कम हैं।';
        exp9.Particulars_Marathi__c = 'माझ्या कुटुंबाचे सरासरी मासिक उत्पन्न १०,००० रुपयांपेक्षा कमी आहे.';
        Insert exp9;
        
        Explanations__c  exp10 = new Explanations__c();
        exp10.Name = 'Realities';
        exp10.Particulars__c = 'I scored below 50% in my last two exams';
        exp10.Realities__c = 'A';
        exp10.Code__c = 'Self 4 - How much do I score A - Below 50%, B - 50%-80%, C - Above 80%';
        exp10.Particulars_Hindi__c = 'मैंने अपनी पिछली दो परीक्षाओं में ५०% से कम स्कोर किया।';
        exp10.Particulars_Marathi__c = 'माझ्या शेवटच्या दोन परीक्षांमध्ये मी ५०% च्या खाली गुण मिळवले.';
        Insert exp10;
        
        Test.startTest();
        Map<String, Object> res = (Map<String, Object>)StudentIARFormCtrl.fetchStudentQuestionsAndAnswers('Aptitude','eng',con.Id);
        StudentIARFormCtrl.WrpStudentQuestionAnswer data = (StudentIARFormCtrl.WrpStudentQuestionAnswer)res.get('data');
        StudentIARFormCtrl.saveTemporaryStudentIAR(data.lstWrpStudentQuestion, con.Id, 'submit','I','Interest');
        StudentIARFormCtrl.fetchQuestionImage(stdFeedback.Id);
        StudentIARFormCtrl.verifyStudentSubmittedExam(con.Id,'I');
        StudentIARFormCtrl.saveWhatsappnum(con.Id,'8754213696');
        StudentIARFormCtrl.studentResult(con.Id,'I','eng');
        StudentIARFormCtrl.studentResult(con.Id,'I','mar');
        StudentIARFormCtrl.studentResult(con.Id,'I','hin');
        StudentIARFormCtrl.studentResult(con.Id,'I','Urdu');
        StudentIARFormCtrl.studentResult(con.Id,'R','eng');
        StudentIARFormCtrl.studentResult(con.Id,'R','mar');
        StudentIARFormCtrl.studentResult(con.Id,'R','hin');
        StudentIARFormCtrl.studentResult(con.Id,'R','Urdu');
        StudentIARFormCtrl.studentResult(con.Id,'A','eng');
        StudentIARFormCtrl.studentResult(con.Id,'A','mar');
        StudentIARFormCtrl.studentResult(con.Id,'A','hin');
        StudentIARFormCtrl.studentResult(con.Id,'A','Urdu');
        StudentIARFormCtrl.FillDefaultDetails('eng');
        StudentIARFormCtrl.FillDefaultDetails('mar');
        StudentIARFormCtrl.FillDefaultDetails('hin');
        StudentIARFormCtrl.FillDefaultDetails('Urdu');
        Test.stopTest();
    }
    
}