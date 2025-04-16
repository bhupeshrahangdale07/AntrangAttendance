/*Change History
version   Date   	Description
V1.0      14/12/23  To exclude duplicate record from form submission 

*/
public without sharing class InterestDetailsHandler {
    @AuraEnabled
    public static responseWrapper searchStudentRecords(String searchText, String batchId, String grade){ 
        try{
            responseWrapper rsp = new responseWrapper();
            do{
                String search = '%'+searchText+'%';
                List<Contact> studentList = new List<Contact>([
                    SELECT Id, Name, Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c,
                    (select id,Created_from_Form__c, Interest_1__c, Interest_2__c, Interest_3__c,Interest_Form_Submitted__c,Form_Submitted__c  from  Self_Awareness_and_Feedbacks__r where Created_from_Form__c=true AND RecordType.Name='Baseline' AND Interest_Form_Submitted__c=true) 
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
                            if(cp.Interest_Form_Submitted__c)
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
            System.debug('InterestDetailsHandler.searchStudentRecords, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static studentDataWrapper getStudentData(String batchId) {  
        try{
            studentDataWrapper st = new studentDataWrapper();
            List<Contact> conList = [Select id,Name,Full_Name__c,(select id,Created_from_Form__c, Interest_1__c, Interest_2__c, Interest_3__c  from  Self_Awareness_and_Feedbacks__r where Created_from_Form__c=true AND RecordType.Name='Baseline' AND Interest_Form_Submitted__c=true)
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
            system.debug('st='+st);
            return st;
        } catch (Exception e) {
            System.debug('InterestDetailsHandler.getStudentRecords, e.getMessage() : ' + e.getMessage());
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
    public static Self_Awareness_and_Feedback__c getRecordApt(String studentId) {
        try{
            List<Self_Awareness_and_Feedback__c> sf =  new List<Self_Awareness_and_Feedback__c>([select id,Created_from_Form__c,
                                                            Interest_Test_1__c,Interest_Test_10__c,Interest_Test_11__c,Interest_Test_12__c,
                                                            Interest_Test_13__c,Interest_Test_14__c,Interest_Test_15__c,Interest_Test_16__c,
                                                            Interest_Test_17__c,Interest_Test_18__c,Interest_Test_19__c,Interest_Test_2__c,
                                                            Interest_Test_20__c,Interest_Test_21__c,Interest_Test_22__c,Interest_Test_23__c,
                                                            Interest_Test_24__c,Interest_Test_25__c,Interest_Test_26__c,Interest_Test_27__c,
                                                            Interest_Test_28__c,Interest_Test_29__c,Interest_Test_3__c,Interest_Test_30__c,
                                                            Interest_Test_31__c,Interest_Test_32__c,Interest_Test_33__c,Interest_Test_34__c,
                                                            Interest_Test_35__c,Interest_Test_36__c,Interest_Test_37__c,Interest_Test_38__c,
                                                                                                 Interest_Test_39__c,Interest_Test_4__c,Interest_Test_40__c,Interest_Test_41__c,Interest_Test_42__c,Interest_Test_43__c,Interest_Test_44__c,Interest_Test_45__c,Interest_Test_46__c,Interest_Test_47__c,Interest_Test_48__c,Interest_Test_5__c,Interest_Test_6__c,Interest_Test_7__c,Interest_Test_8__c,Interest_Test_9__c, Student__c, Student__r.name from  Self_Awareness_and_Feedback__c
                                                            where Student__c =: studentId and Created_from_Form__c = true and RecordType.Name='Baseline' limit 1]);
                if(!sf.isEmpty()){
                    return sf[0];
                }

            return new Self_Awareness_and_Feedback__c();
        }catch(exception e){
            System.debug('InterestDetailsHandler.getRecordApt, e.getMessage() : ' + e.getMessage());
            System.debug('InterestDetailsHandler.getRecordApt, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static void dataPrepare(boolean saveFlag,Self_Awareness_and_Feedback__c sf,string apt1, string apt2, string apt3){
        try{
             if(saveFlag){
                sf.Interest_Form_Submitted__c = true;
             }
                // if(apt1 == 'NoAnswer' || apt2 == 'NoAnswer' || apt3== 'NoAnswer'){
                //     sf.Interest_1__c = ''; 
                //     sf.Interest_2__c = ''; 
                //     sf.Interest_3__c = ''; 
                // }else{
                //     sf.Interest_1__c = apt1; 
                //     sf.Interest_2__c = apt2; 
                //     sf.Interest_3__c = apt3; 
                // }
            // }else{
                if(apt1 == 'NoAnswer')apt1='';
                if(apt2 == 'NoAnswer')apt2='';
                if(apt3 == 'NoAnswer')apt3='';
                sf.Interest_1__c = apt1; 
                sf.Interest_2__c = apt2; 
                sf.Interest_3__c = apt3; 
            upsert sf;   
        }catch(exception e){
            System.debug('InterestDetailsHandler.dataPrepare, e.getMessage() : ' + e.getMessage());
            System.debug('InterestDetailsHandler.dataPrepare, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    public static void dataPrepareForV2(boolean saveFlag,Self_Awareness_and_Feedback__c sf,List<QuestionAnswer> dataMap,string interest1,string interest2,string interest3,string typ, string lng){
        try{
             if(saveFlag){
                sf.Interest_Form_Submitted__c = true;
                 sf.Interest_1__c = interest1;
                 sf.Interest_2__c = interest2;
                 sf.Interest_3__c = interest3;
                 sf.Form_Name__c = typ;
                 sf.Form_Language__c = lng;
             }
             /*for (String key : dataMap.keySet()) {
                 string fieldName = 'Interest_Test_'+key+'__c';
                 string value = String.valueOf(answerMap.get(key));
             }*/
            system.debug('dataMap = '+dataMap);
            for (QuestionAnswer qa : dataMap) {
                 string fieldName = 'Interest_Test_'+qa.question +'__c';
                 string value = String.valueOf(qa.answer);
                 sf.put(fieldName,value);
            }
              
            upsert sf;   
        }catch(exception e){
            System.debug('InterestDetailsHandler.dataPrepare, e.getMessage() : ' + e.getMessage());
            System.debug('InterestDetailsHandler.dataPrepare, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    @AuraEnabled
    public static string saveDataForFormV2(String studentId, List<Map<String, Object>> answerSet,boolean saveFlag, string grade, string typ, string lng, string interest1, string interest2, string interest3) {
        system.debug('questionAnswers = '+answerSet);
        List<QuestionAnswer> dataMap = new List<QuestionAnswer>();
        for (Map<String, Object> qa : answerSet) {
            Decimal question = (Decimal)qa.get('question');
            String answer = (String)qa.get('answer');
    
            QuestionAnswer qaObj = new QuestionAnswer();
            qaObj.question = question;
            qaObj.answer = answer;
    
            dataMap.add(qaObj);
        }
        String returnStr = '';
        List<Self_Awareness_and_Feedback__c> sf =  new List<Self_Awareness_and_Feedback__c>([select id,Created_from_Form__c, Interest_1__c,Interest_Test_1__c,Interest_Test_10__c,Interest_Test_11__c,Interest_Test_12__c,
                                                            Interest_Test_13__c,Interest_Test_14__c,Interest_Test_15__c,Interest_Test_16__c,
                                                            Interest_Test_17__c,Interest_Test_18__c,Interest_Test_19__c,Interest_Test_2__c,
                                                            Interest_Test_20__c,Interest_Test_21__c,Interest_Test_22__c,Interest_Test_23__c,
                                                            Interest_Test_24__c,Interest_Test_25__c,Interest_Test_26__c,Interest_Test_27__c,
                                                            Interest_Test_28__c,Interest_Test_29__c,Interest_Test_3__c,Interest_Test_30__c,
                                                            Interest_Test_31__c,Interest_Test_32__c,Interest_Test_33__c,Interest_Test_34__c,
                                                            Interest_Test_35__c,Interest_Test_36__c,Interest_Test_37__c,Interest_Test_38__c,
                                                                                                 Interest_Test_39__c,Interest_Test_4__c,Interest_Test_40__c,Interest_Test_41__c,Interest_Test_42__c,Interest_Test_43__c,Interest_Test_44__c,Interest_Test_45__c,Interest_Test_46__c,Interest_Test_47__c,Interest_Test_48__c,Interest_Test_5__c,Interest_Test_6__c,Interest_Test_7__c,Interest_Test_8__c,Interest_Test_9__c,  Interest_2__c, Interest_3__c, Student__c from  Self_Awareness_and_Feedback__c
                                                            where Student__c =: studentId and Created_from_Form__c = true and RecordType.Name='Baseline' and Error_Status__c = 'No Error' limit 1]); //V1.0
    	if(!sf.isEmpty()){
            returnStr = 'Update';
            system.debug('saveFlag ='+saveFlag);
            system.debug('sf[0] = '+sf[0]);
            dataPrepareForV2(saveFlag,sf[0],dataMap,interest1,interest2,interest3,typ,lng);
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
            dataPrepareForV2(saveFlag,sf1,dataMap,interest1,interest2,interest3,typ,lng);
        }
        return returnStr;
    }
    @AuraEnabled
    public static string saveData(String studentId, string apt1, string apt2, string apt3,boolean saveFlag, string grade, String typ, String lng) {
        system.debug(':::studentId = '+studentId);
		String returnStr = '';
        try{
			List<Self_Awareness_and_Feedback__c> sf =  new List<Self_Awareness_and_Feedback__c>([select id,Created_from_Form__c, Interest_1__c, Interest_2__c, Interest_3__c, Student__c from  Self_Awareness_and_Feedback__c
                                                            where Student__c =: studentId and Created_from_Form__c = true and RecordType.Name='Baseline' limit 1]);
            if(!sf.isEmpty()){
				returnStr = 'Update';
                system.debug('saveFlag ='+saveFlag);
                system.debug('sf[0] = '+sf[0]);

                sf[0].Form_Name__c = typ;
                sf[0].Form_Language__c = lng;
                dataPrepare(saveFlag,sf[0],apt1,apt2,apt3);
            }
			else
			{
				returnStr = 'Insert';
				contact con = [select id,Bar_Code__c,Batch_Code__c,G10_Batch_Code__c,G11_Batch_Code__c,G12_Batch_Code__c,Grade_9_Barcode__c,Grade_10_Barcode__c,Grade_11_Barcode__c,Grade_12_Barcode__c from contact where id=:studentId];
                string barcode = '';
                 if(grade == 'Grade 9')barcode=con.Grade_9_Barcode__c;
                if(grade == 'Grade 10')barcode=con.Grade_10_Barcode__c;
                if(grade == 'Grade 11')barcode=con.Grade_11_Barcode__c;
                if(grade == 'Grade 12')barcode=con.Grade_12_Barcode__c;
                RecordType rt = [select id, name, SobjectType from RecordType where SobjectType = 'Self_Awareness_and_Feedback__c' and name = 'Baseline'];
				Self_Awareness_and_Feedback__c sf1 = new Self_Awareness_and_Feedback__c(Created_from_Form__c = true, Student__c = studentId, Barcode__c = barcode, RecordTypeId = rt.id);
                system.debug('sf1 = '+sf1);

                sf1.Form_Name__c = typ;
                sf1.Form_Language__c = lng;

				dataPrepare(saveFlag,sf1,apt1,apt2,apt3);
			}
			
			return returnStr;
        }catch(exception e){
			System.debug('InterestDetailsHandler.saveData, e.getMessage() : ' + e.getMessage());
            System.debug('InterestDetailsHandler.saveData, e.getLineNumber() : ' + e.getLineNumber());
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
    public class studentDataWrapper{
        @AuraEnabled
        public List<Contact> studentList {get;set;}
        @AuraEnabled
        public Integer countStudent {get;set;}
    }
    public class QuestionAnswer {
        @AuraEnabled public Decimal question { get; set; }
        @AuraEnabled public String answer { get; set; }
    }
}