({        
    showMessage: function (component, event, message, title, severity) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":severity
        });
        toastEvent.fire();
    },    
    
    handleStartExam : function (component, event, helper) {
        var studentId = component.get("v.ContactId");
        var language = 'English';
        if(component.get("v.SelectedLanguage") != undefined && component.get("v.SelectedLanguage") != null &&
          	component.get("v.SelectedLanguage") != ''){
            language = component.get("v.SelectedLanguage");
        }
        
		var address = window.location.origin+'/assessment/s/transition-form?contactId='+studentId+'&lang='+language;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": address
        });                
        urlEvent.fire();        
    },    
    showHideSpinner : function(component) {
        var showValue = component.get('v.show');
        
        if(showValue) {
            var spinner = component.find("spinner");
        	$A.util.removeClass(spinner, "slds-hide");
        } else {
            var spinner = component.find("spinner");
        	$A.util.addClass(spinner, "slds-hide");
        }
    },

    showspinner: function(component) {
        component.set("v.show",true);        
    },

    hidespinner: function(component) {
        window.setTimeout(
            function() {
                component.set("v.show",false);
            }, 1000
        );        
    }    
})