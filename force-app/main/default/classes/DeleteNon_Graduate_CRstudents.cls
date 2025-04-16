global class DeleteNon_Graduate_CRstudents implements Database.Batchable<sObject>
{
    global string query;
    public DeleteNon_Graduate_CRstudents(string q){
        if(q != null)
            query=q;
    }
    
    //Start Method 
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        //Query to Fetch Records
        return Database.getQueryLocator([select id,API_Status__c,Student_Status__c FROM Contact where API_Status__c='Both APIs Executed' and Student_Status__c !='Graduated' and RecordType.Name ='CR Student']);
        
    }
    
    //Execute Method
    global void  execute(Database.BatchableContext BC, List<sobject> scope) {
        delete scope;
    }
    
    //Finish Method
    global void finish(Database.BatchableContext BC){
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email
                          FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        System.debug(LoggingLevel.WARN,'Deleting contact Finished');
        
    }
}