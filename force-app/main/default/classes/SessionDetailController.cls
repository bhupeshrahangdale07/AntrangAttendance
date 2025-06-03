/**
* @File Name : SessionDetailController.cls
* @Description : This class is for Student Attendance 
* @Author : Twinkle Khapekar
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | 06/05/2025 |  Twinkle Khapekar | Initial Version
**/
public without sharing class SessionDetailController {

    /**@Description : This method is used for saving the late scheduled sessions **/
    @AuraEnabled
    public static boolean saveLateSchedule(List<Session__c> sessionList){
        boolean status =  true;
        try{
            if (!sessionList.isEmpty()) {
                update sessionList;
                status = true;
            }
        }catch(exception e){
            throw new AuraHandledException('Error while fetching sessions: ' + e.getMessage());
        }
        return status;
    }

    /**@Description : Method to save the student Attendance from student Attendance and Parent Attendance form **/
    @AuraEnabled
    public static boolean saveStudentAttendance(List<studentAttendance> studentAttendanceList, boolean saveAttendance, string sessionId,
                                                string reason) {
                                                    boolean status = false;
                                                    try{
                                                        
                                                        System.debug('studentAttendanceList = ' + studentAttendanceList);
                                                        
                                                        List<Session_Attendance__c> sessionAttend = new List<Session_Attendance__c>();
                                                        List<Session_Attendance__c> deleteSessionAttend = new List<Session_Attendance__c>();
                                                        
                                                        if (!studentAttendanceList.isEmpty()) {
                                                            for (studentAttendance std : studentAttendanceList) {
                                                                if ((String.isNotBlank(std.stdAttendance)) || std.stdWrongBatch == true) {
                                                                    Session_Attendance__c stdAttend = new Session_Attendance__c();
                                                                    
                                                                    if (String.isNotEmpty(std.sessionAttendanceId)) {
                                                                        stdAttend.Id = std.sessionAttendanceId;
                                                                    } else {
                                                                        stdAttend.Contact__c = std.studentId;
                                                                        stdAttend.Session__c = std.sessionId;
                                                                    }
                                                                    
                                                                    stdAttend.Attendance__c = std.stdAttendance;
                                                                    stdAttend.Guardian_Parent_Attendance__c = std.parentAttendance;
                                                                    stdAttend.Wrong_Batch__c = std.stdWrongBatch;
                                                                    stdAttend.Session_Lead__c = std.stdLead;
                                                                    stdAttend.Counseling_Date__c = std.stdCounselingDate;
                                                                    stdAttend.Counseling_Time__c = std.stdCounselingTime;
                                                                    
                                                                    system.debug('std.stdWrongBatch- '+std.stdWrongBatch);
                                                                    sessionAttend.add(stdAttend);
                                                                } else if (String.isNotBlank(std.sessionAttendanceId)) {
                                                                    deleteSessionAttend.add(new Session_Attendance__c(Id = std.sessionAttendanceId));
                                                                }
                                                            }
                                                        }
                                                        
                                                        if (!sessionAttend.isEmpty()) {
                                                            upsert sessionAttend;
                                                        }
                                                        
                                                        if (!deleteSessionAttend.isEmpty()) {
                                                            delete deleteSessionAttend;
                                                        }
                                                        if(saveAttendance == true){
                                                            session__c session = [select id,Attendance_Submitted__c,Log_Reason__c from session__c where id = :sessionId limit 1];
                                                            session.Attendance_Submitted__c = true;
                                                            session.Log_Reason__c = reason;
                                                            session.Session_Status__c = 'Complete';
                                                            update session;
                                                        }
                                                        status = true;
                                                    }catch(exception e){
                                                        throw new AuraHandledException('Error while fetching sessions: ' + e.getMessage());
                                                    }
                                                    return status;
                                                    
                                                }
    
    /**@Description : Method to show the list of sessions availble for the facilitator **/
    @AuraEnabled
    public static List<wrpSession> lstsessionRecords(string batchId,string loggedInTrainer){
        
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        List<wrpSession> wrpSessionLSt = new List<wrpSession>();
        
        for(Session__c objSession : [select Id,Name,SessionDate__c,Session_Delivery__c,Session_Number__c,Total_Student_Present__c,
                                     Session_Link__c,Session_Grade__c,Session_Type__c,HM_Attended__c,Session_Lead__c,Attendance_Submitted__c,
                                     Session_Code__c,Session_End_Time__c,Session_Start_Time__c, Session_Mode__c,Total_Parent_Present__c,
                                     Assigned_Facilitator__c,Assigned_Facilitator__r.Name,Assigned_Facilitator__r.npe01__WorkEmail__c,
                                     Session_Status__c,Scheduling_Type__c,Rescheduled_Counter__c,Late_Schedule__c,
                                     (select id from Sessions__r limit 1)
                                     from session__c where Batch__c =: batchId
                                     order by session_Number__c ]){
                                         wrpSession objwrp = new wrpSession();
                                         objwrp.id = objSession.Id;
                                         objwrp.WhereClause = ' AND RecordType.DeveloperName = \'CA_Trainer\' AND Academic_Year__c = '+Integer.valueOf(antarangSett.Academic_Year__c)+' ORDER BY Name';//antarangSett.Academic_Year__c != null ? Integer.valueOf(antarangSett.Academic_Year__c) : null;
                                         objwrp.name = objSession.Name;
                                         objwrp.grade = objSession.Session_Grade__c;
                                         objwrp.mode = objSession.Session_Mode__c;
                                         objwrp.facilitatorId = objSession.Assigned_Facilitator__c;
                                         objwrp.facilitatorName = objSession.Assigned_Facilitator__c != null ? objSession.Assigned_Facilitator__r.Name : '';
                                         objwrp.sessionDate = objSession.SessionDate__c;
                                         objwrp.status = objSession.Session_Status__c;
                                         objwrp.statusClassName = (objSession.Session_Status__c == 'Ready for Attendance') ? 'ReadyforAttendanceCls' : objSession.Session_Status__c + 'Cls' ;
                                         objwrp.link = objSession.Session_Link__c;
                                         objwrp.endTime = objSession.Session_End_Time__c;
                                         objwrp.startTime = objSession.Session_Start_Time__c;
                                         objwrp.parentAttendance =  objSession.Total_Parent_Present__c != null ? objSession.Total_Parent_Present__c : 0;
                                         objwrp.studentAttendance =  objSession.Total_Student_Present__c != null ? objSession.Total_Student_Present__c : 0;
                                         objwrp.hmAttended = objSession.HM_Attended__c != null ? objSession.HM_Attended__c : '';
                                         objwrp.sessionLead = objSession.Session_Lead__c != null ? objSession.Session_Lead__c : '';
                                         objwrp.scheduleOnTime = (objSession.Scheduling_Type__c == 'On Time') ? true : false;
                                         objwrp.scheduleLate = (objSession.Scheduling_Type__c == 'Late Schedule') ? true : false;
                                         objwrp.scheduleCounter = (objSession.Rescheduled_Counter__c == null) ? 0 : objSession.Rescheduled_Counter__c;
                                         objwrp.reasonForLateSchedule = objSession.Late_Schedule__c;
                                         objwrp.attendanceSubmitted = objSession.Attendance_Submitted__c;
                                         objwrp.sessionNumber = objSession.Session_Number__c;
                                         //objwrap.sessionStatus = objSession.Session_Status__c;
                                         if((
                                             objSession.Total_Student_Present__c > 0 ) ||
                                            objSession.Sessions__r.size() > 0 && objSession.SessionDate__c != null){
                                                objwrp.isAttendenceFound = true;
                                            }else{
                                                objwrp.isAttendenceFound = false;
                                            }
                                         if(objSession.Assigned_Facilitator__c != null && objSession.Assigned_Facilitator__c == loggedInTrainer){
                                             objwrp.isNotLoggedInTrainerSession = false;
                                         }else{
                                             objwrp.isNotLoggedInTrainerSession = true;
                                         }
                                         if(objSession.Session_Type__c == 'Parent'){
                                             objwrp.isParentSession = true;
                                         }else{
                                             objwrp.isParentSession = false;
                                         }         
                                         if(objSession.Session_Type__c == 'Student'){
                                             objwrp.isStudentSession = true;
                                         }else{
                                             objwrp.isStudentSession = false;
                                         }
                                         if(objSession.Session_Type__c == 'Flexible'){
                                             objwrp.isFlexibleSession = true;
                                         }else{
                                             objwrp.isFlexibleSession = false;
                                         }
                                         if(objSession.Session_Type__c == 'Counseling'){
                                             objwrp.isCounselingSession = true;
                                         }else{
                                             objwrp.isCounselingSession = false;
                                         }
                                         wrpSessionLSt.add(objwrp);
                                         
                                     }
        return wrpSessionLSt;
        
    }
    
    /**@Description :This method is used to retrieve the list of school options.**/
    @AuraEnabled(cacheable=true)
    public static List<Account> getSchoolList(string facilitorId) {
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        set<string> schoolId = new set<string>();
        list<session__c> lstSession = [select id,Batch__r.School_Name__r.name,Batch__r.School_Name__c,Batch_Academic_Year__c from session__c where 
                                       Assigned_Facilitator__c = :facilitorId and (Batch_Academic_Year__c =: antarangSett.Academic_Year__c OR 
                                                                                   Batch_Academic_Year__c =: antarangSett.Next_Academic_Year__c)];
        for(session__c sess : lstSession){
            schoolId.add(sess.Batch__r.School_Name__c);
        }
        
        return [SELECT Id, Name,Academic_Year__c FROM Account where RecordType.Name = 'school' and 
                (Academic_Year__c =: antarangSett.Academic_Year__c OR 
                 Academic_Year__c =: antarangSett.Next_Academic_Year__c) AND id in :schoolId];
    }
    
     /**@Description : Method to sign out from Student Attendance page**/
    @AuraEnabled
    public static boolean sessionSignOut(String strEmail){
        boolean signOut = false;
        try{
            if(!String.isEmpty(strEmail)){
                list<contact> fac = [SELECT id, npe01__WorkEmail__c, Form_Login__c FROM contact WHERE id =:strEmail limit 1];
                fac[0].Form_Login__c = false;
                update fac;
                signOut = true;
            }
        }catch(exception e){
            throw new AuraHandledException('Error while fetching sessions: ' + e.getMessage());
        }
        return signOut;
        
    }

    /**@Description : Method to retrive the Batch code related to School, Trainer and Grade**/
    @AuraEnabled
    public static List<picklistwrapper> getBatch(String grade,String schoolId, string trainerId){
        List<picklistwrapper> options = new List<picklistwrapper>();
        try{
            AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
            set<string> batchId = new set<string>();
            list<session__c> lstSession = [select id,Batch__c,Batch__r.School_Name__r.name,Batch__r.School_Name__c,Batch_Academic_Year__c,Session_Grade__c from session__c 
                                           where Assigned_Facilitator__c = :trainerId and (Batch_Academic_Year__c =: antarangSett.Academic_Year__c OR 
                                                                                           Batch_Academic_Year__c =: antarangSett.Next_Academic_Year__c) and Session_Grade__c = :grade];
            for(session__c sess : lstSession){
                batchId.add(sess.Batch__c);
            }
            
            
            list<batch__c> lstBatch = [SELECT id, Batch_Number__c from Batch__c where Grade__c = :grade and School_Name__c = :schoolId and 
                                       (Academic_Year__c =: antarangSett.Academic_Year__c OR 
                                        Academic_Year__c =: antarangSett.Next_Academic_Year__c) AND Dummy_Batch__c = False and id in :batchId];
            options.add(new picklistwrapper('--None--', ''));
            for (batch__c batch : lstBatch) {
                options.add(
                    new picklistwrapper(batch.Batch_Number__c , batch.Id)
                );
            }
        }catch(exception e){
            throw new AuraHandledException('Error while fetching sessions: ' + e.getMessage());
        }
        return options;
    }

    /**@Description : Method to retrive picklist values for different fields **/
    @AuraEnabled
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

    /**@Description : This method is used to get pendingSession for popup**/
    @AuraEnabled
    public static Map<String, Map<String,String>> getPendingSessionData(String stremail) {
        Map<String, Map<String,String>> schoolSessionMap = new Map<String, Map<String,String>>();
        try{
            if(!String.isEmpty(strEmail)){
                AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
                List<Session__c> sessions = [
                    SELECT 
                    Id, 
                    Batch__r.School_Name__r.Name, 
                    Batch__r.Grade__c, 
                    Batch__r.Batch_Number__c, Session_Status__c 
                    FROM 
                    Session__c 
                    WHERE 
                    Session_Status__c != 'Complete' 
                    AND Assigned_Facilitator__c = :stremail
                    AND (Batch__r.Academic_Year__c =: antarangSett.Academic_Year__c OR 
                         Batch__r.Academic_Year__c =: antarangSett.Next_Academic_Year__c) order by Batch__r.School_Name__r.Name,Batch__r.Grade__c	
                ];
                system.debug('sessions = '+sessions);
                system.debug('sessions = '+[select id from Session__c]);
                system.debug('a = '+antarangSett.Academic_Year__c);
                system.debug('b ='+antarangSett.Next_Academic_Year__c);
                for (Session__c session : sessions) {
                    String schoolName = session.Batch__r.School_Name__r.Name;
                    String mergedValue = session.Batch__r.Grade__c + ' - ' + session.Batch__r.Batch_Number__c;
                    String mergedIds = '?sId='+session.Batch__r.School_Name__c+'&bId='+session.Batch__c+'&grade='+session.Batch__r.Grade__c;
                    if (!schoolSessionMap.containsKey(schoolName)) {
                        schoolSessionMap.put(schoolName, new Map<String,String>());
                    }
                    
                    if (!schoolSessionMap.get(schoolName).containsKey(mergedValue)) {
                        schoolSessionMap.get(schoolName).put(mergedValue,mergedIds);
                    }
                }
            }
        }catch(exception e){
            throw new AuraHandledException('Error while fetching sessions: ' + e.getMessage());
        }
        return schoolSessionMap;
    }
    
    /**@Description : This method is use for getting Student Session Data**/
    @AuraEnabled
    public static Object getSessionStudent(String batchId, String facilitatorId, String sessionID, String selectedGrade){
        Map<String, Object> result = new Map<String, Object>();
        //Boolean isSessionTypeParent = false;
        string sessionName = '';
        system.debug('batchId ' + batchId);
        system.debug('sessionID ' + sessionID);
        List<studentAttendance> studentMatrix = new List<studentAttendance>();
        Map<Id,Boolean> sessionWithExpire = new Map<Id,Boolean>();
        Map<String,Session_Attendance__c> stdExistingAttendance = new Map<String,Session_Attendance__c>();
        //for(Session__c sess :[
        List<Session__c> session = [Select Id, Name, SessionDate__c,Session_Type__c,Attendance_Submitted__c From Session__c 
                                    Where Id =: sessionID];
        
        //]){
        //Integer dt1 = (system.today()).daysBetween(Date.valueOf(sess.SessionDate__c));
        //start change for Auguest month 
        // if(dt1 <= -3){
        //    sessionWithExpire.put(sess.Id,true);
        // } else {
        //sessionWithExpire.put(sess.Id,false);
        // }
        //end change for Auguest month 
        // if(sess.Session_Type__c == 'Parent'){
        //     isSessionTypeParent = true;
        // }
        
        //}
        
        Map<Id,Session__C> sessionMap = new Map<Id,Session__C>([select id,Attendance_Submitted__c,Total_Student_Present__c,
                                                                batch__r.Name,Session_Number__c,
                                                                batch__r.Batch_Number_edit__c,Session_Grade__c,
                                                                Total_Parent_Present__c from 
                                                                Session__c where Id =: sessionID]);
        System.debug('sessionMap- '+ sessionMap);
        
        for(Session_Attendance__c sessionAttend :[
            Select Id,Contact__c,Attendance__c,Wrong_Batch__c,Session_Lead__c,Guardian_Parent_Attendance__c,Counseling_Date__c,Counseling_Time__c,Session__c,Session__r.Batch__r.Name,Session__r.Session_Grade__c From
            Session_Attendance__c where Session__c = :sessionID ORDER BY Session__r.Session_Number__c]){
                stdExistingAttendance.put(sessionAttend.Contact__c+'_'+sessionAttend.Session__c,sessionAttend);
            }
        String conQuery = 'Select Id,Name From Contact';
        if(selectedGrade == 'Grade 9'){
            conQuery += ' where Batch_Code__c = :batchId order by Name,Bar_Code__c';
        } else if(selectedGrade == 'Grade 10'){
            conQuery += ' where G10_Batch_Code__c = :batchId order by Name,Bar_Code__c';
        } else if(selectedGrade == 'Grade 11'){
            conQuery += ' where G11_Batch_Code__c = :batchId order by Name,Bar_Code__c';
        }else if(selectedGrade == 'Grade 12'){
            conQuery += ' where G12_Batch_Code__c = :batchId order by Name,Bar_Code__c';
        }
        system.debug('std- '+Database.query(conQuery));
        for(Contact con : Database.query(conQuery)){
            studentAttendance stdAttend = new studentAttendance();
            
            stdAttend.studentName = con.Name;
            system.debug('Std Name- '+con.Name);
            stdAttend.studentId = con.Id;
            
            List<sessionData> sesdata = new List<sessionData>();
            //for(String sessId : sessionID){
            // if(stdAttend.batchName == null)
            //     stdAttend.batchName = sessionMap.get(sessionID).batch__r.Batch_Number_edit__c+' - '+ sessionMap.get(sessionID).Batch__r.Name;
            // if(stdAttend.className == null)
            //     stdAttend.className = sessionMap.get(sessionID).Session_Grade__c;
            sessionData sessData = new sessionData();
            sessData.sessionId = sessionID;
            sessData.isSessionTwoOrMoreDaysOld = sessionWithExpire.get(sessionID);
            if(stdExistingAttendance.containsKey(con.Id+'_'+sessionID)){
                sessData.stdAttendance = stdExistingAttendance.get(con.Id+'_'+sessionID).Attendance__c; 
                sessData.stdWrongBatch = stdExistingAttendance.get(con.Id+'_'+sessionID).Wrong_Batch__c; 
                sessData.parentAttendance = stdExistingAttendance.get(con.Id+'_'+sessionID).Guardian_Parent_Attendance__c; 
                sessData.stdLead = stdExistingAttendance.get(con.Id+'_'+sessionID).Session_Lead__c;
                sessData.stdCounselingDate = stdExistingAttendance.get(con.Id+'_'+sessionID).Counseling_Date__c;
                sessData.stdCounselingTime = stdExistingAttendance.get(con.Id+'_'+sessionID).Counseling_Time__c;
                sessData.sessionAttendanceId = stdExistingAttendance.get(con.Id+'_'+sessionID).Id;
                
            } else {
                
                sessData.stdAttendance = '';   
                sessData.parentAttendance = '';
                sessData.stdLead = '';
                //sessData.stdCounselingDate = '';
                //sessData.stdCounselingTime = '';
                sessData.sessionAttendanceId = '';
                sessData.stdWrongBatch = false;
                
            }
            sesdata.add(sessData);
            //}
            stdAttend.sessiondata = sesdata;
            stdAttend.stdAttendance = sesdata[0].stdAttendance;
            stdAttend.stdWrongBatch = sesdata[0].stdWrongBatch;
            stdAttend.stdLead = sesdata[0].stdLead;
            stdAttend.stdCounselingDate = sesdata[0].stdCounselingDate;
            stdAttend.stdCounselingTime = sesdata[0].stdCounselingTime;
            stdAttend.sessionAttendanceId = sesdata[0].sessionAttendanceId;
            stdAttend.parentAttendance = sesdata[0].parentAttendance;
            stdAttend.sessionId = sesdata[0].sessionId;
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
        
        result.put('SessionData',session);
        result.put('studentdata',studentMatrix);
        result.put('attendancepicklist', getdynamicpicklistval('Session_Attendance__c','Attendance__c'));
        result.put('parentattendancepicklist', getdynamicpicklistval('Session_Attendance__c','Guardian_Parent_Attendance__c'));
        //result.put('logreasonpicklist', getdynamicpicklistval('Session__c','Log_Reason__c'));
        //result.put('isSessionTypeParent', isSessionTypeParent);
        if(sessionMap != null && sessionMap.containsKey(sessionID)){
            //if(sessionMap.get(sessionID).Session_Number__c != null){
            result.put('selectedSessionNumber', sessionMap.get(sessionID).Session_Number__c);
            //}
            //if(sessionMap.get(sessionID).Attendance_Submitted__c != null){
            result.put('isAttendanceSubmited', sessionMap.get(sessionID).Attendance_Submitted__c);
            //}
            // if(sessionMap.get(sessionID).Total_Student_Present__c != null){
            result.put('studentPresented', sessionMap.get(sessionID).Total_Student_Present__c);
            //}
            //if(sessionMap.get(sessionID).Total_Parent_Present__c != null){
            result.put('parentPresented', sessionMap.get(sessionID).Total_Parent_Present__c);
            //}
        }
        return result;
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
        public Boolean isCounselingSession; 
        
        @AuraEnabled
        public Boolean isStudentSession; 
        
        @AuraEnabled
        public time startTime;
        
        @AuraEnabled
        public Decimal parentAttendance;
        
        @AuraEnabled
        public Decimal studentAttendance;

        @AuraEnabled
        public Decimal sessionNumber;
        
        @AuraEnabled
        public string hmAttended;
        
        @AuraEnabled
        public string sessionLead;
        
        @AuraEnabled
        public time endTime;
        
        @AuraEnabled
        public string link;
        
        @AuraEnabled
        public boolean isSessionDate;
        
        
        @AuraEnabled
        public boolean isAttendenceFound;

        @AuraEnabled
        public boolean attendanceSubmitted;
     
        
        @AuraEnabled
        public boolean isNotLoggedInTrainerSession;
        
        @AuraEnabled
        public string grade;
        
        @AuraEnabled
        public string mode;
        
        @AuraEnabled
        public string status;
        
        @AuraEnabled
        public string statusClassName;
        
        @AuraEnabled
        public boolean scheduleOnTime;
        
        @AuraEnabled
        public boolean scheduleLate;
        
        @AuraEnabled
        public Decimal scheduleCounter;
        
        @AuraEnabled
        public String reasonForLateSchedule;
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
        public String stdAttendance { get; set; }
        
        @AuraEnabled
        public Boolean stdWrongBatch { get; set; }  
        
        @AuraEnabled
        public String stdLead { get; set; } 

        @AuraEnabled
        public Date stdCounselingDate {get; set;} 

        @AuraEnabled
        public Time stdCounselingTime {get; set;}
        
        @AuraEnabled
        public String sessionAttendanceId { get; set; }
        
        @AuraEnabled
        public String parentAttendance { get; set; }
        
        @AuraEnabled
        public List<sessionData> sessiondata { get; set; }
        
        @AuraEnabled
        public String sessionId { get; set; }
        
        @AuraEnabled
        public boolean attSubmited { get; set; }
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
        public Boolean stdWrongBatch { get; set; }
        
        @AuraEnabled
        public String parentAttendance { get; set; }
        
        @AuraEnabled
        public String lateReason { get; set; }
        
        @AuraEnabled
        public String stdLead { get; set; }

        @AuraEnabled
        public Date stdCounselingDate {get; set;} 

        @AuraEnabled
        public Time stdCounselingTime {get; set;}
    }
}