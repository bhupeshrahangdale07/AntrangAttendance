@isTest
public class GenerateInvoiceFormController_Test {
    
    private static DateTime invoiceDateTime = Date.Today()-1;
    private static Date invoiceDate = Date.today()-1;
    private static string JSONdata;
    
    @testSetup
    public static void testData() {
        
        //AntarangSetting__c setting = new AntarangSetting__c(Name = 'Default Setting', Academic_Year__c = 2023,Finance_Login_Username__c = 'test@test.com');
        //insert setting;
        
        //CustomLabel customLabel = new CustomLabel();
        //customLabel.Finance_Login_Password = 'test@test.com';
        //customLabel.Finance_Login_Username = 'test@123';
        
        State_Govt_Body_Level__c state = new State_Govt_Body_Level__c(Name = 'Test State');
        insert state;
        
        District_Master__c district = new District_Master__c(Name = 'TDistrict', State__c = state.id, 
                                                             Payout_Supervisor_Username__c = 'payout.supervisor@test.com',
                                                             Payout_Supervisor_Password__c = 'Password1',
                                                             Payout_Admin_Password__c = 'Password2',
                                                             Payout_Admin_Username__c = 'payout.admin@test.com');
        insert district;
        
        Id conRtId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Trainer').getRecordTypeId();
        
        Contact con1 = new Contact(LastName = 'Contact 1', Payment_Type__c = 'Salary', RecordTypeId = conRtId, Trainer_Status__c = 'Morning',
                                   Fixed_Amount__c = 8000, Academic_Year__c = 2023, npe01__WorkEmail__c = 'test@test.com', 
                                   Payment_Start_Date__c = invoiceDate-180,PAN_Number__c = '23445555',MailingStreet='test',MailingCity='test',
                                   MailingPostalCode = 'test',MailingState='test',MailingCountry='test',Bank_Account_No__c='12345',
                                   IFSC_Code__c='12345',Branch_Name__c='12345',Bank_City__c='test',TDS_Applicable__c='Yes',Bank_Name__c='test');
        insert con1;
            
            // Create test salary records
        Salary__c sal = new Salary__c(
            Contact__c = con1.Id,
            Salary_Month__c = '6',
            District_Master__c = district.Id,
            Fixed_Amount__c = 8000,
            Amount_to_be_paid__c = 7500,
            Status__c = 'Invoice generated',
            Amount_Paid__c = 7000,
            Invoice_Date__c = invoiceDate+60,
            Reason__c = 'On Leave'
        );
       insert sal;
        
        Id accRtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        
        Account school = new Account(Name = 'Test School Account 1', School_Name__c = 'School 1', 
                                     District__c = district.Id, State__c = state.Id, RecordTypeId = accRtId);
        insert school;
        
        Batch__c b1 = new Batch__c(Name = 'Batch 1', School_Name__c = school.Id, Preferred_Language__c = 'English', Trainer_Name__c = con1.Id);
        insert b1;
        
        session__c session = new session__c();
        session.Batch__c = b1.Id;
        session.Name='test 1';
        session.Session_Grade__c = 'Grade 9';
        session.Session_Type__c = 'student';
        session.Assigned_facilitator__c = con1.Id;
        session.SessionDate__c = invoiceDate;
        session.Payment_Status__c = 'Ready For Payment';
        insert session;
        
        GenerateInvoiceFormController.facilitatorWrapper wrapper = new GenerateInvoiceFormController.facilitatorWrapper();
        wrapper.FacilitatorId = '0031m00000PMLnbAAH';
        wrapper.FacilitatorEmail = 'srikanth.d@kandisatech.com';
        wrapper.FacilitatorName = 'Srikanth Test';
        wrapper.FacilitatorOwner = '0057F000000iWraQAE';
        wrapper.FacilitatorFixedAmount = 10000;
        wrapper.Checkbox = true;
        wrapper.FacilitatorAmtToBePaid = 4000;
        wrapper.Reason = 'Only Attedance not submitted';
        wrapper.ReasonStatus = true;
        wrapper.AcademicYear = 2021;
        wrapper.AmountPaid = 6000;
        wrapper.MonthYear = 'March 2023';
        wrapper.SalaryMonth = '3';
        wrapper.SalaryStatus = 'Invoice Generated';
        wrapper.SalaryId = 'a1s1m000000ivwCAAQ';
        wrapper.AmountPaidToThisMonth = 2000;
        wrapper.PreviousAmountPaid = 4000;
        wrapper.invoiceMonth = '5';
        //copyOfAmtToBePaid
        
        JSONdata = JSON.serialize(wrapper);
    }
    
    @isTest
    public static void getDistrictTest(){
        
        try{ 
            Test.startTest();
            GenerateInvoiceFormController.getDistrict();
            Test.stopTest();           
        }catch(Exception ex){
            system.debug('getDistrictTest : ' + ex.getMessage());
            system.debug('getDistrictTest : ' + ex.getLineNumber());
        }
    }
    
