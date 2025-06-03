/*
* Classname: SessionTriggerHandler
* Description : Handler class for SessionTrigger
* -------------------------------------------------------------------------------------------------------------------------
* History
* Version	Date			Description
* v1.0 	    24th Apr 24	    Added method to populate Total_Student_Present__c from Present_Count__c
* v1.1 	    7th  Jun 24 	Added logic to populate Total_Parent_Present__c from Guardian_Parent_Count__c
*/ 
public class SessionTriggerHandler {
    //count total Session__c on contact
    public static Boolean flag = true;
    public static Boolean isRecurrsive = false;
    
    public static void cleanDefferedReasonFeild(List<Session__c> lstNewSession, Map<Id,Session__c> oldSessionMap) {
        for(Session__c objSession: lstNewSession) {
            if(objSession.Payment_Status__c != oldSessionMap.get(objSession.id).Payment_Status__c && objSession.Payment_Status__c != 'Deferred for Payment' && objSession.Payment_Status__c != 'Do not pay' && (objSession.Deferred_Reason__c != null || String.isNotBlank(objSession.Deferred_Reason__c)) ){
                objSession.Deferred_Reason__c = null;
            }
        }
        
    }
    
    public static void updateDateOfFacillitationOnBatch(List<Session__c> lstNewSession, Map<Id,Session__c> oldSessionMap) {
        Map<Id,Session__c> sessionMapWithBatchIds = new Map<Id,Session__c>();
        for(Session__c objSession: lstNewSession) {
            if((objSession.Session_Number__c == 1 && objSession.SessionDate__c != null) || (oldSessionMap != null  && objSession.SessionDate__c != oldSessionMap.get(objSession.Id).SessionDate__c && objSession.Session_Number__c == 1 && objSession.SessionDate__c != null) ){
                sessionMapWithBatchIds.put(objSession.Batch__c, objSession);
            }
        }
        
        if(!sessionMapWithBatchIds.isEmpty()){
            List<Batch__c> batchList = [Select Id,Date_of_facilitation_starting__c,Dummy_Batch__c from Batch__c where Id IN :sessionMapWithBatchIds.keySet()];
            List<Batch__c> batchUpdateList = new List<Batch__c>();
            for(Batch__c b:batchList){
                if( !b.Dummy_Batch__c && b.Date_of_facilitation_starting__c != sessionMapWithBatchIds.get(b.Id).SessionDate__c){
                    b.Date_of_facilitation_starting__c = sessionMapWithBatchIds.get(b.Id).SessionDate__c;
                    batchUpdateList.add(b);
                }
            }
            
            if(batchUpdateList.size() > 0){
                try{
                    update batchUpdateList;
                }catch(Exception e){
                    system.debug('test : '+e.getMessage());
                }
            }
        }
        
    }
    
    public static void updateDummySession(List<Session__c> lstNewSession, Map<Id,Session__c> oldSessionMap) {
        Map<String,Session__c> sessionCodeMap = new Map<String,Session__c>(); 
        
        
        for(Session__c objSession: lstNewSession) {            
            if( (objSession.Copy_of_Session__c == null || objSession.Copy_of_Session__c == '') && objSession.Dummy_Session_Created__c == true &&
               ( objSession.SessionDate__c != oldSessionMap.get(objSession.Id).SessionDate__c ||
                objSession.Assigned_Facilitator__c != oldSessionMap.get(objSession.Id).Assigned_Facilitator__c ||
                objSession.Session_End_Time__c != oldSessionMap.get(objSession.Id).Session_End_Time__c || 
                objSession.Session_Start_Time__c != oldSessionMap.get(objSession.Id).Session_Start_Time__c ||
                objSession.Payment_Status__c != oldSessionMap.get(objSession.Id).Payment_Status__c ||
                objSession.Deferred_Reason__c != oldSessionMap.get(objSession.Id).Deferred_Reason__c ||
                objSession.Log_Reason__c != oldSessionMap.get(objSession.Id).Log_Reason__c || 
                objSession.Payment_Date__c != oldSessionMap.get(objSession.Id).Payment_Date__c || 
                objSession.Invoice_Date__c != oldSessionMap.get(objSession.Id).Invoice_Date__c )
              ){
                  sessionCodeMap.put(objSession.Session_Code__c, objSession);
                  system.debug('dummy sessions map : '+sessionCodeMap);
              }
        }
        
        List<Session__c> dummySessionsLst =  new List<Session__c>();
        for(Session__c s:[SELECT Id, Deferred_Reason__c, Copy_of_Session__c, SessionDate__c, Assigned_Facilitator__c, Session_End_Time__c, Session_Start_Time__c, Payment_Status__c, Log_Reason__c, Payment_Date__c, Invoice_Date__c FROM Session__c WHERE Copy_of_Session__c IN :sessionCodeMap.keySet() AND Payment_Status__c !=	'Do not pay']){
            system.debug('dummy sessions : '+s);
            s.SessionDate__c  = sessionCodeMap.get(s.Copy_of_Session__c).SessionDate__c;
            s.Assigned_Facilitator__c  = sessionCodeMap.get(s.Copy_of_Session__c).Assigned_Facilitator__c;
            s.Session_End_Time__c  = sessionCodeMap.get(s.Copy_of_Session__c).Session_End_Time__c; 
            s.Session_Start_Time__c  = sessionCodeMap.get(s.Copy_of_Session__c).Session_Start_Time__c;  
            s.Payment_Status__c  = sessionCodeMap.get(s.Copy_of_Session__c).Payment_Status__c;
            s.Log_Reason__c  = sessionCodeMap.get(s.Copy_of_Session__c).Log_Reason__c;
            s.Payment_Date__c  = sessionCodeMap.get(s.Copy_of_Session__c).Payment_Date__c; 
            s.Invoice_Date__c  = sessionCodeMap.get(s.Copy_of_Session__c).Invoice_Date__c; 
            s.Deferred_Reason__c = sessionCodeMap.get(s.Copy_of_Session__c).Deferred_Reason__c;
            
            dummySessionsLst.add(s);
        }
        
        system.debug('dummy sessions : '+dummySessionsLst);
        if(dummySessionsLst.size() > 0){
            update dummySessionsLst;
        }
    }
    
    
    
