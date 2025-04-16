/*
 * Trigger: CareerPlanningTrigger
 * Object : Career_Planning__c
 * -------------------------------------------------------------------------------------------------------------------------
 * History
 * Version	Date			Description
 * v1.0 	18th Sept 23	Updated logic for OMR Assessment Count to consider existing records
 */ 
trigger CareerPlanningTrigger on Career_Planning__c (after insert, after update, after delete,before insert,before update) {
	
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            CareerPlanningTriggerHandler.calculateCareerPlanningMarksNew(Trigger.New);
        }
        CareerPlanningTriggerHandler.updateBatchId(Trigger.New, Trigger.oldMap);
    }
    
    if(Trigger.isAfter) {
        if(Trigger.isDelete) {
            CareerPlanningTriggerHandler.updateOMRTypeCounterManager(Trigger.New, Trigger.oldMap, Trigger.isDelete);  //v1.0
          //  CareerPlanningTriggerHandler.updateOMRTypeCounter(Trigger.old, null, Trigger.isDelete);
        }   
        if(Trigger.isInsert && !CareerPlanningTriggerHandler.isStopRecursion) {
			// CareerPlanningTriggerHandler.calculateCareerPlanningMarks(Trigger.New);            
        }
        if(!CareerPlanningTriggerHandler.updateCounterFlag) {  
            CareerPlanningTriggerHandler.updateOMRTypeCounterManager(Trigger.New, Trigger.oldMap, Trigger.isDelete);  //v1.0
           // CareerPlanningTriggerHandler.updateOMRTypeCounter(Trigger.New, Trigger.oldMap, Trigger.isDelete);
        }
    }
    
    
}