    @isTest
    public static void generateInvoiceTest(){
        District_Master__c dst = [select id, Payout_Admin_Password__c, Payout_Admin_Username__c, Payout_Supervisor_Password__c, 
                                       Payout_Supervisor_Username__c, name from District_Master__c limit 1];
        contact con = [select id from contact limit 1];
        salary__c sal = [select id from salary__c limit 1];
        String jsonData = '[{"SalaryStatus":"Proposal Rejected","SalaryId":"'+sal.id+'","PreviousAmountPaid":1000,"SalaryMonth":"5","AcademicYear":"2023","FacilitatorFixedAmount":2000,"FacilitatorId":"'+con.id+'","Checkbox":true,"FacilitatorAmtToBePaid":1500,"AmountPaid":500,"Reason":"On Leave","FacilitatorName":"John Doe","MonthYear":"May 2023"}]';
        String jsonData1= '[{"SalaryStatus":"Proposal Rejected","SalaryId":"'+sal.id+'","PreviousAmountPaid":1000,"SalaryMonth":"5","AcademicYear":"2023","FacilitatorFixedAmount":2000,"FacilitatorId":"'+con.id+'","Checkbox":false,"FacilitatorAmtToBePaid":0,"AmountPaid":500,"Reason":"","FacilitatorName":"John Doe","MonthYear":"May 2023"}]';
        String salaryMonth = '5';
        Date invoiceDate = Date.today();
        String district = dst.id;
        Test.startTest();
        String result = GenerateInvoiceFormController.generateInvoice(jsonData, salaryMonth, invoiceDate, district);
        String result1= GenerateInvoiceFormController.generateInvoice(jsonData1, salaryMonth, invoiceDate, district);
		Test.stopTest();     
    }
    
    @isTest
    public static void approveRejectPayoutTest(){
        
        try{
            District_Master__c dst = [select id, Payout_Admin_Password__c, Payout_Admin_Username__c, Payout_Supervisor_Password__c, 
                                       Payout_Supervisor_Username__c, name from District_Master__c limit 1];
        contact con = [select id from contact limit 1];
        salary__c sal = [select id from salary__c limit 1];
           String jsonData = '[{"SalaryStatus":"Proposal Rejected","SalaryId":"'+sal.id+'","PreviousAmountPaid":1000,"SalaryMonth":"5","AcademicYear":"2023","FacilitatorFixedAmount":2000,"FacilitatorId":"'+con.id+'","Checkbox":true,"FacilitatorAmtToBePaid":1500,"AmountPaid":500,"Reason":"Appreciation/performance bonus","FacilitatorName":"John Doe","MonthYear":"May 2023","AmountPaidToThisMonth":6000}]';
            Test.startTest();
            GenerateInvoiceFormController.approveRejectPayout(jsonData, '5', dst.id, '' , invoiceDateTime);
            GenerateInvoiceFormController.approveRejectPayout(jsonData, '5', dst.id, 'Invoice Generated' , invoiceDateTime);
            Test.stopTest();           
        }catch(Exception ex){
            system.debug('approveRejectPayoutTest : ' + ex.getMessage());
            system.debug('approveRejectPayoutTest : ' + ex.getLineNumber());
        }
    }
    
    @isTest
    public static void generateFinanceFileNSendTest(){
        
        try{ 
            District_Master__c dst = [select id, Payout_Admin_Password__c, Payout_Admin_Username__c, Payout_Supervisor_Password__c, 
                                       Payout_Supervisor_Username__c, name from District_Master__c limit 1];

            Test.startTest();
            GenerateInvoiceFormController.generateFinanceFileNSend(invoiceDate+60, dst.id);
            GenerateInvoiceFormController.getPicklistValues();
            Test.stopTest();           
        }catch(Exception ex){
            system.debug('generateFinanceFileNSendTest: ' + ex.getMessage());
            system.debug('generateFinanceFileNSendTest: ' + ex.getLineNumber());
        }
    }
    
    @isTest
    public static void showFaciliatorOnEditTest(){
        
        try{ 
            District_Master__c dst = [select id, Payout_Admin_Password__c, Payout_Admin_Username__c, Payout_Supervisor_Password__c, 
                                       Payout_Supervisor_Username__c, name from District_Master__c limit 1];

            Test.startTest();
            List<GenerateInvoiceFormController.facilitatorWrapper> fw = GenerateInvoiceFormController.showFaciliatorOnEdit(dst.id, invoiceDate);
            Test.stopTest();           
        }catch(Exception ex){
            system.debug('showFaciliatorOnEditTest: ' + ex.getMessage());
            system.debug('showFaciliatorOnEditTest: ' + ex.getLineNumber());
        }
    }
}