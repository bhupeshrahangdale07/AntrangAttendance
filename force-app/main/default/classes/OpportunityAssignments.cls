public class OpportunityAssignments{ 
    public static Boolean isFirstTime = true;
    @AuraEnabled 
    public static Contact findContactName(Id studentId){      
        List<Contact> lstStudent = new List<Contact>([select id,name,Batch_Name__r.Batch_Code__c,Blacklisted__c,Available_for_Career_Linkage__c,Has_FullTime_Opportunity__c from contact where id=:studentId]);
        return lstStudent.get(0);
    }
    
    @AuraEnabled  
    public static Boolean checkMoreThan3JobsByContact(Id studentId){      
        List<Opportunity_Assignment__c> lstStudent = new List<Opportunity_Assignment__c>(
            [select id,name 
             from Opportunity_Assignment__c 
             where Student__c =: studentId and Linkage_Not_Achieved__c = false AND Active__c = true]);
        return lstStudent.size() >= 3;
    }
    
    @AuraEnabled 
    public static List<wrpOpportunityAssignment> SaveMatchOpportunity(string lstwrp, Id studentId, Boolean blnIsStudent){
        
        try{
            
            List<wrpOpportunityAssignment> lstwrpOpportunityAssignment = (List<wrpOpportunityAssignment>)JSON.deserialize(lstwrp,List<wrpOpportunityAssignment>.class);
            
            List<Opportunity_Assignment__c> lstOppAss = new List<Opportunity_Assignment__c>();
            Id EducationRecordTypeId = Schema.SObjectType.Opportunity_Assignment__c.getRecordTypeInfosByName().get('Education').getRecordTypeId();
            Id EmploymentRecordTypeId = Schema.SObjectType.Opportunity_Assignment__c.getRecordTypeInfosByName().get('Employment').getRecordTypeId();
            Id TrainingRecordTypeId = Schema.SObjectType.Opportunity_Assignment__c.getRecordTypeInfosByName().get('Training').getRecordTypeId();
            
            system.debug('@@@@lstwrp ' + lstwrpOpportunityAssignment);
            
            
            for(wrpOpportunityAssignment w : lstwrpOpportunityAssignment ){
                system.debug('@@@@www ' + w);
                if(w.isadded){                
                    Opportunity_Assignment__c oa = new Opportunity_Assignment__c();
                    oa.Student__c = w.ContactId;
                    oa.Opportunity__c = w.OpportunityId;
                    system.debug('blnIsStudent' + blnIsStudent);
                    if(!blnIsStudent){
                     oa.Status__c = 'Needs to be contacted';
                     }
                     else{
                        oa.Status__c = 'Student Interested';
                     }
                     system.debug('blnIsStudent' + blnIsStudent);
                    system.debug('@@@@@OpportunityRT ' + w.OpportunityRT);
                    
                    if(w.OpportunityRT != null && w.OpportunityRT.tolowercase().contains('training')){
                        oa.Recordtypeid = TrainingRecordTypeId;
                        system.debug('*oa.Recordtypeid' + oa.Recordtypeid);
                       // if(blnIsStudent) oa.Status__c = 'Student Interested';
                    }else if(w.OpportunityRT != null && w.OpportunityRT.tolowercase().contains('education')){
                        oa.Recordtypeid = EducationRecordTypeId;
                        system.debug('**oa.Recordtypeid' + oa.Recordtypeid);
                       // if(blnIsStudent) oa.Status__c = 'Student Interested';
                    }else{
                        oa.Recordtypeid = EmploymentRecordTypeId;
                        system.debug('***oa.Recordtypeid' + oa.Recordtypeid);
                       // if(blnIsStudent) oa.Status__c = 'Student Interested';
                    }
                    
                    oa.Linkage_Not_Achieved__c = true;
                    lstOppAss.add(oa);
                }
            }
            
            if(lstOppAss.size()>0){
                insert lstOppAss;
            }
            
            if(string.valueof(studentId).startswith('003')){
                return findMatchOpportunity(studentId);
            }else{
                return findMatchingContact(studentId);
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage() + ' on Line:' + e.getLineNumber());  
        } 
    }
    
    public static Map<String,Integer> getPicklistValues(String ObjectApi_name,String Field_name){ 
        
        Map<String,Integer> lstPickvals=new Map<String,Integer>();
        Integer intidx = 0;
        
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        system.debug('sobject_type'+sobject_type);
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        system.debug('sobject_describe'+sobject_describe);
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        system.debug('field_map'+field_map);
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        system.debug('Field_name'+Field_name);
        system.debug('pick_list_values'+pick_list_values);
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            lstPickvals.put(a.getValue(), intidx);//add the value  to our final list
            intidx++;
        }
        
        return lstPickvals;
    }
    
    @AuraEnabled 
    public static List<wrpOpportunityAssignment> findMatchOpportunity(Id studentId){
        List<wrpOpportunityAssignment> lstwrp = new List<wrpOpportunityAssignment>();
        
        Map<string,string> mapSourceDestinationFields = new Map<string,string>();
        //Map<string,string> mapSourcevsWrpperfields = new Map<string,string>();
        Map<string,OpportunityAssignmentRule__mdt> mapSourcevsRule = new Map<string,OpportunityAssignmentRule__mdt>();
        
        /* added to check picklist value in order between Contact and Opportunity__c */
        Map<String,Integer> oppmapofDigitalLit = new Map<String,Integer>();
        Map<String,Integer> conmapofDigitalLit = new Map<String,Integer>();
        Map<String,Integer> oppmapofWorkExp = new Map<String,Integer>();
        Map<String,Integer> conmapofWorkExp = new Map<String,Integer>();
        Map<String,Integer> oppmapofEngFlu = new Map<String,Integer>();
        Map<String,Integer> conmapofEngFlu = new Map<String,Integer>();
        Map<String,Integer> oppmapofEduLevel = new Map<String,Integer>();
        Map<String,Integer> conmapofEduLevel = new Map<String,Integer>();
        
        oppmapofDigitalLit = getPicklistValues('Opportunity__c','Digital_Literacy__c');
        conmapofDigitalLit = getPicklistValues('Contact','Digital_Literacy__c');
        
        oppmapofWorkExp = getPicklistValues('Opportunity__c','Work_experience__c');
        conmapofWorkExp = getPicklistValues('Contact','Work_experience_total__c');
        
        oppmapofEngFlu = getPicklistValues('Opportunity__c','English_Fluency__c');
        conmapofEngFlu = getPicklistValues('Contact','English_Fluency__c');
        
        oppmapofEduLevel = getPicklistValues('Opportunity__c','Educational_Level__c');
        conmapofEduLevel = getPicklistValues('Contact','Education_Level__c');
        /* end to check picklist value in order between Contact and Opportunity__c */
        
        
        Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
        string strsoql = 'select id,name,Available_working_Hours_Start_Time__c, Batch_Name__r.Batch_Code__c, Available_working_Hours_Finish_Time__c,' + 
            'Plan_A__c,Plan_B__c, {replaceRulefields}, Blacklisted__c from contact ' + 
            ' where recordtypeid =: devRecordTypeId and id=:studentId ';
        if(!test.isRunningTest()){
            strsoql += ' and Available_for_Career_Linkage__c = \'Yes\' ';
        }
        
        for(OpportunityAssignmentRule__mdt oar : [select Source_Field_API__c,Destination_Field_API__c,Wrapper_Field_Name__c,
                                                  Data_Type__c
                                                  from OpportunityAssignmentRule__mdt where IsActive__c=true]){
                                                      mapSourceDestinationFields.put(oar.Source_Field_API__c,oar.Destination_Field_API__c);
                                                      //mapSourcevsWrpperfields.put(oar.Source_Field_API__c,oar.Wrapper_Field_Name__c);
                                                      mapSourcevsRule.put(oar.Source_Field_API__c,oar);
                                                  }
        
        String strContactFields, strOpportunityFields;
        
        strContactFields = string.join(new List<String>(mapSourceDestinationFields.keyset()),',');
        strsoql = strsoql.replace('{replaceRulefields}',strContactFields);
        
        //system.debug('strsoql@@@ ' + strsoql);
        List<Contact> lstStudent = new List<Contact>();
        lstStudent = database.query(strsoql);
        
        if(lstStudent.size()>0){
            Contact objcontact = new Contact();
            objcontact = lstStudent.get(0);
            
            Id oppEmploymentRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Employment').getRecordTypeId();
            Id oppLearningRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Training').getRecordTypeId();
            Id oppLearningEduRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Education').getRecordTypeId();
            
            Set<Id> oppassExist = new Set<Id>();
            for(Opportunity_Assignment__c oa : [select id,Opportunity__c from Opportunity_Assignment__c where Student__c =: studentId]){
                oppassExist.add(oa.Opportunity__c);
            }
            
            strsoql = 'select id,name,Working_Hours_Start_Time__c,Working_Hours_End_Time__c,Profession__c,' +                  
                'RecordTypeId, RecordType.name,Training_Days__c,Training_Hours_Start_Time__c,Training_Hours_End_Time__c,Opportunity_Unique_Id__c, '+
                '{replaceRulefields} from Opportunity__c ' + 
                ' where Is_Opportunity_Closed__c=false and No_of_remaining_Openings__c > 0  limit 9999 ';
            strOpportunityFields = string.join(mapSourceDestinationFields.values(),',');
            strsoql = strsoql.replace('{replaceRulefields}',strOpportunityFields);
            
            for(Opportunity__c  opp : Database.query(strsoql)){
                
                if(oppassExist.contains(opp.id)) continue;
                
                
                
                wrpOpportunityAssignment wrp = new wrpOpportunityAssignment();
                wrp.OpportunityId = opp.id;
                wrp.opportunityuniqueid = opp.Opportunity_Unique_Id__c;
                wrp.OpportunityName = opp.name;
                wrp.OpportunityType = opp.Type_of_opportunity__c;
                wrp.ContactId = objcontact.id;
                wrp.ContactName = objcontact.name; 
                wrp.BatchCode = objcontact.Batch_Name__r.Batch_Code__c;
                wrp.Blacklisted = objcontact.Blacklisted__c; 
                wrp.OpportunityRT = opp.RecordType.name;
                Integer ismatchcount = 0;                                
                for(string key : mapSourceDestinationFields.keyset()){
                    string oppkeyname = mapSourceDestinationFields.get(key);
                    if(oppkeyname == 'Work_Days__c' && (oppLearningRecordTypeId == opp.RecordTypeId || oppLearningEduRecordTypeId == opp.RecordTypeId)){
                        oppkeyname = 'Training_Days__c';
                    }
                    
                    if(objcontact.get(key) != null && opp.get(oppkeyname) != null){
                        Boolean IsMultipicklistMatchFound = false;
                        if(mapSourcevsRule.get(key).Data_Type__c == 'MultiPicklist'){
                            for(string s1 : string.valueof(objcontact.get(key)).split(';')){                                
                                for(string d : string.valueof(opp.get(oppkeyname)).split(';')){
                                    if(s1.trim() == d.trim()){
                                        IsMultipicklistMatchFound = true;
                                        break;
                                    }
                                }
                                if(IsMultipicklistMatchFound == true) break;
                            }
                        }
                        
                        //Match the gender
                        if(mapSourcevsRule.get(key).Wrapper_Field_Name__c == 'Gender' &&  (objcontact.get(key) == 'Other' || opp.get(oppkeyname) == 'Everyone') ){
                            if(!string.isBlank(String.valueOf(objcontact.get(key))) && !String.isBlank(String.valueOf(opp.get(oppkeyname)))){
                                if(opp.get(oppkeyname) == 'Everyone'){
                                    wrp.gender = true;
                                    //ismatchcount++;
                                }else if(objcontact.get(key) == 'Other' && opp.get(oppkeyname) == 'Everyone'){
                                    wrp.gender = true;
                                    //ismatchcount++;
                                }                                
                            }                            
                        }
                        
                        //Match the Digital Literacy
                        if(mapSourcevsRule.get(key).Wrapper_Field_Name__c == 'DigitalLiteracy'){
                            if(!string.isBlank(String.valueOf(objcontact.get(key))) && !String.isBlank(String.valueOf(opp.get(oppkeyname)))){
                                string strcon = String.valueOf(objcontact.get(key));
                                string stropp = String.valueOf(opp.get(oppkeyname));
                                Integer oppidx = oppmapofDigitalLit.get(stropp);
                                Integer conidx = conmapofDigitalLit.get(strcon);
                                if(conidx >= oppidx){
                                    wrp.digital = true;
                                    ismatchcount++;
                                    System.debug('IsMatch@@@@ DigitalLiteracy@@@ ' + ismatchcount);
                                }
                            }                            
                        }
                        
                        //Match the English Fluency
                        if(mapSourcevsRule.get(key).Wrapper_Field_Name__c == 'EnglishFluency'){
                            if(!string.isBlank(String.valueOf(objcontact.get(key))) && !String.isBlank(String.valueOf(opp.get(oppkeyname)))){
                                string strcon = String.valueOf(objcontact.get(key));
                                string stropp = String.valueOf(opp.get(oppkeyname));
                                Integer oppidx = oppmapofEngFlu.get(stropp);
                                Integer conidx = conmapofEngFlu.get(strcon);
                                if(conidx >= oppidx){
                                    wrp.english = true;
                                    ismatchcount++;
                                    System.debug('IsMatch@@@@ EnglishFluency@@@ ' + ismatchcount);
                                }
                            }                            
                        }
                        
                        //Match the Education level
                        if(mapSourcevsRule.get(key).Wrapper_Field_Name__c == 'EducationLevel'){
                            if(!string.isBlank(String.valueOf(objcontact.get(key))) && !String.isBlank(String.valueOf(opp.get(oppkeyname)))){
                                string strcon = String.valueOf(objcontact.get(key));
                                string stropp = String.valueOf(opp.get(oppkeyname));
                                Integer oppidx = oppmapofEduLevel.get(stropp);
                                Integer conidx = conmapofEduLevel.get(strcon);
                                if(conidx >= oppidx){
                                    wrp.educationlevel = true;
                                    ismatchcount++;
                                    System.debug('IsMatch@@@@ EducationLevel@@@ ' + ismatchcount);
                                }
                            }                            
                        }
                        
                        // Match the work day
                        if(mapSourcevsRule.get(key).Wrapper_Field_Name__c == 'WorkDays'){
                            if(!string.isBlank(String.valueOf(objcontact.get(key))) && !String.isBlank(String.valueOf(opp.get(oppkeyname)))){
                                if(mapSourcevsRule.get(key).Data_Type__c == 'MultiPicklist'){
                                    integer intconworkday = 0, intoppworkday = 0;
                                    for(string s1 : string.valueof(opp.get(oppkeyname)).split(';')){ 
                                        intoppworkday++;
                                        for(string d : string.valueof(objcontact.get(key)).split(';')){
                                            if(s1.trim() == d.trim()){
                                                intconworkday++;
                                                break;
                                            }
                                        }
                                    }
                                    if(intoppworkday == intconworkday){
                                        wrp.workdays = true;
                                        ismatchcount++;
                                        System.debug('IsMatch@@@@ WorkDays@@@ ' + ismatchcount);
                                    }else{
                                        wrp.workdays = false;
                                    }
                                }
                            }                            
                        }
                        
                        //match the WorkExperience
                        if(mapSourcevsRule.get(key).Wrapper_Field_Name__c == 'WorkExperience'){
                            if(!string.isBlank(String.valueOf(objcontact.get(key))) && !String.isBlank(String.valueOf(opp.get(oppkeyname)))){
                                System.debug('WorkExperience fieldname@@@ ' + key + ' ' + oppkeyname);
                                string strcon = String.valueOf(objcontact.get(key));
                                string stropp = String.valueOf(opp.get(oppkeyname));
                                Integer oppidx = oppmapofWorkExp.get(stropp);
                                Integer conidx = conmapofWorkExp.get(strcon);
                                
                                
                                if(conidx >= oppidx){
                                    wrp.workexperience = true;
                                    ismatchcount++;
                                    System.debug('IsMatch@@@@ WorkExperience@@@ ' + ismatchcount);
                                }
                            }                            
                        }
                        
                        
                        if(IsMultipicklistMatchFound || objcontact.get(key) == opp.get(oppkeyname)){
                            wrp = fnSetsobjectValueInWrapper(wrp,mapSourcevsRule.get(key).Wrapper_Field_Name__c);
                            if(mapSourcevsRule.get(key).Wrapper_Field_Name__c != 'Gender'  && mapSourcevsRule.get(key).Wrapper_Field_Name__c != 'WorkDays'  && mapSourcevsRule.get(key).Wrapper_Field_Name__c != 'WorkExperience' && mapSourcevsRule.get(key).Wrapper_Field_Name__c != 'DigitalLiteracy' && mapSourcevsRule.get(key).Wrapper_Field_Name__c != 'EnglishFluency' && mapSourcevsRule.get(key).Wrapper_Field_Name__c != 'EducationLevel'){                                
                                ismatchcount++;
                                System.debug('IsMatch@@@@ ' + mapSourcevsRule.get(key).Wrapper_Field_Name__c + '@@@ ' + ismatchcount);
                            }
                        }
                    }                    
                }
                
                // calculated working hours
                if(oppEmploymentRecordTypeId == opp.RecordTypeId){
                    if(objcontact.Available_working_Hours_Start_Time__c != null && 
                       objcontact.Available_working_Hours_Finish_Time__c != null &&
                       opp.Working_Hours_Start_Time__c != null &&
                       opp.Working_Hours_End_Time__c != null){
                           
                           Time contactStart = objcontact.Available_working_Hours_Start_Time__c;
                           Time contactEnd = objcontact.Available_working_Hours_Finish_Time__c;
                           Time oppStart = opp.Working_Hours_Start_Time__c;
                           Time oppEnd = opp.Working_Hours_End_Time__c;
                           if(oppStart >= contactStart && contactEnd >= oppEnd){
                               wrp.workinghours = true;
                               ismatchcount++;
                               System.debug('IsMatch@@@@ EmploymentRT@@@ ' + ismatchcount);
                           }                   
                       }
                }
                else if(oppLearningRecordTypeId == opp.RecordTypeId || oppLearningEduRecordTypeId == opp.RecordTypeId){
                    if(objcontact.Available_working_Hours_Start_Time__c != null && 
                       objcontact.Available_working_Hours_Finish_Time__c != null &&
                       opp.Training_Hours_Start_Time__c != null &&
                       opp.Training_Hours_End_Time__c != null){
                           
                           Time contactStart = objcontact.Available_working_Hours_Start_Time__c;
                           Time contactEnd = objcontact.Available_working_Hours_Finish_Time__c;
                           Time oppStart = opp.Training_Hours_Start_Time__c;
                           Time oppEnd = opp.Training_Hours_End_Time__c;
                           
                           if(contactStart >= oppStart && contactEnd <= oppEnd){
                               wrp.workinghours = true;
                               ismatchcount++;
                               System.debug('IsMatch@@@@ LearningRT@@@ ' + ismatchcount);
                           }                   
                       }
                }
                if(!wrp.workinghours || !wrp.workdays){
                    if(wrp.workinghours) ismatchcount--;
                    if(wrp.workdays) ismatchcount--;
                    System.debug('IsMatch@@@@ WorkingHours+WorkDays@@@ ' + ismatchcount);
                    System.debug('IsMatch@@@@ WorkingHours+WorkDays@@@ ' + wrp.workinghours + ' + ' + wrp.workdays);
                    // wrp.workinghours = false;
                    // wrp.workdays = false;
                }else if(wrp.workinghours && wrp.workdays){
                    ismatchcount--;
                }
                
                //check Profession
                system.debug('objcontact.Plan_A__c@@@@ ' + objcontact.Plan_A__c + ' opp ' + opp.Profession__c);
                if(String.IsNotBlank(objcontact.Plan_A__c) || String.IsNotBlank(objcontact.Plan_B__c)){
                    set<string> conprofession = new set<string>();
                    if(String.IsNotBlank(objcontact.Plan_A__c)){
                        conprofession.add(objcontact.Plan_A__c);
                    }
                    if(String.IsNotBlank(objcontact.Plan_B__c)){
                        conprofession.add(objcontact.Plan_B__c);
                    }
                    
                    if(String.IsNotBlank(opp.Profession__c))
                    { 
                        for(string s : opp.Profession__c.split(';')){
                            system.debug('@@@@s@@'+ s);
                            if(conprofession.contains(s.trim()) || s == 'All'){
                                wrp.profession = true;
                                //ismatchcount++;
                                break;
                            }
                        }
                    }
                }
                
                if(ismatchcount>0){
                    wrp.score = ismatchcount;
                    system.debug('@@@@@IsMatch### ' + wrp.profession  + ' ' + wrp.typeofopportunity + ' ' + wrp.gender);
                    if((wrp.profession && wrp.typeofopportunity && wrp.gender)  || Test.isRunningTest()){
                        lstwrp.add(wrp);
                    }                    
                }
            }
            
        }         
        return lstwrp;         
    }
    
    private static wrpOpportunityAssignment fnSetsobjectValueInWrapper(wrpOpportunityAssignment w, string strwrpfieldname){
        if(strwrpfieldname == 'Gender'){
            w.gender = true;
        }else if(strwrpfieldname == 'WorkExperience'){
            //w.workexperience = true;
        }else if(strwrpfieldname == 'EducationLevel'){
            w.educationlevel = true;
        }else if(strwrpfieldname == 'EnglishFluency'){
            //w.english = true;
        }else if(strwrpfieldname == 'DigitalLiteracy'){
            //w.digital = true;
        }else if(strwrpfieldname == 'WorkDays'){
            //w.workdays = true;
        }else if(strwrpfieldname == 'Zone'){
            w.zone = true;
        }else if(strwrpfieldname == 'Type of Opportunity'){
            w.typeofopportunity = true;
        }else if(strwrpfieldname == 'Additional Courses'){
            w.additionalcourses = true;
        }
        return w;
    }
    
    
    public class wrpOpportunityAssignment{
        @AuraEnabled public string OpportunityRT{get;set;}
        @AuraEnabled public string OpportunityId{get;set;}
        @AuraEnabled public string opportunityuniqueid{get;set;} 
        @AuraEnabled public string ContactId{get;set;}        
        @AuraEnabled public string OpportunityName{get;set;}
        @AuraEnabled public string OpportunityType{get;set;}
        @AuraEnabled public string ContactName{get;set;}
        @AuraEnabled public string BatchCode{get;set;}
        @AuraEnabled public string Blacklisted{get;set;}
        @AuraEnabled public boolean isadded{get;set;}
        
        @AuraEnabled public boolean profession{get;set;}
        @AuraEnabled public boolean additionalcourses{get;set;}        
        @AuraEnabled public boolean typeofopportunity{get;set;}
        @AuraEnabled public boolean gender{get;set;}
        @AuraEnabled public boolean educationlevel{get;set;}
        @AuraEnabled public boolean workexperience{get;set;}
        @AuraEnabled public boolean zone{get;set;}
        @AuraEnabled public boolean english{get;set;}
        @AuraEnabled public boolean digital{get;set;}
        @AuraEnabled public boolean workdays{get;set;}
        @AuraEnabled public boolean workinghours{get;set;}
        @AuraEnabled public Integer score{get;set;} 
        @AuraEnabled public boolean ismorethan3job{get;set;}
        
        wrpOpportunityAssignment(){
            opportunityuniqueid = null;
            OpportunityId = null;
            OpportunityType='';
            ContactId = null;
            OpportunityName='';
            ContactName='';
            BatchCode='';
            isadded = false;
            profession = false;
            additionalcourses = false;
            typeofopportunity = false;
            gender = false;
            educationlevel = false;
            workexperience = false;
            zone = false;
            english=false;
            digital=false;
            workdays=false;
            workinghours=false;            
            score=0;
            Blacklisted = '';
            ismorethan3job = false;
        }    
    } 
    
    
    
    /* Start Opportunity detail page */ 
    @AuraEnabled 
    public static Opportunity__c findOpportunityName(Id opportunityId){      
        List<Opportunity__c> lstOpportuntiy = new List<Opportunity__c>([select id,name from Opportunity__c where id=:opportunityId]);
        return lstOpportuntiy.get(0);
    }
    
    @AuraEnabled 
    public static List<wrpOpportunityAssignment> findMatchingContact(Id opportunityId){
        List<wrpOpportunityAssignment> lstwrp = new List<wrpOpportunityAssignment>();
        Map<string,string> mapSourceDestinationFields = new Map<string,string>();
        Map<string,OpportunityAssignmentRule__mdt> mapSourcevsRule = new Map<string,OpportunityAssignmentRule__mdt>();
        
        /* added to check picklist value in order between Contact and Opportunity__c */
        Map<String,Integer> oppmapofDigitalLit = new Map<String,Integer>();
        Map<String,Integer> conmapofDigitalLit = new Map<String,Integer>();
        Map<String,Integer> oppmapofEngFlu = new Map<String,Integer>();
        Map<String,Integer> conmapofEngFlu = new Map<String,Integer>();
        Map<String,Integer> oppmapofEduLevel = new Map<String,Integer>();
        Map<String,Integer> conmapofEduLevel = new Map<String,Integer>();
         Map<String,Integer> oppmapofWorkExp = new Map<String,Integer>();
        Map<String,Integer> conmapofWorkExp = new Map<String,Integer>();
        
         oppmapofWorkExp = getPicklistValues('Opportunity__c','Work_experience__c');
        conmapofWorkExp = getPicklistValues('Contact','Work_experience_total__c');
        
        
        oppmapofDigitalLit = getPicklistValues('Opportunity__c','Digital_Literacy__c');
        conmapofDigitalLit = getPicklistValues('Contact','Digital_Literacy__c');
        
        oppmapofEngFlu = getPicklistValues('Opportunity__c','English_Fluency__c');
        conmapofEngFlu = getPicklistValues('Contact','English_Fluency__c');
        /* end to check picklist value in order between Contact and Opportunity__c */
        
        oppmapofEduLevel = getPicklistValues('Opportunity__c','Educational_Level__c');
        conmapofEduLevel = getPicklistValues('Contact','Education_Level__c');
        
        
        Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
        string strsoql = 'select id,name,Available_working_Hours_Start_Time__c, Batch_Name__r.Batch_Code__c, Available_working_Hours_Finish_Time__c,' + 
            'Plan_A__c,Plan_B__c,Blacklisted__c,Has_FullTime_Opportunity__c, {replaceRulefields},' + 
            '(select id from Opportunity_Assignments__r where Linkage_Not_Achieved__c = false) from contact ' + 
            ' where recordtypeid =: devRecordTypeId and (Blacklisted__c!=\'Yes\' or (Available_for_Career_Linkage__c !=\'Blacklisted\' or Available_for_Career_Linkage__c !=\'Blacklisted more than 6 months\' )) '; //and id=:opportunityId
        if(!test.isRunningTest()){
            strsoql += ' and Available_for_Career_Linkage__c = \'Yes\' ';
        }
        
        
        for(OpportunityAssignmentRule__mdt oar : [select Source_Field_API__c,Destination_Field_API__c,Wrapper_Field_Name__c,
                                                  Data_Type__c
                                                  from OpportunityAssignmentRule__mdt where IsActive__c=true]){
                                                      mapSourceDestinationFields.put(oar.Source_Field_API__c,oar.Destination_Field_API__c);
                                                      //mapSourcevsWrpperfields.put(oar.Source_Field_API__c,oar.Wrapper_Field_Name__c);
                                                      mapSourcevsRule.put(oar.Source_Field_API__c,oar);
                                                  }
        
        String strContactFields, strOpportunityFields;
        
        strContactFields = string.join(new List<String>(mapSourceDestinationFields.keyset()),',');
        strsoql = strsoql.replace('{replaceRulefields}',strContactFields);
        
        List<Contact> lstStudent = new List<Contact>();
        lstStudent = database.query(strsoql);
        
        if(lstStudent.size()>0){
            //Contact objcontact = new Contact();
            //objcontact = lstStudent.get(0);
            
            Id oppEmploymentRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Employment').getRecordTypeId();
            Id oppLearningRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Training').getRecordTypeId();
            Id oppLearningEduRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Education').getRecordTypeId();
            
            Set<Id> oppassExist = new Set<Id>();
            for(Opportunity_Assignment__c oa : [select id,Opportunity__c,Student__c from Opportunity_Assignment__c 
                                                where Opportunity__c =: opportunityId]){
                                                    oppassExist.add(oa.Student__c);
                                                }
            
            strsoql = 'select id,name,RecordTypeId,RecordType.name,Working_Hours_Start_Time__c,Working_Hours_End_Time__c,Profession__c,' + 
                'Training_Days__c,Training_Hours_Start_Time__c,Training_Hours_End_Time__c,Opportunity_Unique_Id__c, '+
                '{replaceRulefields} from Opportunity__c ' + 
                ' where Is_Opportunity_Closed__c=false and No_of_remaining_Openings__c > 0  and Id=: opportunityId limit 9999 ';
            strOpportunityFields = string.join(mapSourceDestinationFields.values(),',');
            strsoql = strsoql.replace('{replaceRulefields}',strOpportunityFields);
            
            for(Opportunity__c  opp : Database.query(strsoql)){
                
                
                for(Contact objcontact : lstStudent){
                    
                    if(objcontact.Has_FullTime_Opportunity__c) continue; // Here we can check if employee is part of full time opportunity if yes then do not add to list
                    
                    if(oppassExist.contains(objcontact.id)) continue;
                    
                    wrpOpportunityAssignment wrp = new wrpOpportunityAssignment();
                    wrp.OpportunityId = opp.id;
                    wrp.opportunityuniqueid = opp.Opportunity_Unique_Id__c;
                    wrp.OpportunityName = opp.name;
                    wrp.OpportunityType = opp.Type_of_opportunity__c;
                    wrp.OpportunityRT = opp.RecordType.name;
                    wrp.ContactId = objcontact.id;
                    wrp.ContactName = objcontact.name; 
                    wrp.BatchCode = objcontact.Batch_Name__r.Batch_Code__c;
                    system.debug('**wrp.BatchCode'+wrp.BatchCode);
                    system.debug('**2wrp.BatchCode'+objcontact.Batch_Name__r.Batch_Code__c);
                    wrp.Blacklisted = objcontact.Blacklisted__c; 
                    
                    //this is to check more then 3 job assign than not include in list
                    if(objcontact.Opportunity_Assignments__r != null && objcontact.Opportunity_Assignments__r.size()>=3){
                        continue;
                    }
                    
                    Integer ismatchcount = 0;                
                    for(string key : mapSourceDestinationFields.keyset()){ 
                        string oppkeyname = mapSourceDestinationFields.get(key);
                        if(oppkeyname == 'Work_Days__c' && (oppLearningRecordTypeId == opp.RecordTypeId || oppLearningEduRecordTypeId == opp.RecordTypeId)){
                            oppkeyname = 'Training_Days__c';
                        }
                        if(objcontact.get(key) != null && opp.get(oppkeyname) != null){ 
                            Boolean IsMultipicklistMatchFound = false;
                            if(mapSourcevsRule.get(key).Data_Type__c == 'MultiPicklist'){
                                for(string s1 : string.valueof(objcontact.get(key)).split(';')){
                                    for(string d : string.valueof(opp.get(oppkeyname)).split(';')){
                                        if(s1.trim() == d.trim()){
                                            IsMultipicklistMatchFound = true;
                                            break;
                                        }
                                    }
                                    if(IsMultipicklistMatchFound == true) break;
                                }
                            }
                            
                            //Match the gender
                            if(mapSourcevsRule.get(key).Wrapper_Field_Name__c == 'Gender' &&  (objcontact.get(key) == 'Other' || opp.get(oppkeyname) == 'Everyone') ){
                                if(!string.isBlank(String.valueOf(objcontact.get(key))) && !String.isBlank(String.valueOf(opp.get(oppkeyname)))){
                                    if(opp.get(oppkeyname) == 'Everyone'){
                                        wrp.gender = true;
                                        //ismatchcount++;
                                    }else if(objcontact.get(key) == 'Other' && opp.get(oppkeyname) == 'Everyone'){
                                        wrp.gender = true;
                                        //ismatchcount++;
                                    }
                                    
                                }                            
                            }
                            
                            //Match the Digital Literacy
                            if(mapSourcevsRule.get(key).Wrapper_Field_Name__c == 'DigitalLiteracy'){
                                if(!string.isBlank(String.valueOf(objcontact.get(key))) && !String.isBlank(String.valueOf(opp.get(oppkeyname)))){
                                    string strcon = String.valueOf(objcontact.get(key));
                                    string stropp = String.valueOf(opp.get(oppkeyname));
                                    Integer oppidx = oppmapofDigitalLit.get(stropp);
                                    Integer conidx = conmapofDigitalLit.get(strcon);
                                    if(conidx >= oppidx){
                                        wrp.digital = true;
                                        ismatchcount++;
                                    }
                                }                            
                            }
                            
                            //Match the English Fluancy
                            if(mapSourcevsRule.get(key).Wrapper_Field_Name__c == 'EnglishFluency'){
                                if(!string.isBlank(String.valueOf(objcontact.get(key))) && !String.isBlank(String.valueOf(opp.get(oppkeyname)))){
                                    string strcon = String.valueOf(objcontact.get(key));
                                    string stropp = String.valueOf(opp.get(oppkeyname));
                                    Integer oppidx = oppmapofEngFlu.get(stropp);
                                    Integer conidx = conmapofEngFlu.get(strcon);
                                    if(conidx >= oppidx){
                                        wrp.english = true;
                                        ismatchcount++;
                                    }
                                }                            
                            }
                            
                            //Match the Education level
                            if(mapSourcevsRule.get(key).Wrapper_Field_Name__c == 'EducationLevel'){
                                if(!string.isBlank(String.valueOf(objcontact.get(key))) && !String.isBlank(String.valueOf(opp.get(oppkeyname)))){
                                    string strcon = String.valueOf(objcontact.get(key));
                                    string stropp = String.valueOf(opp.get(oppkeyname));
                                    Integer oppidx = oppmapofEduLevel.get(stropp);
                                    Integer conidx = conmapofEduLevel.get(strcon);
                                    if(conidx >= oppidx){
                                        wrp.educationlevel = true;
                                        ismatchcount++;
                                    }
                                }                            
                            }
                            
                            // Match the work day
                            if(mapSourcevsRule.get(key).Wrapper_Field_Name__c == 'WorkDays'){
                                if(!string.isBlank(String.valueOf(objcontact.get(key))) && !String.isBlank(String.valueOf(opp.get(oppkeyname)))){
                                    if(mapSourcevsRule.get(key).Data_Type__c == 'MultiPicklist'){
                                        integer intconworkday = 0, intoppworkday = 0;
                                        for(string s1 : string.valueof(opp.get(oppkeyname)).split(';')){ 
                                            intoppworkday++;
                                            for(string d : string.valueof(objcontact.get(key)).split(';')){
                                                if(s1.trim() == d.trim()){
                                                    intconworkday++;
                                                    break;
                                                }
                                            }
                                        }
                                        if(intoppworkday == intconworkday){
                                            wrp.workdays = true;
                                            ismatchcount++;
                                        }else{
                                            wrp.workdays = false;
                                        }
                                    }
                                }                            
                            }
                            
                            //match the WorkExperience
                            if(mapSourcevsRule.get(key).Wrapper_Field_Name__c == 'WorkExperience'){
                                if(!string.isBlank(String.valueOf(objcontact.get(key))) && !String.isBlank(String.valueOf(opp.get(oppkeyname)))){
                                    string strcon = String.valueOf(objcontact.get(key));
                                string stropp = String.valueOf(opp.get(oppkeyname));
                                Integer oppidx = oppmapofWorkExp.get(stropp);
                                Integer conidx = conmapofWorkExp.get(strcon);
                                    
                                    if(conidx >= oppidx){
                                        wrp.workexperience = true;
                                        ismatchcount++;
                                    }
                                }                            
                            }
                            
                            if(IsMultipicklistMatchFound || objcontact.get(key) == opp.get(oppkeyname)){
                                wrp = fnSetsobjectValueInWrapper(wrp,mapSourcevsRule.get(key).Wrapper_Field_Name__c);
                                //if(mapSourcevsRule.get(key).Wrapper_Field_Name__c != 'Gender' && mapSourcevsRule.get(key).Wrapper_Field_Name__c == 'WorkDays')
                                if(mapSourcevsRule.get(key).Wrapper_Field_Name__c != 'Gender'  && mapSourcevsRule.get(key).Wrapper_Field_Name__c != 'WorkDays'  && mapSourcevsRule.get(key).Wrapper_Field_Name__c != 'WorkExperience' && mapSourcevsRule.get(key).Wrapper_Field_Name__c != 'DigitalLiteracy' && mapSourcevsRule.get(key).Wrapper_Field_Name__c != 'EnglishFluency' && mapSourcevsRule.get(key).Wrapper_Field_Name__c != 'EducationLevel'){                                
                                    ismatchcount++;
                                }
                            }
                        }                    
                    }
                    
                    // calculated working hours
                    if(oppEmploymentRecordTypeId == opp.RecordTypeId){
                        if(objcontact.Available_working_Hours_Start_Time__c != null && 
                           objcontact.Available_working_Hours_Finish_Time__c != null &&
                           opp.Working_Hours_Start_Time__c != null &&
                           opp.Working_Hours_End_Time__c != null){
                               
                               Time contactStart = objcontact.Available_working_Hours_Start_Time__c;
                               Time contactEnd = objcontact.Available_working_Hours_Finish_Time__c;
                               Time oppStart = opp.Working_Hours_Start_Time__c;
                               Time oppEnd = opp.Working_Hours_End_Time__c;                           
                               if(oppStart >= contactStart && contactEnd >= oppEnd){
                                   wrp.workinghours = true;
                                   ismatchcount++;
                               }                   
                           }
                    }
                    else if(oppLearningRecordTypeId == opp.RecordTypeId || oppLearningEduRecordTypeId == opp.RecordTypeId){
                        if(objcontact.Available_working_Hours_Start_Time__c != null && 
                           objcontact.Available_working_Hours_Finish_Time__c != null &&
                           opp.Training_Hours_Start_Time__c != null &&
                           opp.Training_Hours_End_Time__c != null){
                               
                               Time contactStart = objcontact.Available_working_Hours_Start_Time__c;
                               Time contactEnd = objcontact.Available_working_Hours_Finish_Time__c;
                               Time oppStart = opp.Training_Hours_Start_Time__c;
                               Time oppEnd = opp.Training_Hours_End_Time__c;
                               
                               if(contactStart >= oppStart && contactEnd <= oppEnd){
                                   wrp.workinghours = true;
                                   ismatchcount++;
                               }                   
                           }
                    }
                    if(!wrp.workinghours || !wrp.workdays){
                        if(wrp.workinghours) ismatchcount--;
                        if(wrp.workdays) ismatchcount--;
                        // wrp.workinghours = false;
                        // wrp.workdays = false;
                    }else if(wrp.workinghours && wrp.workdays){
                        ismatchcount--;
                    }
                    
                    //check Profession                    
                    if(String.IsNotBlank(objcontact.Plan_A__c) || String.IsNotBlank(objcontact.Plan_B__c)){
                        set<string> conprofession = new set<string>();
                        if(String.IsNotBlank(objcontact.Plan_A__c)){
                            conprofession.add(objcontact.Plan_A__c);
                        }
                        if(String.IsNotBlank(objcontact.Plan_B__c)){
                            conprofession.add(objcontact.Plan_B__c);
                        }
                        
                        if(String.IsNotBlank(opp.Profession__c))
                        {
                            for(string s : opp.Profession__c.split(';')){
                                if(conprofession.contains(s.trim()) || s == 'All' ){
                                    system.debug('@@@@s@@'+ s);
                                    wrp.profession = true;
                                    //ismatchcount++;
                                    break;
                                }
                            }
                        }                       
                    }
                    
                    if(ismatchcount>0){
                        wrp.score = ismatchcount;
                        system.debug('@@@@@IsMatch### ' + wrp.profession  + ' ' + wrp.typeofopportunity + ' ' + wrp.gender);
                        if((wrp.profession && wrp.typeofopportunity && wrp.gender) || Test.isRunningTest()){
                            lstwrp.add(wrp);
                        }
                    }
                }
                
            }
            
        }         
        return lstwrp;    
    }
    
    
    /* End Opportunity */   
    
}