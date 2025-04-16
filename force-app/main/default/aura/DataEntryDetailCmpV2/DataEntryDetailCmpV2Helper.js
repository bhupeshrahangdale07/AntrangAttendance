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
                component.set("v.baselineAssessmentButton",true);
                console.log('$$$ baselineAssessmentButton');
                if(component.get("v.selectedGrade") !=null && component.get("v.selectedBatchId") !=null){
                    var school = component.get("v.AccountId");
                    var grade = component.get("v.selectedGrade");
                    var batch = component.get("v.selectedBatchId");
                    //helper.getButtonsVisibility(component, school, grade, batch);
                    if(batch != null && batch != ''){
                        helper.doAssignment(component);
                        
                        /*
                        var districtData = component.get("v.districtFields");
                        if(grade === 'Grade 9'){
                            console.log('grade 9');
                            component.set("v.baselineAssessmentButton",districtData.Show_Baseline_for_G9__c);
                            component.set("v.studentDetailsButton",districtData.Show_Student_Details_for_G9__c);
                            component.set("v.interestButton",districtData.Show_Interest_for_G9__c);
                            component.set("v.aptitudeButton",districtData.Show_Aptitude_for_G9__c);
                            component.set("v.realityButton",districtData.Show_Reality_for_G9__c);
                            component.set("v.quiz1Button",districtData.Show_Quiz_1_for_G9__c);
                            component.set("v.midProgramFeedbackButton",districtData.Show_Mid_Program_for_G9__c);
                            component.set("v.quiz2Button",districtData.Show_Quiz_2_for_G9__c);
                            component.set("v.endlineAssessmentButton",districtData.Show_Endline_for_G9__c);
                        }else if(grade == 'Grade 10'){
                            component.set("v.baselineAssessmentButton",districtData.Show_Baseline_for_G10__c);
                            component.set("v.studentDetailsButton",districtData.Show_Student_Details_for_G10__c);
                            component.set("v.interestButton",districtData.Show_Interest_for_G10__c);
                            component.set("v.aptitudeButton",districtData.Show_Aptitude_for_G10__c);
                            component.set("v.realityButton",districtData.Show_Reality_for_G10__c);
                            component.set("v.quiz1Button",districtData.Show_Quiz_1_for_G10__c);
                            component.set("v.midProgramFeedbackButton",districtData.Show_Mid_Program_for_G10__c);
                            component.set("v.quiz2Button",districtData.Show_Quiz_2_for_G10__c);
                            component.set("v.endlineAssessmentButton",districtData.Show_Endline_for_G10__c);
                        }else if(grade == 'Grade 11'){
                            component.set("v.baselineAssessmentButton",districtData.Show_Baseline_for_G11__c);
                            component.set("v.studentDetailsButton",districtData.Show_Student_Details_for_G11__c);
                            component.set("v.interestButton",districtData.Show_Interest_for_G11__c);
                            component.set("v.aptitudeButton",districtData.Show_Aptitude_for_G11__c);
                            component.set("v.realityButton",districtData.Show_Reality_for_G11__c);
                            component.set("v.quiz1Button",districtData.Show_Quiz_1_for_G11__c);
                            component.set("v.midProgramFeedbackButton",districtData.Show_Mid_Program_for_G11__c);
                            component.set("v.quiz2Button",districtData.Show_Quiz_2_for_G11__c);
                            component.set("v.endlineAssessmentButton",districtData.Show_Endline_for_G11__c);
                        }else if(grade == 'Grade 12'){
                           component.set("v.baselineAssessmentButton",districtData.Show_Baseline_for_G12__c);
                            component.set("v.studentDetailsButton",districtData.Show_Student_Details_for_G12__c);
                            component.set("v.interestButton",districtData.Show_Interest_for_G12__c);
                            component.set("v.aptitudeButton",districtData.Show_Aptitude_for_G12__c);
                            component.set("v.realityButton",districtData.Show_Reality_for_G12__c);
                            component.set("v.quiz1Button",districtData.Show_Quiz_1_for_G12__c);
                            component.set("v.midProgramFeedbackButton",districtData.Show_Mid_Program_for_G12__c);
                            component.set("v.quiz2Button",districtData.Show_Quiz_2_for_G12__c);
                            component.set("v.endlineAssessmentButton",districtData.Show_Endline_for_G12__c);
                        }
                        component.set("v.displayButtonList",true);  
                        */
                    }
                }
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
        var selectedGrade =  component.get("v.selectedGrade");
       	console.log('### SelectedGrade : '+selectedGrade);
        component.set("v.displayButtonList",false); 
        if(selectedGrade.length > 0 ){
            component.set("v.batchOptions",[]);
            component.set("v.selectedBatchId",'');
            helper.findSchoolBatch(component, event, helper, selectedGrade);       
            //console.log('selectedGrade: '+selectedGrade);
            var school = component.get("v.AccountId");
            var grade = component.get("v.selectedGrade");
            //var batch = component.get("v.selectedBatchId");
            //console.log('$$$ Before calling getButtonsVisibility batch:'+batch);
            //helper.getButtonsVisibility(component, school, grade);
        }
        else{
            component.set("v.batchOptions",[]);
            component.set("v.selectedBatchId",'');
            component.set("v.studentBatchWhereClause",'');//Added Now : 31/01/2022
        }
    },
    findSchoolBatch :  function (component, event, helper, selGrade) {
       	let flagEmail;
        let strUsername = component.get("v.traineremail");
        if(strUsername != undefined || strUsername != null || strUsername != ""){
            var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
            var phonePattern = /^[0-9]{10}$/; // Assumes a 10-digit phone number format
            if (emailPattern.test(strUsername)) {
                flagEmail = true;
            }else if(phonePattern.test(strUsername)){
                flagEmail =  false;
            }
        }
        let action = component.get("c.findBatch");
        action.setParams({
            accountId : component.get("v.AccountId"),
            selectedGrade : selGrade,
            traineremail: component.get("v.traineremail"),
            flagEmail :flagEmail
            
        });
        action.setCallback(this, function (response) {
             let state = response.getState();
            if (state === "SUCCESS") {
                let res = response.getReturnValue();
                console.log('res = ',res)
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
            console.log('grade = ',response.getReturnValue());
            //added filter to remove grade 11 and grade 12
            const filteredGrades = response.getReturnValue().grade.filter(grade => grade.label !== 'Grade 11');
            console.log('filteredGrades = ',filteredGrades)
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
        if(component.get("v.formLng") == 'English'){
            objui.accountQName = "Type the first 4 letters of your school and wait for a drop-down to select the school";
            objui.contactQName =
            "Type the first 2 numbers of the batch code, then wait for different batch codes to appear, please select the batch code from that list. DO NOT type entire batch code.";
            objui.contactStudentQName =
            "Type the first 4 letters of the student's name, then wait for student names appear, please select the school name from that list. DO NOT type the whole school name.";
        }else{
            objui.accountQName = "अपने स्कूल के पहले 4 अक्षर टाइप करें और स्कूल का चयन करने के लिए ड्रॉप-डाउन की प्रतीक्षा करें";
            objui.contactQName =
            "बैच कोड के पहले 2 नंबर टाइप करें, फिर अलग-अलग बैच कोड आने की प्रतीक्षा करें, कृपया उस सूची से बैच कोड चुनें। संपूर्ण बैच कोड टाइप न करें.";
            objui.contactStudentQName =
            "छात्र के नाम के पहले 4 अक्षर टाइप करें, फिर छात्र के नाम आने तक प्रतीक्षा करें, कृपया उस सूची से स्कूल का नाम चुनें। पूरे स्कूल का नाम न लिखें.";
        }
        

        
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
    
    getButtonsVisibility : function (component, school) {
        console.log('$$$ school :'+school);
        //console.log('$$$ grade :'+grade);
        if(school != null && school != ''){
            console.log('$$$ If Condition');
            let action = component.get("c.getSchoolDistrictData");
            action.setParams({
                schoolId : school
            });
            action.setCallback(this, function(response){
                
                let state = response.getState();
                console.log('state = ',state);
                console.log('response.getReturnValue() = ',response.getReturnValue());
                if(state === "SUCCESS"){
                    let res = response.getReturnValue();
                    console.log('Return :'+JSON.stringify(res));
                    component.set("v.districtFields",res);
                    console.log('districtFields = ',component.get("v.districtFields"));
					
                    this.doAssignment(component);
                    /* // For Dynamic query
                    if(res.Select_Forms_to_Show_in_Baseline_for_G9__c || res.Select_Forms_to_Show_in_Baseline_for_G10__c || Select_Forms_to_Show_in_Baseline_for_G11__c || res.Select_Forms_to_Show_in_Baseline_for_G12__c){
                        component.set("v.studentDetailButton",true);
                    }
                    if(res.Select_Forms_to_Show_in_Endline_for_G9__c || res.Select_Forms_to_Show_in_Endline_for_G10__c || Select_Forms_to_Show_in_Endline_for_G11__c || res.Select_Forms_to_Show_in_Endline_for_G12__c){
                        component.set("v.baselineAssessmentButton",true);
                    }*/
                }
            });
            $A.enqueueAction(action);                   
        }
    },
    
    doAssignment : function (component) {
        var districtData = component.get("v.districtFields");
        var grade = component.get("v.selectedGrade");
        if(grade === 'Grade 9'){
            console.log('grade 9');
            component.set("v.baselineAssessmentButton",districtData.Show_Baseline_for_G9__c);
            component.set("v.studentDetailsButton",districtData.Show_Student_Details_for_G9__c);
            component.set("v.interestButton",districtData.Show_Interest_for_G9__c);
            component.set("v.aptitudeButton",districtData.Show_Aptitude_for_G9__c);
            component.set("v.realityButton",districtData.Show_Reality_for_G9__c);
            component.set("v.quiz1Button",districtData.Show_Quiz_1_for_G9__c);
            component.set("v.midProgramFeedbackButton",districtData.Show_Mid_Program_for_G9__c);
            component.set("v.quiz2Button",districtData.Show_Quiz_2_for_G9__c);
            component.set("v.endlineAssessmentButton",districtData.Show_Endline_for_G9__c);
        }else if(grade == 'Grade 10'){
            component.set("v.baselineAssessmentButton",districtData.Show_Baseline_for_G10__c);
            component.set("v.studentDetailsButton",districtData.Show_Student_Details_for_G10__c);
            component.set("v.interestButton",districtData.Show_Interest_for_G10__c);
            component.set("v.aptitudeButton",districtData.Show_Aptitude_for_G10__c);
            component.set("v.realityButton",districtData.Show_Reality_for_G10__c);
            component.set("v.quiz1Button",districtData.Show_Quiz_1_for_G10__c);
            component.set("v.midProgramFeedbackButton",districtData.Show_Mid_Program_for_G10__c);
            component.set("v.quiz2Button",districtData.Show_Quiz_2_for_G10__c);
            component.set("v.endlineAssessmentButton",districtData.Show_Endline_for_G10__c);
        }else if(grade == 'Grade 11'){
            component.set("v.baselineAssessmentButton",districtData.Show_Baseline_for_G11__c);
            component.set("v.studentDetailsButton",districtData.Show_Student_Details_for_G11__c);
            component.set("v.interestButton",districtData.Show_Interest_for_G11__c);
            component.set("v.aptitudeButton",districtData.Show_Aptitude_for_G11__c);
            component.set("v.realityButton",districtData.Show_Reality_for_G11__c);
            component.set("v.quiz1Button",districtData.Show_Quiz_1_for_G11__c);
            component.set("v.midProgramFeedbackButton",districtData.Show_Mid_Program_for_G11__c);
            component.set("v.quiz2Button",districtData.Show_Quiz_2_for_G11__c);
            component.set("v.endlineAssessmentButton",districtData.Show_Endline_for_G11__c);
        }else if(grade == 'Grade 12'){
            component.set("v.baselineAssessmentButton",districtData.Show_Baseline_for_G12__c);
            component.set("v.studentDetailsButton",districtData.Show_Student_Details_for_G12__c);
            component.set("v.interestButton",districtData.Show_Interest_for_G12__c);
            component.set("v.aptitudeButton",districtData.Show_Aptitude_for_G12__c);
            component.set("v.realityButton",districtData.Show_Reality_for_G12__c);
            component.set("v.quiz1Button",districtData.Show_Quiz_1_for_G12__c);
            component.set("v.midProgramFeedbackButton",districtData.Show_Mid_Program_for_G12__c);
            component.set("v.quiz2Button",districtData.Show_Quiz_2_for_G12__c);
            component.set("v.endlineAssessmentButton",districtData.Show_Endline_for_G12__c);
        }
 
        var schoolName = component.get("v.selectedValueFromList");
        var batch = component.get("v.selectedBatchId");
        if(batch && batch != '' &&
           grade && grade != '' &&
           schoolName && schoolName != ''){
            component.set("v.displayButtonList",true);
        }
    }
})