/********************************************************************************************   
* NAME         : EndLineStudentAssessmentFormCtrlTest
* DESCRIPTION  : Test class of EndLineStudentAssessmentFormCtrlTest class.
*   
* @AUTHOR: Dev Team
* @DATE: 8th Dec 2021 
*   
********************************************************************************************/  
@isTest
public class EndLineStudentAssessmentFormCtrlTest{

    @testSetup static void setupTestData() {
        
        Test.StartTest();
        
        State_Govt_Body_Level__c state = new State_Govt_Body_Level__c();
        state.Name = 'SSC';
        insert state;
        
        District_Master__c distict = new District_Master__c();
        distict.State__c = state.id;
        distict.Name = 'Maharashtra';
        insert distict;
        
        City_Master__c city = new City_Master__c();
        city.District__c = distict.id;
        city.Name = 'Mumbai'; 
        insert city;
        
        Ward_Master__c ward = new Ward_Master__c();
        ward.City__c = city.id;
        ward.Name = 'Anderi';
        insert ward;
        
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('School_Account').getRecordTypeId();
        Account objAccount = new Account();
        objAccount.Name = 'Shreeram School';
        objAccount.State__c = state.id;
        objAccount.Ward__c = ward.id;
        objAccount.City__c = city.id;
        objAccount.School_Timing__c = 'morning';
        objAccount.District__c = distict.id;        
        objAccount.RecordTypeId = RecordTypeIdAccount;
        objAccount.Medium_Language_of_Instruction__c = 'English';
        objAccount.School_Location__c = 'Test Principal address';
        objAccount.Principal_Name__c = 'Test Principal';
        insert objAccount;
               
        Batch__c objBatch = new Batch__c();
        objBatch.Name = 'Borivali Chikuwadi';
        objBatch.School_Name__c = objAccount.id;
        objBatch.Preferred_Language__c = 'Hindi';
        objBatch.Medium_Language_of_Instruction__c = 'English';
        insert objBatch;
                 
        Contact objContact = new Contact();
        objContact.FirstName = 'Demo';
        objContact.LastName = 'Contact';
        objContact.Email = 'assessmentExam@test.com';
        objContact.Phone = '1234567890';
        objContact.MobilePhone = '2233556677';
        objContact.Gender__c  = 'Male';
        objContact.Father_Education__c = 'Below 10th Grade';
        objContact.Mother_Education__c = 'I do not know';
        objContact.Household_Income__c = 'More then 20,000';
        objContact.Caste_Certificate_present__c = 'SC';
        objContact.Batch_Code__c = objBatch.Id;
        objContact.AccountId = objAccount.Id;
        insert objContact;
        
        Contact objContact1 = new Contact();
        objContact1.FirstName = 'Demo1';
        objContact1.LastName = 'Contact';
        objContact1.Email = 'assessmentExam@test1.com';
        objContact1.Phone = '1234567891';
        objContact1.MobilePhone = '2233556676';
        objContact1.Gender__c  = 'Female';
        objContact1.Father_Education__c = 'Below 10th Grade';
        objContact1.Mother_Education__c = 'I do not know';
        objContact1.Household_Income__c = 'More then 20,000';
        objContact1.Caste_Certificate_present__c = 'SC';
        objContact1.Batch_Code__c = objBatch.Id;
        objContact1.AccountId = objAccount.Id;
        insert objContact1;
        
       
        
        Assessment__c objAssessment = new Assessment__c(Total_Marks__c = 49);
        insert objAssessment;
        
        Question__c objQuestion = new Question__c();
        objQuestion.Display_Type__c = 'RadioGroup';
        objQuestion.Order_of_Question__c = 1;
        objQuestion.Question_Label__c = 'Pick one activity that you are most interested in';
        objQuestion.Section__c = 1;
        objQuestion.Display_Number__c = '1';
        objQuestion.Is_Dependent_Question__c = false;
        objQuestion.Assessment__c = objAssessment.Id;
        objQuestion.Is_Career_Question__c = false;
        objQuestion.Is_NextStep_Question__c = false;
        objQuestion.Maximum_Allow_Answer__c = 0;
        objQuestion.Marks__c = 1;
        objQuestion.Language__c = 'eng';
        insert objQuestion;
        
        Question__c objQuestion4 = new Question__c();
        objQuestion4.Display_Type__c = 'RadioGroup';
        objQuestion4.Order_of_Question__c = 3;
        objQuestion4.Question_Label__c = 'Now that you know which activity interests you, what are you BEST at doing?';
        objQuestion4.Section__c = 1;
        objQuestion4.Display_Number__c = '3';
        objQuestion4.Is_Dependent_Question__c = false;
        objQuestion4.Assessment__c = objAssessment.Id;
        objQuestion4.Is_Career_Question__c = false;
        objQuestion4.Is_NextStep_Question__c = false;
        objQuestion4.Maximum_Allow_Answer__c = 0;
        objQuestion4.Marks__c = 1;
        objQuestion4.Language__c = 'eng';
        insert objQuestion4;
        
        Question__c objQuestion5= new Question__c();
        objQuestion5.Display_Type__c = 'CheckboxGroup';
        objQuestion5.Order_of_Question__c = 5;
        objQuestion5.Question_Label__c = 'What can stop you from making this interest your career? (pick as many as apply)';
        objQuestion5.Section__c = 1;
        objQuestion5.Display_Number__c = '5';
        objQuestion5.Assessment__c = objAssessment.Id;
        objQuestion5.Marks__c = 1;
        objQuestion5.Language__c = 'eng';
        insert objQuestion5;
        
        Question_Option__c objQuestionOption = new Question_Option__c();
        objQuestionOption.Question__c = objQuestion.Id;
        objQuestionOption.Actual_Answer__c = true;
        objQuestionOption.Order_of_Answer__c = 1;
        objQuestionOption.Marks__c = 0;
        insert objQuestionOption;
        
        Question__c objQuestion2 = new Question__c();
        objQuestion2.Display_Type__c = 'CheckboxGroup';
        objQuestion2.Order_of_Question__c = 1;
        objQuestion2.Question_Label__c = 'Careers good for boys';
        objQuestion2.Section__c = 2;
        objQuestion2.Display_Number__c = '1';
        objQuestion2.Is_Gender_Stereotypes__c = true;
        objQuestion2.Assessment__c = objAssessment.Id;
        objQuestion2.Marks__c = 0;
        objQuestion2.Language__c = 'eng';
        objQuestion2.Minimum_Actual_Answer__c = 0;
        insert objQuestion2;
        
        Question_Option__c objQuestionOption1 = new Question_Option__c();
        objQuestionOption1.Question__c = objQuestion2.Id;
        objQuestionOption1.Actual_Answer__c = false;
        objQuestionOption1.Order_of_Answer__c = 1;
        objQuestionOption1.Marks__c = 0;
        insert objQuestionOption1;
        
        Question_Option__c objQuestionOption2 = new Question_Option__c();
        objQuestionOption2.Question__c = objQuestion2.Id;
        objQuestionOption2.Actual_Answer__c = true;
        objQuestionOption2.Order_of_Answer__c = 2;
        objQuestionOption2.Marks__c = 2;
        insert objQuestionOption2;
        
        Question_Option__c objQuestionOption3 = new Question_Option__c();
        objQuestionOption3.Question__c = objQuestion2.Id;
        objQuestionOption3.Actual_Answer__c = true;
        objQuestionOption3.Order_of_Answer__c = 3;
        objQuestionOption3.Is_Show_Others__c = true;
        objQuestionOption3.Marks__c = 1;
        insert objQuestionOption3;
        
        Question_Option__c objQuestionOption4 = new Question_Option__c();
        objQuestionOption4.Question__c = objQuestion4.Id;
        objQuestionOption4.Actual_Answer__c = true;
        objQuestionOption4.Order_of_Answer__c = 1;
        objQuestionOption4.Marks__c = 0;
        insert objQuestionOption4;
        
        Question_Option__c objQuestionOption5 = new Question_Option__c();
        objQuestionOption5.Question__c = objQuestion5.Id;
        objQuestionOption5.Actual_Answer__c = false;
        objQuestionOption5.Is_Full_Marks__c = true;
        objQuestionOption5.Order_of_Answer__c = 1;
        objQuestionOption5.Marks__c = 0;
        insert objQuestionOption5;
        
        Question_Option__c objQuestionOption6 = new Question_Option__c();
        objQuestionOption6.Question__c = objQuestion5.Id;
        objQuestionOption6.Actual_Answer__c = true;
        objQuestionOption6.Mapping_To_IARP_Master_Field__c = 'Reality_1__c';
        objQuestionOption6.Order_of_Answer__c = 1;
        objQuestionOption6.Marks__c = 0;
        insert objQuestionOption6;
        
        Question__c objQuestion3 = new Question__c();
        objQuestion3.Display_Type__c = 'Picklist';
        objQuestion3.Order_of_Question__c = 1;
        objQuestion3.Question_Label__c = 'My career Option 1 is';
        objQuestion3.Section__c = 4;
        objQuestion3.Display_Number__c = '1';
        objQuestion3.Is_Career_Question__c = true;
        objQuestion3.Career_Option_Number__c = 1;
        objQuestion3.Assessment__c = objAssessment.Id;
        objQuestion3.Marks__c = 3;
        objQuestion3.Language__c = 'eng';
        insert objQuestion3;
        
        Question__c objQuestion6 = new Question__c();
        objQuestion6.Display_Type__c = 'MatchColumn';
        objQuestion6.Order_of_Question__c = 1;
        objQuestion6.Question_Label__c = 'Nutritionist';
        objQuestion6.Section__c = 2;
        objQuestion6.Display_Number__c = 'F';
        objQuestion6.Is_Gender_Stereotypes__c = false;
        objQuestion6.Assessment__c = objAssessment.Id;
        objQuestion6.Marks__c = 0;
        objQuestion6.Language__c = 'eng';
        insert objQuestion6;
        
        Question_Option__c objQuestionOption7 = new Question_Option__c();
        objQuestionOption7.Question__c = objQuestion6.Id;
        objQuestionOption7.Actual_Answer__c = true;
        objQuestionOption7.Order_of_Answer__c = 3;
        objQuestionOption7.Marks__c = 0;
        insert objQuestionOption7;
        
        IARP_Master__c objIARP = new IARP_Master__c(Name = 'Accountant');
        insert objIARP;
        
        IARP_Master__c objIARP1 = new IARP_Master__c(Name = 'Artist');
        insert objIARP1;
        
        IARP_Master__c objIARP2 = new IARP_Master__c(Name = 'Other');
        insert objIARP2;
        
        CareerAware_Next_Step_Mapping__c ojbNextStep = new CareerAware_Next_Step_Mapping__c();
        ojbNextStep.Name = 'Accountant - HSC-Commerce';
        ojbNextStep.Aspiration__c = 'Accountant';
        ojbNextStep.Step_1__c = 'HSC-Commerce';
        insert ojbNextStep;
        
        CareerAware_Next_Step_Mapping__c ojbNextStep1 = new CareerAware_Next_Step_Mapping__c();
        ojbNextStep1.Name = 'Artist - Diploma';
        ojbNextStep1.Aspiration__c = 'Artist';
        ojbNextStep1.Step_1__c = 'Diploma';
        insert ojbNextStep1;
        
        CareerAware_Next_Step_Mapping__c ojbNextStep3 = new CareerAware_Next_Step_Mapping__c();
        ojbNextStep3.Name = 'Other';
        ojbNextStep3.Aspiration__c = 'Other';
        ojbNextStep3.Step_1__c = 'Other';
        insert ojbNextStep3;
        
        String AssessmentMark_Endline_RT = Schema.getGlobalDescribe()
        .get('Assessment_Marks__c')
        .getDescribe()
        .getRecordTypeInfosByDeveloperName()
        .get('Endline_Assessment')
        .getRecordTypeId();
        
        Assessment_Marks__c objAsMarks = New Assessment_Marks__c(RecordTypeId = AssessmentMark_Endline_RT);
        objAsMarks.Assessment__c = objAssessment.Id;
        objAsMarks.Student__c = objContact1.Id;
        insert objAsMarks;
        
        Test.StopTest();
    }
    
