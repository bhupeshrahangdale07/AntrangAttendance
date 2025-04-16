global class UpdateDisableAppLogin implements Database.Batchable<sObject>,Database.Stateful,schedulable {
    List<Contact> contactToUpdate = new List<Contact>();
    date dt = System.today().addYears(-2);

    global Database.QueryLocator start(Database.BatchableContext BC){            
     

        return Database.getQueryLocator('SELECT Id,Name,Graduate_Date__c FROM Contact where Disable_App_Login__c = false and Graduate_Date__c <: dt');
    }

    global void execute(Database.BatchableContext BC, List<Contact> con){
        
        
        
        for(Contact c : con){
        
            if(c.Graduate_Date__c < dt)
            {
                c.Disable_App_Login__c = TRUE; 
                contactToUpdate .add(c);         
            }

        }
        update contactToUpdate ;
    }

    global void finish(Database.BatchableContext BC){     
    } 
    
    global void execute(SchedulableContext sc) {
        Id batchId = Database.executeBatch(new UpdateDisableAppLogin(), 20);
    }   
}