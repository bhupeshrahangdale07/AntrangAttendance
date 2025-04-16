({
    checkemailhandler : function (component, event, helper) {

        let stremail = component.get("v.traineremail");
        let validExpense = true;
        if (stremail == undefined || stremail == null || stremail == "") {
            validExpense = false;
            helper.showMessageToast(
                component,
                event,
                helper,
                "Enter facilitator's email address!",
                "error"
            );
        }
        if (validExpense) {
            helper.checktraineremail(component, event, helper);
        }
    },
    checktraineremail: function (component, event, helper) {
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
                    this.createCookie('AntarangLogin', email, 1);
                    var navService = component.find("navService");
                    var pageReference = {
                                        type: 'comm__namedPage',
                                        attributes: {
                                                        name: 'DataEntryDetailPage__c'
                                                    }, 
                                        state: {
                                                    fem: component.get('v.traineremail')
                                                }
                    };
                
                    navService.navigate(pageReference);
                } else {
                    helper.showMessageToast(
                        component,
                        event,
                        helper,
                        "Please check the email address provided. If you think this is a mistake, fill up the support form and someone from the team will get back to you.",
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
    createCookie: function(name, value, days){
        var expires;
        if (days) {
            const date = new Date();
            date.setTime(date.getTime() + (1 * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toGMTString();
        } else {
            expires = "";
        }
        document.cookie = name + "=" + value + expires + "; path=/";
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