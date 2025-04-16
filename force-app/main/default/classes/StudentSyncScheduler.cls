global class StudentSyncScheduler implements Schedulable {
    //this scheduler invokes batch class to sync student data from Antarang to Salesofrce Contact Records
    global void execute(SchedulableContext sc) {
        Date fromDate =  Date.Today();
        Integer numberDaysDue = 0;
        List<Student_Sync_Setting__c> mcs = new List<Student_Sync_Setting__c>([Select Id,Last_Sync_Date__c from Student_Sync_Setting__c where Name='StudentSyncAPIs' limit 1 ]); 
        
        if(mcs.size()>0){
            Student_Sync_Setting__c sss = mcs.get(0);
            if(sss.Last_Sync_Date__c == null){
                fromDate = Date.today();
                sss.Last_Sync_Date__c = Date.Today();
                update sss;
            }else{
                fromDate = sss.Last_Sync_Date__c;
            }

            
            Date startDate = fromDate;
            Date toDate = Date.Today();
           // numberDaysDue = startDate.daysBetween(toDate);      

                         
                StudentSyncBatch b = new StudentSyncBatch(fromDate, toDate);
                ID jobID = database.executebatch(b);

                sss.Last_Sync_Date__c = Date.Today();
                update sss;
            
        }
    }
}