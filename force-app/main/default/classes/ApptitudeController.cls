/*Change History
version   Date   	Description
V1.0      14/12/23  To exclude duplicate record from form submission 

*/ 
public without sharing class ApptitudeController {
    @AuraEnabled
    public static string getApptitudeRecord(String studentId, string grade, String batchId) {
        List<Batch__c> batches = [
            SELECT Id, Name, School_Name__r.Name, Grade__c, Academic_Year__c, Batch_Number__c
            FROM Batch__c
            WHERE Id = :batchId LIMIT 1];
        String studentBarcode = '';
                List<Contact> studentContact = new List<Contact>([
                    SELECT Id, Name, Bar_Code__c, 
                    Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Grade_12_Barcode__c, 
                    Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c, G12_Batch_Code__c
                    FROM Contact 
                    WHERE Id = :studentId
                    LIMIT 1
                ]);
                if(grade == 'Grade 9')
                {
                    studentBarcode = studentContact[0].Grade_9_Barcode__c;
                }
                else if(grade == 'Grade 10')
                {
                    studentBarcode = studentContact[0].Grade_10_Barcode__c;
                }
                else if(grade == 'Grade 11')
                {
                    studentBarcode = studentContact[0].Grade_11_Barcode__c;
                }
                else if(grade == 'Grade 12')
                {
                    studentBarcode = studentContact[0].Grade_12_Barcode__c;
                }	
            list<Self_Awareness_and_Feedback__c> assesRec = [SELECT Created_from_Form__c, Barcode__c, Form_Submitted__c 
                            FROM Self_Awareness_and_Feedback__c 
                            WHERE Created_from_Form__c = true AND 
                            RecordType.Name='Baseline'  AND  
                            Barcode__c = : studentBarcode AND 
                            Grade__c = :grade AND
                            Student__c = : studentId AND 
                            Academic_Year__c = : batches[0].Academic_Year__c AND
                            Apptitude_Form_Submitted__c = true];
            if(assesRec.size() > 0) return 'found'; 
            else return 'notfound';
        
    }
    @AuraEnabled
    public static string saveDataForFormV2(String studentId, List<Map<String, Object>> answerSet,boolean saveFlag, string grade, string typ, 
                                           string lng, string batchId){
        List<QuestionAnswer> dataMap = new List<QuestionAnswer>();
        String studentBarcode = '';
                List<Contact> studentContact = new List<Contact>([
                    SELECT Id, Name, Bar_Code__c, 
                    Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Grade_12_Barcode__c, 
                    Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c, G12_Batch_Code__c
                    FROM Contact 
                    WHERE Id = :studentId
                    LIMIT 1
                ]);
                if(grade == 'Grade 9')
                {
                    studentBarcode = studentContact[0].Grade_9_Barcode__c;
                }
                else if(grade == 'Grade 10')
                {
                    studentBarcode = studentContact[0].Grade_10_Barcode__c;
                }
                else if(grade == 'Grade 11')
                {
                    studentBarcode = studentContact[0].Grade_11_Barcode__c;
                }
                else if(grade == 'Grade 12')
                {
                    studentBarcode = studentContact[0].Grade_12_Barcode__c;
                }

        List<Batch__c> batches = new List<Batch__c>([
            SELECT Id, Name, School_Name__r.Name, Grade__c, Academic_Year__c, Batch_Number__c
            FROM Batch__c
            WHERE Id = :batchId LIMIT 1]);
        for (Map<String, Object> qa : answerSet) {
            Decimal question = (Decimal)qa.get('question');
            String answer = (String)qa.get('answer');
    
            QuestionAnswer qaObj = new QuestionAnswer();
            qaObj.question = question;
            qaObj.answer = answer;
    
            dataMap.add(qaObj);
        }
        String returnStr = '';
        List<Self_Awareness_and_Feedback__c> sf =  new List<Self_Awareness_and_Feedback__c>([select id,Created_from_Form__c, Aptitude_1__c, 
                                                           Aptitude_2__c, Aptitude_3__c, Student__c, Student__r.name,
                                                           Spatial_Ability_Q_1__c,Spatial_Ability_Q_2__c,Spatial_Ability_Q_3__c,
                                                           Spatial_Ability_Q_4__c,Spatial_Ability_Q_5__c,Spatial_Ability_Q_6__c,
                                                           Spatial_Ability_Q_7__c,Spatial_Ability_Q_8__c,Numerical_1__c,Numerical_2__c,
                                                           Numerical_3__c,Numerical_4__c,Numerical_5__c,Numerical_6__c,Numerical_7__c,Aptitude_1_Selected_By_Student__c, Aptitude_2_Selected_By_Student__c, Aptitude_3_Selected_By_Student__c,
                                                           Numerical_8__c,Mechanical_1__c,Mechanical_2__c,Mechanical_3__c,Mechanical_4__c,Mechanical_5__c,Mechanical_6__c,Mechanical_7__c,Mechanical_8__c,Abstract_Reasoning_Q_1__c,Abstract_Reasoning_Q_2__c,Abstract_Reasoning_Q_3__c,Abstract_Reasoning_Q_4__c,Abstract_Reasoning_Q_5__c,Abstract_Reasoning_Q_6__c,Abstract_Reasoning_Q_7__c,Abstract_Reasoning_Q_8__c,Verbal_1__c,Verbal_2__c,Verbal_3__c,Verbal_4__c,Verbal_5__c,Verbal_6__c,Verbal_7__c,Verbal_8__c,Creative_1__c,Creative_2__c,Creative_3__c,Creative_4__c,Creative_5__c,Creative_6__c,Creative_7__c,Creative_8__c 
                                                           from  Self_Awareness_and_Feedback__c
                                                           where Student__c =: studentId and Created_from_Form__c = true 
                                                           AND Academic_Year__c = :batches[0].Academic_Year__c
                                                            AND Grade__c = :batches[0].Grade__c 
                                                            AND Barcode__c  = :studentBarcode 
                                                           and RecordType.Name='Baseline' and Error_Status__c = 'No Error' limit 1]); //V1.0
    	if(!sf.isEmpty()){
            returnStr = 'Update';
            system.debug('saveFlag ='+saveFlag);
            system.debug('sf[0] = '+sf[0]);
            dataPrepareForV2(saveFlag,sf[0],dataMap);
        }else{
            returnStr = 'Insert';
            contact con = [select id,Bar_Code__c,Batch_Code__c,G10_Batch_Code__c,G11_Batch_Code__c,G12_Batch_Code__c,Grade_9_Barcode__c,Grade_10_Barcode__c,Grade_11_Barcode__c,Grade_12_Barcode__c from contact where id=:studentId];
            string barcode = '';
            if(grade == 'Grade 9')barcode=con.Grade_9_Barcode__c;
            if(grade == 'Grade 10')barcode=con.Grade_10_Barcode__c;
            if(grade == 'Grade 11')barcode=con.Grade_11_Barcode__c;
            if(grade == 'Grade 12')barcode=con.Grade_12_Barcode__c;
            RecordType rt = [select id, name, SobjectType from RecordType where SobjectType = 'Self_Awareness_and_Feedback__c' and name = 'Baseline'];
            Self_Awareness_and_Feedback__c sf1 = new Self_Awareness_and_Feedback__c(Created_from_Form__c = true, Student__c = studentId, Barcode__c = barcode, RecordTypeId = rt.id,Form_Language__c=lng,Form_Name__c=typ);
            system.debug('sf1 = '+sf1);
            dataPrepareForV2(saveFlag,sf1,dataMap);
        }
        return returnStr;
    }
    @AuraEnabled
    public static void dataPrepareForV2(boolean saveFlag,Self_Awareness_and_Feedback__c sf,List<QuestionAnswer> dataMap){
        try{
             /*for (String key : dataMap.keySet()) {
                 string fieldName = 'Interest_Test_'+key+'__c';
                 string value = String.valueOf(answerMap.get(key));
             }*/
            system.debug('dataMap = '+dataMap);
            List<String> customFieldNames = new List<String>{'Spatial_Ability_Q_1__c', 'Spatial_Ability_Q_2__c', 'Spatial_Ability_Q_3__c', 'Spatial_Ability_Q_4__c', 'Spatial_Ability_Q_5__c', 'Spatial_Ability_Q_6__c', 'Spatial_Ability_Q_7__c', 'Spatial_Ability_Q_8__c', 'Numerical_1__c', 'Numerical_2__c', 'Numerical_3__c', 'Numerical_4__c', 'Numerical_5__c', 'Numerical_6__c', 'Numerical_7__c', 'Numerical_8__c', 'Mechanical_1__c', 'Mechanical_2__c', 'Mechanical_3__c', 'Mechanical_4__c', 'Mechanical_5__c', 'Mechanical_6__c', 'Mechanical_7__c', 'Mechanical_8__c', 'Abstract_Reasoning_Q_1__c', 'Abstract_Reasoning_Q_2__c', 'Abstract_Reasoning_Q_3__c', 'Abstract_Reasoning_Q_4__c', 'Abstract_Reasoning_Q_5__c', 'Abstract_Reasoning_Q_6__c', 'Abstract_Reasoning_Q_7__c', 'Abstract_Reasoning_Q_8__c', 'Verbal_1__c', 'Verbal_2__c', 'Verbal_3__c', 'Verbal_4__c', 'Verbal_5__c', 'Verbal_6__c', 'Verbal_7__c', 'Verbal_8__c', 'Creative_1__c', 'Creative_2__c', 'Creative_3__c', 'Creative_4__c', 'Creative_5__c', 'Creative_6__c', 'Creative_7__c', 'Creative_8__c'};
            integer i = 0;
            for (QuestionAnswer qa : dataMap) {
                 string fieldName = customFieldNames[i];
                 string value = String.valueOf(qa.answer);
                 sf.put(fieldName,value);
                i++;
            }
            if(saveFlag){
                sf.Apptitude_Form_Submitted__c = true;
                List<Question_Bank__c> correctAns = new List<Question_Bank__c>();
                List<String> ans = new List<String>();
                List<String> highestApti = new List<String>();
                map<string, List<Question_Bank__c>> mapAllQBCategoryWise = Utility.getAllCategorywiseQuestions();
                system.debug('mapAllQBCategoryWise = '+mapAllQBCategoryWise);
                Boolean anySpatialAbilitySeleced = False;
                if(String.isNotBlank(sf.Spatial_Ability_Q_1__c) || String.isNotBlank(sf.Spatial_Ability_Q_2__c) || 
                   String.isNotBlank(sf.Spatial_Ability_Q_3__c) || String.isNotBlank(sf.Spatial_Ability_Q_4__c) || 
                   String.isNotBlank(sf.Spatial_Ability_Q_5__c) || String.isNotBlank(sf.Spatial_Ability_Q_6__c) || 
                   String.isNotBlank(sf.Spatial_Ability_Q_7__c) || String.isNotBlank(sf.Spatial_Ability_Q_8__c)){
                       anySpatialAbilitySeleced = true;
                   }
                Map<String, Integer> aptitute = new Map<String, Integer>();
                correctAns = mapAllQBCategoryWise.containskey('Spatial') ? mapAllQBCategoryWise.get('Spatial') : new List<Question_Bank__c>();
                ans.add(sf.Spatial_Ability_Q_1__c);
                ans.add(sf.Spatial_Ability_Q_2__c);
                ans.add(sf.Spatial_Ability_Q_3__c);
                ans.add(sf.Spatial_Ability_Q_4__c);
                ans.add(sf.Spatial_Ability_Q_5__c);
                ans.add(sf.Spatial_Ability_Q_6__c);
                ans.add(sf.Spatial_Ability_Q_7__c);
                ans.add(sf.Spatial_Ability_Q_8__c);
                Integer count = 0;
                for (Integer j = 0; j < ans.size(); j++) {
                    if (ans.get(j)!=null && ans.get(j)!='') {
                        if (correctAns.get(j).Category__c == ans.get(j)) {
                            count++; }
                    }
                }
                if(count > 0)
                    aptitute.put('Spatial', count);
                
                correctAns = new List<Question_Bank__c>();
                ans.clear();
                Boolean anyNumericalSeleced = False;
                if(String.isNotBlank(sf.Numerical_1__c) || String.isNotBlank(sf.Numerical_2__c) || 
                   String.isNotBlank(sf.Numerical_3__c) || String.isNotBlank(sf.Numerical_4__c) || 
                   String.isNotBlank(sf.Numerical_5__c) || String.isNotBlank(sf.Numerical_6__c) || 
                   String.isNotBlank(sf.Numerical_7__c) || String.isNotBlank(sf.Numerical_8__c)){
                       anyNumericalSeleced = true;
                   }
                correctAns = mapAllQBCategoryWise.containskey('Numerical') ? mapAllQBCategoryWise.get('Numerical') : new List<Question_Bank__c>();
                ans.add(sf.Numerical_1__c);
                ans.add(sf.Numerical_2__c);
                ans.add(sf.Numerical_3__c);
                ans.add(sf.Numerical_4__c);
                ans.add(sf.Numerical_5__c);
                ans.add(sf.Numerical_6__c);
                ans.add(sf.Numerical_7__c);
                ans.add(sf.Numerical_8__c);
                count = 0;
                
                for (Integer j = 0; j < ans.size(); j++) {
                    if (ans.get(j)!=null && ans.get(j)!=''){
                        if (correctAns.get(j).Category__c == ans.get(j)) {
                            count++;
                        }
                    }
                }
                if(count > 0)
                    aptitute.put('Numerical', count);
                
                correctAns = new List<Question_Bank__c>();
                ans.clear();
                
                
                Boolean anyAbstractSeleced = False;
                if(String.isNotBlank(sf.Abstract_Reasoning_Q_1__c) || String.isNotBlank(sf.Abstract_Reasoning_Q_2__c) || 
                   String.isNotBlank(sf.Abstract_Reasoning_Q_3__c) || String.isNotBlank(sf.Abstract_Reasoning_Q_4__c) || 
                   String.isNotBlank(sf.Abstract_Reasoning_Q_5__c) || String.isNotBlank(sf.Abstract_Reasoning_Q_6__c) || 
                   String.isNotBlank(sf.Abstract_Reasoning_Q_7__c) || String.isNotBlank(sf.Abstract_Reasoning_Q_8__c)){
                       anyAbstractSeleced = true;
                   }
                correctAns = mapAllQBCategoryWise.containskey('Abstract') ? mapAllQBCategoryWise.get('Abstract') : new List<Question_Bank__c>();
                ans.add(sf.Abstract_Reasoning_Q_1__c);
                ans.add(sf.Abstract_Reasoning_Q_2__c);
                ans.add(sf.Abstract_Reasoning_Q_3__c);
                ans.add(sf.Abstract_Reasoning_Q_4__c);
                ans.add(sf.Abstract_Reasoning_Q_5__c);
                ans.add(sf.Abstract_Reasoning_Q_6__c);
                ans.add(sf.Abstract_Reasoning_Q_7__c);
                ans.add(sf.Abstract_Reasoning_Q_8__c);
                count = 0;
                for (Integer j = 0; j < ans.size(); j++) {
                    if (ans.get(j)!=null && ans.get(j)!=''){
                        if (correctAns.get(j).Category__c == ans.get(j)) {
                            count++;
                        }
                    }
                }
                if(count > 0)
                    aptitute.put('Abstract', count);
                
                correctAns = new List<Question_Bank__c>();
                ans.clear();
                
                Boolean anyCreativeSeleced = False;
                if(String.isNotBlank(sf.Creative_1__c) || String.isNotBlank(sf.Creative_2__c) || 
                   String.isNotBlank(sf.Creative_3__c) || String.isNotBlank(sf.Creative_4__c) || 
                   String.isNotBlank(sf.Creative_5__c) || String.isNotBlank(sf.Creative_6__c) || 
                   String.isNotBlank(sf.Creative_7__c) || String.isNotBlank(sf.Creative_8__c)){
                       anyCreativeSeleced = true;
                   }
                correctAns = mapAllQBCategoryWise.containskey('Creative') ? mapAllQBCategoryWise.get('Creative') : new List<Question_Bank__c>();
                ans.add(sf.Creative_1__c);
                ans.add(sf.Creative_2__c);
                ans.add(sf.Creative_3__c);
                ans.add(sf.Creative_4__c);
                ans.add(sf.Creative_5__c);
                ans.add(sf.Creative_6__c);
                ans.add(sf.Creative_7__c);
                ans.add(sf.Creative_8__c);
                count = 0;
                for (Integer j = 0; j < ans.size(); j++) {
                    if (ans.get(j)!=null && ans.get(j)!=''){
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
                
                Boolean anyMechanicalSeleced = False;
                if(String.isNotBlank(sf.Mechanical_1__c) || String.isNotBlank(sf.Mechanical_2__c) || 
                   String.isNotBlank(sf.Mechanical_3__c) || String.isNotBlank(sf.Mechanical_4__c) || 
                   String.isNotBlank(sf.Mechanical_5__c) || String.isNotBlank(sf.Mechanical_6__c) || 
                   String.isNotBlank(sf.Mechanical_7__c) || String.isNotBlank(sf.Mechanical_8__c)){
                       anyMechanicalSeleced = true;
                   }
                correctAns = mapAllQBCategoryWise.containskey('Mechanical') ? mapAllQBCategoryWise.get('Mechanical') : new List<Question_Bank__c>();
                ans.add(sf.Mechanical_1__c);
                ans.add(sf.Mechanical_2__c);
                ans.add(sf.Mechanical_3__c);
                ans.add(sf.Mechanical_4__c);
                ans.add(sf.Mechanical_5__c);
                ans.add(sf.Mechanical_6__c);
                ans.add(sf.Mechanical_7__c);
                ans.add(sf.Mechanical_8__c);
                count = 0;
                for (Integer j = 0; j < ans.size(); j++) {
                    if (ans.get(j)!=null && ans.get(j)!=''){
                        if (correctAns.get(j).Category__c == ans.get(j)) {
                            count++;
                        }
                    }
                }
                if(count > 0)
                    aptitute.put('Mechanical', count);
                
                correctAns = new List<Question_Bank__c>();
                ans.clear();
                
                Boolean anyVerbalSeleced = False;
                if(String.isNotBlank(sf.Verbal_1__c) || String.isNotBlank(sf.Verbal_2__c) || 
                   String.isNotBlank(sf.Verbal_3__c) || String.isNotBlank(sf.Verbal_4__c) || 
                   String.isNotBlank(sf.Verbal_5__c) || String.isNotBlank(sf.Verbal_6__c) || 
                   String.isNotBlank(sf.Verbal_7__c) || String.isNotBlank(sf.Verbal_8__c)){
                       anyVerbalSeleced = true;
                   }
                correctAns = mapAllQBCategoryWise.containskey('Verbal') ? mapAllQBCategoryWise.get('Verbal') : new List<Question_Bank__c>();
                ans.add(sf.Verbal_1__c);
                ans.add(sf.Verbal_2__c);
                ans.add(sf.Verbal_3__c);
                ans.add(sf.Verbal_4__c);
                ans.add(sf.Verbal_5__c);
                ans.add(sf.Verbal_6__c);
                ans.add(sf.Verbal_7__c);
                ans.add(sf.Verbal_8__c);
                count = 0;
                for (Integer j = 0; j < ans.size(); j++) {
                    if (ans.get(j)!=null && ans.get(j)!=''){
                        if (correctAns.get(j).Category__c == ans.get(j)) {
                            count++;
                        }
                    }
                }
                if(count > 0)
                    aptitute.put('Verbal', count);
                system.debug('aptitute = '+aptitute);
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
                system.debug('aptitudeList = '+aptitudeList);
                system.debug('mapCountWiseAptitude = '+mapCountWiseAptitude);
                aptitudeList.sort();
                system.debug('aptitudeList = '+aptitudeList);
                integer cntRes2 = 0;
                Map<String, Integer> resultInt2 = new Map<String, Integer>();
                for(Integer j = aptitudeList.size()-1; j>=0;j--){
                    if(cntRes2 < 3){
                        if(mapCountWiseAptitude.get(aptitudeList[j]).size() > 1){
                            for(integer k = 0 ; mapCountWiseAptitude.get(aptitudeList[j]).size() > k ; k++){
                                resultInt2.put(mapCountWiseAptitude.get(aptitudeList[j])[k],aptitudeList[j]);
                                cntRes2++;
                            }
                        } else {
                            resultInt2.put(mapCountWiseAptitude.get(aptitudeList[j])[0],aptitudeList[j]);
                            cntRes2++;
                        }
                    } else {
                        break;
                    }
                }
                system.debug('resultInt2 = '+resultInt2);
                for(Integer m = aptitudeList.size()-1; m >= 0; m--){
                    if(mapCountWiseAptitude.containskey(aptitudeList[m])){
                        List<string> lstAptitude = mapCountWiseAptitude.get(aptitudeList[m]);
                        if(lstAptitude.size() > 1){
                            boolean isFound = false;
                            for(string apti: lstAptitude){
                                if(apti == sf.Aptitude_1_Selected_By_Student__c || apti == sf.Aptitude_2_Selected_By_Student__c  ||
                                   apti == sf.Aptitude_3_Selected_By_Student__c){
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
                system.debug('highestApti = '+highestApti);
                if(highestApti.size() < 3){
                    for(Integer key: mapCountWiseAptitude.keyset()){
                        for(string apti: mapCountWiseAptitude.get(key)){
                            if(!highestApti.contains(apti)){
                                highestApti.add(apti);
                            }
                        }
                    }
                }
                sf.Aptitude_1__c= '';
                sf.Aptitude_2__c= '';
                sf.Aptitude_3__c= '';
                if(anySpatialAbilitySeleced && anyNumericalSeleced && anyAbstractSeleced && 
                   anyCreativeSeleced && anyMechanicalSeleced && anyVerbalSeleced){
                       Integer cnt2 = 1;
                       for(String str : resultInt2.keyset()){
                           if(cnt2 == 1){
                               sf.Aptitude_1__c= str;
                               cnt2++;
                           } else if(cnt2 == 2){
                               sf.Aptitude_2__c= str;
                               cnt2++;
                           } else if(cnt2 == 3){
                               sf.Aptitude_3__c= str;
                               cnt2++;
                           }
                       }
                   }
                
            }
            system.debug('sf = '+sf);
            upsert sf;   
        }catch(exception e){
            System.debug('InterestDetailsHandler.dataPrepare, e.getMessage() : ' + e.getMessage());
            System.debug('InterestDetailsHandler.dataPrepare, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        
    }

    public class responseWrapper{
        @AuraEnabled 
        public List<Contact> gradeStudentList {get;set;}
        
        @AuraEnabled 
        public Map<String,Contact> submittedStudentMap {get;set;}
        
        @AuraEnabled 
        public Integer batchTotalStudents {get;set;}
        
        public responseWrapper(){
            gradeStudentList = new List<Contact>();
            submittedStudentMap = new Map<String,Contact>();
            batchTotalStudents = 0;
        }
    }

    @AuraEnabled
    public static responseWrapper searchStudentRecords(String searchText, String batchId, String grade){ 
        try{
            responseWrapper rsp = new responseWrapper();
            do{
                String search = '%'+searchText+'%';
                List<Contact> studentList = new List<Contact>([
                    SELECT Id, Name, Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c,
                    (select id,Created_from_Form__c, Aptitude_1__c, Aptitude_2__c, Aptitude_3__c,Apptitude_Form_Submitted__c,Form_Submitted__c  from  Self_Awareness_and_Feedbacks__r where Created_from_Form__c=true AND RecordType.Name='Baseline' AND Apptitude_Form_Submitted__c=true) 
                    FROM Contact 
                    WHERE (Batch_Code__c = :batchId OR 
                           G10_Batch_Code__c = :batchId OR
                           G11_Batch_Code__c = :batchId OR G12_Batch_Code__c = :batchId) 
                    AND Name LIKE :search
                ]);
                
                if(studentList.isEmpty())break;
                
                Integer batchGradeStudents = 0;
                List<Contact> gradeStudentList = new List<Contact>();
                for(Contact con : studentList)
                {
                    //=========================================================//
                    if(grade == 'Grade 11' && con.G11_Batch_Code__c != null)
                    {
                        batchGradeStudents++;
                        gradeStudentList.add(con);                     
                    }
                    else if(grade == 'Grade 10' && con.G10_Batch_Code__c != null)
                    {
                        batchGradeStudents++;
                        gradeStudentList.add(con); 
                    }
                    else if(grade == 'Grade 9' && con.Batch_Code__c != null)
                    {
                        batchGradeStudents++;
                        gradeStudentList.add(con);
                    }else if(grade == 'Grade 12' && con.G12_Batch_Code__c != null){
                        batchGradeStudents++;
                        gradeStudentList.add(con);
                    }
                    //=========================================================//
                }
                
                if(gradeStudentList.isEmpty())break;
                rsp.batchTotalStudents = batchGradeStudents;
                rsp.gradeStudentList = gradeStudentList;
                
                Map<String,Contact> submittedStudentMap = new Map<String,Contact>();  
                for(Contact con : gradeStudentList)
                {
                    if(!con.Self_Awareness_and_Feedbacks__r.isEmpty())
                    {
                        for(Self_Awareness_and_Feedback__c cp : con.Self_Awareness_and_Feedbacks__r)
                        {
                            if(cp.Apptitude_Form_Submitted__c)
                            {
                                submittedStudentMap.put(con.Id,con); 
                                break;
                            }
                        }
                    }
                }  
                
                if(submittedStudentMap.isEmpty())break;
                rsp.submittedStudentMap = submittedStudentMap;
            }while(false);
            return rsp;
        } catch (Exception e) {
            System.debug('searchStudentRecords, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static studentDataWrapper getStudentData(String batchId) {  
        try{
            studentDataWrapper st = new studentDataWrapper();
            List<Contact> conList = [Select id,Name,Full_Name__c,(select id,Created_from_Form__c, Aptitude_1__c, Aptitude_2__c, Aptitude_3__c  from  Self_Awareness_and_Feedbacks__r where Created_from_Form__c=true AND RecordType.Name='Baseline' AND Apptitude_Form_Submitted__c=true)
                                     from Contact where ( Batch_Code__c  =: batchId OR G10_Batch_Code__c =:batchId OR G11_Batch_Code__c  =:batchId OR G11_Batch_Code__c =:batchID ) ORDER BY Name ASC];
            List<Contact> studentsToDisplay = new List<Contact>();
            for(Contact con : conList)
            {
                if(con.Self_Awareness_and_Feedbacks__r.size() != 0)
                {
                    studentsToDisplay.add(con);
                }
            }
            st.studentList = studentsToDisplay;
            st.countStudent = conList.size();
            st.totalStudentList = conList;
            system.debug('st='+st);
            return st;
        } catch (Exception e) {
            System.debug('idSummary.getStudentRecords, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        
    }

    @AuraEnabled
    public static responseWrappper getStudentRecords(String batchId, String grade){ 
        try{
            responseWrappper rsp = new responseWrappper();
            do{
                List<Batch__c> baches = [
                    SELECT Id, Name, School_Name__r.Name, Grade__c, Academic_Year__c, Batch_Number__c 
                    FROM Batch__c
                    WHERE Id = :batchId LIMIT 1];

                if(baches.isEmpty())break;
                rsp.batchGrade = baches[0].Grade__c;
                rsp.batchName = baches[0].Name;
                rsp.schoolName = baches[0].School_Name__r.Name;
                rsp.batchNumber = baches[0].Batch_Number__c;

                List<Contact> studentList = new List<Contact>([
                    SELECT Id, Name, 
                    Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, 
                    Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c, G12_Batch_Code__c,                     
                        (SELECT Created_from_Form__c, Barcode__c, Apptitude_Form_Submitted__c 
                        FROM Self_Awareness_and_Feedbacks__r 
                        WHERE Created_from_Form__c = true 
                        AND RecordType.Name='Baseline'  AND  Academic_Year__c = : baches[0].Academic_Year__c AND Grade__c = :baches[0].Grade__c)
                    FROM Contact 
                    WHERE (Batch_Code__c = :batchId OR 
                    G10_Batch_Code__c = :batchId OR
                    G11_Batch_Code__c = :batchId OR
                    G12_Batch_Code__c = :batchId) 
                    ORDER BY Name
                ]);

                if(studentList.isEmpty())break;
                
                Integer batchGradeStudents = 0;
                List<Contact> gradeStudentList = new List<Contact>();
                for(Contact con : studentList)
                {
                    //=========================================================//
                    if(grade == 'Grade 12' && con.G12_Batch_Code__c != null && con.G12_Batch_Code__c == batchId)
                    {
                        batchGradeStudents++;   
                        gradeStudentList.add(con);                 
                    }
                    else if(grade == 'Grade 11' && con.G11_Batch_Code__c != null && con.G11_Batch_Code__c == batchId)
                    {
                        batchGradeStudents++;   
                        gradeStudentList.add(con);                 
                    }
                    else if(grade == 'Grade 10' && con.G10_Batch_Code__c != null && con.G10_Batch_Code__c == batchId)
                    {
                        batchGradeStudents++;
                        gradeStudentList.add(con);    
                    }
                    else if(grade == 'Grade 9' && con.Batch_Code__c != null && con.Batch_Code__c == batchId)
                    {
                        batchGradeStudents++;
                        gradeStudentList.add(con);    
                    }
                    //=========================================================//
                }

                if(gradeStudentList.isEmpty())break;
                rsp.batchTotalStudents = batchGradeStudents;
                rsp.gradeStudentList = gradeStudentList;

                List<Contact> submittedStudentList = new List<Contact>();  
                for(Contact con : gradeStudentList)
                {   /*
                    String studentBarcode = '';
                    if(grade == 'Grade 9')
                    {
                        studentBarcode = con.Grade_9_Barcode__c;
                    }
                    else if(grade == 'Grade 10')
                    {
                        studentBarcode = con.Grade_10_Barcode__c;
                    }
                    else if(grade == 'Grade 11')
                    {
                        studentBarcode = con.Grade_11_Barcode__c;
                    }*/

                    if(!con.Self_Awareness_and_Feedbacks__r.isEmpty()){
                        for(Self_Awareness_and_Feedback__c saf : con.Self_Awareness_and_Feedbacks__r)
                        {
                            if(saf.Apptitude_Form_Submitted__c /*&& saf.Barcode__c == studentBarcode*/)
                            {
                                submittedStudentList.add(con); 
                                break;
                            }
                        }
                    }
                }  
                
                if(submittedStudentList.isEmpty())break;
                rsp.submittedStudentList = submittedStudentList;
            }while(false);
            return rsp;
        } catch (Exception e) {
            System.debug('idSummary.getStudentRecords, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static District_Master__c aptitudeFormType(Id schoolId){ 
        Account schoolDetails = [ SELECT Id, District__c
                           		  FROM Account 
                                  WHERE id =:schoolId ];
        
        District_Master__c districtDetails = [SELECT Show_Aptitude_for_G9__c, Show_Aptitude_for_G10__c, Show_Aptitude_for_G11__c, Show_Aptitude_for_G12__c
                                              FROM District_Master__c 
                                              WHERE Id = :schoolDetails.District__c];
        return districtDetails;
    }

    @AuraEnabled
    public static Self_Awareness_and_Feedback__c getRecordApt(String studentId, string batchId) {
        try{
            List<Batch__c> batches = new List<Batch__c>([
                SELECT Id, Name, School_Name__r.Name, Grade__c, Academic_Year__c, Batch_Number__c
                FROM Batch__c
                WHERE Id = :batchId LIMIT 1]);
            string grade = batches[0].grade__c;
            String studentBarcode = '';
                List<Contact> studentContact = new List<Contact>([
                    SELECT Id, Name, Bar_Code__c, 
                    Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Grade_12_Barcode__c, 
                    Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c, G12_Batch_Code__c
                    FROM Contact 
                    WHERE Id = :studentId
                    LIMIT 1
                ]);
                if(grade == 'Grade 9')
                {
                    studentBarcode = studentContact[0].Grade_9_Barcode__c;
                }
                else if(grade == 'Grade 10')
                {
                    studentBarcode = studentContact[0].Grade_10_Barcode__c;
                }
                else if(grade == 'Grade 11')
                {
                    studentBarcode = studentContact[0].Grade_11_Barcode__c;
                }
                else if(grade == 'Grade 12')
                {
                    studentBarcode = studentContact[0].Grade_12_Barcode__c;
                }

            List<Self_Awareness_and_Feedback__c> sf =  new List<Self_Awareness_and_Feedback__c>([select id,Created_from_Form__c, Aptitude_1__c, 
                                                           Aptitude_2__c, Aptitude_3__c, Student__c, Student__r.name,
                                                           Spatial_Ability_Q_1__c,Spatial_Ability_Q_2__c,Spatial_Ability_Q_3__c,
                                                           Spatial_Ability_Q_4__c,Spatial_Ability_Q_5__c,Spatial_Ability_Q_6__c,
                                                           Spatial_Ability_Q_7__c,Spatial_Ability_Q_8__c,Numerical_1__c,Numerical_2__c,
                                                           Numerical_3__c,Numerical_4__c,Numerical_5__c,Numerical_6__c,Numerical_7__c,
                                                           Numerical_8__c,Mechanical_1__c,Mechanical_2__c,Mechanical_3__c,Mechanical_4__c,Mechanical_5__c,Mechanical_6__c,Mechanical_7__c,Mechanical_8__c,Abstract_Reasoning_Q_1__c,Abstract_Reasoning_Q_2__c,Abstract_Reasoning_Q_3__c,Abstract_Reasoning_Q_4__c,Abstract_Reasoning_Q_5__c,Abstract_Reasoning_Q_6__c,Abstract_Reasoning_Q_7__c,Abstract_Reasoning_Q_8__c,Verbal_1__c,Verbal_2__c,Verbal_3__c,Verbal_4__c,Verbal_5__c,Verbal_6__c,Verbal_7__c,Verbal_8__c,Creative_1__c,Creative_2__c,Creative_3__c,Creative_4__c,Creative_5__c,Creative_6__c,Creative_7__c,Creative_8__c 
                                                           from  Self_Awareness_and_Feedback__c
                                                            where Student__c =: studentId and Created_from_Form__c = true  
                                                            AND Academic_Year__c = :batches[0].Academic_Year__c
                                                            AND Grade__c = :batches[0].Grade__c 
                                                            AND Barcode__c  = :studentBarcode AND
                                                            RecordType.Name='Baseline' limit 1]);
                if(!sf.isEmpty()){
                    return sf[0];
                }

            return new Self_Awareness_and_Feedback__c();
        }catch(exception e){
            System.debug('awarenessData, e.getMessage() : ' + e.getMessage());
            System.debug('awarenessData, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static void dataPrepare(boolean saveFlag,Self_Awareness_and_Feedback__c sf,string apt1, string apt2, string apt3){
        try{
             if(saveFlag){
                sf.Apptitude_Form_Submitted__c = true;

                if(apt1 == 'NoAnswer')apt1='';
                if(apt2 == 'NoAnswer')apt2='';
                if(apt3 == 'NoAnswer')apt3='';
                sf.Aptitude_1__c = apt1; 
                sf.Aptitude_2__c = apt2; 
                sf.Aptitude_3__c = apt3;

                // if(apt1 == 'NoAnswer' || apt2 == 'NoAnswer' || apt3== 'NoAnswer'){
                //     sf.Aptitude_1__c = ''; 
                //     sf.Aptitude_2__c = ''; 
                //     sf.Aptitude_3__c = ''; 
                // }else{
                //     sf.Aptitude_1__c = apt1; 
                //     sf.Aptitude_2__c = apt2; 
                //     sf.Aptitude_3__c = apt3; 
                // }
            }else{
                if(apt1 == 'NoAnswer')apt1='';
                if(apt2 == 'NoAnswer')apt2='';
                if(apt3 == 'NoAnswer')apt3='';
                sf.Aptitude_1__c = apt1; 
                sf.Aptitude_2__c = apt2; 
                sf.Aptitude_3__c = apt3; 
            }
            upsert sf;   
        }catch(exception e){
            System.debug('ApptitudeController.dataPrepare, e.getMessage() : ' + e.getMessage());
            System.debug('ApptitudeController.dataPrepare, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    @AuraEnabled
    public static string saveData(String studentId, string apt1, string apt2, string apt3,boolean saveFlag, String typ, String lng) {
        system.debug(':::studentId = '+studentId);
		String returnStr = '';
        
        try{
			List<Self_Awareness_and_Feedback__c> sf =  new List<Self_Awareness_and_Feedback__c>([select id,Created_from_Form__c, Aptitude_1__c, Aptitude_2__c, Aptitude_3__c, Student__c from  Self_Awareness_and_Feedback__c
                                                            where Student__c =: studentId and Created_from_Form__c = true and RecordType.Name='Baseline' limit 1]);
            if(!sf.isEmpty()){
				returnStr = 'Update';
                system.debug('saveFlag ='+saveFlag);

                sf[0].Form_Name__c = typ;
                sf[0].Form_Language__c = lng;
                dataPrepare(saveFlag,sf[0],apt1,apt2,apt3);
            }
			else
			{
				returnStr = 'Insert';
				contact con = [select id,Bar_Code__c,Batch_Code__c,G10_Batch_Code__c,G11_Batch_Code__c,G12_Batch_Code__c,Grade_9_Barcode__c,Grade_10_Barcode__c,Grade_11_Barcode__c,Grade_12_Barcode__c from contact where id=:studentId];
                string barcode = '';
                if(con.Batch_Code__c != null)barcode=con.Grade_9_Barcode__c;
                if(con.G10_Batch_Code__c != null)barcode=con.Grade_10_Barcode__c;
                if(con.G11_Batch_Code__c != null)barcode=con.Grade_11_Barcode__c;
                if(con.G12_Batch_Code__c != null)barcode=con.Grade_12_Barcode__c;
                RecordType rt = [select id, name, SobjectType from RecordType where SobjectType = 'Self_Awareness_and_Feedback__c' and name = 'Baseline'];
				Self_Awareness_and_Feedback__c sf1 = new Self_Awareness_and_Feedback__c(Created_from_Form__c = true, Student__c = studentId, Barcode__c = barcode, RecordTypeId = rt.id);
				
                sf1.Form_Name__c = typ;
                sf1.Form_Language__c = lng;
                dataPrepare(saveFlag,sf1,apt1,apt2,apt3);
			}
			
			return returnStr;
        }catch(exception e){
			System.debug('ApptitudeController.saveData, e.getMessage() : ' + e.getMessage());
            System.debug('ApptitudeController.saveData, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static Contact getStudentName(String stuId) {  
        try{
            Contact con = [Select Id,Name FROM Contact WHERE Id =:stuId ];
            return con;
        } catch (Exception e) {
            System.debug('InterestDetailsHandler.getStudentName, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
	public class QuestionAnswer {
        @AuraEnabled public Decimal question { get; set; }
        @AuraEnabled public String answer { get; set; }
    }
    public class studentDataWrapper{
        @AuraEnabled
        public List<Contact> studentList {get;set;}
        @AuraEnabled
        public Integer countStudent {get;set;}
        @AuraEnabled
        public List<Contact> totalStudentList {get;set;}
    }
    public class responseWrappper{
        @AuraEnabled 
        public List<Contact> gradeStudentList {get;set;}

        @AuraEnabled 
        public List<Contact> submittedStudentList {get;set;}

        @AuraEnabled 
        public Integer batchTotalStudents {get;set;}

        @AuraEnabled 
        public String batchGrade {get;set;}

        @AuraEnabled 
        public String batchName {get;set;}

        @AuraEnabled 
        public String schoolName {get;set;}
        
        @AuraEnabled 
        public String batchNumber {get;set;}

        public responseWrappper(){
            submittedStudentList = new List<Contact>();
            batchTotalStudents = 0;
            batchGrade = ''; 
            batchName = '';
            schoolName = '';
            batchNumber = '';
        }
    }
}