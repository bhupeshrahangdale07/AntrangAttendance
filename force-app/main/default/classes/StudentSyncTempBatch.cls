global class StudentSyncTempBatch implements Database.Batchable<Account>, Database.AllowsCallouts {
    
    Date fromDate;
    Date toDate;
    List<Contact> lstcon = new List<Contact>();
    DateTime dt = System.Now().addHours(-1);
    id userid = UserInfo.getUserId();
    set<Id> contsID = new set<id>();
    
    global StudentSyncTempBatch(Date fromDate, Date toDate) {
        this.fromDate = fromDate;
        this.toDate = toDate;
    }
    
    global Iterable<Account> start(Database.BatchableContext BC) {
        return (new List<Account>{new Account()});
    }

    global void execute(Database.BatchableContext BC, List<Account> scope) {
        //this batch invokes sync method 
        //which getStudents from Antarang for the given date range, and create/update in salesforce
        StudentSyncTempBatchHelper.syncStudentsFromAntarang(fromDate, toDate, '1');
    }
    
    global void finish(Database.BatchableContext BC) {
        
        StudentSyncTempBatchHelper.syncStudentsFromAntarang(fromDate, toDate, '2');
        List<Contact> lstcon = [Select id from Contact where  LastModifiedDate>=:dt and LastModifiedById =:userid];
        for(Contact con : lstcon){
          contsID.add(con.id);
      }
      if(contsID.size() > 0){
        Id batchJobId = Database.executeBatch(new ContactCalloutBatch(contsID),5);
       }
       
    }
}