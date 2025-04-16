/*
 * Author       : Kandisa Technology Pvt. Ltd.
 * Date         : 15/10/2019
 * Description  : Fetches Picklist fields and their values of given sObject
 * Updation     : 21/04/2020 - Changed label of Picklist Field from API name to Lable
 */

public class PicklistManagementCtrl {

    public string selectedObject {get;set;} 
    public string selectedPicklistField {get;set;}
    public string selectedOperation {get;set;}
    public string newValue {get;set;}
    public string oldValue {get;set;}
    public string order{get;set;}
    
    public boolean showError {get;set;}
    public boolean showAddNewValue {get;set;}
    public boolean showRemoveValue {get;set;}
    public boolean showReplaceValue {get;set;}
    
    public static boolean showResponseMessage {get;set;}
    public static string calloutStatus {get;set;} // success or error only
    public static string calloutResponse {get;set;}
    
    public string operationHeading {get;set;}
    public map<String, List<String>> map_picklistToValues;
    public map<String, String> map_apiNameToLabel;
    
    
    public PicklistManagementCtrl(){
        showError = false;
        showResponseMessage = false;
        showAddNewValue = false;
        showRemoveValue = false;
        showReplaceValue = false;
        map_picklistToValues = new map<String, List<String>>();
        map_apiNameToLabel = new map<String, String>();
        
        oldValue = '';
        newValue = '';
        order = '';
        selectedObject = ''; 
        selectedPicklistField = ''; 
        selectedOperation = '';
    }
    
    
    /*
     * Method : objectSelected
     * Description : Fetches picklist fields of selected sObject
     */
    public void objectSelected(){
        System.debug('Object :: ' + selectedObject);
        selectedPicklistField = '';
        selectedOperation = '';
        
        if(selectedObject != null){
            Schema.SObjectType s = Schema.getGlobalDescribe().get(selectedObject) ;
            Schema.DescribeSObjectResult r = s.getDescribe() ;
            Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
            
            List<String> picklistNames = new List<String>();
            picklistNames.AddAll(fields.keyset());
            picklistNames.Sort();
            
            for(String fieldName : picklistNames){
                
                Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
                Schema.DisplayType fieldType = fieldResult.getType();
                if(String.valueOf(fieldType) == 'PICKLIST' || String.valueOf(fieldType) == 'MULTIPICKLIST'){
                    
                    System.debug(fieldName);
                    fieldName = nameFormat(fieldName);
                    
                    if(!map_picklistToValues.containsKey(fieldName)){
                        map_picklistToValues.put(fieldName, new list<string>());
                        map_apiNameToLabel.put(fieldName, fieldResult.getLabel());
                    }
                    List<String> picklistValues = map_picklistToValues.get(fieldName);
                    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                    for( Schema.PicklistEntry pickListVal : ple){
                        picklistValues.add(pickListVal.getValue());
                    } 
                }
            }
            OperationSelected();
        }
    }
    
