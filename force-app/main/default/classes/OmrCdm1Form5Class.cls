public without sharing class OmrCdm1Form5Class {

    //@AuraEnabled(Cacheable=true)
    /*@AuraEnabled
    public static List<Contact>  fetchStudentForCmd1Form(String selBatchIdFromParams,String selectedRecordType){
        /*System.debug('@@Params : '+selBatchIdFromParams + ' param 2 : '+selectedRecordType);
        /* Prev. Requirement :
        String query = ' Select id,Created_from_Form__c,Form_Submitted__c,Student__c,Student__r.Name from OMR_Assessment__c where Created_from_Form__c=true AND ' 
                        + ' RecordType.Name='+'\''+selectedRecordType+'\''
                            +' AND ( Student__r.Batch_Code__c  ='+ '\''+selBatchIdFromParams+'\'' 
                            + ' OR Student__r.G10_Batch_Code__c ='+  '\''+selBatchIdFromParams+'\''  
                            + ' OR Student__r.G11_Batch_Code__c  ='+ '\''+selBatchIdFromParams+'\' ) ORDER BY Student__r.Name';
        

        //String query = 'Select id,Name,'+
            ' (select id,Form_Submitted__c, Created_from_Form__c from  OMR_Assessments__r where Created_from_Form__c=true AND Form_Submitted__c=true AND RecordType.Name='+'\''+selectedRecordType+'\'),'+
            ' (select id,Form_Submitted__c, Created_from_Form__c from CDM2__r WHERE Form_Submitted__c=true AND Created_from_Form__c=true AND RecordType.Name='+'\''+selectedRecordType+'\'),'+
            ' (select id,Form_Submitted__c, Created_from_Form__c from Career_Plannings__r WHERE Form_Submitted__c=true AND Created_from_Form__c=true AND RecordType.Name='+'\''+selectedRecordType+'\')'+
        ' from Contact where ( Batch_Code__c  ='+'\''+selBatchIdFromParams+'\''+ 'OR G10_Batch_Code__c ='+'\''+selBatchIdFromParams+'\''+ 'OR G11_Batch_Code__c  ='+'\''+selBatchIdFromParams+'\' ) '+
        ' ORDER BY Name';
		 String query = 'Select id,Name,'+
            ' (select id,Form_Submitted__c, Created_from_Form__c from  OMR_Assessments__r where Created_from_Form__c=true AND RecordType.Name='+'\''+selectedRecordType+'\'),'+
            ' (select id,Form_Submitted__c, Created_from_Form__c from CDM2__r WHERE Form_Submitted__c=true AND RecordType.Name='+'\''+selectedRecordType+'\'),'+
            ' (select id,Form_Submitted__c, Created_from_Form__c from Career_Plannings__r WHERE Created_from_Form__c=true AND RecordType.Name='+'\''+selectedRecordType+'\')'+
        ' from Contact where ( Batch_Code__c  ='+'\''+selBatchIdFromParams+'\''+ 'OR G10_Batch_Code__c ='+'\''+selBatchIdFromParams+'\''+ 'OR G11_Batch_Code__c  ='+'\''+selBatchIdFromParams+'\' ) '+
        ' ORDER BY Name';
		
        System.debug('@@Query : '+query);
        List<Contact> contactLst = Database.query(query);
        System.debug('@@@ Contact List : '+Database.query(query));
        if(contactLst.size()>0){
            return contactLst;
        }
        return null;
    }*/
    @AuraEnabled
    public static studentDataWrapper getStudentData(String batchId) {  
        try{
            studentDataWrapper st = new studentDataWrapper();
            List<Contact> conList = new List<Contact>();
            conList = [Select id,Name,Full_Name__c,(select id,Form_Submitted__c, Created_from_Form__c from  OMR_Assessments__r where Created_from_Form__c=true AND RecordType.Name='Baseline'),
				(select id,Form_Submitted__c, Created_from_Form__c from CDM2__r WHERE Form_Submitted__c=true AND Created_from_Form__c=true AND RecordType.Name='Baseline'),(select id,Form_Submitted__c, Created_from_Form__c from Career_Plannings__r WHERE Form_Submitted__c=true AND Created_from_Form__c=true AND RecordType.Name='Baseline')
                from Contact where ( Batch_Code__c  =: batchId OR G10_Batch_Code__c =:batchId OR G11_Batch_Code__c  =:batchId OR G11_Batch_Code__c =:batchID ) ORDER BY Name ASC];        
            /*for(Contact con : conList)
            {
                if(con.Self_Awareness_Realities__r.size() != 0)
                {
                    studentsToDisplay.add(con);
                }
            }*/
            st.studentList = conList;
            st.countStudent = conList.size();
            system.debug('st='+st);
            return st;
        } catch (Exception e) {
            System.debug('RealityController.getStudentRecords, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        
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

                if(batches.isEmpty())break;
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
                                         WHERE Created_from_Form__c = true AND RecordType.Name='Baseline')
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
                                         WHERE Created_from_Form__c = true AND RecordType.Name='Baseline')
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
                                         WHERE Created_from_Form__c = true AND RecordType.Name='Baseline')
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
                                         WHERE Created_from_Form__c = true AND RecordType.Name='Baseline')
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
                                         WHERE Created_from_Form__c = true AND RecordType.Name='Baseline')
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