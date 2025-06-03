/*
OMRRecvCount: update OMR_s_received_for_session__c field on Session when OMRs_Received_Count__c changes on SOT
updateFirstOMRUploadDate: stamp current date when 1st OMR is uploaded
*/

public class SessionOMRTypeTriggerHandler {
    
    public static void OMRRecvCount(List<Session_OMR_Type__c> newSOTList, Map<Id,Session_OMR_Type__c> oldSOTMap) {
        Set<Id> sessionIdSet = New Set<Id>();
        Map<Id,Integer> sessionOMRTYpes = New Map<Id,Integer>();
        Map<Id,Integer> OMRRecvCount = New Map<Id,Integer>();
        Map<Id,Session__c> sessionMap = New Map<Id,Session__c>();
        Integer getCount = 0;
        
        for(Session_OMR_Type__c s: newSOTList) {
            if(s.OMRs_Received_Count__c != oldSOTMap.get(s.Id).OMRs_Received_Count__c) {                
                sessionIdSet.add(s.Session__c);
            }
        }
        if(sessionIdSet.size()>0) {                               
            for(Session_OMR_Type__c sot: [Select Id, Session__c, OMRs_Received_Count__c
                                          From Session_OMR_Type__c
                                          Where Session__c In: sessionIdSet]) {                                              
                                              //total SOT of Session
                                              if(sessionOMRTYpes.containsKey(sot.Session__c)) {
                                                  getCount = sessionOMRTYpes.get(sot.Session__c);
                                                  sessionOMRTYpes.put(sot.Session__c, getCount+1);                                                  
                                              } else {
                                                  sessionOMRTYpes.put(sot.Session__c, 1);
                                              }
                                              //OMRs Received Count
                                              if(sot.OMRs_Received_Count__c >= 1){                                                  
                                                      if(OMRRecvCount.containsKey(sot.Session__c)) {
                                                          getCount = OMRRecvCount.get(sot.Session__c);
                                                          OMRRecvCount.put(sot.Session__c, getCount+1);
                                                      } else {
                                                          OMRRecvCount.put(sot.Session__c, 1);
                                                      }
                                              }
                                              
                                          }
                    
        }        
        if(sessionOMRTYpes.size()>0) {               
            for(Id s: sessionOMRTYpes.keySet()) {  
                Session__c sess = New Session__c();
                if(OMRRecvCount.containsKey(s) && sessionOMRTYpes.get(s) == OMRRecvCount.get(s)) {                                       
                    sess.Id = s;
                    sess.OMR_s_received_for_session__c = 'Yes';
                    sessionMap.put(s, sess);
                } else {                    
                    sess.Id = s;
                    sess.OMR_s_received_for_session__c = 'No';
                    sessionMap.put(s, sess);
                }
            }
        }
        if(sessionMap.size()>0) {            
            update sessionMap.values();
        }
    }
    
    public static void firstOMRUploadDate(List<Session_OMR_Type__c> newSOTList, Map<Id,Session_OMR_Type__c> oldSOTMap) {
        List<Session_OMR_Type__c> slist = New List<Session_OMR_Type__c>();
        system.debug('inside class');
        
        for(Session_OMR_Type__c s: newSOTList) {
            system.debug('inside loop');
            if(s.OMR_Assessment_Count__c != oldSOTMap.get(s.Id).OMR_Assessment_Count__c) {    
                system.debug('inside con');
                if(s.OMR_Assessment_Count__c > 0 && oldSOTMap.get(s.Id).OMR_Assessment_Count__c == 0) {
                    system.debug('inside new');
                    s.First_OMR_Uploaded_Date__c = Date.today();
                    slist.add(s);
                } else if(s.OMR_Assessment_Count__c < 1 && oldSOTMap.get(s.Id).OMR_Assessment_Count__c > 0) {
                    system.debug('iside old');
                    s.First_OMR_Uploaded_Date__c = null;
                    slist.add(s);
                }
            }
        }/*
        if(slist.size()>0) {
            update slist;
        }*/	
    }

}