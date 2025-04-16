({
	retrieveStudentData : function(component, event, helper) {
        helper.showspinner(component);
        let selectedlanguage = 'English';
        if(component.get("v.language") != undefined && component.get("v.language") != null &&
           component.get("v.language") != ''){
            selectedlanguage = component.get("v.language");
        }
        
        if(selectedlanguage == 'Hindi'){
            component.set("v.SelfAwarenessHeader","छात्र जनसांख्यिकी");
            component.set("v.CareerAwarenessHeader","शिक्षा और अगला चरण");
            component.set("v.ParentSupportHeader","कार्य की स्थिति");
            component.set("v.CareerPlanningHeader","करियर प्लैनिंग/करियर की योजना");
            component.set("v.questionrequiredmsg","सभी प्रश्न आवश्यक हैं।");
            component.set("v.othertextrequiredmsg","कृपया अन्य मान निर्दिष्ट करें!");
            component.set("v.errortext","त्रुटि!");
            component.set("v.savenextbtn","आगे बढ़ें");
            component.set("v.previousbtn","पिछला");
            component.set("v.submitbtn","सबमिट/दर्ज करें");
            component.set("v.careerheader","करियर");
            component.set("v.qualificationheader","योग्यताए");

            component.set("v.popUpModalMessage",'सबमिट करने पर फॉर्म में बदलाव सेव हो जाएंगे। क्या आप आगे बढ़ना चाहते हैं ?');
            component.set("v.popUpYesBtnLabel","हाँ");
            component.set("v.popUpNoBtnLabel","नहीं");
            component.set("v.popUpFinalPageMessage"," आपके उत्तर के लिए धन्यवाद। करियर के बारे में अधिक जानकारी के लिए इस लिंक पर करियर चैटबॉट देखें।");  
        }
        else if(selectedlanguage == 'Marathi'){
            component.set("v.SelfAwarenessHeader","विद्यार्थी लोकसंख्याशास्त्र");
            component.set("v.CareerAwarenessHeader"," शिक्षण आणि पुढील पायऱ्या");
            component.set("v.ParentSupportHeader","नोकरी संभंदीत");
            component.set("v.CareerPlanningHeader","करिअर नियोजन");
            component.set("v.questionrequiredmsg","सर्व प्रश्न आवश्यक आहेत.");
            component.set("v.othertextrequiredmsg","कृपया इतर मूल्ये निर्दिष्ट करा!");
            component.set("v.errortext","त्रुटी!");
            component.set("v.savenextbtn","सेव करा आणि पुढे जा");
            component.set("v.previousbtn","मागील");
            component.set("v.submitbtn","प्रस्तुत करा");
            component.set("v.careerheader","करिअर");
            component.set("v.qualificationheader","पात्रता");

            component.set("v.popUpModalMessage",'फॉर्ममधील बदल सबमिट केल्यावर सेव्ह केले जातील. तुम्हाला पुढे जायचे आहे का?');
            component.set("v.popUpYesBtnLabel","होय");
            component.set("v.popUpNoBtnLabel","नाही");
            component.set("v.popUpFinalPageMessage"," तुमच्या उत्तराबद्दल धन्यवाद. करिअरच्या अधिक माहितीसाठी या लिंकवर करिअर चॅटबॉटला भेट द्या.");
        }
        else if(selectedlanguage == 'Urdu'){
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

            //Todo : for urdu lang
            // component.set("v.popUpModalMessage",'फॉर्ममधील बदल सबमिट केल्यावर सेव्ह केले जातील. तुम्हाला पुढे जायचे आहे का?');
            // component.set("v.popUpYesBtnLabel","अपना उत्तर यहाँ लिखें");
            // component.set("v.popUpNoBtnLabel","एक विकल्प चुने");
            // component.set("v.popUpFinalPageMessage","एक विकल्प चुने");
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
                
                if(result != null && result != undefined){
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
        let existingQuestionList = component.get("v.questions");
        for(var key in questionsMap){
            if(questionsMap[key].key == pageNumber){
                questionSectionWise.push(questionsMap[key].value);
            }
        }

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
        helper.loadQuestionPerPage(component, event, helper, component.get("v.endPage"));
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
        //TODO : Enable Validation Once The Complete development of Form is done.

        if(!helper.isValidSection(component)){
            helper.showMessage(component, event, component.get("v.questionrequiredmsg"), component.get("v.errortext"), "error");
            return;
        } 
        
        if(!helper.otherValidation(component,event,helper)){
            return;
        }
        
        helper.showspinner(component);


     //CUSTOM CODE :
        var currentPage = component.get('v.startPage');
        var studentQuestionMap = Array.from(component.get("v.StudentQuestions")); 
        var filteredMap =  studentQuestionMap.filter(element =>{
            if(element.key !== currentPage){
                return element;
            }
        });
        
        var questionsList = component.get('v.questions');
        for(var key in questionsList){
            filteredMap.push({key: questionsList[key].sectionNumber, value: questionsList[key]});
        }
        component.set("v.StudentQuestions",filteredMap);
        debugger;
     //TILL HERE
        
        helper.goNext(component, event, helper);      
        helper.hidespinner(component);    
    },
    convertListToMapQuestions : function(component, event, helper, lstQuestions) {
		let allQuestions = lstQuestions;
        var questionsMap = [];
        var section4n5QuestionMap = [];
        var sectionNumberArray = [];
        for(var key in allQuestions){
            //CUSTOMCODE: If Section 4 and 5 Save them in a new Map
            if(allQuestions[key].sectionNumber == 4 || allQuestions[key].sectionNumber == 5){
                section4n5QuestionMap.push({key: allQuestions[key].sectionNumber, value: allQuestions[key]});
            }else{
                questionsMap.push({key: allQuestions[key].sectionNumber, value: allQuestions[key]});
            
                if(sectionNumberArray.indexOf(allQuestions[key].sectionNumber) === -1) {
                    sectionNumberArray.push(allQuestions[key].sectionNumber);
                }
            }
        }

        component.set("v.StudentQuestions",questionsMap);
        component.set("v.StudentQuestionsSectionAnB",section4n5QuestionMap);
        
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
            // if(o.fieldType != 'Label'){ //OMIT
            //CUSTOMCODE : If AnswerId and contactFieldAnswer both are null or blank then do validation.
                if(!o.isdependentquestion && ((o.answerId == undefined || o.answerId == null || o.answerId == '')
                    &&(o.contactFieldAnswer == undefined || o.contactFieldAnswer == null || o.contactFieldAnswer == '')
                    &&(o.otherAnswer == undefined || o.otherAnswer == null || o.otherAnswer == '')
                    )
                ){
                    isValid = false;
                }else{
                    if(o.isdependentquestion && o.isdependentquestionshow 
                        && (o.answerId == undefined || o.answerId == null || o.answerId == '') 
                        && (o.otherAnswer == undefined || o.otherAnswer == null || o.otherAnswer == '') 
                        ){
                        isValid = false;
                    }
                }
            //TILL HERE...
			// } //OMIT
		});
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
                if(o.isCareerOption 
                    && (o.otherAnswerDescription == '' || o.otherAnswerDescription == null)
                    && (o.iDontKnowAnswerDescription == null || o.iDontKnowAnswerDescription == '')){
                    
                    isRequiredOtherValues = true;
                    isValid = false;
                }else{
                    if((o.isDisplayOtherOption && (o.otherAnswerDescription == '' || o.otherAnswerDescription == null)) ||
                        (o.isDisplayIdontKnowOption && (o.iDontKnowAnswerDescription == null || o.iDontKnowAnswerDescription == ''))
                        ){
                        isRequiredOtherValues = true;
                        isValid = false;
                    }
                }
        	}

        //TODO : Add Custom Validation for rest ....
            if(o.validationPresent){
                //TODO : Add QuestionIds and check validations.
                //TODO : If no Regex pattern for validation then harcode the Validation Criteria like below example

                if(!o.isValidComponent){
                    let message = o.validationErrorMessage;
                    helper.showMessage(component, event, message, component.get("v.errortext"),'error');
                    isValid = false;
                }

            }
        //TILL HERE ....

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
            TotalSize: totalPage 
        });
        appEvent.fire();
    },



    //CUSTOMCODE : Creates the Trasition Tracking details for every Question and Answers and Insert it into new Transition Tracking Record.    
    saveTransitionTracking: function(component,event, helper){
        //TODO : Enable Validation Once The Complete development of Form is done.
        
        helper.showspinner(component);

        var studentQuestionMap = component.get("v.StudentQuestions");
        var studentQuestions = [];
        
        for(var key in studentQuestionMap){
            studentQuestions.push(studentQuestionMap[key].value);
        }
        debugger;
        let selectedlanguage = 'eng';
        if(component.get("v.language") != undefined && component.get("v.language") != null &&
           component.get("v.language") != ''){
            selectedlanguage = component.get("v.language");
        } 

        let action = component.get("c.saveTransitionTrackingRecord");
    	action.setParams({
            lstStudentQuestions : studentQuestions,
            studentId : component.get("v.contactId"),
            language : selectedlanguage 
        });

        action.setCallback(this, function(response){
            let state = response.getState();
            
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result != null && result != undefined){
                                 
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
        });
        $A.enqueueAction(action); 

        helper.hidespinner(component);
    },





    //CUSTOMCODE : Dynamically Handling the Dependency of Questions.
    helperHandleQuestionData : function(component,event, helper){
        var params = event.getParam('arguments');            
        var lst = component.get("v.questions");
        
        if(params.fieldType == 'RadioGroup'||params.fieldType == 'Picklist'){
            if(params.questionid != undefined && params.questionid != null){            
             //CUSTOMCODE : DEPENDENCY AND TOGGLING CODE
                lst.forEach(quest=>{
                    //If Main Question
                    if(quest.questionId === params.basequestionid){
                        quest.lstWrpStudentAnswer.forEach(answer=>{
                            if(answer.answerId === params.answerLabel){
                                if(answer.questionsToHide){
                                    var hideQnsLst = answer.questionsToHide.split(";");                                
                                    lst.forEach(innerQuest=>{
                                        if(hideQnsLst.includes(innerQuest.questionId)){
                                            innerQuest.isdependentquestionshow = false;
                                            innerQuest.answerId = ''; 
                                            innerQuest.otherAnswer='';
                                            innerQuest.isshowtextarea=false 
                                            innerQuest.otherAnswerDescription='';
                                            innerQuest.iDontKnowAnswerDescription='';
                                        }    
                                    });
                                }
                            }
                        });
                    }
                    //If Dependent Question
                    else if(quest.questionId === params.questionid && params.answerLabel){
                        quest.isdependentquestionshow = true;
                        //so that we can add new Values then the Dependent Question is Active
                        quest.answerId = ''; 
                        quest.otherAnswer='';
                        // quest.otherAnswerDescription='';    //TODO : Future Requirement
                        // quest.iDontKnowAnswerDescription=''; //TODO : Future Requirement

                        //For Making The Submit and Next button toggle for section 3 and The also changing above Progress Bar
                        if(quest.sectionNumber === 3){
                            component.set("v.totalPages",component.get("v.startPage")); 
                            helper.handleProgressBarEvent(component,component.get("v.startPage"),component.get("v.totalPages")); //DIDTODAY
                        }
                        
                        //Clearing Checkbox Already ticked Values
                        if(quest.fieldType === 'CheckboxGroup'){
                            const cmps = component.find('cleartTest');
                            if(cmps){
                                if ($A.util.isArray(cmps)) {
                                    cmps.forEach(child =>{
                                      child.doClearMultipleAnswer(quest.questionId);
                                    }); 
                               	}else{
                                      cmps.doClearMultipleAnswer(quest.questionId);  
                               	}
                            }
                        }

                    }
                });
             //TILL HERE ...    


            }else if(params.basequestionid != undefined && params.basequestionid != null){

                //CUSTOMCODE : Section Toggling code
                lst.forEach(quest=>{
                    //Section Toggling is based on section 3
                    if(quest.questionId === params.basequestionid && quest.sectionNumber === 3){
                        quest.lstWrpStudentAnswer.forEach(answer=>{
                            if(answer.answerId === params.answerLabel){
                                
                                var filteredMap = component.get("v.StudentQuestions").filter(element =>{
                                    if(element.key !== 4){
                                        return element;   //Clearing the Map if it has Section 4 questions
                                    }
                                });
                                component.set("v.StudentQuestions",filteredMap);

                                var newMapLast = [];
                                var filteredSectionMap = [];
                                var fetchedSectionMap = JSON.parse(JSON.stringify(component.get("v.StudentQuestionsSectionAnB")));

                                if(answer.sectionToShow > 0){
                                    if(answer.sectionToShow === 4){                
                                        filteredSectionMap = fetchedSectionMap.filter(element =>{
                                           if(element.key == 4){
                                               return element;
                                           }
                                       });
                   
                                        newMapLast = [...Array.from(component.get("v.StudentQuestions")), ...Array.from(filteredSectionMap)];                
                                   }   
                                   else if(answer.sectionToShow === 5){                                    
                                        filteredSectionMap = fetchedSectionMap.filter(element =>{
                                           if(element.key == 5){
                                               element.key = 4;
                                               return element;
                                           }
                                       });
                                        newMapLast = [...Array.from(component.get("v.StudentQuestions")), ...Array.from(filteredSectionMap)];                                    
                                   }
                                   
                                   component.set("v.StudentQuestions",newMapLast);
                                   component.set("v.totalPages",component.get("v.startPage")+1);
                                   helper.handleProgressBarEvent(component,component.get("v.startPage"),component.get("v.totalPages")); //DIDTODAY
                                }else{
                                    component.set("v.StudentQuestions",filteredMap);
                                    component.set("v.totalPages",component.get("v.startPage"));   //TODO :Remove this line in future if not needed because it makes Next btn to Submit
                                    helper.handleProgressBarEvent(component,component.get("v.startPage"),component.get("v.totalPages")); //DIDTODAY
                                }

                                                                
                            }
                        });
                    }
                });
            //TILL HERE .....


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
                            l.otherAnswer='';  //ADDED NOW : To blank the Text input on toggling of  Question.
                            l.isshowtextarea=false //ADDED NOW : : To Hide the TextBox on toggling of  Question.
                            l.otherAnswerDescription='';//ADDED NOW : To blank the TextBox on toggling of  Question.
                            l.iDontKnowAnswerDescription='';//ADDED NOW : : To blank the TextBox on toggling of  Question.
                        }
                    });
                });
            }
            
            var pageNumber = component.get("v.startPage");
                var counter = 1;
                lst.forEach(m => {
                    if(!m.isdependentquestion){
                        m.displayNumber = counter;
                        counter++;
                    }else{
                        if((m.isdependentquestion && m.isdependentquestionshow)){
                            m.displayNumber = counter;
                            counter++;
                        }
                    }
                });
            component.set("v.questions",lst);
            debugger; 
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



    }
    

})