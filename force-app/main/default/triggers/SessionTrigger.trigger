/*
* Apex Trigger: SessionTrigger
* Description : 1. populate number of session on trainer(contact)
				2. update inactive child batch payment status
				3. populate Total_Student_Present__c 24/4/24
* -------------------------------------------------------------------------------------------------------------------------
* History
* Version	Date			Description
* v1.0 	    24th Apr 24	    Added logic to populate Total_Student_Present__c from Present_Count__c
*/ 
trigger SessionTrigger on Session__c (after insert, after undelete, after delete, after update, before update) {
    
    if(Trigger.isAfter && ( Trigger.isInsert || Trigger.isUpdate) ){
        SessionTriggerHandler.updateDateOfFacillitationOnBatch(Trigger.new, null);
    }
    
    if(Trigger.isAfter){
        SessionTriggerHandler.countTotalSession(trigger.new,trigger.old,trigger.oldMap);   
        if(Trigger.isUpdate) { 
            if(SessionTriggerHandler.flag)
                SessionTriggerHandler.updateDummySession(Trigger.new, trigger.oldMap);            
            SessionTriggerHandler.inactiveChildBatchPaytStatus(Trigger.new, trigger.oldMap);
            if(!SessionTriggerHandler.isRecurrsive)
                SessionTriggerHandler.updateStudentPresent(Trigger.new, trigger.oldMap);  //v1.0
            
        }
    }
    
    
    
    if(Trigger.isBefore && Trigger.isUpdate){
        
        SessionTriggerHandler.cleanDefferedReasonFeild(Trigger.new, trigger.oldMap);
        
        SessionTriggerHandler.cancelledRescheduledCounter(Trigger.new, trigger.oldMap);
    }
}