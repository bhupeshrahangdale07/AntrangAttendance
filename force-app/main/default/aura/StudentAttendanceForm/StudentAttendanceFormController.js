({
    init: function (cmp, event, helper) {
        
    },
    
    showallsession: function (component, event, helper) {
        component.set("v.showAllSession", true);
        let BatchId =  component.get("v.selectedBatchId");
        if(BatchId != ''){
            let action = component.get("c.showAllStudentSessionData");
            action.setParams({
                batchId : BatchId,
                facilitatorId : component.get("v.FacilitatorId")
            });
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (response.getState() === "SUCCESS") {
                    let res = response.getReturnValue();
                    if(res.sessionData){
                        component.set("v.allSessionRecords",res.sessionData);
                        component.set("v.Allstudentdata",res.studentData);
                        helper.defaultSessionList(component, event, helper);
                    } else {
                        component.set("v.Spinner", false);
                        component.set("v.allSessionRecords",[]);
                        component.set("v.Allstudentdata",[]);
                    }
                } else if (response.getState() === "ERROR") {
                    let errors = response.getError();
                    let message = ""; // Default error message
                    if (errors && Array.isArray(errors) && errors.length > 0) {
                        message += errors[0].message;
                    }
                    helper.showMessageToast(component, event, helper, message, "error");
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    closeAllSessionModel: function (component, event, helper) {
        component.set("v.showAllSession", false);
    },
    
    checkemail: function (component, event, helper) {
        let stremail = component.get("v.traineremail");
        let validExpense = true;
        if (stremail == undefined || stremail == null || stremail == "") {
            validExpense = false;
            helper.showMessageToast(
                component,
                event,
                helper,
                "Enter trainer's email address!",
                "error"
            );
        }
        
        if (validExpense) {
            helper.checktraineremail(component, event, helper);
        }
    },
    
    onwrpEventUpdate: function (component, event, helper) {
        let sObject = event.getParam("sObject");
        
        if (sObject == "Account") {
            let accountId = event.getParam("AccountId");
            if(accountId != undefined && accountId != null && accountId.length >0){
                component.set("v.AccountId", accountId);
                let d = new Date();
                let yearToSub = d.getMonth() > 4 ? 1 : 2;
                let firstMay = d.getFullYear() - yearToSub +'-05-01';
                let nextYearApril = d.getFullYear() + yearToSub + '-04-30';
                component.set(
                    "v.StudentWhareClause",
                    " AND Facilitation_Start_Date__c >= "+firstMay+" AND Facilitation_Start_Date__c <= "+nextYearApril+" AND School_Name__c = '" + accountId + "' ORDER BY NAME"
                ); // AND day_only(Batch_Code__r.Date_of_facilitation_starting__c) >= 2020-05-01
                if(component.get("v.AccountId") != '' && component.get("v.selectedGrade") != ''){
                    helper.fetchBatchList(component, event, helper);
                }
            } else {
                component.set("v.studentMatrix",[]);
                component.set("v.selectedSession","");
                component.set("v.batchOptions",[]);
                component.set("v.sessionRecords",[]);
                component.set("v.selectedSession","");
                component.set("v.isBatchOption",true);
                component.set("v.isBatchSelected",true);
                component.set("v.batchSelected",false);
            }
        }
        
        if (sObject == "Batch__C") {
            let BatchId = event.getParam("BatchId");
            if(BatchId.length > 0 ){
                helper.sessionRecord(component, event, helper,BatchId);
            } else {
                //component.set("v.sessionRecords","");
                component.set("v.studentMatrix",component.get("v.tempstudentMatrix2"));
                
                component.set("v.selectedSession","");
                component.set("v.isBatchSelected",true);
            }
            
        }
        
        
        
    },
    
    handleClassChange: function (component, event, helper) {
        let selectedvalue =  component.get("v.selectedGrade");
        var studentmatrix = [];
        var matrix = component.get("v.tempstudentMatrix");
        if(selectedvalue != 'All'){
            matrix.forEach(s => {  if(s.className == selectedvalue){
                                 studentmatrix.push(s); }});
            component.set("v.studentMatrix",studentmatrix);
        }
        else{
            component.set("v.studentMatrix",matrix);
        }
        if(component.get("v.AccountId") != '' && component.get("v.selectedGrade") != ''){
            component.set("v.tempstudentMatrix2",[]);
            component.set("v.studentMatrix",[]);
            component.set("v.batchOptions",[]);
            component.set("v.sessionRecords",[]);
            component.set("v.selectedSession",false);
            component.set("v.batchSelected",false);
            helper.fetchBatchList(component, event, helper);
        }else{
            component.set("v.tempstudentMatrix2",[]);
            component.set("v.studentMatrix",[]);
            component.set("v.batchOptions",[]);
            component.set("v.sessionRecords",[]);
            component.set("v.selectedBatchId",'');
            component.set("v.isBatchOption",true);
            component.set("v.isBatchSelected",true);
            component.set("v.selectedSession",false);
            component.set("v.batchSelected",false);
            
        }
    },
    
    handleBatchChange: function (component, event, helper) {
        let BatchId =  component.get("v.selectedBatchId");
        if(BatchId != '' ){
            
            component.set("v.studentMatrix",[]);
            component.set("v.tempstudentMatrix2",[]);
            component.set("v.sessionRecords",[]);
            component.set("v.selectedSession","");
            component.set("v.isBatchSelected",false);
            component.set("v.batchSelected",false);
            helper.sessionRecord(component, event, helper,BatchId);
        } else {
            //component.set("v.sessionRecords","");
            component.set("v.tempstudentMatrix2",[]);
            component.set("v.studentMatrix",[]);
            component.set("v.sessionRecords",[]);
            component.set("v.selectedSession","");
            component.set("v.isBatchSelected",true);
            component.set("v.batchSelected",false);
            component.set("v.selectedSession",false);
            component.set("v.batchSelected",false);
        }
    },
    
    showSpinner: function (component, event, helper) {
        // make Spinner attribute true for display loading spinner
        component.set("v.Spinner", true);
    },
    
    // this function automatic call by aura:doneWaiting event
    hideSpinner: function (component, event, helper) {
        // make Spinner attribute to false for hide loading spinner
        component.set("v.Spinner", false);
    },
    
    handleSessionChange: function (component, event, helper) {
        //debugger;
        var sessionLST = [];
        if(component.get("v.selectedSession") == 'All'){
            var sess = component.get("v.sessionRecords");
            sess.forEach(s => {
                if(s.label != 'All'){
                sessionLST.push(s.value);
            } 
                         });
        } else if(component.get("v.selectedSession") == ''){
            //component.set("v.sessionRecords",[]);
            //component.set("v.sessWithPreSessSubmitedAtt",new Map());
            component.set("v.studentMatrix",[]);
                component.set("v.selectedSession","");
            
        }else {
            var sess = component.get("v.sessionRecords");
            
            sess.forEach(s => {
                if(s.value == component.get("v.selectedSession")){
                component.set("v.singleSession",s.label);
            } 
                         });
            sessionLST.push(component.get("v.selectedSession"));
        }
        if(component.get("v.sessWithPreSessSubmitedAtt") != undefined ){
            //var sessWithPreSessAtt = component.get("v.sessWithPreSessSubmitedAtt");
            let sessWithPreSessAtt = new Map();
            sessWithPreSessAtt = component.get("v.sessWithPreSessSubmitedAtt");
            var custs = [];
            
            for ( var key in sessWithPreSessAtt ) {
                if(key == component.get("v.selectedSession") && !sessWithPreSessAtt[key]){
                    helper.showMessageToast(component, event, helper, 'Previous Session Attendance is not marked', "warning");
                }
            }
        }
        
        if(sessionLST.length > 0){
            helper.fetchSession(component, event, helper,sessionLST);
            
        }
        
        
    },
    
    savedata: function (component, event, helper) {
        helper.savestudentattendance(component, event, helper, true);
    },
    
    /*sendemail: function (component, event, helper) {
        component.set("v.Spinner", true);
        let action = component.get("c.sendEmailForSessionDetails");
        action.setParams({
            stdAttend : JSON.stringify(component.get("v.studentMatrixForAllSession")),
            sessopnOptions : JSON.stringify(component.get("v.allSessionRecords")),
            emailId : component.get("v.traineremail")
        });
        action.setCallback(this, function (response) {
            alert(JSON.stringify(response.getState()));
            //alert(JSON.stringify(response.getError()));
            // let state = response.getState();
            if (response.getState() === "SUCCESS") {
                helper.showMessageToast(component, event, helper, 'Email Sent Sccessfully!', "success");
                component.set("v.Spinner", false);
            } else if (state === "ERROR") {
                let errors = response.getError();
                let message = ""; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message += errors[0].message;
                }
                helper.showMessageToast(component, event, helper, message, "error");
                component.set("v.Spinner", false);
            }
            component.set("v.Spinner", false);
        });
        $A.enqueueAction(action);
    },*/
    
    submitform: function (component, event, helper) {
        var data = component.get("v.studentMatrix");
        var noneFound = false;
        var stdBlankAttend = '';
        var presentCnt = 0;
        var parentPresentCnt = 0;
        var parentBlankAttend = '';
        
        data.forEach(function(d) {
            d.sessiondata.forEach(function(s) {
                if(s.stdAttendance == ''){
                    noneFound = true;
                    stdBlankAttend += d.studentName + ', ';
                } else if(s.stdAttendance == 'Present'){
                    presentCnt++;
                }
                /*if(s.parentAttendance == '' && component.get("v.isSessionTypeParent")){
                    noneFound = true;
                    parentBlankAttend += d.studentName + ', ';
                }*/
                if(component.get("v.isSessionTypeParent")){
                    if(s.parentAttendance == ''){
                        noneFound = true;
                        parentBlankAttend += d.studentName + ', ';
                    } else if(s.parentAttendance == 'Present'){
                        parentPresentCnt++;
                    }
                }
            });
        });
        console.log(noneFound);
        if(noneFound){
            if(stdBlankAttend != ''){
                stdBlankAttend = stdBlankAttend.replace(/,\s*$/, "");
                helper.showMessageToast(component, event, helper, 'Please mark Student attendance for : ' + stdBlankAttend, "error");
            }
            if(parentBlankAttend != ''){
                parentBlankAttend = parentBlankAttend.replace(/,\s*$/, "");
                helper.showMessageToast(component, event, helper, 'Please mark Parent attendance for : ' + parentBlankAttend, "error");
            }
        } else {
            debugger;
            if(presentCnt != parseInt(component.get("v.studentPresented")) || 
               (component.get("v.isSessionTypeParent") && parentPresentCnt != parseInt(component.get("v.parentPresented")))){
                component.set("v.showLogReason", true);
            } else {
                component.set("v.showLogReason", false);
                helper.savestudentattendance(component, event, helper, false);
                helper.submitattendance(component, event, helper);
            }
        }
    },
    
    closeLogReason: function (component, event, helper) {
        component.set("v.selectedLogReason","");
    	component.set("v.showLogReason", false);
    },
    
    saveLogReason: function (component, event, helper) {
        //component.set("v.Spinner",true);
        if(component.get("v.selectedLogReason") == ''){
            helper.showMessageToast(component, event, helper, 'Complete Log Reason Field!', "error");
            component.set("v.Spinner",false);
        } else {
            var msg ='Are you sure you want to submit attendance?';
            if (!confirm(msg)) {
                return false;
            } else {
                helper.savestudentattendance(component, event, helper, false);
                helper.submitattendance(component, event, helper); 
                component.set("v.showLogReason",false);
            }
        }
        //component.set("v.Spinner",false);
    },
    
    signOut: function (component, event, helper) {
        setTimeout(function(){ $A.get('e.force:refreshView').fire(); }, 10);
    },
    
    SavePresentStudentCount: function (component, event, helper) {
        debugger;
        if(component.get("v.studentPresented") == undefined || parseInt(component.get("v.studentPresented")) == 0 || component.get("v.studentPresented") == ""){
            helper.showMessageToast(component, event, helper, 'Please enter total student present value to submit!', "error");
        } else if(component.get("v.isSessionTypeParent") && 
                  (component.get("v.parentPresented") == undefined || component.get("v.parentPresented") == 0 || component.get("v.parentPresented") == "")){
            helper.showMessageToast(component, event, helper, 'Please enter total parent present value to submit!', "error");
        } else{
            //Commented on 26-sep-2022
            /*var noValidation = true;
            if(parseInt(component.get("v.studentPresented")) > parseInt(component.get("v.totalStdInBatch")) &&
               parseInt(component.get("v.selectedSessionNumber")) != 1 && parseInt(component.get("v.selectedSessionNumber")) != 2){
                noValidation = false;
            } 
            if(component.get("v.isSessionTypeParent") && 
               parseInt(component.get("v.parentPresented")) > parseInt(component.get("v.totalStdInBatch")) &&
               parseInt(component.get("v.selectedSessionNumber")) != 1 && parseInt(component.get("v.selectedSessionNumber")) != 2){
                noValidation = false;
            } 
            if(!noValidation){
                if(parseInt(component.get("v.studentPresented")) > parseInt(component.get("v.totalStdInBatch"))){
                    helper.showMessageToast(component, event, helper, 'Total Student Attended count entered is higher than the total number of students in the classroom', "error");   
                } 
                if(component.get("v.isSessionTypeParent") && parseInt(component.get("v.parentPresented")) > parseInt(component.get("v.totalStdInBatch"))){
                    helper.showMessageToast(component, event, helper, 'Total Parent Attended count entered is higher than the total number of students in the classroom', "error");
                }*/
           // } else {
                component.set("v.Spinner", true);
                let action = component.get("c.savePresentedStudentCount");
                action.setParams({
                    sessionId : component.get("v.selectedSession"),
                    presentCount : component.get("v.studentPresented"),
                    parentPresentCnt : component.get("v.parentPresented")
                });
                action.setCallback(this, function (response) {
                    // let state = response.getState();
                    if (response.getState() === "SUCCESS") {
                        //window.location.reload();
                        component.set("v.Spinner", false);
                        component.set("v.isPresentedValueExist",true);
                        helper.showMessageToast(component, event, helper, 'Total Student Present Submitted!', "success");
                    } else if (state === "ERROR") {
                        let errors = response.getError();
                        let message = ""; // Default error message
                        if (errors && Array.isArray(errors) && errors.length > 0) {
                            message += errors[0].message;
                        }
                        component.set("v.Spinner", false);
                        helper.showMessageToast(component, event, helper, message, "error");
                    }
                    component.set("v.Spinner", false);
                });
                $A.enqueueAction(action);
            //}
        }
    },
    
    closePendingSess: function (component, event, helper) {
    	component.set("v.showPendingsessions", false);
    }
})