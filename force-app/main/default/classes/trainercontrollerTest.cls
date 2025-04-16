@isTest
public class trainercontrollerTest {
  @TestSetup
  static void makeData() {
    Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName()
      .get('School')
      .getRecordTypeId();
    Account acc = new Account(
      Name = 'Salesforce',
      RecordTypeId = RecordTypeIdAccount
    );
    insert acc;

    Student_Feedback_mapping__c sfm = new Student_Feedback_mapping__c();
    sfm.Day_Number__c = 'Day-1';
    sfm.Field_API__c = 'Name';
    sfm.Field_Label__c = 'Student Name';
    sfm.Object_API_Name__c = 'Contact';
    sfm.Language__c = 'eng';
    insert sfm;

    TriggerCheck triggerCheck = new TriggerCheck();
    Batch__c batch = new Batch__c();
    batch.Preferred_Language__c = 'Hindi';
    batch.School_Name__c = acc.id;
    batch.Name = 'Batch 7';
    batch.Number_of_students_facilitated__c = 0.0;
    insert batch;

    AntarangSetting__c CS = AntarangSetting__c.getOrgDefaults();
    CS.Enable_Contact_Trigger__c = true;
    upsert cs AntarangSetting__c.Id;

    contact con = new Contact();
    con.FirstName = 'fname';
    con.LastName = 'lname';
    con.Followup1Aspiration__c = 'Accountant';
    con.Follow_up_1_Step_1__c = 'HSC-Science';
    con.Aspiration_via_conf_call__c = 'Accountant';
    con.Batch_Code__c = batch.Id;
    con.Additional_CA_Call_1__c = 'Present';
    con.email = 'Test@gmail.com';
    insert con;
    
    trainercontroller.checkEmailExist(con.email);
    trainercontroller.IdentifyStudent(acc.id,batch.id);

    IARP_Master__c iarp0 = new IARP_Master__c(Name = 'Accountant');
    IARP_Master__c iarp1 = new IARP_Master__c(Name = 'Beautician');
    IARP_Master__c iarp2 = new IARP_Master__c(Name = 'Banking');
    IARP_Master__c iarp3 = new IARP_Master__c(Name = 'Actor');
    List<IARP_Master__c> lstIARP = new List<IARP_Master__c>{
      iarp0,
      iarp1,
      iarp2,
      iarp3
    };
    insert lstIARP;
    trainercontroller.additionalcacalltrue(con.id);
  }

  @isTest
  public static void testGetRecords() {
    test.startTest();
    List<SObject> accounts = trainercontroller.getRecords(
      'sales',
      'Account',
      'Id',
      'Name',
      'Name',
      null,
      10
    );
    System.assertEquals(1, accounts.size());
    accounts = trainercontroller.getRecords(
      'abc',
      'Account',
      'Id',
      'Name',
      'Name',
      '',
      100
    );
    System.assertEquals(0, accounts.size());
    test.stopTest();
  }

  @isTest
  public static void testgetAccountBatches() {
    List<Account> accounts = [SELECT Id FROM Account LIMIT 1];
    test.startTest();
    trainercontroller.getAccountBatches(accounts[0].Id);
    test.stopTest();
  }

  @isTest
  public static void testgetMappingRecords() {
    test.startTest();
    List<Student_Feedback_mapping__c> lst_sfm = trainercontroller.getMappingRecords(
      'Day-1',
      'eng'
    );
    System.assertEquals(1, lst_sfm.size());

    Contact c = [SELECT Id FROM Contact LIMIT 1];
    trainercontroller.findDay1Data(c.Id);
    lst_sfm = trainercontroller.getMappingRecords('Day-2', 'eng');
    trainercontroller.findcontactrecommendation(c.Id);
    test.stopTest();
  }

  @isTest
  public static void testsavecontactPage1() {
    List<Contact> contacts = [
      SELECT Id, Name, Batch_Code__c, Batch_Code__r.School_Name__c
      FROM Contact
      LIMIT 1
    ];
    trainercontroller.wrpcon wrpcon = new trainercontroller.wrpcon();
    wrpcon.accountid = contacts[0].Batch_Code__r.School_Name__c;
    wrpcon.contactid = contacts[0].Id;
    wrpcon.batchid = contacts[0].Batch_Code__c;
    wrpcon.pagenumber = '1';
    wrpcon.daynumber = '1';
    wrpcon.dob = String.valueOf(System.today().addYears(-20));
    wrpcon.PossibleCareers1 = 'Actor';
    wrpcon.PossibleCareers2 = 'Accountant';
    wrpcon.PossibleCareers3 = 'Banking';

    String jsonString = JSON.serialize(wrpcon);
    System.debug(jsonString);

    test.startTest();
    trainercontroller.savecontact(JSON.serialize(wrpcon));
    wrpcon.daynumber = '2';
    trainercontroller.savecontact(JSON.serialize(wrpcon));
    wrpcon.daynumber = '5';
    trainercontroller.savecontact(JSON.serialize(wrpcon));
    wrpcon.daynumber = '3';
    trainercontroller.savecontact(JSON.serialize(wrpcon));
    wrpcon.daynumber = '4';
    trainercontroller.savecontact(JSON.serialize(wrpcon));
    test.stopTest();
  }

  @isTest
  public static void testsavecontactPage2() {
    List<Contact> contacts = [
      SELECT Id, Name, Batch_Code__c, Batch_Code__r.School_Name__c
      FROM Contact
      LIMIT 1
    ];
    trainercontroller.wrpcon wrpcon = new trainercontroller.wrpcon();
    wrpcon.accountid = contacts[0].Batch_Code__r.School_Name__c;
    wrpcon.contactid = contacts[0].Id;
    wrpcon.batchid = contacts[0].Batch_Code__c;
    wrpcon.pagenumber = '2';
    wrpcon.daynumber = '1';
    wrpcon.dob = String.valueOf(System.today().addYears(-20));
    wrpcon.PossibleCareers1 = 'Actor';
    wrpcon.PossibleCareers2 = 'Accountant';
    wrpcon.PossibleCareers3 = 'Banking';
    wrpcon.Gender ='Male';


    String jsonString = JSON.serialize(wrpcon);
    System.debug(jsonString);

    test.startTest();
    trainercontroller.savecontact(JSON.serialize(wrpcon));
    wrpcon.daynumber = '2';
    trainercontroller.savecontact(JSON.serialize(wrpcon));
    wrpcon.daynumber = '5';
    trainercontroller.savecontact(JSON.serialize(wrpcon));
    test.stopTest();
  }
}