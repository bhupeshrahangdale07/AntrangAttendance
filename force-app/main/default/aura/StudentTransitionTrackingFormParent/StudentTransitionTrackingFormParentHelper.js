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
                    o.lstWrpStudentAnswer.forEach(l => {
                        if(l.isShowOtherOption 
                            && (o.otherAnswerDescription == '' || o.otherAnswerDescription == null)
                            &&(o.iDontKnowAnswerDescription == null || o.iDontKnowAnswerDescription == '')){
                            isRequiredOtherValues = true;
                            isValid = false;
                        }
                    });
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
            // TotalSize: totalPage + 1 //OMIT : Beacuse we need only those Sections That we Mentioned in Record (Till Now Requirement).
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





    //CUSTOMCODE : Statically Handling the Dependency of Questions.
    helperHandleQuestionData : function(component,event, helper){
        var params = event.getParam('arguments');
            
        var lst = component.get("v.questions");
        
        if(params.fieldType == 'RadioGroup'||params.fieldType == 'Picklist'){
            if(params.questionid != undefined && params.questionid != null){            
            //TODO : DEPENDENCY WORK 

            //SECTION 2 : DEPENDENCY :             
                //Do You Pass 10th class & YES
                if(params.basequestionid=="a1f1m000000ybVmAAI" && params.answerLabel == 'a1g1m000001FB0nAAG'){
                    lst.forEach(quest=>{
                        if(quest.questionId === params.questionid && quest.questionId === 'a1f1m0000012RBvAAM'){
                            quest.isdependentquestionshow = true;
                        }else if(quest.questionId === 'a1f1m0000012RC0AAM'     //Hiding First Level
                                || quest.questionId === 'a1f1m0000012RCAAA2'){ //Hiding Second Level
                                quest.isdependentquestionshow = false;
                                quest.answerId = ''; //Making Sure that all their Selected Answer are Reset when the respective questions are hidden
                                quest.isshowtextarea=false //ADDED NOW : To Hide the TextBox on toggling of Dependent Question.
                                quest.otherAnswerDescription='';//ADDED NOW : To blank the TextBox on toggling of Dependent Question.
                                quest.iDontKnowAnswerDescription='';//ADDED NOW : To blank the TextBox on toggling of Dependent Question.
                        }
                    });
                }
                //Do You Pass 10th class & NO
                else if(params.basequestionid=="a1f1m000000ybVmAAI" && params.answerLabel == 'a1g1m000001FB0sAAG'){
                    lst.forEach(quest=>{
                        if(quest.questionId === params.questionid && quest.questionId === 'a1f1m0000012RC0AAM'){
                            quest.isdependentquestionshow = true;
                        }else if(quest.questionId === 'a1f1m0000012RBvAAM'  //Hiding First Level
                            || quest.questionId === 'a1f1m0000012RC5AAM' || quest.questionId === 'a1f1m0000012RCAAA2' //Hiding Second Level
                            || quest.questionId === 'a1f1m0000012RCKAA2'){   //Hiding third level
                            quest.isdependentquestionshow = false;
                            quest.answerId='';   //CUSTOMCODE : Making Sure that all their Selected Answer are Reset when the respective questions are hidden
                            quest.otherAnswer=''; //Making the User Entered Value for Qn {Which city is the school/college } blank
                            quest.isshowtextarea=false //ADDED NOW : To Hide the TextBox on toggling of Dependent Question.
                            quest.otherAnswerDescription='';//ADDED NOW : To blank the TextBox on toggling of Dependent Question.
                            quest.iDontKnowAnswerDescription='';//ADDED NOW : To blank the TextBox on toggling of Dependent Question.
                        }
                    });
                }


                //Are you pursuing education and YES
                else if(params.basequestionid=="a1f1m0000012RBvAAM" && params.answerLabel == 'a1g1m000001NMC9AAO'){
                    lst.forEach(quest=>{
                        if(quest.questionId === params.questionid && quest.questionId === 'a1f1m0000012RC5AAM'){
                            quest.isdependentquestionshow = true;
                        }else if(quest.questionId === 'a1f1m0000012RCAAA2'){
                            quest.isdependentquestionshow = false;
                            quest.answerId = '';
                            quest.isshowtextarea=false //ADDED NOW : To Hide the TextBox on toggling of Dependent Question.
                            quest.otherAnswerDescription='';   //ADDED NOW : To blank the TextBox on toggling of Dependent Question.
                            quest.iDontKnowAnswerDescription='';   //ADDED NOW : To blank the TextBox on toggling of Dependent Question.                
                        }
                    });
                }
                //Are you pursuing education and NO
                else if(params.basequestionid=="a1f1m0000012RBvAAM" && params.answerLabel == 'a1g1m000001NMCXAA4'){
                    lst.forEach(quest=>{
                        if(quest.questionId === params.questionid && quest.questionId === 'a1f1m0000012RCAAA2'){
                            quest.isdependentquestionshow = true;
                        }else if(quest.questionId === 'a1f1m0000012RC5AAM' || quest.questionId === 'a1f1m0000012RCKAA2'){
                            quest.isdependentquestionshow = false;
                            quest.answerId = '';
                            quest.otherAnswer=''; //Making the User Entered Value for Qn {Which city is the school/college } blank
                        }
                    });
                }

                //If yes, then have you applied for admission in any school/college AND YES
                else if(params.basequestionid=="a1f1m0000012RC5AAM" && params.answerLabel == 'a1g1m000001NMCmAAO'){
                    lst.forEach(quest=>{
                        if(quest.questionId === params.questionid && quest.questionId === 'a1f1m0000012RCKAA2'){
                            quest.isdependentquestionshow = true;
                        }
                    });
                }

                //Would you like to attempt the 10th Board Exam again? AND  NO
                else if(params.basequestionid=="a1f1m0000012RC0AAM" && params.answerLabel == 'a1g1m000001NMCdAAO'){
                    lst.forEach(quest=>{
                        if(quest.questionId === params.questionid && quest.questionId === 'a1f1m0000012RCAAA2'){
                            quest.isdependentquestionshow = true;                            
                        }
                    });
                }

            //END OF SECTION 2 DEPENDENCY ============================= 
            
            
            //SECTION 3 : DEPENDENCY :  

                //Have you started working? AND Option-> 3/4/5 .
                else if(params.basequestionid=="a1f1m0000012RgZAAU" && 
                        (params.answerLabel == 'a1g1m000001NSG7AAO' ||params.answerLabel == 'a1g1m000001NSGCAA4' || params.answerLabel == 'a1g1m000001NSGHAA4' )){
                    lst.forEach(quest=>{
                        if(quest.questionId === params.questionid && quest.questionId === 'a1f1m0000012RgjAAE'){
                            quest.isdependentquestionshow = true;
                            quest.otherAnswer='';
                        }
                    });
                    component.set("v.totalPages",component.get("v.startPage")); //For Making The Submit and Next button toggle for section 3
                }

              //END OF SECTION 3 DEPENDENCY ============================= 



            //SECTION 4 : DEPENDENCY :  

            //How did you find out about the job?  AND Throunh Company Website(i.e. option 3)
            else if(params.basequestionid=="a1f1m0000012S0cAAE" && params.answerLabel == 'a1g1m000001NmopAAC'){
                lst.forEach(quest=>{
                    if(quest.questionId === params.questionid && quest.questionId === 'a1f1m0000012S0mAAE'){
                        quest.isdependentquestionshow = true;
                    }
                });
            }

            //END OF SECTION 4 DEPENDENCY ============================= 
                 


           //SECTION 5 : DEPENDENCY :  

            //Do you need assistance in finding a job/setting up a business? AND YES .
            else if(params.basequestionid=="a1f1m0000012S1pAAE" && params.answerLabel == 'a1g1m000001NnbeAAC'){
                lst.forEach(quest=>{
                    if(quest.questionId === params.questionid && quest.questionId === 'a1f1m0000012S1uAAE'){
                        quest.isdependentquestionshow = true;
                    }
                });
            }

            //What type of job do you want? AND Option 3 or 5
            else if(params.basequestionid=="a1f1m0000012S1kAAE" && (params.answerLabel == 'a1g1m000001NnbPAAS' || params.answerLabel == 'a1g1m000001NnbGAAS')){
                lst.forEach(quest=>{
                    if(quest.questionId === params.questionid && quest.questionId === 'a1f1m0000012S1zAAE'){
                        quest.isdependentquestionshow = true;
                    }
                });
            }

            //END OF SECTION 5 DEPENDENCY =============================  



                    
            }else if(params.basequestionid != undefined && params.basequestionid != null){

            //TODO : CODE FOR TOGGLING Dendency SECTION A & SECTION B
                //Have you started working & YES -> Show Section A i.e. 4
                if(params.basequestionid=="a1f1m0000012RgZAAU" && params.answerLabel == 'a1g1m000001NSFxAAO'){

                    var filteredMap = component.get("v.StudentQuestions").filter(element =>{
                        if(element.key !== 4){
                            return element.value;     //Clearing the Map if it has Section 4 questions
                        }
                    });
                    component.set("v.StudentQuestions",filteredMap);

                    var fetchedSectionMap = JSON.parse(JSON.stringify(component.get("v.StudentQuestionsSectionAnB")));
                    var filteredSectionMap = fetchedSectionMap.filter(element =>{
                        if(element.key == 4){
                            return element;
                        }
                    });

                    var newMapLast = [...Array.from(component.get("v.StudentQuestions")), ...Array.from(filteredSectionMap)];

                    component.set("v.StudentQuestions",newMapLast);
                    component.set("v.totalPages",component.get("v.startPage")+1);                    
                }
                
                //Have you started working & NO -> Show Section B i.e. 5
                else if(params.basequestionid=="a1f1m0000012RgZAAU" && params.answerLabel == 'a1g1m000001NSG2AAO'){
                    var filteredMap = component.get("v.StudentQuestions").filter(element =>{
                        if(element.key !== 4){
                            return element;
                        }
                    });
                    component.set("v.StudentQuestions",filteredMap);
                    
                    var fetchedSectionMap =JSON.parse(JSON.stringify(component.get("v.StudentQuestionsSectionAnB")));
                    var filteredSectionMap = fetchedSectionMap.filter(element =>{
                        if(element.key == 5){
                            element.key = 4;
                            return element;
                        }
                    });
                    var newMapLast = [...Array.from(component.get("v.StudentQuestions")), ...Array.from(filteredSectionMap)];
                    
                    component.set("v.StudentQuestions",newMapLast);
                    component.set("v.totalPages",component.get("v.startPage")+1);
                }

                //Have you started working & Any other Options
                else if(params.basequestionid == "a1f1m0000012RgZAAU" 
                        && (params.answerLabel != 'a1g1m000001NSG2AAO' || params.answerLabel != 'a1g1m000001NSFxAAO') //ADDED NOW
                            && !params.answerLabel){
                        var filteredMap = component.get("v.StudentQuestions").filter(element =>{
                            if(element.key !== 4 || element.key !== 5){
                                return element;
                            }
                    });
                    component.set("v.StudentQuestions",filteredMap);
                    component.set("v.totalPages",component.get("v.startPage"));
                }

            //END OF SECTION 4 And 5 ========


                var lstremove = [];
                lst.forEach(o => {
                    if(o.questionId == params.basequestionid){
                        o.lstWrpStudentAnswer.forEach(w => {
                            if(w.dependentquestion != undefined){
                                lstremove.push(w.dependentquestion);	
                            }   
                        });
                    }
                    // if(o.questionId == ) //LEFT
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
            //COMMENTED OUT:
            //if(pageNumber == 1){
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
            // }
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

        //TODO :DONENOW
        //TODO : Add else if for Label type

        //CUSTOMCODE : to fetch the changed Contact Api Field Values.
        // else if(params.fieldType == 'Label' || params.fieldType == 'Numeric' || params.fieldType == 'Text' ){
        //     debugger;
        //     lst.forEach(quest=>{
        //         if(params.basequestionid === quest.questionId){
        //             if((quest.contactFieldAnswer.trim() !== '')&&params.fieldType == 'Label'){
        //                 quest.contactFieldAnswer = params.answerLabel;
        //             }else if(params.fieldType == 'Numeric' ||  params.fieldType == 'Text'){
        //                 quest.otherAnswer = params.answerLabel;
        //             }
        //         }
        //     });            
        //     debugger;
        //     component.set("v.questions",lst);
        // }
    //TILL HERE ....

    }
    

})