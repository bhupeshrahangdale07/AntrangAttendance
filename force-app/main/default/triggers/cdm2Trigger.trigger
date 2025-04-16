/*
 * Trigger: cdm2Trigger
 * Object : CDM2__c
 * -------------------------------------------------------------------------------------------------------------------------
 * History
 * Version	Date			Description
 * v1.0 	18th Sept 23	Updated logic for OMR Assessment Count to consider existing records
 */ 
trigger cdm2Trigger on CDM2__c (after insert, after update, after delete,before insert,before update) {
    
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            cdm2TriggerHandler.populateStudentOnCDM2New(Trigger.New);
        }
        cdm2TriggerHandler.updateBatchId(Trigger.New, Trigger.oldMap);
    }
        
    if(Trigger.isAfter) {
        if(Trigger.isDelete) {
            cdm2TriggerHandler.updateOMRTypeCounterManager(Trigger.New, Trigger.oldMap, Trigger.isDelete);    //v1.0
           // cdm2TriggerHandler.updateOMRTypeCounter(Trigger.old, null, Trigger.isDelete);
        }        
        if(Trigger.isInsert && !cdm2TriggerHandler.isStopRecursion) {
            // cdm2TriggerHandler.populateStudentOnCDM2(Trigger.New);
        }
        if(!cdm2TriggerHandler.updateCounterFlag) { 
            cdm2TriggerHandler.updateOMRTypeCounterManager(Trigger.New, Trigger.oldMap, Trigger.isDelete);   // v1.0
           // cdm2TriggerHandler.updateOMRTypeCounter(Trigger.New, Trigger.oldMap, Trigger.isDelete);
        }
    }
    
}