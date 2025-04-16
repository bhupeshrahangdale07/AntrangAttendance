/********************************************************************************************   
* NAME         : StudentAssessmentFormCtrl
* DESCRIPTION  : This class is use to Student Assessment Exam Paper
*   
* @AUTHOR: Dev Team
* @DATE: 6th July 2021
*   
********************************************************************************************/  

public without sharing class StudentAssessmentFormCtrl{

	//BaseLine edit	
    public static String AssessmentDetail_Baseline_RT = Schema.getGlobalDescribe()	
        .get('Assessment_Detail__c')	
        .getDescribe()	
        .getRecordTypeInfosByDeveloperName()	
        .get('Baseline_Assessment')	
        .getRecordTypeId();		
    //BaseLine edit	
    public static String AssessmentMark_Baseline_RT = Schema.getGlobalDescribe()	
        .get('Assessment_Marks__c')	
        .getDescribe()	
        .getRecordTypeInfosByDeveloperName()	
        .get('Baseline_Assessment')	
        .getRecordTypeId();    

    @AuraEnabled
    public static wrpStudentData fetchStudentData(String contactId){
        List<Contact> lstContact = new List<Contact>([
            SELECT
                Id,
                Name,
                Phone, 
                MobilePhone,
                Gender__c,
                Father_Education__c,
                Mother_Education__c,
                Household_Income__c,
                Caste_Certificate_present__c,
                Birthdate,
                Batch_Code__r.School_Name__r.Name,
                Account.State__r.Name, 
                Account.City__r.Name
            FROM Contact
            WHERE Id = :contactId
        ]);
        
        if(lstContact.size() > 0){
            wrpStudentData objWSD = new wrpStudentData();
            objWSD.studentId = lstContact[0].Id;
            objWSD.studentName = lstContact[0].Name;
            objWSD.studentContactNumber = lstContact[0].Phone;
            objWSD.studentDOB = lstContact[0].Birthdate;
            objWSD.schoolName = lstContact[0].Batch_Code__r.School_Name__r.Name;
            objWSD.state = lstContact[0].Account.State__r.Name;
            objWSD.city = lstContact[0].Account.City__r.Name;
            objWSD.whatsappNumber  = lstContact[0].MobilePhone;
            objWSD.gender = lstContact[0].Gender__c;
            objWSD.fatherEducation = lstContact[0].Father_Education__c;
            objWSD.motherEducation = lstContact[0].Mother_Education__c;
            objWSD.householdIncome =  lstContact[0].Household_Income__c;
            objWSD.studentCast = lstContact[0].Caste_Certificate_present__c;
            
            return objWSD;
        }
        return null;
    }
    
    @AuraEnabled
    public static String updateStudentData(wrpStudentData contactDetail){
        if(contactDetail != null){
            Contact objContact = new Contact();
            
            objContact.Id = contactDetail.studentId;
            objContact.MobilePhone = contactDetail.whatsappNumber;
            objContact.Household_Income__c = contactDetail.householdIncome;
            objContact.Father_Education__c = contactDetail.fatherEducation;
            objContact.Mother_Education__c = contactDetail.motherEducation;
            objContact.Caste_Certificate_present__c = contactDetail.studentCast;
            objContact.Birthdate = contactDetail.studentDOB;
            objContact.Gender__c = contactDetail.gender;
            
            if(objContact.Id != null){
                Update objContact;
                return 'success';
            }
        }
        return null;
    }
    
    @AuraEnabled
    public static WrpStudentQuestionAnswer fetchStudentQuestionsAndAnswers(String studentId, String language){
        WrpStudentQuestionAnswer objWrpStudentQuestionAnswer = new WrpStudentQuestionAnswer();
        Map<Id,Assessment_Detail__c> mapAssessmentDetail = new Map<Id,Assessment_Detail__c>();
        Set<String> setMatchAnswerValues = new Set<String>();
        Map<String, String> mapAllCareerAspirations = new Map<String, String>();
        Map<String, List<String>> mapAllCareerNextSteps = new Map<String, List<String>>();
        
        //This is return if already submitted assessment.
        Assessment_Marks__c assessmentMarks = fetchAssessmentMarks(studentId, AssessmentMark_Baseline_RT);   //BaseLine
        
        if(assessmentMarks != null){
            objWrpStudentQuestionAnswer.isSubmitted = true;
            objWrpStudentQuestionAnswer.objAssessmentMarks = assessmentMarks;
            return objWrpStudentQuestionAnswer;
        }
        
        for(Assessment_Detail__c objAD : [
            SELECT Id, Question__c, Question__r.Display_Type__c, 
            Answer__c, Answer__r.Answer_Value__c, Career_Answer__c,
            Multi_Answers__c,Other_Answer_Description__c 
            FROM Assessment_Detail__c WHERE Student__c =: studentId
            AND Question__r.Language__c = :language
			AND RecordTypeId = :AssessmentDetail_Baseline_RT                                    //BaseLine edit
            ORDER BY Question__r.Section__c, Question__r.Order_of_Question__c]
        ){
            mapAssessmentDetail.put(objAD.Question__c,objAD);
            
            if(objAD.Question__r.Display_Type__c == 'MatchColumn') {
                setMatchAnswerValues.add(objAD.Answer__r.Answer_Value__c);
            }
        }
        
        List<Question__c> lstQuestion = new List<Question__c>([
            SELECT
                Id,
                Display_Type__c,
                Order_of_Question__c,
                Question_Label__c,
                Section__c,
                Display_Number__c,
                Is_Dependent_Question__c,
                Assessment__c,
                Is_Career_Question__c,
                Is_NextStep_Question__c,
                Maximum_Allow_Answer__c,
                (SELECT
                    Id,
                    Answer_Value__c,
                    Order_of_Answer__c,
                    Dependent_Question__c,
                    Is_Show_Others__c
                FROM Question_Options__r
                ORDER BY Order_of_Answer__c)
            FROM Question__c
            WHERE Language__c = :language
            ORDER BY  Section__c ASC,  Order_of_Question__c ASC
        ]);
        
        for(Question__c objQuestion : lstQuestion){
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
            objWrpStudentQuestion.isCareerNextStep = objQuestion.Is_NextStep_Question__c;
            objWrpStudentQuestion.maxAllowAnswer = Integer.valueof(objQuestion.Maximum_Allow_Answer__c);
            
            if(objQuestion.Is_Career_Question__c){
                if(mapAllCareerAspirations == null || mapAllCareerAspirations.size() == 0){
                    mapAllCareerAspirations = fnGetCareerAspiration(language);
                }
                objWrpStudentQuestion.mapCareerAspiration = mapAllCareerAspirations;
                
                if(mapAllCareerNextSteps == null || mapAllCareerNextSteps.size() == 0){
                    mapAllCareerNextSteps = fnGetAspirationStep(language);
                }
                
                objWrpStudentQuestion.mapAspirationStep = mapAllCareerNextSteps;
            }
            
            if(mapAssessmentDetail.containskey(objQuestion.Id)){
                objWrpStudentQuestion.tempObjectId = mapAssessmentDetail.get(objQuestion.Id).Id;
                
                if(mapAssessmentDetail.get(objQuestion.Id).Answer__c != null){
                    objWrpStudentQuestion.answerId = mapAssessmentDetail.get(objQuestion.Id).Answer__c;
                }else{
                    objWrpStudentQuestion.answerId = mapAssessmentDetail.get(objQuestion.Id).Multi_Answers__c;
                }
                
                if(!String.IsBlank(mapAssessmentDetail.get(objQuestion.Id).Career_Answer__c) && 
                    mapAssessmentDetail.get(objQuestion.Id).Answer__c == null &&
                    String.IsBlank(mapAssessmentDetail.get(objQuestion.Id).Multi_Answers__c)){
                    objWrpStudentQuestion.answerId = mapAssessmentDetail.get(objQuestion.Id).Career_Answer__c;
                    
                    if(mapAssessmentDetail.get(objQuestion.Id).Career_Answer__c == 'Others' ||
                        mapAssessmentDetail.get(objQuestion.Id).Career_Answer__c == 'Other'){
                        objWrpStudentQuestion.isshowtextarea = true;
                    }
                }
                
                if(!String.IsBlank(mapAssessmentDetail.get(objQuestion.Id).Other_Answer_Description__c)){
                    objWrpStudentQuestion.otherAnswerDescription = mapAssessmentDetail.get(objQuestion.Id).Other_Answer_Description__c;
                }
            }
            
            for(Question_Option__c objAnswer : objQuestion.Question_Options__r){
                if(!objWrpStudentQuestion.answerId.contains(',') && objWrpStudentQuestion.answerId == String.valueof(objAnswer.Id)){
                    objWrpStudentQuestion.isdependentquestionshow = true;
                }
                
                WrpStudentAnswer objWrpStudentAnswer = new WrpStudentAnswer();
                objWrpStudentAnswer.answerId = objAnswer.Id;
                objWrpStudentAnswer.answerValue = objAnswer.Answer_Value__c;
                
                if(setMatchAnswerValues.contains(objAnswer.Answer_Value__c) && mapAssessmentDetail.containskey(objQuestion.Id) 
                    && objAnswer.Answer_Value__c != mapAssessmentDetail.get(objQuestion.Id).Answer__r.Answer_Value__c){
                    objWrpStudentAnswer.isdisabled = true;
                }
                
                objWrpStudentAnswer.orderOfAnswer = Integer.valueof(objAnswer.Order_of_Answer__c);
                if(objAnswer.Dependent_Question__c != null){
                    objWrpStudentAnswer.dependentquestion = objAnswer.Dependent_Question__c;
                }
                
                if(objAnswer.Is_Show_Others__c){
                    objWrpStudentAnswer.isShowOtherOption = objAnswer.Is_Show_Others__c;
                    if(objWrpStudentQuestion.answerId.indexOf(objAnswer.Id) != -1){
                        objWrpStudentQuestion.isshowtextarea = true;     //TODO : Thoda confusion hai idr. 
                    }
                }
                objWrpStudentQuestion.lstWrpStudentAnswer.add(objWrpStudentAnswer);
            }
            
            objWrpStudentQuestionAnswer.lstWrpStudentQuestion.add(objWrpStudentQuestion);            
        }
        
        mapAllCareerAspirations = null;
        mapAllCareerNextSteps = null;
        
        return objWrpStudentQuestionAnswer;    
    }
    
    @AuraEnabled
    public static WrpStudentQuestionAnswer saveAndNextAssessment(List<WrpStudentQuestion> lstStudentQuestions, String studentId, String actionName, String language){   
        WrpStudentQuestionAnswer objWrpStudentQuestionAnswer = new WrpStudentQuestionAnswer();
        List<Assessment_Detail__c> upsertToAssessmentDetail = new List<Assessment_Detail__c>();
        Map<String,String> mapAssessmentDetail = new Map<String,String>();
        
        for(WrpStudentQuestion objWSQ: lstStudentQuestions){
        
            if(!String.IsBlank(objWSQ.answerId)){
                Assessment_Detail__c objAssessmentDetail = objWSQ.tempObjectId != null ? 
				new Assessment_Detail__c(Id = objWSQ.tempObjectId) : new Assessment_Detail__c(RecordTypeId = AssessmentDetail_Baseline_RT);      //BaseLine edit
                
                if(!objWSQ.isCareerOption){
                    if(objWSQ.answerId.contains(',')){
                        objAssessmentDetail.Multi_Answers__c = objWSQ.answerId;
                        objAssessmentDetail.Answer__c = null;
                    }else{
                        objAssessmentDetail.Answer__c = objWSQ.answerId;
                    }
                }else{
                    objAssessmentDetail.Career_Answer__c = objWSQ.answerId;
                }
                
                objAssessmentDetail.Question__c = objWSQ.questionId;
                objAssessmentDetail.Student__c = studentId;
                objAssessmentDetail.Other_Answer_Description__c = objWSQ.otherAnswerDescription;
                objAssessmentDetail.Question_Label__c = objWSQ.questionLabel;                		//BaseLine edit

                upsertToAssessmentDetail.add(objAssessmentDetail);
            }
        }
        
        if(upsertToAssessmentDetail.size() > 0){
            Upsert upsertToAssessmentDetail;
        }
        
        for(Assessment_Detail__c objAD : upsertToAssessmentDetail){
            if(objAD.Question__c != null && (objAD.Answer__c != null || !String.IsBlank(objAD.Multi_Answers__c) || 
                !String.IsBlank(objAD.Career_Answer__c))){
                mapAssessmentDetail.put(objAD.Question__c, objAD.Id);
            }
        }
        
        for(WrpStudentQuestion objWSQ: lstStudentQuestions){
            WrpStudentQuestion objWrpStudentQuestion = objWSQ;
            
            if(mapAssessmentDetail.containskey(objWSQ.questionId)){
                objWrpStudentQuestion.tempObjectId = mapAssessmentDetail.get(objWSQ.questionId);
            }
            objWrpStudentQuestionAnswer.lstWrpStudentQuestion.add(objWrpStudentQuestion);
        }
        
        if(actionName == 'submit'){
            objWrpStudentQuestionAnswer.isSubmitted = true;
            
            List<Assessment_Detail__c> lstAssessmentDetail = new List<Assessment_Detail__c>([
                SELECT
                    Id,
                    Question__r.Assessment__c, 
                    Student__c
                FROM Assessment_Detail__c
                WHERE Student__c = :studentId
                AND Question__r.Language__c = :language
				AND RecordTypeId = :AssessmentDetail_Baseline_RT                   //BaseLine edit	
                AND Id IN :upsertToAssessmentDetail LIMIT 1
            ]);
            
            if(lstAssessmentDetail.size() > 0){
                //Create Assessment Mark record
                createAssessmentMarks(lstAssessmentDetail[0].Question__r.Assessment__c, lstAssessmentDetail[0].Student__c, language);
                
                objWrpStudentQuestionAnswer.objAssessmentMarks = fetchAssessmentMarks(studentId, AssessmentMark_Baseline_RT);   //BaseLine
            }           
            
        }else{
            objWrpStudentQuestionAnswer.isSubmitted = false;
        }

        return objWrpStudentQuestionAnswer;
    }
    
    //TODO: we will added assessment once we give the option to select assessment
    private static Assessment_Marks__c fetchAssessmentMarks(String studentId, String strRecordTypeId){
        List<Assessment_Marks__c> lstAssessmentMarks = new List<Assessment_Marks__c>([
            SELECT
                Id,
                Student__r.Name,
                Self_Awareness_Score__c,
                Self_Awareness_Grade__c,
                Career_Awareness_Score__c,
                Career_Awareness_Grade__c,
                Parent_Support_Score__c,
                Parent_Support_Grade__c,
                Career_Planning_Score__c,
                Career_Planning_Grade__c,
                Overall_Score__c,
                Overall_Grade__c
            FROM Assessment_Marks__c 
            WHERE Student__c = :studentId
			AND RecordTypeId = :strRecordTypeId        //BaseLine edit
        ]);
        
        return lstAssessmentMarks.size() > 0 ? lstAssessmentMarks[0] : null;
    }
    
    public static void createAssessmentMarks(String assessmentId, String studentId, String language){
        Map<String, List<String>> mapAllCareerNextSteps = new Map<String, List<String>>();
        Map<String,IARP_Master__c> mapIARPMaster = new Map<String,IARP_Master__c>();
        Map<String,List<String>> mapAssessmentDetail = new Map<String,List<String>>();
        Double totalMarks = 0, section1Marks = 0, section2Marks = 0, section3Marks = 0, section4Marks = 0;
        String careerOption1 = '';
        
        Map<Id,Question_Option__c> mapAnswers = new Map<Id,Question_Option__c>([
            SELECT 
                Id,
                Actual_Answer__c,
                Marks__c,
                Question__c,
                Question__r.Marks__c,
                Is_Full_Marks__c,
                Match_To_IARP_Master__c,
                Mapping_To_IARP_Master_Field__c
            FROM Question_Option__c
            WHERE Question__r.Assessment__c = : assessmentId
            AND Question__r.Language__c = :language
        ]);
        
        if(mapAllCareerNextSteps == null || mapAllCareerNextSteps.size() == 0){
            mapAllCareerNextSteps = fnGetAspirationStep(language);
        }
        
        List<IARP_Master__c> lstIARPMaster = fetchIARPMasters();
        
        for(IARP_Master__c objIARPMaster : lstIARPMaster){
            
            mapIARPMaster.put(objIARPMaster.Name, objIARPMaster);        
        }
        
        List<Assessment_Detail__c> lstAssessmentDetail = new List<Assessment_Detail__c>([
            SELECT 
				Id, 
				Answer__c, 
				Answer__r.Actual_Answer__c,
				Answer__r.Marks__c, 
				Answer__r.Is_Full_Marks__c,
				Question__c, Multi_Answers__c, 
				Question__r.Is_Required_Answer__c,
				Question__r.Marks__c, 
				Question__r.Assessment__c, Student__c,
				Question__r.Is_Career_Question__c, 
				Career_Answer__c,
				Question__r.Is_Gender_Stereotypes__c,
				Question__r.Section__c,
				Question__r.Minimum_Actual_Answer__c,
				Question__r.Career_Option_Number__c,
				Answer__r.Match_To_IARP_Master__c,
				Question__r.Order_of_Question__c,
				Answer__r.Mapping_To_IARP_Master_Field__c,
				Assessment_Marks__c                                                                   //BaseLine edit
            FROM Assessment_Detail__c WHERE Question__r.Assessment__c = : assessmentId
            AND Question__r.Language__c = :language
            AND Student__c = :studentId
			AND RecordTypeId = :AssessmentDetail_Baseline_RT                                          //BaseLine edit
            ORDER BY Question__r.Section__c, Question__r.Order_of_Question__c
        ]);
        
        for(Assessment_Detail__c objAssessmentDetail : lstAssessmentDetail){
            
            totalMarks = 0;
            if(objAssessmentDetail.Question__r.Is_Career_Question__c){
                if(objAssessmentDetail.Question__r.Career_Option_Number__c == 1){
                    careerOption1 = objAssessmentDetail.Career_Answer__c;
                }
                if(!String.IsBlank(objAssessmentDetail.Career_Answer__c) && objAssessmentDetail.Career_Answer__c != 'I do not know/Not sure'){
                    if(objAssessmentDetail.Career_Answer__c == 'Others' || objAssessmentDetail.Career_Answer__c == 'Other'){
                        totalMarks = 1;
                        
                        if(objAssessmentDetail.Question__r.Career_Option_Number__c == 3 && careerOption1 == 'I do not know/Not sure'){
                            totalMarks = 0;
                        }
                    }else{
                            
                        if(objAssessmentDetail.Question__r.Career_Option_Number__c == 3 && !String.IsBlank(careerOption1) && 
                            careerOption1 != 'I do not know/Not sure' &&
                            mapAllCareerNextSteps.containskey(careerOption1)){

                            for(String key : mapAllCareerNextSteps.get(careerOption1)){
                                if(key == objAssessmentDetail.Career_Answer__c){
                                    totalMarks = objAssessmentDetail.Question__r.Marks__c;
                                }
                            }    
                        }else if(objAssessmentDetail.Question__r.Career_Option_Number__c != 3){
                            //for Career Option 1 and 2
                            Integer careerOptionMarks = 0;
                            Boolean isValidInterest = false, isValidAptitude = false, isValidReality = false;
                            
                            if(mapIARPMaster.containskey(objAssessmentDetail.Career_Answer__c)){
                                Boolean isInvalidAnswer = false, isCheckReality = false;
                                Integer validAnswer = 0, totalSelectedAnswer = 0;
                            
                                for(String key : mapAssessmentDetail.keyset()){                                
                                    if(key == 'Interest'){
                                        for(String IARPValue : mapAssessmentDetail.get(key)){
                                            if(mapIARPMaster.get(objAssessmentDetail.Career_Answer__c).Interest_1__c == IARPValue || 
                                                mapIARPMaster.get(objAssessmentDetail.Career_Answer__c).Interest_2__c == IARPValue ||
                                                mapIARPMaster.get(objAssessmentDetail.Career_Answer__c).Interest_3__c == IARPValue){

                                                careerOptionMarks += 1;
                                                isValidInterest = true;
                                            }
                                        }
                                        
                                    }else if(key == 'Aptitude'){
                                        for(String IARPValue : mapAssessmentDetail.get(key)){
                                            if(mapIARPMaster.get(objAssessmentDetail.Career_Answer__c).Aptitude_1__c == IARPValue || 
                                                mapIARPMaster.get(objAssessmentDetail.Career_Answer__c).Aptitude_2__c == IARPValue ||
                                                mapIARPMaster.get(objAssessmentDetail.Career_Answer__c).Aptitude_3__c == IARPValue){

                                                careerOptionMarks += 1;
                                                isValidAptitude = true;
                                            }
                                        }                                        
                                    }else{

                                        if(key == 'InValidAnswer'){
                                            for(String IARPValue : mapAssessmentDetail.get(key)){
                                                if(IARPValue == 'Full Mark'){
                                                    isInvalidAnswer = false;
                                                    isValidReality = true;
                                                    
                                                    if(isCheckReality){
                                                        isInvalidAnswer = true;
                                                        isValidReality = false;
                                                        break;
                                                    }
                                                }else{
                                                    isInvalidAnswer = true;
                                                    isValidReality = false;
                                                    break;
                                                }
                                            }
                                            if(isInvalidAnswer){
                                                break;
                                            }
                                            
                                        }else{
                                            totalSelectedAnswer ++;
                                            isCheckReality = true;
                                            
                                            if(!isInvalidAnswer && isValidReality){
                                                isValidReality = false;
                                                break;
                                            }
                                            
                                            for(String IARPValue : mapAssessmentDetail.get(key)){
                                                if(mapIARPMaster.get(objAssessmentDetail.Career_Answer__c).get(key) == 'Any'){
                                                    validAnswer++;
                                                    break;
                                                }
                                                
                                                List<String> realityActualValues = IARPValue.split('\\,');
                                                for(String realityOption : realityActualValues){
                                                    if(!String.IsBlank(String.valueof(mapIARPMaster.get(objAssessmentDetail.Career_Answer__c).get(key))) && 
                                                        String.valueof(mapIARPMaster.get(objAssessmentDetail.Career_Answer__c).get(key)).contains(realityOption)){
                                                        validAnswer++;
                                                        break;
                                                    }
                                                }
                                            }
                                        }   
                                    }
                                }

                                if(isInvalidAnswer){
                                    careerOptionMarks += 0;
                                    isValidReality = false;
                                }
                                
                                if(!isInvalidAnswer && totalSelectedAnswer == validAnswer){
                                    careerOptionMarks += 1;
                                    isValidReality = true;
                                }else{
                                    isValidReality = false;
                                }
                                
                            }
                            
                            if(isValidInterest && isValidAptitude && isValidReality){
                                totalMarks = careerOptionMarks;
                            }
                            
                        }
                    }
                }
                
            }else if(objAssessmentDetail.Question__r.Is_Gender_Stereotypes__c){
                List<Id> answerIds = new List<Id>();
                if(objAssessmentDetail.Answer__c == null && objAssessmentDetail.Multi_Answers__c != null){
                    answerIds = objAssessmentDetail.Multi_Answers__c.split('\\,');
                }else if(objAssessmentDetail.Answer__c != null){
                    answerIds.add(objAssessmentDetail.Answer__c); 
                }
                
                Double multiAnswerMarks = 0;
                Integer count = 0;
                Boolean isFullMarks = false;
                for(Id answerId : answerIds){
                    if(mapAnswers.containskey(answerId)){
                        if(mapAnswers.get(answerId).Actual_Answer__c){
                            if(mapAnswers.get(answerId).Is_Full_Marks__c){
                                isFullMarks = true;
                            }else{
                                count++;
                            }
                            multiAnswerMarks = mapAnswers.get(answerId).Question__r.Marks__c;
                        }else{
                            isFullMarks = false;
                            multiAnswerMarks = 0;
                            break;
                        }                            
                    }
                }
                
                if(count == objAssessmentDetail.Question__r.Minimum_Actual_Answer__c){
                    totalMarks = multiAnswerMarks;
                }else if(isFullMarks){
                    totalMarks = multiAnswerMarks;
                }              

            }else if(!objAssessmentDetail.Question__r.Is_Career_Question__c && !objAssessmentDetail.Question__r.Is_Gender_Stereotypes__c){
                if(objAssessmentDetail.Answer__c != null && objAssessmentDetail.Answer__r.Actual_Answer__c){
                    if(objAssessmentDetail.Answer__r.Marks__c != 0){
                        totalMarks = objAssessmentDetail.Answer__r.Marks__c;
                    }else{
                        totalMarks = objAssessmentDetail.Question__r.Marks__c;
                    }
                }else if(objAssessmentDetail.Answer__c == null && objAssessmentDetail.Multi_Answers__c != null){
                    List<Id> answerIds = objAssessmentDetail.Multi_Answers__c.split('\\,');
                    
                    Double multiAnswerMarks = 0;
                    for(Id answerId : answerIds){
                        if(mapAnswers.containskey(answerId)){
                            if(mapAnswers.get(answerId).Actual_Answer__c){
                                if(mapAnswers.get(answerId).Marks__c != 0){
                                    multiAnswerMarks += mapAnswers.get(answerId).Marks__c;
                                }else{
                                    multiAnswerMarks = mapAnswers.get(answerId).Question__r.Marks__c;
                                }
                            }else{
                                if(objAssessmentDetail.Question__r.Is_Required_Answer__c){
                                    continue;
                                }else{
                                    multiAnswerMarks = 0;
                                    break;
                                }                                
                            }
                        }
                    }
                    
                    totalMarks = multiAnswerMarks;
                }
                if(objAssessmentDetail.Question__r.Section__c == 1 && objAssessmentDetail.Question__r.Order_of_Question__c == 5){
                    if(objAssessmentDetail.Answer__c != null && !objAssessmentDetail.Answer__r.Actual_Answer__c && objAssessmentDetail.Answer__c != null && objAssessmentDetail.Answer__r.Is_Full_Marks__c){
                        if(objAssessmentDetail.Answer__r.Marks__c != 0){
                            totalMarks = objAssessmentDetail.Answer__r.Marks__c;
                        }else{
                            totalMarks = objAssessmentDetail.Question__r.Marks__c;
                        }
                    }
                }
            }
            
            if(objAssessmentDetail.Question__r.Section__c == 1){
                if(objAssessmentDetail.Question__r.Order_of_Question__c == 1){
                    
                    if(!mapAssessmentDetail.containskey('Interest')){
                        mapAssessmentDetail.put('Interest',new List<string>());
                    }
                    mapAssessmentDetail.get('Interest').add(objAssessmentDetail.Answer__r.Match_To_IARP_Master__c);
                }else if(objAssessmentDetail.Question__r.Order_of_Question__c == 3){
                    
                    if(!mapAssessmentDetail.containskey('Aptitude')){
                        mapAssessmentDetail.put('Aptitude',new List<string>());
                    }
                    mapAssessmentDetail.get('Aptitude').add(objAssessmentDetail.Answer__r.Match_To_IARP_Master__c);
                }else if(objAssessmentDetail.Question__r.Order_of_Question__c == 5){
                    
                    if(objAssessmentDetail.Answer__c != null){
                        if(objAssessmentDetail.Answer__r.Actual_Answer__c){
                            if(!mapAssessmentDetail.containskey(objAssessmentDetail.Answer__r.Mapping_To_IARP_Master_Field__c)){
                                mapAssessmentDetail.put(objAssessmentDetail.Answer__r.Mapping_To_IARP_Master_Field__c,new List<string>());
                            }
                            mapAssessmentDetail.get(objAssessmentDetail.Answer__r.Mapping_To_IARP_Master_Field__c).add(objAssessmentDetail.Answer__r.Match_To_IARP_Master__c);
                        }else{
                            if(objAssessmentDetail.Answer__r.Is_Full_Marks__c){
                                mapAssessmentDetail.put('InValidAnswer',new List<String>{'Full Mark'});
                            }else{
                                mapAssessmentDetail.put('InValidAnswer',new List<String>{'No Mark'});
                            }
                        }
                    }else if(objAssessmentDetail.Answer__c == null && !String.IsBlank(objAssessmentDetail.Multi_Answers__c)){
                        List<Id> answerIds = objAssessmentDetail.Multi_Answers__c.split('\\,');
                        
                        for(Id answerId : answerIds){
                            if(mapAnswers.containskey(answerId)){
                                if(mapAnswers.get(answerId).Actual_Answer__c){
                                    if(!mapAssessmentDetail.containskey(mapAnswers.get(answerId).Mapping_To_IARP_Master_Field__c)){
                                        mapAssessmentDetail.put(mapAnswers.get(answerId).Mapping_To_IARP_Master_Field__c, new List<string>());
                                    }
                                    mapAssessmentDetail.get(mapAnswers.get(answerId).Mapping_To_IARP_Master_Field__c).add(mapAnswers.get(answerId).Match_To_IARP_Master__c);
                                }else{
                                    if(mapAnswers.get(answerId).Is_Full_Marks__c){
                                        if(!mapAssessmentDetail.containskey('InValidAnswer')){
                                            mapAssessmentDetail.put('InValidAnswer',new List<String>());
                                        }
                                        mapAssessmentDetail.get('InValidAnswer').add('Full Mark');
                                    }else{
                                        if(!mapAssessmentDetail.containskey('InValidAnswer')){
                                            mapAssessmentDetail.put('InValidAnswer',new List<String>());
                                        }
                                        mapAssessmentDetail.get('InValidAnswer').add('No Mark');
                                    }
                                }
                            }
                        }
                    }
                }
                
                section1Marks += totalMarks;
            }else if(objAssessmentDetail.Question__r.Section__c == 2){
                section2Marks += totalMarks;
            }else if(objAssessmentDetail.Question__r.Section__c == 3){
                section3Marks += totalMarks;
            }else if(objAssessmentDetail.Question__r.Section__c == 4){
                section4Marks += totalMarks;
            }
            
        }
        
        //TODO: remove upsert assessment and allow only once insert if they will finish testing
        Assessment_Marks__c objAssessmentMarks = new Assessment_Marks__c(RecordTypeId = AssessmentMark_Baseline_RT);     //BaseLine edit
        
        Assessment_Marks__c assessmentMarks = fetchAssessmentMarks(studentId, AssessmentMark_Baseline_RT);               //BaseLine edit
        
        if(assessmentMarks != null){
            objAssessmentMarks = assessmentMarks;
        }
        
        objAssessmentMarks.Assessment__c = assessmentId;
        objAssessmentMarks.Student__c = studentId;
        objAssessmentMarks.Self_Awareness_Marks__c = section1Marks;
        objAssessmentMarks.Career_Awareness_Marks__c = section2Marks;
        objAssessmentMarks.Parent_Support_Marks__c = section3Marks;
        objAssessmentMarks.Career_Planning_Marks__c = section4Marks;
        objAssessmentMarks.Total_Marks__c = section1Marks + section2Marks + section3Marks + section4Marks;
                                             
        Upsert objAssessmentMarks;
        
        //BaseLine edit
        if(assessmentMarks == null || assessmentMarks.Id == null)
        {
            List<Assessment_Detail__c> UpdateToAssessmentDetail = new List<Assessment_Detail__c>();
            for(Assessment_Detail__c objAssessmentDetail : lstAssessmentDetail)
            {
                objAssessmentDetail.Assessment_Marks__c = objAssessmentMarks.Id;
                UpdateToAssessmentDetail.add(objAssessmentDetail);
            }
            
            if(!UpdateToAssessmentDetail.isEmpty())
            {
                Update UpdateToAssessmentDetail; 
            }
        }
    }

    private static Map<String, String> fnGetCareerAspiration(String language){
        Map<String, String> mapCareerAspirations = new Map<String, String>();        
        List<IARP_Master__c> lstIARPMaster = fetchIARPMasters();
        
        for(IARP_Master__c objIARPMaster : lstIARPMaster){
            if(language == 'eng'){
                mapCareerAspirations.put(objIARPMaster.Name, objIARPMaster.Label_for_the_Assessment_form__c);
            }else if(language == 'hin'){
                mapCareerAspirations.put(objIARPMaster.Name, objIARPMaster.Hindi_Label_for_the_Assessment_form__c);
            }else if(language == 'mar'){
                mapCareerAspirations.put(objIARPMaster.Name, objIARPMaster.Marathi_Label_for_the_Assessment_form__c);
            }else if(language == 'urd'){
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
    
    private static Map<String,List<String>> fnGetAspirationStep(String language){
        Map<String,List<String>> mapAspirationNextStep = new Map<String,List<String>>();
        List<CareerAware_Next_Step_Mapping__c> lstNextSteps = CareerAware_Next_Step_Mapping__c.getall().values();
        
        for(CareerAware_Next_Step_Mapping__c objNextStep : lstNextSteps){
            if(!mapAspirationNextStep.containskey(objNextStep.Aspiration__c)){
                mapAspirationNextStep.put(objNextStep.Aspiration__c, new List<String>());
            }
            if(objNextStep.Aspiration__c == 'Other'){
                if(objNextStep.Step_1__c != 'Other' && objNextStep.Step_1__c != 'I do not know'){
                    fillMapAspirationNextStep(mapAspirationNextStep,objNextStep,language);
                }
            }else{
                fillMapAspirationNextStep(mapAspirationNextStep,objNextStep,language);
            }
            
        }
        
        return mapAspirationNextStep;
    }
    
    private static void fillMapAspirationNextStep(Map<String,List<String>> mapAspirationNextStep, CareerAware_Next_Step_Mapping__c objNextStep, String language){
        if(language == 'eng'){
            mapAspirationNextStep.get(objNextStep.Aspiration__c).add(objNextStep.Step_1__c);
        }else if(language == 'hin'){
            mapAspirationNextStep.get(objNextStep.Aspiration__c).add(objNextStep.Hindi_Step_1__c);
        }else if(language == 'mar'){
            mapAspirationNextStep.get(objNextStep.Aspiration__c).add(objNextStep.Marathi_Step_1__c);
        }else if(language == 'urd'){
            mapAspirationNextStep.get(objNextStep.Aspiration__c).add(objNextStep.Urdu_Step_1__c);
        }
        
    }
    
    public class wrpStudentData{
        @AuraEnabled
        public Id studentId {get;set;}
        
        @AuraEnabled
        public string studentName {get;set;}
        
        @AuraEnabled
        public string studentContactNumber {get;set;}
        
        @AuraEnabled
        public date studentDOB {get;set;}
        
        @AuraEnabled
        public string schoolName {get;set;}
        
        @AuraEnabled
        public string state {get;set;}
        
        @AuraEnabled
        public string city {get;set;}
        
        @AuraEnabled
        public string whatsappNumber {get;set;} 
        
        @AuraEnabled
        public string gender {get;set;}
        
        @AuraEnabled
        public string fatherEducation {get;set;}
            
        @AuraEnabled
        public string motherEducation {get;set;}
        
        @AuraEnabled
        public string householdIncome {get;set;}
        
        @AuraEnabled
        public string studentCast {get;set;}
        
        public wrpStudentData(){
            studentId = null;
            studentName = '';
            studentContactNumber = '';
            studentDOB = null;
            schoolName = '';
            state = '';
            city = '';
            whatsappNumber = '';
            gender = '';
            fatherEducation = '';
            motherEducation= '';
            householdIncome = '';
            studentCast = '';            
        }
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
        
        public WrpStudentAnswer(){
            answerId = '';
            isdisabled = false;
            answerValue = '';
            orderOfAnswer = 0;
            dependentquestion = null;
            isShowOtherOption = false;
        }
    }
}