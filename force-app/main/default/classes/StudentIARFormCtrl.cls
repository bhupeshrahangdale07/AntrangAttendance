/********************************************************************************************   
* NAME         : StudentIARFormCtrl
* DESCRIPTION  : This class is use to display and Save Student IAR Form data
*   
* @AUTHOR: Dev Team
* @DATE: 1st July 2021 
*   
********************************************************************************************/  

public without sharing class StudentIARFormCtrl{
    
    public static map<string,Explanations__c> mapofInterest;
    public static map<string,Explanations__c> mapofAptitude;
    public static map<string,string> mapRealityExplanations;
    public static map<String, List<string>> mapAllRealities;

    @AuraEnabled
    public static Object fetchStudentQuestionsAndAnswers(String testName, String strLanguage, String contactId){
        Map<String, object> result = new Map<String, object>();
        WrpStudentQuestionAnswer objWrpStudentQuestionAnswer = new WrpStudentQuestionAnswer();
        List<Contact> lstContact = new List<Contact>([Select Id, Name,Submitted_Page__c from Contact where Id = :contactId]);
        
        string requestedPage = '';
        if(testName == 'Interest'){
            requestedPage = 'I';
        } else if(testName == 'Aptitude'){
            requestedPage = 'A';
        } else if(testName == 'Reality'){
            requestedPage = 'R';
        }
        
        boolean pageExist = false;
        if(lstContact.size() > 0){
            if(lstContact.get(0).Submitted_Page__c != null){
                if(lstContact.get(0).Submitted_Page__c.contains(requestedPage)){
                    pageExist = true;
                } 
            } 
            result.put('PageExist',pageExist);
            
            if(!pageExist){
                Map<Id,Temporary_Student_Data__c> QueVsTempId = new Map<Id,Temporary_Student_Data__c>();
                List<Student_Feedback_mapping__c> lstStudentFeedbackMapping = new List<Student_Feedback_mapping__c>([
                    SELECT
                    Id,
                    Question_Label__c, 
                    Order_of_Question__c, 
                    Display_Type__c, 
                    Display_Number__c,
                    (SELECT
                     Id,
                     Name, 
                     Form_value__c, 
                     Order__c, 
                     SF_Value__c, 
                     Student_Feedback_mapping__c 
                     FROM Picklist_Mappings__r
                     ORDER BY Order__c ASC)
                    
                    FROM Student_Feedback_mapping__c
                    WHERE Day_Number__c = :testName
                    AND Language__c = :strLanguage
                    ORDER BY Order_of_Question__c ASC
                ]);
                
                for(Temporary_Student_Data__c tempStudentIARLST : [
                    Select Id,Question__c,Answer__c From Temporary_Student_Data__c where 
                    Student__c = :contactId AND 
                    Question__r.Day_Number__c = :testName AND 
                    Question__r.Language__c = :strLanguage 
                ]) {
                    QueVsTempId.put(tempStudentIARLST.Question__c,tempStudentIARLST);
                }
                
                for(Student_Feedback_mapping__c objSFM : lstStudentFeedbackMapping){
                    WrpStudentQuestion objWrpStudentQuestion = new WrpStudentQuestion();
                    objWrpStudentQuestion.tempObjectId = QueVsTempId.containsKey(objSFM.Id) ? QueVsTempId.get(objSFM.Id).Id : null;
                    objWrpStudentQuestion.questionId = objSFM.Id;
                    objWrpStudentQuestion.questionLabel = objSFM.Question_Label__c;
                    objWrpStudentQuestion.displayNumber = String.valueOf(objSFM.Display_Number__c);
                    objWrpStudentQuestion.orderOfQuestion = Integer.valueof(objSFM.Order_of_Question__c);
                    objWrpStudentQuestion.fieldType = objSFM.Display_Type__c;
                    objWrpStudentQuestion.answerId = QueVsTempId.containsKey(objSFM.Id) ? QueVsTempId.get(objSFM.Id).Answer__c : null;
                    
                    for(Picklist_Mapping__c objPM : objSFM.Picklist_Mappings__r){
                        WrpStudentAnswer objWrpStudentAnswer = new WrpStudentAnswer();
                        objWrpStudentAnswer.answerId = objPM.Id;
                        objWrpStudentAnswer.formValue = objPM.Form_value__c;
                        objWrpStudentAnswer.order = Integer.valueof(objPM.Order__c);
                        objWrpStudentQuestion.lstWrpStudentAnswer.add(objWrpStudentAnswer);
                    }
                    
                    objWrpStudentQuestionAnswer.lstWrpStudentQuestion.add(objWrpStudentQuestion);
                }
                
                objWrpStudentQuestionAnswer.objContact = lstContact.size() > 0 ? lstContact[0] : null;
                result.put('data',objWrpStudentQuestionAnswer);
            }
        }
        return result;
    }
    
    @AuraEnabled
    public static object verifyStudentSubmittedExam(String contactId, String currPage){
        Map<String,Object> result = new Map<String,Object>();
        List<Contact> lstContact = new List<Contact>([Select Id, Name,Submitted_Page__c,MobilePhone from Contact where Id = :contactId]);
        
        if(lstContact.get(0).Submitted_Page__c != null && lstContact.get(0).Submitted_Page__c.contains(currPage)){
            result.put('isStdSubmittedExam', true);
        } else {
            result.put('isStdSubmittedExam', false);
        }
        result.put('whatsupnumber', lstContact.get(0).MobilePhone);
        //result.put('isStdSubmittedExam', false);
        return result;
    }
    
    @AuraEnabled
    public static void saveWhatsappnum(String conId, String whatsappnumber){
        Contact con = new Contact(Id = conId);
        con.MobilePhone = whatsappnumber;
        update con;
    }
    
    @AuraEnabled
    public static WrpQuestionImage fetchQuestionImage(String questionId){

        List<ContentDocumentLink> lstCDL = new List<ContentDocumentLink>([
            SELECT 
                ContentDocumentId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :questionId
        ]);

        if(lstCDL.size() > 0){

            List<ContentVersion> lstCV = new List<ContentVersion>([
                SELECT 
                    VersionData,
                    FileType  
                FROM ContentVersion 
                WHERE ContentDocumentId = :lstCDL[0].ContentDocumentId
            ]);

            if(lstCV.size() > 0){
                WrpQuestionImage objWrpQuestionImage = new WrpQuestionImage();
                objWrpQuestionImage.fileType = lstCV[0].FileType;
                objWrpQuestionImage.fileData = EncodingUtil.base64Encode(lstCV[0].VersionData);
                return objWrpQuestionImage;
            }
            
        }
        return null;
    }
    
    @AuraEnabled
    public static List<WrpStudentQuestion> saveTemporaryStudentIAR(List<WrpStudentQuestion> temporaryStudentQuestions,String contactId, String actionName, String submittedPage, String submittedPageName){
        List<WrpStudentQuestion> lstTemporaryStudentQuestions = new List<WrpStudentQuestion>();
        List<Temporary_Student_Data__c> upsertToTemporaryStudentIAR = new List<Temporary_Student_Data__c>();
        Map<String,String> mapTemporaryStudentQuestions = new Map<String,String>();
        
        for(WrpStudentQuestion objWSQ: temporaryStudentQuestions){
            Temporary_Student_Data__c objTSIAR = objWSQ.tempObjectId != null ? new Temporary_Student_Data__c(Id = objWSQ.tempObjectId) : new Temporary_Student_Data__c();
            objTSIAR.Answer__c = objWSQ.answerId;
            objTSIAR.Question__c = objWSQ.questionId;
            objTSIAR.Student__c = contactId;
            upsertToTemporaryStudentIAR.add(objTSIAR);
        }
        
        if(upsertToTemporaryStudentIAR.size() > 0){
            Upsert upsertToTemporaryStudentIAR;
        }
        
        for(Temporary_Student_Data__c objTSIAR : upsertToTemporaryStudentIAR){
            if(objTSIAR.Question__c != null){
                mapTemporaryStudentQuestions.put(objTSIAR.Question__c, objTSIAR.Id);
            }
        }
        
        for(WrpStudentQuestion objWSQ: temporaryStudentQuestions){
            WrpStudentQuestion objWrpStudentQuestion = objWSQ;
            
            if(mapTemporaryStudentQuestions.containskey(objWSQ.questionId)){
                objWrpStudentQuestion.tempObjectId = mapTemporaryStudentQuestions.get(objWSQ.questionId);
            }
            lstTemporaryStudentQuestions.add(objWrpStudentQuestion);
        }
        
        if(actionName == 'submit'){
            submitExam(temporaryStudentQuestions, contactId, submittedPage, submittedPageName);
        }
        
        return lstTemporaryStudentQuestions;
    }
    
    public static void submitExam(List<WrpStudentQuestion> finalStudentQuestions, String currentUserId, String currentPage, String currentPageName){
        Set<Id> setTempObjectIds = new Set<Id>();
        
        for(WrpStudentQuestion objWSQ: finalStudentQuestions){
            setTempObjectIds.add(objWSQ.tempObjectId);
        }
        
        List<Temporary_Student_Data__c> lstTemporaryStudentIAR = new List<Temporary_Student_Data__c>([
            SELECT
                Id,
                Answer__r.SF_Value__c,
                Question__r.Field_API__c,
                Student__c
            FROM Temporary_Student_Data__c
            WHERE Id = :setTempObjectIds
            AND Answer__c != null
            AND Student__c = :currentUserId
        ]);
        
        Contact con = [Select Id,Submitted_Page__c From Contact where Id = :currentUserId];
        String submittedpage = con.Submitted_Page__c;
        
        if(String.isNotBlank(submittedpage)){
            if(!submittedpage.contains(currentPage)){
                submittedpage += ';' + currentPage;
            }
        } else {
            submittedpage = currentPage;
        }
        
        Contact objContact = new Contact(Id = currentUserId);
        
        for(Temporary_Student_Data__c objTSIAR: lstTemporaryStudentIAR){
            objContact.put(objTSIAR.Question__r.Field_API__c, objTSIAR.Answer__r.SF_Value__c);
        }
        
        //Move Studnet Answer on Student record from Temporary Student Question and Answer records
        if(objContact.Id != null){
            objContact.Submitted_Page__c = submittedpage;
            Update objContact;
            contactIARAttendance(objContact.Id, currentPageName);
        }
        
        //Delete Temporary Student IAR Records
        if(setTempObjectIds.size() > 0){
            Delete [SELECT Id FROM Temporary_Student_Data__c WHERE Id = :setTempObjectIds];
        }
        
        //Will return student result.
    }
    
    @AuraEnabled
    public static Object studentResult(String conId,String currPage,String language){
        
        List<String> highestInterest = new List<String>();
        Map<String, Object> result = new Map<String, Object>();
        map<Integer, List<string>> mapCountWiseInterest = new map<Integer, List<string>>();
        /*if(currPage == 'I'){
            List<Contact> conData = [Select Id,I_like_to_repair_mobiles__c,I_like_to_build_things_like_shoe_racks__c,
                                     I_like_to_take_care_of_animals__c,I_like_to_cook__c,I_am_a_practical_person__c,
                                     I_like_working_outside__c,I_like_to_heal_or_cure_people__c,I_like_to_grow_plants__c,
                                     I_like_to_do_puzzles_like_sudoku__c,My_favourite_subject_in_school_college_i__c,
                                     I_enjoy_trying_to_gure_out_how_things__c,I_can_never_make_a_mistake_while_countin__c,
                                     I_am_good_at_calculating_how_much_to_pay__c,I_like_to_analyze_things_problems_and_s__c,
                                     I_like_working_with_numbers__c,I_am_good_at_math__c,I_am_good_at_working_by_myself__c,
                                     I_like_to_read_about_art_and_music__c,I_like_writing_stories_plays_and_poems__c,
                                     I_am_creative_person_I_like_to_make_gre__c,I_like_to_play_instruments_or_sing_and_d__c,
                                     I_like_acting_in_plays__c,I_like_to_draw_and_paint__c,
                                     My_friends_take_my_advice_on_what_to_wea__c,I_like_to_work_in_teams__c,
                                     I_like_to_teach_and_train_people__c,I_like_to_help_people_solve_their_proble__c,
                                     I_like_learning_about_where_people_come__c,I_like_to_listen_to_the_news_read_newspa__c,
                                     I_like_organizing_parties_and_get_togeth__c,I_like_helping_the_elderly__c,
                                     I_like_playing_team_games__c,I_am_ambitious_and_set_goals_for_myself__c,
                                     I_like_selling_things_and_convincing_peo__c,I_am_quick_to_take_on_new_responsibiliti__c,
                                     I_would_like_to_start_my_own_business__c,I_like_to_lead_and_motivate_people__c,
                                     I_like_to_give_speeches_talk_to_a_lot_o__c,I_like_to_teach_my_friends_or_siblings__c,
                                     I_like_to_take_on_responsibilities__c,I_like_to_organise_and_put_things_in__c,
                                     I_like_to_have_clear_instructions_to_f__c,I_wouldn_t_mind_working_8hrs_per_day__c,
                                     I_pay_attention_to_detail_and_I_am_good__c,I_like_to_do_filling_and_typing__c,
                                     I_like_putting_things_together_and_ass__c,I_am_good_with_keeping_records_of_my_w__c,
                                     I_like_working_in_an_office__c,Interest_1_Selected_By_Student__c,
                                     Interest_2_Selected_By_Student__c,Interest_3_Selected_By_Student__c
                                     From Contact where Id = :conId];
            for (Contact con : conData) 
            {
                List<Integer> interestList = new List<Integer>(); 
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
                
                realistInterest.add(con.I_like_to_repair_mobiles__c);
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
                    mp.put('Realist', realistCount);  
                
                // INVESTIGATIVE    
                List<String> investigativeInterest = new List<String>();
                
                investigativeInterest.add(con.I_like_to_do_puzzles_like_sudoku__c);
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
                    mp.put('Investigative', investigativeCount);
                
                // Artistic
                List<String> artisticInterest = new List<String>();
                
                artisticInterest.add(con.I_am_good_at_working_by_myself__c);
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
                    mp.put('Artistic', artisticCount);
                
                // SOCIAL
                List<String> socialInterest = new List<String>();
                
                socialInterest.add(con.I_like_to_work_in_teams__c);
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
                    mp.put('Social', socialCount);
                
                // ENTERPRISING
                List<String> enterprisingInterest = new List<String>();
                
                enterprisingInterest.add(con.I_am_ambitious_and_set_goals_for_myself__c);
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
                    mp.put('Enterprising', enterprisingCount);
                
                // CONVENTIONAL
                List<String> conventionalInterest = new List<String>();
                
                conventionalInterest.add(con.I_like_to_organise_and_put_things_in__c);
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
                    mp.put('Conventional', conventionalCount);
                
                for(string interest: mp.keyset()){
                    Integer count = mp.get(interest);
                    if(mapCountWiseInterest.containskey(count)){
                        mapCountWiseInterest.get(count).add(interest);
                    } else {
                        mapCountWiseInterest.put(count, new List<string>{interest});
                    }
                }
                
                interestList.addall(mapCountWiseInterest.keyset());
                interestList.sort();
                
                integer cntRes = 0;
                Map<String, Integer> resultInt = new Map<String, Integer>();
                for(Integer j = interestList.size()-1; j>=0;j--){
                    if(cntRes < 3){
                        if(mapCountWiseInterest.get(interestList[j]).size() > 1){
                            for(integer i = 0 ; mapCountWiseInterest.get(interestList[j]).size() > i ; i++){
                                resultInt.put(mapCountWiseInterest.get(interestList[j])[i],interestList[j]);
                                cntRes++;
                            }
                        } else {
                            resultInt.put(mapCountWiseInterest.get(interestList[j])[0],interestList[j]);
                            cntRes++;
                        }
                    } else {
                        break;
                    }
                }
                
                for(Integer i = interestList.size()-1; i >= 0; i--){
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
                
                if(highestInterest.size() < 3){
                    for(Integer key: mapCountWiseInterest.keyset()){
                        for(string inte: mapCountWiseInterest.get(key)){
                            if(!highestInterest.contains(inte)){
                                highestInterest.add(inte);
                            }
                        }
                    }
                }
                
                List<resultWrapper> resWrapp = new List<resultWrapper>();
                Integer cnt = 1;
                Set<String> strLST = resultInt.keyset();
                for(String str : resultInt.keyset()){    
                    if(cnt == 1){
                        con.Interest_1__c= str;
                    } else if(cnt == 2){
                        con.Interest_2__c= str;
                    } else if(cnt == 3){
                        con.Interest_3__c= str;
                    }
                    
                    resultWrapper res = new resultWrapper();
                    if(language == 'eng'){
                        if(str == 'Realist'){
                            res.label = '<br/>Realistic <br/>(Like working with tools, machines, plants or animals)';     
                        } else if(str == 'Investigative'){
                            res.label = '<br/>Investigative <br/>(Like solving puzzles, finding solutions or subjects like Science)';     
                        } else if(str == 'Artistic'){
                            res.label = '<br/>Artistic <br/>(Like music, art, dance, drama, writing)';     
                        } else if(str == 'Social'){
                            res.label = '<br/>Social <br/>(Like helping or teaching others)';     
                        } else if(str == 'Enterprising'){
                            res.label = '<br/>Enterprising <br/>(Like to lead others or work in teams)';     
                        } else if(str == 'Conventional'){
                            res.label = '<br/>Conventional <br/>(Like filing, typing, organizing things or working with numbers)';     
                        }
                    } else if(language == 'hin'){
                        if(str == 'Realist'){
                            res.label = '<br/>यथार्थवादी <br/>(जैसे औजारों, मशीनों, पौधों या जानवरों के साथ काम करना)';     
                        } else if(str == 'Investigative'){
                            res.label = '<br/>खोजी <br/>(जैसे पहेलियाँ सुलझाना, समाधान ढूँढ़ना या विज्ञान जैसे विषय)';     
                        } else if(str == 'Artistic'){
                            res.label = '<br/>कलात्मक <br/>(जैसे संगीत, कला, नृत्य, नाटक, लेखन)';     
                        } else if(str == 'Social'){
                            res.label = '<br/>सामाजिक <br/>(जैसे दूसरों की मदद करना या सिखाना)';     
                        } else if(str == 'Enterprising'){
                            res.label = '<br/>उद्यमी <br/>(दूसरों का नेतृत्व करना या टीमों में काम करना पसंद करते हैं)';     
                        } else if(str == 'Conventional'){
                            res.label = '<br/>परम्परागत <br/>(जैसे फाइल करना, टाइप करना, चीजों को व्यवस्थित करना या नंबरों के साथ काम करना)';     
                        }
                    } else if(language == 'mar'){
                        if(str == 'Realist'){
                            res.label = '<br/>वास्तववादी <br/>(साधने, मशीन, वनस्पती किंवा प्राण्यांसह काम करण्यासारखे)';     
                        } else if(str == 'Investigative'){
                            res.label = '<br/>अन्वेषक <br/>(जसे कोडी सोडवणे, उपाय शोधणे किंवा विज्ञानासारखे विषय)';     
                        } else if(str == 'Artistic'){
                            res.label = '<br/>कलात्मक <br/>(संगीत, कला, नृत्य, नाटक, लेखन यासारखे)';     
                        } else if(str == 'Social'){
                            res.label = '<br/>सामाजिक <br/>(इतरांना मदत करणे किंवा शिकवण्यासारखे)';     
                        } else if(str == 'Enterprising'){
                            res.label = '<br/>एंटरप्रायझिंग <br/>(इतरांचे नेतृत्व करणे किंवा संघात काम करणे आवडते)';     
                        } else if(str == 'Conventional'){
                            res.label = '<br/>पारंपारिक <br/>(जसे फाईल करणे, टाइप करणे, गोष्टींचे आयोजन करणे किंवा संख्यांसह कार्य करणे)';     
                        }
                    } else if(language == 'Urdu'){
                        if(str == 'Realist'){
                            res.label = '<br/>ریالسٹک <br/>(اوزاروں ، مشینوں، پیڑ پودوں، جانوروں کے ساتھ کام کرنا اچھا لگتا ہے)';     
                        } else if(str == 'Investigative'){
                            res.label = '<br/>انویسٹیگیٹو <br/>(پہیلی حل کرنا ، مسئلے حل کرنا ، اور سائنس جیسے مضامین پڑھنا پسند ہے)';     
                        } else if(str == 'Artistic'){
                            res.label = '<br/>آرٹسٹک <br/>(گانا ،اداکاری ، رقص ، ڈراما، کہانیاں نظمیں لکھنا پسند ہے)';     
                        } else if(str == 'Social'){
                            res.label = '<br/>سوشل <br/>(دوسروں کی مدد کرنا یا کچھ سیکھا نا پسند ہے)';     
                        } else if(str == 'Enterprising'){
                            res.label = '<br/>انٹرپرائزنگ <br/>(دوسروں کا لیڈر بننا یا ٹیموں میں کام کرنا)';     
                        } else if(str == 'Conventional'){
                            res.label = '<br/>کنوینشننل <br/>(جیسے فائل کرنا ، ٹائپ کرنا ، چیزوں کو ترتیب دینا یا نمبروں کے ساتھ کام کرنا)';     
                        }
                    }

                    if(cnt < 4){
                        String s = '<b>' + res.label + '</b>';
                        res.label = s;
                        res.value = '<br/><b>'+String.valueOf(resultInt.get(str))+'</b>';
                    } else {
                        String s = '<I>' + res.label + '</I>';
                        res.label = s;
                        res.value = '<br/><I>'+String.valueOf(resultInt.get(str))+'</I>';
                    }
                    resWrapp.add(res);
                    cnt++;
                }
                result.put('result',resWrapp);
            }
            update conData;
            String fieldName = '';
            if(language == 'eng'){
            	fieldName = 'Label_for_the_Assessment_form__c';
            } else if(language == 'hin'){
            	fieldName = 'Hindi_Label_for_the_Assessment_form__c';
            } else if(language == 'mar'){
            	fieldName = 'Marathi_Label_for_the_Assessment_form__c';
            } else if(language == 'Urdu'){
            	fieldName = 'Urdu_Label_for_the_Assessment_form__c';
            }
            
            String inteQuery = 'Select Id,'+fieldName+' From IARP_Master__c where Is_Active__c = true and '+
                '(Interest_1__c = \''+highestInterest.get(0)+'\' or Interest_2__c = \''+highestInterest.get(1)+
                '\' or Interest_3__c = \''+highestInterest.get(2)+'\') limit 6';
            system.debug('inteQuery : ' + inteQuery);
            result.put('careerInterest',database.query(inteQuery));
        } 
        else if(currPage == 'R'){
            
            List<Contact> conData = [Select Id,Reality1Self__c,Reality2Self__c,Reality3Self__c,Reality4Self__c,
                                     Reality1Family__c,Reality2Family__c,Reality3Family__c,Reality4Family__c,Reality_4__c,
                                     Reality_8__c
                                     From Contact where Id = :conId];
            for (Contact con : conData) 
            {
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
                }
            }
            update conData;
            
            FillDefaultDetails(language);
            
            mapAllRealities = new map<String, List<string>>();
            if (conData.get(0).Reality_1__c == 'Yes' && mapRealityExplanations.containskey('1Yes')){
                mapAllRealities.put('One', new List<string>{mapRealityExplanations.get('1Yes')});
            } else if(conData.get(0).Reality_1__c == 'No' && mapRealityExplanations.containskey('1No')) { 
                mapAllRealities.put('One', new List<string>{mapRealityExplanations.get('1No')});
            }
            if (conData.get(0).Reality_2__c=='Yes' && mapRealityExplanations.containskey('2Yes')){
                if(mapAllRealities.containskey('One')){
                    mapAllRealities.get('One').add(mapRealityExplanations.get('2Yes'));
                } else {
                    mapAllRealities.put('One',new List<string>{mapRealityExplanations.get('2Yes')});
                }
            } else if(conData.get(0).Reality_2__c=='No' && mapRealityExplanations.containskey('2No')){ 
                if(mapAllRealities.containskey('One')){
                    mapAllRealities.get('One').add(mapRealityExplanations.get('2No'));
                } else {
                    mapAllRealities.put('One',new List<string>{mapRealityExplanations.get('2No')});
                }
            }
            if (conData.get(0).Reality_3__c=='Yes' && mapRealityExplanations.containskey('3Yes')){
                mapAllRealities.put('Two', new List<string>{mapRealityExplanations.get('3Yes')});
            } else if(conData.get(0).Reality_3__c=='No' && mapRealityExplanations.containskey('3No')) { 
                mapAllRealities.put('Two', new List<string>{mapRealityExplanations.get('3No')});
            }
            if(conData.get(0).Reality_4__c=='B' && mapRealityExplanations.containskey('4B')) { 
                if(mapAllRealities.containskey('Two')){
                    mapAllRealities.get('Two').add(mapRealityExplanations.get('4B'));
                } else {
                    mapAllRealities.put('Two',new List<string>{mapRealityExplanations.get('4B')});
                }
            } else  if(conData.get(0).Reality_4__c=='C' && mapRealityExplanations.containskey('4C')) { 
                if(mapAllRealities.containskey('Two')){
                    mapAllRealities.get('Two').add(mapRealityExplanations.get('4C'));
                } else {
                    mapAllRealities.put('Two',new List<string>{mapRealityExplanations.get('4C')});
                }
            } else if (conData.get(0).Reality_4__c=='A' && mapRealityExplanations.containskey('4A')){
                if(mapAllRealities.containskey('Two')){
                    mapAllRealities.get('Two').add(mapRealityExplanations.get('4A'));
                } else {
                    mapAllRealities.put('Two',new List<string>{mapRealityExplanations.get('4A')});
                }
            }
            if (conData.get(0).Reality_5__c=='Yes' && mapRealityExplanations.containskey('5Yes')){
                mapAllRealities.put('Three', new List<string>{mapRealityExplanations.get('5Yes')});
            } else  if(conData.get(0).Reality_5__c=='No' && mapRealityExplanations.containskey('5No')) { 
                mapAllRealities.put('Three', new List<string>{mapRealityExplanations.get('5No')});
            }
            if (conData.get(0).Reality_6__c=='Yes' && mapRealityExplanations.containskey('6Yes')){
                if(mapAllRealities.containskey('Three')){
                    mapAllRealities.get('Three').add(mapRealityExplanations.get('6Yes'));
                } else {
                    mapAllRealities.put('Three',new List<string>{mapRealityExplanations.get('6Yes')});
                }
            } else  if(conData.get(0).Reality_6__c=='No' && mapRealityExplanations.containskey('6No')) { 
                if(mapAllRealities.containskey('Three')){
                    mapAllRealities.get('Three').add(mapRealityExplanations.get('6No'));
                } else {
                    mapAllRealities.put('Three',new List<string>{mapRealityExplanations.get('6No')});
                }
            }
            if (conData.get(0).Reality_7__c=='Yes' && mapRealityExplanations.containskey('7Yes')){
                mapAllRealities.put('Four', new List<string>{mapRealityExplanations.get('7Yes')});
            } else if(conData.get(0).Reality_7__c=='No' && mapRealityExplanations.containskey('7No')) { 
                mapAllRealities.put('Four', new List<string>{mapRealityExplanations.get('7No')});
            }
            if(conData.get(0).Reality_8__c=='B' && mapRealityExplanations.containskey('8B')) { 
                //mapAllRealities.get(4).add(mapRealityExplanations.get('8B'));
                if(mapAllRealities.containskey('Four')){
                    mapAllRealities.get('Four').add(mapRealityExplanations.get('8B'));
                } else {
                    mapAllRealities.put('Four',new List<string>{mapRealityExplanations.get('8B')});
                }
            } else if(conData.get(0).Reality_8__c=='C' && mapRealityExplanations.containskey('8C')) { 
                if(mapAllRealities.containskey('Four')){
                    mapAllRealities.get('Four').add(mapRealityExplanations.get('8C'));
                } else {
                    mapAllRealities.put('Four',new List<string>{mapRealityExplanations.get('8C')});
                }
            } else if (conData.get(0).Reality_8__c=='A' && mapRealityExplanations.containskey('8A')){
                if(mapAllRealities.containskey('Four')){
                    mapAllRealities.get('Four').add(mapRealityExplanations.get('8A'));
                } else {
                    mapAllRealities.put('Four',new List<string>{mapRealityExplanations.get('8A')});
                }
            }
            
            result.put('result',mapAllRealities);
            
            String fieldName = '';
            if(language == 'eng'){
            	fieldName = 'Label_for_the_Assessment_form__c';
            } else if(language == 'hin'){
            	fieldName = 'Hindi_Label_for_the_Assessment_form__c';
            } else if(language == 'mar'){
            	fieldName = 'Marathi_Label_for_the_Assessment_form__c';
            } else if(language == 'Urdu'){
            	fieldName = 'Urdu_Label_for_the_Assessment_form__c';
            } 
            String reality4 = '%'+conData.get(0).Reality_4__c+'%';
            String reality8 = '%'+conData.get(0).Reality_8__c+'%';
            String inteQuery = 'Select Id,'+fieldName+' From IARP_Master__c where Is_Active__c = true and '+
                '((Reality_1__c = \'Any\' or Reality_1__c = \''+conData.get(0).Reality_1__c+'\')'+
                ' and (Reality_2__c = \'Any\' or Reality_2__c = \''+conData.get(0).Reality_2__c+'\')'+
                ' and (Reality_3__c = \'Any\' or Reality_3__c = \''+conData.get(0).Reality_3__c+'\')'+
                ' and (Reality_4__c = \'Any\' or Reality_4__c Like \''+reality4+'\')'+
                ' and (Reality_5__c = \'Any\' or Reality_5__c = \''+conData.get(0).Reality_5__c+'\')'+
                ' and (Reality_6__c = \'Any\' or Reality_6__c = \''+conData.get(0).Reality_6__c+'\')'+
                ' and (Reality_7__c = \'Any\' or Reality_7__c = \''+conData.get(0).Reality_7__c+'\')'+
                ' and (Reality_8__c = \'Any\' or Reality_8__c = \''+reality8+'\')) limit 6';
            system.debug('inteQuery ' + inteQuery);
            result.put('careerInterest',database.query(inteQuery));
            system.debug('data ' + result.get('careerInterest'));
        }
        else if(currPage == 'A'){
            map<string, List<Question_Bank__c>> mapAllQBCategoryWise = Utility.getAllCategorywiseQuestions();
            List<String> ans = new List<String>();
            List<String> highestApti = new List<String>();
            Map<String, Integer> aptitute = new Map<String, Integer>();
            List<Contact> conData = [Select Id,S__c,Spatial_Ability_Q_2__c,Spatial_Ability_Q_3__c,Spatial_Ability_Q_4__c,
                                     Spatial_Ability_Q_5__c,Spatial_Ability_Q_6__c,Spatial_Ability_Q_7__c,
                                     Spatial_Ability_Q_8__c,X21_46__c,X32_19__c,X141_90__c,X53_13__c,X96_37__c,X329_183__c,
                                     X25_16_4__c,X125_58_16__c,Abstract_Reasoning__c,Abstract_Reasoning_Q_2__c,
                                     Abstract_Reasoning_Q_3__c,Abstract_Reasoning_Q_4__c,Abstract_Reasoning_Q_5__c,
                                     Abstract_Reasoning_Q_6__c,Abstract_Reasoning_Q_7__c,Abstract_Reasoning_Q_8__c,
                                     Creative1__c,Creative2__c,Creative3__c,Creative4__c,Creative5__c,Creative6__c,
                                     Creative7__c,Creative8__c,Mech1__c,Mech2__c,Mech3__c,Mech4__c,Mech5__c,Mech6__c,
                                     Mech7__c,Mech8__c,Verbal1__c,Verbal2__c,Verbal3__c,Verbal4__c,Verbal5__c,Verbal6__c,
                                     Verbal7__c,Verbal8__c,Aptitude_1__c,Aptitude_2__c,Aptitude_3__c,Aptitude_1_Selected_By_Student__c,
                                     Aptitude_2_Selected_By_Student__c,Aptitude_3_Selected_By_Student__c
                                     From Contact where Id = :conId];
            for (Contact con : conData) 
            {
                List<Question_Bank__c> correctAns = new List<Question_Bank__c>();
                system.debug('mapAllQBCategoryWise : ' + mapAllQBCategoryWise);
                correctAns = mapAllQBCategoryWise.containskey('Spatial') ? mapAllQBCategoryWise.get('Spatial') : new List<Question_Bank__c>();
                system.debug('correctAns : ' + correctAns);
                ans.add(con.S__c);
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
                System.debug('Spatial ' + count);
                
                //correctAns = [select Category__c,Name from Question_Bank__c where Category1__c ='Numerical' order by Name];
                //removed query and read from map
                correctAns = mapAllQBCategoryWise.containskey('Numerical') ? mapAllQBCategoryWise.get('Numerical') : new List<Question_Bank__c>();
                ans.add(con.X21_46__c);
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
                System.debug('Numerical ' + count);
                
                //correctAns =[select Category__c from Question_Bank__c where Category1__c =:'Abstract'];
                //removed query and read from map
                correctAns = mapAllQBCategoryWise.containskey('Abstract') ? mapAllQBCategoryWise.get('Abstract') : new List<Question_Bank__c>();
                ans.add(con.Abstract_Reasoning__c);
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
                System.debug('Abstract '+ count);
                
                
                //correctAns =[select Category__c from Question_Bank__c where Category1__c =:'Creative'];
                //removed query and read from map
                correctAns = mapAllQBCategoryWise.containskey('Creative') ? mapAllQBCategoryWise.get('Creative') : new List<Question_Bank__c>();
                ans.add(con.Creative1__c);
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
                System.debug('Creative '+ count);
                
                
                //correctAns =[select Category__c from Question_Bank__c where Category1__c =:'Mechanical'];
                //removed query and read from map
                correctAns = mapAllQBCategoryWise.containskey('Mechanical') ? mapAllQBCategoryWise.get('Mechanical') : new List<Question_Bank__c>();
                ans.add(con.Mech1__c);
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
                System.debug('Mechanical '+ count);
                
                
                //correctAns =[select Category__c from Question_Bank__c where Category1__c =:'Verbal'];
                //removed query and read from map
                correctAns = mapAllQBCategoryWise.containskey('Verbal') ? mapAllQBCategoryWise.get('Verbal') : new List<Question_Bank__c>();
                ans.add(con.Verbal1__c);
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
                
                aptitudeList.sort();
                
                integer cntRes = 0;
                Map<String, Integer> resultInt = new Map<String, Integer>();
                for(Integer j = aptitudeList.size()-1; j>=0;j--){
                    if(cntRes < 3){
                        if(mapCountWiseAptitude.get(aptitudeList[j]).size() > 1){
                            for(integer i = 0 ; mapCountWiseAptitude.get(aptitudeList[j]).size() > i ; i++){
                                resultInt.put(mapCountWiseAptitude.get(aptitudeList[j])[i],aptitudeList[j]);
                                cntRes++;
                            }
                        } else {
                            resultInt.put(mapCountWiseAptitude.get(aptitudeList[j])[0],aptitudeList[j]);
                            cntRes++;
                        }
                    } else {
                        break;
                    }
                }
                
                for(Integer i = aptitudeList.size()-1; i >= 0; i--){
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
                }
                if(highestApti.size() < 3){
                    for(Integer key: mapCountWiseAptitude.keyset()){
                        for(string apti: mapCountWiseAptitude.get(key)){
                            if(!highestApti.contains(apti)){
                                highestApti.add(apti);
                            }
                        }
                    }
                }
                
                system.debug('highestApti :: ' + highestApti);
                Integer cnt = 1;
                List<resultWrapper> resWrapp = new List<resultWrapper>();
                for(String str : resultInt.keyset()){
                    
                    if(cnt == 1){
                        con.Aptitude_1__c= str;
                    } else if(cnt == 2){
                        con.Aptitude_2__c= str;
                    } else if(cnt == 3){
                        con.Aptitude_3__c= str;
                    }
                    
                    resultWrapper res = new resultWrapper();
                    if(language == 'eng'){
                        if(str == 'Spatial'){
                         	res.label = '<br/>Spatial<br/>(Good at solving puzzles, using maps, photography)';     
                        } else if(str == 'Numerical'){
                            res.label = '<br/>Numerical<br/>(Good at maths, calculations and numbers)';     
                        } else if(str == 'Abstract'){
                            res.label = '<br/>Abstract<br/>(Good at grouping things, making plans)';     
                        } else if(str == 'Creative'){
                            res.label = '<br/>Creative<br/>(Good at coming up with new ideas, drawing, drama)';     
                        } else if(str == 'Mechanical'){
                            res.label = '<br/>Mechanical<br/>(Good at working with machines)';     
                        } else if(str == 'Verbal'){
                            res.label = '<br/>Verbal<br/>(Good at writing, grammar, punctuation)';     
                        }
                    } else if(language == 'hin'){
                    	if(str == 'Spatial'){
                         	res.label = '<br/>स्थानिक<br/>(पहेली को हल करने में , नक्शे, फोटोग्राफी का उपयोग करनेमे अच्छा होना)';     
                        } else if(str == 'Numerical'){
                            res.label = '<br/>संख्यात्मक<br/>(गणित, गणना और संख्या में अच्छा होना)';     
                        } else if(str == 'Abstract'){
                            res.label = '<br/>सार<br/>(चीजों को समूहीकृत करना, योजना बनाने मे अच्छा होना)';     
                        } else if(str == 'Creative'){
                            res.label = '<br/>क्रिएटिव<br/>(नए विचारों, ड्राइंग, नाटक के साथ काम करणेमे अच्छा होणा)';     
                        } else if(str == 'Mechanical'){
                            res.label = '<br/>मैकेनिकल<br/>(मशीनों के साथ काम करने में अच्छा होना)';     
                        } else if(str == 'Verbal'){
                            res.label = '<br/>मौखिक<br/>(लेखन, व्याकरण, विराम चिह्न मे अच्छा रेहना)';     
                        }
                    } else if(language == 'mar'){
                    	if(str == 'Spatial'){
                         	res.label = '<br/>स्थानिक<br/>(जसे कोडे सोडविने, नकाशे, छायाचित्रण वापरन्यात चांगले असणे)';     
                        } else if(str == 'Numerical'){
                            res.label = '<br/>संख्यात्मक<br/>(गणित, मोजमाप आणि संख्या या बाबतीत चांगले असणे)';     
                        } else if(str == 'Abstract'){
                            res.label = '<br/>अ‍ॅबस्ट्रॅक्ट<br/>(जसे गोष्टी गटबद्ध करणे, योजना तयार करणे यात चांगले असणे)';     
                        } else if(str == 'Creative'){
                            res.label = '<br/>क्रिएटिव्ह<br/>(जसे नवीन कल्पना, रेखाचित्र, नाटक घेऊन येण्यात चांगले असणे)';     
                        } else if(str == 'Mechanical'){
                            res.label = '<br/>यांत्रिक<br/>(मशीनसह कार्य करन्यात चांगले असणे)';     
                        } else if(str == 'Verbal'){
                            res.label = '<br/>तोंड<br/>(लेखनात, व्याकरण, विरामचिन्हे यात चांगले असणे)';     
                        }
                    } else if(language == 'Urdu'){
                        if(str == 'Spatial'){
                            res.label = '<br/>مکانی<br/>(پہیلیاں حل کرنے میں ، نقشے ، فوٹو گرافی کا استعمال کرتے ہوئے)';     
                        } else if(str == 'Numerical'){
                            res.label = '<br/>اعدادی<br/>(ریاضی ، حساب اور نمبروں میں اچھا)';     
                        } else if(str == 'Abstract'){
                            res.label = '<br/>خلاصہ<br/>(چیزوں کو گروہ بنانے ، منصوبے بنانے میں اچھا)';     
                        } else if(str == 'Creative'){
                            res.label = '<br/>تخلیقی۔<br/>(نئے خیالات ، ڈرائنگ ، ڈرامہ کے ساتھ آنے میں اچھا ہے)';     
                        } else if(str == 'Mechanical'){
                            res.label = '<br/>مکینیکل<br/>(مشینوں کے ساتھ کام کرنے میں اچھا)';     
                        } else if(str == 'Verbal'){
                            res.label = '<br/>زبانی۔<br/>(لکھنے ، گرائمر ، اوقاف میں اچھا)';     
                        }
                    }
                    
                    if(cnt < 4){
                        String s = '<b>' + res.label + '</b>';
                        res.label = s;
                        res.value = '<br/><b>'+String.valueOf(resultInt.get(str))+'</b>';
                    } else {
                        String s = '<I>' + res.label + '</I>';
                        res.label = s;
                        res.value = '<br/><I>'+String.valueOf(resultInt.get(str))+'</I>';
                    }
                    
                    //res.value = '<br/>'+String.valueOf(aptitute.get(str));
                    resWrapp.add(res);
                    cnt++;
                }
                
                result.put('result',resWrapp);
            }
            update conData;
            
            String fieldName = '';
            if(language == 'eng'){
            	fieldName = 'Label_for_the_Assessment_form__c';
            } else if(language == 'hin'){
            	fieldName = 'Hindi_Label_for_the_Assessment_form__c';
            } else if(language == 'mar'){
            	fieldName = 'Marathi_Label_for_the_Assessment_form__c';
            } else if(language == 'Urdu'){
            	fieldName = 'Urdu_Label_for_the_Assessment_form__c';
            } 
            
            if(highestApti.size() > 0){
            String inteQuery = 'Select Id,'+fieldName+' From IARP_Master__c where Is_Active__c = true and '+
                '(Aptitude_1__c = \''+highestApti[0]+
                '\' or Aptitude_2__c = \''+highestApti[1]+
                '\' or Aptitude_3__c = \''+highestApti[2]+'\')  limit 6';
            system.debug('inteQuery : ' + inteQuery);
            result.put('careerInterest',database.query(inteQuery));
            } else {
                result.put('careerInterest',new List<String>());
            }
        }*/
        
        return result;
    }
    
    public static void FillDefaultDetails(String lang){
        /*mapofInterest = new map<string,Explanations__c>();
        for(Explanations__c objEx: [select Id,Name,Code__c,Icon_Name__c,Particulars__c,Particulars_Hindi__c,Particulars_Marathi__c,Document_Icon_Id__c from Explanations__c Where Name = 'Interest']){
            mapofInterest.put(objEx.Code__c, objEx);
        }*/
        
        /*mapofPersonality = new map<string,Explanations__c>();
        for(Explanations__c objEx: [select Id,Name,Code__c,Icon_Name__c,Particulars__c,Particulars_Hindi__c,Particulars_Marathi__c,Document_Icon_Id__c from Explanations__c Where Name = 'Personality']){
            mapofPersonality.put(objEx.Code__c, objEx);
        }*/
        
        /*mapofAptitude = new map<string,Explanations__c>();
        for(Explanations__c objEx: [select Id,Name,Code__c,Icon_Name__c,Particulars__c,Particulars_Hindi__c,Particulars_Marathi__c,Document_Icon_Id__c from Explanations__c Where Name = 'Aptitude']){
            mapofAptitude.put(objEx.Code__c, objEx);
        }*/
        
        /*fill map of explanation*/
        mapRealityExplanations = new map<string,string>();
        for (Explanations__c ex: [Select Name,Particulars__c,Realities__c,Code__c,Particulars_Hindi__c,Particulars_Marathi__c,
                                  Document_Icon_Id__c from Explanations__c where Name= 'Realities' and Code__c != null Order by Code__c]){
            if(ex.Code__c.startswith('Self 1')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('1Yes',getRealityText(ex,lang));
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('1No',getRealityText(ex,lang));
                }
            }
            if(ex.Code__c.startswith('Self 2')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('2Yes',getRealityText(ex,lang));
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('2No',getRealityText(ex,lang));
                }
            }
            if(ex.Code__c.startswith('Self 3')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('3Yes',getRealityText(ex,lang));
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('3No',getRealityText(ex,lang));
                }
            }
            if(ex.Code__c.startswith('Self 4')) {
                if(ex.Realities__c == 'A') {
                    mapRealityExplanations.put('4A',getRealityText(ex,lang));
                }
                if(ex.Realities__c == 'B') {
                    mapRealityExplanations.put('4B',getRealityText(ex,lang));
                }
                if(ex.Realities__c == 'C') {
                    mapRealityExplanations.put('4C',getRealityText(ex,lang));
                }
            }
            if(ex.Code__c.startswith('Family 1')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('5Yes',getRealityText(ex,lang));
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('5No',getRealityText(ex,lang));
                }
            }
            if(ex.Code__c.startswith('Family 2')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('6Yes',getRealityText(ex,lang));
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('6No',getRealityText(ex,lang));
                }
            }
            if(ex.Code__c.startswith('Family 3')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('7Yes',getRealityText(ex,lang));
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('7No',getRealityText(ex,lang));
                }
            }
            if(ex.Code__c.startswith('Family 4')) {
                if(ex.Realities__c == 'A') {
                    mapRealityExplanations.put('8A',getRealityText(ex,lang));
                }
                if(ex.Realities__c == 'B') {
                    mapRealityExplanations.put('8B',getRealityText(ex,lang));
                }
                if(ex.Realities__c == 'C') {
                    mapRealityExplanations.put('8C',getRealityText(ex,lang));
                }
            }
        }
    }
    
    public static string getRealityText(Explanations__c ex, String language){
        string strParticulars = ex.Particulars__c;
        if(language == 'hin') {
            strParticulars = ex.Particulars_Hindi__c;
        } else if(language == 'mar'){
            strParticulars = ex.Particulars_Marathi__c;
        } else if(language == 'eng'){
            strParticulars = ex.Particulars__c;
        }
        return strParticulars;
    }
    
    public static void contactIARAttendance(Id contactId, String submittedPage) {
        AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
        String grade9Initial = setting.Bar_Code_Initial_for_Grade_9__c;
        String page = '';
        system.debug('grade9Initial '+grade9Initial+' contactIARAttendance '+submittedPage+' '+contactId);
        List<Contact> objContact = New List<Contact>([Select Id, Bar_Code__c, Batch_Code__c 
                                                     From Contact 
                                                     Where Id =: contactId AND Batch_Code__c != null]) ;
        system.debug('objContact '+objContact.size()+objContact);
        if(objContact.size()>0) {
            system.debug('inside objContact '+objContact[0].Batch_Code__c+objContact[0]);
            if(objContact[0].Bar_Code__c != null && grade9Initial == objContact[0].Bar_Code__c.substring(0,2)) {
                system.debug('inside cond');
                List<Session__c> objSession = New List<Session__c>([Select id, Name, Batch__r.Batch_Number__c 
                                                                    From Session__c 
                                                                    Where Name =: submittedPage AND Batch__c =: objContact[0].Batch_Code__c 
                                                                    Order By Batch__r.Date_of_facilitation_starting__c Desc
                                                                    LIMIT 1]);
                system.debug('objSession '+objSession.size()+objSession);
                if(objSession.size()>0) {
                    Session_Attendance__c objSA = New Session_Attendance__c();
                    objSA.Session__c = objSession[0].Id;
                    objSA.Contact__c = contactId;
                    insert objSA;
                }                
            }            
        }
    }
    
    public class resultWrapper {
        @AuraEnabled
        public String label {get; set;}
        
        @AuraEnabled
        public String value {get; set;}
    }
    
    public class WrpStudentQuestionAnswer{
        @AuraEnabled
        public List<WrpStudentQuestion> lstWrpStudentQuestion {get;set;}
    
        @AuraEnabled
        public Contact objContact {get;set;}
        
        public WrpStudentQuestionAnswer(){
            lstWrpStudentQuestion = new List<WrpStudentQuestion>();
            objContact = new Contact();
        }
    }
    
    public class WrpStudentQuestion{
        @AuraEnabled
        public Id tempObjectId {get;set;}
        
        @AuraEnabled
        public Id questionId {get;set;}
        
        @AuraEnabled
        public String questionLabel {get;set;}
        
        @AuraEnabled
        public String displayNumber {get;set;}
        
        @AuraEnabled
        public Integer orderOfQuestion {get;set;}
        
        @AuraEnabled
        public String fieldType {get;set;}
        
        @AuraEnabled
        public Id answerId {get;set;}
        
        @AuraEnabled
        public List<WrpStudentAnswer> lstWrpStudentAnswer{get;set;}
        
        public WrpStudentQuestion(){
            tempObjectId = null;
            questionLabel = '';
            displayNumber = '';
            questionId = null;
            orderOfQuestion = 0;
            fieldType = '';
            answerId = null;
            lstWrpStudentAnswer = new List<WrpStudentAnswer>();
        }
    }

    public class WrpStudentAnswer{        
        @AuraEnabled
        public Id answerId {get;set;}
        
        @AuraEnabled
        public String formValue {get;set;}

        @AuraEnabled
        public Integer order {get;set;}
        
        public WrpStudentAnswer(){
            answerId = null;
            formValue = '';
            order = 0;
        }
    }
    
    public class WrpQuestionImage{    
        @AuraEnabled
        public string fileType {get;set;}
        
        @AuraEnabled
        public string fileData {get;set;}
        
        public WrpQuestionImage(){
            fileType = '';
            fileData = '';
        }
    }
}