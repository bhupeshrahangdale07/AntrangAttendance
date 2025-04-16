public without sharing class sessionFormController {
    
    @AuraEnabled
    public static Object checkEmailExist(String stremail) {
        Map<String, Object> result = new Map<String, Object>();
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('CA_Trainer')
            .getRecordTypeId();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults(); // updated: 23.03.2023
        
        result.put('grade', getdynamicpicklistval('Batch__c', 'Grade__c'));
        Contact c = new Contact();
        string labelForDomain = System.Label.Antarang_Domain;
        if((String.isNotBlank(stremail) && stremail.contains('@') && labelForDomain.contains(stremail.split('@').get(1)))) {
            for (Contact objcon : [
            SELECT id, npe01__WorkEmail__c
            FROM contact
            WHERE npe01__WorkEmail__c = :stremail AND RecordTypeId = :recordTypeId
                AND (Academic_Year__c =: antarangSett.Academic_Year__c OR Academic_Year__c =: antarangSett.Next_Academic_Year__c)	// updated: 23.03.2023 - Only Acad year or Next Acad year Fac. can log in the form
                AND Facilitator_Work_Status__c = 'Active'	//updated on 08.03.2023
                ORDER BY CreatedDate DESC
            LIMIT 1
        ]) {
            c = objcon;
        }
        
        result.put('contact', c);
        return result;
        }else{
            result.put('contact', c);
        return result;
        }
        
    }
    
    @AuraEnabled
    //public static List<studentAttendance> findSessionAtt(string accountId){
    public static Map<String,Object> findBatch(string accountId, String selectedGrade, String traineremail){ 
        //updated: 23.02.2023 - get Fac. Acad year
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Trainer').getRecordTypeId();
        Decimal acadYear = 0.0;
        Contact c = [Select Id, Name, npe01__WorkEmail__c, Academic_Year__c
                     From Contact
                     Where npe01__WorkEmail__c = :traineremail AND RecordTypeId = :recordTypeId             
                     ORDER BY CreatedDate DESC
                     LIMIT 1];
        acadYear = c.Academic_Year__c;
        
        Map<String,Object> returnValues = new Map<String,Object>();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        system.debug('accountId :: '+accountId+' selectedGrade :: '+selectedGrade+'antarangSett.Academic_Year__c ::'+antarangSett.Academic_Year__c);
        List<Batch__c> batchlst = [select id,Name,Facilitation_Start_Date__c,
                                Batch_number__c,Grade__c 
                                   from Batch__c
                                where school_name__c =:accountId AND
                                Grade__c =: selectedGrade 
                                //AND Academic_Year__c =: antarangSett.Academic_Year__c
                                AND Academic_Year__c =: acadYear	//updated: 23.02.2023
                                   AND Dummy_Batch__c = False                                   
                                /*AND Batch__r.Facilitation_Start_Date__c != null AND
                                batch_code__r.Facilitation_Start_Date__c >=: twoYearBack AND 
                                batch_code__r.Facilitation_Start_Date__c <=: oneYearAfter*/
                                ORDER BY Facilitation_Start_Date__c desc ];
        system.debug('studentlst :: '+batchlst);
        List<picklistwrapper> options = new List<picklistwrapper>();
        options.add(new picklistwrapper('-None-', ''));
        for(Batch__c bc : batchlst){
            
            options.add(
                new picklistwrapper(bc.Batch_number__c +' - '+bc.Name, String.valueOf(bc.Id))
            );
            
        }
        
        returnValues.put('batchOptions',options);
        
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
        /*
        List<Batch__c> batch = new List<Batch__c>([Select Id,Facilitation_Start_Date__c From Batch__c where Id = :batchId]);
        String sessionGrade = '';
        if(batch.size() > 0){
            //need to change to dynamic 
           /* date dt = date.newInstance(Date.today().year(), 4, 30);
            date d = date.newInstance(Date.today().year()-1, 5, 1);*/
        /*    date d = date.newInstance(System.Today().year()-1,6,1);
            date dt = date.newInstance(System.Today().year(),6,30); //
            if(batch[0].Facilitation_Start_Date__c >= d && batch[0].Facilitation_Start_Date__c <= dt){
                sessionGrade = 'Class 9';
            } else {
                sessionGrade = 'Class 10';
            }
        }*/
        
       List<wrpSession> wrpSessionLSt = new List<wrpSession>();
        
        for(Session__c objSession : [select Id,Name,SessionDate__c,Session_Delivery__c,Session_Number__c,Total_Student_Present__c,
                                                            Session_Link__c,Session_Grade__c,Session_Type__c,
                                                            Session_Code__c,Session_End_Time__c,Session_Start_Time__c, Session_Mode__c,
                                     Assigned_Facilitator__c,Assigned_Facilitator__r.Name,Assigned_Facilitator__r.npe01__WorkEmail__c,
                                                            (select id from Sessions__r limit 1)
                            from session__c where Batch__c =: batchId /*AND Session_Grade__c = :sessionGrade*/ AND Session_Type__c != 'Counseling' /*AND Session_Type__c != 'Parent'*/ order by session_Number__c ]){
                                wrpSession objwrp = new wrpSession();
                                objwrp.id = objSession.Id;
                                objwrp.WhereClause = ' AND RecordType.DeveloperName = \'CA_Trainer\' AND Academic_Year__c = '+Integer.valueOf(antarangSett.Academic_Year__c)+' ORDER BY Name';//antarangSett.Academic_Year__c != null ? Integer.valueOf(antarangSett.Academic_Year__c) : null;
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
                                if(objSession.Session_Type__c == 'Flexible'){
                                     objwrp.isFlexibleSession = true;
                                }else{
                                    objwrp.isFlexibleSession = false;
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
        Contact selectedStudent= [SELECT Id,Bar_Code__c From Contact Where Id=:contactId];
        // system.debug(' @@@ contact Id : '+selectedStudent.Id);
        // system.debug(' @@@ contact Barcode : '+selectedStudent.Bar_Code__c);
        return selectedStudent;
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
        public Boolean isFlexibleSession; 
        
        
        @AuraEnabled
        public time startTime;
        
        @AuraEnabled
        public time endTime;
        
        @AuraEnabled
        public string link;
        
        @AuraEnabled
        public boolean isSessionDate;
        
      /*  @AuraEnabled
        public string delivery;
        
        @AuraEnabled
        public string type;
        
        @AuraEnabled
        public string code;*/
        
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