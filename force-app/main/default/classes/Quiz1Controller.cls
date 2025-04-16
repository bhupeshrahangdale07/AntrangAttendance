public without sharing class Quiz1Controller {
    public Quiz1Controller() {

    }
	/*@AuraEnabled
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
    }*/

    /*@AuraEnabled
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
                        (SELECT id,Created_from_Form__c,Form_Submitted__c,Quiz_2_Form_Submitted__c  from  Self_Awareness_Realities__r  where Created_from_Form__c=true AND RecordType.Name='Baseline')
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
                            /*if(saf.Quiz_2_Form_Submitted__c){
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
    }*/

    /*@AuraEnabled
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

    public class studentDataWrapper{
        @AuraEnabled
        public List<Contact> studentList {get;set;}
        @AuraEnabled
        public Integer countStudent {get;set;}
    }*/
    
    /*public class responseWrapper{
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
    }*/
    
    /*@AuraEnabled
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
    }*/
    
    @AuraEnabled
    public static string saveAllQA(String studentId, string q11, string q12, string q13, string q14, string q15, string grade, string lng, string typ) {

        Map<String, String> keyMap = new Map<String, String>{'1'=>'A', '2'=>'B', '3'=>'C', '4'=>'D', '5'=>'*', '6'=>''};
        if(String.isNotBlank(q11) && keyMap.containsKey(q11)){
            q11 = keyMap.get(q11);
        }

        if(String.isNotBlank(q12) && keyMap.containsKey(q12)){
            q12 = keyMap.get(q12);
        }

        if(String.isNotBlank(q13) && keyMap.containsKey(q13)){
            q13 = keyMap.get(q13);
        }

        if(String.isNotBlank(q14) && keyMap.containsKey(q14)){
            q14 = keyMap.get(q14);
        }

        if(String.isNotBlank(q15) && keyMap.containsKey(q15)){
            q15 = keyMap.get(q15);
        }


        system.debug('$$$ studentId: '+ studentId);
		String returnStr = '';
        string rspId = '';
        try{
			List<Self_Awareness_and_Feedback__c> sf =  new List<Self_Awareness_and_Feedback__c>([ Select id,Created_from_Form__c, Quiz_1_1__c,Quiz_1_2__c,Quiz_1_3__c,Quiz_1_4__c,Quiz_1_5__c, 
                                                                                                 	Grade9_Quiz1_Submitted__c, Grade10_Quiz1_Submitted__c, Grade11_Quiz1_Submitted__c, Grade12_Quiz1_Submitted__c, Student__c 
                                                                                                  from Self_Awareness_and_Feedback__c
                                                            									  where Student__c =: studentId and Created_from_Form__c = true and RecordType.Name='Baseline' and Error_Status__c = 'No Error' 
                                                                                                  limit 1]); //V1.0
            if(!sf.isEmpty()){
				returnStr = 'Update';
                sf[0].Form_Language__c = lng;
                sf[0].Form_Name__c = typ;
                dataPrepare(sf[0], q11, q12, q13, q14, q15, grade);
                rspId = sf[0].Id;
            }
			else{
				returnStr = 'Insert';
				contact con = [select id,Bar_Code__c,Batch_Code__c,G10_Batch_Code__c,G11_Batch_Code__c,G12_Batch_Code__c,Grade_9_Barcode__c,Grade_10_Barcode__c,Grade_11_Barcode__c,Grade_12_Barcode__c from contact where id=:studentId];
                string barcode = '';
                if(grade == 'Grade 9')barcode=con.Grade_9_Barcode__c;
                if(grade == 'Grade 10')barcode=con.Grade_10_Barcode__c;
                if(grade == 'Grade 11')barcode=con.Grade_11_Barcode__c;
                if(grade == 'Grade 12')barcode=con.Grade_12_Barcode__c;
                RecordType rt = [select id, name, SobjectType 
                                 from RecordType 
                                 where SobjectType = 'Self_Awareness_and_Feedback__c' and name = 'Baseline'];

				Self_Awareness_and_Feedback__c sf1 = new Self_Awareness_and_Feedback__c(Created_from_Form__c = true,Form_Language__c=lng,Form_Name__c=typ, Student__c = studentId, Barcode__c = barcode, RecordTypeId = rt.id);
                dataPrepare(sf1, q11, q12, q13, q14, q15, grade);
                rspId = sf1.Id;
			}
			
			return rspId;
        }catch(exception e){
			System.debug('Quiz1Controller.saveAllQA, e.getMessage() : ' + e.getMessage());
            System.debug('Quiz1Controller.saveAllQA, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    public static void dataPrepare(Self_Awareness_and_Feedback__c sf, string q11, string q12, string q13, string q14, string q15, string grade){
        try{
             if(sf != null){
                sf.Quiz_1_1__c = q11; 
                sf.Quiz_1_2__c = q12;
                sf.Quiz_1_3__c = q13;
                sf.Quiz_1_4__c = q14;
                sf.Quiz_1_5__c = q15;
                if(grade == 'Grade 9')sf.Grade9_Quiz1_Submitted__c = true;
                if(grade == 'Grade 10')sf.Grade10_Quiz1_Submitted__c = true;
                if(grade == 'Grade 11')sf.Grade11_Quiz1_Submitted__c = true;
                if(grade == 'Grade 12')sf.Grade12_Quiz1_Submitted__c = true;
                 
                upsert sf;
            	submitAndCalculate(sf.id);
             }
        }catch(exception e){
            System.debug('Quiz1Controller.dataPrepare, e.getMessage() : ' + e.getMessage());
            System.debug('Quiz1Controller.dataPrepare, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
	
    @AuraEnabled
    public static String submitAndCalculate(String recordIdQUIZ1){
        Savepoint sp = Database.setSavepoint();
        try{

            List<Self_Awareness_and_Feedback__c> sfList = [ SELECT Id, Name, Barcode__c, Created_from_Form__c, Quiz_1_1__c, Quiz_1_2__c, Quiz_1_3__c, Quiz_1_4__c, Quiz_1_5__c, student__c
				FROM Self_Awareness_and_Feedback__c 
                WHERE Id = :recordIdQUIZ1
                LIMIT 1
            ];

            SelfAwarenessandFeedbackTriggerHandler.populateStudentAndMarksCalculation(sfList);
            return 'success';
        } catch (Exception e) {
            Database.rollback(sp);
            System.debug('Quiz1Controller.submitAndCalculate, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Contact getStudentName(String studId) {
        list<Contact> studList = [select id, name, Bar_Code__c from contact where id = :studId];
        if(studList.size() > 0){
            return studList[0];
        }
        return null;
    }
    
     public class qAnswer{
        String answer;
    }

    public class qAnswerAll{
        qAnswer q01;
        qAnswer q02;
        qAnswer q03;
        qAnswer q04;
        qAnswer q05;

        public qAnswerAll(){
            q01 = new qAnswer();
            q02 = new qAnswer();
            q03 = new qAnswer();
            q04 = new qAnswer();
            q05 = new qAnswer();
        }
    }
}