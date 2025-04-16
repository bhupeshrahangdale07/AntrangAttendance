//added by kandisatech on 19/08/2019
public with sharing class InvocableSetFullTimeOpportunityOnStudent {
   
    @InvocableMethod(label='Calc full time opportunity flag on student' description='set has full time opportunity flag on student.')
    public static void setHasfulltimeOpportunityOnStudent(List<Opportunity_Assignment__c> OppAssignments) {
        Set<Id> studentIds = new Set<Id>();
        for (Opportunity_Assignment__c oa : OppAssignments) {
            studentIds.add(oa.Student__c);
        }

        set<string> setTypeOfOpp = new Set<String>{ 'Full time Internship', 'Full time job' , 'Part time job'};

        Map<Id,Boolean> mapContactIdvsAssignment = new Map<Id,Boolean>();
        for (Opportunity_Assignment__c o : [select id,Active__c,Student__c,Linkage_Not_Achieved__c,Opportunity__r.Type_of_opportunity__c from Opportunity_Assignment__c where Student__c =: studentIds order by Student__c asc]) {
            if(o.Active__c && !o.Linkage_Not_Achieved__c && setTypeOfOpp.contains(o.Opportunity__r.Type_of_opportunity__c)){
                mapContactIdvsAssignment.put(o.Student__c,true);
            }else{
                if(!mapContactIdvsAssignment.containsKey(o.Student__c) ){
                    mapContactIdvsAssignment.put(o.Student__c,false);
                }
            }
        }

        List<Contact> lstContact = new List<Contact>();
        for (Id conId : mapContactIdvsAssignment.keySet()) {
            Contact c = new Contact(Id = conId, Has_FullTime_Opportunity__c = mapContactIdvsAssignment.get(conId));
            lstContact.add(c);
        }

        if(lstContact.size()>0){
            update lstContact;
        }
    }

}