/*
 * Trigger: omrAssessmentTrigger
 * Object : OMR_Assessment__c(CDM1)
 * -------------------------------------------------------------------------------------------------------------------------
 * History
 * Version	Date			Description
 * v1.0 	18th Sept 23	Updated logic for OMR Assessment Count to consider existing records
 * v2.0     14th feb 24     changed parameters from (Trigger.old, null) to (Trigger.New, Trigger.oldMap)
 */
trigger omrAssessmentTrigger on OMR_Assessment__c (after insert, after update, after delete,before insert,before update) {

    /*
    if(Trigger.isInsert && Trigger.isBefore){
        omrAssessmentTriggerHandler.populateStudentOnOMRAssementbeforeNew(Trigger.New);
    }
    
    if(Trigger.isAfter && Trigger.isInsert && !omrAssessmentTriggerHandler.isStopRecursion){
        
        omrAssessmentTriggerHandler.populateStudentAspirations(Trigger.New, null);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){        
        omrAssessmentTriggerHandler.populateStudentAspirations(Trigger.New, Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isDelete){        
        omrAssessmentTriggerHandler.populateStudentAspirations(Trigger.old, null);
    }*/
    
    if(Trigger.isBefore) {
        //commentd if condition because we want to call batch class
        //batch class always worked on stored data which is having Id
        if(Trigger.isInsert) {
            omrAssessmentTriggerHandler.populateStudentOnOMRAssementbeforeNew(Trigger.New);
        }
        omrAssessmentTriggerHandler.updateBatchId(Trigger.New, Trigger.oldMap);
        //omrAssessmentTestTriggerHandler.updateBatchId(Trigger.New, Trigger.oldMap);
    }
    
    if(Trigger.isAfter) {
        
        
        /*if(Trigger.isInsert) {
            omrAssessmentTestTriggerHandler omrOb = new omrAssessmentTestTriggerHandler(Trigger.New);
			database.executeBatch(omrOb,20);
        }*/
        
        if(Trigger.isDelete) {
            omrAssessmentTriggerHandler.populateStudentAspirations(Trigger.old, null);
            omrAssessmentTriggerHandler.updateOMRTypeCounterManager(Trigger.New, Trigger.oldMap, Trigger.isDelete);  //v1.0
            //omrAssessmentTestTriggerHandler.populateStudentAspirations(Trigger.old, null);
            //omrAssessmentTestTriggerHandler.updateOMRTypeCounter(Trigger.old, null, Trigger.isDelete);
        }
        
        //omrAssessmentTestTriggerHandler.isStopRecursion
        if(!omrAssessmentTriggerHandler.isStopRecursion) {
            
            omrAssessmentTriggerHandler.populateStudentAspirations(Trigger.New, Trigger.oldMap); //v2.0
        }
        
        //omrAssessmentTestTriggerHandler.updateCounterFlag
        if(!omrAssessmentTriggerHandler.updateCounterFlag) {     
            omrAssessmentTriggerHandler.updateOMRTypeCounterManager(Trigger.New, Trigger.oldMap, Trigger.isDelete);   //v1.0
        }
    }    
}