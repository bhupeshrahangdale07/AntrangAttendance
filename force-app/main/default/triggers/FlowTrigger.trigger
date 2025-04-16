trigger FlowTrigger on Flow__c (after insert) {
    
    map<string,contact> conlst = new map<string,contact>();
    map<string,contact> conPhoneNameMap = new map<string,contact>();
    map<string,id> flowExecuteMap = new map<string,id>();
    map<string,list<map<string,object>>> CreateFlowExcutedMap = new map<string,list<map<string,object>>>();
    map<string,string> CreateFlowStudentIdMap = new Map<string,string>(); 
    
    for(contact c : [select id,phone,FirstName,LastName,(select id from Flows_executed__r) from contact]){
        conPhoneNameMap.put(c.phone, c);
        
        if(c.Flows_executed__r.size() > 0)
            flowExecuteMap.put(c.phone,c.Flows_executed__r.get(0).Id);
    }
    
    list<Flow_executed__c> feLst = new list<Flow_executed__c>();
    for(flow__c f : trigger.new){
        if(f.response__c != null){
            list<object> objlst = (list<object>)JSON.deserializeUntyped(f.response__c);
            
            for(object o : objlst){
                map<string,object> mymap = (map<string,object>)o;
                
                CreateFlowStudentIdMap.put(f.Id, conPhoneNameMap.get(String.valueof(mymap.get('contact_phone'))).Id);
                if(!CreateFlowExcutedMap.containsKey(f.Id))
                    CreateFlowExcutedMap.put(f.Id, new list<map<string,object>>());
                CreateFlowExcutedMap.get(f.Id).add(mymap);
                system.debug('CreateFlowExcutedMap :: '+CreateFlowExcutedMap);
                } 
        }
    }
    
    for(Id f : CreateFlowExcutedMap.keyset()){
            Flow_executed__c fe = new Flow_executed__c();
            fe.Flow__c = f;
            fe.Result__c = JSON.serialize(CreateFlowExcutedMap.get(f));
            fe.Student__c = CreateFlowStudentIdMap.get(f);
            felst.add(fe);
        }
    
    insert felst;
    
}