    /*
     * Method : nameFormat
     * Description : Returns string with first letter in Uppercase
     */
    public String nameFormat (String name) {
        String result = '';
        
        if (name != null && name != '') {
            for (String iter : name.split('[ ]+')) {
                if (iter != null && iter != '') {
                    if (iter.length() > 1) {  
                        result += iter.substring(0,1).toUpperCase() + iter.substring(1,iter.length()) + ' ';
                    }
                    else {
                        result += iter.substring(0,1).toUpperCase() + ' ';
                    }
                }
            }
            result = result.substring(0, result.length() - 1);
        }
        return result;
    } 
    
    
    /*
     * Method : PicklistSelected
     * Description : Get selected picklist field
     */
    public void PicklistSelected(){
        System.debug('Selected Picklist :: ' + selectedPicklistField);
        selectedOperation = '';
        OperationSelected();
    }
    
    
    /*
     * Method : OperationSelected
     * Description : Shows corresponding operation output panel
     */
    public void OperationSelected(){
        if(selectedObject != null && selectedPicklistField != null && selectedOperation != null){
            if(selectedOperation == 'Add'){
                showAddNewValue = true;
                showRemoveValue = false;
                showReplaceValue = false;
                operationHeading = 'Add new value';
                
            }else if(selectedOperation == 'Remove'){
                showAddNewValue = false;
                showRemoveValue = true;
                showReplaceValue = false;
                operationHeading = 'Remove existing Value';
                
            }else if(selectedOperation == 'Replace'){
                showAddNewValue = false;
                showRemoveValue = false;
                showReplaceValue = true;
                operationHeading = 'Replace existing Value with new value';
            }
        }else{
            showAddNewValue = false;
            showRemoveValue = false;
            showReplaceValue = false;
            operationHeading = '';
        }
        
    }
    
    
    /*
     * Method : getListofPicklist
     * Description : Returns list of picklists
     */
    public List<SelectOption> getListofPicklist() {
        List<SelectOption> options = new List<SelectOption>();
        if(map_apiNameToLabel != null && map_apiNameToLabel.size() > 0){
            options.add(new SelectOption('','--Select Picklist Field--'));
            for(String str : map_apiNameToLabel.keyset()){
                String pickVal = nameFormat(map_apiNameToLabel.get(str));
                options.add(new SelectOption(str,pickVal));
            }
        }
        return options;
    }
    
    
    /*
     * Method : getPicklistValues
     * Description : Returns list of picklist values
     */
    public List<SelectOption> getPicklistValues() {
        List<SelectOption> options = new List<SelectOption>();
        if(map_picklistToValues != null && map_picklistToValues.size() > 0){
            
            for(String picklistName : map_picklistToValues.keyset()){
                
                if(picklistName == selectedPicklistField){
                    List<String> lst_listValues = map_picklistToValues.get(picklistName);
                    if(lst_listValues != null && lst_listValues.size() > 0){
                        options.add(new SelectOption('','--Select Value--'));
                        for(String val : lst_listValues){
                            options.add(new SelectOption(val, val));
                        }
                    }
                }
                
            }
        }
        return options;
    }
    
    
    /*
     * Method : savePicklistChanges
     * Description : Get the Picklist and picklist values and set a API Callout.
     */
    public void savePicklistChanges(){
        showError = false;
        if(String.isNotBlank(selectedObject)  && String.isNotBlank(selectedPicklistField) && String.isNotBlank(selectedOperation) &&
           ((selectedOperation == 'Add' && String.isNotBlank(newValue) && String.isNotBlank(order)) ||
            (selectedOperation == 'Remove' && String.isNotBlank(oldValue)) || 
            (selectedOperation == 'Replace' && String.isNotBlank(newValue) && String.isNotBlank(oldValue) ))){
                
                System.debug('Picklist being updated to' + selectedObject + ' ' + selectedPicklistField + ' ' + selectedOperation + ' ' + newValue + ' ' + oldValue + order);
                
                String accessToken = getAccessToken();
                String objName = '';
                if(selectedObject == 'Contact'){
                        objName = 'Contact';
                    }else if(selectedObject == 'Opportunity__c'){
                        objName = 'Opportunity';
                    }else if(selectedObject == 'Opportunity_Assignment__c'){
                        objName = 'Opportunity Assessments';
                    }
                
                String strBody = '{' +
                    
                    '"master_api_object_name":"' + objName + '",'+
                    '"master_api_label" : "' + map_apiNameToLabel.get(selectedPicklistField) + '",'+
                    '"master_api_name":"' + selectedPicklistField + '",';
                
                if(selectedOperation == 'Add'){
                    oldValue = '';
                    strBody += '"master_api_value": "' + newValue + '",' +
                        '"master_api_value_name":"' + newValue + '",'+
                        '"master_api_old_value" :"",' +
                        '"master_api_new_value" :"",' +
                        '"master_api_order_by" :"' + order + '",'+
                        '"api_user_auth_token":"' + accessToken + '",'+
                        '"mode" :"i"' +
                        '}';
                }else if(selectedOperation == 'Remove'){
                    newValue = '';
                    strBody += '"master_api_value": "' + oldValue + '",' +
                        '"master_api_value_name":"",'+
                        '"master_api_old_value" :"",' +
                        '"master_api_new_value" :"",' +
                        '"api_user_auth_token":"' + accessToken + '",'+
                        '"mode" :"d"' +
                        '}';
                }else if(selectedOperation == 'Replace'){
                    strBody += '"master_api_value": "",' +
                        '"master_api_value_name":"",'+
                        '"master_api_old_value" :"' + oldValue + '",' +
                        '"master_api_new_value" :"' + newValue + '",' +
                        '"api_user_auth_token":"' + accessToken + '",'+
                        '"mode" :"U"}';
                }
                
                
                AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
                String endpoint = '';
                if (setting == null || string.isblank(setting.BaseApiUrl__c )) {
                    String strMessage = 'Opportunity Api Endpoint is not populated. Please go to Custom Setting -> Antarang Setting -> Opportunity Api Endpoint  .';
                    
                } else {
                    endpoint = setting.BaseApiUrl__c +'mastersync/insertupdatemaster'  ;
                }
                
                calloutStatus = '';
                HttpResponse response = doCallout(strBody, 'POST', endpoint, accessToken);
                
                if(calloutStatus == 'success'){
                    sendEmailToAdmin();
                }
                
            }else{
                
                showError = true;
            }   
        oldValue = '';
        newValue = '';
        order = '';
        selectedObject = ''; 
        selectedPicklistField = ''; 
        selectedOperation = '';
        map_picklistToValues = new map<String, List<String>>();
        showAddNewValue = false;
        showRemoveValue = false;
        showReplaceValue = false; 
    }
    
    
    
