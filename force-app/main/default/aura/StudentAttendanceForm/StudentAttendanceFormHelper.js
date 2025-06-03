({
    checktraineremail: function (component, event, helper) {
        
        let email = component.get("v.traineremail");
        let action = component.get("c.checkEmailExist");
        action.setParams({
            stremail: email
        });
        action.setCallback(this, function (response) {
             let state = response.getState();
            
            if (response.getState() === "SUCCESS") {
                let res = response.getReturnValue();
                if (res != undefined && res != null && res.contact.Id != undefined) {
                    component.set("v.FacilitatorId", res.contact.Id);
                    component.set("v.gradeList", res.grade);
                    component.set("v.pagenumber", 2);
                    component.set("v.pendingsessions", res.pendingsessionlist);
                    console.log(JSON.stringify(res.pendingsessionlist));
                    component.set("v.showPendingsessions", true);
                    helper.fnGetMappingTable(component, event, helper);
                } else {
                    helper.showMessageToast(
                        component,
                        event,
                        helper,
                        "Matching trainer not found!",
                        "warning"
                    );
                }
            } else if (state === "ERROR") {
                let errors = response.getError();
                let message = ""; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message += errors[0].message;
                }
                helper.showMessageToast(component, event, helper, message, "error");
            }
        });
        $A.enqueueAction(action);
    },
    
    fnGetMappingTable: function (component, event, helper) {
        let langparam = "eng";
        let objui = {};
        objui.accountQName =
            "Type the first 4 letters of the student's school name, then wait for different school names appear, please select the school name from that list. DO NOT type the whole school name.";
        objui.contactQName =
            "Type the first 2 numbers of the batch code, then wait for different batch codes to appear, please select the batch code from that list. DO NOT type entire batch code.";
        component.set("v.objUI", objui);
        
    },
    
    fetchSession: function(component, event, helper,sessionLST){
            let action = component.get("c.prepareMatrix");
        action.setParams({
            batchId : component.get("v.selectedBatchId"),
            facilitatorId : component.get("v.FacilitatorId"),
            sessionID : sessionLST,
            selectedGrade: component.get("v.selectedGrade")
        });
        action.setCallback(this, function (response) {
            // let state = response.getState();
            if (response.getState() === "SUCCESS") {
                let res = response.getReturnValue();
                component.set("v.studentMatrix",res.studentdata);
                component.set("v.tempstudentMatrix",res.studentdata);
                component.set("v.studentattendance",res.attendancepicklist);
                component.set("v.parentattendance",res.parentattendancepicklist);
                component.set("v.logreasonpicklist",res.logreasonpicklist);
                component.set("v.isAttendanceSubmited",res.isAttendanceSubmited);
                component.set("v.studentPresented",res.studentPresented);
                component.set("v.parentPresented",res.parentPresented);
                component.set("v.isSessionTypeParent",res.isSessionTypeParent);
                component.set("v.selectedSessionNumber",res.selectedSessionNumber);
                if(res.studentPresented != '' && res.studentPresented != undefined){
                    component.set("v.isPresentedValueExist", true);
                } else if(res.isSessionTypeParent && res.parentPresented != '' && res.parentPresented != undefined){
                    component.set("v.isPresentedValueExist", true);
                } else {
                    component.set("v.isPresentedValueExist", false);
                }
                if(res.sessWithPreSessSubmitedAtt != '' && res.sessWithPreSessSubmitedAtt != undefined){
                    component.set("v.sessWithPreSessSubmitedAtt",res.sessWithPreSessSubmitedAtt);
                }
                
                //added 
                component.find("totalStd").setCustomValidity("");
                component.find("totalStd").reportValidity();
                component.set("v.Spinner",false);
            } else if (state === "ERROR") {
                let errors = response.getError();
                let message = ""; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message += errors[0].message;
                }
                helper.showMessageToast(component, event, helper, message, "error");
            }
        });
        $A.enqueueAction(action);
        
    },
    
    sessionRecord: function(component, event, helper,BtId){
        debugger;
        let action = component.get("c.lstsessionRecords");
        action.setParams({
            batchId : BtId,
            facilitatorId : component.get("v.FacilitatorId"),
            SelectedGrade: component.get("v.selectedGrade")
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (response.getState() === "SUCCESS") {
                let res = response.getReturnValue();
                
                if (res.sessionData != undefined && res.sessionData != null && res.sessionData.length > 0) {
                    component.set("v.sessionRecords",res.sessionData);
                    //component.set("v.studentdata",res.studentData);
                    component.set("v.isBatchSelected",false);
                    component.set("v.batchSelected",true);
                    //component.set("v.sessWithPreSessSubmitedAtt",res.sessWithPreSessSubmitedAtt);
                    //component.set("v.totalStdInBatch",res.totalStdInBatch);
                    //component.set("v.selectedSession","All");
                    //helper.defaultSessionList(component, event, helper);
                }  else {
                    component.set("v.batchSelected",false);
                    helper.showMessageToast(
                        component,
                        event,
                        helper,
                        "No Session records found for selected batch!",
                        "warning"
                    );
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
    },
    
    showMessageToast: function (component, event, helper, strmessage, strtype) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: strmessage,
            type: strtype,
            duration: 4000
        });
        toastEvent.fire();
    },
    
    defaultSessionList: function (component, event, helper) {
        var sessionLST = [];
        var sess = component.get("v.allSessionRecords");
        sess.forEach(s => {
            if(s.label != 'None'){
            sessionLST.push(s.value);
        } 
                     });
        console.log(JSON.stringify(sessionLST));
        console.log(component.get("v.Allstudentdata"));
        let action = component.get("c.prepareMatrix");
        action.setParams({
            batchId : component.get("v.selectedBatchId"),
            facilitatorId : component.get("v.FacilitatorId"),
            sessionID : sessionLST,
            selectedGrade: component.get("v.selectedGrade")
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (response.getState() === "SUCCESS") {
                let res = response.getReturnValue();
                console.log('res = ',res);
                component.set("v.studentMatrixForAllSession",res.studentdata);
                component.set("v.tempstudentMatrixForAllSession",res.studentdata);
                if(res.sessWithPreSessSubmitedAtt != '' && res.sessWithPreSessSubmitedAtt != undefined){
                    component.set("v.sessWithPreSessSubmitedAtt",res.sessWithPreSessSubmitedAtt);
                }
            } else if (state === "ERROR") {
                let errors = response.getError();
                let message = ""; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message += errors[0].message;
                }
                helper.showMessageToast(component, event, helper, message, "error");
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchBatchList : function (component, event, helper) {
        debugger;
        let action = component.get("c.findSessionAtt");
        action.setParams({
            accountId : component.get("v.AccountId"),
            selectedGrade : component.get("v.selectedGrade"),
            facilitatorId : component.get("v.FacilitatorId")
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let res = response.getReturnValue();
                component.set("v.batchOptions",res.batchOptions);
                console.log('batchOptions=',res.batchOptions);
                console.log('acadYear =',component.get("v.FacilitatorId"));
                component.set("v.isBatchOption",false);
                //added to remove selected session
                component.set("v.sessionRecords",[]);
                component.set("v.selectedSession","");
                component.set("v.isBatchSelected",true);
                component.set("v.batchSelected",false);
            } else if (state === "ERROR") {
                let errors = response.getError();
                let message = ""; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message += errors[0].message;
                }
                helper.showMessageToast(component, event, helper, message, "error");
            }
        });
        $A.enqueueAction(action);
    },
    
    findSessionAttedence :  function (component, event, helper, selGrade) {
        debugger;
        let action = component.get("c.findSessionAtt");
        action.setParams({
            accountId : component.get("v.AccountId"),
            selectedGrade : selGrade
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let res = response.getReturnValue();
                component.set("v.studentMatrix",res.studentAttendance);
                component.set("v.tempstudentMatrix",res.studentAttendance);
                component.set("v.tempstudentMatrix2",res.studentAttendance);
                component.set("v.batchOptions",res.batchOptions);
                component.set("v.isBatchOption",false);
                
            } else if (state === "ERROR") {
                let errors = response.getError();
                let message = ""; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message += errors[0].message;
                }
                helper.showMessageToast(component, event, helper, message, "error");
            }
        });
        $A.enqueueAction(action);
    },
    
    submitattendance :  function (component, event, helper){
        
            let action = component.get("c.submitAttendance");
            action.setParams({
                sessId : component.get("v.selectedSession"),
                logReason : component.get("v.selectedLogReason")
            });
            action.setCallback(this, function (response) {
                // let state = response.getState();
                if (response.getState() === "SUCCESS") {
                    helper.showMessageToast(component, event, helper, "Student Attendance Submitted Successfully!", "success");
                    //setTimeout(function(){ $A.get('e.force:refreshView').fire(); }, 3000);
                    var sessionLST = [];
                    sessionLST.push(component.get("v.selectedSession"));
                    component.set("v.selectedLogReason","");
                    helper.fetchSession(component, event, helper,sessionLST);
                } else if (state === "ERROR") {
                    let errors = response.getError();
                    let message = ""; // Default error message
                    if (errors && Array.isArray(errors) && errors.length > 0) {
                        message += errors[0].message;
                    }
                    helper.showMessageToast(component, event, helper, message, "error");
                    component.set("v.Spinner",false);
                } else {
                 	component.set("v.Spinner",false);   
                }
            });
            $A.enqueueAction(action);
    },
    
    savestudentattendance:  function (component, event, helper, fromSave){
        debugger;
        let action = component.get("c.saveStudentAttendance");
        action.setParams({
            studentAttendance : component.get("v.studentMatrix")
        });
        action.setCallback(this, function (response) {
            // let state = response.getState();
            if (response.getState() === "SUCCESS") {
                if(fromSave){
                    helper.showMessageToast(component, event, helper, "Student Attendance Save Successfully!", "success");
                    var sessionLST = [];
                    sessionLST.push(component.get("v.selectedSession"));
                    helper.fetchSession(component, event, helper,sessionLST);
                    //setTimeout(function(){ $A.get('e.force:refreshView').fire(); }, 3000);   
                }
            } else if (state === "ERROR") {
                let errors = response.getError();
                let message = ""; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message += errors[0].message;
                }
                helper.showMessageToast(component, event, helper, message, "error");
                component.set("v.Spinner",false);
            }
            else {
                component.set("v.Spinner",false);
            }
        });
        $A.enqueueAction(action);
    }
})