({
    initHelper: function(component) {        
        var recordId = component.get("v.recordId");
        var action = component.get("c.findContactName");
        
        action.setParams({
            'studentId': recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var lst = response.getReturnValue();

                var isFullTimeOpportunity = lst["Has_FullTime_Opportunity__c"] == true;
                
                var isblacklisted = lst["Blacklisted__c"] == "Yes";
                component.set('v.contactName', lst["Name"]);
                if(isblacklisted){
                    component.set("v.messageType", 'error' );
                	component.set("v.message", 'Opportunity Assignment not applicable on this contact after they have been Blacklisted.' );
                    
                }else if(isFullTimeOpportunity){
                    component.set("v.messageType", 'error' );
                	component.set("v.message", 'You cannot assign a new Opportunity to this Student since it has an active full time opportunity!.' );
                }else{
                    //component.set('v.contactName', lst["Name"]);
                	this.findOppAssignment(component);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    findOppAssignment: function(component) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.findMatchOpportunity");
        
        action.setParams({
            'studentId': recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var lst = response.getReturnValue();
                if(lst.length > 0){                   
                    lst.sort(function (a, b) {
                      return b.score - a.score;
                    });
                    component.set('v.wrapperList', lst);
                    component.set('v.isListExist', false);
                }else{
                    component.set('v.wrapperList', []);
                    component.set('v.isListExist', true);
                }
            }else if (state === "ERROR") {
                var errors = response.getError();
                var errmsg = '';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errmsg = errors[0].message;
                    }
                } else {
                    errmsg = 'Unknown error';
                }                
                component.set("v.messageType", 'error' );
                component.set("v.message", errmsg );
                
                setTimeout(function(){ 
                    component.set("v.messageType", '' );
                    component.set("v.message", '');                    
                }, 5000);                
            }
        });        
        $A.enqueueAction(action);         
    },
    
    checkMoreThan3JobsByContact: function(component){
        var recordId = component.get("v.recordId");
        var action = component.get("c.checkMoreThan3JobsByContact");
        action.setParams({
            'studentId': recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                var bln =  response.getReturnValue();
                if(!bln){
                    this.saveOppAssignment(component);    
                }else{
                    component.set("v.messageType", 'warning' );
                    component.set("v.message", 'This student reached 3 Job rule limitation. Kindly choose another student.' );
                    
                    setTimeout(function(){ 
                        component.set("v.messageType", '' );
                        component.set("v.message", '');                        
                    }, 5000);
                }                
            }
        });
        $A.enqueueAction(action);        
    },
    
    saveOppAssignment: function(component) {
        var recordId = component.get("v.recordId");
        var lst = component.get("v.wrapperList");
        
        var lstwrp = [];
        lst.forEach(function(e) {
            if(e.isadded){
                lstwrp.push(e);
            }
        });
        
        if(lstwrp.length > 0){
            var action = component.get("c.SaveMatchOpportunity");
            action.setParams({
                'studentId': recordId,
                'lstwrp': JSON.stringify(lstwrp),
                'blnIsStudent': true
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS"){
                    var lst = response.getReturnValue();
                    
                    if(lst.length > 0){
                        lst.sort(function (a, b) {
                          return b.score - a.score;
                        });
                        
                        component.set('v.contactName', lst[0].ContactName);
                        component.set('v.wrapperList', lst);
                        component.set('v.isListExist', false);
                    }else{
                        component.set('v.wrapperList', []);
                        component.set('v.isListExist', true);
                    }
                    
                    component.set("v.messageType", 'success' );
                    component.set("v.message", 'Record(s) has been created for Opportunity Assignment!' );
                    
                }else if (state === "ERROR") {
                    var errors = response.getError();
                    var errmsg = 'Unknown error';
                    if (errors) {
                        if (errors && Array.isArray(errors) && errors.length > 0) {
                            errmsg = errors[0].message ? errors[0].message : errors[0].pageErrors[0].message
                        }
                    }           
                    component.set("v.messageType", 'error' );
                    component.set("v.message", errmsg );
                }
                
                setTimeout(function(){ 
                    component.set("v.messageType", '' );
                    component.set("v.message", '');
                    
                }, 5000);
            });
            
            $A.enqueueAction(action);   
        }else if(lst.length > 0){
            component.set("v.messageType", 'info' );
            component.set("v.message", 'At least one record should be selected to save!' );
        }    
    }
})