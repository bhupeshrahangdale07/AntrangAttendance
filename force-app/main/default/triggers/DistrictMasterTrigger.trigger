trigger DistrictMasterTrigger on District_Master__c (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        DistrictMasterTriggerHandler.checkDistrictInSessionMapping(Trigger.New);
    }
}