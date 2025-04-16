Trigger OpportunityTrigger on opportunity__c(after insert, after update, after delete) {
    
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        if(!OpportunityAPIHandler.CallOutforOpprtunity){
            //for( Id OpportunityID : Trigger.newMap.keySet() )
            if(!OpportunityAssignments.isFirstTime){
            OpportunityAssignments.isFirstTime = false;
            ID currentOppId;
            Integer len;
            List<OpportunityAssignments.wrpOpportunityAssignment> wrpOpp = new  List<OpportunityAssignments.wrpOpportunityAssignment>();
            for(opportunity__c opp:Trigger.new){
                currentOppId = opp.id;
            }
            wrpOpp = OpportunityAssignments.findMatchingContact(currentOppId);
            len = wrpOpp.size();
            system.debug('length::'+len);
            opportunity__c opp = [SELECT id ,Number_of_profile_matches__c FROM opportunity__c WHERE id =:currentOppId];
              if(wrpOpp != Null){
                     opp.Number_of_profile_matches__c=len;
                }
                else{
                    opp.Number_of_profile_matches__c=0; 
                }
            OpportunityAPIHandler.CallOutforOpprtunity = True;
            update opp;
           
        }
             OpportunityAPIHandler.OpportunityAPI(Trigger.new,Trigger.IsInsert,Trigger.IsUpdate,Trigger.isDelete,Trigger.oldMap);
        }
    } 
    if(Trigger.isAfter && Trigger.isDelete) {
        OpportunityAPIHandler.OpportunityAPI(Trigger.old,Trigger.IsInsert,Trigger.IsUpdate,Trigger.isDelete,Trigger.oldMap);
    }
}


/*for( Id OpportunityID : Trigger.newMap.keySet() )
{
  if( Trigger.oldMap != null && (Trigger.oldMap.get( OpportunityID ).Type_of_opportunity__c != Trigger.newMap.get( OpportunityID ).Type_of_opportunity__c ||Trigger.oldMap.get( OpportunityID ).Work_Days__c != Trigger.newMap.get( OpportunityID ).Work_Days__c||Trigger.oldMap.get( OpportunityID ).Educational_Level__c != Trigger.newMap.get( OpportunityID ).Educational_Level__c|| 
          Trigger.oldMap.get( OpportunityID ).Additional_courses__c != Trigger.newMap.get( OpportunityID ).Additional_courses__c || Trigger.oldMap.get( OpportunityID ).English_fluency__c != Trigger.newMap.get( OpportunityID ).English_fluency__c ||  Trigger.oldMap.get( OpportunityID ).Digital_Literacy__c != Trigger.newMap.get( OpportunityID ).Digital_Literacy__c||
          Trigger.oldMap.get( OpportunityID ).Zone__c != Trigger.newMap.get( OpportunityID ).Zone__c||  Trigger.oldMap.get( OpportunityID ).Work_experience__c != Trigger.newMap.get( OpportunityID ).Work_experience__c|| Trigger.oldMap.get( OpportunityID ).No_of_Openings__c != Trigger.newMap.get( OpportunityID ).No_of_Openings__c||Trigger.oldMap.get( OpportunityID ).Gender__c != Trigger.newMap.get( OpportunityID ).Gender__c ||
          Trigger.oldMap.get( OpportunityID ).Profession__c != Trigger.newMap.get( OpportunityID ).Profession__c|| Trigger.oldMap.get( OpportunityID ).Is_Opportunity_Closed__c != Trigger.newMap.get( OpportunityID ).Is_Opportunity_Closed__c))
  {
    OpportunityAPIHandler.OpportunityAPI(Trigger.new,Trigger.IsInsert,Trigger.IsUpdate,Trigger.isDelete);  }
}*/