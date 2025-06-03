public without sharing class idSummary {
    public idSummary() {

    }
	@AuraEnabled
    public static string getInterestRecord(String studentId, string grade, String batchId) {
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
                            Interest_Form_Submitted__c = true];
            if(assesRec.size() > 0) return 'found'; 
            else return 'notfound';
        
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
                    Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c, G12_Batch_Code__c,                      
                        (SELECT Created_from_Form__c, Barcode__c, Interest_Form_Submitted__c 
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

                    if(!con.Self_Awareness_and_Feedbacks__r.isEmpty())
                    {
                        for(Self_Awareness_and_Feedback__c saf : con.Self_Awareness_and_Feedbacks__r)
                        {
                            if(saf.Interest_Form_Submitted__c /*&& saf.Barcode__c == studentBarcode*/)
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
    public static District_Master__c interestFormType(Id schoolId){ 
        Account schoolDetails = [ SELECT Id, District__c
                           		  FROM Account 
                                  WHERE id =:schoolId ];
        
        District_Master__c districtDetails = [SELECT Show_Interest_for_G9__c, Show_Interest_for_G10__c, Show_Interest_for_G11__c, Show_Interest_for_G12__c
                                              FROM District_Master__c 
                                              WHERE Id = :schoolDetails.District__c];
        return districtDetails;
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