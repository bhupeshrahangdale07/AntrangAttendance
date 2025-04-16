({
	doInit : function(component, event, helper) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        if(sPageURL.length > 0){
            sPageURL.split("&").forEach(function(part) {
                var param = part.split("=");
                if (param[0] == "contactId") {
                    component.set("v.contactId",param[1]);
                }else if(param[0] == "lang"){
                    component.set("v.language",param[1]);
                }
            });
        }
        if(component.get("v.contactId") != undefined && component.get("v.contactId") != null &&
           	component.get("v.contactId") != ''){
			helper.retrieveStudentData(component, event, helper);
        }

        component.set('v.StudentChangedDetails',{}); //Setting the object to default value so that the data can be entered in it.
	},
    
    handleNext : function(component, event, helper) {
        helper.saveOnNext(component, event, helper, 'next');
    },
    handlePrevious : function(component, event, helper) {
        helper.goPrevious(component, event, helper);
    },
    handleSubmit : function(component, event, helper) {
        helper.saveOnNext(component, event, helper, 'submit');
    },
    handlequestiondata : function(component, event, helper) {
        var params = event.getParam('arguments');
      	
        var lst = component.get("v.questions");
        if(params.fieldType == 'RadioGroup'){
            if(params.questionid != undefined && params.questionid != null){            
                lst.forEach(o => {
                    if(o.questionId  == params.questionid){
                        o.isdependentquestionshow = true;
                    }
                });
                        
            }else if(params.basequestionid != undefined && params.basequestionid != null){
                var lstremove = [];
                lst.forEach(o => {
                    if(o.questionId == params.basequestionid){
                        o.lstWrpStudentAnswer.forEach(w => {
                            if(w.dependentquestion != undefined){
                                lstremove.push(w.dependentquestion);	
                            }   
                        });
                    }
                });
               
                lst.forEach(l => {
                    lstremove.forEach(o => {
                        if(l.questionId == o){
                            l.isdependentquestionshow = false;
                    		l.answerId = '';
                        }
                    });
                });
            }
            var pageNumber = component.get("v.startPage");
            if(pageNumber == 1){
                var counter = 1;
                lst.forEach(m => {
                    if(!m.isdependentquestion){
                        m.displayNumber = counter;
                        counter++;
                    }else{
                        if(m.isdependentquestion && m.isdependentquestionshow){
                            m.displayNumber = counter;
                            counter++;
                        }
                    }
                });
            }
            component.set("v.questions",lst);
        }
        else if(params.fieldType == 'MatchColumn'){
            var setselectedoptions = new Set();
            let mapquestionvsans = new Map();
            lst.forEach(o => {
                if(o.fieldType == 'MatchColumn'){
                    if(o.answerId != undefined && o.answerId != null && o.answerId != ""){
                        let ansval = '';
                        o.lstWrpStudentAnswer.forEach(c => {
                            if(c.answerId == o.answerId){
                                ansval = c.answerValue;
                            }
                        });
                        if(ansval != ''){
                            setselectedoptions.add(ansval);
                            mapquestionvsans.set(o.questionId,ansval);
                        }
                        
                    }
                }
            });

            lst.forEach(o => {
               if(o.fieldType == 'MatchColumn'){
                    o.lstWrpStudentAnswer.forEach(w => {   
                        if(mapquestionvsans.get(o.questionId) == w.answerValue){
                            w.isdisabled = false;
                        }
                        else if(setselectedoptions.has(w.answerValue)){
                            w.isdisabled = true;
                        }else{
                            w.isdisabled = false;
                        }
                    });                        
                }
            });
            component.set("v.questions",lst);
        }
    },
                    
	handlenextStepQuestion : function(component, event, helper) {
        var params = event.getParam('arguments');
        var lst = component.get("v.questions");
        
        var counter = 1;
        lst.forEach(o => {
            if(o.isCareerNextStep){
            	if(params.selectedcareer != '' && params.selectedcareer != null &&
                    params.selectedcareer != 'I do not know/Not sure'){
                    o.isdependentquestionshow = true;
        		}else{
                    o.answerId = '';
                    o.isdependentquestionshow = false;
                }
                
                var nextStepsMap = JSON.parse(JSON.stringify(o.mapAspirationStep));
                var nextStepslst = [];
        		var randomNextStep = new Set();
        		for (let key in nextStepsMap) {
                    if(key == params.selectedcareer){
                        nextStepslst = nextStepsMap[params.selectedcareer];
                    }else{
                        if(o.isdependentquestionshow){
                            for(let childKey in nextStepsMap[key]){
                                if(nextStepsMap[key][childKey] != 'I do not know' &&
                                  	nextStepsMap[key][childKey] != 'Other'){
                                    randomNextStep.add(nextStepsMap[key][childKey]);
                                }
                            }
                        }
                    }
                }
        		if(o.isdependentquestionshow){
                    var selectedNextSteps = new Set();
                    for(let o in nextStepslst){
                        selectedNextSteps.add(nextStepslst[o]);
                    }
            
                    var count = 0;
                    randomNextStep.forEach(i => {
                        if(!selectedNextSteps.has(i)){
                            if(count < 2){
                                nextStepslst.push(i);
                                count++;
                            }
                        }
                    });
        		}
                component.set("v.CareerNextStpeOptions",nextStepslst);
            }
		});
        component.set("v.questions",lst);
    },

    // this function automatic call by aura:waiting event  
    spinnerDisplayHandler: function(component, event, helper) {        
        helper.showHideSpinner(component); 
    },

    studentDetailChangedHandler : function(component, event, helper){
        console.log('EVENT HANDLED');
        helper.handleStudentChangedDetails(component, event);
    }
})