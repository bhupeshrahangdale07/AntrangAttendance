public class bigQueryAsyncExecution implements Schedulable  {
    public String sql;
    public void execute(SchedulableContext  context) {
        GoogleUiController.runBigQuerySql('');
        
    }
    
    /*public void finish(Database.BatchableContext BC)
    {
        // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems
                          FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        
        //then use the active job id and abort it
        system.abortJob(a.id);
    }*/
    
    
    public class fieldWrap{
        public string label;
        public string fieldName;
        public string type;
    }
}