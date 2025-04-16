({
    doInit : function(component, event, helper) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        if(sPageURL.length > 0){
            sPageURL.split("&").forEach(function(part) {
                var param = part.split("=");
                if (param[0] == "contactId") {
                    component.set("v.contactId",param[1]);
                }
                if(param[0] == "len") {
                    component.set("v.language",param[1]);
                }
            });
        }
        
        
    },
    handleNext: function (component, event, helper) {
        helper.saveOnNext(component, event, helper, 'next','n');
    },
    handlePrevious: function (component, event, helper) {
        helper.goPrevious(component, event);
    },
    handleParentTimerEvt: function (component, event, helper) {
        if(parseInt(component.get("v.endPage")) == 53)
        {
            component.set("v.submitConfirmation",true);
            //helper.saveOnNext(component, event, helper, 'submit','t');
        } else {
            helper.saveOnNext(component, event, helper, 'next','t');
        }
    },
    handleSubmitConfirmation: function (component, event, helper) {
        component.set("v.submitConfirmation",true);
    	//helper.saveOnNext(component, event, helper, 'submit');
    },
    handleSubmit: function (component, event, helper) {
        component.set('v.firstClick',true);
    	helper.saveOnNext(component, event, helper, 'submit','');
    },
    spinnerDisplayHandler: function(component, event, helper) {        
        helper.showHideSpinner(component); 
    },
    hideConfirmation: function (component, event, helper) {
        component.set("v.submitConfirmation",false);
    },
    closeModel: function (component, event, helper) {
    	component.set("v.showIntro",false);
    },
    submitDetails: function (component, event, helper) {
    	component.set("v.showIntro",false);
        
        if(component.get("v.contactId") != undefined && component.get("v.contactId") != null &&
           	component.get("v.contactId") != ''){
			helper.retrieveStudentData(component, event, helper);
        }
    }
})