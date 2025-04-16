trigger SessionAttendanceTrigger on Session_Attendance__c (After Insert,After Delete, After Update) {
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        SessionAttendanceTriggerHandler.updateSessionOnInsert(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isDelete && Trigger.isAfter){
        SessionAttendanceTriggerHandler.updateSessionOnDelete(Trigger.old);
    }

}