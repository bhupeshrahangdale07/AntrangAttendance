@isTest
public class CreateOppAssignmentsForTrainingCon_Test {

    public static testMethod void CreateOppassTest() {
        list<id> conid = new list<id>();
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        Account acc = new Account(Name = 'Test Account', recordtypeid=accRecordTypeId);
        insert acc;
       
        Contact con =new Contact();
        con.FirstName='Test12';
        con.LastName='LN';
        con.Additional_courses__c = 'Advanced Excel;Public Relations;';
        Id RecordTypeIdContact = Schema.SObjectType.contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
        con.RecordTypeId=RecordTypeIdContact;
        con.Education_Status__c = 'Completed';
        insert con;
        conid.add(con.id);
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('External Training').getRecordTypeId();
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
        opp.Work_Days__c = 'Tuesday; Wednesday;';
        insert opp;
        
        test.startTest();
        CreateOppAssignmentsForTrainingCon COAE = new CreateOppAssignmentsForTrainingCon();
        CreateOppAssignmentsForTrainingCon.wrapContact wrp = new CreateOppAssignmentsForTrainingCon.wrapContact();
        wrp.opptyid = opp.id;
        wrp.LstConIds = con.id;
        CreateOppAssignmentsForTrainingCon.updateACSE_AVSE(new list< CreateOppAssignmentsForTrainingCon.wrapContact>{wrp});
        test.stopTest();
       
    }

}