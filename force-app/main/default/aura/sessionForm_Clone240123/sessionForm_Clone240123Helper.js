({
    checktraineremail: function (component, event, helper) {
        debugger;
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
                    component.set("v.gradeList", res.grade);
                    component.set("v.pagenumber", 2);
                    helper.fnGetMappingTable(component, event, helper);
                    if(!component.get("v.donotcallBatchOptionfn"))
                        helper.populatedBatchesBasedOnEmail(component, event, helper);
                } else {
                    helper.showMessageToast(
                        component,
                        event,
                        helper,
                        "Please check the email address provided. If you think this is a mistake, send an email to abc@gmail.com",
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
        //debugger;
        let langparam = "eng";
        let objui = {};
        //Added Now : 3/2/2022
        objui.accountQName = "Type the first 4 letters of your school and wait for a drop-down to select the school";
        //objui.accountQName = "Type the first 4 letters of the student's school name, then wait for different school names appear, please select the school name from that list. DO NOT type the whole school name.";
        objui.contactQName =
            "Type the first 2 numbers of the batch code, then wait for different batch codes to appear, please select the batch code from that list. DO NOT type entire batch code.";

        //Added Now : 24/01/2022
        objui.contactStudentQName =
            "Type the first 4 letters of the student's name, then wait for student names appear, please select the school name from that list. DO NOT type the whole school name.";
        component.set("v.objUI", objui);
    },
    
    findSchoolBatch :  function (component, event, helper, selGrade) {
       
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
                component.set("v.isBatchOption",false);
                
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
    
    sessionRecord: function(component, event, helper,BtId){
        //debugger;
        let action = component.get("c.lstsessionRecords");
        action.setParams({
            batchId : BtId,
            loggedInTrainer : component.get("v.traineremail")
        });
        action.setCallback(this, function (response) {
            // let state = response.getState();
            if (response.getState() === "SUCCESS") {
                let res = response.getReturnValue();
                if (res != undefined && res != null && res.length > 0) {
                    helper.doProcessRecord(component, event, helper,res);
                    
        } else {
                           helper.showMessageToast(
                           component,
                           event,
                           helper,
                           "No Session records found for selected batch!",
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
    
    saveRecord: function(component, event, helper,sessionLST){
        let btId = component.get("v.selectedBatchId");

		var action = component.get("c.saveSessions");
			action.setParams({
    		'data': JSON.stringify(sessionLST),
                'batchId' : btId,
                loggedInTrainer : component.get("v.traineremail")
			});
			action.setCallback(this, function(response) {
    	var state = response.getState();
    		if (state === "SUCCESS") {
        	var res = response.getReturnValue();
                if (res != undefined && res != null && res.length > 0) {
                    helper.doProcessRecord(component, event, helper,res);
                    helper.showMessageToast(component, event, helper, "Record Updated Success!", "success");
                    component.set("v.showSaveCancelBtn",false);
                }        	
    	}
        else if (state === "ERROR") {
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
        
        doProcessRecord: function(component, event, helper,res){
            let sessionres = [];
                    res.forEach(s => {
                       // if(s.Session_date__c != undefined){
                       // let sdt = new Date(s.Session_date__c);
                       // s.Session_date__c = sdt.toISOString().substring(0, 10);
                    //}
                    //debugger;
                        if(s.startTime != null){
                        let stTime =  new Date(s.startTime);
                        s.startTime = stTime.toISOString().substr(11, 12);
                    }
                                if(s.endTime != null){
                        let edTime =  new Date(s.endTime);
                        s.endTime = edTime.toISOString().substr(11, 12);
                    }
                    sessionres.push(s);
                });
                component.set("v.sessionRecords",res);
                
                /*let sessionLST = [{'label' : 'All', 'value' : 'ALL'}];
                res.forEach(s => {
                    sessionLST.push({'label' : s.name, 'value' : s.id});
            } );
            component.set("v.sessionSelectRec",sessionLST);
            component.set("v.isBatchSelected",false);*/
            if(res){
                //debugger;
                let isSessionDateExist = false;
                for(let i = 0 ; i< res.length ; i++){
                    if(res[i]["sessionDate"] != null){
                        res[i]["isSessionDate"] = true;
                        isSessionDateExist = true;
                    }
                    else{
                        res[i]["isSessionDate"] = false;
                        if(isSessionDateExist == true){
                            res[i]["isSessionDate"] = true
                        }            
                        isSessionDateExist = false;
                    }
                }
            }
            //component.set("v.sessioneditRecTemp",res);
 			component.set("v.sessioneditRec",res);
            component.set("v.sessionfound",true);
            
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
        
    //--- Piyush(2/2/23)
	/*showStudentCount: function (component, event, helper, strmessage, strtype) {
        let btId = component.get("v.selectedBatchId");  
        //let batchId = component.get("v.TotalStudent");
        var action = component.get("c.getBatchCodeName");
        action.setParams({
            batchId : BatchId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                component.set('v.selectedBatchName', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    //--- Piyush(2/2/23)
    showAssessmentCompletedStudentCount: function (component, event, helper, strmessage, strtype) {
        let btId = component.get("v.selectedBatchId");  
        //let batchId = component.get("v.assessmentCompletedStudent");
        var action = component.get("c.assessmentCompleted");
        action.setParams({
            batchId : btId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                component.set('v.totalStudent', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },*/


    //Added Now : 31/01/2022
    findStudentRecordData :  function (component, event, helper) {
        debugger;
        let action = component.get("c.findSelectedStudentRecord");
        action.setParams({
            contactId : component.get("v.studentContactId"),
        });
        action.setCallback(this, function (response) {
             let state = response.getState();
            if (state === "SUCCESS") {
                debugger;
                let res = response.getReturnValue();
                console.log('#### Record Id : '+res.Id);
                console.log('#### Record Barcode : '+res.Bar_Code__c);
                if(res.Bar_Code__c){
                    // TODO : Save the barcode into a new Attribute
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


    checkemailhandler : function (component, event, helper) {

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
        component.set("v.MinDate",new Date().toISOString().split('T')[0]);
        if (validExpense) {
            helper.checktraineremail(component, event, helper);
        }
    },

    gradehandler : function (component, event, helper) {
        var selectedGrade =  component.get("v.selectedGrade");
       console.log('### SelectedGrade : '+selectedGrade);
            if(selectedGrade.length > 0 ){
                component.set("v.batchOptions",[]);
                component.set("v.selectedBatchId",'');
                component.set("v.sessionRecords",[]);
                component.set("v.sessionfound",false);
                //console.log("--- onwrpEventUpdate: ",BatchId );
                //component.set("v.selectedBatchId", selectedGrade);
                //findSessionAtt
                helper.findSchoolBatch(component, event, helper, selectedGrade);
                /*if(selectedGrade === 'Grade 9'){
                    component.set("v.cdm1Button",false);
                    component.set("v.careerSkillButton",false);
                    component.set("v.futurePlanningButton",false);
                    component.set("v.selfAwareNdFeedbackButton",false);
                    component.set("v.realitiesButton",false);
                }
                else if(selectedGrade === 'Grade 10'){
                    component.set("v.cdm1Button",false);
                    component.set("v.careerSkillButton",false);
                    component.set("v.futurePlanningButton",false);
                    component.set("v.selfAwareNdFeedbackButton",false);
                    component.set("v.realitiesButton",false);
                }
                else if(selectedGrade === 'Grade 11'){
                    component.set("v.cdm1Button",false);
                    component.set("v.careerSkillButton",false);
                    component.set("v.futurePlanningButton",false);
                    component.set("v.selfAwareNdFeedbackButton",false);
                    component.set("v.realitiesButton",false);
                }
                else if(selectedGrade === 'Grade 12'){
                    component.set("v.cdm1Button",false);
                    component.set("v.careerSkillButton",false);
                    component.set("v.futurePlanningButton",false);
                    component.set("v.selfAwareNdFeedbackButton",false);
                    component.set("v.realitiesButton",false);
                }
                else{}*/
                console.log('selectedGrade: '+selectedGrade);
            }
            else{
                component.set("v.batchOptions",[]);
                component.set("v.selectedBatchId",'');
                component.set("v.sessionRecords",[]);
                component.set("v.isBatchSelected",true);
                component.set("v.sessionfound",false);
                component.set("v.studentBatchWhereClause",'');//Added Now : 31/01/2022
                component.set("v.studentContactId",''); //Added Now : 31/01/2022
                component.set("v.displayButtonList",false); //Added Now : 31/01/2022
            }
    },
    batchhandler : function (component, event, helper) {
        //helper.findSchoolBatch(component, event, helper, component.get("v.selectedBatchId"));
        
            var BatchId = component.get("v.selectedBatchId");
            console.log('$$$In batchhandler :'+BatchId);
            if(BatchId.length > 0 ){
                //console.log("--- onwrpEventUpdate: ",BatchId );
                //component.set("v.selectedBatchId", BatchId);
                //helper.sessionRecord(component, event, helper,BatchId);
                /*let batchOptions = component.get('v.batchOptions');
                console.log('@@@ batcOptions : '+JSON.parse(JSON.stringify(batchOptions)));
                for(let e of batchOptions){
                    let batch = e;
                    console.log('@@@ e : '+JSON.stringify(e));
                    if(batch.value === BatchId){
                        var slicedata = (batch.label.slice(batch.label.indexOf('- ')+1));;
                        console.log('@@slicedata'+slicedata);
                        component.set('v.selectedBatchName',slicedata).trim();
                        // break;
                    }
                }

                console.log(' ########## continue here ######');*/

                //Added Now : 24/01/2022    
                var whereclause = ' AND RecordType.Name = \'CA Student\' AND ( Batch_Code__c = \''+component.get("v.selectedBatchId")+'\''
                        +' OR G10_Batch_Code__c = \''+component.get("v.selectedBatchId")+'\''
                        +' OR G11_Batch_Code__c = \''+component.get("v.selectedBatchId")+'\')'
                        +' ORDER BY Name';
                component.set("v.studentBatchWhereClause",whereclause);
                //If Batches Changes we will hide the "Add Assemenet Btn functionality".
                component.set("v.displayButtonList",true);
                component.set("v.studentDetailsPage",true);

                if(component.get('v.displayBatchStudents')){
                    component.set('v.displayBatchStudents',false);
                    component.set("v.studentDetailsPage",false);
                }
            }
            else{
                //component.set("v.batchOptions",[]);
                component.set("v.selectedBatchId",'');
                component.set("v.sessionRecords",[]);
                component.set("v.isBatchSelected",true);
                component.set("v.sessionfound",false);
                component.set("v.studentBatchWhereClause",'');//Added Now : 31/01/2022
                component.set("v.studentContactId",''); //Added Now : 31/01/2022
                component.set("v.displayButtonList",false); //Added Now : 31/01/2022
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
        /*else if(component.get("v.accountId") || component.get("v.selectedValueFromList") || component.get("v.selectedGrade")){
            helper.populatedBatchesBasedOnEmail(component, event, helper);
        }*/

    },
        
    populatedBatchesBasedOnEmail : function (component, event, helper) {
        var emailStr = component.get("v.traineremail");
        //console.log('##traineremail' +traineremail);

        var action = component.get("c.batchOptionsbyBatchId");
        action.setParams({
            traineremail : emailStr
        });
        action.setCallback(this, function(response){
            let state = response.getState();
        if (state === "SUCCESS") {
            let res = response.getReturnValue();
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

})