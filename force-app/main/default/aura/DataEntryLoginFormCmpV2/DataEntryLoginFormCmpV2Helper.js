({
    checkemailhandler : function (component, event, helper) {

        let strUsername = component.get("v.trainerUsername").trim();
        let strLanguage = component.get("v.formLanguage");
        let validExpense = true;
        if (strUsername == undefined || strUsername == null || strUsername == "") {
            validExpense = false;
            helper.showMessageToast(
                component,
                event,
                helper,
                "Enter facilitator's email address or phone number!",
                "error"
            );
        }else if (strLanguage == undefined || strLanguage == null || strLanguage == "") {
            validExpense = false;
            helper.showMessageToast(
                component,
                event,
                helper,
                "Select Language",
                "error"
            );
        }else if(strUsername != undefined || strUsername != null || strUsername != ""){
        	var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
            var phonePattern = /^[0-9]{10}$/; // Assumes a 10-digit phone number format
            if (emailPattern.test(strUsername)) {
            	validExpense = true;
                console.log("Entered username is an email")
            }else if(phonePattern.test(strUsername)){
                validExpense = true;
                console.log("Entered username is an phone")
            }else{
                validExpense = false;
                helper.showMessageToast(
                    component,
                    event,
                    helper,
                    "Invalid email or phone number",
                    "error"
                );
            }
        }
        console.log('validExpense = ',validExpense)
        if (validExpense) {
            console.log('enter');
            helper.checktraineremail(component, event, helper);
        }
    },
    getNextAcademicYearFunc: function (component, event, helper) {
        try {
        let action = component.get("c.getAntarangNextAcadamicYear");
        action.setParams({}); // Fix the curly braces
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") { // Use the 'state' variable instead of 'response.getState()'
                let res = response.getReturnValue();
                console.log('getNextAcademicYear res = ',res)
                component.set("v.nxtAcademicYear",res);
            } else {
                console.error('Error occurred: ', state);
            }
        });
        $A.enqueueAction(action);
        }catch(e){
           console.error('An error occurred: ', e); 
        }
    },
    checktraineremail: function (component, event, helper) {
        let email = component.get("v.trainerUsername");
        let strLanguage = component.get("v.formLanguage");
        let action = component.get("c.checkEmailExist");
        action.setParams({
            stremail: email,
            typ: 'Form V2'
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (response.getState() === "SUCCESS") {
                let res = response.getReturnValue(); 
                console.log('res =',res)
                if (res != undefined && res != null && res.contact.Id != undefined) {
                    console.log(res.contact.Academic_Year__c);
                    console.log(component.get("v.nxtAcademicYear"));
                    if(/*res.contact.Academic_Year__c ===  component.get("v.nxtAcademicYear") && */res.contact.Facilitator_Work_Status__c === 'Active'){
                       this.createCookie('AntarangLoginV2', email, 1);
                       this.goToNewPage(email,strLanguage); 
                    }else{
                        helper.showMessageToast(
                        component,
                        event,
                        helper,
                        "This facilitator is not active. If you think this is a mistake, fill up the support form and someone from the team will get back to you.",
                        "warning"
                    );
                    }
                } else {
                    helper.showMessageToast(
                        component,
                        event,
                        helper,
                        "Please check the email address or phone number provided. If you think this is a mistake, fill up the support form and someone from the team will get back to you.",
                        "warning"
                    );
                }
            } else if (state === "ERROR") {
                console.log('error');
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

        }
        document.cookie = name + "=" + value + expires + "; path=/";
    },
    goToNewPage: function(emailStr,strLanguage) {
        console.log(emailStr);
        var email = 'test@test.com';
        console.log(email);
        //var urlStr = "/dataentrydetailpagev2?fem="+component.get('v.trainerUsername')+"&lng=&typ=v2";
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
                            "url": '/dataentrydetailpagev2?typ=v2&fem='+emailStr+'&lng='+strLanguage

        });
    
        urlEvent.fire();
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