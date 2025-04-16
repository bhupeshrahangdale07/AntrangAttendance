/*
 * Trigger: CareerSkillTrigger
 * Object : Career_Skill__c
 * -------------------------------------------------------------------------------------------------------------------------
 * History
 * Version	Date			Description
 * v1.0 	18th Sept 23	Updated logic for OMR Assessment Count to consider existing records
 */ 
trigger CareerSkillTrigger on Career_Skill__c (after insert, after update, after delete,before insert,before update) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            CareerSkillTriggerHandler.populateStudentAndMarksCalculationNew(Trigger.New);
        }
        CareerSkillTriggerHandler.updateBatchId(Trigger.New, Trigger.oldMap);
    }
    
    if(Trigger.isAfter) {
        if(Trigger.isDelete) {
            CareerSkillTriggerHandler.updateOMRTypeCounterManager(Trigger.New, Trigger.oldMap, Trigger.isDelete); // v1.0
          //  CareerSkillTriggerHandler.updateOMRTypeCounter(Trigger.old, null, Trigger.isDelete);
        }   
        if(Trigger.isInsert && !CareerSkillTriggerHandler.isStopRecursion) {
			// CareerSkillTriggerHandler.populateStudentAndMarksCalculation(Trigger.New);            
        }
        if(!CareerSkillTriggerHandler.updateCounterFlag) { 
            CareerSkillTriggerHandler.updateOMRTypeCounterManager(Trigger.New, Trigger.oldMap, Trigger.isDelete);  //v1.0
           // CareerSkillTriggerHandler.updateOMRTypeCounter(Trigger.New, Trigger.oldMap, Trigger.isDelete);
        }
    }
}