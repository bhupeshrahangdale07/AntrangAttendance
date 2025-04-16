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
        
            if(fieldType == 'RadioGroup' || fieldType == 'Picklist'){ //CUSTOMCODE : Added Or type==Picklist
                let changedValue = event.getSource().get("v.value");
                parentComponent.questionmethod(dependentquestionid, basequestionid,changedValue,fieldType);
            }
        
        //CUSTOMCODE : for label and Numeric as text Field Type
            else if(fieldType == 'Label' || fieldType == 'Numeric' || fieldType == 'Text'){
            //CUSTOMCODE : For Dynamic Validation
                let inputElement = event.getSource(); 
                let isValid = helper.customValidation(inputElement);
                let questionObject = component.get('v.questionObject');
                questionObject.isValidComponent = isValid;
                component.set('v.questionObject',questionObject);
            //TILL HERE....
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
        if(selectedAnswers == 'Others' || selectedAnswers == 'Other' ){
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
    },

    //CUSTOMCODE: Dynamic Validation
    customValidation : function(inputComponent) {
        let isValid = true;
        let inputField = inputComponent;
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
        return isValid;
    }

})