/*
This invocable class is used to create Opportunity Assignment Record for each additional Course
*/
global class CreateOppAssignmentsForTrainingCon{
    @invocableMethod(label='Create Opp Assignment for each additional courses')
    global static void updateACSE_AVSE(wrapContact[] wrapParam){
        Id RecordTypeIdCR = Schema.SObjectType.Opportunity_Assignment__c.getRecordTypeInfosByName().get('External Training').getRecordTypeId();
        set<id> conIds = new set<id>();
        for(wrapContact wpc : wrapParam ){
        conIds.add(wpc.LstConIds);
        }
        List<Opportunity_Assignment__c> oppAssignRecsToBeCreated = new List<Opportunity_Assignment__c>();
        for(Contact con : [Select Additional_courses__c, Account.Industry, Education_Status__c from Contact where id in: conIds and Additional_courses__c != null]){
            for(String s : con.Additional_courses__c.trim().split(';')){
                Opportunity_Assignment__c oppAssign = new Opportunity_Assignment__c();
                oppAssign.Opportunity__c = wrapParam[0].opptyid;
                oppAssign.Student__c = con.id;
                oppAssign.Status__c = 'Course started';
                oppAssign.RecordTypeId = RecordTypeIdCR;
                oppAssign.Opportunity_Start_Date__c = System.Date.today();
                oppAssign.Training_Status__c = 'Completed';
                oppAssign.Comments__c = s;
                oppAssign.Linkage_Not_Achieved__c = false;
                oppAssign.Course_name__c = 'Adobe illustrator'; //course name
                oppAssign.Industry__c = 'Education and Training'; //industry
                oppAssign.Opportunity_Start_Date__c = Date.today(); //opp start date
                
                oppAssignRecsToBeCreated.add(oppAssign);
            }
        }
        
        if(oppAssignRecsToBeCreated.size() > 0)
            insert oppAssignRecsToBeCreated;
    }
    global class wrapContact {
        @InvocableVariable(required=true) global ID opptyid;
         @InvocableVariable(required=true) global ID LstConIds;
     }
    
}