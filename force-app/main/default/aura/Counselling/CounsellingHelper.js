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
                    if(res.contact.Facilitator_Work_Status__c == 'Active'){
                        component.set("v.facilitatorId", res.contact.Id);
                        component.set("v.gradeList", res.grade);
                        component.set("v.pagenumber", 2);
                        helper.fnGetMappingTable(component, event, helper);
                    }else{
                        helper.showMessageToast(
                        component,
                        event,
                        helper,
                        "Trainer is not Active!",
                        "warning"
                    );
                    }
                    
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
    
    showMessageToast: function (component, event, helper, strmessage, strtype) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: strmessage,
            type: strtype,
            duration: 1000
        });
        toastEvent.fire();
    },
    
    fetchbatch: function (component, event, helper) {
        let action = component.get("c.fetchbatch");
        action.setParams({
            schoolId: component.get("v.AccountId"),
            sessGrade: component.get("v.selectedGrade"),
           	facilitatorId: component.get("v.facilitatorId")
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (response.getState() === "SUCCESS") {
                let res = response.getReturnValue(); 
                console.log('res = '+JSON.stringify(res));
                component.set("v.batchOptions", res.batch);
                component.set("v.isBatchOption", false);
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
    
    fetchstudent: function (component, event, helper) {
        let action = component.get("c.fetchStudent");
        action.setParams({
            batchId: component.get("v.selectedBatchId"),
            facilitatorId: component.get("v.facilitatorId"),	//updated on 27.04.2023
            sessGrade: component.get("v.selectedGrade")
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (response.getState() === "SUCCESS") {
                
                let res = response.getReturnValue();
                component.set("v.counsellingfound",true);
                if (res.StdData != undefined && res.StdData != null && res.StdData.length > 0) {
                    let tempData = [];
                    res.StdData.forEach(s => { if(s.counsellingTime != null){ 
                                              let stTime =  new Date(s.counsellingTime);
                                              s.counsellingTime = stTime.toISOString().substr(11, 12);
                                             }
                                        tempData.push(s);
                });
                component.set("v.counsellingEditRec",tempData);
            }
            else{
                component.set("v.counsellingEditRec",res.StdData);
            }
             
            console.log(JSON.stringify(res.counselingType));
            component.set("v.status",res.status);
            component.set("v.counselingType",res.counselingType);
            component.set("v.careerAspiration",res.careerAspiration);
            component.set("v.reason",res.reason);
            component.set("v.CounselingCount",res.forsubmitted);
            component.set("v.firstStepAfterClass10",res.firstStepAfterClass10);
            component.set("v.guardianParentAttend",res.guardianParentAttend);
            component.set("v.studentAttend",res.studentAttend);
            component.set("v.saveDisabled",false);
            //component.set("v.Spinner", false);
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
 
 saveData: function (component, event, helper) {
    var counsellingData = component.get("v.counsellingEditRec");
    //let processCounsellingData = [];
    var stdName = '';
    var stdTextNum = '';
    var stdParentAtt = '';
    var dateWithNotAllValue = '';
    var stdStatus = '';
    var letters = /^[0-9]+$/;
    if (counsellingData.length > 0) {
        
        counsellingData.forEach(s => { 
            if(s.whatsappnum){
            if(s.whatsappnum.trim().length != 10){
            stdName += s.studentName + ', ';
        }
                                
                                if(!s.whatsappnum.trim().toString().match(letters)){
            stdTextNum += s.studentName + ', ';
        }
    }
    
    if(s.counselingType == 'Phone counseling' && s.status == ''){
        stdStatus += s.studentName + ', ';
    }
    console.log(s.studentName + ' == ' + s.counselingType + ' == ' + s.selGuardianParentAtt);
    if((s.counselingType == 'In person' || s.counselingType == 'Digital') && s.selGuardianParentAtt == '' && s.counsellingTime != undefined){
        stdParentAtt += s.studentName + ', ';
    }
    
    if(s.counsellingDate != undefined &&  
       ( s.counsellingTime == undefined || s.counsellingTime == '' ||  s.counselingType == undefined || s.counselingType == '' || s.counsellingTime == undefined || 
        s.counsellingTime == '' || s.selGuardianParentAtt == '' || s.selStudentAtt == '')  ){
        dateWithNotAllValue += s.studentName + ', ';
    }
});

let tempData = [];
counsellingData.forEach(s => { 
    if(s.counsellingTime != null && s.counsellingTime != undefined && !s.counsellingTime.includes("Z")){
    s.counsellingTime = s.counsellingTime+"Z";
}
                        var selRes = '';
                        s.seletedReasonList.forEach(r => {
                        //if(r.selected){
                        selRes += r.value+';';
                        // }
                        });
s.selectedReason = selRes.slice(0, -1);
tempData.push(s);
});
component.set("v.tempcounsellingEditRec",tempData);
}
console.log('stdName ' + stdName);
console.log('stdTextNum ' + stdTextNum);
console.log('stdStatus ' + stdStatus);
console.log('stdParentAtt ' + stdParentAtt);
if(stdName == '' && stdTextNum == '' && stdStatus == '' && stdParentAtt == '' && dateWithNotAllValue == ''){
    let action = component.get("c.saveCounselling");
    action.setParams({
        counsellingWrap : JSON.stringify(component.get("v.tempcounsellingEditRec"))
        // sessGrade: component.get("v.selectedGrade")
    });
    action.setCallback(this, function (response) {
        let state = response.getState();
        if (response.getState() === "SUCCESS") {
            helper.showMessageToast(component, event, helper, 'Records Saved!', "success");
            window.location.reload();
        } else if (state === "ERROR") {
            let errors = response.getError();
            let message = ""; // Default error message
            if (errors && Array.isArray(errors) && errors.length > 0) {
                message += errors[0].message;
            }
            helper.showMessageToast(component, event, helper, message, "error");
            component.set("v.Spinner",false);
        }
    });
    $A.enqueueAction(action);
} else {
    var ShowOnlyOneAlert = true;
    if(dateWithNotAllValue != ''){
        var err = dateWithNotAllValue.replace(/,\s*$/, "") + ' : Time and Attendance is required if Date filled.';
        component.set("v.Spinner",false);
        ShowOnlyOneAlert = false;
        alert(err);
    }
    
    if(stdName != '' && ShowOnlyOneAlert){
        var err = stdName.replace(/,\s*$/, "") + ' : Other number field should be 10 digit.';
        component.set("v.Spinner",false);
        ShowOnlyOneAlert = false;
        alert(err);
        
    }
    
    if(stdTextNum != '' && ShowOnlyOneAlert){
        var err = stdTextNum.replace(/,\s*$/, "") + ' : Other number field should be numeric.';
        component.set("v.Spinner",false);
        ShowOnlyOneAlert = false;
        alert(err);
    }
    
    if(stdStatus != '' && ShowOnlyOneAlert){
        var err = stdStatus.replace(/,\s*$/, "") + ' : Status is mandatory for phone counseling type.';
        component.set("v.Spinner",false);
        ShowOnlyOneAlert = false;
        alert(err);
    }
    
    if(stdParentAtt != '' && ShowOnlyOneAlert){
        var err = stdParentAtt.replace(/,\s*$/, "") + ' : Parent attendance is mandatory for In person counseling type.';
        component.set("v.Spinner",false);
        ShowOnlyOneAlert = false;
        alert(err);
    }
    
}

},
    
    completecounselingForm: function (component, event, helper) {
        component.set("v.Spinner",true);
        let action = component.get("c.saveCounselingStaus");
        action.setParams({
            batchId: component.get("v.selectedBatchId")
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (response.getState() === "SUCCESS") {
                helper.showMessageToast(component, event, helper, 'Counseling form submittd for completion', "success");
                helper.saveData(component, event, helper);
                /*window.setTimeout(
                    $A.getCallback(function() {
                        component.set("v.Spinner",false);
                        window.location.reload();
                    }), 3000
                );*/
            } else if (state === "ERROR") {
                component.set("v.Spinner",false);
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


})