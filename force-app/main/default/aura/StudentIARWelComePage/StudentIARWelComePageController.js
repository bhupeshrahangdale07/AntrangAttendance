({
    doInit : function(component, event, helper) {
        var currPage = '';
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        if(sPageURL.length > 0){
            sPageURL.split("&").forEach(function(part) {
                var param = part.split("=");
                if (param[0] == "contactId") {
                    component.set("v.contactId",param[1]);
                }
                if(param[0] == "len"){
                    component.set("v.language",param[1]);
                }
                if(param[0] == "req"){
                    var req = '';
                    if(param[1] == 'I'){
                        currPage = 'I';
                        req = 'interest';
                    }
                    if(param[1] == 'A'){
                        currPage = 'A';
                        req = 'aptitude';
                    }
                    if(param[1] == 'R'){
                        currPage = 'R';
                        req = 'reality';
                    }
                    component.set("v.reqpage",req);
                }
                component.set("v.currPage", currPage);
            });
        }
        
        if(component.get("v.contactId") != ''){
            let action = component.get("c.verifyStudentSubmittedExam");
            action.setParams({
                contactId : component.get("v.contactId"),
                currPage : currPage
            });
            action.setCallback(this, function(response){
                let state = response.getState();
                if(state === "SUCCESS"){
                    let result = response.getReturnValue();
                    component.set("v.whatsupnumber",result.whatsupnumber);
                    component.set("v.isStdSubmittedExam",result.isStdSubmittedExam);
                    component.set("v.isModalOpen",true);
                    /*if(result.isStdSubmittedExam){
                        var address = window.location.origin+'/iar/s/result?contactId='+component.get("v.contactId")+'&req='+currPage+'&len='+component.get("v.language");
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": address
                        });                
                        urlEvent.fire();
                    }*/
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
                helper.hidespinner(component);
            });
            $A.enqueueAction(action);   
        }
    },
    
    startTest : function(component, event, helper) {
        var studentId = component.get("v.contactId");
        var address = window.location.origin+'/iar/s/'+component.get("v.reqpage")+'?contactId='+studentId+'&len='+component.get('v.language');
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": address
        });                
        urlEvent.fire();
    },
    
    closeModel : function(component, event, helper) {
        if(component.get("v.isStdSubmittedExam")){
            var address = window.location.origin+'/iar/s/result?contactId='+component.get("v.contactId")+'&req='+component.get("v.currPage")+'&len='+component.get("v.language");
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": address
            });                
            urlEvent.fire();
        } else {
            component.set("v.isModalOpen",false);   
        }
    },
    
    submitDetails : function(component, event, helper) {
        if(component.get("v.whatsupnumber") != '' && component.get("v.whatsupnumber") != undefined){
            if(component.get("v.whatsupnumber").length == 10){
                
                let action = component.get("c.saveWhatsappnum");
                action.setParams({
                    conId : component.get("v.contactId"),
                    whatsappnumber : component.get("v.whatsupnumber")
                });
                action.setCallback(this, function(response){
                    let state = response.getState();
                    if(state === "SUCCESS"){
                        if(component.get("v.isStdSubmittedExam")){
                            var address = window.location.origin+'/iar/s/result?contactId='+component.get("v.contactId")+'&req='+component.get("v.currPage")+'&len='+component.get("v.language");
                            var urlEvent = $A.get("e.force:navigateToURL");
                            urlEvent.setParams({
                                "url": address
                            });                
                            urlEvent.fire();
                        } else {
                            component.set("v.isModalOpen",false);
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
                    helper.hidespinner(component);
                });
                $A.enqueueAction(action); 
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error Message',
                    message: 'Whatsapp number length should be 10.',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error Message',
                message: 'Whatsapp number is required.',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
        }
    }
})