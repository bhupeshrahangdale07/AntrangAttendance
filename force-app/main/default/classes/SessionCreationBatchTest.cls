@isTest
private class SessionCreationBatchTest {
    @testSetup
    static void setupTestData() {
        // Create test data for Sessions_Historical_Mapping__c
        List<Sessions_Historical_Mapping__c> sessionTemplates = new List<Sessions_Historical_Mapping__c>();
        for (Integer i = 1; i <= 2; i++) {
            sessionTemplates.add(new Sessions_Historical_Mapping__c(
                Name = 'Template ' + i,
                Grade__c = 'Grade 9',
                Session_Number__c = i,
                Description__c = 'Session Desc ' + i
            ));
        }
        insert sessionTemplates;
	
     	Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get('School_Account')
            .getRecordTypeId();
        acc.Name = 'test 01';
        Insert acc;
        
        Contact con = new Contact();
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('CA_Trainer')
            .getRecordTypeId();
        con.LastName = 'test';
        con.Email = 'test@gmail.com';
        con.npe01__WorkEmail__c='test@gmail.com';
        Insert con;
        
        // Create test data for Batch__c
        List<Batch__c> batches = new List<Batch__c>();
        for (Integer i = 0; i < 2; i++) {
            batches.add(new Batch__c(
                Grade__c = 'Grade 9',
                Date_of_facilitation_starting__c = Date.today().addDays(i),
                Trainer_Name__c = con.Id,
                Preferred_Language__c = 'English',
                School_Name__c = acc.id
            ));
        }
        insert batches;

        // Create test data for Contact
        List<Contact> contacts = new List<Contact>();
        for (Batch__c batch : batches) {
            contacts.add(new Contact(
                LastName = 'Test Student',
                Batch_Code__c = batch.Id,
                Day_1__c = 'Present'
            ));
        }
        insert contacts;
    }

    @isTest
    static void testBatchJobExecution() {
        Test.startTest();

        // Instantiate and execute the batch
        SessionCreationBatch batchJob = new SessionCreationBatch('SELECT Id, Grade__c, Facilitation_Start_Date__c, Trainer_Name__c FROM Batch__c');
        Database.executeBatch(batchJob);

        Test.stopTest();

        // Verify sessions were created
        List<Session__c> sessions = [SELECT Id FROM Session__c];
        System.assertEquals(4, sessions.size(), 'Expected 4 sessions to be created');

        // Verify session attendance records
        List<Session_Attendance__c> attendances = [SELECT Id FROM Session_Attendance__c];
        System.assertEquals(4, attendances.size(), 'Expected 4 attendance records to be created');

        // Verify batch update
        List<Batch__c> updatedBatches = [SELECT Manual_Session_Att_creation__c FROM Batch__c];
        for (Batch__c batch : updatedBatches) {
            System.assert(batch.Manual_Session_Att_creation__c, 'Batch should be marked as processed.');
        }
    }

    @isTest
    static void testBatchWithNoRecords() {
        Test.startTest();
        // Run with an empty batch
        SessionCreationBatch batchJob = new SessionCreationBatch('SELECT Id FROM Batch__c WHERE Grade__c = \'Grade 11\'');
        Database.executeBatch(batchJob);
        Test.stopTest();

        // Ensure no sessions are created
        List<Session__c> sessions = [SELECT Id FROM Session__c];
        System.assertEquals(0, sessions.size(), 'No sessions should be created for non-matching records');
    }
}