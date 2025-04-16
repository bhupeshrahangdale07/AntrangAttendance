public class assignFacilatorOnBatchController {
    public List<Batch__c> lstBatch{get;set;}
    public List<contact> lstContact{get;set;}
    public string selectedCon{get;set;}
    public string facilitator{get;set;}
    public boolean selectDisable{get;set;}
    
    public assignFacilatorOnBatchController(ApexPages.StandardSetController controller)
    {
        selectDisable = false;
        
        facilitator = apexpages.currentpage().getparameters().get('facilitator');
        string mediumString ='';
        string functionalCity ='';
        string timings ='';
        
        if(controller.getSelected() == NULL || controller.getSelected().size()<=0)
            apexpages.addmessage(new apexpages.message(apexpages.severity.error, 'Please select batch to proceed'));  
        else{
            //system.debug('cont :: '+ controller.getSelected());
            set<id> batchIds = new set<id>();
            for (batch__c b : (List<batch__c>)controller.getSelected()){
                batchIds.add(b.Id);
            }
            
            string lstBatchstr = 'SELECT Id,Name,Need_to_assign_G9__c,Need_to_assign_G10__c,School_Name__r.Name,'+
                'School_Name__r.Medium_Language_of_Instruction__c,School_Name__r.City__r.Name,'+
                'School_Name__r.School_Timing__c FROM Batch__c '+
                ' WHERE Id IN : batchIds';
            if(facilitator == 'G9') lstBatchstr = lstBatchstr+' AND Need_to_assign_G9__c = TRUE';
            else if(facilitator == 'G10')  lstBatchstr = lstBatchstr+' AND Need_to_assign_G10__c = TRUE';
            
            
            
            system.debug('lstBatchstr : '+lstBatchstr);
            lstBatch = database.query(lstBatchstr);
            
            if(lstBatch.size()>0){
                for(Batch__c b : lstBatch){
                    if(b.School_Name__r.Medium_Language_of_Instruction__c != null)
                        mediumString+='\''+b.School_Name__r.Medium_Language_of_Instruction__c+'\',';
                    if(b.School_Name__r.City__r.Name != null)
                        functionalCity+='\''+b.School_Name__r.City__r.Name+'\',';
                    if(b.School_Name__r.School_Timing__c != null)
                        timings+='\''+b.School_Name__r.School_Timing__c+'\',';
                    
                }
                mediumString = mediumString.removeEnd(',');
                functionalCity = functionalCity.removeEnd(',');
                timings = timings.removeEnd(',');
                Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Trainer').getRecordTypeId();
                string str = 'select id,Name, (select id from sessions__r) from contact WHERE RecordTypeId =: RecordTypeIdContact AND Is_Inactive_Trainer__c != TRUE ';
                if(String.isNotBlank(mediumString) || String.isNotBlank(functionalCity) || String.isNotBlank(timings)){
                    str+= ' AND ';
                    if(String.isNotBlank(mediumString))
                        str+= ' Language__c INCLUDES ('+mediumString+') AND ';
                    if(String.isNotBlank(functionalCity))
                        str+= ' Cities_of_Operation__c INCLUDES ('+functionalCity+') AND ';
                    if(String.isNotBlank(timings))
                        str+= ' Trainer_Status__c INCLUDES ('+timings+') ';
                    
                    str = str.removeEnd('AND ');
                    lstContact = database.query(str);
                }
                
                system.debug('qyury :: '+str);
                
                system.debug('lstContact :'+lstContact);
                
                if(lstContact == NULL || lstContact.size()<=0){
                    apexpages.addmessage(new apexpages.message(apexpages.severity.error, 'No match Trainer found please try again'));
                }
            }
            else{
                apexpages.addmessage(new apexpages.message(apexpages.severity.error, 'Please select different batches the selected batches does not met criteria.'));
            }
            
        }
        
        
    }
    
    public PageReference processSelected(){
        if(selectedCon != null){
            selectDisable = true;
            AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
            
            
            Map<string,Session_Mapping__c> mappingSessionMap = new Map<string,Session_Mapping__c>();
            for(Session_Mapping__c objSessionMapping : [select id,name,Description__c,Grade__c,Payment__c,
                                                       Session_Delivery__c,Session_Number__c,Session_Type__c,Session_Mode__c
                                                        FROM Session_Mapping__c]){
                                                           mappingSessionMap.put(string.valueOf(objSessionMapping.Grade__c)+'_'+objSessionMapping.Session_Number__c, objSessionMapping);       
                                                        }
            
        list<Batch__c> batchToUpdate = new list<Batch__c>();
        list<session__c> G9SessionToInsert = new list<session__c>();
        Integer n = facilitator == 'G9' ? Integer.valueOf(setting.Number_of_sessions_for_Grade_9__c) : Integer.valueOf(setting.Number_of_session_for_Grade_10__c);
        String sessionGrade = facilitator == 'G9' ? 'Class 9' : 'Class 10';
            string grade = facilitator == 'G9' ? '9' :'10';
        for(Batch__c b : lstBatch){
            Batch__c bc = new Batch__c();
            bc.Id = b.Id;
            
            if(facilitator == 'G9') {
                bc.Need_to_assign_G9__c = false;
                bc.Trainer_Name__c = selectedCon;
            }
            else if(facilitator == 'G10')  {
                bc.Need_to_assign_G10__c = false;
                bc.Followup_1_Trainer_Name__c = selectedCon;
                bc.Date_of_1st_Follow_up_session__c = date.valueOf(system.now().addmonths(1));
            }
            
            batchToUpdate.add(bc);
            for(integer i=0;i<n;i++){
                session__c s = new session__c();
                if(mappingSessionMap.containskey(grade+'_'+i)){
                    //s.Name = i+'_'+mappingSessionMap.get(grade+'_'+i).Description__c;
                    s.Name = mappingSessionMap.get(grade+'_'+i).Description__c;
                    s.Session_Delivery__c = mappingSessionMap.get(grade+'_'+i).Session_Delivery__c;
                    s.Session_Type__c = mappingSessionMap.get(grade+'_'+i).Session_Type__c;
                    s.Total_Amount__c = mappingSessionMap.get(grade+'_'+i).Payment__c;
                    s.Session_Mode__c = mappingSessionMap.get(grade+'_'+i).Session_Mode__c;
                    s.Session_Number__c = mappingSessionMap.get(grade+'_'+i).Session_Number__c; 
                }else{
                    s.Name = 'Session - '+i;
                }                
                s.Batch__c = b.Id;
                s.Assigned_facilitator__c = selectedCon;
                s.Session_Grade__c = sessionGrade;
                G9SessionToInsert.add(s);
            }
        }
        
        if(batchToUpdate.size()>0){
            update batchToUpdate;
            
            insert G9SessionToInsert;
            
            system.debug(Batch__c.sobjecttype.getDescribe().getKeyPrefix());
            PageReference pg = new PageReference('/'+Batch__c.sobjecttype.getDescribe().getKeyPrefix());
            pg.setRedirect(true);
            return pg;
        }
        else{
            apexpages.addmessage(new apexpages.message(apexpages.severity.error, 'ERROR'));
            return null;
        }
        }
        else{
            apexpages.addmessage(new apexpages.message(apexpages.severity.error, 'Please select trainer to proceed'));
            return null;
        }
        
        
    }
    
    public PageReference backToList()
    {
        system.debug(Batch__c.sobjecttype.getDescribe().getKeyPrefix());
        PageReference pg = new PageReference('/'+Batch__c.sobjecttype.getDescribe().getKeyPrefix());
        pg.setRedirect(true);
        return pg;
    }
    
    
}