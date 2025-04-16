public without sharing class studentAttendanceController {
    @AuraEnabled
    public static Object checkEmailExist(String stremail) {
        Map<String, Object> result = new Map<String, Object>();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('CA_Trainer')
            .getRecordTypeId();
        Double acadYear = 0.0;
        string labelForDomain = System.Label.Antarang_Domain;
        Contact c = new Contact();
        if((String.isNotBlank(stremail) && stremail.contains('@') && labelForDomain.contains(stremail.split('@').get(1)))) {
               for (Contact objcon : [
                   SELECT id, npe01__WorkEmail__c, Academic_Year__c
                   FROM contact
                   WHERE npe01__WorkEmail__c = :stremail AND RecordTypeId = :recordTypeId
                   AND (Academic_Year__c =: antarangSett.Academic_Year__c OR Academic_Year__c =: antarangSett.Next_Academic_Year__c)	// updated: 23.03.2023 - Only Acad year or Next Acad year Fac. can log in the form
                   AND Facilitator_Work_Status__c = 'Active'	//updated on 08.03.2023
                   ORDER BY CreatedDate DESC
                   LIMIT 1
               ]) {
                   c = objcon;
                   acadYear = c.Academic_Year__c;	//added: 23.03.202
               }
           }
        system.debug('::acadYear = '+acadYear);
        result.put('grade', getdynamicpicklistval('Batch__c', 'Grade__c'));
        result.put('contact', c);
        result.put('pendingsessionlist', [Select Id,Batch__c,Batch__r.Batch_Number__c,Batch__r.Name,Name,SessionDate__c 
                                          from Session__c
                                          where Batch__r.Trainer_Name__c =: c.Id AND SessionDate__c < :system.today() AND 
                                          Batch__r.Dummy_Batch__c = False AND Assigned_Facilitator__c =: c.Id AND // added on 29.09.2022
                                          Attendance_Count__c = 0 AND Batch__r.Academic_Year__c =: acadYear AND	//updated 23.03.2023
                                         Session_Type__c != 'Counseling']);
        return result;
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
    
    /*commented on 03/05/2023 @AuraEnabled
    public static List<Session__c> sessionRecords(string batchId){
        
        //List<Batch__c> batch = new List<Batch__c>([Select Id,Facilitation_Start_Date__c From Batch__c where Id = :batchId]);
        //String sessionGrade = '';
        //if(batch.size() > 0){
        //    if(batch[0].Facilitation_Start_Date__c.year() == Date.today().year()){
        //        sessionGrade = 'Class 9';
        //    } else {
        //         sessionGrade = 'Class 10';
        //     }
        // }
        
        list<Session__c> sessionLst = new list<Session__c>([
            select id,Name,Payment_made__c,Batch__c,SessionDate__c ,Session_Delivery__c,
            Session_Grade__c,Session_Type__c from session__c where 
            Batch__c =: batchId and 
            SessionDate__c != null and Session_Type__c != 'Counseling'/* and
            Session_Delivery__c != 'Asynchronous' and
Session_Grade__c = :sessionGrade
        ]);
        return sessionLst;
        
    }*/
    
    @AuraEnabled
    public static Object lstsessionRecords(string batchId, String facilitatorId, String SelectedGrade){
        
        List<Batch__c> batch = new List<Batch__c>([Select Id,Grade__c,Facilitation_Start_Date__c,
                                                   (Select Id From Contacts__r),(Select Id From Contacts1__r),
                                                   (Select Id From Contacts2__r) From Batch__c 
                                                   where Trainer_Name__c = :facilitatorId AND Id = :batchId]);
        String sessionGrade = '';
        if(batch.size() > 0){
            //need to change to dynamic 
            /*date dt = date.newInstance(Date.today().year(), 5, 1);*/
            date dt = date.newInstance(Date.today().year(), 5, 1);
            date d = date.newInstance(System.Today().year()-1,6,1);
            //if(batch[0].Facilitation_Start_Date__c >= dt){
            /*if(batch[0].Facilitation_Start_Date__c >= d && batch[0].Facilitation_Start_Date__c <= dt){
sessionGrade = 'Class 9';
} else {
sessionGrade = 'Class 10';
}*/
            sessionGrade = batch.get(0).Grade__c != '' ? batch.get(0).Grade__c : '';
        }
        
        Map<String, Object> result = new Map<String, Object>();
        //Map<String, Boolean> sessWithPreSessAttSub = new Map<String, Boolean>();
        //commented on 03/08/2023
        //session picklist
        List<picklistwrapper> options = new List<picklistwrapper>();
        options.add(new picklistwrapper('None', ''));
        List<Session__c> sessionLST = new List<Session__c>([
            select id,Name,Attendance_Submitted__c from session__c where 
            Batch__c =: batchId and 
            Assigned_Facilitator__c =: facilitatorId and
            SessionDate__c != null and 
             Session_Type__c != 'Counseling' /*AND Session_Delivery__c != 'Asynchronous' and
Session_Grade__c = :sessionGrade*/ AND 
            SessionDate__c <= :system.today() 
            ORDER BY Session_Number__c ]);
        
        for (Integer i = 0 ; i < sessionLST.size() ; i++) 
        {
            options.add(
                new picklistwrapper(sessionLST[i].Name, String.valueOf(sessionLST[i].Id))
            );
            //commented on 03/08/2023
            /*if(i != 0){
                sessWithPreSessAttSub.put(sessionLST[i].Id,sessionLST[i-1].Attendance_Submitted__c);
            }*/
        }
        if(sessionLST.size() > 0){
            result.put('sessionData',options);
        }
        //commented on 03/08/2023
        /*if(sessWithPreSessAttSub.size() > 0){
            result.put('sessWithPreSessSubmitedAtt',sessWithPreSessAttSub);
        }*/
        //commented on 03/08/2023
        /*if(SelectedGrade == 'Grade 9'){
            result.put('totalStdInBatch',batch.get(0).Contacts__r.size());
        } else if(SelectedGrade == 'Grade 10'){
            result.put('totalStdInBatch',batch.get(0).Contacts1__r.size());
        } else if(SelectedGrade == 'Grade 11'){
            result.put('totalStdInBatch',batch.get(0).Contacts2__r.size());
        }*/
        //result.put('studentData',[Select Id,Name From Contact where Batch_Code__c = :batchId]);
        //result.put('studentData',[Select Id,Name From Student__c where Batch__c = :batchId]);
        
        return result;
        
    }
    
    @AuraEnabled
    public static Object showAllStudentSessionData(string batchId, String facilitatorId){
    	List<Batch__c> batch = new List<Batch__c>([Select Id,Grade__c,Facilitation_Start_Date__c From Batch__c where Id = :batchId]);
        String sessionGrade = '';
        if(batch.size() > 0){
            //need to change to dynamic 
            /*date dt = date.newInstance(Date.today().year(), 5, 1);*/
            date dt = date.newInstance(Date.today().year(), 5, 1);
            date d = date.newInstance(System.Today().year()-1,6,1);
            //if(batch[0].Facilitation_Start_Date__c >= dt){
            /*if(batch[0].Facilitation_Start_Date__c >= d && batch[0].Facilitation_Start_Date__c <= dt){
sessionGrade = 'Class 9';
} else {
sessionGrade = 'Class 10';
}*/
            sessionGrade = batch.get(0).Grade__c != '' ? batch.get(0).Grade__c : '';
        }
        
        Map<String, Object> result = new Map<String, Object>();
        //session picklist
        List<picklistwrapper> options = new List<picklistwrapper>();
        options.add(new picklistwrapper('None', ''));
        List<Session__c> sessionLST = new List<Session__c>([
            select id,Name from session__c where 
            Batch__c =: batchId and 
            SessionDate__c != null and Assigned_Facilitator__c=:facilitatorId AND
             Session_Type__c != 'Counseling' /*AND Session_Delivery__c != 'Asynchronous' and
Session_Grade__c = :sessionGrade*/ ORDER BY Session_Number__c ]);
        
        for (Session__c pickListVal : sessionLST) 
        {
            options.add(
                new picklistwrapper(pickListVal.Name, String.valueOf(pickListVal.Id))
            );
        }
        if(sessionLST.size() > 0){
            result.put('sessionData',options);
        } else {
            
        }
        
        result.put('studentData',[Select Id,Name From Contact where Batch_Code__c = :batchId]);
        //result.put('studentData',[Select Id,Name From Student__c where Batch__c = :batchId]);
        
        return result;
    }
    
    @AuraEnabled
    public static Object prepareMatrix(String batchId, String facilitatorId, List<String> sessionID, String selectedGrade){
        Map<String, Object> result = new Map<String, Object>();
        Boolean isSessionTypeParent = false;
        system.debug('batchId ' + batchId);
        system.debug('sessionID ' + sessionID);
        List<studentAttendance> studentMatrix = new List<studentAttendance>();
        Map<Id,Boolean> sessionWithExpire = new Map<Id,Boolean>();
        Map<String,Session_Attendance__c> stdExistingAttendance = new Map<String,Session_Attendance__c>();
        for(Session__c sess :[
            Select Id,SessionDate__c,Session_Type__c From Session__c Where 
            Id IN: sessionID and 
            SessionDate__c != null
        ]){
            //Integer dt1 = (system.today()).daysBetween(Date.valueOf(sess.SessionDate__c));
            //start change for Auguest month 
            // if(dt1 <= -3){
            //    sessionWithExpire.put(sess.Id,true);
            // } else {
            sessionWithExpire.put(sess.Id,false);
            // }
            //end change for Auguest month 
            if(sess.Session_Type__c == 'Parent'){
                isSessionTypeParent = true;
            }
            
        }
        
        Map<Id,Session__C> sessionMap = new Map<Id,Session__C>([select id,Attendance_Submitted__c,Total_Student_Present__c,
                                                                batch__r.Name,Session_Number__c,
                                                                batch__r.Batch_Number_edit__c,Session_Grade__c,
                                                                Total_Parent_Present__c from 
                                                                Session__c where Id IN: sessionID]);
        
        for(Session_Attendance__c sessionAttend :[
            Select Id,Contact__c,Attendance__c,Guardian_Parent_Attendance__c,Session__c,Session__r.Batch__r.Name,Session__r.Session_Grade__c From
            Session_Attendance__c where Session__c IN :sessionID ORDER BY Session__r.Session_Number__c]){
                stdExistingAttendance.put(sessionAttend.Contact__c+'_'+sessionAttend.Session__c,sessionAttend);
            }
        String conQuery = 'Select Id,Name From Contact';
        if(selectedGrade == 'Grade 9'){
            conQuery += ' where Batch_Code__c = :batchId order by Name';
        } else if(selectedGrade == 'Grade 10'){
            conQuery += ' where G10_Batch_Code__c = :batchId order by Name';
        } else if(selectedGrade == 'Grade 11'){
            conQuery += ' where G11_Batch_Code__c = :batchId order by Name';
        }else if(selectedGrade == 'Grade 12'){
            conQuery += ' where G12_Batch_Code__c = :batchId order by Name';
        }
        for(Contact con : Database.query(conQuery)){
            studentAttendance stdAttend = new studentAttendance();
            
            stdAttend.studentName = con.Name;
            stdAttend.studentId = con.Id;
            
            List<sessionData> sesdata = new List<sessionData>();
            for(String sessId : sessionID){
                if(stdAttend.batchName == null)
                    stdAttend.batchName = sessionMap.get(sessId).batch__r.Batch_Number_edit__c+' - '+ sessionMap.get(sessId).Batch__r.Name;
                if(stdAttend.className == null)
                    stdAttend.className = sessionMap.get(sessId).Session_Grade__c;
                sessionData sessData = new sessionData();
                sessData.sessionId = sessId;
                sessData.isSessionTwoOrMoreDaysOld = sessionWithExpire.get(sessId);
                if(stdExistingAttendance.containsKey(con.Id+'_'+sessId)){
                    sessData.stdAttendance = stdExistingAttendance.get(con.Id+'_'+sessId).Attendance__c; 
                    sessData.parentAttendance = stdExistingAttendance.get(con.Id+'_'+sessId).Guardian_Parent_Attendance__c; 
                    sessData.sessionAttendanceId = stdExistingAttendance.get(con.Id+'_'+sessId).Id;
                    
                } else {
                    
                    sessData.stdAttendance = '';   
                    sessData.parentAttendance = '';
                    sessData.sessionAttendanceId = '';
                }
                sesdata.add(sessData);
            }
            stdAttend.sessiondata = sesdata;
            studentMatrix.add(stdAttend);
        }
        
        List<Batch__c> batch = new List<Batch__c>([Select Id,Grade__c,Facilitation_Start_Date__c From Batch__c 
                                                   where Trainer_Name__c = :facilitatorId AND Id = :batchId]);
        
        List<Session__c> sessionLST = new List<Session__c>([
            select id,Name,Attendance_Submitted__c from session__c where 
            Batch__c =: batchId and 
            Assigned_Facilitator__c =: facilitatorId and
            SessionDate__c != null and 
             Session_Type__c != 'Counseling' AND 
            SessionDate__c <= :system.today() 
            ORDER BY Session_Number__c ]);
        
        Map<String, Boolean> sessWithPreSessAttSub = new Map<String, Boolean>();
        
        for (Integer i = 0 ; i < sessionLST.size() ; i++) 
        {
            if(i != 0){
                sessWithPreSessAttSub.put(sessionLST[i].Id,sessionLST[i-1].Attendance_Submitted__c);
            }
        }
		if(sessWithPreSessAttSub.size() > 0){
            result.put('sessWithPreSessSubmitedAtt',sessWithPreSessAttSub);
        }
        
        
        result.put('studentdata',studentMatrix);
        result.put('attendancepicklist', getdynamicpicklistval('Session_Attendance__c','Attendance__c'));
        result.put('parentattendancepicklist', getdynamicpicklistval('Session_Attendance__c','Guardian_Parent_Attendance__c'));
        result.put('logreasonpicklist', getdynamicpicklistval('Session__c','Log_Reason__c'));
        result.put('isSessionTypeParent', isSessionTypeParent);
        result.put('selectedSessionNumber', sessionMap.get(sessionID[0]).Session_Number__c);
        result.put('isAttendanceSubmited', sessionMap.get(sessionID[0]).Attendance_Submitted__c);
        result.put('studentPresented', sessionMap.get(sessionID[0]).Total_Student_Present__c);
        result.put('parentPresented', sessionMap.get(sessionID[0]).Total_Parent_Present__c);
        return result;
    }
    
    @AuraEnabled
    public static void saveStudentAttendance(List<studentAttendance> studentAttendance){
        List<Session_Attendance__c> sessionAttend = new List<Session_Attendance__c>();
        List<Session_Attendance__c> deleteSessionAttend = new List<Session_Attendance__c>();
        
        
        if(studentAttendance.size() > 0){
            for(studentAttendance std : studentAttendance){
                for(sessionData sess : std.sessiondata){
                    if(String.isNotBlank(sess.stdAttendance) || String.isNotBlank(sess.parentAttendance)){
                        //if(string.isBlank(sess.sessionAttendanceId) || string.isEmpty(sess.sessionAttendanceId)){
                            Session_Attendance__c stdAttend = new Session_Attendance__c();
                        	if(string.isNotEmpty(sess.sessionAttendanceId)) stdAttend.Id = sess.sessionAttendanceId;
                            if(string.isEmpty(sess.sessionAttendanceId)) stdAttend.Contact__c = std.studentId;
                            if(string.isEmpty(sess.sessionAttendanceId)) stdAttend.Session__c = sess.sessionId;
                            stdAttend.Attendance__c = sess.stdAttendance;
                            stdAttend.Guardian_Parent_Attendance__c = sess.parentAttendance;
                            sessionAttend.add(stdAttend);
                       // }
                        
                        
                    } else {
                        if(String.isNotBlank(sess.sessionAttendanceId)){
                            Session_Attendance__c delSessAttend = new Session_Attendance__c(Id = sess.sessionAttendanceId);
                            deleteSessionAttend.add(delSessAttend);
                        }
                    }
                }
            }
        }
        
        if(sessionAttend.size() > 0){
            upsert sessionAttend;
            
            
        }
        
        if(deleteSessionAttend.size() > 0){
            delete deleteSessionAttend;
        }
    }
    
    @AuraEnabled
    //public static List<studentAttendance> findSessionAtt(string accountId){
    public static Map<String,Object> findSessionAtt(string accountId, String selectedGrade, String facilitatorId){ 

        Map<String,Object> returnValues = new Map<String,Object>();
        date twoYearBack = date.newInstance(System.Today().addYears(-2).year(), 5, 1);
        date oneYearAfter = date.newInstance(System.Today().addYears(1).year(), 4, 30);
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        Double facilatorAcademicYr = 0.0;
        //added 24-2-23 start
        Contact facilatorAcademic = [select id,Academic_Year__c from Contact where id= :facilitatorId];
        if(facilatorAcademic != null){
            facilatorAcademicYr = facilatorAcademic.Academic_Year__c;
        }//added 24-2-23 ends
        List<contact> conlst = [select id,name,batch_code__r.Name,batch_code__r.Facilitation_Start_Date__c,batch_code__c,
                                batch_code__r.Batch_number__c,batch_code__r.Grade__c from contact
                                where batch_code__r.school_name__c =:accountId AND
                                batch_code__r.Grade__c =: selectedGrade 
                                AND batch_code__r.Academic_Year__c =: antarangSett.Academic_Year__c
                                AND batch_code__r.Facilitation_Start_Date__c != null /*AND
                                batch_code__r.Facilitation_Start_Date__c >=: twoYearBack AND 
                                batch_code__r.Facilitation_Start_Date__c <=: oneYearAfter*/
                                ORDER BY batch_code__r.Facilitation_Start_Date__c desc ];
        
        
        List<studentAttendance> studentMatrix = new List<studentAttendance>();
        
        date dt = date.newInstance(Date.today().year(), 5, 1);
        //batch picklist
        List<picklistwrapper> options = new List<picklistwrapper>();
        options.add(new picklistwrapper('-None-', ''));
        for(Contact con : conlst){
            studentAttendance stdAttend = new studentAttendance();
            stdAttend.studentName = con.Name;
            stdAttend.studentId = con.Id;
            stdAttend.batchName =  con.batch_code__r.Batch_number__c;
            stdAttend.className = con.batch_code__r.Grade__c != '' ? con.batch_code__r.Grade__c : '';    
            
            
            
            studentMatrix.add(stdAttend);
        }
        for(Batch__c bc : [select id,Name,Facilitation_Start_Date__c,
                           Batch_number__c,Grade__c from Batch__c
                           where school_name__c =:accountId AND
                           Grade__c =: selectedGrade 
                           AND /*Academic_Year__c =: antarangSett.Academic_Year__c  */ //commented on 24.02.2023
                           Academic_Year__c =: facilatorAcademicYr //added on 24.02.2023
                           AND Trainer_Name__c =: facilitatorId
                           AND Dummy_Batch__c = False // added on 29.09.2022
                           ORDER BY Facilitation_Start_Date__c desc ]){
                               
                               options.add(
                                   new picklistwrapper(bc.Batch_number__c +' - '+bc.Name, String.valueOf(bc.Id))
                               );
                               
                           }
        
        returnValues.put('studentAttendance',studentMatrix);
        returnValues.put('batchOptions',options);
        
        return returnValues;
        
        
    }
    
    @AuraEnabled
    public static void submitAttendance(String sessId, String logReason){
        system.debug('sessId : ' + sessId);
        List<Session__c> sessLST = new List<Session__c>([
            Select Id,Attendance_Submitted__c,Payment_Status__c,Log_Reason__c From Session__c Where Id =: sessId
        ]);
        
        if(sessLST.size() > 0){
            sessLST.get(0).Attendance_Submitted__c = true;
            sessLST.get(0).Payment_Status__c = sessLST.get(0).Payment_Status__c == null ? 'Ready For Payment' : sessLST.get(0).Payment_Status__c;
            sessLST.get(0).Log_Reason__c = String.isNotBlank(logReason) ? logReason : '';
            update sessLST;
        }
    }
    /* commented on 03/03/2023
    public static Map<String,Object> getBatchList(string accountId, String selectedGrade){ 
        Map<String,Object> returnValues = new Map<String,Object>();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        List<picklistwrapper> options = new List<picklistwrapper>();
        options.add(new picklistwrapper('-None-', ''));
        for(Batch__c bc : [select id,Name,Facilitation_Start_Date__c,
                           Batch_number__c,Grade__c from Batch__c
                           where school_name__c =:accountId AND
                           Grade__c =: selectedGrade 
                           AND Academic_Year__c =: antarangSett.Academic_Year__c
                           ORDER BY Facilitation_Start_Date__c desc ]){
                               
                               options.add(
                                   new picklistwrapper(bc.Batch_number__c +' - '+bc.Name, String.valueOf(bc.Id))
                               );
                               
                           }
        returnValues.put('batchOptions',options);
        
        return returnValues;
    }*/
    
    @AuraEnabled
    public static void savePresentedStudentCount(String sessionId, Integer presentCount, Integer parentPresentCnt){
        List<Session__c> sessionLst = new List<Session__c>([
            Select Id,Session_Number__c,Payment_Status__c,Total_Student_Present__c,Total_Parent_Present__c From Session__c where Id =:sessionId
        ]);
        
        if(sessionLst.size() > 0){
            sessionLst.get(0).Total_Parent_Present__c = parentPresentCnt;
            sessionLst.get(0).Total_Student_Present__c = presentCount;
            //Commented on 26-sep-2022
            //if(sessionLst.get(0).Session_Number__c == 1 || sessionLst.get(0).Session_Number__c == 2){
                sessionLst.get(0).Payment_Status__c = sessionLst.get(0).Payment_Status__c == null ? 'Ready For Payment' : sessionLst.get(0).Payment_Status__c;
            //}
            update sessionLst;
        }
    }
    
    /*@AuraEnabled
    public static void sendEmailForSessionDetails(String stdAttend, String sessopnOptions, String emailId){
        system.debug('stdAttend : ' + stdAttend);
        system.debug('sessopnOptions : ' + sessopnOptions);
        system.debug('emailId : ' + emailId);
        List<studentAttendance> stdAttendLST = (List<studentAttendance>)JSON.deserialize(stdAttend, studentAttendance.class);
        List<picklistwrapper> sessopnOptionsLST = (List<picklistwrapper>)JSON.deserialize(sessopnOptions, picklistwrapper.class);
        system.debug('stdAttendLST : ' + stdAttendLST);
        system.debug('sessopnOptionsLST : ' + sessopnOptionsLST);
        List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
        
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setSubject('An error Occured');
        
        String errorLogs = '<table border="1"><thead><tr><th>Batch Code</th><th>Student Name</th>';
        for(picklistwrapper pick : sessopnOptions){
            errorLogs += '<th>' + pick.label + '</th>';
        }
        errorLogs += '</tr>';
        
        for(studentAttendance std : stdAttend){
            errorLogs += '<tr><td>' + std.batchName + '</td>';
            errorLogs += '<td>' + std.studentName + '</td>';
            for(sessionData sess : std.sessionData){
                errorLogs += '<td>' + sess.isChecked + '</td>';
            }
            errorLogs += '</tr>';
        }
        errorLogs += '</table>';
        
        msg.setHTMLbody(errorLogs);
        msg.setToAddresses(new List<String>{emailId});
        
        lstMsgs.add(msg);
        
        if(!Test.isRunningTest())
        {
            Messaging.sendEmail(lstMsgs);
        }
    }*/
    
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
    
    public class studentAttendance {
        @AuraEnabled
        public String studentName { get; set; }
        
        @AuraEnabled
        public String batchName { get; set; }
        
        @AuraEnabled
        public String className { get; set; }
        
        @AuraEnabled
        public String studentId { get; set; }
        
        @AuraEnabled
        public List<sessionData> sessiondata { get; set; }
    }
    
    public class sessionData {
        @AuraEnabled
        public String sessionId { get; set; }
        
        @AuraEnabled
        public String sessionAttendanceId { get; set; }
        
        @AuraEnabled
        public boolean isSessionTwoOrMoreDaysOld { get; set; }
        
        @AuraEnabled
        public String stdAttendance { get; set; }
        
        @AuraEnabled
        public String parentAttendance { get; set; }
    }
}