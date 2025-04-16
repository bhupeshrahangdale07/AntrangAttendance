/*
 * Trigger: FuturePlanningTrigger
 * Object : Future_Planning__c
 * -------------------------------------------------------------------------------------------------------------------------
 * History
 * Version	Date			Description
 * v1.0 	18th Sept 23	Updated logic for OMR Assessment Count to consider existing records
 */ 
trigger FuturePlanningTrigger on Future_Planning__c (after insert, after update, after delete,before insert,before update) {

    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            FuturePlanningTriggerHandler.populateStudentAndMarksCalculationNew(Trigger.New);
        }
        FuturePlanningTriggerHandler.updateBatchId(Trigger.New, Trigger.oldMap);
    }

	if(Trigger.isAfter) {
        if(Trigger.isDelete) {
            FuturePlanningTriggerHandler.updateOMRTypeCounterManager(Trigger.New, Trigger.oldMap, Trigger.isDelete);  //v1.0
           // FuturePlanningTriggerHandler.updateOMRTypeCounter(Trigger.old, null, Trigger.isDelete);
        }        
        if(Trigger.isInsert && !FuturePlanningTriggerHandler.isStopRecursion) {
            // FuturePlanningTriggerHandler.populateStudentOnCDM2(Trigger.New);
        }
        if(!FuturePlanningTriggerHandler.updateCounterFlag) {
            FuturePlanningTriggerHandler.updateOMRTypeCounterManager(Trigger.New, Trigger.oldMap, Trigger.isDelete);   //v1.0
           // FuturePlanningTriggerHandler.updateOMRTypeCounter(Trigger.New, Trigger.oldMap, Trigger.isDelete);
        }
    }    
}