public class logsBatchForDelete implements Database.Batchable<sObject> {
    
    public Database.QueryLocator  start(Database.BatchableContext bc) {
        return Database.getQueryLocator('select id from log__c');
    }
    public void execute(database.BatchableContext bc, list<log__c> loglst){
        
        if(loglst.size()>0) delete loglst;
    }
    public void finish(database.BatchableContext bc){
        
    }
}