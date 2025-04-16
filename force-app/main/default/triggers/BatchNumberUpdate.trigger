/* Created for creating and updating batch number, also calculating the number of student belongs to the batch */
trigger BatchNumberUpdate on Batch__c (after insert,after update,after delete,after undelete) {
    
    if(Trigger.isAfter && Trigger.isUpdate){
        BatchTriggerHandler.updateDummyBatch(Trigger.New, Trigger.OldMap);
        
        BatchTriggerHandler.calculateNumberOfStudent(Trigger.New, Trigger.OldMap);
        BatchTriggerHandler.updatingFacilitatorName(Trigger.NewMap, Trigger.OldMap); 
        BatchTriggerHandler.updateSessionToChild(Trigger.NewMap, Trigger.OldMap);
        BatchTriggerHandler.updateNoOfStudOnSOT(Trigger.New, Trigger.oldMap);
    }
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        BatchTriggerHandler.calculateNumberOfBatches(Trigger.New,Trigger.OldMap,Trigger.isInsert, Trigger.isUpdate);
    }
    
    if(Trigger.isAfter && (Trigger.isdelete || Trigger.isUndelete)){
        BatchTriggerHandler.countSession(Trigger.New, Trigger.OldMap, Trigger.isDelete);
    }
    
    //old code is commented because of giveing error when bulk update batches.
    /*if (TriggerCheck.runOnce()) {
        if (trigger.old != null){
            if(trigger.new[0].School_Name__c != trigger.old[0].School_Name__c){
                TriggerCheck.schoolCheck= false;
                for (Batch__c batch:trigger.new) {  
                    TriggerCheck triggerCheck = new TriggerCheck();
                    triggerCheck.calculateNumberOfStudent(trigger.new[0].School_Name__c, trigger.old[0].School_Name__c);}
            }
            
            if (trigger.new[0].Donor_Name__c != trigger.old[0].Donor_Name__c){
                for (Batch__c batch:trigger.new) {  
                    TriggerCheck triggerCheck = new TriggerCheck();
                    triggerCheck.calculateNumberOfBatches(batch.id, trigger.old[0].Donor_Name__c);
                } 
            }
        }
        for (Batch__c batch:trigger.new) {
            TriggerCheck triggerCheck = new TriggerCheck();
            triggerCheck.createBatchNumber(batch.id);
            triggerCheck.calculateNumberOfBatches(batch.id);
        }
    }*/
    
    
}