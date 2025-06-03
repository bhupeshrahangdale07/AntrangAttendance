@isTest
public class upsertOMRContactBatchTest {
    @testSetup
    public static void testData(){
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        antarangSett.Academic_Year__c = 2023;
        Insert antarangSett;
        
        OMR_Field_Mapping__c omrfield1 = new OMR_Field_Mapping__c();
        omrfield1.Name = 'Female';
        omrfield1.Field_Type__c = 'Gender';
        omrfield1.Selected_Number__c = '2';
        omrfield1.SF_Value__c = 'Female';
        Insert omrfield1;
        
        OMR_Field_Mapping__c omrfield2 = new OMR_Field_Mapping__c();
        omrfield2.Name = 'Male';
        omrfield2.Field_Type__c = 'Gender';
        omrfield2.Selected_Number__c = '1';
        omrfield2.SF_Value__c = 'Male';
        Insert omrfield2;
        
        OMR_Field_Mapping__c omrfield3 = new OMR_Field_Mapping__c();
        omrfield3.Name = 'Transgender';
        omrfield3.Field_Type__c = 'Gender';
        omrfield3.Selected_Number__c = '3';
        omrfield3.SF_Value__c = 'Transgender';
        Insert omrfield3;
        
        OMR_Field_Mapping__c omrfield4 = new OMR_Field_Mapping__c();
        omrfield4.Name = 'Others';
        omrfield4.Field_Type__c = 'Gender';
        omrfield4.Selected_Number__c = '4';
        omrfield4.SF_Value__c = 'Others';
        Insert omrfield4;
        
        OMR_Field_Mapping__c omrfield5 = new OMR_Field_Mapping__c();
        omrfield5.Name = '10TH';
        omrfield5.Field_Type__c = 'Currently Studying In';
        omrfield5.Selected_Number__c = '3';
        omrfield5.SF_Value__c = 'Grade 10';
        Insert omrfield5;
        
        OMR_Field_Mapping__c omrfield6 = new OMR_Field_Mapping__c();
        omrfield6.Name = '11TH';
        omrfield6.Field_Type__c = 'Currently Studying In';
        omrfield6.Selected_Number__c = '4';
        omrfield6.SF_Value__c = 'Grade 11';
        Insert omrfield6;
        
        OMR_Field_Mapping__c omrfield7 = new OMR_Field_Mapping__c();
        omrfield7.Name = '12TH';
        omrfield7.Field_Type__c = 'Currently Studying In';
        omrfield7.Selected_Number__c = '5';
        omrfield7.SF_Value__c = 'Grade 12';
        Insert omrfield7;
        
        OMR_Field_Mapping__c omrfield8 = new OMR_Field_Mapping__c();
        omrfield8.Name = '8TH';
        omrfield8.Field_Type__c = 'Currently Studying In';
        omrfield8.Selected_Number__c = '1';
        omrfield8.SF_Value__c = 'Grade 8';
        Insert omrfield8;
        
        OMR_Field_Mapping__c omrfield9 = new OMR_Field_Mapping__c();
        omrfield9.Name = '9TH';
        omrfield9.Field_Type__c = 'Currently Studying In';
        omrfield9.Selected_Number__c = '2';
        omrfield9.SF_Value__c = 'Grade 9';
        Insert omrfield9;
        
        OMR_Field_Mapping__c omrfield10 = new OMR_Field_Mapping__c();
        omrfield10.Name = 'Other';
        omrfield10.Field_Type__c = 'Currently Studying In';
        omrfield10.Selected_Number__c = '6';
        omrfield10.SF_Value__c = 'Other';
        Insert omrfield10;
        
        OMR_Field_Mapping__c omrfield11 = new OMR_Field_Mapping__c();
        omrfield11.Name = '10th Pass';
        omrfield11.Field_Type__c = 'Father Education';
        omrfield11.Selected_Number__c = 'C';
        omrfield11.SF_Value__c = '10th Pass';
        Insert omrfield11;
        
        OMR_Field_Mapping__c omrfield12 = new OMR_Field_Mapping__c();
        omrfield12.Name = '12th Pass';
        omrfield12.Field_Type__c = 'Father Education';
        omrfield12.Selected_Number__c = 'D';
        omrfield12.SF_Value__c = '12th Pass';
        Insert omrfield12;
        
        OMR_Field_Mapping__c omrfield13 = new OMR_Field_Mapping__c();
        omrfield13.Name = 'Below 10th';
        omrfield13.Field_Type__c = 'Father Education';
        omrfield13.Selected_Number__c = 'B';
        omrfield13.SF_Value__c = 'Below 10th';
        Insert omrfield13;
        
        OMR_Field_Mapping__c omrfield14 = new OMR_Field_Mapping__c();
        omrfield14.Name = 'College Pass';
        omrfield14.Field_Type__c = 'Father Education';
        omrfield14.Selected_Number__c = 'E';
        omrfield14.SF_Value__c = 'College Pass';
        Insert omrfield14;
        
        OMR_Field_Mapping__c omrfield15 = new OMR_Field_Mapping__c();
        omrfield15.Name = 'Did not attend school';
        omrfield15.Field_Type__c = 'Father Education';
        omrfield15.Selected_Number__c = 'A';
        omrfield15.SF_Value__c = 'Did not attend school';
        Insert omrfield15;
        
        OMR_Field_Mapping__c omrfield16 = new OMR_Field_Mapping__c();
        omrfield16.Name = 'I don\'t know';
        omrfield16.Field_Type__c = 'Father Education';
        omrfield16.Selected_Number__c = 'F';
        omrfield16.SF_Value__c = 'I don\'t know';
        Insert omrfield16;
        
        OMR_Field_Mapping__c omrfield17 = new OMR_Field_Mapping__c();
        omrfield17.Name = 'Buddhists';
        omrfield17.Field_Type__c = 'Religion';
        omrfield17.Selected_Number__c = 'F';
        omrfield17.SF_Value__c = 'Buddhists';
        Insert omrfield17;
        
        OMR_Field_Mapping__c omrfield18 = new OMR_Field_Mapping__c();
        omrfield18.Name = 'Christians';
        omrfield18.Field_Type__c = 'Religion';
        omrfield18.Selected_Number__c = 'D';
        omrfield18.SF_Value__c = 'Christians';
        Insert omrfield18;
        
        OMR_Field_Mapping__c omrfield19 = new OMR_Field_Mapping__c();
        omrfield19.Name = 'Hindu';
        omrfield19.Field_Type__c = 'Religion';
        omrfield19.Selected_Number__c = 'A';
        omrfield19.SF_Value__c = 'Hindu';
        Insert omrfield19;
        
        OMR_Field_Mapping__c omrfield20 = new OMR_Field_Mapping__c();
        omrfield20.Name = 'I don\'t know Religion';
        omrfield20.Field_Type__c = 'Religion';
        omrfield20.Selected_Number__c = 'H';
        omrfield20.SF_Value__c = 'I don\'t know';
        Insert omrfield20;
        
        OMR_Field_Mapping__c omrfield21 = new OMR_Field_Mapping__c();
        omrfield21.Name = 'Muslims';
        omrfield21.Field_Type__c = 'Religion';
        omrfield21.Selected_Number__c = 'B';
        omrfield21.SF_Value__c = 'Muslims';
        Insert omrfield21;
        
        OMR_Field_Mapping__c omrfield22 = new OMR_Field_Mapping__c();
        omrfield22.Name = 'Others Religion';
        omrfield22.Field_Type__c = 'Religion';
        omrfield22.Selected_Number__c = 'G';
        omrfield22.SF_Value__c = 'Others';
        Insert omrfield22;
        
        OMR_Field_Mapping__c omrfield23 = new OMR_Field_Mapping__c();
        omrfield23.Name = 'Sikhs';
        omrfield23.Field_Type__c = 'Religion';
        omrfield23.Selected_Number__c = 'C';
        omrfield23.SF_Value__c = 'Sikhs';
        Insert omrfield23;
        
        OMR_Field_Mapping__c omrfield24 = new OMR_Field_Mapping__c();
        omrfield24.Name = 'Zoroastrians';
        omrfield24.Field_Type__c = 'Religion';
        omrfield24.Selected_Number__c = 'E';
        omrfield24.SF_Value__c = 'Zoroastrians';
        Insert omrfield24;
        
        OMR_Field_Mapping__c omrfield25 = new OMR_Field_Mapping__c();
        omrfield25.Name = 'General';
        omrfield25.Field_Type__c = 'Category';
        omrfield25.Selected_Number__c = 'A';
        omrfield25.SF_Value__c = 'General';
        Insert omrfield25;
        
        OMR_Field_Mapping__c omrfield26 = new OMR_Field_Mapping__c();
        omrfield26.Name = 'I don\'t know Category';
        omrfield26.Field_Type__c = 'Category';
        omrfield26.Selected_Number__c = 'F';
        omrfield26.SF_Value__c = 'I don\'t know';
        Insert omrfield26;
        
        OMR_Field_Mapping__c omrfield27 = new OMR_Field_Mapping__c();
        omrfield27.Name = 'Nomadic Tribes';
        omrfield27.Field_Type__c = 'Category';
        omrfield27.Selected_Number__c = 'D';
        omrfield27.SF_Value__c = 'Nomadic Tribes';
        Insert omrfield27;
        
        OMR_Field_Mapping__c omrfield28 = new OMR_Field_Mapping__c();
        omrfield28.Name = 'OBC';
        omrfield28.Field_Type__c = 'Category';
        omrfield28.Selected_Number__c = 'C';
        omrfield28.SF_Value__c = 'OBC';
        Insert omrfield28;
        
        OMR_Field_Mapping__c omrfield29 = new OMR_Field_Mapping__c();
        omrfield29.Name = 'SC/ST';
        omrfield29.Field_Type__c = 'Category';
        omrfield29.Selected_Number__c = 'B';
        omrfield29.SF_Value__c = 'SC/ST';
        Insert omrfield29;
        
        OMR_Field_Mapping__c omrfield30 = new OMR_Field_Mapping__c();
        omrfield30.Name = 'SEBC';
        omrfield30.Field_Type__c = 'Category';
        omrfield30.Selected_Number__c = 'D';
        omrfield30.SF_Value__c = 'SEBC';
        Insert omrfield30;
        
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Mumbai';
        sm.Name = 'Mumbai Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'Test000';
        insert sm;
        
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
        
        list<Batch__c> batchLst = new list<batch__c>();
        Batch__c batch1 = new Batch__c();
        batch1.Name = 'batch 1';
        batch1.School_Name__c=account.id;
        batch1.Preferred_Language__c = 'Hindi';
        batch1.Grade__c = 'Grade 9';
        batch1.Medium_Language_of_Instruction__c = 'English';
        batch1.Academic_Year__c = 2023;
        //batch1.Batch_number__c = '8454918131'; Not writeable
        Insert batch1;
        /*batchLst.add(batch1);
        
        Batch__c batch2 = new Batch__c();
        batch2.Name = 'batch 2';
        batch2.School_Name__c=account.id;
        batch2.Preferred_Language__c = 'English';
        batch2.Medium_Language_of_Instruction__c = 'English';
        batchLst.add(batch2);
        
        insert batchLst;*/
        
        //String baseline1filedata = 'U2VyaWFsIE5vLixCYXJjb2RlLFN0dWRlbnQgTmFtZSxEYXRlIE9mIEJpcnRoLFdoYXRzYXBwIE51bWJlcixDdXJyZW50bHkgU3R1ZHlpbmcgSW4sR2VuZGVyLEFsdGVybmF0ZSBNb2JpbGUgTm8sVUlELEZyb250IHNpZGUgSW1hZ2UsQmFjayBzaWRlIEltYWdlDQoxLDIyMDAwNDk1OSxTQUNISU4gRElORVNIIFBSQUpBUEFUSSAsNzEwMjAwOCw4NDU0OTE4MTMxLDIsMSw5MzIxMTI3NTg4LCAgICAgICAgICxHOlxBbnRhcmFuZyBTY2FubmluZ1xCYXNlIExJbmUtMVxJbWFnZVwwMDAxIDIwMjIuMDguMjQgMTQuMTQuNDdGLmpwZywNCjIsMjIwMDAzMjQzLEFESVRZQSBTVU5JTCBUSVdBUkkgICAgICwyODA0MjAwOSw4OTI4NzQxNTkwLDIsMSw4OTI4NzQxNTkwLCAgICAgICAgICxHOlxBbnRhcmFuZyBTY2FubmluZ1xCYXNlIExJbmUtMVxJbWFnZVwwMDAyIDIwMjIuMDguMjQgMTQuMTQuNDlGLmpwZywNCjMsMjIwMDA0OTY2LFlPR0VOREVSIFNJTkdIIFJBVEhPUkUgICwxMTA4MjAwOCw3NjY2NDY3Njk0LDIsMSw3NjY2NDY3Njk0LCAgICAgICAgICxHOlxBbnRhcmFuZyBTY2FubmluZ1xCYXNlIExJbmUtMVxJbWFnZVwwMDAzIDIwMjIuMDguMjQgMTQuMTQuNTFGLmpwZywNCjQsMjIwMDA0OTc3LFJBR0hVIERIQU5BTkpBWSBCT0REVSAgICw1MDIyMDA5LDkxMzc2OTEwNTcsMiwxLDkxMzc2OTEwNTcsICAgICAgICAgLEc6XEFudGFyYW5nIFNjYW5uaW5nXEJhc2UgTEluZS0xXEltYWdlXDAwMDQgMjAyMi4wOC4yNCAxNC4xNC41M0YuanBnLA0KNSwyMjAwMDQ5NjcsUEFSVEggTUFIRU5EUkEgREFOREFORSAgLDYwODIwMDgsODA5NzMyMzY3MSwyLDEsODA5NzMyMzY3MSwgICAgICAgICAsRzpcQW50YXJhbmcgU2Nhbm5pbmdcQmFzZSBMSW5lLTFcSW1hZ2VcMDAwNSAyMDIyLjA4LjI0IDE0LjE0LjU1Ri5qcGcsDQo2LDIyMDAwNDk2NCxKQVkgU0FOSkFZICBLQVJBTkRFS0FSICAgLDIwNDIwMDgsOTc1NzQ2MjI4MiwyLDEsOTc1NzQ2MjI4MiwgICAgICAgICAsRzpcQW50YXJhbmcgU2Nhbm5pbmdcQmFzZSBMSW5lLTFcSW1hZ2VcMDAwNiAyMDIyLjA4LjI0IDE0LjE0LjU3Ri5qcGcsDQo3LDIyMDAwNDk2OSxPTSBSQUpVIE1PVVJZQSAgICAgICAgICAsODEyMjAwOCw3NzM4ODIxNjM4LDIsMSw3NzM4ODIxNjM4LCAgICAgICAgICxHOlxBbnRhcmFuZyBTY2FubmluZ1xCYXNlIExJbmUtMVxJbWFnZVwwMDA3IDIwMjIuMDguMjQgMTQuMTQuNThGLmpwZywNCjgsMjIwMDA0OTY1LFNVUlkqIFNIIFJBSkVTSCBQQU5ERVkgICwxODExMjAwNyw5ODIwNDkzNTg5LDIsMSw5ODIwNDkzNTg5LCAgICAgICAgICxHOlxBbnRhcmFuZyBTY2FubmluZ1xCYXNlIExJbmUtMVxJbWFnZVwwMDA4IDIwMjIuMDguMjQgMTQuMTUuMDBGLmpwZywNCjksMjIwMDA0OTYzLEZBUkhBTiBBSE1BRCBQQVRBTktBUiAgICwxMDAyMjAwOCw4MTA4NDU2MTIxLDIsMSw4MTA4NDU2MTIxLCAgICAgICAgICxHOlxBbnRhcmFuZyBTY2FubmluZ1xCYXNlIExJbmUtMVxJbWFnZVwwMDA5IDIwMjIuMDguMjQgMTQuMTYuMTlGLmpwZywNCjEwLDIyMDAwNDQ5OCxSVUNISSBTQU5UKiBTSCBBTUJBVEkgICAsMTcxMjIwMDgsOTMyMzg2MDM5NSwyLDIsOTMgMzg2MCAqNSwgICAgICAgICAsRzpcQW50YXJhbmcgU2Nhbm5pbmdcQmFzZSBMSW5lLTFcSW1hZ2VcMDAxMCAyMDIyLjA4LjI0IDE0LjE2LjIwRi5qcGcsDQoxMSwyMjAwMDQ0OTcsU0FISUwgTUFIRVNIIEdBSUtXQUQgICAgLDIxMTAyMDA4LDg4NzkwMDM2MDEsMiwxLDg4NzkwMDM2MDEsICAgICAgICAgLEc6XEFudGFyYW5nIFNjYW5uaW5nXEJhc2UgTEluZS0xXEltYWdlXDAwMTEgMjAyMi4wOC4yNCAxNC4xNi4zOUYuanBnLA0K';
        //String baseline2filedata = 'QmFyY29kZSxGYXRoZXIncyBFZHVjYXRpb24sRmF0aGVyJ3MgT2NjdXBhdGlvbixNb3RoZXInIEVkdWNhdGlvbixNb3RoZXIncyBPY2N1cGF0aW9uLFJlbGlnaW9uLENhdGVnb3J5LFBhdGgNCjIyMDAwMDAwMSwqLCosKiwqLCosKiwNCjIyMDAwMDAwMixDLEEsRCxBLEEsQywNCjIyMDAwMDAwMyxDLEUsRSxDLEMsRCwNCjIyMDAwMDAwNCxCLEQsQixHLEYsQiwNCjIyMDAwMDAwNSxDLEYsQixELEgsRCwNCjIyMDAwMDAwNyxBLEgsQSxHLEEsQywNCg%3D%3D';
        
        
        OMR_Manager_Email__c omrEm = new OMR_Manager_Email__c();
        omrEm.Name = 'Test Omr email';
        omrEm.Email__c = 'testomremail@test.com';
        insert omrEm;
        
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Student').getRecordTypeId();
        List<Contact> conList = New List<Contact>{
            New Contact(LastName= 'Test Student', Grade_9_Barcode__c = '220004959', Bar_Code__c = '220004959', AccountId = account.Id, RecordTypeId = conRecTypeId, Batch_Code__c = batch1.Id),
                New Contact(LastName= 'Test Student2', Grade_10_Barcode__c = '220003243', Bar_Code__c = '220003243', AccountId = account.Id, RecordTypeId = conRecTypeId, G10_Batch_Code__c = batch1.Id),
                New Contact(LastName= 'Test Student3', Grade_11_Barcode__c = '220004966', Bar_Code__c = '220004966', AccountId = account.Id, RecordTypeId = conRecTypeId, G11_Batch_Code__c = batch1.Id),
                New Contact(LastName= 'Test Student4', Grade_12_Barcode__c = '220004977', Bar_Code__c = '220004977', AccountId = account.Id, RecordTypeId = conRecTypeId, G12_Batch_Code__c = batch1.Id),
                New Contact(LastName= 'Test Student5', Grade_9_Barcode__c = '220004967', Grade_10_Barcode__c = '220004967', Grade_11_Barcode__c = '220004967', Bar_Code__c = '220004967', AccountId = account.Id, RecordTypeId = conRecTypeId, Batch_Code__c = batch1.Id)
                };     
        Insert conList;
    }
    @isTest
    public static void testMethod01() {
        //upsertOMRContactBatch.testCodeCoverage();
        List<Contact> studentLIST = [SELECT Id, LastName, Grade_9_Barcode__c FROM Contact];
        Map<String, String> expectedGrade = new Map<String, String>();
        for (Contact con : studentLIST) {
            expectedGrade.put(con.Grade_9_Barcode__c, 'Grade 9');
        }
        Test.startTest();
        upsertOMRContactBatch bc = new upsertOMRContactBatch(studentLIST, expectedGrade, 'Baseline 1','test@gmail.com','','');
        Database.executeBatch(bc,30);
        Test.stopTest();
    }
    
    @isTest
    public static void testMethod02() {
        List<Contact> studentLIST = [SELECT Id, LastName, Grade_9_Barcode__c FROM Contact];
        
        Test.startTest();
        upsertOMRContactBatch bc = new upsertOMRContactBatch(studentLIST, 'batch 1','Grade 9','Baseline 1');
        Database.executeBatch(bc,30);
        upsertOMRContactBatch.dummycoverage();
        Test.stopTest();
    }
}