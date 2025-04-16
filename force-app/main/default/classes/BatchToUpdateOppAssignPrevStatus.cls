//added by kandisatech on 11/11/2019

global  class BatchToUpdateOppAssignPrevStatus implements Database.Batchable<sObject> {

    Public String SoqlQry = '';
    Public BatchToUpdateOppAssignPrevStatus(){
        this.SoqlQry = 'SELECT Id, (SELECT Id, ParentId, Field, OldValue, NewValue FROM Histories where field=\'Status__c\' order by createddate desc limit 1) from Opportunity_Assignment__c ';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) 
    {       
        return Database.getQueryLocator(SoqlQry);
    }
    global void execute(Database.BatchableContext BC, List<Opportunity_Assignment__c> lst) {
        List<Opportunity_Assignment__c> lstOA = new List<Opportunity_Assignment__c>();
        for (Opportunity_Assignment__c oa : lst) {
            Opportunity_Assignment__c a = new Opportunity_Assignment__c(Id = oa.Id);
            for (Opportunity_Assignment__History h : oa.Histories) {
                a.Old_Status__c = String.valueOf(h.OldValue);
                lstOA.add(a);
            }
        }

        if(lstOA.size()>0){
            update lstOA;
        }
       
    }    
    global void finish(Database.BatchableContext BC) { }


}