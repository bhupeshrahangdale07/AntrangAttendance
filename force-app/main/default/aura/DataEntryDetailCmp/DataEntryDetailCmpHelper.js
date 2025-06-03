({
    batchhandler : function (component, event, helper) {
            var BatchId = component.get("v.selectedBatchId");
            console.log('$$$In batchhandler :'+BatchId);
            if(BatchId.length > 0 ){
                var whereclause = ' AND RecordType.Name = \'CA Student\' AND ( Batch_Code__c = \''+component.get("v.selectedBatchId")+'\''
                        +' OR G10_Batch_Code__c = \''+component.get("v.selectedBatchId")+'\''
                        +' OR G11_Batch_Code__c = \''+component.get("v.selectedBatchId")+'\')'
                        +' ORDER BY Name';
                component.set("v.studentBatchWhereClause",whereclause);
               if(component.get("v.selectedGrade") !=null && component.get("v.selectedBatchId") !=null)
                        component.set("v.displayButtonList",true);
            }
            else{
                component.set("v.selectedBatchId",'');
                component.set("v.studentBatchWhereClause",'');//Added Now : 31/01/2022
                component.set("v.displayButtonList",false);
            }
        if(!component.get("v.AccountId") && !component.get("v.selectedValueFromList") && !component.get("v.selectedGrade")){

            var action = component.get("c.schoolnGradebyBatchId");
            action.setParams({
                batchId : BatchId
            });
            action.setCallback(this, function(response){
                let state = response.getState();
                if (state === "SUCCESS") {
                    let res = response.getReturnValue();

                    console.log('AccountId  '+res.School_Name__c);
                    console.log('selectedValueFromList  '+res.School_Name__r.Name);
                    console.log('selectedGrade  '+res.Grade__c);
                    component.set("v.AccountId",res.School_Name__c);
                    component.set("v.selectedValueFromList",res.School_Name__r.Name);
                    component.set("v.selectedGrade",res.Grade__c);
                    
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
        }
     

    },
    gradehandler : function (component, event, helper) {
        debugger;
        var selectedGrade =  component.get("v.selectedGrade");
       console.log('### SelectedGrade : '+selectedGrade);
            if(selectedGrade.length > 0 ){
                component.set("v.batchOptions",[]);
                component.set("v.selectedBatchId",'');
                helper.findSchoolBatch(component, event, helper, selectedGrade);       
                console.log('selectedGrade: '+selectedGrade);
            }
            else{
                component.set("v.batchOptions",[]);
                component.set("v.selectedBatchId",'');
                component.set("v.studentBatchWhereClause",'');//Added Now : 31/01/2022
                component.set("v.displayButtonList",false); //Added Now : 31/01/2022
            }
    },
    findSchoolBatch :  function (component, event, helper, selGrade) {
       console.log('findSchoolBatch');
        let action = component.get("c.findBatch");
        action.setParams({
            accountId : component.get("v.AccountId"),
            selectedGrade : selGrade,
            traineremail: component.get("v.traineremail")
        });
        action.setCallback(this, function (response) {
             let state = response.getState();
            if (state === "SUCCESS") {
                let res = response.getReturnValue();
                component.set("v.batchOptions",res.batchOptions);
                /*for(var i=0 ; i < res.batchOptions.length ; i++){
                    if(res.batchOptions[i]['value'] == component.get("v.selectedBatchId"))
						component.set("v.selectedBatchCode",res.batchOptions[i]['label']);                    	
                }
                console.log('bbb',res.batchOptions)
                //component.set("v.selectedBatchId",res.batchOptions);
                console.log('aaa',res.batchOptions)*/
                //component.set("v.isBatchOption",false);
                if(component.get("v.donotcallBatchOptionfn"))
                    helper.batchhandler(component, event, helper);
                
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
    showMessageToast: function (component, event, helper, strmessage, strtype) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: strmessage,
            type: strtype,
            duration: 1000
        });
        toastEvent.fire();
    },
    getIntialData: function (component, event, helper) {
        let action = component.get("c.checkEmailExist");
        action.setParams({
            stremail: component.get("v.traineremail")
        });
        action.setCallback(this, function (response) {
            console.log(response.getReturnValue());
            component.set("v.gradeList", response.getReturnValue().grade);
            helper.fnGetMappingTable(component, event, helper);
            // if(!component.get("v.donotcallBatchOptionfn"))
            //             helper.populatedBatchesBasedOnEmail(component, event, helper);
        });
        $A.enqueueAction(action);
    },
    fnGetMappingTable: function (component, event, helper) {
        //debugger;
        let langparam = "eng";
        let objui = {};
        objui.accountQName = "Type the first 4 letters of your school and wait for a drop-down to select the school";
        objui.contactQName =
            "Type the first 2 numbers of the batch code, then wait for different batch codes to appear, please select the batch code from that list. DO NOT type entire batch code.";

        objui.contactStudentQName =
            "Type the first 4 letters of the student's name, then wait for student names appear, please select the school name from that list. DO NOT type the whole school name.";
        component.set("v.objUI", objui);
    },
    createCookie: function(name, value, days){
        var expires;
        if (days) {
            const date = new Date();
            date.setTime(date.getTime() + (1 * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toGMTString();
        } else {
            expires = "";
        }
        document.cookie = name + "=" + value + expires + "; path=/";
    },
    // populatedBatchesBasedOnEmail : function (component, event, helper) {
    //     var emailStr = component.get("v.traineremail");
    //     //console.log('##traineremail' +traineremail);

    //     var action = component.get("c.batchOptionsbyBatchId");
    //     action.setParams({
    //         traineremail : emailStr
    //     });
    //     action.setCallback(this, function(response){
    //         let state = response.getState();
    //     if (state === "SUCCESS") {
    //         let res = response.getReturnValue();
    //         component.set("v.batchOptions",res.batchOptions);
    //         component.set("v.isBatchOption",false);
            
    //     } else if (state === "ERROR") {
    //         let errors = response.getError();
    //         let message = ""; // Default error message
    //         if (errors && Array.isArray(errors) && errors.length > 0) {
    //             message += errors[0].message;
    //         }
    //         helper.showMessageToast(component, event, helper, message, "error");
    //     }
    //     });
    //     $A.enqueueAction(action);
    // },

})