public with sharing class loginPageController {
    
    @AuraEnabled
    public static Object checkEmailExist(String stremail) {
        Map<String, Object> result = new Map<String, Object>();
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('CA_Trainer')
            .getRecordTypeId();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults(); 
        
        result.put('grade', getdynamicpicklistval('Batch__c', 'Grade__c'));
        Contact c = new Contact();
        
        if((String.isNotBlank(stremail) && stremail.contains('@') && stremail.split('@').get(1) == 'antarangfoundation.org') 
            || stremail == 'farheen.s@kandisatech.com') {
            for (Contact objcon : [ SELECT id, npe01__WorkEmail__c
                                    FROM contact
                                    WHERE npe01__WorkEmail__c = :stremail AND RecordTypeId = :recordTypeId
                                   //AND Academic_Year__c =: antarangSett.Next_Academic_Year__c
                                    ORDER BY CreatedDate DESC
                                    LIMIT 1 ]) {
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
    public static Integer assessmentData(string batchId){ 
        
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        system.debug('batchId :: '+batchId+' antarangSett.Academic_Year__c ::'+antarangSett.Academic_Year__c);
        //Student__c stuList =[ SELECT COUNT(Id)cId FROM Student__c WHERE Batch__c = :batchId ];
        List<Student__c> stuList =[ SELECT Id, Name, Batch__c 
                              FROM Student__c 
                              WHERE Batch__c = :batchId ];
        system.debug('studentlst :: '+stuList.size());
        return stuList.size();
    }

    @AuraEnabled
    //public static List<studentAttendance> findSessionAtt(string accountId){
    public static Map<String,Object> findBatch(string accountId, String selectedGrade){ 
        
        Map<String,Object> returnValues = new Map<String,Object>();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        system.debug('accountId :: '+accountId+' selectedGrade :: '+selectedGrade+' antarangSett.Next_Academic_Year__c'+antarangSett.Next_Academic_Year__c+'antarangSett.Academic_Year__c ::'+antarangSett.Academic_Year__c);
        List<Batch__c> batchlst = [ SELECT id,Name, Facilitation_Start_Date__c, Batch_number__c,Grade__c 
                                    FROM Batch__c 
                                    WHERE (school_name__c =:accountId AND 
                                           Grade__c =:selectedGrade AND 
                                           Academic_Year__c =: antarangSett.Academic_Year__c AND 
                                           Dummy_Batch__c = False) 
                                    ORDER BY Facilitation_Start_Date__c desc ];
                                /*AND Batch__r.Facilitation_Start_Date__c != null AND
                                batch_code__r.Facilitation_Start_Date__c >=: twoYearBack AND 
                                batch_code__r.Facilitation_Start_Date__c <=: oneYearAfter*/
                                
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
        //for loop deleted
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

/*@AuraEnabled(cacheable=true)
public static List<Contact> checkFacilitatorEmail(String emailId){
    //String facilitatorEmail = '%' + emailId + '%';
    return [ SELECT Id, Name, Title, Phone, Email
                FROM Contact
                WHERE Email LIKE :emailId
                WITH SECURITY_ENFORCED
                LIMIT 1 ];
}

@AuraEnabled(cacheable=true)
public static List<Batch__c> assessmentData(Id batchId){
    
    return [ SELECT Id, Name, Batch_Number__c, Year__c, Faci__c, School_State__c, Remarks__c, School_Name__c, Trainer_Name__c, Academic_Year__c, Total_Amount_Batch__c, Total_Amount_Counselling__c, Facilitation__c, Grade__c, Copy_of_Batch__c 
                FROM Batch__c
                WHERE Id = :batchId
                WITH SECURITY_ENFORCED
                LIMIT 1 ];
}*/