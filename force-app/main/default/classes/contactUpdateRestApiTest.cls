@isTest
public class contactUpdateRestApiTest {
    
    @isTest
    static void ValidateConatctRESTApiTest(){
        Test.startTest();
        
       RestResponse res = new RestResponse();
       RestRequest req = new RestRequest();
        
        
       Contact con =new Contact();
        con.FirstName='Test12';
        con.LastName='LN';
        
        insert con;
         String JsonMsg='{"Detail": [{"Salutation": "test","firstName": "testing","lastName": "testbk1","uid": "32","monthly_salary_currently": 0,'+
         '"phone": "8528528525","mobilephone": "9696969696","homePhone": "8542158721","otherphone": "8542158722","email": "tets@abc.com","marital_status": "single",'+
         '"birthdate": "2019-05-08","gender": "male","education" : "ITI","english_fluency": "Not present","digital_literacy": "Level 4","plan_a": "Accounting",'+
         '"available_for_career_linkage": "no","reason_for_career_linkage_unavilability": "Currently working","type_of_career_linkage": "Part time employment",'+
         '"additional_courses": "Basic Tally;Advanced Excel","location": "Andheri","zone": "Airoli","education_status": "Completed","education_level": "Graduate",'+
         '"plan_b": "Animation","available_work_days": "Monday;Tuesday","available_working_hours_start_time": "04:00:00","available_working_hours_finish_time": "08:00:00", '+
         '"work_experience_total": "-1","isdeleted": false,"blacklisted": "no","app_password": "pass","disable_app_login": true,"trainer_s_contact_no": "852125634",'+
         '"student_last_login_date": "2019-06-09","student_profile_picture": "http://dummy.restapiexample.com/api/v1/create","id": "'+con.id+'",'+
         '"createddate": "2019-06-03 04:00:00","lastmodifieddate": "2019-06-03 04:00:00"}, {"Salutation": "test","firstName": "testing","lastName": "testbk1","uid": "32","monthly_salary_currently": 0,'+
         '"phone": "8528528525","mobilephone": "9696969696","homePhone": "8542158721","email": "tets@abc.com","marital_status": "single",'+
         '"birthdate": "2019-05-08","gender": "male","english_fluency": "Not present","education" : "ITI","digital_literacy": "Level 4","plan_a": "Accounting",'+
         '"available_for_career_linkage": "no","reason_for_career_linkage_unavilability": "Currently working","type_of_career_linkage": "Part time employment",'+
         '"additional_courses": "Basic Tally;Advanced Excel","location": "Andheri","zone": "Airoli","education_status": "Completed","education_level": "Graduate",'+
         '"plan_b": "Animation","available_work_days": "Monday;Tuesday","available_working_hours_start_time": "04:00:00","available_working_hours_finish_time": "08:00:00", '+
         '"work_experience_total": "-1","isdeleted": false,"blacklisted": "no","app_password": "pass","disable_app_login": true,"trainer_s_contact_no": "852125634",'+
         '"student_last_login_date": "2019-06-09","student_profile_picture": "http://dummy.restapiexample.com/api/v1/create","id": "",'+
         '"createddate": "2019-06-03 04:00:00","lastmodifieddate": "2019-06-03 04:00:00"}]}';
       
         system.debug(JsonMsg);
        
        req.requestUri = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/placements/students';
        req.httpMethod = 'post';
        req.requestBody = Blob.valueof(JsonMsg);
       
        RestContext.request = req;
        RestContext.response= res;
        
        contactUpdateRestApi.findallcontact();
                
        Test.stopTest();            
    }
    
}