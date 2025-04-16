@isTest 
private class InvocableSetFullTimeOppTest {
    static testMethod void validatetest() {
        
       Test.startTest();

       Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
       
       Account acc = new Account(Name = 'Test Account', recordtypeid=accRecordTypeId);
       insert acc;
       
       IARP_Master__c Profession = new IARP_Master__c(Name = 'Plan A');
       insert Profession;
       
       Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
       Contact c = new Contact();
       c.lastname = 'test';
       c.recordtypeid = contactRecordTypeId;
       c.English_Fluency__c = 'Level 1 - Only introduction and then switches to another language';
       c.Digital_Literacy__c = 'Level 2 - Comfortable on a tab/computer - has an email account, has used word/ppt at least once and knows how to search on the internet' ;
       c.Gender__c = 'Male only';
       c.Education_Level__c = 'Graduate';
       c.Available_working_Hours_Start_Time__c =  Time.newInstance(8, 1, 1, 1);
       c.Available_working_Hours_Finish_Time__c = Time.newInstance(9, 1, 1, 1);
       c.Available_work_Days__c = 'Tuesday';
       c.Profession_1__c = Profession.id;
       c.Available_for_Career_Linkage__c = 'Yes';
       c.Type_of_Career_linkage__c = 'Full time Internship';
       insert c;
       
       OpportunityAssignments.findContactName(c.id);
       
       Id oppLearningRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Training').getRecordTypeId();
       
       Id oppRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Employment').getRecordTypeId();
       Opportunity__c  opp = new Opportunity__c();
       opp.name = 'Test Opporunity';
       opp.recordtypeid = oppRecordTypeId;
       opp.Educational_Level__c = 'Graduate';
       opp.Type_of_opportunity__c = 'Education';
       opp.Account__c = acc.id;
       opp.Gender__c = 'Male only';
       opp.No_of_Openings__c = 1;
       opp.Working_Hours_Start_Time__c = Time.newInstance(7, 1, 1, 1);
       opp.Working_Hours_End_Time__c = Time.newInstance(15, 1, 1, 1);
       opp.Training_Hours_Start_Time__c = Time.newInstance(7, 1, 1, 1);
       opp.Training_Hours_End_Time__c = Time.newInstance(15, 1, 1, 1);
       opp.Work_Days__c = 'Tuesday; Wednesday;';
       opp.Profession__c = Profession.Name;
       opp.English_Fluency__c = 'Level 1 - Only introduction and then switches to another language';
       opp.Digital_Literacy__c = 'Level 2 - Comfortable on a tab/computer - has an email account, has used word/ppt at least once and knows how to search on the internet' ;
       
       insert opp;
       
       OpportunityAssignments.checkMoreThan3JobsByContact(c.id);
       List<OpportunityAssignments.wrpOpportunityAssignment> lstwrp = OpportunityAssignments.findMatchOpportunity(c.id);
       
       OpportunityAssignments.wrpOpportunityAssignment wrp = lstwrp.get(0);       
       wrp.isAdded = true;
             
       
       OpportunityAssignments.findOpportunityName(opp.id);
       OpportunityAssignments.findMatchingContact(opp.id);
       
       opp.Recordtypeid = oppLearningRecordTypeId;
       update opp;
       OpportunityAssignments.findOpportunityName(opp.id);
       OpportunityAssignments.findMatchingContact(opp.id);
       
       
       OpportunityAssignments.SaveMatchOpportunity(JSON.serialize(lstwrp),c.id, true);

       List<Opportunity_Assignment__c> lstoa = new list<Opportunity_Assignment__c>([select id,Student__c from Opportunity_Assignment__c]);

       InvocableSetFullTimeOpportunityOnStudent.setHasfulltimeOpportunityOnStudent(lstoa);

       Test.stopTest();
    }
}