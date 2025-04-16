({
	doInit : function(component, event, helper) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        if(sPageURL.length > 0){
            sPageURL.split("&").forEach(function(part) {
                var param = part.split("=");
                if (param[0] == "contactId") {
                    component.set("v.contactId",param[1]);
                    console.log(component.get("v.contactId"));
                    debugger;
                }else if(param[0] == "lang"){
                    component.set("v.language",param[1]);
                }
            });
        }
        if(component.get("v.contactId") != undefined && component.get("v.contactId") != null &&
           	component.get("v.contactId") != ''){
			helper.retrieveStudentData(component, event, helper);
        }
	},
    
    handleNext : function(component, event, helper) {
        helper.saveOnNext(component, event, helper, 'next');
    },
    handlePrevious : function(component, event, helper) {
        helper.goPrevious(component, event, helper);
    },
    handleSubmit : function(component, event, helper) {
        //TODO : Activate below code once all done and needed records to be saved in database
        // helper.saveTransitionTracking(component, event, helper);
    },

    
   

    handlequestiondata : function(component, event, helper) {
        helper.helperHandleQuestionData(component, event, helper);
    },
    
    handlenextStepQuestion : function(component, event, helper) {
        debugger;
        var params = event.getParam('arguments');
        var lst = component.get("v.questions");
        
        var counter = 1;
        var primaryCareerQuestionId = '';
        var showDependent = false;
        lst.forEach(o => {
            if((params.questionid === o.questionId) && o.isCareerOption){
                console.log('Yes we got the QuestionId and it is career option');
                primaryCareerQuestionId = o.primaryDependentQuestionId;

                if(params.selectedcareer != '' && params.selectedcareer != null){
                    if(params.selectedcareer == 'I do not know/Not sure'||params.selectedcareer =='Other'){
                        showDependent = false;
                    }else{
                        showDependent = true;
                    }   
                }
            }
        });

        lst.forEach(m =>{
            if(m.questionId === primaryCareerQuestionId){
                m.isdependentquestionshow = showDependent; 
            }
        })
        component.set("v.questions",lst);
    },


    // this function automatic call by aura:waiting event  
    spinnerDisplayHandler: function(component, event, helper) {        
        helper.showHideSpinner(component); 
    },

    //CUSTOMCODE : Handles EVENT When Click Yes on pop-up model.
    handlePopUp : function(component, event, helper){
        component.set("v.displayModal",false);
    }
    
})