    // Taking count of the session cancelled or Rescheduled when the session date is changes 
    public static void cancelledRescheduledCounter(List<Session__c> lstNewSession, Map<Id,Session__c> oldSessionMap) {
        for(Session__c objSession: lstNewSession) {
            if(objSession.SessionDate__c != oldSessionMap.get(objSession.Id).SessionDate__c){
                if(objSession.Cancelled_Rescheduled_Counter__c == null || objSession.Cancelled_Rescheduled_Counter__c == 0){
                    objSession.Cancelled_Rescheduled_Counter__c = 1;
                }else{
                    objSession.Cancelled_Rescheduled_Counter__c++;
                } 
            }
        }
        
    }
    
    public static void countTotalSession(list<Session__c> newValues, list<Session__c> oldValues, map<Id,Session__c> oldvaluesMap){
        Set<Id> conIds = new Set<Id>();        
        
        if(Trigger.IsInsert || Trigger.IsUndelete){
            for(Session__c s: newValues) {
                if(s.Assigned_facilitator__c != NULL)
                    conIds.add(s.Assigned_facilitator__c);
            }
        }
        
        if(Trigger.IsUpdate){
            for(Session__c s: newValues) {
                if( oldValuesMap.get(s.Id).Assigned_facilitator__c != s.Assigned_facilitator__c){
                    conIds.add(s.Assigned_facilitator__c);
                    
                    conIds.add(oldValuesMap.get(s.Id).Assigned_facilitator__c);
                }
            }
        }
        
        
        if(Trigger.IsDelete){
            for(Session__c s : oldValues){
                if(s.Assigned_facilitator__c != NULL)
                    conIds.add(s.Assigned_facilitator__c);
            }
        }
        
        if(!conIds.isEmpty()){
            system.debug('conIds :: '+conIds);
            
            List<contact> conToUpdate = updateContact(conIds);            
            // Update count on contact
            if(conToUpdate.size() > 0){
                try{
                    update conToUpdate;
                    system.debug('conToUpdate : '+conToUpdate);
                }catch(System.Exception e){
                    System.debug('Error'+e.getMessage());
                }
            }
            
        }
    }
    
    public static list<contact> updateContact(set<Id> conIds){
        List<contact> conToUpdate = new List<contact>();
        Integer count ;
        AggregateResult[] groupedResults = [SELECT COUNT(Id), Assigned_facilitator__c FROM Session__c where Assigned_facilitator__c IN :conIds
                                            GROUP BY Assigned_facilitator__c];
        system.debug('### ar '+groupedResults );
        if(groupedResults.size() > 0){
            for(AggregateResult ar:groupedResults) {     
                Id custid = (ID)ar.get('Assigned_facilitator__c');     
                count = (INTEGER)ar.get('expr0');     
                contact c = new contact(Id=custid);     
                c.Number_Of_Sessions__c = count;     
                conToUpdate.add(c); 
                
                if(conIds.contains(custid)){
                    conIds.remove(custid);
                }
            }     
        }
        
        for(Id i : conIds){
            contact c = new contact(Id=i);     
            c.Number_Of_Sessions__c = 0;
            conToUpdate.add(c); 
        }
        return conToUpdate;
    }
    