    @istest
    private static void updateStudentDataTest(){
        Contact objContact = [Select Id from Contact where email = 'assessmentExam@test.com' limit 1];
        EndLineStudentAssessmentFormCtrl.wrpStudentData objwrpStudentData = EndLineStudentAssessmentFormCtrl.fetchStudentData(objContact.Id);
        
        EndLineStudentAssessmentFormCtrl.updateStudentData(objwrpStudentData);
    }
     
    @istest
    private static void saveAndNextAssessmentTest(){
        
        Test.startTest();
       
        Contact objContact = [Select Id from Contact where email = 'assessmentExam@test.com' limit 1];
        
        EndLineStudentAssessmentFormCtrl.WrpStudentQuestionAnswer objWSTQA = EndLineStudentAssessmentFormCtrl.fetchStudentQuestionsAndAnswers(objContact.Id, 'eng');
        
        Map<String,List<Question_Option__c>> mapQuestionOption = new Map<String,List<Question_Option__c>>();
        List<Question_Option__c> lstQuestionOptions = new List<Question_Option__c>([
            Select 
                Id,
                Answer_Value__c,
                Order_of_Answer__c,
                Dependent_Question__c,
                Is_Show_Others__c,
                Question__c,
                Actual_Answer__c,
                Marks__c
            from Question_Option__c
        ]);
        
        for(Question_Option__c objQO : lstQuestionOptions){
            if(!mapQuestionOption.containskey(objQO.Question__c)){
                mapQuestionOption.put(objQO.Question__c, new List<Question_Option__c>());
            }
            mapQuestionOption.get(objQO.Question__c).add(objQO);
        }
        
        for(EndLineStudentAssessmentFormCtrl.WrpStudentQuestion objWSQ: objWSTQA.lstWrpStudentQuestion){
           if(mapQuestionOption.containskey(objWSQ.questionId)){
               for(Question_Option__c objQO : mapQuestionOption.get(objWSQ.questionId)){                       
                   objWSQ.answerId += objQO.Id + ',';
               }           

               objWSQ.answerId = objWSQ.answerId.removeend(',');
           }
           
           if(objWSQ.isCareerOption){
               objWSQ.answerId = 'Accountant';
           }
        }
        
        EndLineStudentAssessmentFormCtrl.saveAndNextAssessment(objWSTQA.lstWrpStudentQuestion,objContact.Id, 'next','eng');
        EndLineStudentAssessmentFormCtrl.WrpStudentQuestionAnswer objWSTQA1 = EndLineStudentAssessmentFormCtrl.fetchStudentQuestionsAndAnswers(objContact.Id,'eng');
        EndLineStudentAssessmentFormCtrl.saveAndNextAssessment(objWSTQA.lstWrpStudentQuestion,objContact.Id, 'submit','eng');
        Test.StopTest();
    }
    
    @isTest
    public static void asgnMarks()
    {
        Test.startTest();
        Contact objContact = [Select Id from Contact where email = 'assessmentExam@test1.com' limit 1];        
        EndLineStudentAssessmentFormCtrl.WrpStudentQuestionAnswer objWSTQA = EndLineStudentAssessmentFormCtrl.fetchStudentQuestionsAndAnswers(objContact.Id,'eng');

        Test.stopTest();
    }

}