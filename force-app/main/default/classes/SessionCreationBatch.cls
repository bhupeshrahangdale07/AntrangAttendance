/**
* @File Name : SessionCreationBatch.cls
* @Description : Create Sessions and Its Attendence using Sessions_Historical_Mapping__c (Custom Settings)
* @Author : Srikanth Dasari
* @Last Modified By : Srikanth Dasari
* @Last Modified On : January 8, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | January 8, 2025 |  Srikanth Dasari | Initial Version
**/

global class SessionCreationBatch implements Database.Batchable<SObject>, Database.Stateful {
    private List<Sessions_Historical_Mapping__c> sessionTemplates;

    public SessionCreationBatch() {
        fetchSessionTemplates();
    }
    
    public void fetchSessionTemplates() {
        sessionTemplates = [SELECT Id, Name, Description__c, Grade__c, Payment__c, 
                                   Session_Delivery__c, Session_Number__c, Session_Type__c, 
                                   Session_Mode__c, OMR_Type_Required__c, Manually_Created__c, 
                                   Payment_Status__c 
                            FROM Sessions_Historical_Mapping__c];
    }
    
    global String query = '';
    /*
	global Boolean isSessionsCreated = false;
	global SessionCreationBatch(Boolean isSessionsCreated, String query) {
        this.isSessionsCreated = isSessionsCreated;
        this.query = query;
    }
    */
    global SessionCreationBatch(String query) {
        fetchSessionTemplates();
        this.query = query;
    }

    global Database.QueryLocator start(Database.BatchableContext context) {
        
        if(String.isBlank(query)){
            query = 'SELECT Id, Session_Count__c, Grade__c, Facilitation_Start_Date__c, Trainer_Name__c FROM Batch__c WHERE Session_Count__c = 0 AND Grade__c != null AND Academic_Year__c < 2021 AND Manual_Session_Att_creation__c = FALSE AND Trainer_Name__c != NULL AND Facilitation_Start_Date__c != NULL';
            
            /*
            if(this.isSessionsCreated){
                this.isSessionsCreated = false;
            } 
			*/
        }
        // return Database.getQueryLocator('SELECT Id, Grade__c, Facilitation_Start_Date__c, Trainer_Name__c FROM Batch__c where Grade__c != null AND Academic_Year__c < 2021 AND Manual_Session_Att_creation__c = FALSE'); 
        return Database.getQueryLocator(query);         
    }

    // Execute method
    global void execute(Database.BatchableContext context, List<SObject> scope) {
        List<Session__c> sessionsToInsert = new List<Session__c>();
        List<Batch__c> processedBatches = new List<Batch__c>();
		
        // if(isSessionsCreated){
            for (SObject record : scope) {
                Batch__c batch = (Batch__c) record; 
                String grade = batch.Grade__c;
                Date facilitationStartDate = batch.Facilitation_Start_Date__c;
                Id trainerId = batch.Trainer_Name__c; 
                
                // Validate batch data
                if (grade == null || facilitationStartDate == null || trainerId == null) {
                    System.debug('Skipping Batch record with missing data: ' + batch.Id);
                    continue;
                }
                
                for (Sessions_Historical_Mapping__c template : sessionTemplates) {
                    if (template.Grade__c == grade && template.Session_Number__c != null) {
                        sessionsToInsert.add(new Session__c(
                            Batch__c = batch.Id,
                            Name = template.Description__c,
                            Session_Grade__c = grade,
                            Session_Delivery__c = template.Session_Delivery__c,
                            Session_Number__c = template.Session_Number__c,
                            Session_Type__c = template.Session_Type__c,
                            Session_Mode__c = template.Session_Mode__c,
                            OMR_required__c = template.OMR_Type_Required__c,
                            Manually_Created__c = template.Manually_Created__c,
                            Payment_Status__c = template.Payment_Status__c,
                            SessionDate__c = facilitationStartDate,
                            Assigned_Facilitator__c = trainerId
                        ));
                    }
                }
                
                processedBatches.add(new Batch__c(Id=record.Id, Manual_Session_Att_creation__c = true));
            }
            

            if (!sessionsToInsert.isEmpty()) {
                Savepoint sp = Database.setSavepoint();
                try {
                    insert sessionsToInsert;
                    System.debug('Inserted ' + sessionsToInsert.size() + ' Session__c records.');
                    
                    createAttendance(sessionsToInsert);
                    
					update processedBatches;                    
                } catch (DmlException e) {
                    System.debug('Error inserting sessions: ' + e.getMessage());
                    Database.rollback(sp);
                    throw e;
                }
            }
        //}else{
          //  createAttendance((List<Session__c>) scope);
        //}
    }
    
    public static void createAttendance(List<Session__c> sessions){
            
        Map<Id, List<Session__c>> BatchToSessionsMap = new Map<Id, List<Session__c>>();
        for(Session__c s: sessions){
            if(BatchToSessionsMap.containsKey(s.Batch__c)){
                BatchToSessionsMap.get(s.Batch__c).add(s);                
            }else{
                BatchToSessionsMap.put(s.Batch__c, new List<Session__c>{s});
            }
        }
        
        system.debug('BatchToSessionsMap : '+BatchToSessionsMap);
        
        Map<Id, List<Contact>> G9BatchToStudentsMap = new Map<Id, List<Contact>>();
        Map<Id, List<Contact>> G10BatchToStudentsMap = new Map<Id, List<Contact>>();
        
        for(Contact con : [Select Id, Batch_Code__c, G10_Batch_Code__c, Guardian_Present__c, Counselling_Session_Attended__c, Day_1__c, Day_2__c, Day_3__c, Day_4__c, Day_5__c from Contact Where Batch_Code__c IN :BatchToSessionsMap.keySet() OR G10_Batch_Code__c  IN :BatchToSessionsMap.keySet()]){
            if(con.Batch_Code__c != null){
                if(G9BatchToStudentsMap.containsKey(con.Batch_Code__c)){
                    G9BatchToStudentsMap.get(con.Batch_Code__c).add(con);                
                }else{
                    G9BatchToStudentsMap.put(con.Batch_Code__c, new List<Contact>{con});
                }
            }
            
            if(con.G10_Batch_Code__c != null){
                if(G10BatchToStudentsMap.containsKey(con.G10_Batch_Code__c)){
                    G10BatchToStudentsMap.get(con.G10_Batch_Code__c).add(con);                
                }else{
                    G10BatchToStudentsMap.put(con.G10_Batch_Code__c, new List<Contact>{con});
                } 
            }
        }
        
        Map<Id, Session__c> sessionsMap = new Map<Id, Session__c>(sessions);
        
        system.debug('G9BatchToStudentsMap : '+G10BatchToStudentsMap.keySet());
        system.debug('G9BatchToStudentsMap : '+G10BatchToStudentsMap.values());
        system.debug('G10BatchToStudentsMap : '+G10BatchToStudentsMap.keySet());
        system.debug('G10BatchToStudentsMap : '+G10BatchToStudentsMap.values());
        
        List<Session_Attendance__c> sessionAttendance = new List<Session_Attendance__c>();
        if(!sessions.isEmpty()){
            for(Session__c s: sessions){
               List<Contact> StudentsMap = new List<Contact>();
                if(s.Session_Grade__c == 'Grade 9' && G9BatchToStudentsMap.containsKey(s.Batch__c)){
                    StudentsMap = G9BatchToStudentsMap.get(s.Batch__c);
                }else if(s.Session_Grade__c == 'Grade 10' && G10BatchToStudentsMap.containsKey(s.Batch__c)){
                    StudentsMap = G10BatchToStudentsMap.get(s.Batch__c);
                    system.debug('Block : '+StudentsMap);
                }
                
                for(Contact student : StudentsMap){
                    Session_Attendance__c att = studentAttendance(s, student);
                        sessionAttendance.add(att);
                }
            }
            
            if(!sessionAttendance.isEmpty()){
            	insert sessionAttendance;
            }
        }
        
    }
    
    public static Session_Attendance__c studentAttendance(Session__c Session, Contact Student){
        Session_Attendance__c attendance = new Session_Attendance__c(Session__c = Session.Id, Contact__c = Student.Id);
        
        switch on (Integer) Session.Session_Number__c {
            when 1 {
                attendance.Attendance__c = Student.Day_1__c == 'Present' ? 'Present' : 'Absent';
            }
            when 2 {
                attendance.Attendance__c = Student.Day_2__c == 'Present' ? 'Present' : 'Absent';
            }
            when 3 {
                attendance.Attendance__c = Student.Day_3__c == 'Present' ? 'Present' : 'Absent';
            }
            when 4 {
                attendance.Attendance__c = Student.Day_4__c == 'Present' ? 'Present' : 'Absent';
            }
            when 5 {
                attendance.Attendance__c = Student.Day_5__c == 'Present' ? 'Present' : 'Absent';
            }
            when 6 {
                attendance.Attendance__c = Student.Counselling_Session_Attended__c ? 'Present' : 'Absent';
                attendance.Guardian_Parent_Attendance__c = Student.Guardian_Present__c ? 'Present' : 'Absent';
            }
        }
        
        return attendance;
        
    }

    global void finish(Database.BatchableContext context) {
        System.debug('SessionCreationBatch job completed.');
    }
}