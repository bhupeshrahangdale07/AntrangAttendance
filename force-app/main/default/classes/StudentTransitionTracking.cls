public without sharing class StudentTransitionTracking {
    
    @AuraEnabled
    public static WrpStudentQuestionAnswer fetchStudentQuestionsAndAnswers(String studentId, String language){
        System.debug('Student Id : '+studentId);
        WrpStudentQuestionAnswer objWrpStudentQuestionAnswer = new WrpStudentQuestionAnswer();
        Map<Id,Transition_Tracking_Detail__c> mapTransitionTrackingDetail = new Map<Id,Transition_Tracking_Detail__c>();
        Set<String> setMatchAnswerValues = new Set<String>();
        Map<String, String> mapAllCareerAspirations = new Map<String, String>();
        Map<String, List<String>> mapAllCareerNextSteps = new Map<String, List<String>>();
        
        
        List<Transition_Tracking_QnA__c> lstQuestion = new List<Transition_Tracking_QnA__c>([
            SELECT
                Id,
                Display_Type__c,
                Order_of_Question__c,
                Question_Label__c,
                Section__c,
                Display_Number__c,
                Is_Dependent_Question__c,
                Is_Career_Question__c,
                Maximum_Allow_Answer__c,
                Question_Contact_Api_Name__c,
                Pull_From_Contact__c,
                is_Read_Only__c,

                Maximum_Value_To_Enter__c,
                Validation_To_Do__c,
                Validation_Error_Message__c,
                Validation_Regex__c,

                Show_Other_Option__c,
                Show_I_do_not_know_Option__c,

                Primary_Dependent_Question__c,
                //PROBLEM : Still confused about this 5 fields
                // Secondry_Dependent_Question__c,
                // is_Primary_Dependent_Question__c,
                // is_Secondry_Dependent_Question__c,
                // isTernary_Dependent_Question__c,
                (SELECT
                    Id,
                    Answer_Value__c,
                    Order_of_Answer__c,
                    Dependent_Question__c,
                    Is_Show_Others__c
                FROM Transition_Tracking_QnA_Options__r
                ORDER BY Order_of_Answer__c)
            FROM Transition_Tracking_QnA__c
            WHERE Language__c = :language
            ORDER BY  Section__c ASC,  Order_of_Question__c ASC
        ]);

        System.debug('Student Id : '+studentId);
        System.debug('Language : '+language);

        System.debug('TrackQnA Record : '+lstQuestion.size());
        System.debug('TrackQnAoptions Record : '+lstQuestion[0].Transition_Tracking_QnA_Options__r.size());


        //CUSTOMCODE 2: 
        contact fetchedContact = new Contact();
            List<String> studentFieldApis = new List<string>();
            for(Transition_Tracking_QnA__c QnA : lstQuestion){
                if(String.isNotBlank(QnA.Question_Contact_Api_Name__c)&&(QnA.Pull_From_Contact__c == True)){
                    studentFieldApis.add(QnA.Question_Contact_Api_Name__c);
                }
            }
            System.debug('Contact Record : '+fetchedContact);
        if(studentFieldApis.size()>0){
            fetchedContact = helperFetchContact(studentId,studentFieldApis);
        }
        //TILL HERE 2...

        
        for(Transition_Tracking_QnA__c objQuestion : lstQuestion){
            WrpStudentQuestion objWrpStudentQuestion = new WrpStudentQuestion();
            objWrpStudentQuestion.questionId = objQuestion.Id;
            objWrpStudentQuestion.sectionNumber = Integer.valueof(objQuestion.Section__c);
            objWrpStudentQuestion.questionLabel = objQuestion.Question_Label__c;
            objWrpStudentQuestion.orderOfQuestion = Integer.valueof(objQuestion.Order_of_Question__c);
            objWrpStudentQuestion.fieldType = objQuestion.Display_Type__c;
            objWrpStudentQuestion.displayNumber = objQuestion.Display_Number__c;
            objWrpStudentQuestion.isdependentquestion = objQuestion.Is_Dependent_Question__c;
            objWrpStudentQuestion.isdependentquestionshow = false;
            objWrpStudentQuestion.isCareerOption = objQuestion.Is_Career_Question__c;
            objWrpStudentQuestion.maxAllowAnswer = Integer.valueof(objQuestion.Maximum_Allow_Answer__c);
            
            objWrpStudentQuestion.maximumValueToEnter =(Integer)objQuestion.Maximum_Value_To_Enter__c;
            objWrpStudentQuestion.validationPresent =objQuestion.Validation_To_Do__c;
            objWrpStudentQuestion.validationErrorMessage =objQuestion.Validation_Error_Message__c;
            objWrpStudentQuestion.validationRegex =objQuestion.Validation_Regex__c;
            
            objWrpStudentQuestion.isShowOtherOption =objQuestion.Show_Other_Option__c;
            objWrpStudentQuestion.isIdontKnowOption =objQuestion.Show_I_do_not_know_Option__c;
            
            //Prefect till here in The objWrapper Object.
           
            objWrpStudentQuestion.primaryDependentQuestionId = objQuestion.Primary_Dependent_Question__c;

            // objWrpStudentQuestion.secondryDependentQuestionId = objQuestion.Secondry_Dependent_Question__c;
            // objWrpStudentQuestion.isPrimaryDependentQuestion = objQuestion.is_Primary_Dependent_Question__c;
            // objWrpStudentQuestion.isSecondaryDependentQuestion = objQuestion.is_Secondry_Dependent_Question__c;
            // objWrpStudentQuestion.isTernaryDependentQuestion = objQuestion.isTernary_Dependent_Question__c;
            


            //CUSTOMCODE 2: To set the Values fetched from contact
            if(String.isNotBlank(objQuestion.Question_Contact_Api_Name__c)&& objQuestion.Pull_From_Contact__c == true){
                objWrpStudentQuestion.contactFieldAnswer = String.valueOf(fetchedContact.get(objQuestion.Question_Contact_Api_Name__c));      
                if(objQuestion.is_Read_Only__c == true){
                    objWrpStudentQuestion.isReadOnly = true;
                }
            }

            if(objQuestion.Question_Contact_Api_Name__c == 'Father_Occupation__c'){
                objWrpStudentQuestion.listOfOccupations = helperFetchOccupation();
                objWrpStudentQuestion.isFatherOccupation = true;
            }

            if(objQuestion.Question_Contact_Api_Name__c == 'Mother_Occupation__c'){
                objWrpStudentQuestion.listOfOccupations = helperFetchOccupation();
                objWrpStudentQuestion.isMotherOccupation = true;
            }
            //Adding Validation to Only State i.e. Goa where min percentage is 33
            if(objQuestion.Question_Label__c=='How much did you score in your 10th boards?'){
                String stateName = fetchedContact.G10_Batch_Code__r.School_Name__r.State__r.Name;
                if(stateName=='Goa'){
                    objWrpStudentQuestion.validationRegex='^(3[3-9]\\.[0-9][0-9]|[4-9][0-9]\\.[0-9][0-9]|3[3-9]|100|[4-9][0-9])$';
                }
            }
            //TILL HERE 2...
    
            if(objQuestion.Is_Career_Question__c){
                if(mapAllCareerAspirations == null || mapAllCareerAspirations.size() == 0){
                    mapAllCareerAspirations = fnGetCareerAspiration(language);
                }
                objWrpStudentQuestion.mapCareerAspiration = mapAllCareerAspirations;    
            }

     // PERFECT TILL HERE NO CONFUSION......     
            for(Transition_Tracking_QnA_Options__c objAnswer : objQuestion.Transition_Tracking_QnA_Options__r){
                if(!objWrpStudentQuestion.answerId.contains(';') && objWrpStudentQuestion.answerId == String.valueof(objAnswer.Id)){
                    objWrpStudentQuestion.isdependentquestionshow = true;
                }
                WrpStudentAnswer objWrpStudentAnswer = new WrpStudentAnswer();
                objWrpStudentAnswer.answerId = objAnswer.Id;
                objWrpStudentAnswer.answerValue = objAnswer.Answer_Value__c;
                
                if(setMatchAnswerValues.contains(objAnswer.Answer_Value__c) && mapTransitionTrackingDetail.containskey(objQuestion.Id) 
                    && objAnswer.Answer_Value__c != mapTransitionTrackingDetail.get(objQuestion.Id).Answer__r.Answer_Value__c){
                    objWrpStudentAnswer.isdisabled = true;
                }
                
                objWrpStudentAnswer.orderOfAnswer = Integer.valueof(objAnswer.Order_of_Answer__c);
                if(objAnswer.Dependent_Question__c != null){
                    objWrpStudentAnswer.dependentquestion = objAnswer.Dependent_Question__c;
                }
                
                if(objAnswer.Is_Show_Others__c){
                    objWrpStudentAnswer.isShowOtherOption = objAnswer.Is_Show_Others__c;
                    if(objWrpStudentQuestion.answerId.indexOf(objAnswer.Id) != -1){
                        objWrpStudentQuestion.isshowtextarea = true;     //TODO : Thoda confusion hai idr ASK SANDIP SIR FOR THIS. 
                    }
                }

                //CUSTOM CODE 2: TO CHECK IF VALUE MATHES THE QnAOptions Record Value.
                if (objQuestion.Question_Contact_Api_Name__c!=null){
                    if(fetchedContact.get(objQuestion.Question_Contact_Api_Name__c)== objAnswer.Answer_Value__c){
                        objWrpStudentAnswer.isPulledFromContact=true;
                    }
                }
                //TILL HERE

                objWrpStudentQuestion.lstWrpStudentAnswer.add(objWrpStudentAnswer);
            }
            objWrpStudentQuestionAnswer.lstWrpStudentQuestion.add(objWrpStudentQuestion);            
        }        
        mapAllCareerAspirations = null;
        mapAllCareerNextSteps = null;
        System.debug('Questions Count : '+  objWrpStudentQuestionAnswer.lstWrpStudentQuestion.size());
        return objWrpStudentQuestionAnswer;    
    }



    @AuraEnabled
    public static void saveTransitionTrackingRecord(List<WrpStudentQuestion>lstStudentQuestions,String studentId,String language){

        Transition_Tracking__c trackingObject = new Transition_Tracking__c();
        trackingObject.Student__c = studentId;
        trackingObject.Language__c = language;
        trackingObject.Grade__c = 'Grade 10'; //TODO : Harcoded because to Ask From Where to get the Grade from Student
        INSERT trackingObject;

        if(String.isNotBlank(trackingObject.Id)){
            WrpStudentQuestionAnswer objWrpStudentQuestionAnswer = new WrpStudentQuestionAnswer();
            List<Transition_Tracking_Detail__c> upsertToAssessmentDetail = new List<Transition_Tracking_Detail__c>();
            Map<String,String> mapAssessmentDetail = new Map<String,String>();
            
            for(WrpStudentQuestion objWSQ: lstStudentQuestions){        
                if((!String.IsBlank(objWSQ.answerId)) 
                    || String.IsNotBlank(objWSQ.contactFieldAnswer) 
                    || String.IsNotBlank(objWSQ.otherAnswer)
                    || String.IsNotBlank(objWSQ.otherAnswerDescription)
                    || String.IsNotBlank(objWSQ.iDontKnowAnswerDescription)){
                    Transition_Tracking_Detail__c objAssessmentDetail =  new Transition_Tracking_Detail__c();     

                    //CUSTOMCODE : Statically to check if answerId is not 'Other' and 'I dont Know'.
                    if(objWSQ.answerId == 'Other' || objWSQ.answerId == 'I do not know/Not sure'){ 
                        System.debug('Other answerId Found 1 : '+ objWSQ.answerId);
                        objWSQ.answerId  = '';
                    }
                     
                    if(!String.IsBlank(objWSQ.answerId)){    
                        System.debug('Other answerId Found 2 : '+ objWSQ.answerId);
                        if(!objWSQ.isCareerOption){
                            if(objWSQ.answerId.contains(',')){
                                //TODO : NOW we will itrate over answers to get Label Values
                                String allLabelValues = '';
                                for(WrpStudentAnswer ans : objWSQ.lstWrpStudentAnswer){
                                    if(objWSQ.answerId.split(',').contains(ans.answerId)){
                                        allLabelValues += ans.answerValue+ ' ; ';
                                    }
                                }
                                allLabelValues = allLabelValues.substring(0, allLabelValues.length() - 2);
                                objAssessmentDetail.Multi_Answers__c =allLabelValues;
                                objAssessmentDetail.Answer__c = null;
                                //TILL HERE ...
                            }else{
                                objAssessmentDetail.Answer__c = objWSQ.answerId;
                            }
                        }else{
                            objAssessmentDetail.Career_Answer__c = objWSQ.answerId;
                        }
                    }
                //CUSTOMCODE : IF ANSEWERID NULL FOR YOUR CONTACT FIELD APIS -> WE WILL ADD ANOTHER TRACKDETAILS RECORD (with other field values) AND ADD TO LIST FOR UPSERT
                    else if(String.IsNotBlank(objWSQ.contactFieldAnswer)){
                        objAssessmentDetail.Contact_Field_Value__c = objWSQ.contactFieldAnswer;
                        // objAssessmentDetail.Is_Contact_Api_Field__c = true; //Todo : Not needed Now
                    }else if(String.IsNotBlank(objWSQ.otherAnswer)){
                        objAssessmentDetail.User_Entered_Value__c = objWSQ.otherAnswer;
                    }else if(String.IsNotBlank(objWSQ.otherAnswerDescription)){
                        objAssessmentDetail.Other_Answer_Description__c = objWSQ.otherAnswerDescription;
                    }else{
                        objAssessmentDetail.I_Dont_Know_Answer_Description__c = objWSQ.iDontKnowAnswerDescription;
                    }
                //TILL HERE
                    objAssessmentDetail.Transition_Tracking__c = trackingObject.Id; //Transition Tracking Object Id.
                    objAssessmentDetail.Question__c = objWSQ.questionId;
                    objAssessmentDetail.Student__c = studentId;
                    objAssessmentDetail.Language__c = language;
                    objAssessmentDetail.Question_Label__c = objWSQ.questionLabel; 
                    System.debug('Upsert Record : '+ objAssessmentDetail);
                    upsertToAssessmentDetail.add(objAssessmentDetail);
                }
                
            }
            
            if(upsertToAssessmentDetail.size() > 0){
                INSERT upsertToAssessmentDetail;
                System.debug('Upsert List : '+upsertToAssessmentDetail);
                System.debug('Upsert List Count : '+upsertToAssessmentDetail.size());
            }
        }
    }

    

    //HELPER : To fetch Contact Dynamically.
    private static Contact helperFetchContact(String studentId,List<String> studentFieldApis){
        try{
            String innerQuery = '';
            if(studentFieldApis.size()>0){
                innerQuery = String.join(studentFieldApis,',');
            }
            string Query = 'SELECT Id, G10_Batch_Code__r.School_Name__r.State__r.Name, '+innerQuery+' FROM Contact WHERE Id=:studentId LIMIT 1';
            System.debug('Final Query : '+ Query);
            return Database.query(query);
        }catch(Exception exp){
            System.debug('Query Exception : '+ exp.getMessage());   
            return null;
        }
    }

    //HELPER : To fetch Occupations from the Custom Settings Named: OMR Field Mapping
    private static List<string> helperFetchOccupation(){
        List<String> lstOccupation = new List<String>();
         For(OMR_Field_Mapping__c omr : OMR_Field_Mapping__c.getall().values()){
            if(omr.Field_Type__c =='Father Occupation'){
                lstOccupation.add(omr.Name);
            }
        }
        RETURN lstOccupation;
    }
    

    //HELPER : To fetech all the Careers Aspirations options.

    private static Map<String, String> fnGetCareerAspiration(String language){
        Map<String, String> mapCareerAspirations = new Map<String, String>();        
        List<IARP_Master__c> lstIARPMaster = fetchIARPMasters();
        
        for(IARP_Master__c objIARPMaster : lstIARPMaster){
            if(language == 'English'){
                mapCareerAspirations.put(objIARPMaster.Name, objIARPMaster.Label_for_the_Assessment_form__c);
            }else if(language == 'Hindi'){
                mapCareerAspirations.put(objIARPMaster.Name, objIARPMaster.Hindi_Label_for_the_Assessment_form__c);
            }else if(language == 'Marathi'){
                mapCareerAspirations.put(objIARPMaster.Name, objIARPMaster.Marathi_Label_for_the_Assessment_form__c);
            }else if(language == 'Urdu'){
                mapCareerAspirations.put(objIARPMaster.Name, objIARPMaster.Urdu_Label_for_the_Assessment_form__c);
            }
        }
        return mapCareerAspirations;
    }
    
    private static List<IARP_Master__c> fetchIARPMasters(){
        List<IARP_Master__c> lstIARPMaster = new List<IARP_Master__c>([
            SELECT 
                Id, 
                Name,
                Label_for_the_Assessment_form__c,
                Hindi_Label_for_the_Assessment_form__c,
                Marathi_Label_for_the_Assessment_form__c,
                Urdu_Label_for_the_Assessment_form__c,
                Interest_1__c, 
                Interest_2__c, 
                Interest_3__c, 
                Aptitude_1__c, 
                Aptitude_2__c, 
                Aptitude_3__c, 
                Reality_1__c, 
                Reality_2__c, 
                Reality_3__c, 
                Reality_4__c,
                Reality_5__c, 
                Reality_6__c, 
                Reality_7__c, 
                Reality_8__c 
            FROM IARP_Master__c 
            WHERE Is_Active__c = true
            AND Name != 'Other'
            AND Name != 'I do not know'
            ORDER BY Name
        ]);
        
        return lstIARPMaster.size() > 0 ? lstIARPMaster : null;
    }
    
    
    public class WrpStudentQuestionAnswer{
        @AuraEnabled
        public List<WrpStudentQuestion> lstWrpStudentQuestion {get;set;}
        
        @AuraEnabled
        public Boolean isSubmitted {get;set;}
        
        @AuraEnabled
        public Assessment_Marks__c objAssessmentMarks {get;set;}
        
        public WrpStudentQuestionAnswer(){
            lstWrpStudentQuestion = new List<WrpStudentQuestion>();
            isSubmitted = false;
            objAssessmentMarks = new Assessment_Marks__c();
        }
    }
    
    public class WrpStudentQuestion{
        @AuraEnabled
        public Id tempObjectId {get;set;}
        
        @AuraEnabled
        public Id questionId {get;set;}
        
        @AuraEnabled
        public Integer sectionNumber {get;set;}
        
        @AuraEnabled
        public String displayNumber {get;set;}
        
        @AuraEnabled
        public String questionLabel {get;set;}
        
        @AuraEnabled
        public Integer orderOfQuestion {get;set;}
        
        @AuraEnabled
        public String fieldType {get;set;}
        
        @AuraEnabled
        public String answerId {get;set;}

        @AuraEnabled
        public Boolean isdependentquestion {get;set;}

        @AuraEnabled
        public Boolean isdependentquestionshow {get;set;}
        
        @AuraEnabled
        public String otherAnswerDescription {get;set;}

        @AuraEnabled
        public String iDontKnowAnswerDescription {get;set;}
        
        @AuraEnabled
        public Boolean isCareerOption {get;set;}
        
        @AuraEnabled
        public Boolean isCareerNextStep {get;set;}
        
        @AuraEnabled
        public Map<String, String> mapCareerAspiration {get;set;}
        
        @AuraEnabled
        public Map<String, List<String>> mapAspirationStep {get;set;}
        
        @AuraEnabled
        public Integer maxAllowAnswer {get;set;}
        
        @AuraEnabled
        public Boolean isshowtextarea {get;set;}        
        
        @AuraEnabled
        public List<WrpStudentAnswer> lstWrpStudentAnswer{get;set;}

        //CUSTOMCODE : Variable to store the Contact Field Api Value.
        @AuraEnabled
        public String contactFieldAnswer {get;set;}
        
        @AuraEnabled
        public String otherAnswer {get;set;}
        
        @AuraEnabled
        public List<String> listOfOccupations {get;set;}
        
        @AuraEnabled
        public Boolean isFatherOccupation {get;set;}
        
        @AuraEnabled
        public Boolean isMotherOccupation {get;set;}
        
        @AuraEnabled
        public Boolean isReadOnly {get;set;}
        
        @AuraEnabled
        public Integer maximumValueToEnter {get;set;}
        
        @AuraEnabled
        public Boolean validationPresent {get;set;}
        
        @AuraEnabled
        public String validationErrorMessage {get;set;}
        
        @AuraEnabled
        public String validationRegex {get;set;}
       
        @AuraEnabled
        public Boolean isValidComponent {get;set;}
        
        @AuraEnabled
        public Boolean isShowOtherOption {get;set;}
        
        @AuraEnabled
        public Boolean isIdontKnowOption {get;set;}
        


        @AuraEnabled
        public Id primaryDependentQuestionId {get;set;}
        
        // @AuraEnabled
        // public Id secondryDependentQuestionId {get;set;}
        
        // @AuraEnabled
        // public Boolean isPrimaryDependentQuestion {get;set;}
                
        // @AuraEnabled
        // public Boolean isSecondaryDependentQuestion {get;set;}

        // @AuraEnabled
        // public Boolean isTernaryDependentQuestion {get;set;}


        // @AuraEnabled
        // public Boolean isSecondaryDependentQuestionShow {get;set;}
       
        // @AuraEnabled
        // public Boolean isTernaryDependentQuestionShow {get;set;}
        //TILL HERE...


        
        public WrpStudentQuestion(){
            tempObjectId = null;
            questionId = null;
            sectionNumber = 0;
            displayNumber = '';
            questionLabel = '';
            orderOfQuestion = 0;
            fieldType = '';
            answerId = '';
            isdependentquestion = false;
            isdependentquestionshow = false;
            otherAnswerDescription = '';
            iDontKnowAnswerDescription='';
            isCareerOption = false;
            isCareerNextStep = false;
            mapCareerAspiration = new Map<String, String>();
            mapAspirationStep = new Map<String, List<String>>();
            maxAllowAnswer = 0;
            isshowtextarea = false;
            lstWrpStudentAnswer = new List<WrpStudentAnswer>();

            //CUSTOM CODE 2 : EXTRA DEFINED VARIABLEs
            contactFieldAnswer = '';
            isFatherOccupation=false;
            isMotherOccupation=false;
            listOfOccupations  = new List<String>();
            isReadOnly=false;
            otherAnswer='';
            maximumValueToEnter = 100;
            validationPresent=false;
            validationErrorMessage = '';
            validationRegex = '';
            isValidComponent=true;

            isShowOtherOption=false;
            isIdontKnowOption=false;

            primaryDependentQuestionId = null;
            // secondryDependentQuestionId = null;

            // isPrimaryDependentQuestion = false;
            
            // isSecondaryDependentQuestion = false;
            // isSecondaryDependentQuestionShow  = false;
            
            // isTernaryDependentQuestion = false;
            // isTernaryDependentQuestionShow  = false;
        }
    }

    public class WrpStudentAnswer{        
        @AuraEnabled
        public String answerId {get;set;}
        
        @AuraEnabled
        public Boolean isdisabled {get;set;}
        
        @AuraEnabled
        public String answerValue {get;set;}

        @AuraEnabled
        public Integer orderOfAnswer {get;set;}

        @AuraEnabled
        public Id dependentquestion {get;set;}
        
        @AuraEnabled
        public Boolean isShowOtherOption {get;set;}
        
        //CUSTOM CODE 2 : EXTRA DEFINED VARIABLEs
        @AuraEnabled
        public Boolean isPulledFromContact {get;set;}

        public WrpStudentAnswer(){
            answerId = '';
            isdisabled = false;
            answerValue = '';
            orderOfAnswer = 0;
            dependentquestion = null;
            isShowOtherOption = false;
            isPulledFromContact = false;
        }
    }
}