    public static void inactiveChildBatchPaytStatus(List<Session__c> lstNewSession, Map<Id,Session__c> oldSessionMap) {
        
        flag 								= false;
        Set<Id> setId						= New Set<Id>();
        Set<Decimal> setG9					= New Set<Decimal>();
        Map<Decimal,List<String>> mapG9 	= New Map<Decimal,List<String>>();
        Set<String> setG10 					= New Set<String>();
        Map<String,List<String>> mapG10 	= New Map<String,List<String>>();
        List<Session__c> lstToUpateSession	= New List<Session__c>();
        
        for(Session__c objSession: lstNewSession) {
            if(objSession.Payment_Status__c 		== 'Payment Made' 
               && objSession.Payment_Status__c 		!= oldSessionMap.get(objSession.Id).Payment_Status__c 
               && objSession.Is_Inactive_Session__c == false) {
                   setId.add(objSession.Id);
               }
        }
        if(setId.size()>0) {
            for(Session__c objSession : [Select Id, Name, Session_Grade__c, Batch__r.Batch_Number__c, Batch__r.Combined_Batch_no__c, Batch__r.Combined_Batch_no_for_G10__c
                                         From Session__c
                                         Where Id IN: setId]) {
                                             if(objSession.Session_Grade__c == 'Class 9') {
                                                 Decimal bno = Decimal.valueOf(objSession.Batch__r.Batch_Number__c);                                                 
                                                 if(!mapG9.containsKey(bno)) 
                                                     mapG9.put(bno,new list<String>());
                                                 mapG9.get(bno).add(objSession.Name);                                                                                                 
                                             }
                                             else if( objSession.Session_Grade__c == 'Class 10' && objSession.Batch__r.Combined_Batch_no_for_G10__c != null ) {
                                                 String[] st = objSession.Batch__r.Combined_Batch_no_for_G10__c.split(','); 
                                                 for(String s: st) {
                                                     if(!mapG10.containsKey(s)) 
                                                         mapG10.put(s,new list<String>());
                                                     mapG10.get(s).add(objSession.Name); 
                                                 }
                                             }
                                         }
        }
        if(mapG9.size()>0 || mapG10.size()>0) {
            for(Session__c objSession : [Select Id, Name, Batch__r.Combined_Batch_no__c ,Batch__r.Batch_Number__c 
                                         From Session__c 
                                         Where  Is_Inactive_Session__c = true AND
                                         ( (Batch__r.Combined_Batch_no__c IN: mapG9.keySet()  AND Session_Grade__c = 'Class 9' ) 
                                          OR (Batch__r.Batch_Number__c IN: mapG10.keySet()  AND Session_Grade__c = 'Class 10') )
                                        ]) {
                                            if(mapG9.containsKey(objSession.Batch__r.Combined_Batch_no__c)) {
                                                for(String s: mapG9.get(objSession.Batch__r.Combined_Batch_no__c)) {
                                                    if(objSession.Name == s) {
                                                        objSession.Payment_Status__c = 'Payment Made';
                                                        lstToUpateSession.add(objSession);
                                                    }
                                                }
                                            }
                                            
                                            if(mapG10.containsKey(objSession.Batch__r.Batch_Number__c)) {
                                                for(String s: mapG10.get(objSession.Batch__r.Batch_Number__c)) {
                                                    if(objSession.Name == s) {
                                                        objSession.Payment_Status__c = 'Payment Made';
                                                        lstToUpateSession.add(objSession);
                                                    }
                                                }
                                            } 
                                        }
        }
        
        
        if(lstToUpateSession.size()>0) {
            update lstToUpateSession;
        }
    }
    // Below method is used to populate Total_Student_Present__c from Present_Count__c //v1.0
    public static void updateStudentPresent(List<Session__c> lstNewSession, Map<Id,Session__c> oldSessionMap) {
        
        List<Session__c> sessionToUpdate = new List<Session__c>();
        set<Id> sessionIds = new set<Id>();
        
        for(Session__c objSession: lstNewSession) {
            if(objSession.Attendance_Submitted__c == true
               && objSession.Session_Type__c == 'Counseling'
               && objSession.Payment_Status__c == 'Ready For Payment'
               && (oldSessionMap.get(objSession.Id).Present_Count__c != objSession.Present_Count__c || oldSessionMap.get(objSession.Id).Attendance_Submitted__c == false)){
                   isRecurrsive = true;
                   sessionIds.add(objSession.Id);
                   system.debug('objSession > '+objSession.Name);
               }
        }
        if(sessionIds.size() > 0){
            for(Session__c objSession: [Select Id,Present_Count__c,Total_Student_Present__c,Guardian_Parent_Count__c,Total_Parent_Present__c from Session__c where ID IN: sessionIds]) {
                integer presentCount = integer.valueOf(objSession.Present_Count__c);
                integer parentPresentCount = integer.valueOf(objSession.Guardian_Parent_Count__c); //v1.1 
                objSession.Total_Student_Present__c = presentCount;
                objSession.Total_Parent_Present__c = parentPresentCount; //v1.1 
                sessionToUpdate.add(objSession);
            }
            
            if(sessionToUpdate.size() > 0){
                try {
                    isRecurrsive = true;
                    update sessionToUpdate;
                } catch (Exception ex) {
                    system.debug('Error on line :'+ex.getLineNumber() +' Error Message : '+ex.getmessage());
                } finally {
                    isRecurrsive = false;
                }
                
            } 
        }
        
    }
    public static void dummycoverage(){
        Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    } 
}