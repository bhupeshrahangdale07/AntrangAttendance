@istest
public without sharing class StudentTransitionTracking_v2_Test_v2 {

    @TestSetup
    static void prepareDataForTest(){

        State_Govt_Body_Level__c state = new State_Govt_Body_Level__c();
        state.Name = 'Maharashtra';
       // insert state;
        
        District_Master__c distict = new District_Master__c();
        distict.State__c = state.id;
        distict.Name = 'Educate Girls';
       // insert distict;
        
        City_Master__c city = new City_Master__c();
        city.District__c = distict.id;
        city.Name = 'Mumbai'; 
        //insert city;
        
        Ward_Master__c ward = new Ward_Master__c();
        ward.City__c = city.id;
        ward.Name = 'Anderi';
       // insert ward;
        
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('School_Account').getRecordTypeId();
        Account objAccount = new Account();
        objAccount.Name = 'ABC School';
       // objAccount.State__c = state.id;
       // objAccount.Ward__c = ward.id;
       // objAccount.City__c = city.id;
        objAccount.School_Timing__c = 'morning';
       // objAccount.District__c = distict.id;        
        objAccount.RecordTypeId = RecordTypeIdAccount;
        objAccount.Medium_Language_of_Instruction__c = 'English';
        objAccount.School_Location__c = 'Test Principal address';
        objAccount.Principal_Name__c = 'Test Principal';
        insert objAccount;
        
        Batch__c objBatch = new Batch__c();
        objBatch.Name = 'Abc School English 2022 1';
        objBatch.Preferred_Language__c='English';
        objBatch.School_Name__c = objAccount.id;
        objBatch.Medium_Language_of_Instruction__c = 'English';
        insert objBatch;


        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        Contact objContact = new Contact();
        objContact.FirstName = 'Demo1';
        objContact.LastName = 'Student';
        objContact.Bar_Code__c = '54723588235';
        objContact.G10_Alternate_Mobile_No__c='1234567890';
        objContact.G10_Whatsapp_Number__c='9876543210';
        objContact.Gender__c='Female';
        objContact.Birthdate=date.newInstance(1999, 01, 01);
        objContact.RecordTypeId = RecordTypeIdContact;
        objContact.G10_Batch_Code__c = objBatch.Id;
        insert objContact;        


    //******* CREATED STUDENT DATA TILL HERE. *********

    IARP_Master__c objIARP = new IARP_Master__c(Name = 'Accountant');
    insert objIARP;
    
    IARP_Master__c objIARP1 = new IARP_Master__c(Name = 'Artist');
    insert objIARP1;
    
    IARP_Master__c objIARP2 = new IARP_Master__c(Name = 'Other');
    insert objIARP2;
    }






    @IsTest
    static void test_fetchStudentQuestionsAndAnswers(){

        String language = 'English';
        TestData_StudentTransitionTracking_v2.generateQnsAndOptions(language);
        Contact student1 = [SELECT Id,Bar_Code__c,G10_Alternate_Mobile_No__c,Calculated_Age__c,Gender__c FROM Contact LIMIT 1];
        Id student1Id = student1.Id;
        //System.assertEquals('ABC School', student1.fetch_School_Name__c, 'Fetched Schhol Name not matched'); // Deleted field fetch_School_Name__c

        Map<String,List<Transition_Tracking_QnA_Options__c>> mapQnAOptions =new  Map<String,List<Transition_Tracking_QnA_Options__c>>();

        List<Transition_Tracking_QnA_Options__c> lstQnAOptions = [SELECT Id,Name, Question__c, Answer_Value__c, Order_of_Answer__c, 
                                                Dependent_Question__c, Is_Show_Others__c 
                                                FROM Transition_Tracking_QnA_Options__c 
                                                ORDER BY Order_of_Answer__c];
        
        Test.startTest();
        StudentTransitionTracking_v2.WrpStudentQuestionAnswer studentQuestionAnswer = new StudentTransitionTracking_v2.WrpStudentQuestionAnswer();
        studentQuestionAnswer =  StudentTransitionTracking_v2.fetchStudentQuestionsAndAnswers(student1Id, language); //MAIN-TEST
        

        For(Transition_Tracking_QnA_Options__c QnAOption : lstQnAOptions){
            if(!mapQnAOptions.containsKey(QnAOption.Question__c)){
                mapQnAOptions.put(QnAOption.Question__c, new List<Transition_Tracking_QnA_Options__c>());
            }
            mapQnAOptions.get(QnAOption.Question__c).add(QnAOption);
        }


        for(StudentTransitionTracking_v2.WrpStudentQuestion studentQuestion : studentQuestionAnswer.lstWrpStudentQuestion){

           if(studentQuestion.fieldType == 'RadioGroup'){
            studentQuestion.answerId = mapQnAOptions.get(studentQuestion.questionId).get(0).Id;
           }

           else if(studentQuestion.fieldType == 'PickList'){
                //FOR CAREER ANSWER 
                if(studentQuestion.isCareerOption){
                    studentQuestion.answerId = 'Accountant';
                }

                //FOR OTHER ANSWER DESCRIPTION
                else if(mapQnAOptions.get(studentQuestion.questionId).get(mapQnAOptions.get(studentQuestion.questionId).size()-1).Answer_Value__c == 'Other'){
                    studentQuestion.answerId = mapQnAOptions.get(studentQuestion.questionId).get(mapQnAOptions.get(studentQuestion.questionId).size()-1).Id;
                    studentQuestion.otherAnswerDescription = 'This The Other Answer Provided by User';
                }

                //FOR NORMAL ANSWER DESCRIPTION
                else{
                    studentQuestion.answerId = mapQnAOptions.get(studentQuestion.questionId).get(0).Id;
                }
            }
            else if(studentQuestion.fieldType == 'Text'){
                studentQuestion.otherAnswer = 'XYZ DATA';
            }
            else if(studentQuestion.fieldType == 'CheckboxGroup'){
                for(Transition_Tracking_QnA_Options__c op : mapQnAOptions.get(studentQuestion.questionId)){
                    studentQuestion.answerId += op.Id + ',';
                }
                studentQuestion.answerId.removeEnd(',');
            }
        }

        StudentTransitionTracking_v2.saveTransitionTrackingRecord(studentQuestionAnswer.lstWrpStudentQuestion,student1Id,language); //MAIN-TEST


        //***** ASSERTING THE DATA ****.
        List<Transition_Tracking__c> lstTransitionTrackRecord =  [SELECT Id,Student__c,Language__c,Grade__c FROM Transition_Tracking__c];
        System.assertEquals(1, lstTransitionTrackRecord.size(),'Transition Track Record Size Not Matched');
        System.assertEquals(student1Id, lstTransitionTrackRecord[0].Student__c,'Transition Track Record Student Id Not Matched');
        System.assertEquals('Grade 10', lstTransitionTrackRecord[0].Grade__c,'Transition Track Record Grade Not Matched');



        List<Transition_Tracking_Detail__c> lstTransitionDetailRecord = [Select Id,Student__c, Question__c, Question_Label__c,
                                                                Answer__c, Answer_Label__c,  
                                                                Career_Answer__c, Multi_Answers__c,  Other_Answer_Description__c, 
                                                                Contact_Field_Value__c, Is_Contact_Api_Field__c, 
                                                                User_Entered_Value__c, Transition_Tracking__c
                                                                FROM Transition_Tracking_Detail__c];
                                                                
        //System.assertEquals(studentQuestionAnswer.lstWrpStudentQuestion.size(), lstTransitionDetailRecord.size(),'The Transition Details Records Size Not Matched');

        for(Transition_Tracking_Detail__c record : lstTransitionDetailRecord){
            if(String.isNotBlank(record.Career_Answer__c)){
                System.assertEquals('Accountant', record.Career_Answer__c,'The Career Answer Not Matched');
            }
            else if(record.Answer_Label__c == 'Other'){
                System.assertEquals('This The Other Answer Provided by User', record.Other_Answer_Description__c,'The Other Answer Description Not Matched');
            }
            else if(String.isNotBlank(record.Multi_Answers__c)){
                String assertMutiValues = 'Yes, with admissions ; Yes, with finding relevant courses ; No ; Other';
                System.assertEquals(assertMutiValues, record.Multi_Answers__c,'The MultiAnswer Not Matched');
            }
            else if(String.isNotBlank(record.User_Entered_Value__c)){
                System.assertEquals('XYZ DATA', record.User_Entered_Value__c,'The User Entered Value Not Matched');
            }
            else if(record.Is_Contact_Api_Field__c){
                if(record.Question_Label__c == 'Student UID'){
                    System.assertEquals(student1.Bar_Code__c, record.Contact_Field_Value__c , 'The Student UID Not Matched');
                }
                else if(record.Question_Label__c =='School Name'){
                   // System.assertEquals(student1.fetch_School_Name__c, record.Contact_Field_Value__c , 'The Student School Name Not Matched'); // Deleted field fetch_School_Name__c
                }
                else if(record.Question_Label__c =='Alternate Phone Number'){
                    System.assertEquals(student1.G10_Alternate_Mobile_No__c, record.Contact_Field_Value__c , 'The Student Alternate Phone Number Not Matched');
                }
                else if(record.Question_Label__c =='Age'){
                    System.assertEquals(student1.Calculated_Age__c.toPlainString(), record.Contact_Field_Value__c , 'The Student Age Not Matched');
                }
                else if(record.Question_Label__c =='Gender'){
                    System.assertEquals(null, record.Contact_Field_Value__c , 'The Student Gender  contact field value is Not Blank');
                    System.assertEquals('Male', record.Answer_Label__c , 'The Student Gender Not Matched');
                }
            }

        }


        // StudentTransitionTracking_v2.helperFetchOccupation(); //TODO : EXTRA Call to complete the code coverage

        Test.stopTest();
        
    }
}