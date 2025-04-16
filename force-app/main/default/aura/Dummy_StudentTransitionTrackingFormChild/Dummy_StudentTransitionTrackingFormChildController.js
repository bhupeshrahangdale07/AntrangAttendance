({
	doInit : function(component, event, helper) {
        var answers = component.get("v.StudentAnswers");
        var options = [];
        
        let selectedlanguage = 'English';
        if(component.get("v.language") != undefined && component.get("v.language") != null &&
           component.get("v.language") != ''){
            selectedlanguage = component.get("v.language");
        }
        
        if(selectedlanguage == 'Hindi'){
            component.set("v.typehereplh","अपना उत्तर यहाँ लिखें");
            component.set("v.chooseone","एक विकल्प चुने");
            component.set("v.maxallowanswermsg1","कृपया केवल चयन करें ");
            component.set("v.maxallowanswermsg2"," उत्तर।");
            component.set("v.errortext","त्रुटि!");
            component.set("v.otherstext","अन्य");
            component.set("v.idonotknowtext","मुझे नहीं पता/पक्का नहीं है");

            //CUSTOMCODE : Setting hindi Question labels for Other and IdontKnow
            component.set("v.isOtherOptionQuestionLabel","यदि 'अन्य' तो, कृपया निर्दिष्ट करें");
            component.set("v.isIdontKnowOptionQuestionLabel","यदि आप नहीं जानते हैं, तो क्या आप समझा सकते हैं कि क्यों?");
            
        }
        else if(selectedlanguage == 'Marathi'){
            component.set("v.typehereplh","आपले उत्तर येथे टाइप करा");
            component.set("v.chooseone","एक निवडा");
            component.set("v.maxallowanswermsg1","कृपया फक्त निवडा ");
            component.set("v.maxallowanswermsg2"," उत्तरे.");
            component.set("v.errortext","त्रुटी!");
            component.set("v.otherstext","इतर");
            component.set("v.idonotknowtext","मला माहित नाही/खात्री नाही");

             //CUSTOMCODE : Setting hindi Question labels for Other and IdontKnow
             component.set("v.isOtherOptionQuestionLabel","जर 'अन्य' तो, कृपया खरेदी करा");
             component.set("v.isIdontKnowOptionQuestionLabel","जर तुम्हाला माहित नसेल, तर तुम्ही त्याचे कारण सांगू शकता का?");
        }
        else if(selectedlanguage == 'Urdu'){
            component.set("v.typehereplh","اپنا جواب یہاں لکھیں");
            component.set("v.chooseone","ایک کا انتخاب کریں");
            component.set("v.maxallowanswermsg1","براہ کرم صرف منتخب کریں۔ ");
            component.set("v.maxallowanswermsg2"," جوابات");
            component.set("v.errortext","خرابی!");
            component.set("v.otherstext","دوسرے");
            component.set("v.idonotknowtext","میں نہیں جانتا/یقین نہیں ہے۔");
        }
        
        if(answers != null && answers != undefined){
        	for(var i=0; i<answers.length; i++){
                options.push({label:answers[i].answerValue, value: answers[i].answerId});
                // CUSTOMCODE 2:
                if(answers[i].isPulledFromContact == true){
                    component.set("v.answerValue",answers[i].answerId);
                    answers[i].isPulledFromContact = false; //CUSTOMCODE : Made false because on previous we were getting same iPulled one value.
                }
                //TILL HERE...
            }
            component.set("v.answerOptions",options);
        }
        
        var careerAspirationMap = component.get("v.CareerAspirations");
        if(careerAspirationMap != null && careerAspirationMap != undefined){
            var aspirations = JSON.parse(JSON.stringify(careerAspirationMap));
            if(!$A.util.isEmpty(careerAspirationMap)){
                var aspirations = [];
                
                for(var key in careerAspirationMap){
                    aspirations.push({value:careerAspirationMap[key], key:key});
                }
                component.set("v.CareerAspirationOptions",aspirations);
            }
        }        
        
        var selectedAnswers = component.get("v.answerValue");
        if(selectedAnswers != undefined && selectedAnswers != null && selectedAnswers != ''){
            const arrayOfAnswers = selectedAnswers.split(',');
            component.set("v.multiAnswerValue", arrayOfAnswers);
        }else{
            component.set("v.multiAnswerValue", []); //CUSTOMCODE : Even If Answer is Null we want it to show blank i.e. no ticks on Checkbox
        }
	},
    handleMultiAnswer : function(component, event, helper) {
        var allSelectedAnswers = event.getSource().get("v.value");
        let allValues = '';
        var maxAllowAns = component.get("v.maxAllowAnswer");
        
        if(maxAllowAns > 0 && allSelectedAnswers.length > maxAllowAns){
            var message = component.get("v.maxallowanswermsg1") +maxAllowAns + component.get("v.maxallowanswermsg2");
            helper.showMessage(component, event, message, component.get("v.errortext"),'error');
        }
        
        for (let key in allSelectedAnswers) {
            allValues += allSelectedAnswers[key]+ ","; 
        }
        
        allValues = allValues.substring(0, allValues.length - 1);
        component.set("v.answerValue",allValues);
        // helper.handleShowOtherTextbox(component, event, helper);  //OMIT :  No need
    },
    fnparentdependentquestion: function(component, event, helper) {
        // helper.handleShowOtherTextbox(component, event, helper); //OMIT : No Need
        helper.handleParentDependentQuestion(component, event, helper);
    },
    handleCareerNextSteps : function(component, event, helper) {
        var questionLabel = component.get("v.questionlabel");
        var selectedAnswers = event.getSource().get("v.value");
        var questionId = component.get("v.questionId");

        if(questionId != undefined && questionId != null
            //OMIT For now:
            //  && (questionLabel == 'My career Option 1 is' || questionLabel == 'मेरा करियर विकल्प १ है' ||
            // questionLabel == 'माझ्या कारकीर्दीचा पर्याय १ म्हणजे' || questionLabel == 'میرے کیریئر کا آپشن 1 ہے')
            ){
            var parentComponent = component.get("v.parent");
            debugger;
            parentComponent.nextStepQmethod(selectedAnswers,questionId);
        }
        
        helper.HandleShowCareerOtherTextbox(component, event, selectedAnswers);
    },
    
    showNextStepOtherTextbox : function(component, event, helper) {
        var selectedAnswers = event.getSource().get("v.value");
        helper.HandleShowCareerOtherTextbox(component, event, selectedAnswers);
    },

    
    //CUSTOMCODE : Clear Multipe Answers Ticked
    clearMultipleAnswer : function(component, event, helper) {
        var params = event.getParam('arguments'); 
        if(component.get("v.questionId")== params.questionId){
            component.set("v.multiAnswerValue", []);
        }
    }
    

})