global class ContactCalloutBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {

    global set<Id> conts = new set<id>();
    
    global ContactCalloutBatch (set<id> consetID)
    {
         system.debug('setID11'+consetID);
        this.conts = consetID;
        
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return DataBase.getQueryLocator([SELECT Id FROM contact WHERE Id IN: conts ]);
        
    }
    
    global void execute(Database.BatchableContext BC,list<contact> scopecont)
    {
      set<id> contid = new set<id>();
      for(contact con: scopecont){
          contid.add(con.id);
      }
      if(contid.size()> 0){
        ContactAPICallout.ContactCallout(contid );
       }
    }

    global void finish(Database.BatchableContext BC){    
    }
}