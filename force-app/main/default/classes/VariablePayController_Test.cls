@isTest
public class VariablePayController_Test {
    
    @testSetup
    public static void testData(){
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='GOA';
        insert state;
        
        District_Master__c district=new District_Master__c();
        district.State__c=state.id;
        district.Name='Mumbai';
        district.Payout_Supervisor_Username__c='test@gmail.com';
        district.Payout_Admin_Username__c='test@gmail.com';
        insert district;
        
        City_Master__c city =new City_Master__c();
        city.District__c=district.id;
        city.Name='Kalyan'; 
        insert city;
        
        Ward_Master__c ward=new Ward_Master__c();
        ward.City__c=city.id;
        ward.Name='West Kalyan';
        insert ward;
        
        Account account=new Account();
        account.Name='Vidya School';
        account.State__c=state.id;
        account.Ward__c=ward.id;
        account.City__c=city.id;
        account.District__c=district.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        account.School_Timing__c='Morning';
        account.Medium_Language_of_Instruction__c='English';
        account.Academic_Year__c=AntarangSetting__c.getOrgDefaults().Academic_Year__c;
        account.School_Location__c = 'Test address';
        account.Principal_Name__c = 'Test Principal';
        account.Est_Number_of_Students_in_Grade_9_19_20__c = 20;
        account.Estimated_Number_Of_Students__c = 'test';
        account.Principal_Contact_2__c = '12345678';
        account.Principal_Contact_3__c = '12345678';
        insert account;
        
        Account account1=new Account();
        account1.Name='Vidya School Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId=RecordTypeIdAccount1;
        account1.Number_of_batches_pending__c=1.0;
        account1.Number_of_batches_allocated__c=2.0;
        account1.Number_of_batches_funded__c=1.0;
        account1.Medium_Language_of_Instruction__c = 'Hindi';
        insert account1;
        
        Contact contact=new Contact();
        contact.FirstName='TestCon';
        contact.LastName='LName';
        contact.Email = 'test@gmail.com';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Trainer').getRecordTypeId();
        contact.RecordTypeId=RecordTypeIdContact;
        contact.npe01__WorkEmail__c = 'test@gmail.com';
        contact.Academic_Year__c=AntarangSetting__c.getOrgDefaults().Academic_Year__c;
        
        insert contact; 
        
        Batch__c childBatch= new Batch__c();
        childBatch.School_Name__c=account.id;
        childBatch.Preferred_Language__c='Hindi';
        childBatch.Trainer_Name__c=contact.id;        
        childBatch.Donor_Name__c=account1.id;
        childBatch.Name='Batch 8';
        childBatch.Grade__c='Grade 9';
        childBatch.Number_of_students_facilitated__c=1.0;
        childBatch.Medium_Language_of_Instruction__c = 'Hindi';
        childBatch.Date_of_facilitation_starting__c = datetime.now() - 3;
        childBatch.Date_of_facilitation_completion__c = datetime.now();
        childBatch.Followup_1_Trainer_Name__c = contact.id;
        childBatch.Date_of_1st_Follow_up_session__c = system.today() + 2;
        insert childBatch;
        
        String b = [Select Id,Batch_Number__c From Batch__c Where Id =: childBatch.Id].Batch_Number__c;
        
        Batch__c batch=new Batch__c();
        batch.Name='Test Batch';
        batch.School_Name__c=account.Id;
        batch.Preferred_Language__c='English';
        batch.Trainer_Name__c=contact.Id;
        batch.Donor_Name__c=account1.Id;
        batch.Grade__c='Grade 9';
        batch.Number_of_students_facilitated__c=1.0;
        batch.Medium_Language_of_Instruction__c = 'Hindi';
        batch.Date_of_facilitation_starting__c = datetime.now() - 3;
        batch.Date_of_facilitation_completion__c = datetime.now();
        batch.Followup_1_Trainer_Name__c = contact.id;
        batch.Date_of_1st_Follow_up_session__c = system.today() + 2;
        batch.Combined_Batch_no_for_G10__c = b;
        batch.Academic_Year__c = AntarangSetting__c.getOrgDefaults().Academic_Year__c;
        insert batch;
        
        session__c session = new session__c();
        session.Name = 'test';
        session.Batch__c = batch.Id;
        session.Assigned_facilitator__c = contact.Id;
        //session.SessionDate__c = date.today();
        session.Session_Grade__c = 'Grade 9';
        session.Payment_Status__c = 'Ready For Payment';
        session.Status__c='Invoice Generated';
        session.Proposal_Date__c=system.today();
        //session.Attendance_Count__c=5;
        session.Total_Student_Present__c=10;
        session.Total_Parent_Present__c=10;
        session.Total_Amount__c=2000;
        session.Copy_of_Session__c='Test';
        session.SessionDate__c=system.today()+10;
        session.Dummy_Session_Created__c=true;
        session.Dummy_Session__c=true;
        session.Active_Checkbox__c=true;
        
        
        insert session;
        
        session__c session2 = new session__c();
        session2.Name = 'test2';
        session2.Batch__c = batch.Id;
        session2.Assigned_facilitator__c = contact.Id;
        //session.SessionDate__c = date.today();
        session2.Session_Grade__c = 'Grade 9';
        session2.Payment_Status__c = 'Ready For Payment';
        session2.Status__c='Invoice Generated';
        session2.Proposal_Date__c=system.today();
        //session.Attendance_Count__c=5;
        session2.Total_Student_Present__c=10;
        session2.Total_Parent_Present__c=10;
        session2.Total_Amount__c=3000;
        session2.Copy_of_Session__c='Test';
        session2.SessionDate__c=system.today()+10;
        session2.Dummy_Session_Created__c=true;
        session2.Dummy_Session__c=true;
        session2.Active_Checkbox__c=true;
        
        insert session2;
        
        
        
        Session_Attendance__c sessionAtnds= new Session_Attendance__c();
        sessionAtnds.Session__c=session.Id;
        sessionAtnds.Contact__c=contact.Id;
        insert sessionAtnds;
        
        AntarangSetting__c setting = new AntarangSetting__c();
        setting.Academic_Year__c=2023;
        setting.Max_Batch_Size__c=20;
        insert setting;
        
        Salary__c sal = new Salary__c(
            Contact__c = contact.Id,
            Salary_Month__c = '6',
            District_Master__c = district.Id,
            Fixed_Amount__c = 8000,
            Amount_to_be_paid__c = 7500,
            Status__c = 'Invoice generated',
            Amount_Paid__c = 7000,
            Invoice_Date__c = system.today(),
            Reason__c = 'On Leave'
        );
        insert sal;
        
        /* Map<String, Object> result = new Map<String, Object>();
List<PayoutProcessController.sessionWrapper> wrapList = new List<PayoutProcessController.sessionWrapper>();
wrapList = (List<PayoutProcessController.sessionWrapper>)result.get('sessionData');*/
        
        
        
    }
    
