public without sharing class StudentTransitionTracking_v2 {    

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

                is_a_Sub_Question__c,
                Parent_Question__c,

                English_Version_QnA__r.Question_Label__c, 
                (SELECT
                    Id,
                    Answer_Value__c,
                    Order_of_Answer__c,
                    Dependent_Question__c,
                    Is_Show_Others__c,
                    English_Version_QnA_Option__r.Answer_Value__c 
                FROM Transition_Tracking_QnA_Options__r
                WHERE is_Active__c=True
                ORDER BY Order_of_Answer__c)
            FROM Transition_Tracking_QnA__c
            WHERE Language__c = :language AND is_Active__c=true
            ORDER BY  Section__c ASC,  Order_of_Question__c ASC
        ]);

        System.debug('Student Id : '+studentId);
        System.debug('Language : '+language);

        System.debug('TrackQnA Record : '+lstQuestion.size());
        System.debug('TrackQnAoptions Record : '+lstQuestion[0].Transition_Tracking_QnA_Options__r.size());


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
                    
            objWrpStudentQuestion.englishQuestionLabel =  objQuestion.English_Version_QnA__r.Question_Label__c;  //ADDED NOW : ENGLISH TRANSLATEF LABEL

            //ADDED : 07072023
            objWrpStudentQuestion.isASubQuestion = objQuestion.is_a_Sub_Question__c;
            objWrpStudentQuestion.parentQuestionId = objQuestion.Parent_Question__c;


        
            //CUSTOMCODE : To set the Values fetched from contact
            if(String.isNotBlank(objQuestion.Question_Contact_Api_Name__c)&& objQuestion.Pull_From_Contact__c == true){
                objWrpStudentQuestion.contactFieldAnswer = String.valueOf(fetchedContact.get(objQuestion.Question_Contact_Api_Name__c));      
                objWrpStudentQuestion.isPulledFromContact = objQuestion.Pull_From_Contact__c; //Added Now : 11-07-2023
                if(objQuestion.is_Read_Only__c == true){
                    objWrpStudentQuestion.isReadOnly = true;
                }
            }
    
            if(objQuestion.Is_Career_Question__c){
                if(mapAllCareerAspirations == null || mapAllCareerAspirations.size() == 0){
                    mapAllCareerAspirations = fnGetCareerAspiration(language);
                }
                objWrpStudentQuestion.mapCareerAspiration = mapAllCareerAspirations;    
            }

            for(Transition_Tracking_QnA_Options__c objAnswer : objQuestion.Transition_Tracking_QnA_Options__r){
                if(!objWrpStudentQuestion.answerId.contains(';') && objWrpStudentQuestion.answerId == String.valueof(objAnswer.Id)){
                    objWrpStudentQuestion.isdependentquestionshow = true;
                }
                WrpStudentAnswer objWrpStudentAnswer = new WrpStudentAnswer();
                objWrpStudentAnswer.answerId = objAnswer.Id;
                objWrpStudentAnswer.answerValue = objAnswer.Answer_Value__c;

                objWrpStudentAnswer.englishVersionAnswerValue =  objAnswer.English_Version_QnA_Option__r.Answer_Value__c ; //ADDED NOW : For Purpose of Multilangauge

                
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
                        objWrpStudentQuestion.isshowtextarea = true;     
                    }
                }

                //CUSTOM CODE : TO CHECK IF VALUE MATHES THE QnAOptions Record Value.
                if (objQuestion.Question_Contact_Api_Name__c!=null){
                    if(fetchedContact.get(objQuestion.Question_Contact_Api_Name__c)== objAnswer.Answer_Value__c){
                        objWrpStudentQuestion.answerId=objAnswer.Id; //ADDED NOW for all below similar code also
                    }
                    //TODO : For Gender When Languages is Other Than English and add "OR" eg : objAnswer.Answer_Value__c="xyz in Marathi"
                    else if(fetchedContact.get(objQuestion.Question_Contact_Api_Name__c)=='Male' &&  (objAnswer.Answer_Value__c=='पुरुष' || objAnswer.Answer_Value__c=='مرد')){
                        objWrpStudentQuestion.answerId=objAnswer.Id;
                    }
                    else if(fetchedContact.get(objQuestion.Question_Contact_Api_Name__c)=='Female' &&  (objAnswer.Answer_Value__c=='स्त्री' || objAnswer.Answer_Value__c=='عورت')){
                        objWrpStudentQuestion.answerId=objAnswer.Id;
                    }
                    else if(fetchedContact.get(objQuestion.Question_Contact_Api_Name__c)=='Prefer not to say'  
                                &&  (objAnswer.Answer_Value__c=='कहना पसंद नहीं करते' || (objAnswer.Answer_Value__c=='नाही बोलू इच्चीतो' || objAnswer.Answer_Value__c=='کہنا پسند نہیں کرتے'))){
                        objWrpStudentQuestion.answerId=objAnswer.Id;
                    }                    
                }

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
        trackingObject.Grade__c = 'Grade 10'; //TODO : Harcoded FOR NOW
        INSERT trackingObject;

        if(String.isNotBlank(trackingObject.Id)){
            WrpStudentQuestionAnswer objWrpStudentQuestionAnswer = new WrpStudentQuestionAnswer();
            List<Transition_Tracking_Detail__c> upsertToAssessmentDetail = new List<Transition_Tracking_Detail__c>();
            Map<String,String> mapAssessmentDetail = new Map<String,String>();
            
            for(WrpStudentQuestion objWSQ: lstStudentQuestions){        
                if((!String.IsBlank(objWSQ.answerId)) 
                    || String.IsNotBlank(objWSQ.contactFieldAnswer) 
                    || (String.IsBlank(objWSQ.contactFieldAnswer) && objWSQ.isReadOnly) //Added Now : 11-07-2023
                    || String.IsNotBlank(objWSQ.otherAnswer)
                    || String.IsNotBlank(objWSQ.otherAnswerDescription)
                    ){
                    Transition_Tracking_Detail__c objAssessmentDetail =  new Transition_Tracking_Detail__c();     

                    //CUSTOMCODE : Statically to check if answerId is  {'Other' OR 'I dont Know'} AND Not A Carrer Question.
                    if((objWSQ.answerId == 'Other' || (objWSQ.answerId == 'I do not know/Not sure')) && !objWSQ.isCareerOption){ 
                        System.debug('Other answerId Found 1 : '+ objWSQ.answerId);
                        objWSQ.answerId  = '';
                    }
                        
                    if(!String.IsBlank(objWSQ.answerId)){    
                        System.debug('Other answerId Found 2 : '+ objWSQ.answerId);
                        if(!objWSQ.isCareerOption){
                            if(objWSQ.answerId.contains(',')){
                                //TODO : NOW we will iterate over answers to get Label Values
                                String allLabelValues = '';
                                for(WrpStudentAnswer ans : objWSQ.lstWrpStudentAnswer){
                                    if(objWSQ.answerId.split(',').contains(ans.answerId)){
                                        if(language == 'English'){ // When Language is English and Other Language
                                            allLabelValues += ans.answerValue+ ' ; ';
                                        }else{
                                            allLabelValues += ans.englishVersionAnswerValue + ' ; '; // For Other Langauage
                                        }
                                    }
                                }
                                allLabelValues = allLabelValues.substring(0, allLabelValues.length() - 2);
                                objAssessmentDetail.Multi_Answers__c =allLabelValues;
                                objAssessmentDetail.Answer__c = null;
                            }else{
                                objAssessmentDetail.Answer__c = objWSQ.answerId;
                            }
                        }else{
                            objAssessmentDetail.Career_Answer__c = objWSQ.answerId;
                        }
                    }
                //CUSTOMCODE : IF ANSEWERID NULL FOR YOUR CONTACT FIELD APIS -> WE WILL ADD ANOTHER TRACKDETAILS RECORD (with other field values) AND ADD TO LIST FOR UPSERT                    
                    if(String.IsNotBlank(objWSQ.contactFieldAnswer)){
                        //CUSTOMCODE: If The QnsObj has answerId and contactFieldAnswer then -> the Contact_Field_Value__c  should be of answerId Value. -> Else of contactFieldAnswer
                        if(String.IsNotBlank(objWSQ.answerId)){
                            objAssessmentDetail.Contact_Field_Value__c = '';
                        }else{
                            objAssessmentDetail.Contact_Field_Value__c = objWSQ.contactFieldAnswer;
                        }
                        objAssessmentDetail.Is_Contact_Api_Field__c = true;
                    }
                    if(String.IsBlank(objWSQ.contactFieldAnswer) && objWSQ.isReadOnly && objWSQ.isPulledFromContact){ //Added Now : 11-07-2023
                        objAssessmentDetail.Is_Contact_Api_Field__c = true;
                    }

                    if(String.IsNotBlank(objWSQ.otherAnswer)){
                        objAssessmentDetail.User_Entered_Value__c = objWSQ.otherAnswer;
                    }

                    if(String.IsNotBlank(objWSQ.otherAnswerDescription)){
                        objAssessmentDetail.Other_Answer_Description__c = objWSQ.otherAnswerDescription;
                    }
                //TILL HERE
                    objAssessmentDetail.Transition_Tracking__c = trackingObject.Id; //Transition Tracking Object Id.
                    objAssessmentDetail.Question__c = objWSQ.questionId;
                    objAssessmentDetail.Student__c = studentId;
                    objAssessmentDetail.Language__c = language;
                    if(language == 'English'){
                        objAssessmentDetail.Question_Label__c = objWSQ.questionLabel;                         
                    }else{
                        objAssessmentDetail.Question_Label__c = objWSQ.englishQuestionLabel; 
                    }
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
        public String englishQuestionLabel {get;set;}
        
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

        @AuraEnabled
        public String contactFieldAnswer {get;set;}
        
        @AuraEnabled
        public String otherAnswer {get;set;}
        
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
        public Boolean isASubQuestion {get;set;}

        @AuraEnabled
        public String parentQuestionId {get;set;}

        @AuraEnabled
        public Boolean isPulledFromContact {get;set;}


        
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
            isCareerOption = false;
            isCareerNextStep = false;
            mapCareerAspiration = new Map<String, String>();
            mapAspirationStep = new Map<String, List<String>>();
            maxAllowAnswer = 0;
            isshowtextarea = false;
            lstWrpStudentAnswer = new List<WrpStudentAnswer>();
            contactFieldAnswer = '';
            isReadOnly=false;
            otherAnswer='';
            maximumValueToEnter = 100;
            validationPresent=false;
            validationErrorMessage = '';
            validationRegex = '';
            isValidComponent=true;

            englishQuestionLabel='';
            isASubQuestion=false;
            parentQuestionId='';
            isPulledFromContact=false;
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
        
        @AuraEnabled
        public String englishVersionAnswerValue {get;set;}

        public WrpStudentAnswer(){
            answerId = '';
            isdisabled = false;
            answerValue = '';
            orderOfAnswer = 0;
            dependentquestion = null;
            isShowOtherOption = false;
            englishVersionAnswerValue='';
        }
    }
    
}