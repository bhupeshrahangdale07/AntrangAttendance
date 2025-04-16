/*
 * Trigger: SelfAwarenessandFeedbackTrigger
 * Object : Self_Awareness_and_Feedback__c
 * -------------------------------------------------------------------------------------------------------------------------
 * History
 * Version	Date			Description
 * v1.0 	26th Sept 23	Updated logic for OMR Assessment Count to consider existing records
 */ 
trigger SelfAwarenessandFeedbackTrigger on Self_Awareness_and_Feedback__c (after insert, after update, after delete,before insert,before update) {

    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            SelfAwarenessandFeedbackTriggerHandler.populateStudentAndMarksCalculationNew(Trigger.New);
        }
        SelfAwarenessandFeedbackTriggerHandler.updateBatchId(Trigger.New, Trigger.oldMap);
    }
    
     if(Trigger.isAfter) {
        if(Trigger.isDelete) {
            SelfAwarenessandFeedbackTriggerHandler.populateStudentInterestsAptitudes(Trigger.old, null);
            SelfAwarenessandFeedbackTriggerHandler.updateOMRTypeCounterManager(Trigger.New, Trigger.oldMap, Trigger.isDelete);//v1.0
           // SelfAwarenessandFeedbackTriggerHandler.updateOMRTypeCounter(Trigger.old, null, Trigger.isDelete);
        }
        if(Trigger.isInsert) {
            //SelfAwarenessandFeedbackTriggerHandler.executeSelfAwarenessandFeedbackBatch(Trigger.New);
            // SelfAwarenessandFeedbackTriggerHandler.populateStudentAndMarksCalculation(Trigger.New);
        }
        if(!SelfAwarenessandFeedbackTriggerHandler.isStopRecursion) {
			SelfAwarenessandFeedbackTriggerHandler.populateStudentInterestsAptitudes(Trigger.New, Trigger.oldMap);            
        }    
         if(!SelfAwarenessandFeedbackTriggerHandler.updateCounterFlag) { 
            SelfAwarenessandFeedbackTriggerHandler.updateOMRTypeCounterManager(Trigger.New, Trigger.oldMap, Trigger.isDelete); //v1.0
           // SelfAwarenessandFeedbackTriggerHandler.updateOMRTypeCounter(Trigger.New, Trigger.oldMap, Trigger.isDelete);
        }
    }        
}