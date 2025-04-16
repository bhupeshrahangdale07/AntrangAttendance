({
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
            if(params.length == 1){
                component.set("v.traineremail",decodeURI(params[0].split('=')[1]));
                 helper.getIntialData(component, event, helper);
                component.set("v.selectedBatchCode",'');
                component.set("v.displayButtonList",false);
            }else if(params.length == 5){
                component.set("v.traineremail",decodeURI(params[0].split('=')[1])); 
                component.set("v.donotcallBatchOptionfn",true);
                helper.getIntialData(component, event, helper);
                component.set("v.selectedValueFromList",decodeURI(params[1].split('=')[1]));
                component.set("v.AccountId",decodeURI(params[4].split('=')[1]));
                component.set("v.selectedGrade",decodeURI(params[2].split('=')[1])); 
                helper.gradehandler(component, event, helper);
                component.set("v.selectedBatchId",decodeURI(params[3].split('=')[1]));  
                if(component.get("v.selectedGrade") !=null && component.get("v.selectedBatchId") !=null)
                component.set("v.displayButtonList",true);

            }else{
                var navService = component.find("navService");
                var pageReference = {
                    type: 'comm__namedPage',
                    attributes: {
                        name: 'LoginPage__c'
                    }
                };
                navService.navigate(pageReference);
            }
           
        }
           
      
    },
    onwrpEventUpdate: function (component, event, helper) {
        debugger;
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
    	component.set("v.selectedBatchCode",'');
        helper.gradehandler(component, event, helper);
    },
    handleBatchChange: function (component, event, helper) {
        helper.batchhandler(component, event, helper);
    },
    studentDetailsHandler : function(component, event, helper){
        var navService = component.find("navService");
        var pageReference = {
                             type: 'comm__namedPage',
                             attributes: {
                                             name: 'StudentDetails__c'
                                        }, 
                             state: {
                                        fem: component.get('v.traineremail'),
                                        sch: component.get('v.selectedValueFromList'),
                                        grd: component.get('v.selectedGrade'),
                                        bid: component.get('v.selectedBatchId'),
                                        acid:component.get('v.AccountId')
                                    }
        };
    
        navService.navigate(pageReference);
    },
    baselineAssessmentHandle : function(component, event, helper){
        var navService = component.find("navService");
        var pageReference = {
                             type: 'comm__namedPage',
                             attributes: {
                                             name: 'cdm1form5__c'
                                        }, 
                             state: {
                                        fem: component.get('v.traineremail'),
                                        sch: component.get('v.selectedValueFromList'),
                                        grd: component.get('v.selectedGrade'),
                                        bid: component.get('v.selectedBatchId'),
                                        acid:component.get('v.AccountId')
                                    }
        };
    
        navService.navigate(pageReference);
    },
    interestHandler : function(component, event, helper){
        var navService = component.find("navService");
        var pageReference = {
                             type: 'comm__namedPage',
                             attributes: {
                                             name: 'cdm1form5__c'
                                        }, 
                             state: {
                                        fem: component.get('v.traineremail'),
                                        sch: component.get('v.selectedValueFromList'),
                                        grd: component.get('v.selectedGrade'),
                                        bid: component.get('v.selectedBatchId'),
                                        acid:component.get('v.AccountId')
                                    }
        };
    
        navService.navigate(pageReference);
    },
    interestHandler : function(component, event, helper){
        var navService = component.find("navService");
        var pageReference = {
                             type: 'comm__namedPage',
                             attributes: {
                                             name: 'Interest_Data_Summary__c'
                                        }, 
                             state: {
                                        fem: component.get('v.traineremail'),
                                        sch: component.get('v.selectedValueFromList'),
                                        grd: component.get('v.selectedGrade'),
                                        bid: component.get('v.selectedBatchId'),
                                        acid:component.get('v.AccountId')
                                    }
        };
    
        navService.navigate(pageReference);
    },
    aptitudeHandler : function(component, event, helper){
        var navService = component.find("navService");
        var pageReference = {
                             type: 'comm__namedPage',
                             attributes: {
                                             name: 'Apptitude_Details__c'
                                        }, 
                             state: {
                                        fem: component.get('v.traineremail'),
                                        sch: component.get('v.selectedValueFromList'),
                                        grd: component.get('v.selectedGrade'),
                                        bid: component.get('v.selectedBatchId'),
                                        acid:component.get('v.AccountId')
                                    }
        };
    
        navService.navigate(pageReference);
    },
    realityHandler : function(component,event,helper){
        var navService = component.find("navService");
        var pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'Reality_Details__c'
            }, 
            state: {
                fem: component.get('v.traineremail'),
                sch: component.get('v.selectedValueFromList'),
                grd: component.get('v.selectedGrade'),
                bid: component.get('v.selectedBatchId'),
                acid:component.get('v.AccountId')
            }
        };
        
        navService.navigate(pageReference);
    },
    quiz1Handler : function(component, event, helper){
        var navService = component.find("navService");
        var pageReference = {
                             type: 'comm__namedPage',
                             attributes: {
                                             name: 'Quiz_1_Summary__c'
                                        }, 
                             state: {
                                        fem: component.get('v.traineremail'),
                                        sch: component.get('v.selectedValueFromList'),
                                        grd: component.get('v.selectedGrade'),
                                        bid: component.get('v.selectedBatchId'),
                                        acid:component.get('v.AccountId')
                                    }
        };
    
        navService.navigate(pageReference);
    },
    midProgramFeedbackHandler : function(component, event, helper){
        var navService = component.find("navService");
        var pageReference = {
                             type: 'comm__namedPage',
                             attributes: {
                                             name: 'Mid_Program_Feedback__c'
                                        }, 
                             state: {
                                        fem: component.get('v.traineremail'),
                                        sch: component.get('v.selectedValueFromList'),
                                        grd: component.get('v.selectedGrade'),
                                        bid: component.get('v.selectedBatchId'),
                                        acid:component.get('v.AccountId')
                                    }
        };
    
        navService.navigate(pageReference);
    },
    quiz2Handler : function(component, event, helper){
        var navService = component.find("navService");
        var pageReference = {
                             type: 'comm__namedPage',
                             attributes: {
                                             name: 'Quiz_2_Details__c'
                                        }, 
                             state: {
                                        fem: component.get('v.traineremail'),
                                        sch: component.get('v.selectedValueFromList'),
                                        grd: component.get('v.selectedGrade'),
                                        bid: component.get('v.selectedBatchId'),
                                        acid:component.get('v.AccountId')
                                    }
        };
    
        navService.navigate(pageReference);
    },
    endlineAssessmentHandle : function(component, event, helper){
        var navService = component.find("navService");
        var pageReference = {
                             type: 'comm__namedPage',
                             attributes: {
                                             name: 'Endline_Summary__c'
                                        }, 
                             state: {
                                        fem: component.get('v.traineremail'),
                                        sch: component.get('v.selectedValueFromList'),
                                        grd: component.get('v.selectedGrade'),
                                        bid: component.get('v.selectedBatchId'),
                                        acid:component.get('v.AccountId')
                                    }
        };
    
        navService.navigate(pageReference);
    },
    signOut: function (component, event, helper) {
        helper.createCookie('AntarangLogin', '', null);
        var navService = component.find("navService");
        var pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'LoginPage__c'
            }
        };
        
        navService.navigate(pageReference);
    },
})