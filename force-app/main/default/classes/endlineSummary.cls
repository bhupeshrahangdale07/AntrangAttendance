public without sharing class endlineSummary {
    public endlineSummary() {

    }

    @AuraEnabled
    public static responseWrapper getStudentRecords(String batchId, String grade, string typ){ 
        try{
            system.debug('typ = '+typ);
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
                    Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Grade_12_Barcode__c,
                    Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c,G12_Batch_Code__c,                     
                        (SELECT Created_from_Form__c, Barcode__c, 
                        Future_Planning_form_submitted__c, Feedback_form_submitted__c 
                        FROM Planning_for_future__r 
                        WHERE Created_from_Form__c = true 
                        AND RecordType.Name='Endline')
                    FROM Contact 
                    WHERE (Batch_Code__c = :batchId OR 
                    G10_Batch_Code__c = :batchId OR
                    G11_Batch_Code__c = :batchId OR  G12_Batch_Code__c = :batchId) 
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
                    else if(grade == 'Grade 12' && con.G12_Batch_Code__c != null)
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

                    if(!con.Planning_for_future__r.isEmpty())
                    {
                        for(Future_Planning__c fp : con.Planning_for_future__r)
                        {
                            if((typ == 'Form V2' && fp.Future_Planning_form_submitted__c) || (fp.Future_Planning_form_submitted__c && 
                            fp.Feedback_form_submitted__c && (typ == null || typ == ''))/*&& fp.Barcode__c == studentBarcode*/)
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

    public class responseWrapper{
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
        
        public responseWrapper(){
            submittedStudentList = new List<Contact>();
            batchTotalStudents = 0;
            batchGrade = ''; 
            batchName = '';
            schoolName = '';
             batchNumber = '';
        }
    }
}