({
    checkemailhandler : function (component, event, helper) {

        let stremail = component.get("v.traineremail");
        let strPassword = component.get("v.trainerPassword");
        let validExpense = true;
        if (stremail == undefined || stremail == null || stremail == "" || strPassword == undefined || strPassword == null || strPassword == "") {
            validExpense = false;
            helper.showMessageToast(
                component,
                event,
                helper,
                "Enter valid email id and valid password",
                "error"
            );
        }
        if (validExpense) {
            helper.checktraineremail(component, event, helper);
        }
    },
    createCookie: function(name, value, days){
        var expires;
        if (days) {
            const date = new Date();
            date.setTime(date.getTime() + (6* 1000));
            expires = "; expires=" + date.toGMTString();
        } else {
            expires = "";
        }
        document.cookie = name + "=" + value + expires + "; path=/";
    },
    checktraineremail: function (component, event, helper) {
        let email = component.get("v.traineremail");
        let password = component.get("v.trainerPassword");
        let action = component.get("c.checkEmailExist");
        action.setParams({
            stremail: email,
            strPassword : password
        });
        action.setCallback(this, function (response) {
             let state = response.getState();
            if (response.getState() === "SUCCESS") {
                let res = response.getReturnValue();
                console.log('res = ',res);
                if (res && res.isValid == true) {
                    /*var navService = component.find("navService");
                    var pageReference = {
                        type: 'comm__namedPage',
                        attributes: {
                            name: 'FacilitatorSalaryPayment__c'
                        }, 
                        state: {
                            fem: component.get('v.traineremail'),
                            UserType: res.UserType
                        }
                    };
                    
                    navService.navigate(pageReference);
                    */
                    var pageName = 'payment_type__c';
                     /* var pageName = 'LoginPage__c';
                  if(res.UserType && res.UserType == 'Admin'){
                        pageName = 'GenrateInvoiceForm__c';
                    }else if(res.UserType && res.UserType == 'Supervisor'){
                        pageName = 'Approve_Payout__c';
                    }else if(res.UserType && res.UserType == 'Finance'){
                        pageName = 'Generate_payout_file_for_Finance__c';
                    }*/
                    this.createCookie('AntarangPaymentLogin', email, 1);
                    this.navigateTo(component, pageName , res.UserType);
                } else {
                    if(res.error && res.error != ''){
                        console.log('res.error =',res.error);
                        var msg = res.error == 'Invalid Password' ? 'password' : (res.error == 'Invalid UserName' ? 'email address' : 'email address and password');
                        /*helper.showMessageToast(
                            component,
                            event,
                            helper,
                            "Please check the "+ msg +" provided. If you think this is a mistake, fill up the support form and someone from the team will get back to you.",
                            "warning"
                        );*/
                        helper.showMessageToast(
                            component,
                            event,
                            helper,
                            "Please check the "+ msg +" provided.",
                            "warning"
                        );
                    }
                    
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
    /*createCookie: function(name, value, days){
        var expires;
        if (days) {
            const date = new Date();
            date.setTime(date.getTime() + (1 * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toGMTString();
        } else {
            expires = "";
        }
        document.cookie = name + "=" + value + expires + "; path=/";
    },*/
    showMessageToast: function (component, event, helper, strmessage, strtype) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: strmessage,
            type: strtype,
            duration: 1000
        });
        toastEvent.fire();
    },
    
    navigateTo: function (component, pageName, userType) {
        var navService = component.find("navService");
        var pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: pageName//'FacilitatorSalaryPayment__c'
            }, 
            state: {
                fem: component.get('v.traineremail'),
                 UserType: userType
            }
        };
        navService.navigate(pageReference);
    }
})