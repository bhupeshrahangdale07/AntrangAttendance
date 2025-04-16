public class SessionAttendanceTriggerHandler {
    
    //For Insert 
    public static void updateSessionOnInsert(List<Session_Attendance__c> newValues, Map<Id, Session_Attendance__c> oldMapValues){
        
        set<Id> sessionIds = new set<Id>();
        
        for(Session_Attendance__c objSessAttendance : newValues){
            if((oldMapValues == null && objSessAttendance.Session__c != null && objSessAttendance.Attendance__c != null) 
                || (oldMapValues != null && oldMapValues.get(objSessAttendance.Id).Attendance__c != objSessAttendance.Attendance__c)) {
                sessionIds.add(objSessAttendance.Session__c);
                }
        }
        
        if(sessionIds.size()>0){
            List<Session__c> sessionToUpdate = new List<Session__c>();
            for(Session__c objSession : [select id,batch__c,batch__r.school_Name__c
                                         from session__c where Id IN: sessionIds AND
                                         Payment_Status__c = null AND SessionDate__c != null])
            {
                
                Session__c s = new Session__c();
                s.Id = objSession.Id;
                s.Payment_Status__c = 'Ready For Payment';
                sessionToUpdate.add(s);
                
            }
            
            if(sessionToUpdate.size()>0){
                update sessionToUpdate;
            }
        }
            
            
           /* set<string> gradeSet = new set<String>();
            set<Id> schoolIds = new set<Id>();
            for(Session__c objSession : [select id,Session_Grade__c,batch__c,batch__r.school_Name__c from session__c where Id IN: sessionIds])
            {
                schoolIds.add(objSession.batch__r.school_Name__c);
                gradeSet.add(objSession.Session_Grade__c);
            }
            
            if(schoolIds.size()>0){
                
                List<Session__c> sessionToUpdate = new List<Session__c>();
                for(Session__c objSession : [select id,batch__c,batch__r.school_Name__c
                                             from session__c where batch__r.school_Name__c IN: schoolIds AND
                                             Session_Grade__c IN: gradeSet AND
                                             Payment_Status__c = null])
                {
                    
                    Session__c s = new Session__c();
                    s.Id = objSession.Id;
                    s.Payment_Status__c = 'Ready For Payment';
                    sessionToUpdate.add(s);
                    
                }
                
                if(sessionToUpdate.size()>0){
                    update sessionToUpdate;
                }
                
            }
        }*/
    }
    
    
    //for delete 
    public static void updateSessionOnDelete(List<Session_Attendance__c> oldvalues){
        
        set<Id> sessionIds = new set<Id>();
        
        for(Session_Attendance__c objSessAttendance : oldvalues){
            if(objSessAttendance.Session__c != null)
                sessionIds.add(objSessAttendance.Session__c);
        }
        
        if(sessionIds.size()>0){
            
            List<Session__c> sessionToUpdate = new List<Session__c>();
            for(Session__c objSession : [select id,batch__c,batch__r.school_Name__c,Payment_Status__c,(select id from sessions__r limit 1)
                                         from session__c where Id IN: sessionIds AND Payment_Status__c != 'Payment Made' AND SessionDate__c != null])
            {
                
                Session__c s = new Session__c();
                s.Id = objSession.Id;
                if(objSession.sessions__r.size()>0){
                    s.Payment_Status__c = 'Ready For Payment';
                }
                else{
                    s.Payment_Status__c = '';
                }
                
                sessionToUpdate.add(s);
                
            }
            
            if(sessionToUpdate.size()>0){
                update sessionToUpdate;
            }
            
            /*set<Id> schoolIds = new set<Id>();
            set<String> SessionGrade = new set<String>();
            
            
            for(Session__c objSession : [select id,Session_Grade__c,batch__c,batch__r.school_Name__c from session__c 
                                         where Id IN: sessionIds AND Payment_Status__c = 'Ready For Payment'])
            {
                schoolIds.add(objSession.batch__r.school_Name__c);
                SessionGrade.add(objSession.Session_Grade__c);
                
            }
            
            if(schoolIds.size()>0 && SessionGrade.size()>0){
                
                Map<String,List<Session__c>> gradeSessionLstMap = new Map<String,List<Session__c>>();
                for(Session__c objSession : [select id,batch__c,batch__r.school_Name__c,Session_Grade__c
                                             from session__c where batch__r.school_Name__c IN: schoolIds AND
                                             Session_Grade__c IN: SessionGrade AND
                                             Payment_Status__c = 'Ready For Payment']){
                                                 if(!gradeSessionLstMap.containsKey(objSession.Session_Grade__c.replaceAll( '\\s+', '')))
                                                     gradeSessionLstMap.put(objSession.Session_Grade__c.replaceAll( '\\s+', ''), new List<Session__c>());
                                                 gradeSessionLstMap.get(objSession.Session_Grade__c.replaceAll( '\\s+', '')).add(objSession);
                                             }
                
                for(Session_Attendance__c objSessAttendance : [select id,Session__c,Session__r.Session_Grade__c from Session_Attendance__c WHERE 
                                                               Session__r.batch__r.school_Name__c IN: schoolIds AND 
                                                               Session__r.Session_Grade__c IN: SessionGrade])
                {
                    if(gradeSessionLstMap.containskey(objSessAttendance.Session__r.Session_Grade__c.replaceAll( '\\s+', '')))
                        gradeSessionLstMap.remove(objSessAttendance.Session__r.Session_Grade__c.replaceAll( '\\s+', ''));
                }
                
                if(gradeSessionLstMap.keyset().size()>0){
                    List<Session__c> sessionToUpdate = new List<Session__c>();
                    for(string i : gradeSessionLstMap.keyset()){
                        
                        for(Session__c objsession : gradeSessionLstMap.get(i)){
                            Session__c s = new Session__c();
                            s.Id = objsession.Id;
                            s.Payment_Status__c = '';
                            sessionToUpdate.add(s);
                        }
                        
                    }
                    
                    if(sessionToUpdate.size()>0)
                        update sessionToUpdate;
                }
                
            }*/
            
        }
    }
}