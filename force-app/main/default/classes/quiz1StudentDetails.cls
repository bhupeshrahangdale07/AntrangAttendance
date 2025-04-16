public without sharing class quiz1StudentDetails {
    public quiz1StudentDetails() {

    }   

    @AuraEnabled
    public static batchWrapper getBatchInfo(String batchId){ 
        try{
            batchWrapper rsp = new batchWrapper();
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
            }while(false);
            return rsp;
        } catch (Exception e) {
            System.debug('quiz1StudentDetails.getBatchInfo, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class batchWrapper{
        @AuraEnabled 
        public String batchGrade {get;set;}

        @AuraEnabled 
        public String batchName {get;set;}

        @AuraEnabled 
        public String schoolName {get;set;}
		
        @AuraEnabled 
        public String batchNumber {get;set;}
        
        public batchWrapper(){
            batchGrade = ''; 
            batchName = '';
            schoolName = '';
             batchNumber = '';
        }
    }

    @AuraEnabled
    public static responseWrapper searchStudentRecords(String searchText, String batchId, String grade){ 
        try{
            responseWrapper rsp = new responseWrapper();
            do{
                String search = '%'+searchText+'%';
                List<Contact> studentList = new List<Contact>([
                    SELECT Id, Name, 
                    Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, 
                    Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c,                     
                        (SELECT Created_from_Form__c, Barcode__c, 
                        Grade9_Quiz1_Submitted__c, Grade10_Quiz1_Submitted__c 
                        FROM Self_Awareness_and_Feedbacks__r 
                        WHERE Created_from_Form__c = true 
                        AND RecordType.Name='Baseline')
                    FROM Contact 
                    WHERE (Batch_Code__c = :batchId OR 
                    G10_Batch_Code__c = :batchId OR
                    G11_Batch_Code__c = :batchId) 
                    AND Name LIKE :search
                    ORDER BY Name
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
                    }
                    //=========================================================//
                }

                if(gradeStudentList.isEmpty())break;
                rsp.batchTotalStudents = batchGradeStudents;
                rsp.gradeStudentList = gradeStudentList;

                Map<String,Contact> submittedStudentMap = new Map<String,Contact>(); 
                for(Contact con : gradeStudentList)
                {   
                    String studentBarcode = '';
                    if(grade == 'Grade 9')studentBarcode = con.Grade_9_Barcode__c;
                    else if(grade == 'Grade 10')studentBarcode = con.Grade_10_Barcode__c;
                    else if(grade == 'Grade 11')studentBarcode = con.Grade_11_Barcode__c;

                    if(!con.Self_Awareness_and_Feedbacks__r.isEmpty())
                    {
                        for(Self_Awareness_and_Feedback__c saf : con.Self_Awareness_and_Feedbacks__r)
                        {
                            if((saf.Grade9_Quiz1_Submitted__c && grade == 'Grade 9') 
                            && saf.Barcode__c == studentBarcode)
                            {
                                submittedStudentMap.put(con.Id,con); 
                                break;
                            }
                            else if((saf.Grade10_Quiz1_Submitted__c && grade == 'Grade 10') 
                            && saf.Barcode__c == studentBarcode)
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
            System.debug('quiz1StudentDetails.searchStudentRecords, e.getMessage() : ' + e.getMessage());
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
}