    /*
     * Method : getAccessToken
     * Description : Method to Generate Access Token 
     */
    public static string getAccessToken(){
        AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
        String strBody ='';
        string strMessage = '';
        try{
            strbody += '{';
            strBody += '"api_user_name": "'+ setting.ApiUserName__c  +'",';
            strBody += '"api_user_password": "'+ setting.ApiUserPassword__c  +'"';
            strbody += '}';
            String endpoint = '';
            // Endpoint from custom setting 
            if (setting == null || string.isblank(setting.BaseApiUrl__c)) {
                strMessage = 'Access Token Endpoint is not populated. Please go to Custom Setting -> Antarang Setting -> Access Token Endpoint .';
                return strMessage;
            } else {
                endpoint = setting.BaseApiUrl__c +'apiuserlogin/validateapiuser' ;
            }
            // callout for access token 
            HttpResponse response = doCallout(strBody,'POST',endpoint,'');
            System.debug('response :: ' + response);
            if (response != null && response.getStatusCode() == 200) {
                string restBody = response.getBody();
                list <object> tokenlst = (list <object > ) JSON.deserializeUntyped(restBody);
                for(object obj : tokenlst){
                    Map < String, Object > m = (Map < String, Object > ) JSON.deserializeUntyped(json.serialize(obj));
                    if (m.containskey('authentication_token')) {
                        strMessage = string.valueof(m.get('authentication_token'));
                        break;
                        system.debug(strMessage);
                    }
                }
            }else if (response != null) {
                list <object> tokenlst = (list <object > ) JSON.deserializeUntyped(response.getBody());
                for(object obj : tokenlst){
                    Map < String, Object > m = (Map < String, Object > ) JSON.deserializeUntyped(json.serialize(obj));
                    if (m.containskey('error')) {
                        strMessage = string.valueof(m.get('error'));
                        strMessage = strMessage.replace('{', '').replace('}', '');
                    }
                }
            }
        }catch (Exception ex) {
            strMessage = ex.getMessage();
        }
        return strMessage;
    }
    
    
  
    /*
     * Method : doCallout
     * Description : Generic Http method to call out 
     */
    public static HttpResponse doCallout(string strBody, string strMethod, string endpoint, string Acctoken) {
        
        try {
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod(strMethod);
            request.setTimeout(120000);
            request.setBody(strBody);
            system.debug('strRequestBody ::: ' + strBody);
            system.debug('endpoint::: ' + endpoint);
            
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Content-Length', string.valueof(strBody.length()));
            request.setHeader( 'Authorization', Acctoken );
            HttpResponse response = new Http().send(request);
            system.debug(' Response :: ' + response.getBody());
           
            showResponseMessage = true;
           
            ResponseDetails resDetails = parseResponseBody(response);
            System.debug(resDetails);
            if(resDetails.statusCode == 'SUCCESS'){
                calloutStatus = 'success';
            }else if(resDetails.statusCode == 'FAILED'){
                calloutStatus = 'error';
            }
            calloutResponse = resDetails.response;
            
            return response;
        } catch (Exception ex) {
            System.debug('Exception: ' + ex);
            return null;
        }
    }
    
    
    /*
     * Method : parseResponseBody
     * Description : Parses HTTPResponse and returns ResponseDetails
     */
    public static ResponseDetails parseResponseBody(HttpResponse response){
        String responseLine;
        String responseStatus;
        String strMessage;
        
        ResponseDetails resDetails = new ResponseDetails();
        
        if (response != null && response.getStatusCode() == 200) {
            string restBody = response.getBody();
            list <object> resList = (list <object > ) JSON.deserializeUntyped(restBody);
            for(object obj : resList){
                Map < String, Object > m = (Map < String, Object > ) JSON.deserializeUntyped(json.serialize(obj));
                if (m.containskey('response')) {
                    responseLine = string.valueof(m.get('response'));
                    resDetails.response = responseLine;
                    
                    system.debug(responseLine);
                }
                if (m.containskey('StatusCode')) {
                    responseStatus = string.valueof(m.get('StatusCode'));
                    resDetails.statusCode = responseStatus;
                    
                    system.debug(responseStatus);
                }
            }
            return resDetails;
        }else {
           return null;
        }
    }
    

    /*
     * Method : sendEmailToAdmin
     * Description : Send Email to Admin, so that Admin can manage picklist values as per these changes.
     */
    public void sendEmailToAdmin(){
        
        String UserEmail = UserInfo.getUserEmail();
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        //message.toAddresses = new String[] { UserEmail };
            message.toAddresses = new String[] {'antarang.admin@kandisatech.com'};
        message.subject = 'Picklist Management : Need To update picklist';

        String body = 'Hi Admin,<br/><br/>';
        body += 'Object API Name: ' + selectedObject + ' <br/>';
        body += 'Picklist API Name: ' + selectedPicklistField + ' <br/>';
        body += 'Operation: ' + selectedOperation + ' <br/>';
        body += 'New Value: ' + newValue + ' <br/>';
        body += 'Old Value: ' + oldValue + ' <br/>';
        body += 'Order: ' + order + ' <br/><br/>';
        body += 'Regards,';
        
        message.htmlbody = body;
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) 
        {
            System.debug('The email was sent successfully.');
        } else 
        {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }    
 
    
    public class ResponseDetails{
        public string statusCode {get;set;}
        public string response {get;set;}
        public ResponseDetails(){}
    }
}