trigger DistrictMasterTrigger on District_Master__c (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        system.debug('$$$ In DistrictMasterTrigger: ' + Trigger.New);
        DistrictMasterTriggerHandler.checkDistrictInSessionMapping(Trigger.New);
    }
}