({
	retrieveStudentData : function(component, event, helper) {
		let action = component.get("c.fetchStudentQuestionsAndAnswers");
        action.setParams({
            testName: 'Aptitude',
            strLanguage: component.get("v.language"),
            contactId: component.get("v.contactId"),
            currentPage: 'A'
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS"){
                let result = response.getReturnValue();
                
                if(result.PageExist){
                	var address = window.location.origin+'/iar/s/result?contactId='+component.get("v.contactId")+'&req=A&len='+component.get("v.language");
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": address
                    });                
                    urlEvent.fire();
                } else {
                    if(result.data != null && result.data != undefined){
                        component.set("v.StudentQuestions",result.data.lstWrpStudentQuestion);
                        component.set("v.Student",result.data.objContact);
                        
                        debugger;
                        let totalQuestions = component.get("v.StudentQuestions").length;
                        let totalPage = Math.ceil(totalQuestions/component.get("v.pageSize"));
                        
                        helper.handleProgressBarEvent(component,1,totalPage);
                        helper.loadDataOnFirstPage(component);
                        
                        var cookiedata = JSON.stringify(document.cookie);
                        var totalDuration = 10;
                        
                        if(parseInt(cookiedata.split('; ')[0].split('=')[1]) == parseInt(component.get("v.startPage")) &&
                           cookiedata.split('; ')[1].split('=')[1] == 'Aptitude' && cookiedata != ''){
                            totalDuration = cookiedata.split('; ')[2].split('=')[1].slice(0, -1);
                        } 
                        
                        var childEvent = $A.get("e.c:ChildTimerEvent");
                        childEvent.setParams({
                            "totalDuration" : totalDuration,
                            "usedTime" : "00", 
                            "remaingTime" : "00"
                        });
                        childEvent.fire();
                    } else {
                        var address = window.location.origin+'/iar/s/result?contactId='+component.get("v.contactId")+'&req=A&len='+component.get("v.language");
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": address
                    });                
                    urlEvent.fire();
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
        });
        $A.enqueueAction(action);
	},
    
    saveOnNext : function(component, event, helper, actionName, clicked){
        if(!helper.isValidSection(component)){
            if(clicked == 'n'){
                helper.showMessage(component, event, 'All Questions are required.', "Error!", "error");
                return;
            } else if(clicked == 't'){
                helper.showMessage(component, event, 'Time is up. Next Section.', "Error!", "error");
                //return;
            }
        }
        
        
        let action = component.get("c.saveTemporaryStudentIAR");
    	action.setParams({
            temporaryStudentQuestions : component.get("v.StudentQuestions"),
            contactId : component.get("v.contactId"),
            actionName : actionName,
            submittedPage : 'A;',
            submittedPageName: '03. Aptitude'
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS"){
                if(actionName == 'next'){
                    var result = response.getReturnValue();
                    
                    if(result != null && result != undefined){
                        component.set("v.StudentQuestions",result);
                        helper.goNext(component, event, helper);
                    }
                }else{
                    var address = window.location.origin+'/iar/s/result?contactId='+component.get("v.contactId")+'&req=A&len='+component.get("v.language");
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": address
                    });                
                    urlEvent.fire();
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
    },
    
    goNext : function(component, event, helper){
        
        var allQuestions = component.get("v.StudentQuestions");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        
        for(var i=end+1; i<end+pageSize+1; i++){
            if(allQuestions.length > i){
                Paginationlist.push(allQuestions[i]);
            }
            counter ++ ;
        }
        
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.questions', Paginationlist);
        let currentPage = Math.ceil(end/9);
        let totalPage = Math.ceil(allQuestions.length/9);
        this.handleProgressBarEvent(component,currentPage,totalPage);
        var totalDuration = 10;
        var childEvent = $A.get("e.c:ChildTimerEvent");
        childEvent.setParams({
            "totalDuration" : totalDuration,
            "usedTime" : "00", 
            "remaingTime" : "00"
        });
        childEvent.fire();
    },
    
    goPrevious : function(component, event){
        var allQuestions = component.get("v.StudentQuestions");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                Paginationlist.push(allQuestions[i]);
                counter ++;
            }else{
                start++;
            }
        }
        
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.questions', Paginationlist);
        
        let currentPage = Math.ceil(end/8);
        let totalPage = Math.ceil(allQuestions.length/9);
        this.handleProgressBarEvent(component,currentPage,totalPage);
    },
    
    loadDataOnFirstPage : function(component){
        var pageSize = component.get("v.pageSize");
        var allQuestions = component.get("v.StudentQuestions");
        component.set("v.totalRecords", allQuestions.length);
        component.set("v.startPage",0);
        component.set("v.endPage",pageSize-1);
        debugger;
        var PaginationList = [];
        for(var i=0; i< pageSize; i++){
            if(allQuestions.length > i)
                PaginationList.push(allQuestions[i]);    
        }
        component.set('v.questions', PaginationList);
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
    
    handleProgressBarEvent : function(component,currentPage, totalPage){
        let appEvent = $A.get("e.c:LIProgressBarEvent");
        appEvent.setParams({
            CurrentNumber: currentPage,
            TotalSize: totalPage + 1
        });
        appEvent.fire();
    },
    
    saveAndSubmitExam: function (component, event, helper){
        let action = component.get("c.submitExam");
    	action.setParams({
            finalStudentQuestions : component.get("v.StudentQuestions"),
            currentUserId: component.get("v.contactId")
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            
            if(state === "SUCCESS"){
                var address = window.location.origin+'/iar/s/result';
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": address
                });                
                urlEvent.fire();
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
    },
    
    isValidSection : function (component) {
        let allQuestions = component.get("v.questions");
        var isValid = true;
        allQuestions.forEach(o => {
            if(o.fieldType != 'Label'){
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
		return isValid;
    },
        
        showspinner: function(component) {
        component.set("v.show",true);        
    },
        
        showHideSpinner : function(component) {
        var showValue = component.get('v.show');
        
        if(showValue) {
            console.log('showValue'+showValue);
            var spinner = component.find("spinner");
            console.log('spinner'+spinner);
        	$A.util.removeClass(spinner, "slds-hide");
        } else {
            console.log('showValue'+showValue);
            var spinner = component.find("spinner");
            console.log('spinner'+spinner);
        	$A.util.addClass(spinner, "slds-hide");
        }
    },
        
        hidespinner: function(component) {
        window.setTimeout(
            function() {
                component.set("v.show",false);
            }, 1000
        );        
    },
    
})