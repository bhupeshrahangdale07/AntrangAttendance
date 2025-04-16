({
    yesBtn : function(component, event, helper) {
        var currentPopType = component.get("v.popUpType");
        var compEvent = component.getEvent("popUpEvent");

        if(currentPopType == 'AfterLogin' ){
            //Goin To First Page of Transition Tracking Form
            compEvent.setParams({"popType" : currentPopType });
            component.set("v.displayModal", false);
            compEvent.fire();
        }
        else if(currentPopType == 'AfterLogout' ){
            //Going To the Submit Action of Transition Form
            compEvent.setParams({"popType" : currentPopType });
            component.set("v.displayModal", false);
            component.set("v.showFinalPage", true);
            compEvent.fire();
            
        }
    },
	noBtn : function(component, event, helper) {
        var currentPopType = component.get("v.popUpType");

        if(currentPopType == 'AfterLogin' ){
            //Going To Login Page.
            var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": window.location.origin+'/assessment/s/transition-login'
                });
                urlEvent.fire();
                    component.set("v.displayModal", false);
        }
        else if(currentPopType == 'AfterLogout' ){
            //Going To Previous Page
            var compEvent = component.getEvent("popUpEvent");
            compEvent.setParams({"popType" : 'AfterLogin' });
            compEvent.fire();
        }
    },

});