@isTest
public class ContentDocumentLinkTriggerHandlerTest {

    @isTest
    public static void testContentDocumentLink(){
        Test.startTest();
        Student_Feedback_mapping__c std = new Student_Feedback_mapping__c();
        std.Day_Number__c = 'Aptitude';
        std.Display_Number__c = 2;
        std.Display_Type__c = 'RadioGroup';
        std.Field_API__c = 'test__c';
        std.Field_Label__c = 'test';
        std.Language__c = 'eng';
        Insert std;
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        //content.LinkedEntityId=sub.id;
        content.origin = 'H';
        insert content;
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=std.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';insert contentlink;
        Test.stopTest();
    }
    
}