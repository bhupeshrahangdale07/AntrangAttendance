@isTest
public class TestUpdateDisableAppLogin 
{

 static testMethod void ValidateAppLogin() {
     
 Contact c1 = new Contact(LastName='dig1', Graduate_Date__c=date.valueOf('2017-09-18'));
 System.debug('LastName: ' + c1.Lastname);
  Contact c2 = new Contact(LastName='dig2', Graduate_Date__c=date.valueOf('2017-09-18'));
 System.debug('LastName: ' + c2.Lastname);
  insert c1;
 insert c2;
 Test.startTest();
    UpdateDisableAppLogin check= new UpdateDisableAppLogin();
    //String sch = '0 0 23 * * ?';
    //system.schedule('Test check', sch, check);
    Database.executeBatch( check );
 
 Test.stopTest();


 System.assert(c1.Id != null);
     System.assert(c2.Id != null);
 }
}