({
     testhandle: function (component, event, helper) {
         console.log('a')
     },
    init: function (component, event, helper) {
        debugger;
        var sURL = decodeURIComponent(window.location.href);
        console.log(sURL);
        var trainerParamEmail;
        var studentSchool;
        var studentGrade;
        var studentBatchId;
        var accountId;

        if(sURL.includes('?')){
            var params = sURL.split('?')[1].split('&');
            if(params.length == 3){
                component.set("v.formTyp",decodeURI(params[0].split('=')[1]));
                component.set("v.formLng",decodeURI(params[2].split('=')[1]));
                if(component.get("v.formLng") == 'English'){
                    //console.log('English');
            		component.set("v.isEnglish",true);
                    component.set("v.placeHolder", "Search...");
                    component.set("v.labelSelectedGrade", "Select the Grade/Class from the drop down below");
                    component.set("v.labelselectedBatch", "Select the batch code for the student that you want to enter the data for");
                    component.set("v.messageWhenValueMissing", "Complete this field.");
                }else{
                    //console.log('Hindi');
                    component.set("v.isEnglish",false);
                    component.set("v.placeHolder", "खोज....");
                    component.set("v.labelSelectedGrade", "नीचे ड्रॉप डाउन से ग्रेड/क्लास का चयन करें");
                    component.set("v.labelselectedBatch", "उस छात्र के लिए बैच कोड का चयन करें जिसके लिए आप डेटा दर्ज करना चाहते हैं");
                    component.set("v.messageWhenValueMissing", "इस फ़ील्ड को पूरा करें.");
                }
                component.set("v.traineremail",decodeURI(params[1].split('=')[1]));
                helper.getIntialData(component, event, helper);
                component.set("v.selectedBatchCode",'');
                component.set("v.displayButtonList",false);
            }else if(params.length == 7){
                component.set("v.traineremail",decodeURI(params[0].split('=')[1])); 
                component.set("v.donotcallBatchOptionfn",true);
                helper.getIntialData(component, event, helper);
                component.set("v.selectedValueFromList",decodeURI(params[1].split('=')[1]));
                component.set("v.AccountId",decodeURI(params[4].split('=')[1]));
                component.set("v.selectedGrade",decodeURI(params[2].split('=')[1])); 
                helper.gradehandler(component, event, helper);
                component.set("v.selectedBatchId",decodeURI(params[3].split('=')[1]));  
                if(component.get("v.selectedGrade") !=null && component.get("v.selectedBatchId") !=null){
                    debugger;
                    helper.getButtonsVisibility(component, component.get("v.AccountId"));
                    component.set("v.displayButtonList",true);
                }
                component.set("v.formTyp",decodeURI(params[5].split('=')[1]));
                component.set("v.formLng",decodeURI(params[6].split('=')[1]));
                //console.log('v.formLng: '+decodeURI(params[6].split('=')[1]));
                console.log('v.formLng: '+component.get("v.formLng"));
				//v.isEnglish = (component.get("v.formLng") == 'English') ? true : false;
				if(component.get("v.formLng") == 'English'){
                    //console.log('English');
            		component.set("v.isEnglish",true);
                    component.set("v.placeHolder", "Student...");
                    component.set("v.labelSelectedGrade", "Select the Grade/Class from the drop down below");
                    component.set("v.labelselectedBatch", "Select the batch code for the student that you want to enter the data for");
                    component.set("v.messageWhenValueMissing", "Complete this field.");
                }else{
                    //console.log('Hindi');
                    component.set("v.isEnglish",false);
                    component.set("v.placeHolder", "खोज....");
                    component.set("v.labelSelectedGrade", "नीचे ड्रॉप डाउन से ग्रेड/क्लास का चयन करें");
                    component.set("v.labelselectedBatch", "उस छात्र के लिए बैच कोड का चयन करें जिसके लिए आप डेटा दर्ज करना चाहते हैं");
                    component.set("v.messageWhenValueMissing", "इस फ़ील्ड को पूरा करें.");
                }
                console.log('v.isEnglish: '+component.get("v.isEnglish"));
            }else{
                var navService = component.find("navService");
                var pageReference = {
                    type: 'comm__namedPage',
                    attributes: {
                        name: 'LoginPageV2__c'
                    }
                };
                navService.navigate(pageReference);
            }
           
        }
           
      
    },
    onwrpEventUpdate: function (component, event, helper) {
        if(component.get("v.selectedValueFromList") == '' || component.get("v.selectedValueFromList") == 'undefined'){
        	console.log('$$$$$$$$', component.get("v.isEnglish"));
            if(component.get("v.isEnglish") == true){
                console.log('English');
                component.set("v.errorMessage",'Complete this field.');
            }else{
                console.log('Hindi');
                component.set("v.errorMessage", "इस फ़ील्ड को पूरा करें.");
            }
        }else{
            component.set("v.errorMessage",'');
        }
        //console.log("--- onwrpEventUpdate: ");
        let sObject = event.getParam("sObject");
        if (sObject == "Account") {
            let accountId = event.getParam("AccountId");
            let d = new Date();
            let yearToSub = d.getMonth() > 4 ? 1 : 2;
            let firstMay = d.getFullYear() - yearToSub +'-05-01';
            let nextYearApril = d.getFullYear() + yearToSub + '-04-30';
            if(accountId != undefined && accountId != null && accountId.length > 0){
                console.log('#accountId : '+accountId);
                var schoolName = component.get("v.selectedValueFromList");
                if(schoolName != '') helper.getButtonsVisibility(component, accountId);
                console.log('##selectedValueFromSchoolList : '+schoolName);
                component.set("v.AccountId",accountId);
                /*component.set(
                    "v.StudentWhareClause",
                    " AND Facilitation_Start_Date__c >= "+firstMay+" AND Facilitation_Start_Date__c <= "+nextYearApril+" AND School_Name__c = '" + accountId + "' ORDER BY NAME"
                );*/
                let selectedGrade =  component.get("v.selectedGrade");
                if(selectedGrade.length > 0 ){
                    helper.findSchoolBatch(component, event, helper, selectedGrade);
                }
            }else{
                component.set("v.batchOptions",[]);
                component.set("v.AccountId",null);
                component.set("v.selectedBatchId",'');
                component.set("v.displayButtonList",false); 
            }
        }
        
    },
    handleGradeChange: function (component, event, helper) {
        debugger;
        console.log('handleGradeChange SchoolId = ',component.get("v.selectedValueFromList"))
        if(component.get("v.selectedValueFromList") == '' || component.get("v.selectedValueFromList") === undefined){
            if(component.get("v.isEnglish") == true){
                console.log('English');
                component.set("v.errorMessage",'Complete this field.');
            }else{
                console.log('Hindi');
                component.set("v.errorMessage", "इस फ़ील्ड को पूरा करें.");
            }
        }else{
            component.set("v.errorMessage",'');
        }
    	component.set("v.selectedBatchCode",'');
        helper.gradehandler(component, event, helper);
    },
    handleBatchChange: function (component, event, helper) {
        console.log('$$$ In handleBatchChange');
        if(component.get("v.selectedValueFromList") == '' || component.get("v.selectedValueFromList") == 'undefined'){
            if(component.get("v.isEnglish") == true){
                console.log('English');
                component.set("v.errorMessage",'Complete this field.');
            }else{
                console.log('Hindi');
                component.set("v.errorMessage", "इस फ़ील्ड को पूरा करें.");
            }
        }else{
            component.set("v.errorMessage",'');
        }
        helper.batchhandler(component, event, helper);
    },
    studentDetailsHandler : function(component, event, helper){
        var navService = component.find("navService");
        var pageReference = {
                             type: 'comm__namedPage',
                             attributes: {
                                             name: 'StudentDetailsV2__c'
                                        }, 
                             state: {
                                        fem: component.get('v.traineremail'),
                                        sch: component.get('v.selectedValueFromList'),
                                        grd: component.get('v.selectedGrade'),
                                        bid: component.get('v.selectedBatchId'),
                                        acid:component.get('v.AccountId'),
                                        typ: component.get("v.formTyp"),
                                        lng: component.get("v.formLng")
                                    }
        };
    
        navService.navigate(pageReference);
    },
    baselineAssessmentHandle : function(component, event, helper){
        var navService = component.find("navService");
        var pageReference = {
                             type: 'comm__namedPage',
                             attributes: {
                                             name: 'baselinesublinks_V2__c'
                                        }, 
                             state: {
                                 		
                                        fem: component.get('v.traineremail'),
                                        sch: component.get('v.selectedValueFromList'),
                                        grd: component.get('v.selectedGrade'),
                                        bid: component.get('v.selectedBatchId'),
                                        acid:component.get('v.AccountId'),
                                 		typ:component.get('v.formTyp'),
                                 		lng:component.get('v.formLng')
                                    }
        };
    
        navService.navigate(pageReference);
    },
    baseline2AssessmentHandle : function(component, event, helper){
        var navService = component.find("navService");
        var pageReference = {
                             type: 'comm__namedPage',
                             attributes: {
                                             name: 'Baseline_2_Summary__c'
                                        }, 
                             state: {
                                 		
                                        fem: component.get('v.traineremail'),
                                        sch: component.get('v.selectedValueFromList'),
                                        grd: component.get('v.selectedGrade'),
                                        bid: component.get('v.selectedBatchId'),
                                        acid:component.get('v.AccountId'),
                                 		typ:component.get('v.formTyp'),
                                 		lng:component.get('v.formLng')
                                    }
        };
    
        navService.navigate(pageReference);
    },
    interestHandler : function(component, event, helper){
        var navService = component.find("navService");
        //var formApi = component.get('v.interestFormType');
        var pageReference = {
                             type: 'comm__namedPage',
                             attributes: {
                                             name: 'interest_assessment_V2__c'
                                        }, 
                             state: {
                                        fem: component.get('v.traineremail'),
                                        sch: component.get('v.selectedValueFromList'),
                                        grd: component.get('v.selectedGrade'),
                                        bid: component.get('v.selectedBatchId'),
                                        acid:component.get('v.AccountId'),
                                 		typ:component.get('v.formTyp'),
                                 		lng:component.get('v.formLng')
                                    }
        };
    
        navService.navigate(pageReference);
    },
    aptitudeHandler : function(component, event, helper){
        debugger;
        var navService = component.find("navService");
        //var formApi = component.get('v.aptitudeFormType')
        //console.log('$$$ aptitudeHandler formApi1: ', formApi);
        var pageReference = {
                             type: 'comm__namedPage',
                             attributes: {
                                             name: 'aptitude_assessment_V2__c'
                                        }, 
                             state: {
                                        fem: component.get('v.traineremail'),
                                        sch: component.get('v.selectedValueFromList'),
                                        grd: component.get('v.selectedGrade'),
                                        bid: component.get('v.selectedBatchId'),
                                        acid:component.get('v.AccountId'),
                                 		typ:component.get('v.formTyp'),
                                 		lng:component.get('v.formLng')
                                    }
        };
        navService.navigate(pageReference);
    },
    quiz1Handler : function(component, event, helper){
        var navService = component.find("navService");
        var pageReference = {
                             type: 'comm__namedPage',
                             attributes: {
                                             name: 'Quiz_1_Summary_V2__c'
                                        }, 
                             state: {
                                        fem: component.get('v.traineremail'),
                                        sch: component.get('v.selectedValueFromList'),
                                        grd: component.get('v.selectedGrade'),
                                        bid: component.get('v.selectedBatchId'),
                                        acid:component.get('v.AccountId'),
                                        typ:component.get('v.formTyp'),
                                        lng:component.get('v.formLng')
                                    }
        };
    
        navService.navigate(pageReference);
    },
    midProgramFeedbackHandler : function(component, event, helper){
        var navService = component.find("navService");
        var pageReference = {
                             type: 'comm__namedPage',
                             attributes: {
                                             name: 'Mid_Program_Feedback_V2__c'
                                        }, 
                             state: {
                                        fem: component.get('v.traineremail'),
                                        sch: component.get('v.selectedValueFromList'),
                                        grd: component.get('v.selectedGrade'),
                                        bid: component.get('v.selectedBatchId'),
                                        acid:component.get('v.AccountId'),
                                        typ:component.get('v.formTyp'),
                                        lng:component.get('v.formLng')
                                    }
        };
    
        navService.navigate(pageReference);
    },
    realityHandler : function(component,event,helper){
        var navService = component.find("navService");
        var pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'Reality_Details_V2__c'
            }, 
            state: {
                fem: component.get('v.traineremail'),
                sch: component.get('v.selectedValueFromList'),
                grd: component.get('v.selectedGrade'),
                bid: component.get('v.selectedBatchId'),
                acid:component.get('v.AccountId'),
                typ:component.get('v.formTyp'),
                lng:component.get('v.formLng')
            }
        };
        
        navService.navigate(pageReference);
    },
    quiz2Handler : function(component, event, helper){
        var navService = component.find("navService");
        var pageReference = {
                             type: 'comm__namedPage',
                             attributes: {
                                             name: 'quiz2_summary_V2__c'
                                        }, 
                             state: {
                                        fem: component.get('v.traineremail'),
                                        sch: component.get('v.selectedValueFromList'),
                                        grd: component.get('v.selectedGrade'),
                                        bid: component.get('v.selectedBatchId'),
                                        acid:component.get('v.AccountId'),
                                 		typ:component.get('v.formTyp'),
                                        lng:component.get('v.formLng')
                                    }
        };
    
        navService.navigate(pageReference);
    },
    endlineAssessmentHandle : function(component, event, helper){
        var navService = component.find("navService");
        var pageReference = {
                             type: 'comm__namedPage',
                             attributes: {
                                             name: 'endlinesublinks_V2__c'
                                        }, 
                             state: {
                                        fem: component.get('v.traineremail'),
                                        sch: component.get('v.selectedValueFromList'),
                                        grd: component.get('v.selectedGrade'),
                                        bid: component.get('v.selectedBatchId'),
                                        acid:component.get('v.AccountId'),
                                 		typ:component.get('v.formTyp'),
                                        lng:component.get('v.formLng')
                                    }
        };
    
        navService.navigate(pageReference);
    },
    signOut: function (component, event, helper) {
        helper.createCookie('AntarangLoginV2', '', null);
        var navService = component.find("navService");
        var pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'LoginPageV2__c'
            }
        };
        
        navService.navigate(pageReference);
    },
})