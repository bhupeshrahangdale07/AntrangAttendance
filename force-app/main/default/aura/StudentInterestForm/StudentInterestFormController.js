({
	doInit : function(component, event, helper) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        if(sPageURL.length > 0){
            sPageURL.split("&").forEach(function(part) {
                var param = part.split("=");
                if (param[0] == "contactId") {
                    component.set("v.contactId",param[1]);
                } if(param[0] == "len"){
                    component.set("v.language",param[1]);
                }
            });
        }
        if(component.get("v.contactId") != undefined && component.get("v.contactId") != null &&
           	component.get("v.contactId") != ''){
			helper.retrieveStudentData(component, event, helper);
        }
        //helper.retrieveStudentData(component, event, helper);   
	},
    handleNext: function (component, event, helper) {
        helper.saveOnNext(component, event, helper, 'next');
    },
    handlePrevious: function (component, event, helper) {
        helper.goPrevious(component, event);
    },
    handleSubmit: function (component, event, helper) {
        component.set('v.firstClick',true);
    	helper.saveOnNext(component, event, helper, 'submit');
    },
    spinnerDisplayHandler: function(component, event, helper) {        
        helper.showHideSpinner(component); 
    },
    hideConfirmation: function (component, event, helper) {
        component.set("v.submitConfirmation",false);
    },
    handleSubmitConfirmation: function (component, event, helper) {
        component.set("v.submitConfirmation",true);
    }
})