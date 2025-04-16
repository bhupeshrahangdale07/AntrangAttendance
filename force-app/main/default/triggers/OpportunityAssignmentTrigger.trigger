trigger OpportunityAssignmentTrigger on Opportunity_Assignment__c (before insert,before update,after insert, after update, after delete) 
{    
    
    if (Trigger.isBefore && Trigger.isInsert){
        
        AntarangSetting__c antarangSettings = AntarangSetting__c.getOrgDefaults();
        if(antarangSettings.Enable_Opp_Assignment_Duplicate_Validati__c){
            OpportunityAssignmentAPIHandler.OppAssignDuplicateValidation(Trigger.new);
        }
        
        OpportunityAssignmentAPIHandler.UpdateStatusWhenBlank(Trigger.new);
    }
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
       OpportunityAssignmentAPIHandler.UpdateInterviewDate_and_Salary(Trigger.new,Trigger.oldMap);
    }
    

    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        if(!OpportunityAssignmentAPIHandler.CallOutforOpprtunityAssignment){
                OpportunityAssignmentAPIHandler.CallOutforOpprtunityAssignment = true;
            
            OpportunityAssignmentAPIHandler.OpportunityAssignmentAPI(Trigger.new, Trigger.IsInsert,Trigger.IsUpdate,Trigger.isDelete,Trigger.oldMap);
        } 
    } 
    if(Trigger.isAfter && Trigger.isDelete) {
            OpportunityAssignmentAPIHandler.OpportunityAssignmentAPI(Trigger.old, Trigger.IsInsert,Trigger.IsUpdate,Trigger.isDelete,Trigger.oldMap);
    }
     if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
      if(!OpportunityAssignmentAPIHandler.recurrsion){
                OpportunityAssignmentAPIHandler.recurrsion = true;
         OpportunityAssignmentAPIHandler.UpdateAdditionalcourse(Trigger.new,Trigger.oldMap);
      }
    }
}