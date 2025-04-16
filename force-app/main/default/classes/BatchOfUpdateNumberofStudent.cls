public class BatchOfUpdateNumberofStudent implements Database.Batchable<SObject> {
    public static List<Batch__c> batchRecordsToUpdate; // Static variable to hold records
    public set<Id> setId;
    public BatchOfUpdateNumberofStudent(set<Id> batchRecords) {
        this.setId = batchRecords;
    }
    public Database.QueryLocator start(Database.BatchableContext context) {
        List<id> lstId = new List<id>();
        lstId.addAll(setId);
        String Query = 'select Id, Date_of_facilitation_starting__c, Number_of_students_counselled__c,(select Id,Attendance__c,Counselling_Session_Attended__c,I_agree_with_the_recommendation__c,I_am_clear_about_what_I_need_to_do_after__c,Was_the_Program_useful_and_helpful_for_y__c,Did_you_learn_something_new_about_yourse__c,Did_you_learn_about_some_new_Careers__c,Was_the_teacher_s_way_of_teaching_easy_t__c,Did_the_teacher_clear_all_your_doubts__c,Were_you_able_to_understand_the_workbook__c,Pre_follow_up_status__c, Would_you_recommend_the_CareerAware_prog__c,Guardian_Attendance__c,Follow_up_1_training_done__c,Follow_up_2_training_done__c,Followup_1_Change_in_Fitment__c,Followup_1_Change_in_Reccomendation__c,Followup_1_Clear_Next_Steps__c,Followup_1_Match_I_A__c,Import_Status__c, Recommendation_Report_Status__c,Followup_2_Change_in_Fitment__c,Followup_2_Change_in_Reccomendation__c,Facilitated_with_Baseline_1__c from Contacts__r),(select Id,Attendance__c from Contacts1__r),(select Id,Attendance__c from Contacts2__r),(select Id,Attendance__c from Contacts3__r)from Batch__c Where Id in:';
        Query+='lstId';
        return Database.getQueryLocator(Query);
    }
    
    public void execute(Database.BatchableContext context, List<Batch__c> lstBatchOfContact) {
        List<Batch__c> lstBatchstoUpdate = new List<Batch__c>();
        Datetime dtPreviousYear2020 = DateTime.newinstance(2020, 04, 30, 0, 0, 0);
        if(lstBatchOfContact.size() > 0 && !lstBatchOfContact.isEmpty()){
            
            for(Batch__c objBatch: lstBatchOfContact)
            {
                Batch__c objBToUpdate = new Batch__c();
                objBToUpdate.Id = objBatch.Id;
                
                Integer noofstudentsfacilitated = 0;
                Integer NumberofStudentLeftSchool = 0;
                Integer counsellingcount = 0;
                Integer countofbaseline1students = 0;
                Integer countofworkbookstudents = 0;
                Integer countofcounsellingreport = 0;
                
                Integer countagrredwithrecom = 0;
                Integer countnotagrredwithrecom = 0;
                
                Integer countoffollowup1 = 0;
                Integer countoffollowup2 = 0;
                
                Integer countoff1fitmentyes = 0;
                Integer countoff1fitmentno = 0;
                Integer countoff1fitmentna = 0;
                
                Integer countoff1recommyes = 0;
                Integer countoff1recommno = 0;
                Integer countoff1recommna = 0;
                
                Integer countoff2fitmentyes = 0;
                Integer countoff2fitmentno = 0;
                Integer countoff2fitmentna = 0;
                
                Integer countoff2recommyes = 0;
                Integer countoff2recommno = 0;
                Integer countoff2recommna = 0;
                
                Integer countoff1cnsyes = 0;
                Integer countoff1cnsno = 0;
                Integer countoff1cnsna = 0;
                
                Integer countoff1iayes = 0;
                Integer countoff1iano = 0;
                Integer countoff1iana = 0;
                
                Integer countclearafter10 = 0;
                Integer countnotclearafter10 = 0;
                
                Integer countgurdainpresent = 0;
                Integer countgurdainabsent = 0;
                
                Integer count1agreerecommendation = 0; 
                Integer count2agreerecommendation = 0;
                Integer count3agreerecommendation = 0;
                Integer count4agreerecommendation = 0;
                Integer count5agreerecommendation = 0;
                Integer countBagreerecommendation = 0;
                
                Integer count1needtodoafter = 0; 
                Integer count2needtodoafter = 0;
                Integer count3needtodoafter = 0;
                Integer count4needtodoafter = 0;
                Integer count5needtodoafter = 0;
                Integer countBneedtodoafter = 0;
                
                Integer count1clearalldoubts = 0;
                Integer count2clearalldoubts = 0;
                Integer count3clearalldoubts = 0;
                Integer count4clearalldoubts = 0;
                Integer count5clearalldoubts = 0;
                Integer countBclearalldoubts = 0;
                
                Integer count1learnnewcareer = 0;
                Integer count2learnnewcareer = 0;
                Integer count3learnnewcareer = 0;
                Integer count4learnnewcareer = 0;
                Integer count5learnnewcareer = 0;
                Integer countBlearnnewcareer = 0;
                
                Integer count1learnsomethingnew = 0;
                Integer count2learnsomethingnew = 0;
                Integer count3learnsomethingnew = 0;
                Integer count4learnsomethingnew = 0;
                Integer count5learnsomethingnew = 0;
                Integer countBlearnsomethingnew = 0;
                
                Integer count1programuseful = 0;
                Integer count2programuseful = 0;
                Integer count3programuseful = 0;
                Integer count4programuseful = 0;
                Integer count5programuseful = 0;
                Integer countBprogramuseful = 0;
                
                Integer count1recommendcareeraware = 0;
                Integer count2recommendcareeraware = 0;
                Integer count3recommendcareeraware = 0;
                Integer count4recommendcareeraware = 0;
                Integer count5recommendcareeraware = 0;
                Integer countBrecommendcareeraware = 0;
                
                Integer count1understandworkbook = 0;
                Integer count2understandworkbook = 0;
                Integer count3understandworkbook = 0;
                Integer count4understandworkbook = 0;
                Integer count5understandworkbook = 0;
                Integer countBunderstandworkbook = 0;
                
                Integer count1wayofteaching = 0;
                Integer count2wayofteaching = 0;
                Integer count3wayofteaching = 0;
                Integer count4wayofteaching = 0;
                Integer count5wayofteaching = 0;
                Integer countBwayofteaching = 0;
                
                for(Contact objCon: objBatch.Contacts__r){
                    /**if(objCon.Attendance__c > 0){
noofstudentsfacilitated++;
}**/
                    if(objCon.Counselling_Session_Attended__c){
                        counsellingcount++;
                    }
                    //added a new flag to check baseline 1 students instead of import status for year 2019-20
                    if(objCon.Facilitated_with_Baseline_1__c){//objCon.Import_Status__c == 'Baseline 1 Imported'
                        countofbaseline1students++;
                    }
                    //count of workbook needs to work for year 2019-20 so, updated this flag manually those students have baseline1 import status.
                    //for all other year workbook count will be same as facilated students.
                    if(!objCon.Facilitated_with_Baseline_1__c){//objCon.Import_Status__c != 'Baseline 1 Imported'
                        countofworkbookstudents++;
                    }
                    if(objCon.Recommendation_Report_Status__c == 'Report processed'){
                        countofcounsellingreport++;
                    }
                    
                    if(string.isnotblank(objCon.Follow_up_1_training_done__c) && objCon.Follow_up_1_training_done__c.tolowercase() == 'yes') {
                        countoffollowup1++;
                    }
                    if(string.isnotblank(objCon.Follow_up_2_training_done__c) && objCon.Follow_up_2_training_done__c.tolowercase() == 'yes') {
                        countoffollowup2++;
                    }
                    if(string.isnotblank(objCon.Followup_1_Change_in_Fitment__c)){
                        if(objCon.Followup_1_Change_in_Fitment__c.tolowercase() == 'yes'){
                            countoff1fitmentyes++;
                        } else if(objCon.Followup_1_Change_in_Fitment__c.tolowercase() == 'no'){
                            countoff1fitmentno++;
                        } else {
                            countoff1fitmentna++;
                        }
                    }
                    if(string.isnotblank(objCon.Followup_1_Change_in_Reccomendation__c)){
                        if(objCon.Followup_1_Change_in_Reccomendation__c.tolowercase() == 'yes'){
                            countoff1recommyes++;
                        } else if(objCon.Followup_1_Change_in_Reccomendation__c.tolowercase() == 'no'){
                            countoff1recommno++;
                        } else {
                            countoff1recommna++;
                        }
                    }
                    
                    if(string.isnotblank(objCon.Followup_2_Change_in_Fitment__c)){
                        if(objCon.Followup_2_Change_in_Fitment__c.tolowercase() == 'yes'){
                            countoff2fitmentyes++;
                        } else if(objCon.Followup_2_Change_in_Fitment__c.tolowercase() == 'no'){
                            countoff2fitmentno++;
                        } else {
                            countoff2fitmentna++;
                        }
                    }
                    
                    if(string.isnotblank(objCon.Followup_2_Change_in_Reccomendation__c)){
                        if(objCon.Followup_2_Change_in_Reccomendation__c.tolowercase() == 'yes'){
                            countoff2recommyes++;
                        } else if(objCon.Followup_2_Change_in_Reccomendation__c.tolowercase() == 'no'){
                            countoff2recommno++;
                        } else {
                            countoff2recommna++;
                        }
                    }
                    
                    if(string.isnotblank(objCon.Followup_1_Clear_Next_Steps__c)){
                        if(objCon.Followup_1_Clear_Next_Steps__c.tolowercase() == 'yes'){
                            countoff1cnsyes++;
                        } else if(objCon.Followup_1_Clear_Next_Steps__c.tolowercase() == 'no'){
                            countoff1cnsno++;
                        } else {
                            countoff1cnsna++;
                        }
                    }
                    if(string.isnotblank(objCon.Followup_1_Match_I_A__c)){
                        if(objCon.Followup_1_Match_I_A__c.tolowercase() == 'yes'){
                            countoff1iayes++;
                        } else if(objCon.Followup_1_Match_I_A__c.tolowercase() == 'no'){
                            countoff1iano++;
                        } else {
                            countoff1iana++;
                        }
                    }
                    
                    if(objCon.I_agree_with_the_recommendation__c != null){
                        if(objCon.I_agree_with_the_recommendation__c == '4' || objCon.I_agree_with_the_recommendation__c == '5' || objCon.I_agree_with_the_recommendation__c.tolowercase() == 'yes'){
                            countagrredwithrecom++;
                        } else if(objCon.I_agree_with_the_recommendation__c == '1' || objCon.I_agree_with_the_recommendation__c == '2'  || objCon.I_agree_with_the_recommendation__c == '3' || objCon.I_agree_with_the_recommendation__c.tolowercase() == 'no'){
                            countnotagrredwithrecom++;
                        }
                    }
                    
                    if(objCon.I_am_clear_about_what_I_need_to_do_after__c != null){
                        if(objCon.I_am_clear_about_what_I_need_to_do_after__c =='4' || objCon.I_am_clear_about_what_I_need_to_do_after__c =='5' || objCon.I_am_clear_about_what_I_need_to_do_after__c.tolowercase() == 'yes'){
                            countclearafter10++;
                        } else if(objCon.I_am_clear_about_what_I_need_to_do_after__c == '1' || objCon.I_am_clear_about_what_I_need_to_do_after__c == '2'|| objCon.I_am_clear_about_what_I_need_to_do_after__c == '3'|| objCon.I_am_clear_about_what_I_need_to_do_after__c.tolowercase() == 'no'){
                            countnotclearafter10++;
                        }
                    }
                    
                    if(objCon.Guardian_Attendance__c != null){
                        if(objCon.Guardian_Attendance__c.tolowercase() == 'present'){
                            countgurdainpresent++;
                        } else if(objCon.Guardian_Attendance__c.tolowercase() == 'absent'){
                            countgurdainabsent++;
                        }
                    }
                    // recommendation
                    if(objCon.I_agree_with_the_recommendation__c != null){
                        count1agreerecommendation += CheckOption(objCon.I_agree_with_the_recommendation__c, '1');
                        count2agreerecommendation += CheckOption(objCon.I_agree_with_the_recommendation__c, '2');
                        count3agreerecommendation += CheckOption(objCon.I_agree_with_the_recommendation__c, '3');
                        count4agreerecommendation += CheckOption(objCon.I_agree_with_the_recommendation__c, '4');
                        count5agreerecommendation += CheckOption(objCon.I_agree_with_the_recommendation__c, '5');
                    } else {
                        countBagreerecommendation++;
                    }
                    //after do
                    if(objCon.I_am_clear_about_what_I_need_to_do_after__c != null){
                        count1needtodoafter += CheckOption(objCon.I_am_clear_about_what_I_need_to_do_after__c, '1');
                        count2needtodoafter += CheckOption(objCon.I_am_clear_about_what_I_need_to_do_after__c, '2');
                        count3needtodoafter += CheckOption(objCon.I_am_clear_about_what_I_need_to_do_after__c, '3');
                        count4needtodoafter += CheckOption(objCon.I_am_clear_about_what_I_need_to_do_after__c, '4');
                        count5needtodoafter += CheckOption(objCon.I_am_clear_about_what_I_need_to_do_after__c, '5');
                    } else {
                        countBneedtodoafter++;
                    }
                    
                    if(objCon.Was_the_Program_useful_and_helpful_for_y__c != null){
                        count1programuseful += CheckOption(objCon.Was_the_Program_useful_and_helpful_for_y__c, '1');
                        count2programuseful += CheckOption(objCon.Was_the_Program_useful_and_helpful_for_y__c, '2');
                        count3programuseful += CheckOption(objCon.Was_the_Program_useful_and_helpful_for_y__c, '3');
                        count4programuseful += CheckOption(objCon.Was_the_Program_useful_and_helpful_for_y__c, '4');
                        count5programuseful += CheckOption(objCon.Was_the_Program_useful_and_helpful_for_y__c, '5');
                    } else {
                        countBprogramuseful++;
                    }
                    
                    if(objCon.Did_you_learn_something_new_about_yourse__c != null){
                        count1learnsomethingnew += CheckOption(objCon.Did_you_learn_something_new_about_yourse__c, '1');
                        count2learnsomethingnew += CheckOption(objCon.Did_you_learn_something_new_about_yourse__c, '2');
                        count3learnsomethingnew += CheckOption(objCon.Did_you_learn_something_new_about_yourse__c, '3');
                        count4learnsomethingnew += CheckOption(objCon.Did_you_learn_something_new_about_yourse__c, '4');
                        count5learnsomethingnew += CheckOption(objCon.Did_you_learn_something_new_about_yourse__c, '5');
                    } else {
                        countBlearnsomethingnew++;
                    }
                    
                    if(objCon.Did_you_learn_about_some_new_Careers__c != null){
                        count1learnnewcareer += CheckOption(objCon.Did_you_learn_about_some_new_Careers__c, '1');
                        count2learnnewcareer += CheckOption(objCon.Did_you_learn_about_some_new_Careers__c, '2');
                        count3learnnewcareer += CheckOption(objCon.Did_you_learn_about_some_new_Careers__c, '3');
                        count4learnnewcareer += CheckOption(objCon.Did_you_learn_about_some_new_Careers__c, '4');
                        count5learnnewcareer += CheckOption(objCon.Did_you_learn_about_some_new_Careers__c, '5');
                    } else {
                        countBlearnnewcareer++; 
                    }
                    
                    if(objCon.Was_the_teacher_s_way_of_teaching_easy_t__c != null){
                        count1wayofteaching += CheckOption(objCon.Was_the_teacher_s_way_of_teaching_easy_t__c, '1');
                        count2wayofteaching += CheckOption(objCon.Was_the_teacher_s_way_of_teaching_easy_t__c, '2');
                        count3wayofteaching += CheckOption(objCon.Was_the_teacher_s_way_of_teaching_easy_t__c, '3');
                        count4wayofteaching += CheckOption(objCon.Was_the_teacher_s_way_of_teaching_easy_t__c, '4');
                        count5wayofteaching += CheckOption(objCon.Was_the_teacher_s_way_of_teaching_easy_t__c, '5');
                    } else {
                        countBwayofteaching++;
                    }
                    
                    if(objCon.Did_the_teacher_clear_all_your_doubts__c != null){
                        count1clearalldoubts += CheckOption(objCon.Did_the_teacher_clear_all_your_doubts__c, '1');
                        count2clearalldoubts += CheckOption(objCon.Did_the_teacher_clear_all_your_doubts__c, '2');
                        count3clearalldoubts += CheckOption(objCon.Did_the_teacher_clear_all_your_doubts__c, '3');
                        count4clearalldoubts += CheckOption(objCon.Did_the_teacher_clear_all_your_doubts__c, '4');
                        count5clearalldoubts += CheckOption(objCon.Did_the_teacher_clear_all_your_doubts__c, '5');
                    } else {
                        countBclearalldoubts++;
                    }
                    
                    if(objCon.Were_you_able_to_understand_the_workbook__c != null){
                        count1understandworkbook += CheckOption(objCon.Were_you_able_to_understand_the_workbook__c, '1');
                        count2understandworkbook += CheckOption(objCon.Were_you_able_to_understand_the_workbook__c, '2');
                        count3understandworkbook += CheckOption(objCon.Were_you_able_to_understand_the_workbook__c, '3');
                        count4understandworkbook += CheckOption(objCon.Were_you_able_to_understand_the_workbook__c, '4');
                        count5understandworkbook += CheckOption(objCon.Were_you_able_to_understand_the_workbook__c, '5');
                    } else {
                        countBunderstandworkbook++;
                    }
                    
                    if(objCon.Would_you_recommend_the_CareerAware_prog__c != null){
                        count1recommendcareeraware += CheckOption(objCon.Would_you_recommend_the_CareerAware_prog__c, '1');
                        count2recommendcareeraware += CheckOption(objCon.Would_you_recommend_the_CareerAware_prog__c, '2');
                        count3recommendcareeraware += CheckOption(objCon.Would_you_recommend_the_CareerAware_prog__c, '3');
                        count4recommendcareeraware += CheckOption(objCon.Would_you_recommend_the_CareerAware_prog__c, '4');
                        count5recommendcareeraware += CheckOption(objCon.Would_you_recommend_the_CareerAware_prog__c, '5');
                    } else {
                        countBrecommendcareeraware++;
                    }
                    if(objCon.Pre_follow_up_status__c != null && objCon.Pre_follow_up_status__c.contains('Left school')){  
                        NumberofStudentLeftSchool++;
                    } 
                }
                Integer newNumberOfFecilatedStudent = 0;
                for (Contact c : objBatch.Contacts__r) {
                    newNumberOfFecilatedStudent++;
                }
                for (Contact c : objBatch.Contacts1__r) {
                    newNumberOfFecilatedStudent++;
                }
                for (Contact c : objBatch.Contacts2__r) {
                    newNumberOfFecilatedStudent++;
                }
                for (Contact c : objBatch.Contacts3__r) {
                    newNumberOfFecilatedStudent++;
                }
                objBToUpdate.Number_of_students_facilitated__c = newNumberOfFecilatedStudent;
                objBToUpdate.Number_of_students_pending_counselling__c = string.valueof(objBToUpdate.Number_of_students_facilitated__c - objBatch.Number_of_students_counselled__c);
                
                
                if(objBToUpdate.Number_of_students_facilitated__c > 0){
                    objBToUpdate.Scans_Received__c = 'Yes';
                }
                objBToUpdate.No_of_students_with_Baseline_1__c = countofbaseline1students;
                objBToUpdate.No_of_students_facilitated_with_workbook__c = countofworkbookstudents;
                objBToUpdate.No_of_students_have_counselling_report__c = countofcounsellingreport;
                
                //followup fields
                objBToUpdate.Number_of_students_in_follow_up_session1__c = countoffollowup1;
                objBToUpdate.Number_of_students_in_follow_up_session2__c = countoffollowup2;
                
                objBToUpdate.Followup_1_Change_in_Fitment_Y__c = countoff1fitmentyes;
                objBToUpdate.Followup_1_Change_in_Fitment_N__c = countoff1fitmentno;
                objBToUpdate.Followup_1_Change_in_Fitment_N_A__c = countoff1fitmentna;
                
                objBToUpdate.Followup_1_Change_in_Reccomendation_Y__c = countoff1recommyes;
                objBToUpdate.Followup_1_Change_in_Reccomendation_N__c = countoff1recommno;
                objBToUpdate.Followup_1_Change_in_Reccomendation_N_A__c = countoff1recommna;
                
                objBToUpdate.Followup_2_Change_in_Fitment_Y__c = countoff2fitmentyes;
                objBToUpdate.Followup_2_Change_in_Fitment_N__c = countoff2fitmentno;
                objBToUpdate.Followup_2_Change_in_Fitment_N_A__c = countoff2fitmentna;
                
                objBToUpdate.Followup_2_Change_in_Reccomendation_Y__c = countoff2recommyes;
                objBToUpdate.Followup_2_Change_in_Reccomendation_N__c = countoff2recommno;
                objBToUpdate.Followup_2_Change_in_Reccomendation_N_A__c = countoff2recommna;
                
                objBToUpdate.Followup_1_Clear_Next_Steps_Y__c = countoff1cnsyes;
                objBToUpdate.Followup_1_Clear_Next_Steps_N__c = countoff1cnsno;
                objBToUpdate.Followup_1_Clear_Next_Steps_N_A__c = countoff1cnsna;
                
                objBToUpdate.Followup_1_Match_I_A_Y__c = countoff1iayes;
                objBToUpdate.Followup_1_Match_I_A_N__c = countoff1iano;
                objBToUpdate.Followup_1_Match_I_A_N_A__c = countoff1iana;
                
                objBToUpdate.Number_of_students_counselled__c = counsellingcount;
                //objBToUpdate.Number_of_students_pending_counselling__c = string.valueof(objBToUpdate.Number_of_students_facilitated__c - objBToUpdate.Number_of_students_counselled__c);
                
                objBToUpdate.No_of_students_agreed_with_recom__c = countagrredwithrecom;
                objBToUpdate.No_of_students_not_agreed_with_recom__c = countnotagrredwithrecom;
                objBToUpdate.No_of_students_clear_what_after_10__c = countclearafter10;
                objBToUpdate.No_of_students_not_clear_what_after_10__c = countnotclearafter10;
                objBToUpdate.No_of_students_1_agree_recommendation__c = count1agreerecommendation;
                objBToUpdate.No_of_students_2_agree_recommendation__c = count2agreerecommendation;
                objBToUpdate.No_of_students_3_agree_recommendation__c = count3agreerecommendation;
                objBToUpdate.No_of_students_4_agree_recommendation__c = count4agreerecommendation;
                objBToUpdate.No_of_students_5_agree_recommendation__c = count5agreerecommendation;
                objBToUpdate.No_of_students_B_agree_recommendation__c = countBagreerecommendation;
                objBToUpdate.No_of_students_1_need_to_do_after__c = count1needtodoafter;
                objBToUpdate.No_of_students_2_need_to_do_after__c = count2needtodoafter;
                objBToUpdate.No_of_students_3_need_to_do_after__c = count3needtodoafter;
                objBToUpdate.No_of_students_4_need_to_do_after__c = count4needtodoafter;
                objBToUpdate.No_of_students_5_need_to_do_after__c = count5needtodoafter;
                objBToUpdate.No_of_students_B_need_to_do_after__c = countBneedtodoafter;
                objBToUpdate.No_of_students_1_clear_all_doubts__c = count1clearalldoubts;
                objBToUpdate.No_of_students_2_clear_all_doubts__c = count2clearalldoubts;
                objBToUpdate.No_of_students_3_clear_all_doubts__c = count3clearalldoubts;
                objBToUpdate.No_of_students_4_clear_all_doubts__c = count4clearalldoubts;
                objBToUpdate.No_of_students_5_clear_all_doubts__c = count5clearalldoubts;
                objBToUpdate.No_of_students_B_clear_all_doubts__c = countBclearalldoubts;
                objBToUpdate.No_of_students_1_learn_new_career__c = count1learnnewcareer;
                objBToUpdate.No_of_students_2_learn_new_career__c = count2learnnewcareer;
                objBToUpdate.No_of_students_3_learn_new_career__c = count3learnnewcareer;
                objBToUpdate.No_of_students_4_learn_new_career__c = count4learnnewcareer;
                objBToUpdate.No_of_students_5_learn_new_career__c = count5learnnewcareer;
                objBToUpdate.No_of_students_B_learn_new_career__c = countBlearnnewcareer;
                objBToUpdate.No_of_students_1_learn_something_new__c = count1learnsomethingnew;
                objBToUpdate.No_of_students_2_learn_something_new__c = count2learnsomethingnew;
                objBToUpdate.No_of_students_3_learn_something_new__c = count3learnsomethingnew;
                objBToUpdate.No_of_students_4_learn_something_new__c = count4learnsomethingnew;
                objBToUpdate.No_of_students_5_learn_something_new__c = count5learnsomethingnew;
                objBToUpdate.No_of_students_B_learn_something_new__c = countBlearnsomethingnew;
                objBToUpdate.No_of_students_1_program_useful__c = count1programuseful;
                objBToUpdate.No_of_students_2_program_useful__c = count2programuseful;
                objBToUpdate.No_of_students_3_program_useful__c = count3programuseful;
                objBToUpdate.No_of_students_4_program_useful__c = count4programuseful;
                objBToUpdate.No_of_students_5_program_useful__c = count5programuseful;
                objBToUpdate.No_of_students_B_program_useful__c = countBprogramuseful;
                objBToUpdate.No_of_students_1_recommend_careeraware__c = count1recommendcareeraware;
                objBToUpdate.No_of_students_2_recommend_careeraware__c = count2recommendcareeraware;
                objBToUpdate.No_of_students_3_recommend_careeraware__c = count3recommendcareeraware;
                objBToUpdate.No_of_students_4_recommend_careeraware__c = count4recommendcareeraware;
                objBToUpdate.No_of_students_5_recommend_careeraware__c = count5recommendcareeraware;
                objBToUpdate.No_of_students_B_recommend_careeraware__c = countBrecommendcareeraware;
                objBToUpdate.No_of_students_1_understand_workbook__c = count1understandworkbook;
                objBToUpdate.No_of_students_2_understand_workbook__c = count2understandworkbook;
                objBToUpdate.No_of_students_3_understand_workbook__c = count3understandworkbook;
                objBToUpdate.No_of_students_4_understand_workbook__c = count4understandworkbook;
                objBToUpdate.No_of_students_5_understand_workbook__c = count5understandworkbook;
                objBToUpdate.No_of_students_B_understand_workbook__c = countBunderstandworkbook;
                objBToUpdate.No_of_students_1_way_of_teaching__c = count1wayofteaching;
                objBToUpdate.No_of_students_2_way_of_teaching__c = count2wayofteaching;
                objBToUpdate.No_of_students_3_way_of_teaching__c = count3wayofteaching;
                objBToUpdate.No_of_students_4_way_of_teaching__c = count4wayofteaching;
                objBToUpdate.No_of_students_5_way_of_teaching__c = count5wayofteaching;
                objBToUpdate.No_of_students_B_way_of_teaching__c = countBwayofteaching;
                
                objBToUpdate.No_of_students_Guardian_Present__c = countgurdainpresent;
                objBToUpdate.No_of_students_Guardian_Absent__c = countgurdainabsent;
                objBToUpdate.No_of_Students_in_G_10_left_school_20_21__c = NumberofStudentLeftSchool;                    
                lstBatchstoUpdate.add(objBToUpdate);
            }
            
            if(lstBatchstoUpdate.size() > 0) {
                update lstBatchstoUpdate;
            }
        }
    }
    
    public static Integer CheckOption(string value, string option){
        Integer match = 0;
        if(value == option) {
            match = 1;
        }
        return match;
    }
    
    public void finish(Database.BatchableContext context) {
        
    }
}