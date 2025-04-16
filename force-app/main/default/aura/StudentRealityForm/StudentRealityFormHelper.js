({
	retrieveStudentData : function(component, event, helper) {
		let action = component.get("c.fetchStudentQuestionsAndAnswers");
        action.setParams({
            testName: 'Reality',
            strLanguage: component.get("v.language"),
            contactId: component.get("v.contactId"),
            currentPage: 'R'
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS"){
                let result = response.getReturnValue();
                
                if(result.PageExist){
                    var address = window.location.origin+'/iar/s/result?contactId='+component.get("v.contactId")+'&req=R&len='+component.get("v.language");
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": address
                    });                
                    urlEvent.fire();
                } else {
                    if(result.data != null && result.data != undefined){
                        component.set("v.StudentQuestions",result.data.lstWrpStudentQuestion);
                        component.set("v.Student",result.data.objContact);
                        
                        let totalQuestions = component.get("v.StudentQuestions").length;
                        let totalPage = Math.ceil(totalQuestions/8);
                        
                        helper.handleProgressBarEvent(component,1,totalPage);
                        helper.loadDataOnFirstPage(component);
                    } else {
                        var address = window.location.origin+'/iar/s/result?contactId='+component.get("v.contactId")+'&req=R&len='+component.get("v.language");
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
    saveOnNext : function(component, event, helper){
        
        helper.showspinner(component);
        debugger;
        let action = component.get("c.saveTemporaryStudentIAR");
    	action.setParams({
            temporaryStudentQuestions : component.get("v.StudentQuestions"),
            contactId : component.get("v.contactId"),
            actionName : 'submit',
            submittedPage : 'R;',
            submittedPageName: '04. Reality'
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS"){
                var address = window.location.origin+'/iar/s/result?contactId='+component.get("v.contactId")+'&req=R&len='+component.get("v.language");
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
            helper.hidespinner(component);
        });
        $A.enqueueAction(action);        
    },
    goNext : function(component, event){
        
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
        
        let currentPage = Math.ceil(end/8);
        let totalPage = Math.ceil(allQuestions.length/8);
        this.handleProgressBarEvent(component,currentPage,totalPage);
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
        let totalPage = Math.ceil(allQuestions.length/8);
        this.handleProgressBarEvent(component,currentPage,totalPage);
    },
    
    loadDataOnFirstPage : function(component){
        var pageSize = component.get("v.pageSize");
        var allQuestions = component.get("v.StudentQuestions");
        component.set("v.totalRecords", allQuestions.length);
        component.set("v.startPage",0);
        component.set("v.endPage",pageSize-1);
        
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
            TotalSize: totalPage
        });
        appEvent.fire();
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
    showspinner: function(component) {
        component.set("v.show",true);        
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
})