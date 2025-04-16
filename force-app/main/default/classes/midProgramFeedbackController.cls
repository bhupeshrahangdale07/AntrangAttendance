/*Change History
version   Date   	Description
V1.0      14/12/23  To exclude duplicate record from form submission 

*/ 
public without sharing class midProgramFeedbackController {
    @AuraEnabled
    public static string getMidProgramFeedbackRecord(String studentId, string grade, String batchId) {
        List<Batch__c> batches = [
            SELECT Id, Name, School_Name__r.Name, Grade__c, Academic_Year__c, Batch_Number__c
            FROM Batch__c
            WHERE Id = :batchId LIMIT 1];
        list<contact> contact= [select id,Bar_Code__c from contact where id =:studentId];	
            list<Self_Awareness_and_Feedback__c> assesRec = [SELECT Created_from_Form__c, Barcode__c, Form_Submitted__c 
                            FROM Self_Awareness_and_Feedback__c 
                            WHERE Created_from_Form__c = true AND 
                            RecordType.Name='Baseline'  AND  
                            Barcode__c = : contact[0].Bar_Code__c AND 
                            Grade__c = :grade AND
                            Student__c = : studentId AND 
                            Academic_Year__c = : batches[0].Academic_Year__c AND
                            Feedback_Form_Submitted__c = true];
            if(assesRec.size() > 0) return 'found'; 
            else return 'notfound';
        
    }
@AuraEnabled
    public static responseWrapper searchStudentRecords(String searchText, String batchId, String grade){ 
        try{
            responseWrapper rsp = new responseWrapper();
            do{
                system.debug('$$$ batchId'+batchId);
                String search = '%'+searchText+'%';
                List<Contact> studentList = new List<Contact>([
                    SELECT Id, Name, Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c,
                    (select id,Created_from_Form__c, Aptitude_1__c, Aptitude_2__c, Aptitude_3__c,Apptitude_Form_Submitted__c,Form_Submitted__c,Feedback_Form_Submitted__c  from  Self_Awareness_and_Feedbacks__r where Created_from_Form__c=true AND RecordType.Name='Baseline' AND Feedback_Form_Submitted__c=true) 
                    FROM Contact 
                    WHERE (Batch_Code__c = :batchId OR 
                           G10_Batch_Code__c = :batchId OR
                           G11_Batch_Code__c = :batchId OR G12_Batch_Code__c = :batchId) 
                    AND Name LIKE :search
                ]);
                system.debug('$$$ studentList'+studentList);
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
                            if(cp.Feedback_Form_Submitted__c)
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
    public static studentDataWrapper getStudentData(String batchId, String grade) {  
        try{

            List<Batch__c> batches = [
                    SELECT Id, Name, School_Name__r.Name, Grade__c, Academic_Year__c, Batch_Number__c
                    FROM Batch__c
                    WHERE Id = :batchId LIMIT 1];


            studentDataWrapper st = new studentDataWrapper();
            List<Contact> conList = [ Select id,Name,Full_Name__c, Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c, G12_Batch_Code__c, 
                                         (select id,Created_from_Form__c, Feedback_1__c,Feedback_2__c,Feedback_3__c,Feedback_4__c,Feedback_5__c,Feedback_6__c,Feedback_7__c,
                                         Feedback_Form_Submitted__c  from  Self_Awareness_and_Feedbacks__r where RecordType.Name='Baseline' AND  Academic_Year__c = : batches[0].Academic_Year__c AND Grade__c = :batches[0].Grade__c)
                                      from Contact 
                                      where ( Batch_Code__c  =: batchId OR G10_Batch_Code__c =:batchId OR G11_Batch_Code__c  =:batchId OR G12_Batch_Code__c =:batchID ) 
                                      ORDER BY Name ASC];
            // List<Contact> studentsToDisplay = new List<Contact>();
            /*for(Contact con : conList)
            {
                if(con.Self_Awareness_and_Feedbacks__r.size() != 0)
                {
                    studentsToDisplay.add(con);
                }
            }*/

            List<Contact> gradeStudentList = new List<Contact>();
            for(Contact con : conList)
            {
                //=========================================================//
                if(grade == 'Grade 11' && con.G11_Batch_Code__c != null && con.G11_Batch_Code__c == batchId)
                {
                    gradeStudentList.add(con);                 
                }
                else if(grade == 'Grade 10' && con.G10_Batch_Code__c != null && con.G10_Batch_Code__c == batchId)
                {
                    gradeStudentList.add(con);    
                }
                else if(grade == 'Grade 9' && con.Batch_Code__c != null && con.Batch_Code__c == batchId){
                    gradeStudentList.add(con);    
                }else if(grade == 'Grade 12' && con.G12_Batch_Code__c != null && con.G12_Batch_Code__c == batchId)
                {
                    gradeStudentList.add(con);    
                }
                //=========================================================//
            }

            st.studentList = gradeStudentList;
            st.countStudent = gradeStudentList.size();
            system.debug('st='+st);
            return st;
        } catch (Exception e) {
            System.debug('idSummary.getStudentRecords, e.getMessage() : ' + e.getMessage());
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
            List<Self_Awareness_and_Feedback__c> sf =  new List<Self_Awareness_and_Feedback__c>([select id,Created_from_Form__c, Feedback_1__c,Feedback_2__c,Feedback_3__c,Feedback_4__c,Feedback_5__c,Feedback_6__c,Feedback_7__c, Student__c, Student__r.name from  Self_Awareness_and_Feedback__c
                                                            where Student__c =: studentId and Created_from_Form__c = true and RecordType.Name='Baseline' limit 1]);
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
    public static void dataPrepare(boolean saveFlag,Self_Awareness_and_Feedback__c sf,string fb1, string fb2, string fb3, string fb4, string fb5, string fb6, string fb7){
        try{
             if(saveFlag){
                sf.Feedback_Form_Submitted__c = true;
            }
            if(fb1 == 'NoAnswer')fb1='';
            if(fb2 == 'NoAnswer')fb2='';
            if(fb3 == 'NoAnswer')fb3='';
            if(fb4 == 'NoAnswer')fb4='';
            if(fb5 == 'NoAnswer')fb5='';
            if(fb6 == 'NoAnswer')fb6='';
            if(fb7 == 'NoAnswer')fb7='';
            sf.Feedback_1__c = fb1;
            sf.Feedback_2__c = fb2;
            sf.Feedback_3__c = fb3;
            sf.Feedback_4__c = fb4;
            sf.Feedback_5__c = fb5;
            sf.Feedback_6__c = fb6;
            sf.Feedback_7__c = fb7;
            sf.Feedback_Form_Submitted__c=true;
            upsert sf;   
        }catch(exception e){
            System.debug('ApptitudeController.dataPrepare, e.getMessage() : ' + e.getMessage());
            System.debug('ApptitudeController.dataPrepare, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    @AuraEnabled
    public static string saveData(String studentId, string fb1, string fb2, string fb3, string fb4, string fb5, string fb6, string fb7,boolean saveFlag,string grade,
                                 string lng, string typ) {
        system.debug(':::studentId = '+studentId);
		String returnStr = '';
        try{
			List<Self_Awareness_and_Feedback__c> sf =  new List<Self_Awareness_and_Feedback__c>([select id,Created_from_Form__c,Feedback_1__c,Feedback_2__c,Feedback_3__c,Feedback_4__c,Feedback_5__c,Feedback_6__c,Feedback_7__c, Student__c from  Self_Awareness_and_Feedback__c
                                                            where Student__c =: studentId and Created_from_Form__c = true and RecordType.Name='Baseline' and Error_Status__c = 'No Error' limit 1]); //v1.0
            if(!sf.isEmpty()){
				returnStr = 'Update';
                system.debug('saveFlag ='+saveFlag);
                sf[0].Form_Language__c = lng;
                sf[0].Form_Name__c = typ;
                dataPrepare(saveFlag,sf[0],fb1,fb2,fb3,fb4,fb5,fb6,fb7);
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
				Self_Awareness_and_Feedback__c sf1 = new Self_Awareness_and_Feedback__c(Created_from_Form__c = true, Feedback_Form_Submitted__c = true,Form_Language__c=lng,Form_Name__c=typ,Student__c = studentId, Barcode__c = barcode, RecordTypeId = rt.id);
				dataPrepare(saveFlag,sf1,fb1,fb2,fb3,fb4,fb5,fb6,fb7);
			}
			
			return returnStr;
        }catch(exception e){
			System.debug('ApptitudeController.saveData, e.getMessage() : ' + e.getMessage());
            System.debug('ApptitudeController.saveData, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class studentDataWrapper{
        @AuraEnabled
        public List<Contact> studentList {get;set;}
        @AuraEnabled
        public Integer countStudent {get;set;}
    }

    @AuraEnabled
    public static Contact getStudentName(String stuId) {  
        try{
            Contact con = [Select Id,Name FROM Contact WHERE Id =:stuId ];
            return con;
        } catch (Exception e) {
            System.debug('midProgramFeedbackController.getStudentName, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
}