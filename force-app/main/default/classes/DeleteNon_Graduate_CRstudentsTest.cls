@istest(seealldata=false)
public class DeleteNon_Graduate_CRstudentsTest
{
    
    @isTest static void testmethod1(){
        Id RecordTypeIdcontact = Schema.SObjectType.contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
        contact con1 = new contact(lastname = 'con1',email='abc@gmail.com',API_Status__c='Both APIs Executed',Student_Status__c = 'Enrolled',RecordTypeId=RecordTypeIdcontact);
        contact con2 = new contact(lastname = 'con2',email='cgv@gmail.com',API_Status__c='Both APIs Executed',Student_Status__c = 'Enrolled',RecordTypeId=RecordTypeIdcontact);
        contact con3 = new contact(lastname = 'con3',email='cbh@gmail.com',API_Status__c='Both APIs Executed',Student_Status__c = 'Enrolled',RecordTypeId=RecordTypeIdcontact);
        
        list<contact> conList = new list<contact>();
        conList.add(con1);
        conList.add(con2);
        conList.add(con3);
        insert conList;
        system.debug('inserted' +conList);
        
        Test.startTest();
        DeleteNon_Graduate_CRstudents dt = new DeleteNon_Graduate_CRstudents('select id,API_Status__c,Student_Status__c FROM Contact where API_Status__c=\'Both APIs Executed\' and Student_Status__c !=\'Graduated\' and RecordType.Name =\'CR Student\'');
        database.executeBatch(dt,3);
        
        
        //Delete Records For testing the Else situation
        delete conList;
        Test.stopTest();           
        system.assertEquals(0, [SELECT Id FROM contact].size());
        
        
    }   
}