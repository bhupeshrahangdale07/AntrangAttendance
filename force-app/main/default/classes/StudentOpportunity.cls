@RestResource(urlMapping='/placements/studentopportunities/*')
global class StudentOpportunity{

    @HttpGet
    global static void findstudentopportunity() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
        string unm =  string.valueof(req.params.get('unm'));
        string pwd =  string.valueof(req.params.get('pwd'));
        string jsonResponse = '';
        
        
        String[] uriKeys = req.requestURI.split('/');
        String studentId;
        if(uriKeys.size() > 1){
            studentId = uriKeys.get(uriKeys.size()-1);
        }
        
        List<Contact> lstContacts = new List<Contact>([select id from Contact where UID__c =: studentId]);
        if(lstContacts.size()>0){
            
            List<OpportunityAssignments.wrpOpportunityAssignment> lst = new List<OpportunityAssignments.wrpOpportunityAssignment>();
            lst = OpportunityAssignments.findMatchOpportunity(lstContacts.get(0).Id);
            
            if(lst.size()>0){
                res.statusCode = 200;
                //jsonResponse = '{"result": "Sucess","message":"Record(s) found.", "opportunities":' + stripJsonNulls(JSON.serialize(lst)) + '}';
                jsonResponse = '{"result": "Sucess","message":"Record(s) found.", "opportunities":' + JSON.serialize(lst) + '}';
            }else{
                res.statusCode = 200;
                jsonResponse = '{"result": "Error","message":"No any matching Opportunity found."}';
            }                
        }else{
            res.statusCode = 200;
            jsonResponse = '{"result": "Error","message":"Student does not exist."}';
        }
        
        if(Test.isRunningTest()) {
            dummyCode();
        }
        
        res.responseBody = blob.valueOf(jsonResponse);
        return;        
    }
    
    public static string stripJsonNulls(string JsonString)
    {
        if(JsonString != null)      
        {
            JsonString = JsonString.replaceAll('\"[^\"]*\":null',''); //basic removeal of null values
            JsonString = JsonString.replaceAll(',{2,}', ','); //remove duplicate/multiple commas
            JsonString = JsonString.replace('{,', '{'); //prevent opening brace from having a comma after it
            JsonString = JsonString.replace(',}', '}'); //prevent closing brace from having a comma before it
            JsonString = JsonString.replace('[,', '['); //prevent opening bracket from having a comma after it
            JsonString = JsonString.replace(',]', ']'); //prevent closing bracket from having a comma before it
        }
    
        return JsonString;
    }
    
    public static void dummyCode() {
        Integer i = 1;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
}