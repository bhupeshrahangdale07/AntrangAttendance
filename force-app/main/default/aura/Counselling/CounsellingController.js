({
    showSpinner : function(component, event, helper) {
        component.set("v.Spinner", true);
    },
    
    hideSpinner : function(component, event, helper) {
        component.set("v.Spinner", false);
    },
    
    onwrpEventUpdate: function (component, event, helper) {
        component.set("v.AccountId",event.getParam("AccountId"));
        if(event.getParam("AccountId") != '' && component.get("v.selectedGrade")){
            helper.fetchstudent(component, event, helper); 
        }
    },
    
    handleSchoolAndGradeChange: function (component, event, helper) {
        if(component.get("v.AccountId") != '' && component.get("v.selectedGrade")){
            //helper.fetchstudent(component, event, helper); 
            helper.fetchbatch(component, event, helper);
        }
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
    
    Save: function (component, event, helper) {
        component.set("v.Spinner",true);
        helper.saveData(component, event, helper);
    },
    
    completecounseling: function (component, event, helper) {
        
        var data = component.get("v.counsellingEditRec");
        var isValid = true;
        var stdName = '';
        var stdCallBackRetry = '';
        data.forEach(d => {
            if(d.counselingType && d.counsellingDate && d.counsellingTime && d.selStudentAtt && d.selGuardianParentAtt){
            
        } else {
                     isValid = false;
                     stdName += d.studentName + ', ';
                     }
                     
                     if(d.status == 'Call back' || d.status == 'Retry'){
            isValid = false;
            stdCallBackRetry += d.studentName + ', ';
        }
        
    }
    );
    
    if(stdName){
    stdName = stdName.replace(/,\s*$/, "");
    stdName += ' Counseling Type, Date time, Strudent or parent atteandance are missing please fill all fields for complete counseling.'
    alert(stdName);            
}
 if(stdCallBackRetry){
    stdCallBackRetry = stdCallBackRetry.replace(/,\s*$/, "");
    alert('Complete the counseling status for : ' + stdCallBackRetry);            
}

if(isValid){
    
    var msg ='The attendance cannot be changed hereafter.';
    if (!confirm(msg)) {
        return false;
    } else {
        var counsellingData = component.get("v.counsellingEditRec");
        //let processCounsellingData = [];
        var stdName = '';
        var stdTextNum = '';
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

if(stdName == '' && stdTextNum == ''){
    helper.completecounselingForm(component, event, helper);
    
}
else {
    
    if(stdName != ''){
        var err = stdName.replace(/,\s*$/, "") + ' Other number field should be 10 digit.';
        component.set("v.Spinner",false);
        alert(err);
        
    }
    
    if(stdTextNum != ''){
        var err = stdTextNum.replace(/,\s*$/, "") + ' Other number field should be numeric.';
        component.set("v.Spinner",false);
        alert(err);
    }
}
}
}
},
    handleBatchChange: function (component, event, helper) {
        if(component.get("v.selectedBatchId") != ""){
         	helper.fetchstudent(component, event, helper);    
        }
    }
})