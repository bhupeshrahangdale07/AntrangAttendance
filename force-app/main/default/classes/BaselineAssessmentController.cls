public without sharing class BaselineAssessmentController {
    @AuraEnabled
    public static string getBaselineRecord(String studentId, string grade,string type, String batchId) {
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
        if(type=='CDM1'){
            list<OMR_Assessment__c> assesRec = [SELECT Created_from_Form__c, Barcode__c, Form_Submitted__c 
                            FROM OMR_Assessment__c 
                            WHERE Created_from_Form__c = true AND 
                            RecordType.Name='Baseline'  AND  
                            Barcode__c = : studentBarcode AND 
                            Grade__c = :grade AND
                            Student__c = : studentId AND 
                            Academic_Year__c = : batches[0].Academic_Year__c AND
                            Form_Submitted__c = true];
            if(assesRec.size() > 0) return 'found'; 
            else return 'notfound';
        } else if(type=='CDM2'){
            list<CDM2__c> assesRec= [SELECT Created_from_Form__c, Barcode__c, Form_Submitted__c 
                            FROM CDM2__c
                            WHERE Created_from_Form__c = true AND 
                            RecordType.Name='Baseline'  AND  
                            Barcode__c = : studentBarcode AND 
                            Grade__c = :grade AND
                            Student__c = : studentId AND 
                            Academic_Year__c = : batches[0].Academic_Year__c AND
                            Form_Submitted__c = true];
            if(assesRec.size() > 0) return 'found'; 
            else return 'notfound';
        }
        else if(type=='CP'){
            list<Career_Planning__c> assesRec= [SELECT Created_from_Form__c, Barcode__c, Form_Submitted__c 
                            FROM Career_Planning__c
                            WHERE Created_from_Form__c = true AND 
                            RecordType.Name='Baseline'  AND  
                            Barcode__c = : studentBarcode AND 
                            Grade__c = :grade AND
                            Student__c = : studentId AND 
                            Academic_Year__c = : batches[0].Academic_Year__c AND
                            Form_Submitted__c = true];
            if(assesRec.size() > 0) return 'found'; 
            else return 'notfound';
        }
        else if(type=='CS'){
            list<Career_Skill__c> assesRec= [SELECT Created_from_Form__c, Barcode__c, Form_Submitted__c 
                            FROM Career_Skill__c
                            WHERE Created_from_Form__c = true AND 
                            RecordType.Name='Baseline'  AND  
                            Barcode__c = : studentBarcode AND 
                            Grade__c = :grade AND
                            Student__c = : studentId AND 
                            Academic_Year__c = : batches[0].Academic_Year__c AND
                            Form_Submitted__c = true];
            if(assesRec.size() > 0) return 'found'; 
            else return 'notfound';
        }
        else if(type=='PFF'){
            list<Future_Planning__c> assesRec= [SELECT Created_from_Form__c, Barcode__c, Form_Submitted__c 
                            FROM Future_Planning__c
                            WHERE Created_from_Form__c = true AND 
                            RecordType.Name='Baseline'  AND  
                            Barcode__c = : studentBarcode AND 
                            Grade__c = :grade AND
                            Student__c = : studentId AND 
                            Academic_Year__c = : batches[0].Academic_Year__c AND
                            Future_Planning_form_submitted__c = true];
            if(assesRec.size() > 0) return 'found'; 
            else return 'notfound';
        }
        else if(type=='FEEDBACK'){
            list<Future_Planning__c> assesRec= [SELECT Created_from_Form__c, Barcode__c, Form_Submitted__c 
                            FROM Future_Planning__c
                            WHERE Created_from_Form__c = true AND 
                            RecordType.Name='Baseline'  AND  
                            Barcode__c = : studentBarcode AND 
                            Grade__c = :grade AND
                            Student__c = : studentId AND 
                            Academic_Year__c = : batches[0].Academic_Year__c AND
                            Feedback_form_submitted__c = true];
            if(assesRec.size() > 0) return 'found'; 
            else return 'notfound';
        }
        return '';
    }
    // Common method for Baseline Forms
    @AuraEnabled
    public static responseWrapper getStudentDataV2(String batchId, string grade,string type) {  
         try{
            responseWrapper rsp = new responseWrapper();
            do{
                List<Batch__c> batches = [
                    SELECT Id, Name, School_Name__r.Name, Grade__c, Academic_Year__c, Batch_Number__c
                    FROM Batch__c
                    WHERE Id = :batchId LIMIT 1];

                if(batches.isEmpty()){
                    break;
                }
                rsp.batchGrade = batches[0].Grade__c;
                rsp.batchName = batches[0].Name;
                rsp.schoolName = batches[0].School_Name__r.Name;
				rsp.batchNumber = batches[0].Batch_Number__c;
                List<Contact> studentList = new List<Contact>();
                if(type=='CDM1'){
                   studentList = [ SELECT Id, Name, Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Batch_Code__c, 
                                       G10_Batch_Code__c, G11_Batch_Code__c, G12_Batch_Code__c,                 
                                       ( SELECT Created_from_Form__c, Barcode__c, Form_Submitted__c 
                                         FROM OMR_Assessments__r 
                                         WHERE Created_from_Form__c = true AND RecordType.Name='Baseline'  AND  Academic_Year__c = : batches[0].Academic_Year__c AND Grade__c = :batches[0].Grade__c)
                                  FROM Contact
                                  WHERE ( Batch_Code__c = :batchId OR 
                                        G10_Batch_Code__c = :batchId OR
                                        G11_Batch_Code__c = :batchId OR G12_Batch_Code__c = :batchId) 
                                ORDER BY Name ]; 
                }else if(type=='CDM2'){
                   studentList = [ SELECT Id, Name, Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Batch_Code__c, 
                                       G10_Batch_Code__c, G11_Batch_Code__c, G12_Batch_Code__c,                 
                                       ( SELECT Created_from_Form__c, Barcode__c, Form_Submitted__c 
                                         FROM CDM2__r 
                                         WHERE Created_from_Form__c = true AND RecordType.Name='Baseline'  AND  Academic_Year__c = : batches[0].Academic_Year__c AND Grade__c = :batches[0].Grade__c)
                                  FROM Contact
                                  WHERE ( Batch_Code__c = :batchId OR 
                                        G10_Batch_Code__c = :batchId OR
                                        G11_Batch_Code__c = :batchId OR G12_Batch_Code__c = :batchId) 
                                ORDER BY Name ]; 
                }else if(type=='CP'){
                   studentList = [ SELECT Id, Name, Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Batch_Code__c, 
                                       G10_Batch_Code__c, G11_Batch_Code__c, G12_Batch_Code__c,                 
                                       ( SELECT Created_from_Form__c, Barcode__c, Form_Submitted__c 
                                         FROM Career_Plannings__r 
                                         WHERE Created_from_Form__c = true AND RecordType.Name='Baseline'  AND  Academic_Year__c = : batches[0].Academic_Year__c AND Grade__c = :batches[0].Grade__c)
                                  FROM Contact
                                  WHERE ( Batch_Code__c = :batchId OR 
                                        G10_Batch_Code__c = :batchId OR
                                        G11_Batch_Code__c = :batchId OR G12_Batch_Code__c = :batchId) 
                                ORDER BY Name ]; 
                }else if(type=='CS'){
                   studentList = [ SELECT Id, Name, Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Batch_Code__c, 
                                       G10_Batch_Code__c, G11_Batch_Code__c, G12_Batch_Code__c,                 
                                       ( SELECT Created_from_Form__c, Barcode__c, Form_Submitted__c 
                                         FROM Career_Skills__r
                                         WHERE Created_from_Form__c = true AND RecordType.Name='Baseline'  AND  Academic_Year__c = : batches[0].Academic_Year__c AND Grade__c = :batches[0].Grade__c)
                                FROM Contact
                                WHERE ( Batch_Code__c = :batchId OR 
                                        G10_Batch_Code__c = :batchId OR
                                        G11_Batch_Code__c = :batchId OR G12_Batch_Code__c = :batchId) 
                                ORDER BY Name ]; 
                }else if(type=='PFF' || type=='MPF'){
                    studentList = [ SELECT Id, Name, Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Batch_Code__c, 
                                       G10_Batch_Code__c, G11_Batch_Code__c, G12_Batch_Code__c,                 
                                       ( SELECT Created_from_Form__c, Barcode__c, Form_Submitted__c,Future_Planning_form_submitted__c,Feedback_form_submitted__c 
                                         FROM Planning_for_future__r
                                         WHERE Created_from_Form__c = true AND RecordType.Name='Baseline'  AND  Academic_Year__c = : batches[0].Academic_Year__c AND Grade__c = :batches[0].Grade__c)
                                FROM Contact
                                WHERE ( Batch_Code__c = :batchId OR 
                                        G10_Batch_Code__c = :batchId OR
                                        G11_Batch_Code__c = :batchId OR G12_Batch_Code__c = :batchId) 
                                ORDER BY Name ];
                }
                
                /*if(grade == 'Grade 10'){
                    studentList = new List<Contact>([
                    SELECT Id, Name, 
                    Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, 
                    Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c,                     
                        (SELECT Created_from_Form__c, Barcode__c, 
                        Form_Submitted__c 
                        FROM Career_Plannings__r 
                        WHERE Created_from_Form__c = true 
                        AND RecordType.Name='Baseline')
                    FROM Contact 
                    WHERE (Batch_Code__c = :batchId OR 
                    G10_Batch_Code__c = :batchId OR
                    G11_Batch_Code__c = :batchId OR G12_Batch_Code__c = :batchId) 
                    ORDER BY Name
                ]);
                }else{
                       studentList = new List<Contact>([
                        SELECT Id, Name, 
                        Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, 
                        Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c, G12_Batch_Code__c,                 
                            (SELECT Created_from_Form__c, Barcode__c,
                            Future_Planning_form_submitted__c, Feedback_form_submitted__c 
                            FROM Planning_for_future__r 
                            WHERE Created_from_Form__c = true 
                            AND RecordType.Name='Baseline')
                        FROM Contact 
                        WHERE (Batch_Code__c = :batchId OR 
                        G10_Batch_Code__c = :batchId OR
                        G11_Batch_Code__c = :batchId OR G12_Batch_Code__c = :batchId) 
                        ORDER BY Name
                    ]);
                }*/
                
                if(studentList.isEmpty())break;
                
                Integer batchGradeStudents = 0;
                List<Contact> gradeStudentList = new List<Contact>();
                for(Contact con : studentList)
                {
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
                    else if(grade == 'Grade 9' && con.Batch_Code__c != null && con.Batch_Code__c == batchId)
                    {
                        batchGradeStudents++;
                        gradeStudentList.add(con);    
                    }
                    else if(grade == 'Grade 12' && con.G12_Batch_Code__c != null && con.G12_Batch_Code__c == batchId)
                    {
                        batchGradeStudents++;
                        gradeStudentList.add(con);    
                    }
                    //====stuen=====================================================//
                }

                if(gradeStudentList.isEmpty())break;

                rsp.batchTotalStudents = batchGradeStudents;
                rsp.gradeStudentList = gradeStudentList;
                List<Contact> submittedStudentList = new List<Contact>();  
                for(Contact con : gradeStudentList){
                    if(!con.OMR_Assessments__r.isEmpty()){
                         for(OMR_Assessment__c cdm1 : con.OMR_Assessments__r)
                        {
                            if(cdm1.Form_Submitted__c)
                            {
                                submittedStudentList.add(con); 
                                break;
                            }
                        }
                    }
                    if(!con.CDM2__r.isEmpty()){
                         for(CDM2__c cdm2 : con.CDM2__r)
                        {
                            if(cdm2.Form_Submitted__c)
                            {
                                submittedStudentList.add(con); 
                                break;
                            }
                        }
                    }
                    if(!con.Career_Plannings__r.isEmpty()){
                         for(Career_Planning__c cp : con.Career_Plannings__r)
                        {
                            if(cp.Form_Submitted__c)
                            {
                                submittedStudentList.add(con); 
                                break;
                            }
                        }
                    }
                    if(!con.Career_Skills__r.isEmpty()){
                         for(Career_Skill__c cp : con.Career_Skills__r)
                        {
                            if(cp.Form_Submitted__c)
                            {
                                submittedStudentList.add(con); 
                                break;
                            }
                        }
                    }
                    if(!con.Planning_for_future__r.isEmpty() && type=='PFF'){
                         for(Future_Planning__c pff : con.Planning_for_future__r)
                        {
                            if(pff.Future_Planning_form_submitted__c)
                            {
                                submittedStudentList.add(con); 
                                break;
                            }
                        }
                    }
                    if(!con.Planning_for_future__r.isEmpty() && type=='MPF'){
                         for(Future_Planning__c mpf : con.Planning_for_future__r)
                        {
                            if(mpf.Feedback_form_submitted__c)
                            {
                                submittedStudentList.add(con); 
                                break;
                            }
                        }
                    }
                }  
                
                if(submittedStudentList.isEmpty()){
                    break;
                }
                rsp.submittedStudentList = submittedStudentList;
            }while(false);
            return rsp;
        } catch (Exception e) {
            System.debug('idSummary.getStudentRecords, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    public class studentDataWrapper{
        @AuraEnabled
        public List<Contact> studentList {get;set;}
        @AuraEnabled
        public Integer countStudent {get;set;}
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