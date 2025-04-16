({
    doInit : function(component, event, helper) {
        component.set("v.show",true);
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        if(sPageURL.length > 0){
            sPageURL.split("&").forEach(function(part) {
                var param = part.split("=");
                if (param[0] == "contactId") {
                    component.set("v.contactId",param[1]);
                }
                if(param[0] == "req"){
                    component.set("v.reqpage",param[1]);
                }
                if(param[0] == "len"){
                    component.set("v.language",param[1]);
                }
            });
        }
        if(component.get("v.contactId") != ''){
            helper.showspinner(component);
            let action = component.get("c.studentResult");
            action.setParams({
                conId : component.get("v.contactId"),
                currPage : component.get("v.reqpage"),
                language: component.get("v.language")
            });
            action.setCallback(this, function(response){
                let state = response.getState();
                if(state === "SUCCESS"){
                    
                    let result = response.getReturnValue();
                    
                    if(component.get("v.reqpage") == 'I' || component.get("v.reqpage") == 'A'){
                        component.set("v.result",result.result);
                        component.set("v.matchingCareers",result.careerInterest);   
                    } else if(component.get("v.reqpage") == 'R'){
                        component.set("v.matchingCareers",result.careerInterest);
                        var custs = [];
                        var conts = result.result;
                        for(var key in conts){
                            custs.push({value:conts[key], key:key});
                        }
                        component.set("v.mapAllRealities", custs);
                        
                        //component.set("v.mapAllRealities",result.result);
                        //alert(JSON.stringify(result.result));
                    }
                }else if (state === "ERROR") {
                    let errors = response.getError();
                    let errmsg = "";
                    if (errors.length > 0 && errors[0] && errors[0].message){
                        // To show other type of exceptions
                        errmsg += errors[0].message;
                    }
                    if (errors.length > 0 && errors[0] && errors[0].pageErrors){
                        // To show DML exceptions
                        errmsg += errors[0].pageErrors[0].message;
                    }
                    helper.showMessage(component, event, errmsg, "Error!", "error");
                }
                component.set("v.show",false);
            });
            $A.enqueueAction(action);   
        }
        
    },
    
    spinnerDisplayHandler: function(component, event, helper) {        
        helper.showHideSpinner(component); 
    },
    
    redirecttowhatsapp: function(component, event, helper) { 
        if(component.get("v.reqpage") == 'A'){
            window.open('https://api.whatsapp.com/send?phone=917208473080&text=aptitude', '_blank');
        }
        if(component.get("v.reqpage") == 'I'){
         	window.open('https://api.whatsapp.com/send?phone=917208473080&text=interest', '_blank');   
        }
        if(component.get("v.reqpage") == 'R'){
         	window.open('https://api.whatsapp.com/send?phone=917208473080&text=reality', '_blank');   
        }
    }
})