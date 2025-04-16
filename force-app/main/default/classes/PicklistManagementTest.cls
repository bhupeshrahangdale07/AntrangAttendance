@isTest
public class PicklistManagementTest {
    
    @isTest
    public static void calloutPicklistMgntForAdd(){
        
        AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();   
        setting.BaseApiUrl__c = 'http://dscareereadyapp.azurewebsites.net/api/apiuserlogin/validateapiuser';
        insert setting;
        
        CalloutMock accTokenRes = new CalloutMock('http://dscareereadyapp.azurewebsites.net/api/apiuserlogin/validateapiuser',200,'OK','[{"authentication_token": "1D17830820B64487A26DAFEAF0974E57"}]', new map < string, string > {'Content-Type' => 'application/json'});
        Test.setMock(HttpCalloutMock.class, accTokenRes);
        
        Test.startTest();
        PicklistManagementCtrl pickCtrl = new PicklistManagementCtrl();
        pickCtrl.selectedObject = 'Opportunity__c';
        pickCtrl.objectSelected();
        
        pickCtrl.selectedPicklistField = 'Gender__c';
        pickCtrl.PicklistSelected();
        
        pickCtrl.selectedOperation = null;
        pickCtrl.OperationSelected();
        
        pickCtrl.selectedOperation = 'Add';
        pickCtrl.OperationSelected();
                
        pickCtrl.getListofPicklist();
        pickCtrl.getPicklistValues();
        
        pickCtrl.newValue = 'Test1';
        pickCtrl.oldValue = '';
        pickCtrl.savePicklistChanges();

        pickCtrl.sendEmailToAdmin();
        
        Test.stopTest();
    }
    
    @isTest
    public static void calloutPicklistMgntForRemove(){
        
        AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();   
        setting.BaseApiUrl__c = 'http://dscareereadyapp.azurewebsites.net/api/apiuserlogin/validateapiuser';
        insert setting;
        
        CalloutMock accTokenRes = new CalloutMock('http://dscareereadyapp.azurewebsites.net/api/apiuserlogin/validateapiuser',200,'OK','[{"authentication_token": "1D17830820B64487A26DAFEAF0974E57"}]', new map < string, string > {'Content-Type' => 'application/json'});
        Test.setMock(HttpCalloutMock.class, accTokenRes);
        
        Test.startTest();
        PicklistManagementCtrl pickCtrl = new PicklistManagementCtrl();
        pickCtrl.selectedObject = 'Opportunity__c';
        pickCtrl.objectSelected();
        
        pickCtrl.selectedPicklistField = 'Gender__c';
        pickCtrl.PicklistSelected();
        
        pickCtrl.selectedOperation = null;
        pickCtrl.OperationSelected();
        
        pickCtrl.selectedOperation = 'Remove';
        pickCtrl.OperationSelected();
        
        pickCtrl.getListofPicklist();
        pickCtrl.getPicklistValues();
        
        pickCtrl.newValue = '';
        pickCtrl.oldValue = 'Test1';
        pickCtrl.savePicklistChanges();
        
        pickCtrl.sendEmailToAdmin();
        
        Test.stopTest();
    }
    
    @isTest
    public static void calloutPicklistMgntForReplace(){
        
        
        AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();   
        setting.BaseApiUrl__c = 'http://dscareereadyapp.azurewebsites.net/api/apiuserlogin/validateapiuser';
        //insert setting;
        
        CalloutMock accTokenRes = new CalloutMock('http://dscareereadyapp.azurewebsites.net/api/apiuserlogin/validateapiuser',200,'OK','[{"authentication_token": "1D17830820B64487A26DAFEAF0974E57"}]', new map < string, string > {'Content-Type' => 'application/json'});
        Test.setMock(HttpCalloutMock.class, accTokenRes);
        
        Test.startTest();
        PicklistManagementCtrl pickCtrl = new PicklistManagementCtrl();
        pickCtrl.selectedObject = 'Opportunity__c';
        pickCtrl.objectSelected();
        
        pickCtrl.selectedPicklistField = 'Gender__c';
        pickCtrl.PicklistSelected();
        
        pickCtrl.selectedOperation = null;
        pickCtrl.OperationSelected();

        pickCtrl.selectedOperation = 'Replace';
        pickCtrl.OperationSelected();
        
        pickCtrl.getListofPicklist();
        pickCtrl.getPicklistValues();
        
        pickCtrl.newValue = 'Test1';
        pickCtrl.oldValue = 'Test';
        pickCtrl.savePicklistChanges();
        
        pickCtrl.sendEmailToAdmin();
        
        Test.stopTest();
    }
}