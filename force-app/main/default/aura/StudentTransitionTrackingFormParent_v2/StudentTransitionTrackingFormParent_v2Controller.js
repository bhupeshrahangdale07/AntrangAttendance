({
	doInit : function(component, event, helper) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        if(sPageURL.length > 0){
            sPageURL.split("&").forEach(function(part) {
                var param = part.split("=");
                if (param[0] == "contactId") {
                    component.set("v.contactId",param[1]);
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
        //CUSTOMCODE : Doing Validations and if All is Valid then Show Modal 
        if(!helper.isValidSection(component)){
            helper.showMessage(component, event, component.get("v.questionrequiredmsg"), component.get("v.errortext"), "error");
            return;
        }
        
        if(!helper.otherValidation(component,event,helper)){
            return;
        }

        let selectedlanguage = 'English';
        if(component.get("v.language") != undefined && component.get("v.language") != null &&
           component.get("v.language") != ''){
            selectedlanguage = component.get("v.language");
        }

        if(selectedlanguage == 'Hindi'){
            component.set("v.popUpModalMessage",'क्या आप फॉर्म सबमिट करना चाहते हैं?');
        }
        else if(selectedlanguage == 'Marathi'){
            component.set("v.popUpModalMessage",'तुम्हाला फॉर्म सबमिट करायचा आहे का?');
        }
        else if(selectedlanguage == 'Urdu'){
            //TODO : Urdu lang
            component.set("v.popUpModalMessage",'کیا آپ فارم جمع کروانا چاہتے ہیں؟');
        }else{
            component.set("v.popUpModalMessage",'Do You Want To Submit The Form ?');
        }


        component.set("v.popUpModalType",'AfterLogout');
        component.set("v.displayModal",true);
    },

    

    handlequestiondata : function(component, event, helper) {
        helper.helperHandleQuestionData(component, event, helper);
    },
    
    handlenextStepQuestion : function(component, event, helper) {
        debugger;
        var params = event.getParam('arguments');
        var lst = component.get("v.questions");
        
     // CUSTOMCODE :Logic For Career Questions (because the answer values dont have ids and taken from custom settings)
        var counter = 1;
        var primaryCareerQuestionId = '';
        var showDependent = false;
        lst.forEach(o => {
            if((params.questionid === o.questionId) && o.isCareerOption){
                primaryCareerQuestionId = o.primaryDependentQuestionId;

                if(params.selectedcareer != '' && params.selectedcareer != null){  
                    if(params.selectedcareer == 'I do not know/Not sure'){
                        showDependent = false;
                        o.otherAnswerDescription='';
                    }
                    else if(params.selectedcareer =='Other'){
                        showDependent = false;
                        o.iDontKnowAnswerDescription='';
                    }else{
                        showDependent = true;
                        o.otherAnswerDescription='';
                        o.iDontKnowAnswerDescription='';
                    }   
                }
            }
        });
        lst.forEach(m =>{
            if(m.questionId === primaryCareerQuestionId){
                m.isdependentquestionshow = showDependent; 
            }
        })

        //CUSTOMCODE:  Re-Arrangement of Questions
        var pageNumber = component.get("v.startPage");
        var counter = 1;
        lst.forEach(m => {
            if(!m.isdependentquestion){
                m.displayNumber = counter;
                counter++;
            }else{
                if((m.isdependentquestion && m.isdependentquestionshow)){
                    // m.displayNumber = counter;
                    // counter++;
                    if(!m.isASubQuestion){
                        m.displayNumber = counter;
                        counter++;
                    }
                }
            }
        });

     //Till here.....

        component.set("v.questions",lst);
    },


    // this function automatic call by aura:waiting event  
    spinnerDisplayHandler: function(component, event, helper) {        
        helper.showHideSpinner(component); 
    },

    //CUSTOMCODE : Handles EVENT When Click Yes on pop-up model.
    handlePopUp : function(component, event, helper){
        var params = event.getParams();
        if(params.popType == 'AfterLogin'){
            component.set("v.displayModal",false);
            //CUSTOMCODE :Added this because we were getting the Progess bar to first point of bar
            helper.handleProgressBarEvent(component,component.get("v.startPage"),component.get("v.totalPages")); 
        }
        else if(params.popType == 'AfterLogout'){
            //TODO : Activate below code once all done and needed records to be saved in database
            //      If Do Yount to Save is YES then save to database.
            helper.saveTransitionTracking(component, event, helper);
        }
    }
    
})