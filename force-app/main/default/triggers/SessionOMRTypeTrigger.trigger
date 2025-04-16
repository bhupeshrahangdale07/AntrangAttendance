trigger SessionOMRTypeTrigger on Session_OMR_Type__c (after update, before update) {
    
    if(Trigger.isBefore) {
        if(Trigger.isUpdate) {
            SessionOMRTypeTriggerHandler.firstOMRUploadDate(Trigger.New, Trigger.oldMap); 
            system.debug('before update');
        }
    }    
    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            SessionOMRTypeTriggerHandler.OMRRecvCount(Trigger.New, Trigger.oldMap);                       
        }
    }
}