    @isTest
    public static void variableTest1(){
        
        try{
            
            
            salary__c sal = [select id from salary__c limit 1];
            
            Account acc = [select id from Account where Name ='Vidya School' limit 1];
            Account acc1 = [select id,Name from Account where Name ='Vidya School Donor' limit 1];
            system.debug('Donor List'+acc1);
            Batch__c btc =[select id,Batch_Number__c,Donor_Name__c,School_Name__c from Batch__c limit 1];
            
            Contact con =[select id,Name,npe01__WorkEmail__c from Contact limit 1];
            
            session__c session1 = new session__c();
            session1.Name = 'test1';
            session1.Assigned_Facilitator__c=con.Id;
            session1.Batch__c = btc.Id;
            //session1.Assigned_facilitator__c = contact.Id;
            session1.SessionDate__c = date.today();
            session1.Session_Grade__c = 'Grade 9';
            session1.Payment_Status__c = 'Ready For Payment';
            session1.Status__c='Invoice Generated';
            session1.Proposal_Date__c=system.today();
            insert session1;
            
            
            List<VariablePayController.sessionWrapper> wList = new List<VariablePayController.sessionWrapper>();
            
            for(integer i=1;i<=50;i++){
                VariablePayController.sessionWrapper w = new VariablePayController.sessionWrapper();
                w.SessionId = session1.Id;
                w.Name = 'Test '+i;
                w.SessionDate = system.today()+30;
                w.ProposalDate = system.today();
                w.SessionGrade = 'Test '+i;
                w.AttendanceCount=50.0;
                w.PresentCount=40.0;
                w.SessionCode = 'Test '+i;					     
                w.DummySessionAvailable = true; 		
                w.DummySession = true;				
                w.ParentSessionCode ='Test '+i;		
                w.TotalStudentsPresent =10.0;		
                
                w.NumberofSessionsNoofUnits =2.0;
                w.SessionAmount=400.0;     		
                w.Rate=200.0;      		
                w.Status= 'Invoice Generated';       		
                
                w.BatchId =btc.id;						
                w.BatchName = 'Test'+i ;  				
                w.BatchNumber = btc.Batch_Number__c;					
                w.FacilitatorName = con.Name;				
                w.FacilitatorId=con.Id; 				
                w.PaymentStatus='Ready For Payment' ;					
                w.DeferredReason= 'Not to be Paid';				
                w.errorMessage='Test Error'+i; 				
                w.showError =true;					
                w.Checkbox=true;	
                wList.add(w);
            }
            
            
            
            String jsonData = '[{"SalaryStatus":"Proposal Rejected","SessionId":"'+session1.id+'","SalaryId":"'+sal.id+'","PreviousAmountPaid":1000,"SalaryMonth":"5","AcademicYear":"2023","FacilitatorFixedAmount":2000,"FacilitatorId":"'+con.id+'","DonorId":"'+acc1.id+'","Checkbox":true,"FacilitatorAmtToBePaid":1500,"AmountPaid":500,"Reason":"On Leave","FacilitatorName":"John Doe","MonthYear":"May 2023"}]';
            String jsonData1= '[{"SalaryStatus":"Proposal Rejected","SessionId":"'+session1.id+'","SalaryId":"'+sal.id+'","PreviousAmountPaid":1000,"SalaryMonth":"5","AcademicYear":"2023","FacilitatorFixedAmount":2000,"FacilitatorId":"'+con.id+'","DonorId":"'+acc1.id+'","Checkbox":true,"FacilitatorAmtToBePaid":0,"AmountPaid":500,"Reason":"Not to be Paid","FacilitatorName":"John Doe","MonthYear":"May 2023"}]';
            
            Test.startTest();
            String accId = acc.Id;
            String donorId = acc1.Id;
            String batchId = btc.Id;
            String facilitator = con.Id;
            
            VariablePayController.getSessions(system.today(), facilitator, donorId, accId, batchId, 'Grade 9');
            VariablePayController.getSessions(system.today()-30, facilitator, donorId, accId, batchId, 'Grade 9');
            /*Map<String, Object> result = new Map<String, Object>();
result = (Map<String, Object>)a;
system.debug('test : '+result);
system.debug('test 1 : '+result.get('sessionData') );
List<VariablePayController.sessionWrapper> wrapList = new List<VariablePayController.sessionWrapper>();
wrapList = (List<VariablePayController.sessionWrapper>)result.get('sessionData');
VariablePayController.saveSessions(wrapList, 'save' ,system.today(), con.npe01__WorkEmail__c);*/
            
            VariablePayController.financeVariablePayoutFile(system.today(), con.npe01__WorkEmail__c);
            VariablePayController.financeVariablePayoutFile(system.today()+30, con.npe01__WorkEmail__c);
            
            VariablePayController.getPicklistValues();
            VariablePayController.getSessionDataForSupervisor(system.today());
            VariablePayController.approveRejectPayout(jsonData, 'rejected', system.today(), 'test@gmail.com');
            List<VariablePayController.sessionWrapper> wrapList = new List<VariablePayController.sessionWrapper>();
            VariablePayController.saveSessions(wrapList, 'save' ,system.today(), con.npe01__WorkEmail__c);
            
            Test.stopTest();
        }catch(Exception ex){
            system.debug('approveRejectPayoutTest : ' + ex.getMessage());
            system.debug('approveRejectPayoutTest : ' + ex.getLineNumber());
        }
        
    }
    
    @isTest
    public static void variableTest2(){
        
        Contact con =[select id,npe01__WorkEmail__c from Contact limit 1];
        salary__c sal = [select id from salary__c limit 1];
        Session__c sess=[select id from Session__c where Name='test' limit 1];
        Account acc1 = [select id,Name from Account where Name ='Vidya School Donor' limit 1];
        String jsonData1= '[{"SalaryStatus":"Proposal Approved","SalaryId":"'+sal.id+'","PreviousAmountPaid":1000,"SalaryMonth":"5","AcademicYear":"2023","FacilitatorFixedAmount":2000,"FacilitatorId":"'+con.id+'","SessionId":"'+sess.id+'","DonorId":"'+acc1.id+'","Checkbox":true,"FacilitatorAmtToBePaid":0,"AmountPaid":500,"Reason":"On Leave","FacilitatorName":"John Doe","MonthYear":"May 2023"}]';
        Test.startTest();
        VariablePayController.approveRejectPayout(jsonData1, 'approved', system.today(), 'test@gmail.com');
        
        Test.stopTest();
    }
}