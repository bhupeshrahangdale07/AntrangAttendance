/*
Description: Class is created for Contac trigger handler
*/
public class ContactTriggerHandler {
    public static Boolean CallOutforContact = false;
    public static Boolean PlanA_B_recurssion = false;
    public static Boolean recurssionOfPB = false; 
    
    public static void UpdateNumberofStudent(List<Contact> lstContacts, map<Id,Contact> mapOldContacts, 
                                             boolean isInsert, boolean isUpdate, boolean isDelete, boolean isUndelete){
                                                 Id caStudentRTID = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
                                                 set<Id> setofbatchId = new set<Id>();
                                                 
                                                 for(Contact objCon: lstContacts) {
                                                     if(objCon.RecordTypeId == caStudentRTID) {
                                                         if((isInsert || isDelete || isUndelete)) {
                                                             If(objCon.Batch_Code__c != null){
                                                                 setofbatchId.add(objCon.Batch_Code__c); 
                                                             }
                                                             If(objCon.G10_Batch_Code__c != null){
                                                                 setofbatchId.add(objCon.G10_Batch_Code__c); 
                                                             }
                                                             If(objCon.G11_Batch_Code__c != null){
                                                                 setofbatchId.add(objCon.G11_Batch_Code__c); 
                                                             }
                                                             If(objCon.G12_Batch_Code__c != null){
                                                                 setofbatchId.add(objCon.G12_Batch_Code__c); 
                                                             }
                                                         }
                                                         if(isUpdate && (objCon.Batch_Code__c != mapOldContacts.get(objCon.Id).Batch_Code__c || 
                                                                         objCon.G10_Batch_Code__c != mapOldContacts.get(objCon.Id).G10_Batch_Code__c ||
                                                                         objCon.G11_Batch_Code__c != mapOldContacts.get(objCon.Id).G11_Batch_Code__c ||
                                                                         objCon.G12_Batch_Code__c != mapOldContacts.get(objCon.Id).G12_Batch_Code__c ||
                                                                         objCon.Counselling_Session_Attended__c != mapOldContacts.get(objCon.Id).Counselling_Session_Attended__c ||
                                                                         objCon.I_agree_with_the_recommendation__c != mapOldContacts.get(objCon.Id).I_agree_with_the_recommendation__c ||
                                                                         objCon.I_am_clear_about_what_I_need_to_do_after__c != mapOldContacts.get(objCon.Id).I_am_clear_about_what_I_need_to_do_after__c ||
                                                                         objCon.Was_the_Program_useful_and_helpful_for_y__c != mapOldContacts.get(objCon.Id).Was_the_Program_useful_and_helpful_for_y__c || 
                                                                         objCon.Did_you_learn_something_new_about_yourse__c != mapOldContacts.get(objCon.Id).Did_you_learn_something_new_about_yourse__c ||
                                                                         objCon.Did_you_learn_about_some_new_Careers__c != mapOldContacts.get(objCon.Id).Did_you_learn_about_some_new_Careers__c ||
                                                                         objCon.Was_the_teacher_s_way_of_teaching_easy_t__c != mapOldContacts.get(objCon.Id).Was_the_teacher_s_way_of_teaching_easy_t__c ||
                                                                         objCon.Did_the_teacher_clear_all_your_doubts__c != mapOldContacts.get(objCon.Id).Did_the_teacher_clear_all_your_doubts__c ||
                                                                         objCon.Were_you_able_to_understand_the_workbook__c != mapOldContacts.get(objCon.Id).Were_you_able_to_understand_the_workbook__c ||
                                                                         objCon.Would_you_recommend_the_CareerAware_prog__c != mapOldContacts.get(objCon.Id).Would_you_recommend_the_CareerAware_prog__c ||
                                                                         objCon.Guardian_Attendance__c != mapOldContacts.get(objCon.Id).Guardian_Attendance__c ||
                                                                         objCon.Follow_up_1_training_done__c != mapOldContacts.get(objCon.Id).Follow_up_1_training_done__c||
                                                                         objCon.Follow_up_2_training_done__c != mapOldContacts.get(objCon.Id).Follow_up_2_training_done__c ||
                                                                         objCon.Import_Status__c != mapOldContacts.get(objCon.Id).Import_Status__c ||
                                                                         objCon.Recommendation_Report_Status__c != mapOldContacts.get(objCon.Id).Recommendation_Report_Status__c ||
                                                                         objCon.Facilitated_with_Baseline_1__c != mapOldContacts.get(objCon.Id).Facilitated_with_Baseline_1__c ||
                                                                         objCon.Pre_follow_up_status__c != mapOldContacts.get(objCon.Id).Pre_follow_up_status__c||
                                                                         objCon.Attendance__c != mapOldContacts.get(objCon.Id).Attendance__c ||
                                                                         objCon.Day_1__c != mapOldContacts.get(objCon.Id).Day_1__c || 
                                                                         objCon.Day_2__c != mapOldContacts.get(objCon.Id).Day_2__c ||
                                                                         objCon.Day_3__c != mapOldContacts.get(objCon.Id).Day_3__c ||
                                                                         objCon.Day_4__c != mapOldContacts.get(objCon.Id).Day_4__c ||
                                                                         objCon.Day_5__c != mapOldContacts.get(objCon.Id).Day_5__c)) {
                                                                             If(objCon.Batch_Code__c != null){
                                                                                 setofbatchId.add(objCon.Batch_Code__c); 
                                                                             }
                                                                             If(objCon.G10_Batch_Code__c != null){
                                                                                 setofbatchId.add(objCon.G10_Batch_Code__c); 
                                                                             }
                                                                             If(objCon.G11_Batch_Code__c != null){
                                                                                 setofbatchId.add(objCon.G11_Batch_Code__c); 
                                                                             }
                                                                             If(objCon.G12_Batch_Code__c != null){
                                                                                 setofbatchId.add(objCon.G12_Batch_Code__c); 
                                                                             }
                                                                             if(mapOldContacts.get(objCon.Id).Batch_Code__c != null) {
                                                                                 setofbatchId.add(mapOldContacts.get(objCon.Id).Batch_Code__c); 
                                                                             }
                                                                             if(mapOldContacts.get(objCon.Id).G10_Batch_Code__c != null) {
                                                                                 setofbatchId.add(mapOldContacts.get(objCon.Id).G10_Batch_Code__c); 
                                                                             }
                                                                             if(mapOldContacts.get(objCon.Id).G11_Batch_Code__c != null) {
                                                                                 setofbatchId.add(mapOldContacts.get(objCon.Id).G11_Batch_Code__c); 
                                                                             }
                                                                             if(mapOldContacts.get(objCon.Id).G12_Batch_Code__c != null) {
                                                                                 setofbatchId.add(mapOldContacts.get(objCon.Id).G12_Batch_Code__c); 
                                                                             }
                                                                         }
                                                     }
                                                 }
                                                 if(setofbatchId.size() > 0) 
                                                 {
                                                     List<Batch__c> lstBatchstoUpdate = new List<Batch__c>();
                                                     Datetime dtPreviousYear2020 = DateTime.newinstance(2020, 04, 30, 0, 0, 0);
                                                     List<Batch__c> lstBatchOfContact = [select Id, Date_of_facilitation_starting__c, (select Id,Attendance__c,Counselling_Session_Attended__c,I_agree_with_the_recommendation__c,I_am_clear_about_what_I_need_to_do_after__c,
                                                                                                                                       Was_the_Program_useful_and_helpful_for_y__c,Did_you_learn_something_new_about_yourse__c,Did_you_learn_about_some_new_Careers__c,
                                                                                                                                       Was_the_teacher_s_way_of_teaching_easy_t__c,Did_the_teacher_clear_all_your_doubts__c,Were_you_able_to_understand_the_workbook__c,Pre_follow_up_status__c, 
                                                                                                                                       Would_you_recommend_the_CareerAware_prog__c,Guardian_Attendance__c,Follow_up_1_training_done__c,Follow_up_2_training_done__c,
                                                                                                                                       Followup_1_Change_in_Fitment__c,Followup_1_Change_in_Reccomendation__c,Followup_1_Clear_Next_Steps__c,Followup_1_Match_I_A__c,
                                                                                                                                       Import_Status__c, Recommendation_Report_Status__c,Followup_2_Change_in_Fitment__c,Followup_2_Change_in_Reccomendation__c,Facilitated_with_Baseline_1__c
                                                                                                                                       from Contacts__r),(select Id,Attendance__c from Contacts1__r),(select Id,Attendance__c from Contacts2__r),
                                                                                         (select Id,Attendance__c from Contacts3__r)from Batch__c Where Id in: setofbatchId];
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
                                                             if(objCon.Attendance__c > 0){
                                                                 noofstudentsfacilitated++;
                                                             }
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
                                                         objBToUpdate.Number_of_students_pending_counselling__c = string.valueof(objBToUpdate.Number_of_students_facilitated__c - objBToUpdate.Number_of_students_counselled__c);
                                                         
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
    
    
    
    //update followup details
    public static void UpdateFollowupDetails(List<Contact> lstContacts){
        map<string, Question_Bank__c> mapofFU1QuestionBanks = new map<string, Question_Bank__c>();
        map<string, Question_Bank__c> mapofFU2QuestionBanks = new map<string, Question_Bank__c>();
        map<string, IARP_Master__c> mapIARPMasters = new map<string,IARP_Master__c>();
        Id caStudentRTID = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        for(IARP_Master__c objIM: [select Id,Aspiration_1__c,Aptitude_1__c,Aptitude_2__c,Interest_1__c, Interest_2__c 
                                   from IARP_Master__c]){
                                       mapIARPMasters.put(objIM.Aspiration_1__c, objIM);
                                   }
        
        
        for(Question_Bank__c qb: [select Category__c,Category1__c,Name from Question_Bank__c where (Category1__c = 'Followup 1' OR Category1__c = 'Followup 2')]){
            if(qb.Category1__c == 'Followup 1'){
                mapofFU1QuestionBanks.put(qb.Name, qb);
            }
            if(qb.Category1__c == 'Followup 2'){
                mapofFU2QuestionBanks.put(qb.Name, qb);
            }
        }
        for(Contact objCon: lstContacts){
            if(objCon.RecordTypeId == caStudentRTID) {
                //Follow up training picklist populate
                objCon.Follow_up_1_training_done__c = 'No';
                if(String.isNotBlank(objCon.Followup1Aspiration__c) || objCon.Followup_1_Baseline_1__c != null || objCon.Followup_1_Baseline_2__c != null ||
                   objCon.Followup_1_Baseline_3__c != null || objCon.Followup_1_Baseline_4__c != null || objCon.Followup_1_Baseline_5__c != null ||
                   objCon.Followup_1_Baseline_6__c != null || objCon.Followup_1_Baseline_7__c != null || objCon.Followup_1_Endline_1__c != null ||
                   objCon.Followup_1_Endline_2__c != null || objCon.Followup_1_Endline_3__c != null || objCon.Followup_1_Endline_4__c != null ||
                   objCon.Followup_1_Endline_5__c != null || objCon.Followup_1_Endline_6__c != null || objCon.Followup_1_Endline_7__c != null ||
                   objCon.Followup_1_Endline_8__c != null || objCon.Post_follow_up_Conf_status__c =='Present'){
                       objCon.Follow_up_1_training_done__c = 'Yes';
                   }
                objCon.Follow_up_2_training_done__c = 'No';
                if(String.isNotBlank(objCon.Followup2Aspiration__c) || objCon.Followup_2_Baseline_1__c != null || objCon.Followup_2_Baseline_2__c != null ||
                   objCon.Followup_2_Baseline_3__c != null || objCon.Followup_2_Baseline_4__c != null || objCon.Followup_2_Baseline_5__c != null ||
                   objCon.Followup_2_Baseline_6__c != null || objCon.Followup_2_Baseline_7__c != null || objCon.Followup_2_Endline_1__c != null ||
                   objCon.Followup_2_Endline_2__c != null || objCon.Followup_2_Endline_3__c != null || objCon.Followup_2_Endline_4__c != null ||
                   objCon.Followup_2_Endline_5__c != null || objCon.Followup_2_Endline_6__c != null || objCon.Followup_2_Endline_7__c != null ||
                   objCon.Followup_2_Endline_8__c != null){
                       objCon.Follow_up_2_training_done__c = 'Yes';
                   }
                
                //Follow up 1 CheckIn and CheckOut
                Integer countofFU1CheckIn = 0;
                Integer countofFU1CheckOut = 0;
                //followup 1 checkin count
                /*if(objCon.Followup_1_Baseline_1__c != null && mapofFU1QuestionBanks.containskey('Baseline 1')) {
countofFU1CheckIn += getCountForCareerAwarenessStream(objCon.Followup_1_Baseline_1__c, mapofFU1QuestionBanks.get('Baseline 1'));
}*/
                if(objCon.Followup_1_Baseline_2__c != null && mapofFU1QuestionBanks.containskey('Baseline 2')) {
                    countofFU1CheckIn += getCountForCareerAwarenessStream(objCon.Followup_1_Baseline_2__c, mapofFU1QuestionBanks.get('Baseline 2'));
                }
                if(objCon.Followup_1_Baseline_3__c != null && mapofFU1QuestionBanks.containskey('Baseline 3')) {
                    countofFU1CheckIn += getCountForCareerAwarenessStream(objCon.Followup_1_Baseline_3__c, mapofFU1QuestionBanks.get('Baseline 3'));
                }
                if(objCon.Followup_1_Baseline_4__c != null && mapofFU1QuestionBanks.containskey('Baseline 4')) {
                    countofFU1CheckIn += getCountForCareerAwarenessStream(objCon.Followup_1_Baseline_4__c, mapofFU1QuestionBanks.get('Baseline 4'));
                }
                if(objCon.Followup_1_Baseline_5__c != null && mapofFU1QuestionBanks.containskey('Baseline 5')) {
                    countofFU1CheckIn += getCountForCareerAwarenessStream(objCon.Followup_1_Baseline_5__c, mapofFU1QuestionBanks.get('Baseline 5'));
                }
                if(objCon.Followup_1_Baseline_6__c != null && mapofFU1QuestionBanks.containskey('Baseline 6')) {
                    countofFU1CheckIn += getCountForCareerAwarenessStream(objCon.Followup_1_Baseline_6__c, mapofFU1QuestionBanks.get('Baseline 6'));
                }
                
                //followup 1 checkout count
                /*if(objCon.Followup_1_Endline_1__c != null && mapofFU1QuestionBanks.containskey('Endline 1')) {
countofFU1CheckOut += getCountForCareerAwarenessStream(objCon.Followup_1_Endline_1__c , mapofFU1QuestionBanks.get('Endline 1'));
}*/
                if(objCon.Followup_1_Endline_2__c != null && mapofFU1QuestionBanks.containskey('Endline 2')) {
                    countofFU1CheckOut += getCountForCareerAwarenessStream(objCon.Followup_1_Endline_2__c , mapofFU1QuestionBanks.get('Endline 2'));
                }
                if(objCon.Followup_1_Endline_3__c != null && mapofFU1QuestionBanks.containskey('Endline 3')) {
                    countofFU1CheckOut += getCountForCareerAwarenessStream(objCon.Followup_1_Endline_3__c , mapofFU1QuestionBanks.get('Endline 3'));
                }
                if(objCon.Followup_1_Endline_4__c != null && mapofFU1QuestionBanks.containskey('Endline 4')) {
                    countofFU1CheckOut += getCountForCareerAwarenessStream(objCon.Followup_1_Endline_4__c , mapofFU1QuestionBanks.get('Endline 4'));
                }
                if(objCon.Followup_1_Endline_5__c != null && mapofFU1QuestionBanks.containskey('Endline 5')) {
                    countofFU1CheckOut += getCountForCareerAwarenessStream(objCon.Followup_1_Endline_5__c , mapofFU1QuestionBanks.get('Endline 5'));
                }
                if(objCon.Followup_1_Endline_6__c != null && mapofFU1QuestionBanks.containskey('Endline 6')) {
                    countofFU1CheckOut += getCountForCareerAwarenessStream(objCon.Followup_1_Endline_6__c , mapofFU1QuestionBanks.get('Endline 6'));
                }
                objCon.Followup_1_Checkin_Score__c = countofFU1CheckIn;
                objCon.Followup_1_Checkout_Score__c = countofFU1CheckOut;
                
                //Follow up 2 CheckIn and CheckOut
                Integer countofFU2CheckIn = 0;
                Integer countofFU2CheckOut = 0;
                //followup 2 checkin count
                /*if(objCon.Followup_2_Baseline_1__c != null && mapofFU2QuestionBanks.containskey('Baseline 1')) {
countofFU2CheckIn += getCountForCareerAwarenessStream(objCon.Followup_2_Baseline_1__c, mapofFU2QuestionBanks.get('Baseline 1'));
}*/
                if(objCon.Followup_2_Baseline_2__c != null && mapofFU2QuestionBanks.containskey('Baseline 2')) {
                    countofFU2CheckIn += getCountForCareerAwarenessStream(objCon.Followup_2_Baseline_2__c, mapofFU2QuestionBanks.get('Baseline 2'));
                }
                if(objCon.Followup_2_Baseline_3__c != null && mapofFU2QuestionBanks.containskey('Baseline 3')) {
                    countofFU2CheckIn += getCountForCareerAwarenessStream(objCon.Followup_2_Baseline_3__c, mapofFU2QuestionBanks.get('Baseline 3'));
                }
                if(objCon.Followup_2_Baseline_4__c != null && mapofFU2QuestionBanks.containskey('Baseline 4')) {
                    countofFU2CheckIn += getCountForCareerAwarenessStream(objCon.Followup_2_Baseline_4__c, mapofFU2QuestionBanks.get('Baseline 4'));
                }
                if(objCon.Followup_2_Baseline_5__c != null && mapofFU2QuestionBanks.containskey('Baseline 5')) {
                    countofFU2CheckIn += getCountForCareerAwarenessStream(objCon.Followup_2_Baseline_5__c, mapofFU2QuestionBanks.get('Baseline 5'));
                }
                if(objCon.Followup_2_Baseline_6__c != null && mapofFU2QuestionBanks.containskey('Baseline 6')) {
                    countofFU2CheckIn += getCountForCareerAwarenessStream(objCon.Followup_2_Baseline_6__c, mapofFU2QuestionBanks.get('Baseline 6'));
                }
                
                //followup 2 checkout count
                /*if(objCon.Followup_2_Endline_1__c != null && mapofFU2QuestionBanks.containskey('Endline 1')) {
countofFU2CheckOut += getCountForCareerAwarenessStream(objCon.Followup_2_Endline_1__c , mapofFU2QuestionBanks.get('Endline 1'));
}*/
                if(objCon.Followup_2_Endline_2__c != null && mapofFU2QuestionBanks.containskey('Endline 2')) {
                    countofFU2CheckOut += getCountForCareerAwarenessStream(objCon.Followup_2_Endline_2__c , mapofFU2QuestionBanks.get('Endline 2'));
                }
                if(objCon.Followup_2_Endline_3__c != null && mapofFU2QuestionBanks.containskey('Endline 3')) {
                    countofFU2CheckOut += getCountForCareerAwarenessStream(objCon.Followup_2_Endline_3__c , mapofFU2QuestionBanks.get('Endline 3'));
                }
                if(objCon.Followup_2_Endline_4__c != null && mapofFU2QuestionBanks.containskey('Endline 4')) {
                    countofFU2CheckOut += getCountForCareerAwarenessStream(objCon.Followup_2_Endline_4__c , mapofFU2QuestionBanks.get('Endline 4'));
                }
                if(objCon.Followup_2_Endline_5__c != null && mapofFU2QuestionBanks.containskey('Endline 5')) {
                    countofFU2CheckOut += getCountForCareerAwarenessStream(objCon.Followup_2_Endline_5__c , mapofFU2QuestionBanks.get('Endline 5'));
                }
                if(objCon.Followup_2_Endline_6__c != null && mapofFU2QuestionBanks.containskey('Endline 6')) {
                    countofFU2CheckOut += getCountForCareerAwarenessStream(objCon.Followup_2_Endline_6__c , mapofFU2QuestionBanks.get('Endline 6'));
                }
                objCon.Followup_2_Checkin_Score__c = countofFU2CheckIn;
                objCon.Followup_2_Checkout_Score__c = countofFU2CheckOut;
                
                if(objCon.Follow_up_1_training_done__c == 'Yes'){
                    if(String.isnotBlank(objCon.Followup1Aspiration__c) && mapIARPMasters.containskey(objCon.Followup1Aspiration__c)){
                        IARP_Master__c objIM = mapIARPMasters.get(objCon.Followup1Aspiration__c);
                        if((objCon.Aptitude_1__c == objIM.Aptitude_1__c || objCon.Aptitude_2__c == objIM.Aptitude_1__c ||
                            objCon.Aptitude_1__c == objIM.Aptitude_2__c || objCon.Aptitude_2__c == objIM.Aptitude_2__c) &&
                           (objCon.Interest_1__c == objIM.Interest_1__c || objCon.Interest_2__c == objIM.Interest_1__c ||
                            objCon.Interest_1__c == objIM.Interest_2__c || objCon.Interest_2__c == objIM.Interest_2__c)) {
                                objCon.Followup_1_Match_I_A__c = 'Yes';
                            } else {
                                objCon.Followup_1_Match_I_A__c = 'No';
                            }
                    } else {
                        objCon.Followup_1_Match_I_A__c = 'Data not available';
                    }
                }
            }
        }
    }
    
    //update counselling attendend
    public static void CounsellingAttendance(List<Contact> lstContacts){
        Id caStudentRTID = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        for(Contact objCon: lstContacts){
            if(objCon.RecordTypeId == caStudentRTID) {
                if(objCon.I_agree_with_the_recommendation__c != null || objCon.I_am_clear_about_what_I_need_to_do_after__c != null || 
                   objCon.Was_the_Program_useful_and_helpful_for_y__c != null || objCon.Did_you_learn_something_new_about_yourse__c != null ||
                   objCon.Did_you_learn_about_some_new_Careers__c != null || objCon.Was_the_teacher_s_way_of_teaching_easy_t__c != null ||
                   objCon.Did_the_teacher_clear_all_your_doubts__c != null || objCon.Were_you_able_to_understand_the_workbook__c != null ||
                   objCon.Would_you_recommend_the_CareerAware_prog__c != null||objCon.Student_Attendance__c == 'Present' ||
                   objCon.Guardian_Attendance__c != null){
                       objCon.Counselling_Session_Attended__c = true;
                   } else {
                       objCon.Counselling_Session_Attended__c = false;
                   }
            }
        }
    }
    
    //update IARP Status and Recommendation status when Import Status changed
    public static void UpdateStatuses(List<Contact> lstContacts, map<Id,Contact> mapOldContacts){
        set<string> setStatusesToCheck = new set<string>();
        setStatusesToCheck.add('Baseline 1 Imported');
        setStatusesToCheck.add('Baseline 2 Imported');
        setStatusesToCheck.add('Career Awareness Imported');
        setStatusesToCheck.add('Career Planning Imported');
        Id caStudentRTID = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        for(Contact objCon: lstContacts){
            if(objCon.Import_Status__c != mapOldContacts.get(objCon.Id).Import_Status__c && 
               mapOldContacts.get(objCon.Id).Import_Status__c != null && objCon.RecordTypeId == caStudentRTID){
                   if((mapOldContacts.get(objCon.Id).Import_Status__c == 'Self Awareness Imported' || mapOldContacts.get(objCon.Id).Import_Status__c == 'Import Completed') && setStatusesToCheck.contains(objCon.Import_Status__c)){
                       objCon.Status__c = 'Not Processed';
                       objCon.Recommedation_Status__c = 'Not Processed';
                       objCon.Profession_1__c = null;
                       objCon.Profession_2__c = null;
                       objCOn.Recommendation_Path__c = null;
                       objCon.Recommendation_Type__c = null;
                   }
               }
        }
    }
    
    //update career track and clarity reports
    public static void UpdateCareerTracksAndClarityReports(List<Contact> lstContacts, map<Id,Contact> mapOldContacts){
        
        List<Contact> careerAwarenessContacts = new List<Contact>();
        List<Contact> careerPlanningContacts = new List<Contact>();
        
        set<Id> setofPossibleCareers = new set<Id>();
        map<string,IARP_Master__c> mapIRAPmastersbyname = new map<string,IARP_Master__c>();
        map<Id, IARP_Master__c> mapIARPMasters = new map<Id,IARP_Master__c>();
        for(IARP_Master__c iarp : [select Id, Name, Aptitude_1__c, Aptitude_2__c, Aptitude_3__c,Interest_1__c, Interest_2__c, Interest_3__c from IARP_Master__c]){
            
            mapIRAPmastersbyname.put(iarp.name,iarp);
            mapIARPMasters.put(iarp.id,iarp);
        }
        Id caStudentRTID = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        for(Contact objCon: lstContacts){
            if(objCon.RecordTypeId == caStudentRTID) {
                if(objCon.Import_Status__c == 'Career Awareness Imported' && 
                   (mapOldContacts == null || objCon.Import_Status__c != mapOldContacts.get(objCon.Id).Import_Status__c)){//added condition to calculate CCP
                       careerAwarenessContacts.add(objCon);
                   }
                
                if((objCon.Import_Status__c == 'Career Planning Imported' && 
                    (mapOldContacts == null || objCon.Import_Status__c != mapOldContacts.get(objCon.Id).Import_Status__c)) ||
                   ((objCon.Attendance__c >= 1 && (mapOldContacts == null || objCon.Attendance__c != mapOldContacts.get(objCon.Id).Attendance__c))||  
                    (objCon.Additional_CA_Call_2__c  == 'Present' && (mapOldContacts == null || objCon.Additional_CA_Call_2__c  != mapOldContacts.get(objCon.Id).Additional_CA_Call_2__c  )))){
                        careerPlanningContacts.add(objCon);
                    }
                
                //populate possible career count
                Integer possiblecareercount = 0;
                if(objCon.Possible_Careers_1__c != null && mapIARPMasters.containskey(objCon.Possible_Careers_1__c)){
                    IARP_Master__c possiblecareer1 = mapIARPMasters.get(objCon.Possible_Careers_1__c);
                    if(isValidInterest(objCon, possiblecareer1) && isValidAptitude(objCon, possiblecareer1)){
                        possiblecareercount = possiblecareercount + 1;
                    }
                }
                if(objCon.Possible_Careers_2__c != null && mapIARPMasters.containskey(objCon.Possible_Careers_2__c)){
                    IARP_Master__c possiblecareer2 = mapIARPMasters.get(objCon.Possible_Careers_2__c);
                    if(isValidInterest(objCon, possiblecareer2) && isValidAptitude(objCon, possiblecareer2)){
                        possiblecareercount = possiblecareercount + 1;
                    }
                }
                if(objCon.Possible_Careers_3__c != null && mapIARPMasters.containskey(objCon.Possible_Careers_3__c)){
                    IARP_Master__c possiblecareer3 = mapIARPMasters.get(objCon.Possible_Careers_3__c);
                    if(isValidInterest(objCon, possiblecareer3) && isValidAptitude(objCon, possiblecareer3)){
                        possiblecareercount = possiblecareercount + 1;
                    }
                }
                //set possible career count report
                objCon.possible_career_report__c = possiblecareercount;
                
                if(objCon.Current_Aspiration__c != null && string.isnotblank(objCon.Current_Aspiration__c) && ((string.isnotblank(objCon.Aptitude_1__c) ||
                                                                                                                string.isnotblank(objCon.Aptitude_2__c) || string.isnotblank(objCon.Aptitude_3__c)) && (string.isnotblank(objCon.Interest_1__c) ||
                                                                                                                                                                                                        string.isnotblank(objCon.Interest_2__c) || string.isnotblank(objCon.Interest_3__c)))){
                                                                                                                                                                                                            if(mapIRAPmastersbyname.containskey(objCon.Current_Aspiration__c)){
                                                                                                                                                                                                                IARP_Master__c CurrentAspiration = mapIRAPmastersbyname.get(objCon.Current_Aspiration__c);
                                                                                                                                                                                                                if(isValidInterest(objCon, CurrentAspiration) && isValidAptitude(objCon, CurrentAspiration)){
                                                                                                                                                                                                                    objCon.has_self_aware_career_choice_at_baseline__c = 'Yes';
                                                                                                                                                                                                                } else {
                                                                                                                                                                                                                    objCon.has_self_aware_career_choice_at_baseline__c = 'No';
                                                                                                                                                                                                                }
                                                                                                                                                                                                            } else {
                                                                                                                                                                                                                objCon.has_self_aware_career_choice_at_baseline__c = 'No';
                                                                                                                                                                                                            }
                                                                                                                                                                                                        } else {
                                                                                                                                                                                                            objCon.has_self_aware_career_choice_at_baseline__c = 'Data is not available';
                                                                                                                                                                                                        }
            }
        }
        
        // Clarity Report Calculation
        if(!careerPlanningContacts.isEmpty()) {
            
            /*List<string> correctQBAns = new List<string>();
for(Question_Bank__c qb: [select Category__c from Question_Bank__c where Category1__c = 'Clarity' order by name Limit 3]){
correctQBAns.add(qb.Category__c);
}*/
            
            for(Contact objCon : careerPlanningContacts) {
                /*if (objCon.CCP_1__c == null && objCon.CCP_2__c== null && objCon.CCP_3__c == null) {
objCon.Clarity_Report__c = 'Data is not available';
} else if(objCon.CCP_1__c != null && objCon.CCP_2__c != null && objCon.CCP_3__c != null && correctQBAns.size() > 0){
if (correctQBAns.get(0).contains(objCon.CCP_1__c) && correctQBAns.get(1).contains(objCon.CCP_2__c) && correctQBAns.get(2).contains(objCon.CCP_3__c)) {
objCon.Clarity_Report__c = 'Yes';
} else {
objCon.Clarity_Report__c = 'No';
}
} else {
objCon.Clarity_Report__c = 'No';
}*/
                if ((objCon.CCP_1__c == null || string.isblank(objCon.CCP_1__c)) && (objCon.CCP_2__c== null || string.isblank(objCon.CCP_2__c))) {
                    objCon.Clarity_Report__c = 'Data is not available';
                } else if(objCon.CCP_1__c != null && objCon.CCP_2__c != null && (
                    (objCon.CCP_1__c == '1' && (objCon.CCP_2__c == '2' || objCon.CCP_2__c == '3' || objCon.CCP_2__c == '4')) || 
                    (objCon.CCP_1__c == '2' && objCon.CCP_2__c == '4') || 
                    (objCon.CCP_1__c == '3' && (objCon.CCP_2__c == '1' || objCon.CCP_2__c == '2' || objCon.CCP_2__c == '3' || objCon.CCP_2__c == '4'))
                )) {
                    objCon.Clarity_Report__c = 'Yes';
                } else {
                    objCon.Clarity_Report__c = 'No';
                }
            }
        }
        
        // Career Track calculation
        if(!careerAwarenessContacts.isEmpty()) {
            map<string,List<Question_Bank__c>> mapOfQuestionBank = new map<string,List<Question_Bank__c>>();
            List<Question_Bank__c> lstQuestionBank = [select Category__c,Category1__c from Question_Bank__c];
            for(Question_Bank__c qb : lstQuestionBank){
                List<Question_Bank__c> newListOfQB = new List<Question_Bank__c>();
                if(mapOfQuestionBank.containsKey(qb.Category1__c)){
                    newListOfQB = mapOfQuestionBank.get(qb.Category1__c);
                    newListOfQB.add(qb);
                    mapOfQuestionBank.put(qb.Category1__c,newListOfQB);
                }
                else{
                    newListOfQB.add(qb);
                    mapOfQuestionBank.put(qb.Category1__c,newListOfQB);
                }
            }
            
            /**List<Question_Bank__c> conIndustry = mapOfQuestionBank.get('Industry Agnostic');
List<Question_Bank__c> conDesign = mapOfQuestionBank.get('Arts and Design');
List<Question_Bank__c> conMedi = mapOfQuestionBank.get('Media and Entertainment');
List<Question_Bank__c> conFinance = mapOfQuestionBank.get('Finance');
List<Question_Bank__c> conHealthcar = mapOfQuestionBank.get('Healthcare');
List<Question_Bank__c> conHospi = mapOfQuestionBank.get('Tourism and Hospitality');
List<Question_Bank__c> conWellness = mapOfQuestionBank.get('Wellness and Fitness');
List<Question_Bank__c> conEdu = mapOfQuestionBank.get('Education');
List<Question_Bank__c> conPubser = mapOfQuestionBank.get('Public services');
List<Question_Bank__c> conEnv = mapOfQuestionBank.get('Environment and Bioscience');
List<Question_Bank__c> conTrade = mapOfQuestionBank.get('Trades');
List<Question_Bank__c> conIT = mapOfQuestionBank.get('Information Technology'); **/
            
            /**List<Question_Bank__c> conIndustry  = [select Category__c from Question_Bank__c where Category1__c = 'Industry Agnostic'];
List<Question_Bank__c> conDesign    = [select Category__c from Question_Bank__c where Category1__c = 'Arts and Design'];
List<Question_Bank__c> conMedi      = [select Category__c from Question_Bank__c where Category1__c = 'Media and Entertainment'];
List<Question_Bank__c> conFinance   = [select Category__c from Question_Bank__c where Category1__c = 'Finance'];
List<Question_Bank__c> conHealthcar = [select Category__c from Question_Bank__c where Category1__c = 'Healthcare'];
List<Question_Bank__c> conHospi     = [select Category__c from Question_Bank__c where Category1__c = 'Tourism and Hospitality'];
//List<Question_Bank__c> conRetail    = [select Category__c from Question_Bank__c where Category1__c = 'Retail'];
List<Question_Bank__c> conWellness  = [select Category__c from Question_Bank__c where Category1__c = 'Wellness and Fitness'];
List<Question_Bank__c> conEdu       = [select Category__c from Question_Bank__c where Category1__c = 'Education'];
List<Question_Bank__c> conPubser    = [select Category__c from Question_Bank__c where Category1__c = 'Public services'];
List<Question_Bank__c> conEnv       = [select Category__c from Question_Bank__c where Category1__c = 'Environment and Bioscience'];
List<Question_Bank__c> conTrade     = [select Category__c from Question_Bank__c where Category1__c = 'Trades'];
List<Question_Bank__c> conIT    = [select Category__c from Question_Bank__c where Category1__c = 'Information Technology']; **/
            
            /*List<Question_Bank__c> conPerform   = [select Category__c from Question_Bank__c where Category1__c = 'Performance Arts'];
List<Question_Bank__c> conSport     = [select Category__c from Question_Bank__c where Category1__c = 'Sports and fitness'];
List<Question_Bank__c> conMedical   = [select Category__c from Question_Bank__c where Category1__c = 'Medical'];
List<Question_Bank__c> conEngg      = [select Category__c from Question_Bank__c where Category1__c = 'Engineering'];*/
            
            
            for(Contact objCon : careerAwarenessContacts) {
                // Set Track to -1 if all career aware detail is blank.
                if (objCon.Industry_Agnostic__c == null && objCon.Performance_Arts__c == null && objCon.Media_Communication__c == null && objCon.Finance__c == null &&
                    objCon.Healthcare__c == null && objCon.Hospitality_Tourism__c == null && objCon.Information_Technology__c == null && 
                    objCon.Beauty_Wellness__c == null && objCon.Education__c == null && objCon.Public_Services__c == null &&
                    objCon.Enviomental_and_Biological_Sciences__c == null && objCon.Trades__c == null){
                        objCon.Career_Tracks__c = -1;
                    } 
                else {
                    
                    // Map of Category with Count
                    Map<String,Integer> categoryCountMap = new Map<String,Integer>();
                    
                    Integer count = getCountForCareerAwarenessStream(objCon.Industry_Agnostic__c, mapOfQuestionBank.get('Industry Agnostic').size() > 0 ? mapOfQuestionBank.get('Industry Agnostic')[0] : null);
                    categoryCountMap.put('Industry Agnostic', count);
                    
                    count = getCountForCareerAwarenessStream(objCon.Performance_Arts__c, mapOfQuestionBank.get('Arts and Design').size() > 0 ? mapOfQuestionBank.get('Arts and Design')[0] : null);
                    categoryCountMap.put('Arts and Design', count);
                    
                    count = getCountForCareerAwarenessStream(objCon.Media_Communication__c, mapOfQuestionBank.get('Media and Entertainment').size() > 0 ? mapOfQuestionBank.get('Media and Entertainment')[0] : null);
                    categoryCountMap.put('Media and Entertainment', count);
                    
                    count = getCountForCareerAwarenessStream(objCon.Finance__c, mapOfQuestionBank.get('Finance').size() > 0 ? mapOfQuestionBank.get('Finance')[0] : null);
                    categoryCountMap.put('Finance', count);
                    
                    count = getCountForCareerAwarenessStream(objCon.Healthcare__c, mapOfQuestionBank.get('Healthcare').size() > 0 ? mapOfQuestionBank.get('Healthcare')[0] : null);
                    categoryCountMap.put('Healthcare', count);
                    
                    count = getCountForCareerAwarenessStream(objCon.Hospitality_Tourism__c, mapOfQuestionBank.get('Tourism and Hospitality').size() > 0 ? mapOfQuestionBank.get('Tourism and Hospitality')[0] : null);
                    categoryCountMap.put('Tourism and Hospitality', count);
                    
                    /*count = getCountForCareerAwarenessStream(objCon.Retail__c, conRetail.size() > 0 ? conRetail[0] : null);
categoryCountMap.put('Retail', count);*/
                    count = getCountForCareerAwarenessStream(objCon.Information_Technology__c, mapOfQuestionBank.get('Information Technology').size() > 0 ? mapOfQuestionBank.get('Information Technology')[0] : null);
                    categoryCountMap.put('Information Technology', count);
                    
                    count = getCountForCareerAwarenessStream(objCon.Beauty_Wellness__c, mapOfQuestionBank.get('Wellness and Fitness').size() > 0 ? mapOfQuestionBank.get('Wellness and Fitness')[0] : null);
                    categoryCountMap.put('Wellness and Fitness', count);
                    
                    count = getCountForCareerAwarenessStream(objCon.Education__c, mapOfQuestionBank.get('Education').size() > 0 ? mapOfQuestionBank.get('Education')[0] : null);
                    categoryCountMap.put('Education', count);
                    
                    count = getCountForCareerAwarenessStream(objCon.Public_Services__c, mapOfQuestionBank.get('Public services').size() > 0 ? mapOfQuestionBank.get('Public services')[0] : null);
                    categoryCountMap.put('Public services', count);
                    
                    count = getCountForCareerAwarenessStream(objCon.Enviomental_and_Biological_Sciences__c, mapOfQuestionBank.get('Environment and Bioscience').size() > 0 ? mapOfQuestionBank.get('Environment and Bioscience')[0] : null);
                    categoryCountMap.put('Environment and Bioscience', count);
                    
                    count = getCountForCareerAwarenessStream(objCon.Trades__c, mapOfQuestionBank.get('Trades').size() > 0 ? mapOfQuestionBank.get('Trades')[0] : null);
                    categoryCountMap.put('Trades', count);
                    
                    Integer finalTracks = 0;
                    for (String category : categoryCountMap.keySet()) {
                        if (categoryCountMap.get(category) >= 5){
                            finalTracks = finalTracks + 1; 
                        }
                    }   
                    objCon.Career_Tracks__c = finalTracks;
                }
            }
        }
    }
    
    
    public static boolean isValidInterest(Contact con, IARP_Master__c iarp){
        set<string> setOfInterest = new set<string>{'Interest_1__c','Interest_2__c','Interest_3__c'};
            Integer count = 0;
        for(string str: setOfInterest){
            if(con.get(str) != null && iarp.get(str) != null){
                for(string strInt: setOfInterest){
                    if(con.get(str) == iarp.get(strInt)){
                        count++;
                    }
                }
            }
        } 
        return count > 0;
    }
    
    public static boolean isValidAptitude(Contact con, IARP_Master__c iarp){
        set<string> setOfAptitude = new set<string>{'Aptitude_1__c','Aptitude_2__c','Aptitude_3__c'};
            Integer count = 0;
        for(string str: setOfAptitude){
            if(con.get(str) != null && iarp.get(str) != null){
                for(string strApt: setOfAptitude ){
                    if(con.get(str) == iarp.get(strApt)){
                        count++;
                    }
                }
            }
        }
        return count > 0;
    }
    
    private static Integer getCountForCareerAwarenessStream(String choices, Question_Bank__c answer) {
        Integer count = 0;
        
        if(choices != null && answer != null) {
            List<String> stringCharacters = choices.split(';');
            String ans = answer.Category__c;
            
            for (String givenAns : stringCharacters) {
                givenAns = givenAns.trim();
                if (ans.contains(givenAns) && givenAns != ','){
                    count++;
                }
            }
        }
        
        return count;
    }
    public static void Picklistchange(List <Contact> lstContacts) {
        for(contact conobj : lstContacts) {
            if(conobj.Date_for_Placements_re_engage__c == Null && conobj.Available_for_Career_Linkage__c == 'NO' && conobj.Placements_re_engage__c =='Engage based on re-engage date'&& (conobj.Reason_for_career_linkage_unavilability__c == 'Currently does not have time due to education' || conobj.Reason_for_career_linkage_unavilability__c == 'Currently unwilling to work' || conobj.Reason_for_career_linkage_unavilability__c == 'Currently under 18' || conobj.Reason_for_career_linkage_unavilability__c == 'Currently does not have time due to reason other than education'))
                conobj.addError('Please add Placements re - engage date as Student is without linkage.');
        }
    }
    public static void InterestAptitudeMatch(List < Contact > lstContacts, boolean Inserted, boolean Updated, Map < Id, Contact > oldmapCont) {
        
        for (Contact cont: lstContacts) {
            Decimal Interestcount = 0;
            Decimal Aptitudecount = 0;
            Set < String > InterestValueSet = new Set < String > ();
            Set < String > AptitudeValueSet = new Set < String > ();
            
            if (Inserted || (Updated && (cont.Interest_1__c != oldmapCont.get(cont.id).Interest_1__c || cont.Interest_2__c != oldmapCont.get(cont.id).Interest_2__c || 
                                         cont.Interest_3__c != oldmapCont.get(cont.id).Interest_3__c /*|| 
cont.Interest_1_Selected_By_Student__c != oldmapCont.get(cont.id).Interest_1_Selected_By_Student__c ||
cont.Interest_2_Selected_By_Student__c != oldmapCont.get(cont.id).Interest_2_Selected_By_Student__c || 
cont.Interest_3_Selected_By_Student__c != oldmapCont.get(cont.id).Interest_3_Selected_By_Student__c || 
cont.Aptitude_1__c != oldmapCont.get(cont.id).Aptitude_1__c || cont.Aptitude_2__c != oldmapCont.get(cont.id).Aptitude_2__c || 
cont.Aptitude_3__c != oldmapCont.get(cont.id).Aptitude_3__c || 
cont.Aptitude_1_Selected_By_Student__c != oldmapCont.get(cont.id).Aptitude_1_Selected_By_Student__c || 
cont.Aptitude_2_Selected_By_Student__c != oldmapCont.get(cont.id).Aptitude_2_Selected_By_Student__c || 
cont.Aptitude_3_Selected_By_Student__c != oldmapCont.get(cont.id).Aptitude_3_Selected_By_Student__c*/))) {
    if(String.isNotBlank(cont.Interest_1__c)){
        InterestValueSet.add(cont.Interest_1__c);
    }
    if(String.isNotBlank(cont.Interest_2__c)) {  
        InterestValueSet.add(cont.Interest_2__c);
    }
    if(String.isNotBlank(cont.Interest_3__c)){
        InterestValueSet.add(cont.Interest_3__c);
    }
    if(String.isNotBlank(cont.Aptitude_1__c)){ 
        AptitudeValueSet.add(cont.Aptitude_1__c);
    }
    if(String.isNotBlank(cont.Aptitude_2__c)) {
        AptitudeValueSet.add(cont.Aptitude_2__c);
    }
    if(String.isNotBlank(cont.Aptitude_3__c)){
        AptitudeValueSet.add(cont.Aptitude_3__c);
    }
    /*if (String.isNotBlank(cont.Interest_1_Selected_By_Student__c) || String.isNotBlank(cont.Interest_2_Selected_By_Student__c) || 
String.isNotBlank(cont.Interest_3_Selected_By_Student__c) || String.isNotBlank(cont.Interest_1__c) || String.isNotBlank(cont.Interest_2__c) || 
String.isNotBlank(cont.Interest_3__c)) {
if (String.isNotBlank(cont.Interest_1_Selected_By_Student__c) && String.isNotBlank(cont.Interest_1__c)) {
if(InterestValueSet.contains(cont.Interest_1_Selected_By_Student__c))
Interestcount++;
}
if (String.isNotBlank(cont.Interest_1_Selected_By_Student__c) && String.isNotBlank(cont.Interest_2__c)) {
if (InterestValueSet.contains(cont.Interest_2_Selected_By_Student__c))
Interestcount++;
}
if (String.isNotBlank(cont.Interest_1_Selected_By_Student__c) && String.isNotBlank(cont.Interest_3__c)) {
if (InterestValueSet.contains(cont.Interest_3_Selected_By_Student__c))
Interestcount++;
}
cont.Matched_Interest_s__c = string.valueOf(Interestcount);
} else {
cont.Matched_Interest_s__c = 'NA';
}
if (String.isNotBlank(cont.Aptitude_1_Selected_By_Student__c) || String.isNotBlank(cont.Aptitude_2_Selected_By_Student__c) || 
String.isNotBlank(cont.Aptitude_3_Selected_By_Student__c) || String.isNotBlank(cont.Aptitude_1__c) || String.isNotBlank(cont.Aptitude_2__c) || 
String.isNotBlank(cont.Aptitude_3__c)) {
if (String.isNotBlank(cont.Aptitude_1_Selected_By_Student__c) && String.isNotBlank(cont.Aptitude_1__c)) {
if (AptitudeValueSet.contains(cont.Aptitude_1_Selected_By_Student__c))
Aptitudecount++;
}
if (String.isNotBlank(cont.Aptitude_1_Selected_By_Student__c) && String.isNotBlank(cont.Aptitude_2__c)) {
if (AptitudeValueSet.contains(cont.Aptitude_2_Selected_By_Student__c))
Aptitudecount++;
}
if (String.isNotBlank(cont.Aptitude_1_Selected_By_Student__c) && String.isNotBlank(cont.Aptitude_3__c)) {
if (AptitudeValueSet.contains(cont.Aptitude_3_Selected_By_Student__c))
Aptitudecount++;
}
cont.Matched_Aptitude_s__c = string.valueOf(Aptitudecount);
system.debug('Aptitudecount2' + cont.Matched_Aptitude_s__c);
} else {
cont.Matched_Aptitude_s__c = 'NA';
}*/
    
}
        }
    }
    public static void RealtimeContactAPI(List < Contact > lstcon, boolean Inserted, boolean Updated, boolean Deleted, Map < Id, Contact > oldmapContact) {
        set < id > ContactIdset = new set < id > ();
        Id CR_recordtype = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
        for (Contact Cont: lstcon) {
            //if(cont.LastModifiedById == '0057F000000iWraQAE'){
            //system.debug('CallOutforOpprtunityAssignment =' + CallOutforOpprtunityAssignment);
            //oppassginIdset.add(oppassign.id);
            if ((oldmapContact!= null && (Cont.UID__c != oldmapContact.get(Cont.id).UID__c ||Cont.Firstname != oldmapContact.get(Cont.id).Firstname ||
                                          Cont.Lastname != oldmapContact.get(Cont.id).Lastname ||Cont.Batch_Name__r.name != oldmapContact.get(Cont.id).Batch_Name__r.name ||Cont.Location__c != oldmapContact.get(Cont.id).Location__c ||
                                          Cont.Current_Education__c != oldmapContact.get(Cont.id).Current_Education__c ||Cont.Available_work_Days__c != oldmapContact.get(Cont.id).Available_work_Days__c ||
                                          Cont.Available_working_Hours_Start_Time__c != oldmapContact.get(Cont.id).Available_working_Hours_Start_Time__c ||Cont.Digital_Literacy__c != oldmapContact.get(Cont.id).Digital_Literacy__c ||
                                          Cont.Available_working_Hours_Finish_Time__c != oldmapContact.get(Cont.id).Available_working_Hours_Finish_Time__c ||
                                          Cont.English_Fluency__c != oldmapContact.get(Cont.id).English_Fluency__c ||
                                          Cont.Available_for_Career_Linkage__c != oldmapContact.get(Cont.id).Available_for_Career_Linkage__c ||
                                          Cont.Type_of_Career_linkage__c != oldmapContact.get(Cont.id).Type_of_Career_linkage__c ||
                                          Cont.Reason_for_career_linkage_unavilability__c != oldmapContact.get(Cont.id).Reason_for_career_linkage_unavilability__c))
                || Inserted || Deleted) {
                    if(Cont.Recordtypeid == CR_recordtype ){
                        ContactIdset.add(cont.id);
                    }    
                }
            // }
        }
        if(!ContactIdset.isEmpty()){
            if(!System.isBatch()){
                if(ContactIdset.size() <= 20){
                    ContactTriggerHandler.CallOutforContact = True;
                    ID jobID = System.enqueueJob(new ContactAPICallout(ContactIdset));
                }
                else{
                    ContactTriggerHandler.CallOutforContact = True;
                    Id batchJobId = Database.executeBatch(new ContactCalloutBatch(ContactIdset), 10);
                }
            } 
        }
    }
    
    Public static void updatePlanA_B(List < contact > conLst, Map < Id, Contact > oldmapContact, boolean Inserted) {
        
        set < id > conIds = new set < id > ();
        for (Contact con: conLst) {
            if ((string.isnotBlank(con.Plan_A__c) || string.isnotBlank(con.Plan_B__c)) && (Inserted || (oldmapContact != null && (Con.Plan_A__c != oldmapContact.get(Con.id).Plan_A__c || Con.Plan_B__c != oldmapContact.get(Con.id).Plan_B__c)))) {
                conIds.add(con.id);
            }
        } 
        if (conIds.size() > 0) {
            PlanA_B_recurssion = true;
            ID jobID = System.enqueueJob(new PlanA_BIndustryUpdateClass(conIds));
        }
    }
    
    
    //Populate Followup 1 conf Clear Next Steps according to Followup 1 Aspiration and Follow up 1 Step 1
    // Date - 08 Sept 2020
    public static void MapCareerAwareNextStep(List<Contact> contactList, Map<Id, Contact> oldMap, Boolean IsInsert){
        
        List<Contact> finalContactList = new List<Contact>();
        
        if(IsInsert){
            finalContactList = contactList.Clone();
        }else{
            for(Contact conObje: contactList){
                if(conObje.Followup1Aspiration__c != oldMap.get(conObje.Id).Followup1Aspiration__c || 
                   conObje.Follow_up_1_Step_1__c != oldMap.get(conObje.Id).Follow_up_1_Step_1__c ||
                   conObje.Education_status_at_fup__c != oldMap.get(conObje.Id).Education_status_at_fup__c ){
                       
                       finalContactList.add(conObje);
                   }
            }
        }
        if(finalContactList != null && finalContactList.size() > 0){
            //Get mapping data from Custom settings
            List<CareerAware_Next_Step_Mapping__c> careerAwareMappingList = [SELECT Id, Name, Aspiration__c, Step_1__c 
                                                                             FROM CareerAware_Next_Step_Mapping__c ];
            
            //Create a Map With Key = (Aspiration__c + Step_1__c) and value mapping record
            Map<String, CareerAware_Next_Step_Mapping__c> mapCareerAwareNextStep = new Map<String, CareerAware_Next_Step_Mapping__c>();
            if(careerAwareMappingList != null && careerAwareMappingList.size() > 0){
                String key = '';
                for(CareerAware_Next_Step_Mapping__c mapping : careerAwareMappingList){
                    key = mapping.Aspiration__c.ToLowerCase() + mapping.Step_1__c.ToLowerCase();
                    //System.debug('Key1: ' + key);
                    mapCareerAwareNextStep.put(key, mapping);
                }
            }
            
            
            
            // Map the CareerAware_Next_Step__c using mapping details
            for(Contact conObj : finalContactList){
                String key = '';
                if(String.isNotBlank(conObj.Followup1Aspiration__c) && String.isNotBlank(conObj.Follow_up_1_Step_1__c)){
                    
                    //Aspiration = I do not know or Step 1 = I do not know, result = NO
                    if(conObj.Followup1Aspiration__c == 'I do not know' || conObj.Follow_up_1_Step_1__c == 'I do not know' ){
                        conObj.Followup_1_conf_Clear_Next_Steps__c = 'No';
                        
                    }else if(conObj.Follow_up_1_Step_1__c == 'Complete Class 10'){
                        
                        if(conObj.Education_status_at_fup__c == 'Out of School'){
                            conObj.Followup_1_conf_Clear_Next_Steps__c = 'Yes';
                            
                        }else if(conObj.Education_status_at_fup__c == 'Grade 10'){
                            conObj.Followup_1_conf_Clear_Next_Steps__c = 'No';
                            
                        }else if(conObj.Education_status_at_fup__c == 'Grade 9' || String.isBlank(conObj.Education_status_at_fup__c)){
                            conObj.Followup_1_conf_Clear_Next_Steps__c = 'Data not available';
                            
                        }
                    }else{
                        key = conObj.Followup1Aspiration__c.ToLowercase() + conObj.Follow_up_1_Step_1__c.ToLowercase();
                        //System.debug('Key2: ' + key);
                        
                        if(mapCareerAwareNextStep.containsKey(key)){
                            // CareerAware_Next_Step__c = 'Yes' > When mapping record is exist in custom setting with same Aspiration and Step 1.
                            conObj.Followup_1_conf_Clear_Next_Steps__c = 'Yes';
                        }else{
                            // CareerAware_Next_Step__c = 'No' > When mapping record does not exist in custom setting with same Aspiration and Step 1.
                            conObj.Followup_1_conf_Clear_Next_Steps__c = 'No';
                        }
                    }
                    
                    
                }else{
                    // CareerAware_Next_Step__c = 'Data not available' >  Aspiration or Step 1 is not provided
                    conObj.Followup_1_conf_Clear_Next_Steps__c = 'Data not available';
                }
                
            }
        }
        
    }
    
    //Populate Followup 1 Aspiration according to Aspiration via conf call
    // Date - 11 Sept 2020
    public static void MapFupAspiration(List < Contact > contactList, Map < Id, Contact > oldMap, Boolean Inserted) {
        List < Contact > finalContactList = new List < Contact > ();
        
        for (Contact conObje: contactList) {
            if (Inserted || conObje.Aspiration_via_conf_call__c != oldMap.get(conObje.Id).Aspiration_via_conf_call__c) {
                finalContactList.add(conObje);
            }
        } 
        if (finalContactList != null && finalContactList.size() > 0) {
            //Get mapping data from Custom settings
            Map < String, string > mapCareerAwareFUPaspiration = new Map < String, string > ();
            for (Career_Aware_FUP_Aspiration_mapping__c mapping:[SELECT Id, Name, Aspiration_via_conf_call__c, FUP_Aspiration__c FROM Career_Aware_FUP_Aspiration_mapping__c]) {
                
                mapCareerAwareFUPaspiration.put(mapping.Aspiration_via_conf_call__c, mapping.FUP_Aspiration__c);
            }
            
            // Map the Followup1Aspiration__c using mapping details
            for (Contact conObj: finalContactList) {
                if (mapCareerAwareFUPaspiration.containsKey(conObj.Aspiration_via_conf_call__c)) {
                    conObj.Followup1Aspiration__c = mapCareerAwareFUPaspiration.get(conObj.Aspiration_via_conf_call__c);
                }
                
            }
            
        }
        
    }
    //Populate Post 10 - Clear Next Steps based on Post 10 - Current Aspiration and Post 10 - next Step 1     
    public static void MapCareerAwarePost10steps(List<Contact> contactList, Map<Id, Contact> oldMap, Boolean IsInsert){
        
        List<Contact> finalContactList = new List<Contact>();
        
        if(IsInsert){
            finalContactList = contactList.Clone();
        }else{
            for(Contact conObje: contactList){
                if(conObje.Post_10_Current_Aspiration__c!= oldMap.get(conObje.Id).Post_10_Current_Aspiration__c || 
                   conObje.Post_10_next_Step_1__c!= oldMap.get(conObje.Id).Post_10_next_Step_1__c||
                   conObje.Education_status_at_fup__c != oldMap.get(conObje.Id).Education_status_at_fup__c ){
                       
                       finalContactList.add(conObje);
                   }
            }
        }
        if(finalContactList != null && finalContactList.size() > 0){
            //Get mapping data from Custom settings
            List<CareerAware_Next_Step_Mapping__c> careerAwareMappingList = [SELECT Id, Name, Aspiration__c, Step_1__c 
                                                                             FROM CareerAware_Next_Step_Mapping__c ];
            
            //Create a Map With Key = (Aspiration__c + Step_1__c) and value mapping record
            Map<String, CareerAware_Next_Step_Mapping__c> mapCareerAwareNextStep = new Map<String, CareerAware_Next_Step_Mapping__c>();
            if(careerAwareMappingList != null && careerAwareMappingList.size() > 0){
                String key = '';
                for(CareerAware_Next_Step_Mapping__c mapping : careerAwareMappingList){
                    key = mapping.Aspiration__c.ToLowerCase() + mapping.Step_1__c.ToLowerCase();
                    //System.debug('Key1: ' + key);
                    mapCareerAwareNextStep.put(key, mapping);
                }
            }
            
            
            
            // Map the Post_10_Clear_Next_Steps__c using mapping details
            for(Contact conObj : finalContactList){
                String key = '';
                if(String.isNotBlank(conObj.Post_10_Current_Aspiration__c) && String.isNotBlank(conObj.Post_10_next_Step_1__c)){
                    
                    //Aspiration = I do not know or Step 1 = I do not know, result = NO
                    if(conObj.Post_10_Current_Aspiration__c == 'I do not know' || conObj.Post_10_next_Step_1__c == 'I do not know' ){
                        conObj.Post_10_Clear_Next_Steps__c= 'No';
                        
                    }else if(conObj.Post_10_next_Step_1__c == 'Complete Class 10'){
                        
                        if(conObj.Education_status_at_fup__c == 'Out of School'){
                            conObj.Post_10_Clear_Next_Steps__c = 'Yes';
                            
                        }else if(conObj.Education_status_at_fup__c == 'Grade 10'){
                            conObj.Post_10_Clear_Next_Steps__c = 'No';
                            
                        }else if(conObj.Education_status_at_fup__c == 'Grade 9' || String.isBlank(conObj.Education_status_at_fup__c)){
                            conObj.Post_10_Clear_Next_Steps__c = 'Data not available';
                            
                        }
                    }else{
                        key = conObj.Post_10_Current_Aspiration__c.ToLowercase() + conObj.Post_10_next_Step_1__c.ToLowercase();
                        //System.debug('Key2: ' + key);
                        
                        if(mapCareerAwareNextStep.containsKey(key)){
                            // Post_10_Clear_Next_Steps__c = 'Yes' > When mapping record is exist in custom setting with same Aspiration and Step 1.
                            conObj.Post_10_Clear_Next_Steps__c = 'Yes';
                        }else{
                            // Post_10_Clear_Next_Steps__c = 'No' > When mapping record does not exist in custom setting with same Aspiration and Step 1.
                            conObj.Post_10_Clear_Next_Steps__c = 'No';
                        }
                    }
                    
                    
                }else{
                    // Post_10_Clear_Next_Steps__c = 'Data not available' >  Aspiration or Step 1 is not provided
                    conObj.Post_10_Clear_Next_Steps__c = 'Data not available';
                }
                
            }
        }
        
    }
    
    public static void processBuilderUpdateContact(List<Contact> contactList, Map<Id,Contact> oldMap,Boolean IsInsert,Boolean IsUpdate){
        List<Contact> updateContact = new List<Contact>();
        recurssionOfPB = true;
        for(Contact con : contactList){
            //CA_Trainer
            if(con.Cities_of_Operation__c != null && con.RecordTypeId  == Label.ConRecordIdCA_Trainer){
                If(IsInsert){
                    con.Cities_of_Operation_Text__c = con.Cities_of_Operation__c;
                    updateContact.add(con);
                }
                else if(IsUpdate && con.Cities_of_Operation__c != oldMap.get(con.id).Cities_of_Operation__c){
                    con.Cities_of_Operation_Text__c = con.Cities_of_Operation__c;
                    updateContact.add(con);
                    
                }
            }
            //CA_Trainer
            if(con.Type_of_Career_linkage__c != null && con.RecordTypeId  == Label.ConRecordIdCR_Student){
                if(IsInsert && con.Available_for_Career_Linkage__c == 'No'){
                    con.Type_of_Career_linkage__c = null ;
                    updateContact.add(con);
                }
                else if(IsUpdate && con.Available_for_Career_Linkage__c == 'No' && con.Available_for_Career_Linkage__c != oldMap.get(con.id).Available_for_Career_Linkage__c){
                    con.Type_of_Career_linkage__c = null ;
                    updateContact.add(con);
                }
            }
            //CR_Student
            if(con.RecordTypeId  == Label.ConRecordIdCR_Student){
                if((con.Current_Education__c == '8th Standard' || con.Current_Education__c == 'ITI') && con.Education_Status__c =='Pursuing'){
                    con.Education_Level__c = 'Below 8th pass - not completed 8th';
                    updateContact.add(con);
                }
                Else if(((con.Current_Education__c == '10th standard- Distance Education' || con.Current_Education__c == '9th Standard' || con.Current_Education__c == '10th Standard') && con.Education_Status__c =='Pursuing') || ((con.Current_Education__c == '8th Standard' || con.Current_Education__c == '9th Standard') && con.Education_Status__c =='Completed')){
                    con.Education_Level__c = '8th pass - not completed 10th';
                    updateContact.add(con);
                }
                Else if(((con.Current_Education__c == '11th Arts' || con.Current_Education__c == '11th Science' 
                          || con.Current_Education__c == '11th Commerce' || con.Current_Education__c == '12th Arts' 
                          || con.Current_Education__c == '12th Science' || con.Current_Education__c == '12th Commerce' 
                          || con.Current_Education__c == '12th standard- Distance Education') && con.Education_Status__c =='Pursuing') 
                        || ((con.Current_Education__c == '11th Arts' || con.Current_Education__c == '11th Science' 
                             || con.Current_Education__c == '11th Commerce' || con.Current_Education__c == '10th standard- Distance Education' 
                             ||con.Current_Education__c == '10th Standard'||con.Current_Education__c== 'ITI') && con.Education_Status__c =='Completed'))
                {
                    con.Education_Level__c = '10th pass/ITI - minimum 10th completed/ITI after 8th';
                    updateContact.add(con);
                }
                Else if((con.Current_Education__c == '12th Arts' 
                         || con.Current_Education__c == '12th Science' || con.Current_Education__c == '12th Commerce' 
                         || con.Current_Education__c == '12th standard- Distance Education') &&  con.Education_Status__c =='Completed')
                {
                    con.Education_Level__c = '12th pass/ITI/Diploma - minimum 12th completed/ ITI or Diploma after 10th';
                    updateContact.add(con);
                }
                Else if(((con.Current_Education__c == 'FY Bachelors of Arts' || con.Current_Education__c == 'SY Bachelors of Arts' 
                          || con.Current_Education__c == 'TY Bachelors of Arts' || con.Current_Education__c == 'FY Bachelors of Commerce' 
                          || con.Current_Education__c == 'SY Bachelors of Commerce' || con.Current_Education__c == 'TY Bachelors of Commerce' 
                          || con.Current_Education__c == 'FY Bachelors of Science' || con.Current_Education__c == 'SY Bachelors of Science' 
                          || con.Current_Education__c == 'TY Bachelors of Science' || con.Current_Education__c == 'FY Bachelors of Management Studies' 
                          || con.Current_Education__c == 'SY Bachelors of Management Studies' || con.Current_Education__c == 'TY Bachelors of Management Studies' 
                          || con.Current_Education__c == 'FY Bachelors of Mass Media' || con.Current_Education__c == 'SY Bachelors of Mass Media' 
                          || con.Current_Education__c == 'TY Bachelors of Mass Media' || con.Current_Education__c == 'FY Bachelors of Banking and Insurance' 
                          || con.Current_Education__c == 'SY Bachelors of Banking and Insurance' 
                          || con.Current_Education__c == 'TY Bachelors of Banking and Insurance' || con.Current_Education__c == 'FY Bachelors of Science- IT' 
                          || con.Current_Education__c == 'SY Bachelors of Science- IT' || con.Current_Education__c == 'TY Bachelors of Science- IT' 
                          || con.Current_Education__c == 'FY Bachelors of Banking and Finance' || con.Current_Education__c == 'SY Bachelors of Banking and Finance' 
                          || con.Current_Education__c == 'TY Bachelors of Banking and Finance' || con.Current_Education__c == 'FY Diploma in Education' 
                          || con.Current_Education__c == 'SY Diploma in Education' || con.Current_Education__c == 'FY Bachelors in Education' 
                          || con.Current_Education__c == 'SY Bachelors in Education' || con.Current_Education__c == 'Diploma in Early Childhood Care and Education' 
                          || con.Current_Education__c == 'Engineering' ) && con.Education_Status__c =='Pursuing')
                        || (con.Education_Status__c =='Completed' && (con.Current_Education__c == 'FY Bachelors of Arts' 
                                                                      || con.Current_Education__c == 'SY Bachelors of Arts' 
                                                                      || con.Current_Education__c == 'FY Bachelors of Commerce' 
                                                                      || con.Current_Education__c == 'SY Bachelors of Commerce' 
                                                                      || con.Current_Education__c == 'FY Bachelors of Science' 
                                                                      || con.Current_Education__c == 'SY Bachelors of Science' 
                                                                      || con.Current_Education__c == 'FY Bachelors of Management Studies' 
                                                                      || con.Current_Education__c == 'SY Bachelors of Management Studies' 
                                                                      ||con.Current_Education__c == 'FY Bachelors of Mass Media' 
                                                                      || con.Current_Education__c == 'SY Bachelors of Mass Media' 
                                                                      || con.Current_Education__c == 'FY Bachelors of Banking and Insurance' 
                                                                      || con.Current_Education__c == 'SY Bachelors of Banking and Insurance' 
                                                                      || con.Current_Education__c == 'FY Bachelors of Science- IT' 
                                                                      || con.Current_Education__c == 'SY Bachelors of Science- IT' 
                                                                      || con.Current_Education__c == 'FY Bachelors of Banking and Finance' 
                                                                      || con.Current_Education__c == 'SY Bachelors of Banking and Finance' 
                                                                      || con.Current_Education__c == 'FY Diploma in Education' 
                                                                      || con.Current_Education__c == 'SY Diploma in Education' 
                                                                      || con.Current_Education__c == 'FY Bachelors in Education' 
                                                                      || con.Current_Education__c == 'SY Bachelors in Education' 
                                                                      || con.Current_Education__c == 'Diploma in Early Childhood Care and Education')))
                {
                    con.Education_Level__c = 'Pursuing Graduation/Diploma - After 12th';
                    updateContact.add(con);
                }
                Else If((con.Current_Education__c == 'TY Bachelors of Arts' || con.Current_Education__c == 'TY Bachelors of Commerce' || con.Current_Education__c == 'TY Bachelors of Science' || con.Current_Education__c == 'TY Bachelors of Management Studies'|| con.Current_Education__c == 'TY Bachelors of Mass Media' || con.Current_Education__c == 'TY Bachelors of Banking and Insurance' || con.Current_Education__c == 'TY Bachelors of Science- IT' || con.Current_Education__c == 'TY Bachelors of Banking and Finance' || con.Current_Education__c == 'Engineering') && con.Education_Status__c =='Completed')
                {
                    con.Education_Level__c = 'Graduate';
                    updateContact.add(con);
                }
                Else If(((con.Current_Education__c == 'FY Master in Arts' || con.Current_Education__c == 'SY Master in Arts' || con.Current_Education__c == 'FY Master in Commerce' || con.Current_Education__c == 'SY Master in Commerce' ) && con.Education_Status__c =='Pursuing') || (con.Education_Status__c =='Completed' &&(con.Current_Education__c == 'FY Master in Arts' || con.Current_Education__c == 'FY Master in Commerce')))
                {
                    con.Education_Level__c = 'Pursuing post Graduation';
                    updateContact.add(con);
                }
                Else If(( con.Current_Education__c == 'SY Master in Arts' || con.Current_Education__c == 'SY Master in Commerce' ) && con.Education_Status__c =='Completed')
                {
                    con.Education_Level__c = 'Post Graduate';
                    updateContact.add(con);
                }
            }
        }
        If(!updateContact.isEmpty() && updateContact.size() > 0){
            //update updateContact;
        }
        
    }
    
}