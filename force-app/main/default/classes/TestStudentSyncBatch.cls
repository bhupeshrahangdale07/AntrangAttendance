@isTest
public class TestStudentSyncBatch {
    @isTest static void testDemo() {

        Student_Sync_Setting__c sss = new Student_Sync_Setting__c();
        sss.Name = 'StudentSyncAPIs';
        sss.Last_Sync_Date__c = System.today().addDays(-5);
        Insert sss;

        Test.startTest();

        String json=    '['+
                        '    {'+
                        '"batch_type": "College",'+
'"community_college_name": "BM Ruia College - SNDT",'+
'"student_firstname": "Aarti",'+
'"student_lastname": "Yadav",'+
'"uid": "1x3075",'+
'"gender": "F",'+
'"batch_code": "BMRG1",'+
'"trainer_name": "Zahabiya bagasrawala,Test",'+
'"trainer_status": "Active;Inactive",'+
'"student_contact_1": "9757373933",'+
'"student_contact_2": "",'+
'"student_contact_3": "",'+
'"dob": "15-Apr-1995",'+
'"interest_mapping_code_1": "Social",'+
'"interest_mapping_code_2": "Enterprising",'+
'"aptitude_highest": "Numerical",'+
'"aptitude_second_highest": "Mechanical",'+
'"personality_1": "Extrovert",'+
'"personality_2": "",'+
'"personality_3": "",'+
'"personality_4": "",'+
'"reality_1_self": "Yes",'+
'"reality_2_self": "Yes",'+
'"reality_3_self": "Yes",'+
'"reality_4_self": "",'+
'"reality_5_family": "Yes",'+
'"reality_6_family": "",'+
'"reality_7_family": "",'+
'"reality_8_family": "",'+
'"plan_a": "",'+
'"plan_b": "",'+
'"current_education": "",'+
'"student_address": "292/94 New Marwadi Chawl, Senapati Bapat Marg",'+
'"location_name": "Dadar Central & Dadar Western",'+
'"student_pincode": "400014",'+
'"household_income": "",'+
'"mother_education": "",'+
'"father_education": "",'+
'"mother_sector_of_employment": "",'+
'"father_sector_of_employment": "",'+
'"sibling1_sector_of_employment": "",'+
'"sibling1_education": "",'+
'"expected_salary_after_antarang_career_connect": "",'+
'"student_email": "aartiyadav9867@gmail.com",'+
'"working_not_through_af": "",'+
'"sector_of_employment_not_through_af": "",'+
'"current_salary_not_through_af": "",'+
'"batch_start_date": "19-Oct-2018",'+
'"batch_end_date": "22-Nov-2018",'+
'"donor_name": "",'+
'"mock_session_date": "15-Nov-2018"'+
                        '    },{'+
                        '"batch_type": "College",'+
'"community_college_name": "BM Ruia College - SNDT",'+
'"student_firstname": "Anjana",'+
'"student_lastname": "Meena",'+
'"uid": "1x3076",'+
'"gender": "F",'+
'"batch_code": "BMRG1",'+
'"trainer_name": "Zahabiya bagasrawala,Zahabiya bagasrawala",'+
'"trainer_status": "Active;Inactive",'+
'"student_contact_1": "8879945887",'+
'"student_contact_2": "90049910470",'+
'"student_contact_3": "",'+
'"dob": "04-Sep-1997",'+
'"interest_mapping_code_1": "Conventional",'+
'"interest_mapping_code_2": "Enterprising",'+
'"aptitude_highest": "Numerical",'+
'"aptitude_second_highest": "Vocabulary",'+
'"personality_1": "Extrovert",'+
'"personality_2": "",'+
'"personality_3": "",'+
'"personality_4": "",'+
'"reality_1_self": "",'+
'"reality_2_self": "",'+
'"reality_3_self": "",'+
'"reality_4_self": "",'+
'"reality_5_family": "",'+
'"reality_6_family": "",'+
'"reality_7_family": "",'+
'"reality_8_family": "",'+
'"plan_a": "",'+
'"plan_b": "",'+
'"current_education": "",'+
'"student_address": "A/33 8th Floor Central railway Colony, Berlery Palaces",'+
'"location_name": "Byculla",'+
'"student_pincode": "400027",'+
'"household_income": "",'+
'"mother_education": "",'+
'"father_education": "",'+
'"mother_sector_of_employment": "",'+
'"father_sector_of_employment": "",'+
'"sibling1_sector_of_employment": "",'+
'"sibling1_education": "",'+
'"expected_salary_after_antarang_career_connect": "",'+
'"student_email": "iamanjanameena@gmail.com",'+
'"working_not_through_af": "",'+
'"sector_of_employment_not_through_af": "",'+
'"current_salary_not_through_af": "",'+
'"batch_start_date": "19-Oct-2018",'+
'"batch_end_date": "22-Nov-2018",'+
'"donor_name": "",'+
'"mock_session_date": "15-Nov-2018"'+
                        '    }]';

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, 'ok', json, null));

        
        Date fromDate = Date.Today().toStartOfMonth();
        Date toDate = Date.Today();
        //executing batch directly
        StudentSyncBatch b = new StudentSyncBatch(fromDate, toDate);
        database.executebatch(b);


        //executing scheduler which will execute batch
        StudentSyncScheduler obj = new StudentSyncScheduler();   
        String chron = '0 0 23 * * ?';        
        String jobid = System.schedule('testScheduledApex', chron, obj);

        CronTrigger ct = [Select id , CronExpression from CronTrigger where id = :jobId];
        System.assertEquals(chron,ct.CronExpression); 
        

        Test.stopTest();    

        List<Contact> lstcon = new List<Contact>([select id,UID__c from Contact ]);
        system.debug('con####'  + lstcon);

        StudentJSONParser objJSONP = new StudentJSONParser();

        //system.assertEquals([select id from Contact where UID__c in ('2293','22932')].size(), 2);
    }
}