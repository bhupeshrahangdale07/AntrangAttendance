/*
    Description: Test class for Student Report
*/
@isTest
public with sharing class StudentReportTest {
    
     public static testMethod void test(){
         Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Mumbai';
        sm.Name = 'Mumbai Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'description';
        insert sm;
         
        Batch__c batch=new Batch__c();
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='GOA';
        insert state;
         
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Mumbai';
        insert distict;
        
        City_Master__c city =new City_Master__c();
        city.District__c=distict.id;
        city.Name='Kalyan'; 
        insert city;
        
        Ward_Master__c ward=new Ward_Master__c();
        ward.City__c=city.id;
        ward.Name='West Kalyan';
        insert ward;
        
        Account account=new Account();
        account.Name='Shreeram School';
        account.State__c=state.id;
        account.Ward__c=ward.id;
        account.City__c=city.id;
        account.District__c=distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
        
        
        batch.School_Name__c=account.id;
        batch.Preferred_Language__c='Hindi';
        
        Account account1=new Account();
        account1.Name='Shreeram School Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId=RecordTypeIdAccount1;
        account1.Number_of_batches_pending__c=1.0;
        account1.Number_of_batches_allocated__c=2.0;
        account1.Number_of_batches_funded__c=1.0;
        insert account1;
        
        Contact contact=new Contact();
        contact.FirstName='Test';
        contact.LastName='LName';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Trainer').getRecordTypeId();
        contact.RecordTypeId=RecordTypeIdContact;
        insert contact;
         
        batch.Trainer_Name__c=contact.id;
        
        batch.Donor_Name__c=account1.id;
        batch.Name='Batch 7';
        batch.Grade__c='Grade 12';
        batch.Number_of_students_facilitated__c=1.0;
        batch.Preferred_Language__c = 'Hindi';
        insert batch;
        
        List<Explanations__c> explanations =new List<Explanations__c>{ 
           new Explanations__c(Name='Interest',Code__c='Enterprising - E',Particulars__c='Enterprising people like to lead, influence people and are able to negotiate and persuade well.'),
           new Explanations__c(Name='Interest',Code__c='Social - S',Particulars__c='Social people like to be with people and provide information or services to help, train or cure people.'),
           new Explanations__c(Name='Aptitude',Code__c='Verbal Ability',Particulars__c='Verbal ability is the ability to reason with words, to understand and use concepts expressed in words.'),
           new Explanations__c(Name='Aptitude',Code__c='Mechanical Ability',Particulars__c='Mechanical ability is the ability to understand and apply concepts related to tools.'),
           new Explanations__c(Name='Personality',Code__c='Extrovert,Sensing,Thinking,Judging',Particulars__c='Extroverts'),
           new Explanations__c(Name='Realities',Code__c='Self 1',Realities__c='Yes',Particulars__c='Student has family member(s) that have studied upto 12th Grade'),
           new Explanations__c(Name='Realities',Code__c='Self 1',Realities__c='No',Particulars__c='Student does not have family member(s) that have studied upto 12th Grade'),
           new Explanations__c(Name='Realities',Code__c='Self 2',Realities__c='Yes',Particulars__c='Student family allows everyone including women to work past 10pm.'),
           new Explanations__c(Name='Realities',Code__c='Self 2',Realities__c='No',Particulars__c='Student family does not allow women to work past 10pm'),
           new Explanations__c(Name='Realities',Code__c='Self 3',Realities__c='Yes',Particulars__c='Student family income is above INR 20,000 per month'),
           new Explanations__c(Name='Realities',Code__c='Self 3',Realities__c='No',Particulars__c='Student family income is below INR 20,000 per month'),
           new Explanations__c(Name='Realities',Code__c='Self 4',Realities__c='A',Particulars__c='Student family will  provide monetary support for education'),
           new Explanations__c(Name='Realities',Code__c='Self 4',Realities__c='B',Particulars__c='Student family will not provide monetary support for education'),
           new Explanations__c(Name='Realities',Code__c='Self 4',Realities__c='C',Particulars__c='Student family will not provide monetary support for education'),
           new Explanations__c(Name='Realities',Code__c='Family 1',Realities__c='Yes',Particulars__c='Student will not get married till atleast 22 years of age'),
           new Explanations__c(Name='Realities',Code__c='Family 1',Realities__c='No',Particulars__c='Student will get married before 22 years of age'),
           new Explanations__c(Name='Realities',Code__c='Family 2',Realities__c='Yes',Particulars__c='Student will be the fIrst to work in the organized sector in their family'),
           new Explanations__c(Name='Realities',Code__c='Family 2',Realities__c='No',Particulars__c='Student will not get married till atleast 22 years of ageStudent will not be the fIrst to work in the organized sector in their family'),
           new Explanations__c(Name='Realities',Code__c='Family 3',Realities__c='Yes',Particulars__c='Students is already working for 1+ years'),
           new Explanations__c(Name='Realities',Code__c='Family 3',Realities__c='No',Particulars__c='Students is not working for 1+ years'),
           new Explanations__c(Name='Realities',Code__c='Family 4',Realities__c='A',Particulars__c='Student is calm and does not get angry'),
           new Explanations__c(Name='Realities',Code__c='Family 4',Realities__c='B',Particulars__c='Student is not calm and gets angry'),
           new Explanations__c(Name='Realities',Code__c='Family 4',Realities__c='C',Particulars__c='Student is not calm and gets angry')};
        insert explanations;
       
        IARP_Master__c iarp=new IARP_Master__c();
        iarp.Name = 'Teacher';
        iarp.Sector__c = 'Education';
        iarp.Additional_Info__c = 'Education';
        iarp.After_10th__c = 'After 10th';
        iarp.After_12th__c = 'After 12th';
        iarp.Famous_Person__c = 'Famous Person';
        iarp.Avg_Salary__c = 'Avg Person';
        iarp.Fun_Fact__c = 'Fun Fact';
        insert iarp;
        
        IARP_Master__c iarp1=new IARP_Master__c();
        iarp1.Name='Fitness Instructor';
        iarp1.Sector__c='Sports and Fitness';
        iarp1.Additional_Info__c = 'Education';
        iarp1.After_10th__c = 'After 10th';
        iarp1.After_12th__c = 'After 12th';
        iarp1.Famous_Person__c = 'Famous Person';
        iarp1.Avg_Salary__c = 'Avg Person';
        iarp1.Fun_Fact__c = 'Fun Fact';
        insert iarp1;
        
        Contact contact1=new Contact();
        contact1.FirstName='Kurund123';
        contact1.LastName='Jalmi12';
        Id RecordTypeIdStudent = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        contact1.RecordTypeId=RecordTypeIdStudent;
        contact1.Batch_Code__c=batch.id;
        contact1.Current_Aspiration__c='SELF EMPLOYED';
        contact1.Age__c=25;
        contact1.Aspiration_1__c = iarp.Id;
        contact1.Aspiration_2__c = iarp1.Id;
        contact1.Aspiration_3__c = iarp1.Id;
        contact1.Interest_1__c='Social';
        contact1.Interest_2__c='Enterprising';
        contact1.Aptitude_1__c='Verbal';
        contact1.Aptitude_2__c='Mechanical';
        contact1.Personality_1__c='Extrovert';
        contact1.Personality_2__c='Sensing';
        contact1.Personality_3__c='Thinking';
        contact1.Personality_4__c='Judging';
        contact1.Reality_1__c='Yes';
        contact1.Reality_2__c='Yes';
        contact1.Reality_3__c='Yes';
        contact1.Reality_4__c='A';
        contact1.Reality_5__c='Yes';
        contact1.Reality_6__c='Yes';
        contact1.Reality_7__c='Yes';
        contact1.Reality_8__c='A';
        contact1.Profession_1__c = iarp.id;
        contact1.Profession_1_Next_steps__c='To be a school teacher - Students must complete 12th grade in any stream';
        contact1.Profession_1_Recommendation__c='Teacher';
        contact1.Profession_2__c=iarp1.id;
        contact1.Profession_2_Next_steps__c='';
        contact1.Profession_2_Recommendation__c='Fitness Instructor';
        contact1.Recommedation_Status__c = 'Processed';
        contact1.Batch_Code__c=batch.id;
        insert contact1;
        
       
        
        ApexPages.StandardController sc = new ApexPages.StandardController(contact1);
        StudentReportController studentreport = new StudentReportController(sc);
        
        StudentReportBatchController studentbatchreport = new StudentReportBatchController(new ApexPages.StandardController(batch));
        
        StudentReportComponentController componetreport = new StudentReportComponentController();
        componetreport.wrapStudentReport = studentbatchreport.lstStudentReports[0];
        componetreport.setStudentReportWrap(studentbatchreport.lstStudentReports[0]);
        
        contact1.Reality_1__c='No';
        contact1.Reality_2__c='No';
        contact1.Reality_3__c='No';
        contact1.Reality_4__c='A';
        contact1.Reality_5__c='No';
        contact1.Reality_6__c='No';
        contact1.Reality_7__c='No';
        contact1.Reality_8__c='A';
        update contact1;
        
        studentbatchreport = new StudentReportBatchController(new ApexPages.StandardController(batch));
         
    }
    
     public static testMethod void test1(){
         Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Mumbai';
        sm.Name = 'Mumbai Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'description';
        insert sm;
         
        Batch__c batch=new Batch__c();
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='GOA';
        insert state;
         
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Mumbai';
        insert distict;
        
        City_Master__c city =new City_Master__c();
        city.District__c=distict.id;
        city.Name='Kalyan'; 
        insert city;
        
        Ward_Master__c ward=new Ward_Master__c();
        ward.City__c=city.id;
        ward.Name='West Kalyan';
        insert ward;
        
        Account account=new Account();
        account.Name='Shreeram School';
        account.State__c=state.id;
        account.Ward__c=ward.id;
        account.City__c=city.id;
        account.District__c=distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
        
        
        batch.School_Name__c=account.id;
        batch.Preferred_Language__c='English';
        
        Account account1=new Account();
        account1.Name='Shreeram School Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId=RecordTypeIdAccount1;
        account1.Number_of_batches_pending__c=1.0;
        account1.Number_of_batches_allocated__c=2.0;
        account1.Number_of_batches_funded__c=1.0;
        insert account1;
        
        Contact contact=new Contact();
        contact.FirstName='Test';
        contact.LastName='LName';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Trainer').getRecordTypeId();
        contact.RecordTypeId=RecordTypeIdContact;
        insert contact;
         
        batch.Trainer_Name__c=contact.id;
        
        batch.Donor_Name__c=account1.id;
        batch.Name='Batch 7';
        batch.Grade__c='Grade 12';
        batch.Number_of_students_facilitated__c=1.0;
        batch.Preferred_Language__c = 'English';
        insert batch;
        
        List<Explanations__c> explanations =new List<Explanations__c>{ 
           new Explanations__c(Name='Interest',Code__c='Enterprising - E',Particulars__c='Enterprising people like to lead, influence people and are able to negotiate and persuade well.'),
           new Explanations__c(Name='Interest',Code__c='Social - S',Particulars__c='Social people like to be with people and provide information or services to help, train or cure people.'),
           new Explanations__c(Name='Aptitude',Code__c='Verbal Ability',Particulars__c='Verbal ability is the ability to reason with words, to understand and use concepts expressed in words.'),
           new Explanations__c(Name='Aptitude',Code__c='Mechanical Ability',Particulars__c='Mechanical ability is the ability to understand and apply concepts related to tools.'),
           new Explanations__c(Name='Personality',Code__c='Extrovert,Sensing,Thinking,Judging',Particulars__c='Extroverts'),
           new Explanations__c(Name='Realities',Code__c='Self 1',Realities__c='Yes',Particulars__c='Student has family member(s) that have studied upto 12th Grade'),
           new Explanations__c(Name='Realities',Code__c='Self 1',Realities__c='No',Particulars__c='Student does not have family member(s) that have studied upto 12th Grade'),
           new Explanations__c(Name='Realities',Code__c='Self 2',Realities__c='Yes',Particulars__c='Student family allows everyone including women to work past 10pm.'),
           new Explanations__c(Name='Realities',Code__c='Self 2',Realities__c='No',Particulars__c='Student family does not allow women to work past 10pm'),
           new Explanations__c(Name='Realities',Code__c='Self 3',Realities__c='Yes',Particulars__c='Student family income is above INR 20,000 per month'),
           new Explanations__c(Name='Realities',Code__c='Self 3',Realities__c='No',Particulars__c='Student family income is below INR 20,000 per month'),
           new Explanations__c(Name='Realities',Code__c='Self 4',Realities__c='A',Particulars__c='Student family will  provide monetary support for education'),
           new Explanations__c(Name='Realities',Code__c='Self 4',Realities__c='B',Particulars__c='Student family will not provide monetary support for education'),
           new Explanations__c(Name='Realities',Code__c='Self 4',Realities__c='C',Particulars__c='Student family will not provide monetary support for education'),
           new Explanations__c(Name='Realities',Code__c='Family 1',Realities__c='Yes',Particulars__c='Student will not get married till atleast 22 years of age'),
           new Explanations__c(Name='Realities',Code__c='Family 1',Realities__c='No',Particulars__c='Student will get married before 22 years of age'),
           new Explanations__c(Name='Realities',Code__c='Family 2',Realities__c='Yes',Particulars__c='Student will be the fIrst to work in the organized sector in their family'),
           new Explanations__c(Name='Realities',Code__c='Family 2',Realities__c='No',Particulars__c='Student will not get married till atleast 22 years of ageStudent will not be the fIrst to work in the organized sector in their family'),
           new Explanations__c(Name='Realities',Code__c='Family 3',Realities__c='Yes',Particulars__c='Students is already working for 1+ years'),
           new Explanations__c(Name='Realities',Code__c='Family 3',Realities__c='No',Particulars__c='Students is not working for 1+ years'),
           new Explanations__c(Name='Realities',Code__c='Family 4',Realities__c='A',Particulars__c='Student is calm and does not get angry'),
           new Explanations__c(Name='Realities',Code__c='Family 4',Realities__c='B',Particulars__c='Student is not calm and gets angry'),
           new Explanations__c(Name='Realities',Code__c='Family 4',Realities__c='C',Particulars__c='Student is not calm and gets angry')};
        insert explanations;
       
        IARP_Master__c iarp=new IARP_Master__c();
        iarp.Name = 'Teacher';
        iarp.Sector__c = 'Education';
        iarp.Additional_Info__c = 'Education';
        iarp.After_10th__c = 'After 10th';
        iarp.After_12th__c = 'After 12th';
        iarp.Famous_Person__c = 'Famous Person';
        iarp.Avg_Salary__c = 'Avg Person';
        iarp.Fun_Fact__c = 'Fun Fact';
        insert iarp;
        
        IARP_Master__c iarp1=new IARP_Master__c();
        iarp1.Name='Fitness Instructor';
        iarp1.Sector__c='Sports and Fitness';
        iarp1.Additional_Info__c = 'Education';
        iarp1.After_10th__c = 'After 10th';
        iarp1.After_12th__c = 'After 12th';
        iarp1.Famous_Person__c = 'Famous Person';
        iarp1.Avg_Salary__c = 'Avg Person';
        iarp1.Fun_Fact__c = 'Fun Fact';
        insert iarp1;
        
        Contact contact1=new Contact();
        contact1.FirstName='Kurund123';
        contact1.LastName='Jalmi12';
        Id RecordTypeIdStudent = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        contact1.RecordTypeId=RecordTypeIdStudent;
        contact1.Batch_Code__c=batch.id;
        contact1.Current_Aspiration__c='SELF EMPLOYED';
        contact1.Age__c=25;
        contact1.Aspiration_1__c = iarp.Id;
        contact1.Aspiration_2__c = iarp1.Id;
        contact1.Aspiration_3__c = iarp1.Id;
        contact1.Interest_1__c='Social';
        contact1.Interest_2__c='Enterprising';
        contact1.Aptitude_1__c='Verbal';
        contact1.Aptitude_2__c='Mechanical';
        contact1.Personality_1__c='Extrovert';
        contact1.Personality_2__c='Sensing';
        contact1.Personality_3__c='Thinking';
        contact1.Personality_4__c='Judging';
        contact1.Reality_1__c='Yes';
        contact1.Reality_2__c='Yes';
        contact1.Reality_3__c='Yes';
        contact1.Reality_4__c='A';
        contact1.Reality_5__c='Yes';
        contact1.Reality_6__c='Yes';
        contact1.Reality_7__c='Yes';
        contact1.Reality_8__c='A';
        contact1.Profession_1__c = iarp.id;
        contact1.Profession_1_Next_steps__c='To be a school teacher - Students must complete 12th grade in any stream';
        contact1.Profession_1_Recommendation__c='Teacher';
        contact1.Profession_2__c=iarp1.id;
        contact1.Profession_2_Next_steps__c='';
        contact1.Profession_2_Recommendation__c='Fitness Instructor';
        contact1.Recommedation_Status__c = 'Processed';
        contact1.G12_Batch_Code__c=batch.id;
        insert contact1;
        
       
        
        ApexPages.StandardController sc = new ApexPages.StandardController(contact1);
        StudentReportController studentreport = new StudentReportController(sc);
        
        StudentReportBatchController studentbatchreport = new StudentReportBatchController(new ApexPages.StandardController(batch));
        
        StudentReportComponentController componetreport = new StudentReportComponentController();
        componetreport.wrapStudentReport = studentbatchreport.lstStudentReports[0];
        componetreport.setStudentReportWrap(studentbatchreport.lstStudentReports[0]);
        
        contact1.Reality_1__c='No';
        contact1.Reality_2__c='No';
        contact1.Reality_3__c='No';
        contact1.Reality_4__c='A';
        contact1.Reality_5__c='No';
        contact1.Reality_6__c='No';
        contact1.Reality_7__c='No';
        contact1.Reality_8__c='A';
        update contact1;
        
        studentbatchreport = new StudentReportBatchController(new ApexPages.StandardController(batch));
         
    }
    
     public static testMethod void test2(){
         Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Mumbai';
        sm.Name = 'Mumbai Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'description';
        insert sm;
         
        Batch__c batch=new Batch__c();
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='GOA';
        insert state;
         
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Mumbai';
        insert distict;
        
        City_Master__c city =new City_Master__c();
        city.District__c=distict.id;
        city.Name='Kalyan'; 
        insert city;
        
        Ward_Master__c ward=new Ward_Master__c();
        ward.City__c=city.id;
        ward.Name='West Kalyan';
        insert ward;
        
        Account account=new Account();
        account.Name='Shreeram School';
        account.State__c=state.id;
        account.Ward__c=ward.id;
        account.City__c=city.id;
        account.District__c=distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
        
        
        batch.School_Name__c=account.id;
        batch.Preferred_Language__c='Marathi';
        
        Account account1=new Account();
        account1.Name='Shreeram School Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId=RecordTypeIdAccount1;
        account1.Number_of_batches_pending__c=1.0;
        account1.Number_of_batches_allocated__c=2.0;
        account1.Number_of_batches_funded__c=1.0;
        insert account1;
        
        Contact contact=new Contact();
        contact.FirstName='Test';
        contact.LastName='LName';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Trainer').getRecordTypeId();
        contact.RecordTypeId=RecordTypeIdContact;
        insert contact;
         
        batch.Trainer_Name__c=contact.id;
        
        batch.Donor_Name__c=account1.id;
        batch.Name='Batch 7';
        batch.Grade__c='Grade 12';
        batch.Number_of_students_facilitated__c=1.0;
        batch.Preferred_Language__c = 'Marathi';
        insert batch;
        
        List<Explanations__c> explanations =new List<Explanations__c>{ 
           new Explanations__c(Name='Interest',Code__c='Enterprising - E',Particulars__c='Enterprising people like to lead, influence people and are able to negotiate and persuade well.'),
           new Explanations__c(Name='Interest',Code__c='Social - S',Particulars__c='Social people like to be with people and provide information or services to help, train or cure people.'),
           new Explanations__c(Name='Aptitude',Code__c='Verbal Ability',Particulars__c='Verbal ability is the ability to reason with words, to understand and use concepts expressed in words.'),
           new Explanations__c(Name='Aptitude',Code__c='Mechanical Ability',Particulars__c='Mechanical ability is the ability to understand and apply concepts related to tools.'),
           new Explanations__c(Name='Personality',Code__c='Extrovert,Sensing,Thinking,Judging',Particulars__c='Extroverts'),
           new Explanations__c(Name='Realities',Code__c='Self 1',Realities__c='Yes',Particulars__c='Student has family member(s) that have studied upto 12th Grade'),
           new Explanations__c(Name='Realities',Code__c='Self 1',Realities__c='No',Particulars__c='Student does not have family member(s) that have studied upto 12th Grade'),
           new Explanations__c(Name='Realities',Code__c='Self 2',Realities__c='Yes',Particulars__c='Student family allows everyone including women to work past 10pm.'),
           new Explanations__c(Name='Realities',Code__c='Self 2',Realities__c='No',Particulars__c='Student family does not allow women to work past 10pm'),
           new Explanations__c(Name='Realities',Code__c='Self 3',Realities__c='Yes',Particulars__c='Student family income is above INR 20,000 per month'),
           new Explanations__c(Name='Realities',Code__c='Self 3',Realities__c='No',Particulars__c='Student family income is below INR 20,000 per month'),
           new Explanations__c(Name='Realities',Code__c='Self 4',Realities__c='A',Particulars__c='Student family will  provide monetary support for education'),
           new Explanations__c(Name='Realities',Code__c='Self 4',Realities__c='B',Particulars__c='Student family will not provide monetary support for education'),
           new Explanations__c(Name='Realities',Code__c='Self 4',Realities__c='C',Particulars__c='Student family will not provide monetary support for education'),
           new Explanations__c(Name='Realities',Code__c='Family 1',Realities__c='Yes',Particulars__c='Student will not get married till atleast 22 years of age'),
           new Explanations__c(Name='Realities',Code__c='Family 1',Realities__c='No',Particulars__c='Student will get married before 22 years of age'),
           new Explanations__c(Name='Realities',Code__c='Family 2',Realities__c='Yes',Particulars__c='Student will be the fIrst to work in the organized sector in their family'),
           new Explanations__c(Name='Realities',Code__c='Family 2',Realities__c='No',Particulars__c='Student will not get married till atleast 22 years of ageStudent will not be the fIrst to work in the organized sector in their family'),
           new Explanations__c(Name='Realities',Code__c='Family 3',Realities__c='Yes',Particulars__c='Students is already working for 1+ years'),
           new Explanations__c(Name='Realities',Code__c='Family 3',Realities__c='No',Particulars__c='Students is not working for 1+ years'),
           new Explanations__c(Name='Realities',Code__c='Family 4',Realities__c='A',Particulars__c='Student is calm and does not get angry'),
           new Explanations__c(Name='Realities',Code__c='Family 4',Realities__c='B',Particulars__c='Student is not calm and gets angry'),
           new Explanations__c(Name='Realities',Code__c='Family 4',Realities__c='C',Particulars__c='Student is not calm and gets angry')};
        insert explanations;
       
        IARP_Master__c iarp=new IARP_Master__c();
        iarp.Name = 'Teacher';
        iarp.Sector__c = 'Education';
        iarp.Additional_Info__c = 'Education';
        iarp.After_10th__c = 'After 10th';
        iarp.After_12th__c = 'After 12th';
        iarp.Famous_Person__c = 'Famous Person';
        iarp.Avg_Salary__c = 'Avg Person';
        iarp.Fun_Fact__c = 'Fun Fact';
        insert iarp;
        
        IARP_Master__c iarp1=new IARP_Master__c();
        iarp1.Name='Fitness Instructor';
        iarp1.Sector__c='Sports and Fitness';
        iarp1.Additional_Info__c = 'Education';
        iarp1.After_10th__c = 'After 10th';
        iarp1.After_12th__c = 'After 12th';
        iarp1.Famous_Person__c = 'Famous Person';
        iarp1.Avg_Salary__c = 'Avg Person';
        iarp1.Fun_Fact__c = 'Fun Fact';
        insert iarp1;
        
        Contact contact1=new Contact();
        contact1.FirstName='Kurund123';
        contact1.LastName='Jalmi12';
        Id RecordTypeIdStudent = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        contact1.RecordTypeId=RecordTypeIdStudent;
        contact1.Batch_Code__c=batch.id;
        contact1.Current_Aspiration__c='SELF EMPLOYED';
        contact1.Age__c=25;
        contact1.Aspiration_1__c = iarp.Id;
        contact1.Aspiration_2__c = iarp1.Id;
        contact1.Aspiration_3__c = iarp1.Id;
        contact1.Interest_1__c='Social';
        contact1.Interest_2__c='Enterprising';
        contact1.Aptitude_1__c='Verbal';
        contact1.Aptitude_2__c='Mechanical';
        contact1.Personality_1__c='Extrovert';
        contact1.Personality_2__c='Sensing';
        contact1.Personality_3__c='Thinking';
        contact1.Personality_4__c='Judging';
        contact1.Reality_1__c='Yes';
        contact1.Reality_2__c='Yes';
        contact1.Reality_3__c='Yes';
        contact1.Reality_4__c='A';
        contact1.Reality_5__c='Yes';
        contact1.Reality_6__c='Yes';
        contact1.Reality_7__c='Yes';
        contact1.Reality_8__c='A';
        contact1.Profession_1__c = iarp.id;
        contact1.Profession_1_Next_steps__c='To be a school teacher - Students must complete 12th grade in any stream';
        contact1.Profession_1_Recommendation__c='Teacher';
        contact1.Profession_2__c=iarp1.id;
        contact1.Profession_2_Next_steps__c='';
        contact1.Profession_2_Recommendation__c='Fitness Instructor';
        contact1.Recommedation_Status__c = 'Processed';
        contact1.G11_Batch_Code__c=batch.id;
        insert contact1;
        
       
        
        ApexPages.StandardController sc = new ApexPages.StandardController(contact1);
        StudentReportController studentreport = new StudentReportController(sc);
        
        StudentReportBatchController studentbatchreport = new StudentReportBatchController(new ApexPages.StandardController(batch));
        
        StudentReportComponentController componetreport = new StudentReportComponentController();
        componetreport.wrapStudentReport = studentbatchreport.lstStudentReports[0];
        componetreport.setStudentReportWrap(studentbatchreport.lstStudentReports[0]);
        
        contact1.Reality_1__c='No';
        contact1.Reality_2__c='No';
        contact1.Reality_3__c='No';
        contact1.Reality_4__c='A';
        contact1.Reality_5__c='No';
        contact1.Reality_6__c='No';
        contact1.Reality_7__c='No';
        contact1.Reality_8__c='A';
        update contact1;
        
        studentbatchreport = new StudentReportBatchController(new ApexPages.StandardController(batch));
         
    }
    
}