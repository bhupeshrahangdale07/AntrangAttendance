({
	handleParentDependentQuestion : function(component, event, helper) {
		let lst = component.get("v.StudentAnswers");
        let selectans = component.get("v.answerValue");
        var parentComponent = component.get("v.parent");
        var iscallparent = false;
        var dependentquestionid = null;
        var basequestionid = component.get("v.questionId");
        var answerLabel = null;
        var fieldType = component.get("v.fieldType");
        
        lst.forEach(o => {
            if(o.answerId == selectans || selectans == ''){
                iscallparent = true;
                dependentquestionid = o.dependentquestion;
            	answerLabel = o.answerValue;
            }
        });
        
        if(iscallparent){
            if(fieldType == 'RadioGroup'){
                parentComponent.questionmethod(dependentquestionid, basequestionid,null,fieldType);
            }
            else if(fieldType == 'MatchColumn'){
                if(selectans == ''){
                    answerLabel = '';
                }
                parentComponent.questionmethod(basequestionid,null,answerLabel,fieldType);
            }
        }
	},
    
    handleShowOtherTextbox : function(component, event, helper) {
        let lst = component.get("v.StudentAnswers");
        let selectedAnswer = component.get("v.answerValue");
        
        if(lst != undefined){
            lst.forEach(o => {
                if(o.isShowOtherOption != undefined && o.isShowOtherOption){
                    if(selectedAnswer.indexOf(o.answerId) != -1){
                        component.set("v.isshowtextarea",true);
                    }else{
                        component.set("v.isshowtextarea",false);
            			component.set("v.otherAnswerValue",'');
                    }
                }
            });
        }
    },
    HandleShowCareerOtherTextbox : function(component, event, selectedAnswers) {
        if(selectedAnswers == 'Others' || selectedAnswers == 'Other'){
            component.set("v.isshowtextarea",true);
        }else{
            component.set("v.isshowtextarea",false);
            component.set("v.otherAnswerValue",'');
        }
    },
    showMessage: function (component, event, message, title, severity) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":severity
        });
        toastEvent.fire();
    }
})