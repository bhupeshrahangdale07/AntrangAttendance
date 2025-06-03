({
	retrieveQuestionIamge : function(component, event) {
        console.log(component.get("v.questionId"));
		var action = component.get("c.fetchQuestionImage");
        action.setParams({
            questionId: component.get("v.questionId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                
                if(result != null && result != undefined){
                    var imageData = 'data:image/'+result.fileType + ';base64,'+result.fileData;
                	component.set("v.imageData",imageData);
                }
            }else if (state === "ERROR") {
                var errors = response.getError();
                var errmsg = "";
                if (errors.length > 0 && errors[0] && errors[0].message){
                    // To show other type of exceptions
                    errmsg += errors[0].message;
                }
                if (errors.length > 0 && errors[0] && errors[0].pageErrors){
                    // To show DML exceptions
                    errmsg += errors[0].pageErrors[0].message;
                }
                helper.showMessage(component, event, errmsg, "Error!", "error");
            }
        });
        $A.enqueueAction(action);
	}
})