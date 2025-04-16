trigger FlowExecute on Flow_executed__c (after insert) {   
    list<Flow_Session__c> fclst = new list<Flow_Session__c>();
    for(Flow_executed__c f : trigger.new){
        if(f.result__c != null){
            
            list<object> objlst = (list<object>)JSON.deserializeUntyped(f.result__c);
            
            for(object o : objlst){
                map<string,object> mymap = (map<string,object>)o;
                Flow_Session__c fs = new Flow_Session__c();
                fs.Flow_executed__c = f.Id;
                fs.Name = string.valueOf(mymap.get('name'));
                fs.UUID__c = string.valueOf(mymap.get('uuid'));
                fs.Inserted_at__c = Datetime.valueOf(String.valueOf((mymap.get('inserted_at'))).replace('T',' '));
                fs.Updated_at__c = Datetime.valueOf(String.valueOf((mymap.get('updated_at'))).replace('T',' '));
                fs.Result__c = ConverJson.convert(JSON.serialize((mymap.get('results'))));
                fs.Flow_version__c = string.valueOf(mymap.get('flow_version'));
                /*fs.Category__c =string.valueOf(mymap.get('category'));
                fs.Input__c =string.valueOf(mymap.get('input'));*/
                fs.Flow_executed__c = f.Id;
                fclst.add(fs);
            }       
        }
    }
    
      if(fclst.size()>0) insert fclst;
}