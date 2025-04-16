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
        
        // if(iscallparent){
            if(fieldType == 'RadioGroup' || fieldType == 'Picklist'){ //CUSTOMCODE : Added Or type==Picklist
                debugger;
                let changedValue = event.getSource().get("v.value");
                console.log('The Numeric Value Change : '+changedValue);
                parentComponent.questionmethod(dependentquestionid, basequestionid,changedValue,fieldType);

                helper.HandleShowCareerOtherTextbox(component, event, changedValue);
            }
            //TODO : We Will added Extra elseif for Picklist if requirements doesnt matches RadioGroup.
            
            else if(fieldType == 'MatchColumn'){
                if(selectans == ''){
                    answerLabel = '';
                }
                parentComponent.questionmethod(basequestionid,null,answerLabel,fieldType);
            }
        // }
        //CUSTOMCODE : for label and Numeric an text Field Type
            else if(fieldType == 'Label' || fieldType == 'Numeric' || fieldType == 'Text'){
            //CUSTOMCODE : For Dynamic Validation
                debugger;
                let inputElement = event.getSource(); 
                console.log('Input Name : '+inputElement.get("v.name"));
                let isValid = helper.customValidation(inputElement);
                console.log('Input Name : '+inputElement.get("v.name"));
                let questionObject = component.get('v.questionObject');
                questionObject.isValidComponent = isValid;
                component.set('v.questionObject',questionObject);
            //Till here...

                // let changedValue = event.getSource().get("v.value"); //TODO :DONENOW
                // console.log('The Label Value Change : '+changedValue);   //TODO :DONENOW
                // parentComponent.questionmethod(null, basequestionid,changedValue,fieldType); //TODO :DONENOW
            }
        //TILL HERE.        
        debugger;
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
        if(selectedAnswers == 'Others' || selectedAnswers == 'Other' || selectedAnswers == 'I do not know/Not sure' ){
            component.set("v.isshowtextarea",true);
            //CUSTOMCODE : Line 69 only
            selectedAnswers == 'I do not know/Not sure' ? component.set("v.isIdontKnowOption",true) : component.set("v.isIdontKnowOption",false);
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
        debugger;
        return isValid;
    }

})