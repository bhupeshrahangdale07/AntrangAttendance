/*
    Description: Testclass is created for SchoolReportController.
*/
@isTest
private class SchoolReportControllerTest {

    public static testMethod void ReportControllerTest() {
        list < contact > Conlst = new list < contact > ();
        Batch__c batch = new Batch__c();
        State_Govt_Body_Level__c state = new State_Govt_Body_Level__c();
        state.Name = 'SSC';
        insert state;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Pune';
        sm.Name = 'Pune Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 12';
        sm.Description__c = 'description';
        insert sm;

        District_Master__c distict = new District_Master__c();
        distict.State__c = state.id;
        distict.Name = 'Pune';
        insert distict;

        City_Master__c city = new City_Master__c();
        city.District__c = distict.id;
        city.Name = 'Kalyan';
        insert city;

        Ward_Master__c ward = new Ward_Master__c();
        ward.City__c = city.id;
        ward.Name = 'West Kalyan';
        insert ward;

        Account account = new Account();
        account.Partner__c = 'Aangan Trust';
        account.Name = 'Shreeram School';
        account.State__c = state.id;
        account.Ward__c = ward.id;
        account.City__c = city.id;
        account.District__c = distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId = RecordTypeIdAccount;
        insert account;

        Batch__c batch1 = new Batch__c();
        batch1.Name = 'Batch 7';
        batch1.Grade__c = 'Grade 12';
        batch1.Number_of_students_facilitated__c = 1.0;
        batch1.Preferred_Language__c = 'Hindi';
        batch1.School_Name__c = account.id;
        batch1.Date_of_facilitation_starting__c = system.today();
        batch1.Date_of_facilitation_completion__c = system.today()+5;
        

        insert batch1;

        IARP_Master__c iarp = new IARP_Master__c();
        iarp.Name = 'Doctor';
        iarp.Sector__c = 'Education';
        insert iarp;
        IARP_Master__c iarp1 = new IARP_Master__c();
        iarp1.Name = 'IT';
        iarp1.Sector__c = 'Sports and Fitness';
        insert iarp1;
        IARP_Master__c iarp2 = new IARP_Master__c();
        iarp2.Name = 'Doctor';
        iarp2.Sector__c = 'Education';
        insert iarp2;
        IARP_Master__c iarp3 = new IARP_Master__c();
        iarp3.Name = 'IT';
        iarp3.Sector__c = 'Sports and Fitness';
        insert iarp3;

        Contact contact = new Contact();
        contact.FirstName = 'Kurund12';
        contact.LastName = 'Jalmi';
        contact.Clarity_Report__c = 'Yes';
        contact.Career_Tracks__c = 6;
        contact.Interest_1__c = 'Social';
        contact.Interest_2__c = 'Enterprising';
        contact.Aptitude_1__c = 'Verbal';
        contact.Aptitude_2__c = 'Mechanical';
        contact.Personality_1__c = 'Extrovert';
        contact.Personality_2__c = 'Extrovert';
        contact.Personality_3__c = 'Practical';
        contact.Personality_4__c = 'Practical';
        contact.Personality_5__c = 'Thoughtful';
        contact.Personality_6__c = 'Conservative';
        contact.Personality_7__c = 'Talkative';
        contact.Personality_8__c = 'Bold';
        contact.Reality_1__c = 'No';
        contact.Reality_2__c = 'No';
        contact.Reality_3__c = 'No';
        contact.Reality_4__c = 'No';
        contact.Reality_5__c = 'No';
        contact.Reality_6__c = 'No';
        contact.Reality_7__c = 'No';
        contact.Reality_8__c = 'No';
        contact.Profession_1__c = null;
        contact.Profession_1_Next_steps__c = 'To be a school teacher - Students must complete 12th grade in any stream';
        contact.Profession_1_Recommendation__c = 'Teacher';
        contact.Profession_2__c = null;
        contact.Profession_2_Next_steps__c = '';
        contact.Profession_2_Recommendation__c = 'Fitness Instructor';
        contact.Batch_Code__c = batch1.id;
        contact.Gender__c = 'Male';
        contact.Profession_1__c = iarp1.id;
        contact.Profession_2__c = iarp.id;
        contact.Possible_Careers_1__c = iarp1.Id;
        contact.Student_Attendance__c = 'Present';
        contact.Possible_Career_Report__c = 2;
        Conlst.add(contact);

        Contact contact1 = new Contact();
        contact1.FirstName = 'Kurund13';
        contact1.LastName = 'Jalmi1';
        contact1.Batch_Code__c = batch.id;
        contact1.Gender__c = 'Female';
        contact1.Clarity_Report__c = 'Yes';
        contact1.Career_Tracks__c = 6;
        contact1.Interest_1__c = 'Social';
        contact1.Interest_2__c = 'Enterprising';
        contact1.Aptitude_1__c = 'Verbal';
        contact1.Aptitude_2__c = 'Mechanical';
        contact1.Personality_1__c = 'Extrovert';
        contact1.Personality_2__c = 'Extrovert';
        contact1.Personality_3__c = 'Practical';
        contact1.Personality_4__c = 'Practical';
        contact1.Personality_5__c = 'Thoughtful';
        contact1.Personality_6__c = 'Conservative';
        contact1.Personality_7__c = 'Talkative';
        contact1.Personality_8__c = 'Bold';
        contact1.Reality_1__c = 'No';
        contact1.Reality_2__c = 'No';
        contact1.Reality_3__c = 'No';
        contact1.Reality_4__c = 'No';
        contact1.Reality_5__c = 'No';
        contact1.Reality_6__c = 'No';
        contact1.Reality_7__c = 'No';
        contact1.Reality_8__c = 'No';
        contact1.Profession_1__c = null;
        contact1.Profession_1_Next_steps__c = 'To be a school teacher - Students must complete 12th grade in any stream';
        contact1.Profession_1_Recommendation__c = 'Teacher';
        contact1.Profession_2__c = null;
        contact1.Profession_2_Next_steps__c = '';
        contact1.Profession_2_Recommendation__c = 'Fitness Instructor';
        contact1.Batch_Code__c = batch1.id;
        contact1.Gender__c = 'Female';
        contact1.Profession_1__c = iarp3.id;
        contact1.Profession_2__c = iarp.id;
        contact1.Student_Attendance__c = 'Present';
        contact1.Possible_Career_Report__c = 2;
        Conlst.add(contact1);

        Contact contact2 = new Contact();
        contact2.FirstName = 'Kurund13';
        contact2.LastName = 'Jalmi1';
        contact2.Batch_Code__c = batch.id;
        contact2.Gender__c = 'Female';
        contact2.Clarity_Report__c = 'Yes';
        contact2.Career_Tracks__c = 6;
        contact2.Interest_1__c = 'Social';
        contact2.Interest_2__c = 'Enterprising';
        contact2.Aptitude_1__c = 'Verbal';
        contact2.Aptitude_2__c = 'Mechanical';
        contact2.Personality_1__c = 'Extrovert';
        contact2.Personality_2__c = 'Extrovert';
        contact2.Personality_3__c = 'Practical';
        contact2.Personality_4__c = 'Practical';
        contact2.Personality_5__c = 'Thoughtful';
        contact2.Personality_6__c = 'Conservative';
        contact2.Personality_7__c = 'Talkative';
        contact2.Personality_8__c = 'Bold';
        contact2.Reality_1__c = 'No';
        contact2.Reality_2__c = 'No';
        contact2.Reality_3__c = 'No';
        contact2.Reality_4__c = 'No';
        contact2.Reality_5__c = 'No';
        contact2.Reality_6__c = 'No';
        contact2.Reality_7__c = 'No';
        contact2.Reality_8__c = 'No';
        contact2.Profession_1__c = null;
        contact2.Profession_1_Next_steps__c = 'To be a school teacher - Students must complete 12th grade in any stream';
        contact2.Profession_1_Recommendation__c = 'Teacher';
        contact2.Profession_2__c = null;
        contact2.Profession_2_Next_steps__c = '';
        contact2.Profession_2_Recommendation__c = 'Fitness Instructor';
        contact2.Batch_Code__c = batch1.id;
        contact2.Gender__c = 'Female';
        contact2.Profession_1__c = iarp2.id;
        contact2.Profession_2__c = iarp.id;
        contact2.Student_Attendance__c = 'Present';
        contact2.Possible_Careers_1__c = iarp1.Id;
        contact2.Possible_Career_Report__c = 3;
        Conlst.add(contact2);

        insert Conlst;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(account);
        SchoolReportController dt2 = new SchoolReportController(sc);
        dt2.CalculateReport();

        Test.startTest();
        
        Apexpages.currentpage().getParameters().put('selectedYear', '2019-20');
        sc = new ApexPages.StandardController(account);
        dt2 = new SchoolReportController(sc);
        dt2.CalculateReport();

        Test.stopTest();

    }

}