trigger SchoolCodeUpdate on Account (before insert,after insert,after update) {
    /*for (Account school:trigger.new){
       Id RecordTypeIdDonor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();   
        if (school.RecordTypeId == RecordTypeIdDonor){
            TriggerCheck triggerCheck = New TriggerCheck();
            triggerCheck.updateDonor(school.id);
        }
    }  */
    
    /* set school code after creating new school*/
    if(trigger.isbefore && trigger.isInsert){
        SchoolCodeUpdateHandler.updateDonor(trigger.new);
    }
    
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        SchoolCodeUpdateHandler.createbatches(trigger.new,trigger.oldMap, Trigger.IsInsert);
    }

}