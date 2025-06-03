/*Change History
version   Date   	Description
V1.0      14/12/23  To exclude duplicate record from form submission 

*/ 
public without sharing class RealityController {
     @AuraEnabled
    public static string getRealityRecord(String studentId, string grade, String batchId) {
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
            list<Self_Awareness_Realities__c> assesRec = [SELECT Created_from_Form__c, Barcode__c, Form_Submitted__c 
                            FROM Self_Awareness_Realities__c 
                            WHERE Created_from_Form__c = true AND 
                            RecordType.Name='Baseline'  AND  
                            Barcode__c = : studentBarcode AND 
                            Grade__c = :grade AND
                            Student__c = : studentId AND 
                            Academic_Year__c = : batches[0].Academic_Year__c AND
                            Reality_Form_Submitted__c = true];
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
                    (select id,Created_from_Form__c,Form_Submitted__c,Reality_Form_Submitted__c  from  Self_Awareness_Realities__r  where Created_from_Form__c=true AND RecordType.Name='Baseline' AND Reality_Form_Submitted__c=true) 
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
                    if(!con.Self_Awareness_Realities__r.isEmpty())
                    {
                        for(Self_Awareness_Realities__c cp : con.Self_Awareness_Realities__r)
                        {
                            if(cp.Reality_Form_Submitted__c)
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
            System.debug('RealityController.searchStudentRecords, e.getMessage() : ' + e.getMessage());
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
            List<Contact> conList = [Select id,Name,Full_Name__c, Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c, G12_Batch_Code__c, (select id,Created_from_Form__c, Reality_Form_Submitted__c from  Self_Awareness_Realities__r where RecordType.Name='Baseline' AND  Academic_Year__c = : batches[0].Academic_Year__c AND Grade__c = :batches[0].Grade__c ORDER BY Reality_Form_Submitted__c)
                                     from Contact where ( Batch_Code__c  =: batchId OR G10_Batch_Code__c =:batchId OR G11_Batch_Code__c  =:batchId OR G11_Batch_Code__c =:batchID OR G12_Batch_Code__c =:batchID ) ORDER BY Name ASC];
            List<Contact> studentsToDisplay = new List<Contact>();
            /*for(Contact con : conList)
            {
                if(con.Self_Awareness_Realities__r.size() != 0)
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
            System.debug('RealityController.getStudentRecords, e.getMessage() : ' + e.getMessage());
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
    public static Self_Awareness_Realities__c getRecordApt(String studentId, string grade, string batchId) {
        try{
            List<Batch__c> batches = new List<Batch__c>([
                    SELECT Id, Name, School_Name__r.Name, Grade__c, Academic_Year__c, Batch_Number__c
                    FROM Batch__c
                    WHERE Id = :batchId LIMIT 1]);
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
            List<Self_Awareness_Realities__c> sf =  new List<Self_Awareness_Realities__c>([select id,Created_from_Form__c, Student__c,
                                                                                           Reality1_Self_1__c,Reality_2_Self_2__c,
                                                                                           Reality_3_Self_3__c,Reality_4_Self_4__c,
                                                                                           Reality_5_Family_1__c,Reality_6_Family_2__c,
                                                                                           Reality_7_Family_3__c,Reality_8_Family_4__c, 
                                                                                           student__r.name from Self_Awareness_Realities__c
                                                            where Student__c =: studentId and Created_from_Form__c = true and 
                                                                                           RecordType.Name='Baseline' limit 1]);
                if(!sf.isEmpty()){
                    return sf[0];
                }

            return new 	Self_Awareness_Realities__c();
        }catch(exception e){
            System.debug('RealityController.awarenessData, e.getMessage() : ' + e.getMessage());
            System.debug('RealityController.awarenessData, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static void dataPrepare(boolean saveFlag,Self_Awareness_Realities__c sf,string self1, string self2, string self3, string self4,string family1,string family2,string family3,string family4){
        try{
             if(saveFlag){
                sf.Reality_Form_Submitted__c = true;
            }
                if(self1 == 'NoAnswer')self1='';
                if(self2 == 'NoAnswer')self2='';
                if(self3 == 'NoAnswer')self3='';
                if(self4 == 'NoAnswer')self4='';
                if(family1 == 'NoAnswer')family1='';
                if(family2 == 'NoAnswer')family2='';
                if(family3 == 'NoAnswer')family3='';
                if(family4 == 'NoAnswer')family4='';
                sf.Reality1_Self_1__c = self1; 
                sf.Reality_2_Self_2__c = self2;
                sf.Reality_3_Self_3__c = self3;
                sf.Reality_4_Self_4__c = self4;
                sf.Reality_5_Family_1__c = family1;
                sf.Reality_6_Family_2__c = family2;
                sf.Reality_7_Family_3__c = family3;
                sf.Reality_8_Family_4__c = family4;
   
            upsert sf;
            if(saveFlag){
                submitAndCalculate(sf.id);
            }
        }catch(exception e){
            System.debug('RealityController.dataPrepare, e.getMessage() : ' + e.getMessage());
            System.debug('RealityController.dataPrepare, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    public static String submitAndCalculate(String recordIdCMD1){
        Savepoint sp = Database.setSavepoint();
        try{

            List<Self_Awareness_Realities__c> sfList = [
                SELECT Id, Name, Barcode__c, Created_from_Form__c,
				Quiz_2_1__c, Quiz_2_2__c, Quiz_2_3__c, Quiz_2_4__c, Quiz_2_5__c, 
				Quiz_2_6__c, Quiz_2_7__c, Quiz_2_8__c, Quiz_2_9__c, Quiz_2_10__c,
				Reality1_Self_1__c, Reality_2_Self_2__c, Reality_3_Self_3__c, Reality_4_Self_4__c,
				Reality_5_Family_1__c, Reality_6_Family_2__c, Reality_7_Family_3__c, Reality_8_Family_4__c, student__c
				FROM Self_Awareness_Realities__c 
                WHERE Id = :recordIdCMD1
                LIMIT 1
            ];

            Self_Awareness_Realities__c recSubmitStatus = new Self_Awareness_Realities__c(Id = recordIdCMD1);
            recSubmitStatus.Reality1_Self_1_Ans__c = '';
            recSubmitStatus.Reality_2_Self_2_Ans__c = '';
            recSubmitStatus.Reality_3_Self_3_Ans__c = '';
            recSubmitStatus.Reality_4_Self_4_Ans__c = '';
            recSubmitStatus.Reality_5_Family_1_Ans__c = '';
            recSubmitStatus.Reality_6_Family_2_Ans__c = '';
            recSubmitStatus.Reality_7_Family_3_Ans__c = '';
            recSubmitStatus.Reality_8_Family_4_Ans__c = '';
            update recSubmitStatus;
            SelfAwarenessRealitiesTriggerHandler.populateStudentAndMarksCalculation(sfList);
            return 'success';
        } catch (Exception e) {
            Database.rollback(sp);
            System.debug('submitAndCalculate, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static string saveData(String batchId, String studentId, string self1, string self2, string self3,string self4,string family1,string family2,string family3,string family4, boolean saveFlag, string grade,string typ, string lng) {
        system.debug(':::studentId = '+studentId);
		String returnStr = '';
        try{
            
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
            
			List<Self_Awareness_Realities__c> sf =  new List<Self_Awareness_Realities__c>([select id,Created_from_Form__c,Reality1_Self_1__c,Reality_2_Self_2__c,Reality_3_Self_3__c,Reality_4_Self_4__c,Reality_5_Family_1__c,Reality_6_Family_2__c,Reality_7_Family_3__c,Reality_8_Family_4__c, Student__c from Self_Awareness_Realities__c
                                                            where Barcode__c = : studentBarcode AND Grade__c = :batches[0].Grade__c AND Student__c = : studentId AND Academic_Year__c = : batches[0].Academic_Year__c and Created_from_Form__c = true and RecordType.Name='Baseline' and Error_Status__c = 'No Error' limit 1]); //V1.0
            if(!sf.isEmpty()){
                sf[0].Form_Language__c = lng;
                sf[0].Form_Name__c = typ;
				returnStr = 'Update';
                system.debug('saveFlag ='+saveFlag);
                dataPrepare(saveFlag,sf[0],self1,self2,self3,self4,family1,family2,family3,family4);
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
				Self_Awareness_Realities__c sf1 = new 	Self_Awareness_Realities__c(Created_from_Form__c = true, Student__c = studentId, Barcode__c = barcode, RecordTypeId = rt.id);
				sf1.Form_Language__c = lng;
                sf1.Form_Name__c = typ;
                dataPrepare(saveFlag,sf1,self1,self2,self3,self4,family1,family2,family3,family4);
			}
			
			return returnStr;
        }catch(exception e){
			System.debug('RealityController.saveData, e.getMessage() : ' + e.getMessage());
            System.debug('RealityController.saveData, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class studentDataWrapper{
        @AuraEnabled
        public List<Contact> studentList {get;set;}
        @AuraEnabled
        public Integer countStudent {get;set;}
    }
}