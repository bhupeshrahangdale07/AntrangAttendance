global class GenerateAccessTokenbatch implements Database.Batchable<Sobject>, Database.Stateful,Database.AllowsCallouts,schedulable{

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id FROM Account limit 1';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Account> records){
     system.debug('*records' + records);
     if(records.size() > 0)
         GenerateAccessToken.getAccessToken();
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    } 
    
    global void execute(SchedulableContext sc) {
        Id batchId = Database.executeBatch(new GenerateAccessTokenbatch(), 1);
    }
}







/*
global class GenerateAccessTokenbatch implements Schedulable,Database.Stateful,Database.AllowsCallouts{

    global void execute(SchedulableContext SC) {
        Getaccesstoken();
    }
    global void Getaccesstoken() {
       GenerateAccessToken.getAccessToken();
       
    }
    
}*/