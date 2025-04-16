/*For calculating the student IARP information based on csv data.
This class is included in the job which is run after every 5 mins.*/
Public class StudentIARPInformation implements Schedulable, Database.Batchable<sObject>{
    
    public string strQuery = '';
    
    Public void execute(SchedulableContext SC){
        //insertData();
        Integer recordLimit = 15;
        if(System.Label.IARP_Batch_Limit != null) {
            recordLimit = Integer.valueof(System.Label.IARP_Batch_Limit);
        }
        StudentIARPInformation objIARPBatch = new StudentIARPInformation();
        Database.executeBatch(objIARPBatch, recordLimit);
        
    }
        
    public StudentIARPInformation(){
        integer count=0;
        SObjectType t  = Schema.getGlobalDescribe().get('Contact');
        Map<String,Schema.SObjectField> fieldMap = t.getDescribe().fields.getMap();
        String field = '';
        for (String fieldName : fieldMap.keySet()){
            field += ''+fieldName+', ';
        }
        count = field.lastIndexOf(',');
        field = field.substring(0, count);
        
        string strsoqlQuery = 'select '+field+' from Contact where (Import_Status__c =\'Import Completed\' or Import_Status__c = \'Self Awareness Imported\')' + ' and Status__c=\''+'Not Processed'+'\''+' order by Bar_Code__c ';
        
        strQuery = strsoqlQuery;
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(strQuery);
    }

    public void execute(Database.BatchableContext BC, List<Contact> lstContact){
        calculcateIARPInformation(lstContact);
    }

    public void finish(Database.BatchableContext BC){
        
    }

    
    public void calculcateIARPInformation(List<Contact> conData) {
        integer value = 0;
        String aspiration1, aspiration2, aspiration3,PossibleCareers1,PossibleCareers2,PossibleCareers3;
        
        
        List<String> ans = new List<String>();
        //List<Contact> conData =new List<Contact>();
        Map<String, Integer> aptitute = new Map<String, Integer>();
        
        //get all questions banks
        map<string, List<Question_Bank__c>> mapAllQBCategoryWise = Utility.getAllCategorywiseQuestions();
        
        /*getting data of student from contact object based on bar code */
        /*FetchAllData fetchData=new FetchAllData();
        conData = fetchData.getAllData('Contact');*/
        
        for (Contact con : conData) {//TempData
            List<Integer> interestList = new List<Integer>(); 
            List<String> highestInterest = new List<String>();
            List<Question_Bank__c> correctAns = new List<Question_Bank__c>();
            LIST<String> personalityList = new LIST<String>();
            List<String> careerOptions = new List<String>();
            String careerStepUns = 'No';
            List<String> studentSelectUns = new List<String>();
            List<String> unsList = new List<String>();
            integer countOptions = 0;
            
            Map<String, Integer> mp = new Map<String, Integer>();
            
            //for  Interest Logic
            // REALIST

            List<String> realistInterest = new List<String>();

            /*realistInterest.add(con.I_like_to_repair_mobiles__c);
            realistInterest.add(con.I_like_to_build_things_like_shoe_racks__c);
            realistInterest.add(con.I_like_to_take_care_of_animals__c);
            realistInterest.add(con.I_like_to_cook__c);
            realistInterest.add(con.I_am_a_practical_person__c);
            realistInterest.add(con.I_like_working_outside__c);
            realistInterest.add(con.I_like_to_heal_or_cure_people__c);
            realistInterest.add(con.I_like_to_grow_plants__c);

            Integer realistCount = 0;
            for (String interest : realistInterest) {
                if (String.isNotBlank(interest) && interest == 'Yes') {
                    realistCount++;
                }
            }
            if (realistCount > 0)
                mp.put('Realist', realistCount);  */

            // INVESTIGATIVE    
            List<String> investigativeInterest = new List<String>();

            /*investigativeInterest.add(con.I_like_to_do_puzzles_like_sudoku__c);
            investigativeInterest.add(con.My_favourite_subject_in_school_college_i__c);
            investigativeInterest.add(con.I_enjoy_trying_to_gure_out_how_things__c);
            investigativeInterest.add(con.I_can_never_make_a_mistake_while_countin__c);
            investigativeInterest.add(con.I_am_good_at_calculating_how_much_to_pay__c);
            investigativeInterest.add(con.I_like_to_analyze_things_problems_and_s__c);
            investigativeInterest.add(con.I_like_working_with_numbers__c);
            investigativeInterest.add(con.I_am_good_at_math__c);
            //investigativeInterest.add(con.I_am_good_at_working_by_myself__c);

            Integer investigativeCount = 0;
            for (String interest : investigativeInterest) {
                if (String.isNotBlank(interest) && interest == 'Yes') {
                    investigativeCount++;
                }
            }
            if (investigativeCount>0)
                mp.put('Investigative', investigativeCount);*/
            
            // Artistic
            List<String> artisticInterest = new List<String>();
            
            /*artisticInterest.add(con.I_am_good_at_working_by_myself__c);
            artisticInterest.add(con.I_like_to_read_about_art_and_music__c);
            artisticInterest.add(con.I_like_writing_stories_plays_and_poems__c);
            artisticInterest.add(con.I_am_creative_person_I_like_to_make_gre__c);
            artisticInterest.add(con.I_like_to_play_instruments_or_sing_and_d__c);
            artisticInterest.add(con.I_like_acting_in_plays__c);
            artisticInterest.add(con.I_like_to_draw_and_paint__c);
            artisticInterest.add(con.My_friends_take_my_advice_on_what_to_wea__c);

            Integer artisticCount = 0;
            for (String interest : artisticInterest) {
                if (String.isNotBlank(interest) && interest == 'Yes') {
                    artisticCount++;
                }
            }
            if (artisticCount>0)
                mp.put('Artistic', artisticCount);*/
            
            // SOCIAL
            List<String> socialInterest = new List<String>();

            /*socialInterest.add(con.I_like_to_work_in_teams__c);
            socialInterest.add(con.I_like_to_teach_and_train_people__c);
            socialInterest.add(con.I_like_to_help_people_solve_their_proble__c);
            socialInterest.add(con.I_like_learning_about_where_people_come__c);
            socialInterest.add(con.I_like_to_listen_to_the_news_read_newspa__c);
            //socialInterest.add(con.I_like_to_organise_and_put_things_in__c);
            socialInterest.add(con.I_like_organizing_parties_and_get_togeth__c);
            socialInterest.add(con.I_like_helping_the_elderly__c);
            socialInterest.add(con.I_like_playing_team_games__c);

            Integer socialCount = 0;
            for (String interest : socialInterest) {
                if (String.isNotBlank(interest) && interest == 'Yes') {
                    socialCount++;
                }
            }
            if (socialCount>0)
                mp.put('Social', socialCount);*/
            
            // ENTERPRISING
            List<String> enterprisingInterest = new List<String>();
            
            /*enterprisingInterest.add(con.I_am_ambitious_and_set_goals_for_myself__c);
            enterprisingInterest.add(con.I_like_selling_things_and_convincing_peo__c);
            enterprisingInterest.add(con.I_am_quick_to_take_on_new_responsibiliti__c);
            enterprisingInterest.add(con.I_would_like_to_start_my_own_business__c);
            enterprisingInterest.add(con.I_like_to_lead_and_motivate_people__c);
            enterprisingInterest.add(con.I_like_to_give_speeches_talk_to_a_lot_o__c);
            enterprisingInterest.add(con.I_like_to_teach_my_friends_or_siblings__c);
            enterprisingInterest.add(con.I_like_to_take_on_responsibilities__c);

            Integer enterprisingCount = 0;
            for (String interest : enterprisingInterest) {
                if (String.isNotBlank(interest) && interest == 'Yes') {
                    enterprisingCount++;
                }
            }
            if (enterprisingCount > 0)
                mp.put('Enterprising', enterprisingCount);*/
            
            // CONVENTIONAL
            List<String> conventionalInterest = new List<String>();

            /*conventionalInterest.add(con.I_like_to_organise_and_put_things_in__c);
            conventionalInterest.add(con.I_like_to_have_clear_instructions_to_f__c);
            conventionalInterest.add(con.I_wouldn_t_mind_working_8hrs_per_day__c);
            conventionalInterest.add(con.I_pay_attention_to_detail_and_I_am_good__c);
            conventionalInterest.add(con.I_like_to_do_filling_and_typing__c);
            conventionalInterest.add(con.I_like_putting_things_together_and_ass__c);
            conventionalInterest.add(con.I_am_good_with_keeping_records_of_my_w__c);
            conventionalInterest.add(con.I_like_working_in_an_office__c);            
                
            Integer conventionalCount = 0;
            for (String interest : conventionalInterest) {
                if (String.isNotBlank(interest) && interest == 'Yes') {
                    conventionalCount++;
                }
            }
            if (conventionalCount>0)
                mp.put('Conventional', conventionalCount);*/
            
            /*interestList.add(realistCount);
            interestList.add(investigativeCount);
            interestList.add(artisticCount);
            interestList.add(socialCount);
            interestList.add(enterprisingCount);
            interestList.add(conventionalCount);
            
            interestList.sort();
            
            map<Integer, List<string>> mapCountWiseInterest = new map<Integer, List<string>>();
            
            for(string interest: mp.keyset()){
                Integer count = mp.get(interest);
                if(mapCountWiseInterest.containskey(count)){
                    mapCountWiseInterest.get(count).add(interest);
                } else {
                    mapCountWiseInterest.put(count, new List<string>{interest});
                }
            }
            system.debug('mapCountWiseInterest ::: '+mapCountWiseInterest);
            interestList.addall(mapCountWiseInterest.keyset());
            
            interestList.sort();*/
            
            /*for(Integer i = interestList.size()-1; i >= 0; i--){
                if(mapCountWiseInterest.containskey(interestList[i])){
                    List<string> lstInterest = mapCountWiseInterest.get(interestList[i]);
                    if(lstInterest.size() > 1){
                        boolean isFound = false;
                        for(string inte: lstInterest){
                            if(inte == con.Interest_1_Selected_By_Student__c || inte == con.Interest_2_Selected_By_Student__c ||
                                inte == con.Interest_3_Selected_By_Student__c){
                                highestInterest.add(inte);
                                isFound = true;
                                break;
                            }
                        }
                        if(!isFound){
                            highestInterest.add(lstInterest[0]);
                        }
                    } else if(lstInterest.size() > 0) {
                        highestInterest.add(lstInterest[0]);
                    }
                }
            }
            system.debug('highestInterest b::: '+highestInterest);
            if(highestInterest.size() < 3){
                for(Integer key: mapCountWiseInterest.keyset()){
                    for(string inte: mapCountWiseInterest.get(key)){
                        if(!highestInterest.contains(inte)){
                            highestInterest.add(inte);
                        }
                    }
                }
            }*/
            system.debug('highestInterest a::: '+highestInterest);
            /*for (Integer k = 0; k < 3; k++) {
                String maxKey = mp.isEmpty() ? null : new List<String>(mp.keyset())[0];
                for (String s1 : mp.keySet()) {
                    maxKey = mp.get(s1) > mp.get(maxKey) ? s1 : maxKey;}
                highestInterest.add(maxKey);
                mp.remove(maxKey);
            }*/
            
            
            //for  Aptitude  1 and Aptitude  2 logic
            
            /* aptitute 'Spatial' */
            //correctAns =[select Category__c from Question_Bank__c where Category1__c =:'Spatial'];
            //system.debug('mapAllQBCategoryWise Spatial before ::: '+mapAllQBCategoryWise.get('Spatial').size());
            //removed query and read from map
            correctAns = mapAllQBCategoryWise.containskey('Spatial') ? mapAllQBCategoryWise.get('Spatial') : new List<Question_Bank__c>();
            /*ans.add(con.S__c);
            ans.add(con.Spatial_Ability_Q_2__c);
            ans.add(con.Spatial_Ability_Q_3__c);
            ans.add(con.Spatial_Ability_Q_4__c);
            ans.add(con.Spatial_Ability_Q_5__c);
            ans.add(con.Spatial_Ability_Q_6__c);
            ans.add(con.Spatial_Ability_Q_7__c);
            ans.add(con.Spatial_Ability_Q_8__c);
            
            Integer count = 0;
            for (Integer j = 0; j < ans.size(); j++) {
                if (ans.get(j)!=null) {
                    if (correctAns.get(j).Category__c == ans.get(j)) {
                        count++; }
                }
            }
            if(count > 0)
                aptitute.put('Spatial', count);
                
            correctAns = new List<Question_Bank__c>();
            system.debug('mapAllQBCategoryWise Spatial after ::: '+mapAllQBCategoryWise.get('Spatial').size());
            ans.clear();
            System.debug('Spatial ' + count);*/
            /* aptitute 'Numerical'  */
            //correctAns = [select Category__c,Name from Question_Bank__c where Category1__c ='Numerical' order by Name];
            //removed query and read from map
            correctAns = mapAllQBCategoryWise.containskey('Numerical') ? mapAllQBCategoryWise.get('Numerical') : new List<Question_Bank__c>();
            /*ans.add(con.X21_46__c);
            ans.add(con.X32_19__c);
            ans.add(con.X141_90__c);
            ans.add(con.X53_13__c);
            ans.add(con.X96_37__c);
            ans.add(con.X329_183__c);
            ans.add(con.X25_16_4__c);
            ans.add(con.X125_58_16__c);
            count = 0;
            
            for (Integer j = 0; j < ans.size(); j++) {
                if (ans.get(j)!=null){
                    if (correctAns.get(j).Category__c == ans.get(j)) {
                        count++;
                    }
                }
            }
            if(count > 0)
            aptitute.put('Numerical', count);
            
            correctAns = new List<Question_Bank__c>();
            ans.clear();
            System.debug('Numerical ' + count);*/
            /* aptitute 'Abstract Reasoning'  */
            //correctAns =[select Category__c from Question_Bank__c where Category1__c =:'Abstract'];
            //removed query and read from map
            correctAns = mapAllQBCategoryWise.containskey('Abstract') ? mapAllQBCategoryWise.get('Abstract') : new List<Question_Bank__c>();
            /*ans.add(con.Abstract_Reasoning__c);
            ans.add(con.Abstract_Reasoning_Q_2__c);
            ans.add(con.Abstract_Reasoning_Q_3__c);
            ans.add(con.Abstract_Reasoning_Q_4__c);
            ans.add(con.Abstract_Reasoning_Q_5__c);
            ans.add(con.Abstract_Reasoning_Q_6__c);
            ans.add(con.Abstract_Reasoning_Q_7__c);
            ans.add(con.Abstract_Reasoning_Q_8__c);
            count = 0;
            for (Integer j = 0; j < ans.size(); j++) {
                if (ans.get(j)!=null){
                    if (correctAns.get(j).Category__c == ans.get(j)) {
                        count++;
                    }
                }
            }
            if(count > 0)
            aptitute.put('Abstract', count);
            
            correctAns = new List<Question_Bank__c>();
            ans.clear();
            System.debug('Abstract '+ count);*/
            
            /* aptitute 'Creative Ability'  */
            //correctAns =[select Category__c from Question_Bank__c where Category1__c =:'Creative'];
            //removed query and read from map
            correctAns = mapAllQBCategoryWise.containskey('Creative') ? mapAllQBCategoryWise.get('Creative') : new List<Question_Bank__c>();
            /*ans.add(con.Creative1__c);
            ans.add(con.Creative2__c);
            ans.add(con.Creative3__c);
            ans.add(con.Creative4__c);
            ans.add(con.Creative5__c);
            ans.add(con.Creative6__c);
            ans.add(con.Creative7__c);
            ans.add(con.Creative8__c);
            count = 0;
            for (Integer j = 0; j < ans.size(); j++) {
                if (ans.get(j)!=null){
                    //if (ans.get(j) == 'B' || ans.get(j) == 'C' || ans.get(j) == 'D') {
                    if(correctAns.get(j).Category__c.contains(ans.get(j))) {
                        count=count+1;
                    }
                }
            }
            if(count > 0)
            aptitute.put('Creative', count);
            
            correctAns = new List<Question_Bank__c>();
            ans.clear();
            System.debug('Creative '+ count);*/
            
            /* aptitute 'Mechanical Ability'  */
            //correctAns =[select Category__c from Question_Bank__c where Category1__c =:'Mechanical'];
            //removed query and read from map
            correctAns = mapAllQBCategoryWise.containskey('Mechanical') ? mapAllQBCategoryWise.get('Mechanical') : new List<Question_Bank__c>();
            /*ans.add(con.Mech1__c);
            ans.add(con.Mech2__c);
            ans.add(con.Mech3__c);
            ans.add(con.Mech4__c);
            ans.add(con.Mech5__c);
            ans.add(con.Mech6__c);
            ans.add(con.Mech7__c);
            ans.add(con.Mech8__c);
            count = 0;
            for (Integer j = 0; j < ans.size(); j++) {
                if (ans.get(j)!=null){
                    if (correctAns.get(j).Category__c == ans.get(j)) {
                        count++;
                    }
                }
            }
            if(count > 0)
            aptitute.put('Mechanical', count);
            
            correctAns = new List<Question_Bank__c>();
            ans.clear();
            System.debug('Mechanical '+ count);*/
            
            /* aptitute 'VERBAL Ability'  */
            //correctAns =[select Category__c from Question_Bank__c where Category1__c =:'Verbal'];
            //removed query and read from map
            correctAns = mapAllQBCategoryWise.containskey('Verbal') ? mapAllQBCategoryWise.get('Verbal') : new List<Question_Bank__c>();
            /*ans.add(con.Verbal1__c);
            ans.add(con.Verbal2__c);
            ans.add(con.Verbal3__c);
            ans.add(con.Verbal4__c);
            ans.add(con.Verbal5__c);
            ans.add(con.Verbal6__c);
            ans.add(con.Verbal7__c);
            ans.add(con.Verbal8__c);
            count = 0;
            for (Integer j = 0; j < ans.size(); j++) {
                if (ans.get(j)!=null){
                    if (correctAns.get(j).Category__c == ans.get(j)) {
                        count++;
                    }
                }
            }
            if(count > 0)
            aptitute.put('Verbal', count);
            
            correctAns = new List<Question_Bank__c>();
            ans.clear();
            
            System.debug('Verbal '+ count);
            System.debug('aptitute '+ aptitute);
            
            List<String> highestApti = new List<String>();
            
            map<Integer, List<string>> mapCountWiseAptitude = new map<Integer, List<string>>();
            
            for(string apti: aptitute.keyset()){
                Integer countapti = aptitute.get(apti);
                if(mapCountWiseAptitude.containskey(countapti)){
                    mapCountWiseAptitude.get(countapti).add(apti);
                } else {
                    mapCountWiseAptitude.put(countapti, new List<string>{apti});
                }
            }
            List<Integer> aptitudeList = new List<Integer>();
            
            aptitudeList.addall(mapCountWiseAptitude.keyset());
            
            aptitudeList.sort();*/
            
            /*for(Integer i = aptitudeList.size()-1; i >= 0; i--){
                if(mapCountWiseAptitude.containskey(aptitudeList[i])){
                    List<string> lstAptitude = mapCountWiseAptitude.get(aptitudeList[i]);
                    if(lstAptitude.size() > 1){
                        boolean isFound = false;
                        for(string apti: lstAptitude){
                            if(apti == con.Aptitude_1_Selected_By_Student__c || apti == con.Aptitude_2_Selected_By_Student__c  ||
                                apti == con.Aptitude_3_Selected_By_Student__c){
                                highestApti.add(apti);
                                isFound = true;
                                break;
                            }
                        }
                        if(!isFound){
                            highestApti.add(lstAptitude[0]);
                        }
                    } else if(lstAptitude.size() > 0) {
                        highestApti.add(lstAptitude[0]);
                    }
                }
            }*/
            /*if(highestApti.size() < 3){
                for(Integer key: mapCountWiseAptitude.keyset()){
                    for(string apti: mapCountWiseAptitude.get(key)){
                        if(!highestApti.contains(apti)){
                            highestApti.add(apti);
                        }
                    }
                }
            }*/
            /*for (Integer k = 0; k < 3; k++) {
                String maxKey = aptitute.isEmpty() ? null : new List<String>(aptitute.keyset())[0];
                for (String s1 : aptitute.keySet()) {
                    maxKey = aptitute.get(s1) > aptitute.get(maxKey) ? s1 : maxKey;
                }
                highestApti.add(maxKey);
                aptitute.remove(maxKey);
            }*/
            
            /* logic for Personality   */
            
            /*personalityList.add(con.Personality1__c);
            personalityList.add(con.Personality2__c);
            personalityList.add(con.Personality3__c);
            personalityList.add(con.Personality4__c);
            personalityList.add(con.Personality5__c);
            personalityList.add(con.Personality6__c);
            personalityList.add(con.Personality7__c);
            personalityList.add(con.Personality8__c);
            personalityList.add(con.Personality9__c);
            personalityList.add(con.Personality10__c);
            personalityList.add(con.Personality11__c);
            personalityList.add(con.Personality12__c);
            personalityList.add(con.Personality13__c);
            personalityList.add(con.Personality14__c);
            personalityList.add(con.Personality15__c);
            personalityList.add(con.Personality16__c);
            
            Contact student = new Contact();
            
            //for Personality 1 logic
            if (personalityList.get(8)!=null && personalityList.get(0)!=null){
                if (personalityList.get(0).equals('Agree') && personalityList.get(8).equals('Agree')){
                    student.Personality_1__c = 'Any';           
                }
                else if (personalityList.get(0).equals('Disagree') && personalityList.get(8).equals('Disagree')){
                    student.Personality_1__c = 'Any';  
                }
                else if (personalityList.get(0).equals('Agree') && personalityList.get(8).equals('Disagree')){
                    student.Personality_1__c = 'Introvert';  
                }
                else if (personalityList.get(0).equals('Disagree') && personalityList.get(8).equals('Agree')){
                    student.Personality_1__c = 'Extrovert';
                }
            }        
            //for Personality 2 logic
            if (personalityList.get(1)!=null && personalityList.get(9)!=null){
                if (personalityList.get(1).equals('Agree') && personalityList.get(9).equals('Agree')){
                    student.Personality_2__c = 'Any';           
                }
                else if (personalityList.get(1).equals('Disagree') && personalityList.get(9).equals('Disagree' )){
                    student.Personality_2__c = 'Any';  
                    
                }else if (personalityList.get(1).equals('Agree' ) && personalityList.get(9).equals('Disagree')){
                    student.Personality_2__c = 'Structured';  
                }
                else if (personalityList.get(1).equals('Disagree' ) && personalityList.get(9).equals('Agree')){
                    student.Personality_2__c = 'Creative';
                }
            }
            //for Personality 3 logic
            if (personalityList.get(4)!=null && personalityList.get(2)!=null){
                if (personalityList.get(2).equals('Agree') && personalityList.get(4).equals('Agree')){
                    student.Personality_3__c = 'Idealist';           
                }
                else if (personalityList.get(2).equals('Disagree') && personalityList.get(4).equals('Disagree')){
                    student.Personality_3__c = 'Practical';  
                }
                else if (personalityList.get(2).equals('Agree') && personalityList.get(4).equals('Disagree')){
                    student.Personality_3__c = 'Any' ;  
                }
                else if (personalityList.get(2).equals('Disagree') && personalityList.get(4).equals('Agree')){
                    student.Personality_3__c = 'Any';
                }
            }
            //for Personality 4 logic
            if (personalityList.get(3)!=null && personalityList.get(15)!=null){
                if (personalityList.get(3).equals('Agree') && personalityList.get(15).equals('Agree' )){
                    student.Personality_4__c = 'Dreamer';           
                }
                else if (personalityList.get(3).equals('Disagree') && personalityList.get(15).equals('Disagree')){
                    student.Personality_4__c = 'Realist';  
                }
                else if (personalityList.get(3).equals('Agree') && personalityList.get(15).equals('Disagree')){
                    student.Personality_4__c = 'Any';  
                }
                else if (personalityList.get(3).equals('Disagree' ) && personalityList.get(15).equals('Agree')){
                    student.Personality_4__c = 'Any';
                }
            }
            
            //for Personality 5 logic
            if (personalityList.get(5)!=null && personalityList.get(14)!=null){
                if (personalityList.get(5).equals('Agree') && personalityList.get(14).equals('Agree')){
                    student.Personality_5__c = 'Impulsive';          
                }
                else if (personalityList.get(5).equals('Disagree') && personalityList.get(14).equals('Disagree')){
                    student.Personality_5__c = 'Thoughtful';  
                }
                else if (personalityList.get(5).equals('Agree') && personalityList.get(14).equals('Disagree')){
                    student.Personality_5__c = 'Any';  
                }
                else if (personalityList.get(5).equals('Disagree') && personalityList.get(14).equals('Agree')){
                    student.Personality_5__c = 'Any';
                }
            }
            
            //for Personality 6 logic
            if (personalityList.get(6)!=null && personalityList.get(7)!=null){
                if (personalityList.get(6).equals('Agree') && personalityList.get(7).equals('Agree')){
                    student.Personality_6__c = 'Adventourous';          
                }
                else if (personalityList.get(6).equals('Disagree') && personalityList.get(7).equals('Disagree')){
                    student.Personality_6__c = 'Conservative';  
                }
                else if (personalityList.get(6).equals('Agree') && personalityList.get(7).equals('Disagree')){
                    student.Personality_6__c = 'Any';  
                }
                else if (personalityList.get(6).equals('Disagree' ) && personalityList.get(7).equals('Agree')){
                    student.Personality_6__c = 'Any';
                }
            }
            
            //for Personality 7 logic
            if (personalityList.get(10)!=null && personalityList.get(12)!=null){
                if (personalityList.get(10).equals('Agree') && personalityList.get(12).equals('Agree')){
                    student.Personality_7__c = 'Any';          
                }
                else if (personalityList.get(10).equals('Disagree') && personalityList.get(12).equals('Disagree')){
                    student.Personality_7__c = 'Any';  
                }
                else if (personalityList.get(10).equals('Agree') && personalityList.get(12).equals('Disagree')){
                    student.Personality_7__c = 'Quiet';  
                }
                else if (personalityList.get(10).equals('Disagree' ) && personalityList.get(12).equals('Agree')){
                    student.Personality_7__c = 'Talkative';
                }
            }
            //for Personality 8 logic
            
            if (personalityList.get(11)!=null && personalityList.get(13)!=null){
                if (personalityList.get(11).equals('Agree' ) && personalityList.get(13).equals('Agree')){
                    student.Personality_8__c = 'Any';          
                }
                else if (personalityList.get(11).equals('Disagree') && personalityList.get(13).equals('Disagree')){
                    student.Personality_8__c = 'Any';  
                }
                else if (personalityList.get(11).equals('Agree') && personalityList.get(13).equals('Disagree')){
                    student.Personality_8__c = 'Bold';  
                }
                else if (personalityList.get(11).equals('Disagree') && personalityList.get(13).equals('Agree')){
                    student.Personality_8__c = 'Shy';
                }
            }*/
            
            /*logic for Aspiration  1 and Aspiration  2*/
            PossibleCareers1=con.Possible_Careers_1__c;
            PossibleCareers2=con.Possible_Careers_2__c;
            PossibleCareers3=con.Possible_Careers_3__c;
            
            /*  logic for Reality   */
            /*Only responses need to be recorded*/
            
            /*if(highestInterest.size() > 0)
                con.Interest_1__c= highestInterest.get(0);
            if(highestInterest.size() > 1)
                con.Interest_2__c = highestInterest.get(1);
            if(highestInterest.size() > 2)
                con.Interest_3__c = highestInterest.get(2);
            if(highestApti.size() > 0)
                con.Aptitude_1__c = highestApti.get(0);
            if(highestApti.size() > 1)
                con.Aptitude_2__c = highestApti.get(1);
            if(highestApti.size() > 2)
                con.Aptitude_3__c = highestApti.get(2);*/
            /*con.Personality_1__c = student.Personality_1__c;
            con.Personality_2__c = student.Personality_2__c;
            con.Personality_3__c = student.Personality_3__c;
            con.Personality_4__c = student.Personality_4__c;
            con.Personality_5__c = student.Personality_5__c;
            con.Personality_6__c = student.Personality_6__c;
            con.Personality_7__c = student.Personality_7__c;
            con.Personality_8__c = student.Personality_8__c;*/
            /*con.Aspiration_1__c = PossibleCareers1;
            con.Aspiration_2__c = PossibleCareers2;
            con.Aspiration_3__c = PossibleCareers3;
            con.Reality_1__c = con.Reality1Self__c;
            con.Reality_2__c = con.Reality2Self__c;
            con.Reality_3__c = con.Reality3Self__c;
            if(con.Reality4Self__c != null) {
                if(con.Reality4Self__c == '50% - 80%'){
                    con.Reality_4__c = 'B';
                } else if(con.Reality4Self__c == 'Above 80%'){
                    con.Reality_4__c = 'C';
                } else {
                    con.Reality_4__c = 'A';
                }
            }
            con.Reality_5__c = con.Reality1Family__c;
            con.Reality_6__c = con.Reality2Family__c;
            con.Reality_7__c = con.Reality3Family__c;
            if(con.Reality4Family__c != null) {
                if(con.Reality4Family__c == '10-000 - 20-000'){
                    con.Reality_8__c = 'B';
                } else if(con.Reality4Family__c == '20-000+'){
                    con.Reality_8__c = 'C';
                } else {
                    con.Reality_8__c = 'A';
                }
            }*/
            
            
            /*calculation  possible career   */    
            /* Commented code on 2nd Feb by Kandisa - Moved code to Contact trigger*/
            /*careerOptions.add(PossibleCareers1);
            careerOptions.add(PossibleCareers2);
            careerOptions.add(PossibleCareers3);
            
            for (integer k=0; k< careerOptions.size(); k++){
                if (careerOptions.get(k) != null){
                    countOptions= countOptions + 1 ; }
            }
            
            con.possible_career_report__c = countOptions;*/
            
            /*calculation  students with correct answers*/  
            correctAns = new List<Question_Bank__c>();
            ans.clear();
            
            /* code commented by Kandisa on 30th Jan - code moved to trigger
            studentSelectUns.add(con.CCP_1__c);
            studentSelectUns.add(con.CCP_2__c);
            studentSelectUns.add(con.CCP_3__c);
            
            correctAns =[select Category__c from Question_Bank__c where Category1__c =:'Clarity' order by name Limit 3];
            unsList.add(correctAns.get(0).Category__c);
            unsList.add(correctAns.get(1).Category__c);
            unsList.add(correctAns.get(2).Category__c);
            
            if (studentSelectUns.get(0)!=null && studentSelectUns.get(1)!=null && studentSelectUns.get(2)!=null){
                if (unsList.get(0).contains(studentSelectUns.get(0)) && unsList.get(1).contains(studentSelectUns.get(1)) && unsList.get(2).contains(studentSelectUns.get(2))) {
                    careerStepUns = 'Yes';
                }
            }
            if (con.CCP_1__c == null && con.CCP_2__c== null && con.CCP_3__c == null) {
                careerStepUns = 'Data is not available';
            }
            con.Clarity_Report__c = careerStepUns;*/
            
            /* student attendance calculation */
            //commented as student attedence report field is created.
            /*String absentStudent = 'Students who Dropped-out';
            if (con.Day_1__c == 'Present' && con.Day_2__c == 'Present' && con.Day_5__c == 'Present') {
                absentStudent = 'Students who stayed Enrolled';
            }
            if (con.Day_1__c == null && con.Day_2__c == null && con.Day_5__c == null) {
                absentStudent = 'Data is not available'; 
            }
            con.Student_Attendance__c = absentStudent;*/
            //status added to update processed on 30th Jan by Kandisa
            con.Status__c='Processed';
            
            //upsert con; 
            /* Commented code on 30th Jan by Kandisa - Moved code to Contact trigger
            CareerAware cr=new CareerAware();
            cr.getCareerData(con);*/
        }
        update conData;
    }
}