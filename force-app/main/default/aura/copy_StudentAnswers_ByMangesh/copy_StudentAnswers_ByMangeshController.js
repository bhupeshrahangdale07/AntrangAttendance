({
	doInit : function(component, event, helper) {
        var answers = component.get("v.StudentAnswers");
        var options = [];
        
        let selectedlanguage = 'eng';
        if(component.get("v.language") != undefined && component.get("v.language") != null &&
           component.get("v.language") != ''){
            selectedlanguage = component.get("v.language");
        }
        
        if(selectedlanguage == 'hin'){
            component.set("v.typehereplh","अपना उत्तर यहाँ लिखें");
            component.set("v.chooseone","एक विकल्प चुने");
            component.set("v.maxallowanswermsg1","कृपया केवल चयन करें ");
            component.set("v.maxallowanswermsg2"," उत्तर।");
            component.set("v.errortext","त्रुटि!");
            component.set("v.otherstext","अन्य");
            component.set("v.idonotknowtext","मुझे नहीं पता/पक्का नहीं है");
            
        }
        else if(selectedlanguage == 'mar'){
            component.set("v.typehereplh","आपले उत्तर येथे टाइप करा");
            component.set("v.chooseone","एक निवडा");
            component.set("v.maxallowanswermsg1","कृपया फक्त निवडा ");
            component.set("v.maxallowanswermsg2"," उत्तरे.");
            component.set("v.errortext","त्रुटी!");
            component.set("v.otherstext","इतर");
            component.set("v.idonotknowtext","मला माहित नाही/खात्री नाही");
        }
        else if(selectedlanguage == 'urd'){
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
                options.push({label:answers[i].answerId, value: answers[i].answerValue});
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
        }

    // my code : 
    if(component.get('v.fieldType')=='Label'){
        component.set('v.contactApiFieldValue',answers[0].answerValue);
    }

    answers.forEach(element => {
        if(element.isPulledFromContact){
            component.set('v.pulledFromContact',element.isPulledFromContact);
            component.set('v.contactApiFieldValue',element.answerValue);
        }
    });
    console.log('Is Pulled From Contact : '+ component.get('v.pulledFromContact'));
    console.log('Contact Api field Value : '+ component.get('v.contactApiFieldValue'));
    //till here ......

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
        helper.handleShowOtherTextbox(component, event, helper);
    },
    fnparentdependentquestion: function(component, event, helper) {
        helper.handleShowOtherTextbox(component, event, helper);
        helper.handleParentDependentQuestion(component, event, helper);
    },
    handleCareerNextSteps : function(component, event, helper) {
        var questionLabel = component.get("v.questionlabel");
        var selectedAnswers = event.getSource().get("v.value");
        
        if(questionLabel != undefined && questionLabel != null && 
           (questionLabel == 'My career Option 1 is' || questionLabel == 'मेरा करियर विकल्प १ है' ||
            questionLabel == 'माझ्या कारकीर्दीचा पर्याय १ म्हणजे' || questionLabel == 'میرے کیریئر کا آپشن 1 ہے')){
            var parentComponent = component.get("v.parent");
            parentComponent.nextStepQmethod(selectedAnswers);
        }
        
        helper.HandleShowCareerOtherTextbox(component, event, selectedAnswers);
    },
    
    showNextStepOtherTextbox : function(component, event, helper) {
        var selectedAnswers = event.getSource().get("v.value");
        helper.HandleShowCareerOtherTextbox(component, event, selectedAnswers);
    },

    studentDetailCapture :  function(component, event, helper) {

        //1. Tommorow 25 : Do this Timeout Function

        // if (component.get("v.inputSearchFunction")) {
        //     clearTimeout(component.get("v.inputSearchFunction"));
        // }
        
        // var inputTimer = setTimeout(
        //     $A.getCallback(function () {
        //         helper.searchRecords(component, searchString);
        //     }),
        //     1000
        // );
        // component.set("v.inputSearchFunction", inputTimer);



        var selectedAnswers = event.getSource().get("v.value");
        var questionId = component.get('v.questionId');
        console.log('The Selected Field Value : '+selectedAnswers);
        console.log('The changed Field Api Name : '+questionId);

        var compEvent = component.getEvent("studentDetailsPassToParent");
        debugger;
        compEvent.setParams({"fieldIdentifier" :questionId,"fieldValue":selectedAnswers});
        compEvent.fire();        
        console.log('EVENT FIRED SUCCESFULLY');
    }

})