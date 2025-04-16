({
	doInit : function(component, event, helper) {
        var answers = component.get("v.StudentAnswers");
        var options = [];
        
        if(answers != null && answers != undefined){
        	for(var i=0; i<answers.length; i++){
                options.push({label:answers[i].formValue, value: answers[i].answerId});
            }
            component.set("v.answerOptions",options);
        }
	},
    handleMultiAnswer : function(component, event, helper) {
        var allSelectedAnswers = event.getParam('value');
        let allValues = '';
        for (let key in allSelectedAnswers) {
            allValues += allSelectedAnswers[key]+ ","; 
        }
        allValues = allValues.substring(0, allValues.length - 1);
        component.set("v.answerValue",allValues);
    },
})