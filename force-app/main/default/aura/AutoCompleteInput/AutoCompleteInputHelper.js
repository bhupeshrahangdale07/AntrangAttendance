({
	searchRecords : function(component, searchString) {
        var action = component.get("c.getRecords");
        action.setParams({
            "searchString" : searchString,
            "objectApiName" : component.get("v.objectApiName"),
            "idFieldApiName" : component.get("v.idFieldApiName"),
            "valueFieldApiName" : component.get("v.valueFieldApiName"),
            "MatchingvalueFieldApiName" : component.get("v.MatchingvalueFieldApiName"),
            "extendedWhereClause" : component.get("v.extendedWhereClause"),
            "maxRecords" : component.get("v.maxRecords"),
            "defaultWhereclause" : component.get("v.defaultWhereclause")
        });
        action.setCallback(this,function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                const serverResult = response.getReturnValue();
                const results = [];
                if(component.get("v.objectApiName") == 'Batch__C' && component.get("v.sessionFormAttedence")){
                    
                    serverResult.forEach(element => {
                        let studentCount;
                        if(element.Contacts__r != undefined){
                        	studentCount = element.Contacts__r.length;
                    	}
                        else{
                            studentCount = 0; 
                                         }
                                         
                     	const result = {id : element[component.get("v.idFieldApiName")], value : element[component.get("v.valueFieldApiName")] +' ('+studentCount+')'};
                	 	results.push(result);
            		});
        		 }
                 else{
                      	serverResult.forEach(element => {
                      	const result = {id : element[component.get("v.idFieldApiName")], value : element[component.get("v.valueFieldApiName")]};
    				  	results.push(result);
                      	});
					}

                component.set("v.results", results);
                if(serverResult.length>0){
                    component.set("v.openDropDown", true);
                }
            } else{
                var toastEvent = $A.get("e.force:showToast");
                if(toastEvent){
                    toastEvent.setParams({
                        "title": "ERROR",
                        "type": "error",
                        "message": "Something went wrong!! Check server logs!!"
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    }
})