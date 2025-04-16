/*Inserting and Updating number of student field in batch*/
trigger NumberOfStudentUpdate on Contact (after insert,after update, after delete, after undelete, before update,before insert) {
    AntarangSetting__c CS = AntarangSetting__c.getOrgDefaults();
    system.debug(CS.Enable_Contact_Trigger__c);
    if(CS.Skip_contact_trigger_for__c == Userinfo.getuserid()) {
        return;
    }
    if(CS.Enable_Contact_Trigger__c){
        if(Trigger.IsBefore && Trigger.IsUpdate) {
            if(!ContactTriggerHandler.recurssionOfPB){
                ContactTriggerHandler.UpdateStatuses(Trigger.New, Trigger.OldMap);
                ContactTriggerHandler.UpdateCareerTracksAndClarityReports(Trigger.New, Trigger.OldMap);
                ContactTriggerHandler.CounsellingAttendance(Trigger.New);
                ContactTriggerHandler.UpdateFollowupDetails(Trigger.New);
                if(CS.Disable_Placements_re_engage__c){
                    ContactTriggerHandler.Picklistchange(Trigger.new);
                }
            }
        } else if (Trigger.IsAfter) {
            if (Trigger.IsDelete) {
                ContactTriggerHandler.UpdateNumberofStudent(Trigger.Old, Trigger.OldMap, 
                                                            Trigger.IsInsert, Trigger.IsUpdate, Trigger.IsDelete, Trigger.IsUndelete);
                /**String newContactListJSON = JSON.serialize(Trigger.old);
                    String oldContactListJSON = JSON.serialize(Trigger.OldMap);
                    ContactTriggerHandler.numberOfStudentfacilitated(newContactListJSON,oldContactListJSON,Trigger.IsInsert, Trigger.IsUpdate, Trigger.IsDelete, Trigger.IsUndelete);**/
                    
                
            } else {
                system.debug('ContactTriggerHandler.recurssionOfPB :: ' +ContactTriggerHandler.recurssionOfPB);
                    ContactTriggerHandler.UpdateNumberofStudent(Trigger.New, Trigger.OldMap, 
                                                                Trigger.IsInsert, Trigger.IsUpdate, Trigger.IsDelete, Trigger.IsUndelete);
                    /**String newContactListJSON = JSON.serialize(Trigger.New);
                    String oldContactListJSON = JSON.serialize(Trigger.OldMap);
                    ContactTriggerHandler.numberOfStudentfacilitated(newContactListJSON,oldContactListJSON,Trigger.IsInsert, Trigger.IsUpdate, Trigger.IsDelete, Trigger.IsUndelete); **/
               
                
            }  
        }
        
        if(Trigger.IsBefore && Trigger.IsInsert && CS.Disable_Placements_re_engage__c){
            ContactTriggerHandler.Picklistchange(Trigger.new);
        }
        if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
            if(!ContactTriggerHandler.recurssionOfPB){
                ContactTriggerHandler.InterestAptitudeMatch(Trigger.new,Trigger.IsInsert,Trigger.IsUpdate,Trigger.oldMap);
                //Populate Followup 1 conf Clear Next Steps according to Followup 1 Aspiration and Follow up 1 Step 1
                ContactTriggerHandler.MapCareerAwareNextStep(Trigger.new, Trigger.OldMap, Trigger.IsInsert);
                ContactTriggerHandler.MapFupAspiration(Trigger.new, Trigger.OldMap, Trigger.IsInsert);
                ContactTriggerHandler.MapCareerAwarePost10steps(Trigger.new, Trigger.OldMap, Trigger.IsInsert);
                ContactTriggerHandler.processBuilderUpdateContact(Trigger.new, Trigger.OldMap,Trigger.IsInsert,Trigger.IsUpdate);
            }
        }
        if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate) && CS.Enable_Contact_Api__c) {
            if(!ContactTriggerHandler.CallOutforContact && !ContactTriggerHandler.recurssionOfPB){
                ContactTriggerHandler.RealtimeContactAPI(Trigger.new,Trigger.IsInsert,Trigger.IsUpdate,Trigger.isDelete,Trigger.oldMap);
            }
        }
        if(Trigger.isAfter && Trigger.isDelete && CS.Enable_Contact_Api__c) {
            if(!ContactTriggerHandler.CallOutforContact ){
                ContactTriggerHandler.RealtimeContactAPI(Trigger.old,Trigger.IsInsert,Trigger.IsUpdate,Trigger.isDelete,Trigger.oldMap);
            }
        }
        if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate) && CS.PlanA_B_Industry_Check__c){
            if(!ContactTriggerHandler.PlanA_B_recurssion && !ContactTriggerHandler.recurssionOfPB){
                ContactTriggerHandler.updatePlanA_B(Trigger.new,Trigger.oldMap,Trigger.IsInsert);
                
            } 
        }
        
    }
    
}