@isTest 
private class OpportunityAssignmentsTest {
    static testMethod void OppAssignmentValidate() {
       OpportunityAssignments.isFirstTime = false;
       Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
       
       Account acc = new Account(Name = 'Test Account', recordtypeid=accRecordTypeId);
       insert acc;
       
       IARP_Master__c Profession = new IARP_Master__c(Name = 'Plan A');
       insert Profession;
       
       Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
       Contact c = new Contact();
       c.lastname = 'test';
       c.recordtypeid = contactRecordTypeId;
      // c.English_Fluency__c = 'Level 1 - Only introduction and then switches to another language';
       //c.Digital_Literacy__c = 'Level 2 - Comfortable on a tab/computer - has an email account, has uses word/ppt at least once and knows how to search on the internet' ;
       c.Gender__c = 'Male only';
       c.Education_Level__c = 'Graduate';
       c.Available_working_Hours_Start_Time__c =  Time.newInstance(8, 1, 1, 1);
       c.Available_working_Hours_Finish_Time__c = Time.newInstance(9, 1, 1, 1);
       c.Available_work_Days__c = 'Tuesday';
       c.Profession_1__c = Profession.id;
       c.Available_for_Career_Linkage__c = 'Yes';
       c.Type_of_Career_linkage__c = 'Full time Internship';
         c.Plan_A__c = 'Accounting';
        c.Plan_B__c = 'Bodyguard';
       insert c;
       
       OpportunityAssignments.findContactName(c.id);
       
       Id oppLearningRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Training').getRecordTypeId();
       
        Id oppEmploymentRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Education').getRecordTypeId();
       
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
       opp.Salary_in_hand_monthly__c = 10000;
       opp.Payroll_details__c = 'monthly';
       insert opp;
       
       OpportunityAssignments.checkMoreThan3JobsByContact(c.id);
       List<OpportunityAssignments.wrpOpportunityAssignment> lstwrp = OpportunityAssignments.findMatchOpportunity(c.id);
       
       OpportunityAssignments.wrpOpportunityAssignment wrp = lstwrp.get(0);       
       wrp.isAdded = true;
       wrp.OpportunityRT = 'Employment';
             
       
       OpportunityAssignments.findOpportunityName(opp.id);
       OpportunityAssignments.findMatchingContact(opp.id);
       OpportunityAssignments.SaveMatchOpportunity(JSON.serialize(lstwrp),c.id, true);
       opp.Recordtypeid = oppLearningRecordTypeId;
       update opp;
       OpportunityAssignments.findOpportunityName(opp.id);
       OpportunityAssignments.findMatchingContact(opp.id);
       
        
        
      
       
       
    }
    
   /* public static void ValidateOpportunity(){
         OpportunityAssignments.isFirstTime = false;
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
       
       Account acc = new Account(Name = 'Test Account', recordtypeid=accRecordTypeId);
       insert acc;
       
       IARP_Master__c Profession = new IARP_Master__c(Name = 'Plan A');
       insert Profession;
       
       Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
       Contact c = new Contact();
       c.lastname = 'test';
       c.recordtypeid = contactRecordTypeId;
      // c.English_Fluency__c = 'Intermediate - Can understand when spoken to in English and but cannot respond';
       //c.Digital_Literacy__c = 'Level 2 - Comfortable on a tab/computer - has an email account, has uses word/ppt at least once and knows how to search on the internet' ;
       c.Gender__c = 'Male only';
       c.Education_Level__c = 'Graduate';
       c.Available_working_Hours_Start_Time__c =  Time.newInstance(8, 1, 1, 1);
       c.Available_working_Hours_Finish_Time__c = Time.newInstance(9, 1, 1, 1);
       c.Available_work_Days__c = 'Tuesday';
       c.Profession_1__c = Profession.id;
       c.Available_for_Career_Linkage__c = 'Yes';
       c.Type_of_Career_linkage__c = 'Full time Internship';
        c.Plan_A__c = 'Accounting';
        c.Plan_B__c = 'Bodyguard';
       insert c;
       
       OpportunityAssignments.findContactName(c.id);
       
      // Id oppLearningRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Training').getRecordTypeId();
       
        Id oppEmploymentRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Training').getRecordTypeId();
       
       Id oppRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Training').getRecordTypeId();
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
       
       Id oppRecordTypeIdED = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Education').getRecordTypeId();
       Opportunity__c  opp1 = new Opportunity__c();
       opp1.name = 'Test Opporunity';
       opp1.recordtypeid = oppRecordTypeIdED;
       opp1.Educational_Level__c = 'Graduate';
       opp.Type_of_opportunity__c = 'Education';
       opp1.Account__c = acc.id;
       opp1.Gender__c = 'Male only';
       opp1.No_of_Openings__c = 1;
       opp1.Working_Hours_Start_Time__c = Time.newInstance(7, 1, 1, 1);
       opp1.Working_Hours_End_Time__c = Time.newInstance(15, 1, 1, 1);
       opp1.Training_Hours_Start_Time__c = Time.newInstance(7, 1, 1, 1);
       opp1.Training_Hours_End_Time__c = Time.newInstance(15, 1, 1, 1);
       opp1.Work_Days__c = 'Tuesday; Wednesday;';
       opp1.Profession__c = Profession.Name;
       opp1.English_Fluency__c = 'Level 1 - Only introduction and then switches to another language';
       opp1.Digital_Literacy__c = 'Level 2 - Comfortable on a tab/computer - has an email account, has used word/ppt at least once and knows how to search on the internet' ;
       
       insert opp1;
       
       Id oppRecordTypeIdEM = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Employment').getRecordTypeId();
       Opportunity__c  opp2 = new Opportunity__c();
       opp2.name = 'Test Opporunity';
       opp2.recordtypeid = oppRecordTypeIdEM;
       opp2.Educational_Level__c = 'Graduate';
       opp2.Type_of_opportunity__c = 'Education';
       opp2.Account__c = acc.id;
       opp2.Gender__c = 'Male only';
       opp2.No_of_Openings__c = 1;
       opp2.Working_Hours_Start_Time__c = Time.newInstance(7, 1, 1, 1);
       opp2.Working_Hours_End_Time__c = Time.newInstance(15, 1, 1, 1);
       opp2.Training_Hours_Start_Time__c = Time.newInstance(7, 1, 1, 1);
       opp2.Training_Hours_End_Time__c = Time.newInstance(15, 1, 1, 1);
       opp2.Work_Days__c = 'Tuesday; Wednesday;';
       opp.Profession__c = Profession.Name;
       opp2.English_Fluency__c = 'Level 1 - Only introduction and then switches to another language';
       opp2.Digital_Literacy__c = 'Level 2 - Comfortable on a tab/computer - has an email account, has used word/ppt at least once and knows how to search on the internet' ;
       
       insert opp2;
       
       OpportunityAssignments.checkMoreThan3JobsByContact(c.id);
       List<OpportunityAssignments.wrpOpportunityAssignment> lstwrp = OpportunityAssignments.findMatchOpportunity(c.id);
       
       OpportunityAssignments.wrpOpportunityAssignment wrp = lstwrp.get(0);       
       wrp.isAdded = true;
             
       
       OpportunityAssignments.findOpportunityName(opp.id);
       OpportunityAssignments.findMatchingContact(opp.id);
       
       opp.Recordtypeid = oppEmploymentRecordTypeId;
       update opp;
       OpportunityAssignments.findOpportunityName(opp.id);
       OpportunityAssignments.findMatchingContact(opp.id);
       
        
        
      
       OpportunityAssignments.SaveMatchOpportunity(JSON.serialize(lstwrp),c.id, true);
    }*/
}