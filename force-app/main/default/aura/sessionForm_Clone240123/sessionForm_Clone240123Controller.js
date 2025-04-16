({
    init: function (component, event, helper) {
        debugger;
        var sURL = decodeURIComponent(window.location.href);
        if(sURL.includes('?')){
            var params = sURL.split('?')[1].split('&');
            if(params){
                var trainerParamEmail = params[0].split('=')[1];
                var studentSchool = unescape(params[1].split('=')[1]);
                var studentGrade = unescape(params[2].split('=')[1]);
                var studentBatchId = params[3].split('=')[1];
                var accountId = params[4].split('=')[1];
                if(trainerParamEmail){
                    component.set("v.displayButtonList",false);
                    component.set("v.traineremail",trainerParamEmail);           
                    if(trainerParamEmail){
                        component.set("v.traineremail",trainerParamEmail);
                        component.set("v.donotcallBatchOptionfn",true);
                        helper.checkemailhandler(component, event, helper);
                        if(studentSchool){
                            component.set("v.selectedValueFromList",studentSchool);
                            component.set("v.AccountId",accountId);
                            if(studentGrade){
                                component.set("v.selectedGrade",studentGrade);
                                helper.gradehandler(component, event, helper);
                                if(studentBatchId){
                                    component.set("v.selectedBatchId",studentBatchId);
                                    //helper.batchhandler(component, event, helper);
                                }
                            }
                        }
                    }
                }
            }
        }
    },
    checkemail: function (component, event, helper) {
        helper.checkemailhandler(component, event, helper);
    },
    handleGradeChange: function (component, event, helper) {
        helper.gradehandler(component, event, helper);
    },
    handleBatchChange: function (component, event, helper) {
        helper.batchhandler(component, event, helper);
    },
    
    onwrpEventUpdate: function (component, event, helper) {
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
                component.set("v.isBatchOption",true);
                component.set("v.AccountId",null);
                component.set("v.selectedBatchId",'');
                component.set("v.sessionRecords",[]);
                component.set("v.isBatchSelected",true);
                component.set("v.sessionfound",false); 
                component.set("v.studentBatchWhereClause",'');//Added Now : 24/01/2022
                component.set("v.studentContactId",''); //Added Now : 31/01/2022
                component.set("v.displayButtonList",false); //Added Now : 31/01/2022
            }
        }
        if (sObject == "Batch__C") {
            let BatchId = event.getParam("BatchId");
            if(BatchId.length > 0 ){
                //console.log("--- onwrpEventUpdate: ",BatchId );
                component.set("v.selectedBatchId", BatchId);
                helper.sessionRecord(component, event, helper,BatchId);
            }
            else{
                component.set("v.selectedBatchId",'');
                component.set("v.sessionRecords",[]);
                component.set("v.isBatchSelected",true);
                component.set("v.sessionfound",false);
                component.set("v.studentBatchWhereClause",'');//Added Now : 24/01/2022
                component.set("v.studentContactId",''); //Added Now : 31/01/2022
                component.set("v.displayButtonList",false); //Added Now : 31/01/2022
            }
        }

        //Added Now : 31/01/2022
        /*debugger; ------Piyush (1/2/23)
        if (sObject == "Contact") {
            let studentContactId = event.getParam("ContactId");
            if(studentContactId != undefined && studentContactId != null && studentContactId.length > 0){
                component.set("v.studentContactId",studentContactId);
                helper.findStudentRecordData(component, event, helper)
                component.set("v.displayButtonList",true);
            }else{
                component.set("v.studentContactId",'');
                component.set("v.displayButtonList",false);
            }
        }*/
        
    },
    
    
    /* ----- Piyush(1/2/23)
    handleSessionChange: function (component, event, helper) {
        //debugger;
        let sessionLST = [];
        let sel = component.get("v.selectedSession");
        let allSessionRec = component.get("v.sessionRecords");
        if(sel == 'ALL'){
            component.set("v.sessionfound",true);
            component.set("v.sessioneditRec",allSessionRec);
        } else if(sel != 'ALL' && sel != 'None'){
            component.set("v.sessionfound",true);
            
            allSessionRec.forEach(s => {
                if(s.id == sel){
                sessionLST.push(s);
                
                }
            });
            component.set("v.sessioneditRec",sessionLST);
        }
            else{
                component.set("v.sessionfound",false);   
            }
        //component.set("v.sessioneditRec",sessionLST);
    },*/
    
    Save: function(component, event, helper) {
        //debugger;
        //if(component.get("v.isValidAll")){
        let proccrec = component.get("v.sessioneditRec");
        let sel = component.get("v.selectedSession");
        let letestlk = component.get("v.latestLink");
        let sessionLST = [];
        
        let lst = component.find("sessionEdit");
        var validity = true;
        for(let i = 0 ; i<lst.length ; i++){
            if(!lst[i].find("SessionDate").checkValidity()){
                validity = false;
            }  
        }
        
        for(let i = 0 ; i<proccrec.length ; i++){
            if(!proccrec[i].isParentSession){
                if(i+1< proccrec.length && proccrec[i+1].sessionDate && !proccrec[i].sessionDate ){
                    validity = false;
                }
                if(i != 0 && proccrec[i].sessionDate < proccrec[i-1].sessionDate && !proccrec[i].sessionDate){
                    validity = false;
                }
            }
        }
        
        proccrec.forEach(function(o,index){
                         if(!o.isParentSession && o.sessionDate && (!o.facilitatorId || !o.startTime | !o.mode)){
            validity = false;
        }
            if(o.mode == 'Digital' && !o.link && !o.isParentSession){
            validity = false;
        }
        });
        
        if(!validity){
            helper.showMessageToast(component, event, helper, 'Please read the form instructions and fill with proper data!', "error");
            return false;
        }
                    
            
            proccrec.forEach(s => {
                if(!s.isAttendenceFound && !s.isParentSession){
                if(sel == 'ALL' && letestlk != null && letestlk.length > 0){
               // if(s.link == null){
               // s.link = letestlk;
            //}
                             }
                             }
                             if(s.isParentSession && s.startTime && s.startTime != null && s.startTime != undefined && !s.startTime.includes("Z")){
                s.startTime = s.startTime+"Z";
            }
                             if(!s.isParentSession && s.startTime != null && s.startTime != undefined && !s.startTime.includes("Z")){
                s.startTime = s.startTime+"Z";
            }
            if(!s.isParentSession && s.endTime != null && s.endTime != undefined && !s.endTime.includes("Z")){
                s.endTime = s.endTime+"Z";
            }
                             sessionLST.push(s);});
        
        helper.saveRecord(component, event, helper,sessionLST);
     //   }
   // else{
   // helper.showMessageToast(component,event,helper,"Please update the invalid form entries and try again!","error");
    	
	//}
        
    },
 
 
    /*
    cancel : function(component,event,helper){
        // on cancel refresh the view (This event is handled by the one.app container. It’s supported in Lightning Experience, the Salesforce app, and Lightning communities. ) 
        $A.get('e.force:refreshView').fire(); 
    },*/ 
    
    showSpinner: function (component, event, helper) {
        // make Spinner attribute true for display loading spinner
        component.set("v.Spinner", true);
    },
        
        disableFollowingRows: function (component, event, helper) {
        //Get the event message attribute
        var index = event.getParam("index");
            console.log(index); 
            //debugger;
            let lst = component.find("sessionEdit");
            let sessioneditRecs = component.get("v.sessioneditRec");
            let followingTrue = false;
            
            //let currentSessionDateRemoved = false;
            //if(sessioneditRecs[index].sessionDate == null){
            //       currentSessionDateRemoved = true; 
            //    }
           // if(currentSessionDateRemoved){
           //     for(let i = index+1 ; i<lst.length; i++){
            //        sessioneditRecs[i].sessionDate = null;
           //             }
           //  }
           //  
           if(index != 0 && (sessioneditRecs[index].sessionDate < sessioneditRecs[index-1].sessionDate ||
                            sessioneditRecs[index].sessionDate > sessioneditRecs[index+1].sessionDate)){
                    lst[index].find("SessionDate").setCustomValidity("Session Date cannot be less then above OR greater then below Session Date");
                    lst[index].find("SessionDate").reportValidity();
           }else{
               lst[index].find("SessionDate").setCustomValidity("");
                    lst[index].find("SessionDate").reportValidity();
           }
           
            
            for(let i = 0 ; i<lst.length; i++){
                /*if(i != 0 && sessioneditRecs[i].sessionDate < sessioneditRecs[i-1].sessionDate){
                    lst[i].find("SessionDate").setCustomValidity("Session Date cannot be less then above Session Date");
                    lst[i].find("SessionDate").reportValidity();
                }
                else if(i+1 < lst.length && sessioneditRecs[i].sessionDate > sessioneditRecs[i+1].sessionDate){
                    lst[i].find("SessionDate").setCustomValidity("Session Date cannot be greater then below Session Date");
                    lst[i].find("SessionDate").reportValidity();
                }
                else{
                    lst[i].find("SessionDate").setCustomValidity("");
                    lst[i].find("SessionDate").reportValidity();
                }*/
                if(i != 0 && i+1 < lst.length && sessioneditRecs[i].sessionDate > sessioneditRecs[i-1].sessionDate
                   && (sessioneditRecs[i].sessionDate < sessioneditRecs[i+1].sessionDate ||
                       sessioneditRecs[i+1].sessionDate == undefined)){
                    lst[index-1].find("SessionDate").setCustomValidity("");
                    lst[index-1].find("SessionDate").reportValidity();
                }

                /*if(index == i  && index < lst.length && sessioneditRecs[index].sessionDate != null ){
                    let row = lst[index+1];
                    $A.util.removeClass(row, "disabled");
                    followingTrue = true;
                }else if(i == index && i > 0 && sessioneditRecs[index].sessionDate == null && sessioneditRecs[i-1].sessionDate != null){
                    let row = lst[index+1];
                    $A.util.removeClass(row, "disabled");
                    followingTrue = true;

                    if(index != 0 && lst.length != (i+1) && sessioneditRecs[i+1].sessionDate ==null ){
                        let row1 = lst[i+1];
                        $A.util.addClass(row1, "disabled");
                    }                    

                }else if(index != 0 &&  index < (i+1) && sessioneditRecs[i].sessionDate == null && !followingTrue && index < lst.length){
                    let row = lst[i];
                    $A.util.addClass(row, "disabled");
                    //debugger;
                }*/                
            }
            component.set("v.sessioneditRec" , sessioneditRecs);
            
    },
        
    
    // this function automatic call by aura:doneWaiting event
    hideSpinner: function (component, event, helper) {
        // make Spinner attribute to false for hide loading spinner
        component.set("v.Spinner", false);
    },
        
    signOut: function (component, event, helper) {
        //window.history.back();
        //component.set("v.pagenumber", 1);
        /*var navService = component.find("navService");
        var pageReference = {
                             type: 'comm__namedPage',
                             attributes: {
                                             name: 'LoginPage__c'
                                        }, 
                             state: {
                                
                                    }
        };
        setTimeout(function(){ $A.get('e.force:refreshView').fire(); }, 10);*/
        let urlParams = "https://d1m0000000eijeaq--bigquery.sandbox.my.site.com/dataentryform/s/loginpage";
        window.location.assign(urlParams);
    },
        
    // ----Piyush (26/01/23)
    /*addAssementBtnHandler: function (component, event, helper) {
        var displayStudents = component.get('v.displayBatchStudents');
        if(displayStudents){
            component.set('v.displayBatchStudents',false);
        }else{
            component.set('v.displayBatchStudents',true);
        }
    },*/
        
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

})