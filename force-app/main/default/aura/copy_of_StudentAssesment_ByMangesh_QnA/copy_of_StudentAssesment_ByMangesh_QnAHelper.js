({
	retrieveStudentData : function(component, event, helper) {
        helper.showspinner(component);
        let selectedlanguage = 'eng';
        if(component.get("v.language") != undefined && component.get("v.language") != null &&
           component.get("v.language") != ''){
            selectedlanguage = component.get("v.language");
        }
        
        if(selectedlanguage == 'hin'){
            component.set("v.SelfAwarenessHeader","आत्म जागरूकता");
            component.set("v.CareerAwarenessHeader","करियर जागरूकता");
            component.set("v.ParentSupportHeader","माता-पिता का समर्थन");
            component.set("v.CareerPlanningHeader","करियर प्लैनिंग/करियर की योजना");
            component.set("v.questionrequiredmsg","सभी प्रश्न आवश्यक हैं।");
            component.set("v.othertextrequiredmsg","कृपया अन्य मान निर्दिष्ट करें!");
            component.set("v.errortext","त्रुटि!");
            component.set("v.savenextbtn","सेव करें और आगे बढ़ें");
            component.set("v.previousbtn","पिछला");
            component.set("v.submitbtn","सबमिट/दर्ज करें");
            component.set("v.careerheader","करियर");
            component.set("v.qualificationheader","योग्यताए");
        }
        else if(selectedlanguage == 'mar'){
            component.set("v.SelfAwarenessHeader","स्व-जागृती");
            component.set("v.CareerAwarenessHeader","करियर जागरूकता");
            component.set("v.ParentSupportHeader","पालकांचा पाठिंबा");
            component.set("v.CareerPlanningHeader","करिअर नियोजन");
            component.set("v.questionrequiredmsg","सर्व प्रश्न आवश्यक आहेत.");
            component.set("v.othertextrequiredmsg","कृपया इतर मूल्ये निर्दिष्ट करा!");
            component.set("v.errortext","त्रुटी!");
            component.set("v.savenextbtn","सेव करा आणि पुढे जा");
            component.set("v.previousbtn","मागील");
            component.set("v.submitbtn","प्रस्तुत करा");
            component.set("v.careerheader","करिअर");
            component.set("v.qualificationheader","पात्रता");
        }
        else if(selectedlanguage == 'urd'){
            component.set("v.SelfAwarenessHeader","ذاتی بیداری");
            component.set("v.CareerAwarenessHeader","کیریئر کی بیداری");
            component.set("v.ParentSupportHeader","والدین کا سپورٹ");
            component.set("v.CareerPlanningHeader","کیریئر کی منصوبہ بندی");
            component.set("v.questionrequiredmsg","تمام سوالات مطلوب ہیں۔");
            component.set("v.othertextrequiredmsg","براہ کرم دیگر اقدار کی وضاحت کریں!");
            component.set("v.errortext","خرابی!");
            component.set("v.savenextbtn","محفوظ کریں اور اگلا۔");
            component.set("v.previousbtn","پچھلا");
            component.set("v.submitbtn","جمع کرائیں");
            component.set("v.careerheader","کیریئر");
            component.set("v.qualificationheader","اہلیت");
        }
        
		let action = component.get("c.fetchStudentQuestionsAndAnswers");
        action.setParams({
            studentId : component.get("v.contactId"),
            language: selectedlanguage
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            debugger;
            if(state === "SUCCESS"){
                let result = response.getReturnValue();
                console.log('Mangesh log : THe Data from the Controller recieved : '+ JSON.stringify(result));
                
                if(result != null && result != undefined){
                    //this is for already submitted assessment
                    /*if(result.isSubmitted){
                        component.set("v.isShowResult",result.isSubmitted);
                        component.set("v.isShowQuestionPage",false);
                        component.set("v.AssessmentMark",result.objAssessmentMarks);
                        
                    }else if(!result.isSubmitted && result.lstWrpStudentQuestion != null)*/
                    {
                        component.set("v.isShowQuestionPage",true);
                        helper.convertListToMapQuestions(component, event, helper, result.lstWrpStudentQuestion);
                        helper.loadQuestionPerPage(component, event, helper, component.get("v.startPage"));
                        helper.handleProgressBarEvent(component,1,component.get("v.totalPages"));
                    }
                }
            }else if (state === "ERROR") {
                let errors = response.getError();
                let errmsg = "";
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
            helper.hidespinner(component);
        });
        $A.enqueueAction(action);
	},
    loadQuestionPerPage : function(component, event, helper, pageNumber){
        var questionsMap = component.get("v.StudentQuestions");
        let questionSectionWise = [];
        for(var key in questionsMap){
            if(questionsMap[key].key == pageNumber){
                questionSectionWise.push(questionsMap[key].value);
            }
        }
        if(pageNumber == 1){
            var lst = questionSectionWise;
            var counter = 1;
            lst.forEach(o => {
                if(!o.isdependentquestion){
                    o.displayNumber = counter;
                    counter++;
                }else{
                    if(o.isdependentquestion && o.isdependentquestionshow){
                        o.displayNumber = counter;
                        counter++;
                    }
            	}
            });
            component.set("v.questions",lst);
        }else{
            component.set("v.questions",questionSectionWise);
        }
		helper.handleProgressBarEvent(component,pageNumber,component.get("v.totalPages"));
    },
    goNext : function(component, event, helper){
        var starpage = component.get("v.startPage");
        component.set("v.startPage", (starpage + 1));
        component.set("v.endPage",(starpage + 1));
        helper.loadQuestionPerPage(component, event, helper, component.get("v.startPage"));
    },
    goPrevious : function(component, event, helper){
        helper.showspinner(component);
        var endpage = component.get("v.endPage");
		component.set("v.endPage",(endpage - 1));
        component.set("v.startPage", (endpage - 1));
        //My custom Logic : checks if page is 1 then re-render the page.
        if(component.get('v.startPage')===1){
            helper.retrieveStudentData(component, event, helper);
        }else{
            helper.loadQuestionPerPage(component, event, helper, component.get("v.endPage"));
        }
        //till here 
        helper.hidespinner(component);
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
    saveOnNext : function(component, event, helper, actionName){
        if(!helper.isValidSection(component)){
            helper.showMessage(component, event, component.get("v.questionrequiredmsg"), component.get("v.errortext"), "error");
            return;
        }
        
        if(!helper.otherValidation(component,event,helper)){
            return;
        }
        
        helper.showspinner(component);
        var studentQuestionMap = component.get("v.StudentQuestions");
        var studentQuestions = [];
        
        for(var key in studentQuestionMap){
            studentQuestions.push(studentQuestionMap[key].value);
        }
        
        let selectedlanguage = 'eng';
        if(component.get("v.language") != undefined && component.get("v.language") != null &&
           component.get("v.language") != ''){
            selectedlanguage = component.get("v.language");
        }

        //my custom code
        if(component.get('v.startPage')===1){
            helper.handleUpsertOfTransitionTracking(component,event,helper);
            // till here....
        }else{
            let action = component.get("c.saveAndNextAssessment");
            action.setParams({
                lstStudentQuestions : studentQuestions,
                studentId : component.get("v.contactId"),
                actionName : actionName,
                language : selectedlanguage
            });
            action.setCallback(this, function(response){
                let state = response.getState();
                
                if(state === "SUCCESS"){
                    var result = response.getReturnValue();
                    if(result != null && result != undefined){
                        if(!result.isSubmitted){
                            helper.convertListToMapQuestions(component, event, helper, result.lstWrpStudentQuestion);
                            helper.goNext(component, event, helper);
                        }else{
                            component.set("v.isShowResult",true);
                            component.set("v.isShowQuestionPage",false);
                            component.set("v.AssessmentMark",result.objAssessmentMarks);
                        }                    
                    }
                }else if (state === "ERROR") {
                    let errors = response.getError();
                    let errmsg = "";
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
                helper.hidespinner(component);
            });
            $A.enqueueAction(action); 
        }       
    },
    convertListToMapQuestions : function(component, event, helper, lstQuestions) {
		let allQuestions = lstQuestions;
        var questionsMap = [];
        var sectionNumberArray = [];
        var fathersOccupList = [];

        for(var key in allQuestions){
            questionsMap.push({key: allQuestions[key].sectionNumber, value: allQuestions[key]});
            
            if(sectionNumberArray.indexOf(allQuestions[key].sectionNumber) === -1) {
                sectionNumberArray.push(allQuestions[key].sectionNumber);
            }

            //my custom : For getting al father Occupations
            if(allQuestions[key].mapFatherOccupation){
                for( var mapKey in allQuestions[key].mapFatherOccupation){
                    fathersOccupList.push(allQuestions[key].mapFatherOccupation[mapKey]);
                }
            }
            // till here...
        }
        component.set("v.StudentQuestions",questionsMap);
        debugger;
        component.set("v.FathersOccupationList",fathersOccupList);
        
        if(sectionNumberArray != undefined && sectionNumberArray != null){
            var max = sectionNumberArray.reduce(function(a, b) {
                return Math.max(a, b);
            });
            component.set("v.totalPages",max);    
        }
	},

    showHideSpinner : function(component) {
        var showValue = component.get('v.show');
        
        if(showValue) {
            var spinner = component.find("spinner");
        	$A.util.removeClass(spinner, "slds-hide");
        } else {
            var spinner = component.find("spinner");
        	$A.util.addClass(spinner, "slds-hide");
        }
    },

    showspinner: function(component) {
        component.set("v.show",true);        
    },

    hidespinner: function(component) {
        window.setTimeout(
            function() {
                component.set("v.show",false);
            }, 1000
        );        
    },
    isValidSection : function (component) {
        let allQuestions = component.get("v.questions");
        var isValid = true;
        
        allQuestions.forEach(o => {
            // if(o.fieldType != 'Label'){
            //Do not need Validations on Section 1 i.e. Student Information.
            if(!component.get('v.startPage')===1){
                if(!o.isdependentquestion && (o.answerId == undefined || o.answerId == null || 
                    o.answerId == '')){
                    isValid = false;
                }else{
                    if(o.isdependentquestion && o.isdependentquestionshow && 
                        (o.answerId == undefined || o.answerId == null || o.answerId == '')){
                        isValid = false;
                    }
                }
			 }
		});
        console.log("The All required Error is Valid : "+isValid);
		return isValid;
    },
    otherValidation : function (component, event, helper) {
        let allQuestions = component.get("v.questions");
        var isValid = true;
        var isRequiredOtherValues = false;
        
        allQuestions.forEach(o => {
            if(o.maxAllowAnswer > 0 && o.answerId != undefined && o.answerId != null && o.answerId != ''){
            	const answers = o.answerId.split(',');
                if(answers.length > o.maxAllowAnswer){
                    var message = 'Please select only '+o.maxAllowAnswer + ' answers for the Question No. ' + o.displayNumber +'.';
                    helper.showMessage(component, event, message, component.get("v.errortext"),'error');
                    isValid = false;
                }
            }
            
            if(o.isshowtextarea){
                if(o.isCareerOption && (o.otherAnswerDescription == '' || 
                   	o.otherAnswerDescription == null)){
                    
                    isRequiredOtherValues = true;
                    isValid = false;
                }else{
                    o.lstWrpStudentAnswer.forEach(l => {
                        if(l.isShowOtherOption && (o.otherAnswerDescription == '' || 
                            o.otherAnswerDescription == null)){
                            isRequiredOtherValues = true;
                            isValid = false;
                        }
                    });
                }
        	}
        });
		
		if(isRequiredOtherValues){
    		helper.showMessage(component, event, component.get("v.othertextrequiredmsg"), component.get("v.errortext"),'error');
		}
        
        return isValid;
    },
    handleProgressBarEvent : function(component,currentPage, totalPage){
        let appEvent = $A.get("e.c:LIProgressBarEvent");
        appEvent.setParams({
            CurrentNumber: currentPage,
            TotalSize: totalPage + 1
        });
        appEvent.fire();
    },

//My Custom defined Handlers

    handleUpsertOfTransitionTracking : function(component,event,helper){
        if(!helper.isValidSection(component)){
            helper.showMessage(component, event, component.get("v.questionrequiredmsg"), component.get("v.errortext"), "error");
            return;
        }
        
        if(!helper.otherValidation(component,event,helper)){
            return;
        }
        
        helper.showspinner(component);
        var studentQuestionMap = component.get("v.StudentQuestions");
        var studentQuestions = [];
        
        for(var key in studentQuestionMap){
            studentQuestions.push(studentQuestionMap[key].value);
        }
        
        let selectedlanguage = 'eng';
        if(component.get("v.language") != undefined && component.get("v.language") != null &&
           component.get("v.language") != ''){
            selectedlanguage = component.get("v.language");
        }

        let action = component.get("c.saveAndNextTransactionTracking");
    	action.setParams({
            lstStudentQuestions : studentQuestions,
            studentId : component.get("v.contactId"),
            language : selectedlanguage, 
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                helper.goNext(component, event, helper);

            }else if (state === "ERROR") {
                let errors = response.getError();
                let errmsg = "";
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
            helper.hidespinner(component);
        });
        $A.enqueueAction(action); 
    },

    handleStudentChangedDetails : function(component,event){        
        var params = event.getParams();
        
        if (params) {
            var fieldIdentifier = params.fieldIdentifier;
            var fieldValue = params.fieldValue;
            console.log('Recieved Fiedl identifier : '+fieldIdentifier);
            console.log('Recieved Fidl Value : '+fieldValue);
            
            var quesList = component.get('v.questions')
            quesList.forEach(element => {
                if(element.questionId === fieldIdentifier){
                    element.answerId=''; // we have to look into this?
                    element.contactFieldChangedValue=fieldValue;
                }
            });
            component.set('v.questions',quesList);
            debugger
        }

    }
    
})