/*
 * Trigger: SelfAwarenessRealitiesTrigger
 * Object : Self_Awareness_Realities__c
 * -------------------------------------------------------------------------------------------------------------------------
 * History
 * Version	Date			Description
 * v1.0 	26th Sept 23	Updated logic for OMR Assessment Count to consider existing records
 */ 
trigger SelfAwarenessRealitiesTrigger on Self_Awareness_Realities__c (after insert, after update, after delete,before insert,before update) {

    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            SelfAwarenessRealitiesTriggerHandler.populateStudentAndMarksCalculationNew(Trigger.New);
        }
        SelfAwarenessRealitiesTriggerHandler.updateBatchId(Trigger.New, Trigger.oldMap);
    }    
        
    if(Trigger.isAfter) {
        if(Trigger.isDelete) {
            SelfAwarenessRealitiesTriggerHandler.populateStudentRealities(Trigger.old, null);
            SelfAwarenessRealitiesTriggerHandler.updateOMRTypeCounterManager(Trigger.New, Trigger.oldMap, Trigger.isDelete);//v1.0 
           // SelfAwarenessRealitiesTriggerHandler.updateOMRTypeCounter(Trigger.old, null, Trigger.isDelete);
        }
        if(!SelfAwarenessRealitiesTriggerHandler.isStopRecursion) {    
            SelfAwarenessRealitiesTriggerHandler.populateStudentRealities(Trigger.New, Trigger.oldMap);
        }    
        if(!SelfAwarenessRealitiesTriggerHandler.updateCounterFlag) {
            SelfAwarenessRealitiesTriggerHandler.updateOMRTypeCounterManager(Trigger.New, Trigger.oldMap, Trigger.isDelete);//v1.0 
           // SelfAwarenessRealitiesTriggerHandler.updateOMRTypeCounter(Trigger.New, Trigger.oldMap, Trigger.isDelete);
        }
    }            
}