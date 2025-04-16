public class testGoogleUI {
/*
        
    public static map<string,contact> conPhoneMap;
    public static list<map<string,string>> templst;
    public static list<Flow_executed__c> feLstToInsert;
    public static list<flow__c> flowLst;
    public static map<string,list<map<string,string>>> flowgroupByMap;
    public static map<string,Flow__c> flowMap;
    public static map<string,id> flowExecuteMap;
    public static list<Flow_Session__c> fclst;
    public static map<string,list<map<string,string>>> CreateFlowExcutedMap;
    public static map<string,string> CreateFlowStudentIdMap;

    //@future(callout=true)
    public static void runBigQuerySql(String sql){
        datetime dt = date.today().adddays(-1);
        string  dtstr = dt.format('yyyy-MM-dd');
        //sql  = 'select * from [917208473080.flow_results] WHERE DATE(inserted_at) = DATE(timestamp(\''+dtstr+'\')) limit 5'; 
        String projectId = 'whats-next-v1';
        system.debug('sql :: '+sql);
        GoogleBigQuery google = new GoogleBigQuery(projectId);
        GoogleBigQuery.JobsQuery query = new GoogleBigQuery.JobsQuery();
        query.query = sql;
        if (!google.query(query)) {
            system.debug('ttt : '+ google.getResponse());
            //throw new AuraHandledException('Error when Querying: ' + google.getResponse());
        } 
        
        system.debug('google.getResponse() :'+google.getResponse());
        Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(google.getResponse());
        Map<String, Object> myMaps = (Map<String, Object>) meta.get('schema');
        list<Object> objelst = (list<Object>) meta.get('rows');
        
        list<Object> fieldsMap = (list<Object>) myMaps.get('fields');
        list<fieldWrap> fieldLSt = new list<fieldWrap>();
        for(object o1 : fieldsMap){
            map<string,object> tyCastMap = (map<string,object>)o1;
            fieldWrap fw = new fieldWrap();
            fw.label = string.valueOf(tyCastMap.get('name'));
            fw.fieldName = string.valueOf(tyCastMap.get('name'));
            fw.type = 'text';
            fieldLSt.add(fw);
        }
        
        list<map<string,string>> finalLSt = new list<map<string,string>>();
        for(object ol : objelst){
            map<string,string>  tpMAp = new map<string,string>();
            map<string,object> tyCastMap = (map<string,object>)ol;
            integer i=0;
            for(fieldWrap f : fieldLSt){
                fieldWrap fw = f;
                list<object> oliLSt = (list<object>)tyCastMap.get('f');
                map<string,object> tempmap = (map<string,object>)oliLSt[i];
                tpMAp.put(fw.fieldName, string.valueOf(tempmap.get('v')));
                i++;
            }
            finalLSt.add(tpMAp);
        }
        
        feLstToInsert = new list<Flow_executed__c>();
        flowLst  = new list<flow__c>(); 
        flowExecuteMap = new map<string,id>() ;
        conPhoneMap = new map<string,contact>();
        //map<string,contact> conPhoneNameMap = new map<string,contact>();
        for(contact c : [select id,phone,FirstName,LastName,(select id from Flows_executed__r) from contact]){
            conPhoneMap.put(c.phone, c);
            
            if(c.Flows_executed__r.size() > 0)
            flowExecuteMap.put(c.phone,c.Flows_executed__r.get(0).Id);
        }
        
       // System.debug('#### : '+conPhoneNameMap);
        flowMap = new map<string,Flow__c>();
        
        for(Flow__c f : [select id,Name from Flow__c]){
            flowMap.put(f.Name.toLowerCase().replaceAll( '\\s+', ''), f);
            
        }
        //system.debug('flowMap :: '+flowMap);
        flowgroupByMap = new map<string,list<map<string,string>>>();
        list<contact> conToInsertLst = new list<contact>();
         CreateFlowStudentIdMap = new map<string,string>();
        list<map<string,string>> processafterConInsert = new list<map<string,string>>();
        String regex = '[\\ud83c\\udc00-\\ud83c\\udfff]|[\\ud83d\\udc00-\\ud83d\\udfff]|[\\u2600-\\u27ff]';
        map<string,string> NewContactTempCheckMap = new map<string,string>();
        fclst = new list<Flow_Session__c>();
            CreateFlowExcutedMap = new map<string,list<map<string,string>>> ();
        for(map<string,string> ow :finalLSt){
            system.debug('ow :: '+ow);
            templst = new list<map<string,string>>();
            
            //system.debug('$$$$ : '+(string.valueof(string.valueof(ow.get('contact_phone'))+'_'+string.valueof(ow.get('contact_name')).substring(0,3)).tolowercase()));
            if((conPhoneMap.containskey(String.valueof(ow.get('contact_phone'))))){
            //if(conPhoneNameMap.containskey(string.valueof(string.valueof(ow.get('contact_phone'))+'_'+string.valueof(ow.get('contact_name')).substring(0,3)).tolowercase())){
                processRecords(ow);
            
            }
            else{
                if(!NewContactTempCheckMap.containskey(string.valueof(ow.get('contact_name')).toLowerCase().replaceAll( '\\s+', ''))){
                    contact c = new contact();
                    system.debug('CC :: '+string.valueof(ow.get('contact_name')).replaceAll(regex,'').substringAfterLast(' '));
                    c.Lastname = string.valueof(ow.get('contact_name')).replaceAll(regex,'').substringAfterLast(' ') != '' ? 
                        string.valueof(ow.get('contact_name')).replaceAll(regex,'').substringAfterLast(' ') : 
                    string.valueof(ow.get('contact_name'));
                    c.FirstName = string.valueof(ow.get('contact_name')).replaceAll(regex,'').isAlpha() ? 
                        ' ' :
                    string.valueof(ow.get('contact_name')).replaceAll(regex,'').substringBeforeLast(' ');
                    c.Phone = String.valueof(ow.get('contact_phone'));
                    Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
                    system.debug('con :: '+c);
                    conToInsertLst.add(c);
                    processafterConInsert.add(ow);
                    NewContactTempCheckMap.put(string.valueof(ow.get('contact_name')).toLowerCase().replaceAll( '\\s+', ''),'');
                }
                   else{
                       processafterConInsert.add(ow);
                   }
                
            } 
            
       }
        
        
        if(conToInsertLst.size()>0){
            try{
                insert conToInsertLst;
                for(contact c : [select id,phone,FirstName,LastName,(select id from Flows_executed__r) from contact]){
                    conPhoneMap.put(c.phone, c);
                    
                    if(c.Flows_executed__r.size() > 0)
                        flowExecuteMap.put(c.phone,c.Flows_executed__r.get(0).Id);
                }
                
                for(map<string,string> owaf :processafterConInsert){
                    processRecords(owaf);
                }
            }
            catch(exception e){
                system.debug('Exception '+e);
            }
            
            
        }
        system.debug('CreateFlowExcutedMap : '+CreateFlowExcutedMap);
        for(Id f : CreateFlowExcutedMap.keyset()){
            Flow_executed__c fe = new Flow_executed__c();
            fe.Flow__c = f;
            fe.Result__c = JSON.serialize(CreateFlowExcutedMap.get(f));
            fe.Student__c = CreateFlowStudentIdMap.get(f);
            feLstToInsert.add(fe);
        }

            
        
        for(string fg : flowgroupByMap.keyset()){
            flow__c fw = new flow__c();
            fw.Name = fg;
            fw.response__c = JSON.serialize(flowgroupByMap.get(fg));
            flowLst.add(fw);
            system.debug('flowLst :'+flowLst);
        }
        insert flowLst;
        //  system.debug('flowLst :: '+flowLst);
        //
        system.debug('feLstToInsert :: '+feLstToInsert);  
        if(feLstToInsert.size()>0)
           insert feLstToInsert;
        
         if(fclst.size()>0) insert fclst;
        
    }
    
    public static void processRecords(map<string,string> ow){
        
        if(flowMap.containskey(ow.get('name').toLowerCase().replaceAll( '\\s+', ''))){
            
            
            if(flowExecuteMap.containsKey(String.valueof(ow.get('contact_phone')))){
                system.debug('HI');
                Flow_Session__c fs = new Flow_Session__c();
                //fs.Flow_executed__c = flowMap.get(ow.get('name').toLowerCase().replaceAll( '\\s+', '')).Id;
                fs.Name = string.valueOf(ow.get('name'));
                fs.UUID__c = string.valueOf(ow.get('uuid'));
                fs.Inserted_at__c = Datetime.valueOf(String.valueOf((ow.get('inserted_at'))).replace('T',' '));
                fs.Updated_at__c = Datetime.valueOf(String.valueOf((ow.get('updated_at'))).replace('T',' '));
                fs.Result__c = ConverJson.convert(JSON.serialize((ow.get('results'))));
                fs.Flow_version__c = string.valueOf(ow.get('flow_version'));
                /*fs.Category__c =string.valueOf(mymap.get('category'));
				fs.Input__c =string.valueOf(mymap.get('input'));*/
       /*         fs.Flow_executed__c = flowExecuteMap.get(String.valueof(ow.get('contact_phone')));
                fclst.add(fs);
            }
            
            else{
                system.debug('HHHH');
                //conPhoneMap.containskey(String.valueof(ow.get('contact_phone')))
                CreateFlowStudentIdMap.put(flowMap.get(ow.get('name').toLowerCase().replaceAll( '\\s+', '')).Id, conPhoneMap.get(String.valueof(ow.get('contact_phone'))).Id);
                if(!CreateFlowExcutedMap.containsKey(flowMap.get(ow.get('name').toLowerCase().replaceAll( '\\s+', '')).Id))
                    CreateFlowExcutedMap.put(flowMap.get(ow.get('name').toLowerCase().replaceAll( '\\s+', '')).Id, new list<map<string,string>>());
                CreateFlowExcutedMap.get(flowMap.get(ow.get('name').toLowerCase().replaceAll( '\\s+', '')).Id).add(ow);
                system.debug('CreateFlowExcutedMap :: '+CreateFlowExcutedMap);
            }
            
        }
        else{
            if(!flowgroupByMap.containsKey(ow.get('name')))
                flowgroupByMap.put(ow.get('name'), new list<map<string,string>>());
            flowgroupByMap.get(ow.get('name')).add(ow);
            system.debug('flowgroupByMap :: '+flowgroupByMap);
        }
        
    }
    
    
    public class fieldWrap{
        public string label;
        public string fieldName;
        public string type;
    }
    
    */
}