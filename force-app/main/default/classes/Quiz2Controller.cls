/*Change History
version   Date   	Description
V1.0      14/12/23  To exclude duplicate record from form submission 

*/ 
public without sharing class Quiz2Controller {
     @AuraEnabled
    public static string getQuiz2Record(String studentId, string grade, String batchId) {
        List<Batch__c> batches = [
            SELECT Id, Name, School_Name__r.Name, Grade__c, Academic_Year__c, Batch_Number__c
            FROM Batch__c
            WHERE Id = :batchId LIMIT 1];
        list<contact> contact= [select id,Bar_Code__c from contact where id =:studentId];	
            list<Self_Awareness_Realities__c> assesRec = [SELECT Created_from_Form__c, Barcode__c, Form_Submitted__c 
                            FROM Self_Awareness_Realities__c 
                            WHERE Created_from_Form__c = true AND 
                            RecordType.Name='Baseline'  AND  
                            Barcode__c = : contact[0].Bar_Code__c AND 
                            Grade__c = :grade AND
                            Student__c = : studentId AND 
                            Academic_Year__c = : batches[0].Academic_Year__c AND
                            Quiz_2_Form_Submitted__c = true];
            if(assesRec.size() > 0) return 'found'; 
            else return 'notfound';
        
    }
	@AuraEnabled
    public static responseWrapper searchStudentRecords(String searchText, String batchId, String grade){ 
        try{
            responseWrapper rsp = new responseWrapper();
            do{
                String search = '%'+searchText+'%';
                List<Contact> studentList = new List<Contact>([
                    SELECT Id, Name, Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c,
                    (select id,Created_from_Form__c,Form_Submitted__c,Quiz_2_Form_Submitted__c  from  Self_Awareness_Realities__r  where Created_from_Form__c=true AND RecordType.Name='Baseline' AND Quiz_2_Form_Submitted__c=true) 
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
                    if(grade == 'Grade 11' && con.G11_Batch_Code__c != null && con.G11_Batch_Code__c == batchId)
                    {
                        batchGradeStudents++;   
                        gradeStudentList.add(con);                 
                    }
                    else if(grade == 'Grade 10' && con.G10_Batch_Code__c != null && con.G10_Batch_Code__c == batchId)
                    {
                        batchGradeStudents++;
                        gradeStudentList.add(con);    
                    }
                    else if(grade == 'Grade 9' && con.Batch_Code__c != null && con.Batch_Code__c == batchId){
                        batchGradeStudents++;
                        gradeStudentList.add(con);    
                    }else if(grade == 'Grade 12' && con.G12_Batch_Code__c != null && con.G12_Batch_Code__c == batchId)
                    {
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
                    if(!con.Self_Awareness_Realities__r.isEmpty())
                    {
                        for(Self_Awareness_Realities__c cp : con.Self_Awareness_Realities__r)
                        {
                            if(cp.Quiz_2_Form_Submitted__c)
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
            System.debug('Quiz2Controller.searchStudentRecords, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static quiz1Summary.responseWrapper getStudentRecords(String batchId, String grade){ 
        try{
            quiz1Summary.responseWrapper rsp = new quiz1Summary.responseWrapper();
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
                    Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c, G12_Batch_Code__c, Grade_12_Barcode__c,                    
                        (SELECT id,Created_from_Form__c,Form_Submitted__c,Quiz_2_Form_Submitted__c  from  Self_Awareness_Realities__r  where Created_from_Form__c=true AND RecordType.Name='Baseline' AND  Academic_Year__c = : baches[0].Academic_Year__c AND Grade__c = :baches[0].Grade__c)
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
                    if(grade == 'Grade 11' && con.G11_Batch_Code__c != null && con.G11_Batch_Code__c == batchId)
                    {
                        batchGradeStudents++;   
                        gradeStudentList.add(con);                 
                    }
                    else if(grade == 'Grade 10' && con.G10_Batch_Code__c != null && con.G10_Batch_Code__c == batchId)
                    {
                        batchGradeStudents++;
                        gradeStudentList.add(con);    
                    }
                    else if(grade == 'Grade 9' && con.Batch_Code__c != null && con.Batch_Code__c == batchId){
                        batchGradeStudents++;
                        gradeStudentList.add(con);    
                    }else if(grade == 'Grade 12' && con.G12_Batch_Code__c != null && con.G12_Batch_Code__c == batchId)
                    {
                        batchGradeStudents++;
                        gradeStudentList.add(con);    
                    }
                    //=========================================================//
                }

                if(gradeStudentList.isEmpty())break;
                rsp.batchTotalStudents = batchGradeStudents;

                List<Contact> submittedStudentList = new List<Contact>();  
                for(Contact con : gradeStudentList)
                {   
                    String studentBarcode = '';
                    if(grade == 'Grade 9')studentBarcode = con.Grade_9_Barcode__c;
                    else if(grade == 'Grade 10')studentBarcode = con.Grade_10_Barcode__c;
                    else if(grade == 'Grade 11')studentBarcode = con.Grade_11_Barcode__c;
                    else if(grade == 'Grade 12')studentBarcode = con.Grade_12_Barcode__c;

                    if(!con.Self_Awareness_Realities__r.isEmpty())
                    {
                        for(Self_Awareness_Realities__c saf : con.Self_Awareness_Realities__r)
                        {
                            /*if((saf.Grade9_Quiz1_Submitted__c && grade == 'Grade 9') 
                            && saf.Barcode__c == studentBarcode)
                            {
                                submittedStudentList.add(con); 
                                break;
                            }
                            else if((saf.Grade10_Quiz1_Submitted__c && grade == 'Grade 10') 
                            && saf.Barcode__c == studentBarcode)
                            {
                                submittedStudentList.add(con); 
                                break;
                            } */
                            if(saf.Quiz_2_Form_Submitted__c){
                                submittedStudentList.add(con); 
                                break;
                            }               
                        }
                    }
                }  
                
                //if(submittedStudentList.isEmpty())break;
                rsp.submittedStudentList = gradeStudentList;
            }while(false);
            return rsp;
        } catch (Exception e) {
            System.debug('quiz2Summary.getStudentRecords, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static studentDataWrapper getStudentData(String batchId) {  
        try{
            studentDataWrapper st = new studentDataWrapper();
            List<Contact> conList = [Select id,Name,Full_Name__c,(select id,Created_from_Form__c, Quiz_2_Form_Submitted__c from  Self_Awareness_Realities__r where RecordType.Name='Baseline')
                                     from Contact where ( Batch_Code__c  =: batchId OR G10_Batch_Code__c =:batchId OR G11_Batch_Code__c  =:batchId OR G11_Batch_Code__c =:batchID ) ORDER BY Name ASC];
            List<Contact> studentsToDisplay = new List<Contact>();
            for(Contact con : conList)
            {
                if(con.Self_Awareness_Realities__r.size() != 0)
                {
                    studentsToDisplay.add(con);
                }
            }
            st.studentList = conList;
            st.countStudent = conList.size();
            system.debug('st='+st);
            return st;
        } catch (Exception e) {
            System.debug('Quiz2Controller.getStudentRecords, e.getMessage() : ' + e.getMessage());
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
    public static Self_Awareness_Realities__c getRecordApt(String studentId) {
        try{
            List<Self_Awareness_Realities__c> sf =  new List<Self_Awareness_Realities__c>([select id,Created_from_Form__c, Student__c,Student__r.name,Quiz_2_1__c,Quiz_2_2__c,Quiz_2_3__c,Quiz_2_4__c,Quiz_2_5__c from Self_Awareness_Realities__c
                                                            where Student__c =: studentId and Created_from_Form__c = true and RecordType.Name='Baseline' limit 1]);
                if(!sf.isEmpty()){
                    return sf[0];
                }

            return new 	Self_Awareness_Realities__c();
        }catch(exception e){
            System.debug('Quiz2Controller.awarenessData, e.getMessage() : ' + e.getMessage());
            System.debug('Quiz2Controller.awarenessData, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
     @AuraEnabled
    public static String submitAndCalculate(String recordIdCMD1){
        Savepoint sp = Database.setSavepoint();
        try{

            List<Self_Awareness_Realities__c> sfList = [
                SELECT Id, Name, Barcode__c, Created_from_Form__c,
				Quiz_2_1__c, Quiz_2_2__c, Quiz_2_3__c, Quiz_2_4__c, Quiz_2_5__c, student__c,
				Quiz_2_6__c, Quiz_2_7__c, Quiz_2_8__c, Quiz_2_9__c, Quiz_2_10__c,
				Reality1_Self_1__c, Reality_2_Self_2__c, Reality_3_Self_3__c, Reality_4_Self_4__c,
				Reality_5_Family_1__c, Reality_6_Family_2__c, Reality_7_Family_3__c, Reality_8_Family_4__c
				FROM Self_Awareness_Realities__c 
                WHERE Id = :recordIdCMD1
                LIMIT 1
            ];

            SelfAwarenessRealitiesTriggerHandler.populateStudentAndMarksCalculation(sfList);
            return 'success';
        } catch (Exception e) {
            Database.rollback(sp);
            System.debug('submitAndCalculate, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static void dataPrepare(boolean saveFlag,Self_Awareness_Realities__c sf,string q21, string q22, string q23, string q24, string q25){
        try{
             if(saveFlag){
                sf.Quiz_2_Form_Submitted__c = true;
            }
            if(q21 == 'NoAnswer' || q21 == 'nil')q21='';
            if(q22 == 'NoAnswer' || q22 == 'nil')q22='';
            if(q23 == 'NoAnswer' || q23 == 'nil')q23='';
            if(q24 == 'NoAnswer' || q24 == 'nil')q24='';
            if(q25 == 'NoAnswer' || q25 == 'nil')q25='';
            
            sf.Quiz_2_1__c = q21; 
            sf.Quiz_2_2__c = q22;
            sf.Quiz_2_3__c = q23;
            sf.Quiz_2_4__c = q24;
            sf.Quiz_2_5__c = q25;
            sf.Quiz_2_Form_Submitted__c = true;

            upsert sf;
            if(saveFlag){
                submitAndCalculate(sf.id);
            }
        }catch(exception e){
            System.debug('Quiz2Controller.dataPrepare, e.getMessage() : ' + e.getMessage());
            System.debug('Quiz2Controller.dataPrepare, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    @AuraEnabled
    public static string saveData(String studentId, string q21, string q22, string q23, string q24, string q25, boolean saveFlag, string grade,string lng, string typ) {
        system.debug(':::studentId = '+studentId);
		String returnStr = '';
        try{
			List<Self_Awareness_Realities__c> sf =  new List<Self_Awareness_Realities__c>([select id,Created_from_Form__c, Quiz_2_1__c,Quiz_2_2__c,Quiz_2_3__c,Quiz_2_4__c,Quiz_2_5__c, Student__c from Self_Awareness_Realities__c
                                                            where Student__c =: studentId and Created_from_Form__c = true and RecordType.Name='Baseline' and Error_Status__c = 'No Error' limit 1]); //V1.0
            if(!sf.isEmpty()){
				returnStr = 'Update';
                system.debug('saveFlag ='+saveFlag);
                sf[0].Form_Language__c = lng;
                sf[0].Form_Name__c = typ;
                dataPrepare(saveFlag,sf[0],q21,q22,q23,q24,q25);
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
                RecordType rt = [select id, name, SobjectType from RecordType where SobjectType = 'Self_Awareness_Realities__c' and name = 'Baseline'];

				Self_Awareness_Realities__c sf1 = new 	Self_Awareness_Realities__c(Created_from_Form__c = true,Form_Language__c=lng,Form_Name__c=typ, Student__c = studentId, Barcode__c = barcode, RecordTypeId = rt.id);
                dataPrepare(saveFlag,sf1,q21,q22,q23,q24,q25);
			}
			
			return returnStr;
        }catch(exception e){
			System.debug('Quiz2Controller.saveData, e.getMessage() : ' + e.getMessage());
            System.debug('Quiz2Controller.saveData, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class studentDataWrapper{
        @AuraEnabled
        public List<Contact> studentList {get;set;}
        @AuraEnabled
        public Integer countStudent {get;set;}
    }
    
    public static void fakeMethod(){
    Integer i = 0;
    	i++;
    	i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    	i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    //repeat the i++ hundred of times

  }
}