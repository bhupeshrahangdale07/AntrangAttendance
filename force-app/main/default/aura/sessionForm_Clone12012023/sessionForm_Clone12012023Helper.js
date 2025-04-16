({
    checktraineremail: function (component, event, helper) {
        debugger;
        let email = component.get("v.traineremail");
        let action = component.get("c.checkEmailExist");
        action.setParams({
            stremail: email
        });
        action.setCallback(this, function (response) {
             let state = response.getState();
            if (response.getState() === "SUCCESS") {
                let res = response.getReturnValue(); 
                if (res != undefined && res != null && res.contact.Id != undefined) {
                    component.set("v.gradeList", res.grade);
                    component.set("v.pagenumber", 2);
                    helper.fnGetMappingTable(component, event, helper);
                } else {
                    helper.showMessageToast(
                        component,
                        event,
                        helper,
                        "Matching trainer not found!",
                        "warning"
                    );
                }
            } else if (state === "ERROR") {
                let errors = response.getError();
                let message = ""; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message += errors[0].message;
                }
                helper.showMessageToast(component, event, helper, message, "error");
            }
        });
        $A.enqueueAction(action);
    },
    
    fnGetMappingTable: function (component, event, helper) {
        //debugger;
        let langparam = "eng";
        let objui = {};
        objui.accountQName =
            "Type the first 4 letters of the student's school name, then wait for different school names appear, please select the school name from that list. DO NOT type the whole school name.";
        objui.contactQName =
            "Type the first 2 numbers of the batch code, then wait for different batch codes to appear, please select the batch code from that list. DO NOT type entire batch code.";
        component.set("v.objUI", objui);
        
    },
    
    findSchoolBatch :  function (component, event, helper, selGrade) {
       
        let action = component.get("c.findBatch");
        action.setParams({
            accountId : component.get("v.AccountId"),
            selectedGrade : selGrade
        });
        action.setCallback(this, function (response) {
             let state = response.getState();
            if (state === "SUCCESS") {
                let res = response.getReturnValue();
                component.set("v.batchOptions",res.batchOptions);
                component.set("v.isBatchOption",false);
                
            } else if (state === "ERROR") {
                let errors = response.getError();
                let message = ""; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message += errors[0].message;
                }
                helper.showMessageToast(component, event, helper, message, "error");
            }
        });
        $A.enqueueAction(action);
    },
    
    sessionRecord: function(component, event, helper,BtId){
        //debugger;
        let action = component.get("c.lstsessionRecords");
        action.setParams({
            batchId : BtId,
            loggedInTrainer : component.get("v.traineremail")
        });
        action.setCallback(this, function (response) {
            // let state = response.getState();
            if (response.getState() === "SUCCESS") {
                let res = response.getReturnValue();
                if (res != undefined && res != null && res.length > 0) {
                    helper.doProcessRecord(component, event, helper,res);
                    
        } else {
                           helper.showMessageToast(
                           component,
                           event,
                           helper,
                           "No Session records found for selected batch!",
                           "warning"
                          );
    			}
			} else if (state === "ERROR") {
    			let errors = response.getError();
    			let message = ""; // Default error message
    				if (errors && Array.isArray(errors) && errors.length > 0) {
        				message += errors[0].message;
    				}
    				helper.showMessageToast(component, event, helper, message, "error");
				}
		});
		$A.enqueueAction(action);        
		},
    
    saveRecord: function(component, event, helper,sessionLST){
        let btId = component.get("v.selectedBatchId");

		var action = component.get("c.saveSessions");
			action.setParams({
    		'data': JSON.stringify(sessionLST),
                'batchId' : btId,
                loggedInTrainer : component.get("v.traineremail")
			});
			action.setCallback(this, function(response) {
    	var state = response.getState();
    		if (state === "SUCCESS") {
        	var res = response.getReturnValue();
                if (res != undefined && res != null && res.length > 0) {
                    helper.doProcessRecord(component, event, helper,res);
                    helper.showMessageToast(component, event, helper, "Record Updated Success!", "success");
                    component.set("v.showSaveCancelBtn",false);
                }        	
    	}
        else if (state === "ERROR") {
    			let errors = response.getError();
    			let message = ""; // Default error message
    				if (errors && Array.isArray(errors) && errors.length > 0) {
        				message += errors[0].message;
    				}
    				helper.showMessageToast(component, event, helper, message, "error");
				}
		});
		$A.enqueueAction(action);
	},
        
        doProcessRecord: function(component, event, helper,res){
            let sessionres = [];
                    res.forEach(s => {
                       // if(s.Session_date__c != undefined){
                       // let sdt = new Date(s.Session_date__c);
                       // s.Session_date__c = sdt.toISOString().substring(0, 10);
                    //}
                    //debugger;
                        if(s.startTime != null){
                        let stTime =  new Date(s.startTime);
                        s.startTime = stTime.toISOString().substr(11, 12);
                    }
                                if(s.endTime != null){
                        let edTime =  new Date(s.endTime);
                        s.endTime = edTime.toISOString().substr(11, 12);
                    }
                    sessionres.push(s);
                });
                component.set("v.sessionRecords",res);
                
                /*let sessionLST = [{'label' : 'All', 'value' : 'ALL'}];
                res.forEach(s => {
                    sessionLST.push({'label' : s.name, 'value' : s.id});
            } );
            component.set("v.sessionSelectRec",sessionLST);
            component.set("v.isBatchSelected",false);*/
if(res){
    //debugger;
    let isSessionDateExist = false;
    for(let i = 0 ; i< res.length ; i++){
        if(res[i]["sessionDate"] != null){
            res[i]["isSessionDate"] = true;
            isSessionDateExist = true;
        }
        else{
            res[i]["isSessionDate"] = false;
            if(isSessionDateExist == true){
                res[i]["isSessionDate"] = true
            }            
            isSessionDateExist = false;
        }
    }
}
            //component.set("v.sessioneditRecTemp",res);
 			component.set("v.sessioneditRec",res);
            component.set("v.sessionfound",true);
            
        },
    
    showMessageToast: function (component, event, helper, strmessage, strtype) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: strmessage,
            type: strtype,
            duration: 1000
        });
        toastEvent.fire();
    },
        
        
})