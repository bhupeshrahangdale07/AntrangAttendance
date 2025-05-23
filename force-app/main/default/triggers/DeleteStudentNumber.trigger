/*Updating number of student field in batch after deleting student*/
trigger DeleteStudentNumber on Account (before  delete) {
    list<id> AccountIds=new list<id>();      
    if (trigger.isBefore && trigger.isDelete ){
        for (Account con : Trigger.old) {
            AccountIds.add(con.id);
        }
        Id id;
        TriggerCheck triggerCheck = new TriggerCheck();
        list<contact> listOfContacts=[select Batch_Code__c from Contact where accountid in :AccountIds];
        if (!listOfContacts.isEmpty()){
            id= listOfContacts.get(0).Id;
            triggerCheck.updateNumberOfStudent(id);
        }
    }
}