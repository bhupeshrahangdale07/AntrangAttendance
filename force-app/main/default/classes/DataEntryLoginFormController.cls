public without sharing class DataEntryLoginFormController{
    @AuraEnabled
    public static void logUserExit(){
        contact con = [select id from contact where id = '0031m00000ZJjLdAAL'];
        con.FirstName = 'yuga';
        update con;
    }
    @AuraEnabled
    public static decimal getAntarangNextAcadamicYear(){
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
		return antarangSett.Next_Academic_Year__c;
    }
    @AuraEnabled
    public static Object checkEmailExist(String stremail, string typ) {
        stremail = stremail.trim();
        Map<String, Object> result = new Map<String, Object>();
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('CA_Trainer')
            .getRecordTypeId();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        result.put('grade', getdynamicpicklistval('Batch__c', 'Grade__c'));
        Contact c = new Contact();
        
        if((String.isNotBlank(stremail) && stremail.contains('@') && stremail.split('@').get(1) == 'antarangfoundation.org' && typ != 'Form V2') 
           || stremail == 'farheenshaikh@antarangfoundation.org') {
               for (Contact objcon : [
                   SELECT id, npe01__WorkEmail__c,Academic_Year__c,Facilitator_Work_Status__c
                   FROM contact
                   WHERE npe01__WorkEmail__c = :stremail AND RecordTypeId = :recordTypeId
                   /*AND Academic_Year__c =: antarangSett.Next_Academic_Year__c
                   AND Facilitator_Work_Status__c = 'Active'*/
                   ORDER BY CreatedDate DESC
                   LIMIT 1
               ]) {
                   c = objcon;
               }
               system.debug('3 = '+c);
               result.put('contact', c);
               //return result;
        } else if(typ == 'Form V2'){
            if(String.isNotBlank(stremail) && !stremail.contains('@')){
                for (Contact objcon : [
                       SELECT id, npe01__WorkEmail__c,Academic_Year__c,Facilitator_Work_Status__c
                       FROM contact
                       WHERE MobilePhone = :stremail AND RecordTypeId = :recordTypeId
                       AND (Academic_Year__c =: antarangSett.Next_Academic_Year__c OR Academic_Year__c =: antarangSett.Academic_Year__c)
                       /*AND Facilitator_Work_Status__c = 'Active'*/
                       ORDER BY CreatedDate DESC
                       LIMIT 1
                   ]) {
                       c = objcon;
                }
                system.debug('1 = '+c);
                result.put('contact', c);
            }else if(String.isNotBlank(stremail) && stremail.contains('@')){
                for (Contact objcon : [
                   SELECT id, npe01__WorkEmail__c,Academic_Year__c,Facilitator_Work_Status__c
                   FROM contact
                   WHERE npe01__WorkEmail__c = :stremail AND RecordTypeId = :recordTypeId
                  AND (Academic_Year__c =: antarangSett.Next_Academic_Year__c OR Academic_Year__c =: antarangSett.Academic_Year__c)
                   /* AND Facilitator_Work_Status__c = 'Active'*/
                   ORDER BY CreatedDate DESC
                   LIMIT 1
               ]) {
                   c = objcon;
               }
               system.debug('3 = '+c);
               result.put('contact', c);
            }
            //return result;
        }
        else{
               result.put('contact', c);
               //return result;
        }
        return result;
    }

    @AuraEnabled
    //public static List<studentAttendance> findSessionAtt(string accountId){
    public static Map<String,Object> findBatch(string accountId, String selectedGrade, String traineremail, boolean flagEmail){ 
        
        Map<String,Object> returnValues = new Map<String,Object>();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();

        List<Contact> con = new List<Contact>([Select id, Academic_Year__c from Contact where (npe01__WorkEmail__c =:traineremail OR MobilePhone = :traineremail) AND RecordType.DeveloperName = 'CA_Trainer' limit 1 ]);

        decimal nxtAcaYr = antarangSett.Next_Academic_Year__c;
        if(!con.isEmpty() && con[0].Academic_Year__c != null){
            nxtAcaYr = con[0].Academic_Year__c;
        }else{
            return returnValues;
        }

        system.debug('accountId :: '+accountId+' selectedGrade :: '+selectedGrade+'antarangSett.Academic_Year__c ::'+antarangSett.Academic_Year__c+'antarangSett.Next_Academic_Year__c ::'+antarangSett.Next_Academic_Year__c);
        string query = 'select id,Name,Facilitation_Start_Date__c,Batch_number__c,Grade__c from Batch__c where school_name__c =:accountId AND Grade__c =: selectedGrade AND Academic_Year__c =: nxtAcaYr AND Dummy_Batch__c = False';
       if(flagEmail == false){
           query += ' AND Trainer_Name__r.MobilePhone = :traineremail';
       }else{
           query += ' AND Trainer_Name__r.npe01__WorkEmail__c =: traineremail';                           
       }
        query += ' ORDER BY Facilitation_Start_Date__c desc';                                                           
        List<Batch__c> batchlst = Database.query(query);
        system.debug('query = '+query);
        system.debug('studentlst :: '+batchlst);
        List<picklistwrapper> options = new List<picklistwrapper>();
        options.add(new picklistwrapper('-None-', ''));
        for(Batch__c bc : batchlst){
            
            options.add(
                //new picklistwrapper(bc.Batch_number__c +' - '+bc.Name, String.valueOf(bc.Id))
                new picklistwrapper(bc.Batch_number__c,String.valueOf(bc.Id))
            );
            
        }
        
        returnValues.put('batchOptions',options);
        system.debug('returnValues = '+returnValues);
        return returnValues;
    }
    
    public static List<picklistwrapper> getdynamicpicklistval(String objectName,String fieldName){
        List<picklistwrapper> options = new List<picklistwrapper>();
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult r = s.getDescribe();
        Map<String, Schema.SObjectField> fields = r.fields.getMap();
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        options.add(new picklistwrapper('--None--', ''));
        for (Schema.PicklistEntry pickListVal : ple) {
            options.add(
                new picklistwrapper(pickListVal.getLabel(), String.valueOf(pickListVal.getValue()))
            );
        }
        return options;
    }
    
    @AuraEnabled
    public static List<wrpSession> lstsessionRecords(string batchId,string loggedInTrainer){
        
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        
        List<Batch__c> batch = new List<Batch__c>([Select Id,Facilitation_Start_Date__c From Batch__c where Id = :batchId]);
        String sessionGrade = '';
        if(batch.size() > 0){
            //need to change to dynamic 
            /* date dt = date.newInstance(Date.today().year(), 4, 30);
            date d = date.newInstance(Date.today().year()-1, 5, 1);*/
            date d = date.newInstance(System.Today().year()-1,6,1);
            date dt = date.newInstance(System.Today().year(),6,30); //
            if(batch[0].Facilitation_Start_Date__c >= d && batch[0].Facilitation_Start_Date__c <= dt){
                sessionGrade = 'Class 9';
            } else {
                sessionGrade = 'Class 10';
            }
        }
        
        List<wrpSession> wrpSessionLSt = new List<wrpSession>();
        
        for(Session__c objSession : [select Id,Name,SessionDate__c,Session_Delivery__c,Session_Number__c,Total_Student_Present__c,
                                     Session_Link__c,Session_Grade__c,Session_Type__c,
                                     Session_Code__c,Session_End_Time__c,Session_Start_Time__c, Session_Mode__c,
                                     Assigned_Facilitator__c,Assigned_Facilitator__r.Name,Assigned_Facilitator__r.npe01__WorkEmail__c,
                                     (select id from Sessions__r limit 1)
                                     from session__c where Batch__c =: batchId /*AND Session_Grade__c = :sessionGrade*/ AND Session_Type__c != 'Counseling' /*AND Session_Type__c != 'Parent'*/]){
                                         wrpSession objwrp = new wrpSession();
                                         objwrp.id = objSession.Id;
                                         //objwrp.WhereClause = ' AND RecordType.DeveloperName = \'CA_Trainer\' AND Academic_Year__c = '+Integer.valueOf(antarangSett.Academic_Year__c)+' ORDER BY Name';//antarangSett.Academic_Year__c != null ? Integer.valueOf(antarangSett.Academic_Year__c) : null;
                                         objwrp.WhereClause = ' AND RecordType.DeveloperName = \'CA_Trainer\' AND Academic_Year__c = '+Integer.valueOf(antarangSett.Next_Academic_Year__c)+' ORDER BY Name';//antarangSett.Academic_Year__c != null ? Integer.valueOf(antarangSett.Academic_Year__c) : null;
                                         objwrp.name = objSession.Name;
                                         objwrp.grade = objSession.Session_Grade__c;
                                         objwrp.mode = objSession.Session_Mode__c;
                                         objwrp.facilitatorId = objSession.Assigned_Facilitator__c;
                                         objwrp.facilitatorName = objSession.Assigned_Facilitator__c != null ? objSession.Assigned_Facilitator__r.Name : '';
                                         objwrp.sessionDate = objSession.SessionDate__c;
                                         //objwrp.delivery = objSession.Session_Delivery__c;
                                         objwrp.link = objSession.Session_Link__c;
                                         //objwrp.type = objSession.Session_Type__c;
                                         //objwrp.code = objSession.Session_Code__c;
                                         objwrp.endTime = objSession.Session_End_Time__c;
                                         objwrp.startTime = objSession.Session_Start_Time__c;
                                         //Commented on 26-sep-2022
                                         if((/*(objSession.Session_Number__c == 1 || objSession.Session_Number__c == 2) &&*/ 
                                             objSession.Total_Student_Present__c > 0 ) ||
                                            objSession.Sessions__r.size() > 0 && objSession.SessionDate__c != null){
                                                objwrp.isAttendenceFound = true;
                                            }else{
                                                objwrp.isAttendenceFound = false;
                                            }
                                         if(objSession.Assigned_Facilitator__c != null && objSession.Assigned_Facilitator__r.npe01__WorkEmail__c == loggedInTrainer){
                                             objwrp.isNotLoggedInTrainerSession = false;
                                         }else{
                                             objwrp.isNotLoggedInTrainerSession = true;
                                         }
                                         if(objSession.Session_Type__c == 'Student'){
                                             objwrp.isParentSession = false;
                                         }else{
                                             objwrp.isParentSession = true;
                                         }
                                         //objwrp.isAttendenceFound = objSession.Sessions__r.size() > 0 ? true : false;
                                         wrpSessionLSt.add(objwrp);
                                         
                                     }
        return wrpSessionLSt;
        
    }
    
    @AuraEnabled
    public static List<wrpSession> saveSessions(string data, string batchId,string loggedInTrainer) {
        List<wrpSession> wrpSessionLSt = (List<wrpSession>)JSON.deserializeStrict(data, List<wrpSession>.class);
        List<Session__c> sessionToUpdate = new list<Session__c>();
        
        for(wrpSession wrpobj : wrpSessionLSt ){
            Session__c objsession = new Session__c();
            objsession.Id = wrpobj.id;
            objsession.SessionDate__c = wrpobj.sessionDate;
            //objsession.Session_Delivery__c = wrpobj.delivery;
            objsession.Session_Link__c = wrpobj.link;
            //objsession.Session_Type__c = wrpobj.type;
            objsession.Session_End_Time__c = wrpobj.endTime;
            objsession.Session_Start_Time__c = wrpobj.startTime;
            objsession.Session_Mode__c = wrpobj.mode;
            objsession.Assigned_Facilitator__c = wrpobj.facilitatorId != '' ? wrpobj.facilitatorId : null;
            sessionToUpdate.add(objsession);
        }
        
        
        if(sessionToUpdate.size()>0){
            
            update sessionToUpdate;
            
            List<wrpSession> wrplst = lstsessionRecords(batchId,loggedInTrainer);
            
            return wrplst;
            
        }
        return null;  
    }
    
    //Added Now : 31/01/2022
    @AuraEnabled
    public static contact findSelectedStudentRecord(string contactId){
        Contact selectedStudent = [SELECT Id, Bar_Code__c From Contact Where Id=:contactId];
        // system.debug(' @@@ contact Id : '+selectedStudent.Id);
        // system.debug(' @@@ contact Barcode : '+selectedStudent.Bar_Code__c);
        return selectedStudent;
    }
    
    //------ Piyush(2/02/2022)
     @AuraEnabled
    public static batch__c batchDetails(string batchId){
        Batch__c bt = [SELECT name, School_Name__r.name, Grade__c FROM Batch__c WHERE id=: batchId];
        return bt;
    }
    @AuraEnabled
    public static student totalStudentInBatch(String grade, string batchId){
        List<Contact> studentList = [ SELECT Id, Full_Name__c, What_are_you_currently_studying__c,
                                        G9_Whatsapp_Number__c, G10_Whatsapp_Number__c, G11_Whatsapp_Number__c, G12_Whatsapp_Number__c   
                                     FROM Contact 
                                     WHERE ( Batch_Code__c =:batchId OR 
                                            G10_Batch_Code__c =:batchId OR 
                                            G11_Batch_Code__c =:batchId OR 
                                            G12_Batch_Code__c =:batchId ) order by Full_Name__c];
        
        Batch__c bt = [SELECT Name, School_Name__r.name, Grade__c,Batch_Number__c FROM Batch__c WHERE id=: batchId];
        
        student st = new student();
        st.studentList = studentList;
        st.BatchName = bt.name;
        st.BatchNumber = bt.Batch_Number__c;
        st.GradeName = bt.Grade__c;
        st.SchoolName = bt.School_Name__r.name;
        st.countStudent = studentList.size();
        
        // Added new property to Enable/disable the Student Linking Button DT 21-Feb-2024
        Map<String, Object> unlinkedStudents = new Map<String, Object>();
        if(grade == 'Grade 10' || grade == 'Grade 11' || grade == 'Grade 12'){
            unlinkedStudents = StudentLinkController.getUnLinkedStudents(grade, batchId);
        }

        if(unlinkedStudents.containsKey('contacts')){
            List<Contact> unlinkedContacts = new List<Contact>();
            unlinkedContacts = (List<Contact>) unlinkedStudents.get('contacts');
            st.isDisableStudentLinking =  unlinkedContacts.size() < 1 ? true : false;
        }else{
            st.isDisableStudentLinking = true;
        }
        system.debug(' @@@ Student List: '+studentList.size());
        return st;
    }
    
    @AuraEnabled
    public static void updateStudentData(String selectedStudentrecord){
        try {
            Contact con = (Contact) JSON.deserialize(selectedStudentrecord, Contact.class); 
            update con;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class student{
        @AuraEnabled public List<Contact> studentList;
        @AuraEnabled public String BatchName;
        @AuraEnabled public String GradeName;
        @AuraEnabled public String SchoolName;
        @AuraEnabled public Integer countStudent;
        @AuraEnabled public String BatchNumber;

        @AuraEnabled public Boolean isDisableStudentLinking;
    }
    
    @AuraEnabled
    public static Map<String,Object> batchOptionsbyBatchId(String traineremail){ 
        
        Map<String,Object> returnValues = new Map<String,Object>();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        //system.debug('accountId :: '+accountId+' selectedGrade :: '+selectedGrade+'antarangSett.Academic_Year__c ::'+antarangSett.Academic_Year__c);
        List<Batch__c> batchlst = [SELECT id,Name,Facilitation_Start_Date__c, Batch_number__c,Grade__c 
                                   FROM Batch__c
                                   WHERE Trainer_Name__r.npe01__WorkEmail__c =: traineremail AND 
                                         //Academic_Year__c =: antarangSett.Academic_Year__c AND 
                                  		 Academic_Year__c =: antarangSett.Next_Academic_Year__c AND 
                                         Dummy_Batch__c = False 
                                    ORDER BY Facilitation_Start_Date__c desc ];
        system.debug('studentlst :: '+batchlst);
        List<picklistwrapper> options = new List<picklistwrapper>();
        options.add(new picklistwrapper('-None-', ''));
        for(Batch__c bc : batchlst){
            
            options.add(
               // new picklistwrapper(bc.Batch_number__c +' - '+bc.Name, String.valueOf(bc.Id))
               new picklistwrapper(bc.Batch_number__c, String.valueOf(bc.Id))
            );
        }
        returnValues.put('batchOptions',options);
        return returnValues;
    }

    @AuraEnabled
    public static Batch__c schoolnGradebyBatchId(Id batchId){ 
        Batch__c bt = [ SELECT Id, School_Name__c, School_Name__r.Name, Grade__c 
                                    FROM Batch__c 
                                    WHERE id =:batchId ];
        return bt;
    }
	
    //------ Piyush(6/02/2022)
    @AuraEnabled
    public static District_Master__c getSchoolDistrictData(Id schoolId){ 
        system.debug('schoolId = '+schoolId);
        Account schoolDetails = [ SELECT Id, District__c
                           		  FROM Account 
                                  WHERE id =:schoolId ];
        /*Id districtId  = schoolDetails.District__c;
        string fieldsToQuery = 'SELECT ';
        if(grade != null && grade != ''){
            if(grade == 'Grade 9'){
                fieldsToQuery += 'Select_Forms_to_Show_in_Baseline_for_G9__c, Select_Forms_to_Show_in_Endline_for_G9__c, Show_Aptitude_for_G9__c, Show_Baseline_for_G9__c, Show_Endline_for_G9__c, Show_Interest_for_G9__c, Show_Mid_Program_for_G9__c, Show_Quiz_1_for_G9__c, Show_Quiz_2_for_G9__c, Show_Reality_for_G9__c';
            }else if(grade == 'Grade 10'){
                fieldsToQuery += 'Select_Forms_to_Show_in_Baseline_for_G10__c, Select_Forms_to_Show_in_Endline_for_G10__c, Show_Aptitude_for_G10__c, Show_Baseline_for_G10__c, Show_Endline_for_G10__c, Show_Interest_for_G10__c, Show_Mid_Program_for_G10__c, Show_Quiz_1_for_G10__c, Show_Quiz_2_for_G10__c, Show_Reality_for_G10__c';
            }else if(grade == 'Grade 11'){
                fieldsToQuery += 'Select_Forms_to_Show_in_Baseline_for_G11__c, Select_Forms_to_Show_in_Endline_for_G11__c, Show_Aptitude_for_G11__c, Show_Baseline_for_G11__c, Show_Endline_for_G11__c, Show_Interest_for_G11__c, Show_Mid_Program_for_G11__c, Show_Quiz_1_for_G11__c, Show_Quiz_2_for_G11__c, Show_Reality_for_G11__c';
            }else if(grade == 'Grade 12'){
                fieldsToQuery += 'Select_Forms_to_Show_in_Baseline_for_G12__c, Select_Forms_to_Show_in_Endline_for_G12__c, Show_Aptitude_for_G12__c, Show_Baseline_for_G12__c, Show_Endline_for_G12__c, Show_Interest_for_G12__c, Show_Mid_Program_for_G12__c, Show_Quiz_1_for_G12__c, Show_Quiz_2_for_G12__c, Show_Reality_for_G12__c';
            }
        }
        
        fieldsToQuery += ' FROM District_Master__c WHERE Id = :districtId';
        District_Master__c districtDetails = Database.query(fieldsToQuery);*/
 
        
        
        District_Master__c districtDetails = [SELECT Show_Student_Details_for_G9__c, Select_Forms_to_Show_in_Baseline_for_G9__c, Select_Forms_to_Show_in_Endline_for_G9__c, Show_Aptitude_for_G9__c, Show_Baseline_for_G9__c, Show_Endline_for_G9__c, Show_Interest_for_G9__c, Show_Mid_Program_for_G9__c, Show_Quiz_1_for_G9__c, Show_Quiz_2_for_G9__c, Show_Reality_for_G9__c,
                                                     Show_Student_Details_for_G10__c, Select_Forms_to_Show_in_Baseline_for_G10__c, Select_Forms_to_Show_in_Endline_for_G10__c, Show_Aptitude_for_G10__c, Show_Baseline_for_G10__c, Show_Endline_for_G10__c, Show_Interest_for_G10__c, Show_Mid_Program_for_G10__c, Show_Quiz_1_for_G10__c, Show_Quiz_2_for_G10__c, Show_Reality_for_G10__c,
                                                     Show_Student_Details_for_G11__c, Select_Forms_to_Show_in_Baseline_for_G11__c, Select_Forms_to_Show_in_Endline_for_G11__c, Show_Aptitude_for_G11__c, Show_Baseline_for_G11__c, Show_Endline_for_G11__c, Show_Interest_for_G11__c, Show_Mid_Program_for_G11__c, Show_Quiz_1_for_G11__c, Show_Quiz_2_for_G11__c, Show_Reality_for_G11__c,
                                                     Show_Student_Details_for_G12__c, Select_Forms_to_Show_in_Baseline_for_G12__c, Select_Forms_to_Show_in_Endline_for_G12__c, Show_Aptitude_for_G12__c, Show_Baseline_for_G12__c, Show_Endline_for_G12__c, Show_Interest_for_G12__c, Show_Mid_Program_for_G12__c, Show_Quiz_1_for_G12__c, Show_Quiz_2_for_G12__c, Show_Reality_for_G12__c 
                                              FROM District_Master__c 
                                              WHERE Id = :schoolDetails.District__c];
        return districtDetails;
    }
    
    public class wrpSession{
        
        @AuraEnabled
        public string id;
        
        @AuraEnabled
        public string name;
        
        @AuraEnabled
        public date sessionDate;
        
        @AuraEnabled
        public string facilitatorId;
        
        @AuraEnabled
        public string facilitatorName;
        
        @AuraEnabled
        public string WhereClause;
        
        @AuraEnabled
        public Boolean isParentSession;       
        
        @AuraEnabled
        public time startTime;
        
        @AuraEnabled
        public time endTime;
        
        @AuraEnabled
        public string link;
        
        @AuraEnabled
        public boolean isSessionDate;
        
        @AuraEnabled
        public boolean isAttendenceFound;
        
        @AuraEnabled
        public boolean isNotLoggedInTrainerSession;
        
        @AuraEnabled
        public string grade;
        
        @AuraEnabled
        public string mode;
    }
    
    public class picklistwrapper {
        @AuraEnabled
        public String label { get; set; }
        
        @AuraEnabled
        public String value { get; set; }
        
        public picklistwrapper(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }

}