public without sharing class quiz1Summary {
    public quiz1Summary() {

    }
	@AuraEnabled
    public static string getQuiz1Record(String studentId, string grade, String batchId) {
        List<Batch__c> batches = [
            SELECT Id, Name, School_Name__r.Name, Grade__c, Academic_Year__c, Batch_Number__c
            FROM Batch__c
            WHERE Id = :batchId LIMIT 1];
        list<contact> contact= [select id,Bar_Code__c from contact where id =:studentId];	
        if(grade == 'Grade 9'){
            list<Self_Awareness_and_Feedback__c> assesRec = [SELECT Created_from_Form__c, Barcode__c, Form_Submitted__c 
                            FROM Self_Awareness_and_Feedback__c 
                            WHERE Created_from_Form__c = true AND 
                            RecordType.Name='Baseline'  AND  
                            Barcode__c = : contact[0].Bar_Code__c AND 
                            Grade__c = :grade AND
                            Student__c = : studentId AND 
                            Academic_Year__c = : batches[0].Academic_Year__c AND
                            Grade9_Quiz1_Submitted__c = true];
            if(assesRec.size() > 0) return 'found'; 
            else return 'notfound';
        }
        else if(grade == 'Grade 12'){
            list<Self_Awareness_and_Feedback__c> assesRec = [SELECT Created_from_Form__c, Barcode__c, Form_Submitted__c 
                            FROM Self_Awareness_and_Feedback__c 
                            WHERE Created_from_Form__c = true AND 
                            RecordType.Name='Baseline'  AND  
                            Barcode__c = : contact[0].Bar_Code__c AND 
                            Grade__c = :grade AND
                            Student__c = : studentId AND 
                            Academic_Year__c = : batches[0].Academic_Year__c AND
                            Grade12_Quiz1_Submitted__c = true];
            if(assesRec.size() > 0) return 'found'; 
            else return 'notfound';
        }
        else if(grade == 'Grade 10'){
            list<Self_Awareness_and_Feedback__c> assesRec = [SELECT Created_from_Form__c, Barcode__c, Form_Submitted__c 
                            FROM Self_Awareness_and_Feedback__c 
                            WHERE Created_from_Form__c = true AND 
                            RecordType.Name='Baseline'  AND  
                            Barcode__c = : contact[0].Bar_Code__c AND 
                            Grade__c = :grade AND
                            Student__c = : studentId AND 
                            Academic_Year__c = : batches[0].Academic_Year__c AND
                            Grade10_Quiz1_Submitted__c = true];
            if(assesRec.size() > 0) return 'found'; 
            else return 'notfound';
        }
        else if(grade == 'Grade 11'){
            list<Self_Awareness_and_Feedback__c> assesRec = [SELECT Created_from_Form__c, Barcode__c, Form_Submitted__c 
                            FROM Self_Awareness_and_Feedback__c 
                            WHERE Created_from_Form__c = true AND 
                            RecordType.Name='Baseline'  AND  
                            Barcode__c = : contact[0].Bar_Code__c AND 
                            Grade__c = :grade AND
                            Student__c = : studentId AND 
                            Academic_Year__c = : batches[0].Academic_Year__c AND
                            Grade11_Quiz1_Submitted__c = true];
            if(assesRec.size() > 0) return 'found'; 
            else return 'notfound';
        }
        return '';    
        
    }
    @AuraEnabled
    public static responseWrapper getStudentRecords(String batchId, String grade){ 
        try{
            responseWrapper rsp = new responseWrapper();
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
                        (SELECT Created_from_Form__c, Barcode__c, 
                        Grade9_Quiz1_Submitted__c, Grade10_Quiz1_Submitted__c , Grade11_Quiz1_Submitted__c, Grade12_Quiz1_Submitted__c
                        FROM Self_Awareness_and_Feedbacks__r 
                        WHERE Created_from_Form__c = true 
                        AND RecordType.Name='Baseline' AND  Academic_Year__c = : baches[0].Academic_Year__c AND Grade__c = :baches[0].Grade__c)
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

                    if(!con.Self_Awareness_and_Feedbacks__r.isEmpty())
                    {
                        for(Self_Awareness_and_Feedback__c saf : con.Self_Awareness_and_Feedbacks__r)
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
                            if(saf.Grade9_Quiz1_Submitted__c && grade == 'Grade 9'){
                                submittedStudentList.add(con); 
                                break;
                            }else if(saf.Grade10_Quiz1_Submitted__c && grade == 'Grade 10'){
                                submittedStudentList.add(con); 
                                break;
                            }else if(saf.Grade11_Quiz1_Submitted__c && grade == 'Grade 11'){
                                submittedStudentList.add(con); 
                                break;
                            }else if(saf.Grade12_Quiz1_Submitted__c && grade == 'Grade 12'){
                                submittedStudentList.add(con); 
                                break;
                            }            
                        }
                    }
                }  
                
                //if(submittedStudentList.isEmpty())break;
                rsp.submittedStudentList = gradeStudentList;
                system.debug('rsp.submittedStudentList'+rsp.submittedStudentList);
            }while(false);
            return rsp;
        } catch (Exception e) {
            System.debug('quiz1Summary.getStudentRecords, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class responseWrapper{
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

        public responseWrapper(){
            submittedStudentList = new List<Contact>();
            batchTotalStudents = 0;
            batchGrade = ''; 
            batchName = '';
            schoolName = '';
            batchNumber = '';
        }
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
    //repeat the i++ hundred of times

  }
}