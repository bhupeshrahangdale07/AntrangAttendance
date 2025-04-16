({
    handleDateChange : function(component,event,helper) {
        //debugger;
        component.set("v.showSaveCancelBtn",true);
        if(event.getSource().get('v.name') == 'SessionLink')
            component.set("v.latestLink",event.getSource().get('v.value'));
        
        var sNo = component.get("v.sNo");
        if(event.getSource().get('v.name') == 'SessionDate'){
            console.log('Date :: '+event.getSource().get('v.value'));
            let currentDateInput = component.find("SessionDate");
            let sessioneditRecs = component.get("v.sessioneditRec");
            
            let sessionrecordIndex = sNo;
            var g1 = null;
            var g2 = null;
            var g3 = null;
            let isconfirm = false;
            if(sNo > 0){
                g1 = new Date(sessioneditRecs[sNo-1].sessionDate);
            }
            if(sNo > 0 &&  sNo < sessioneditRecs.length-1 &&  sessioneditRecs[sNo+1].sessionDate != null){
                g3 = new Date(sessioneditRecs[sNo+1].sessionDate);
            }
            
            if(sessioneditRecs && (sessioneditRecs.length -1) != (sNo) ){
                if(((sessioneditRecs[sNo].sessionDate == null || sessioneditRecs[sNo].sessionDate == '')&& sessioneditRecs[sNo+1].sessionDate != null) ||
                   (sessioneditRecs[sNo].sessionDate != null && sessioneditRecs[sNo+1].sessionDate != null &&
                    sessioneditRecs[sNo].sessionDate > sessioneditRecs[sNo+1].sessionDate)){
                    isconfirm = true;
                }
                if(sessioneditRecs[sNo].sessionDate == ''){
                    sessioneditRecs[sNo].sessionDate = null;
                }
            }    
            if(isconfirm && window.confirm('Deleting date or changing date to date later than the next session date will delete all dates for all subsequent sessions for the batch. \nDo you want to proceed (Y/N)?')) {
                if(sessioneditRecs[sNo].sessionDate == null){
                   sessioneditRecs[sNo].startTime = null;
                sessioneditRecs[sNo].mode = null;
                sessioneditRecs[sNo].link = null; 
                }
                
                sessioneditRecs.forEach(function (q, idx){
                    if(idx > sNo){
                        q.sessionDate = null;
                        q.startTime = null;
                        q.mode = null;
                        q.link = null;
                        
                        
                        var cmpEvent = component.getEvent("sessionFormEvt"); 
                        //Set event attribute value
                        cmpEvent.setParams({"index" : idx}); 
                        cmpEvent.fire(); 
                    }
                    
                });
                
                
                component.set("v.sessioneditRec", sessioneditRecs);
                
                /*g2 = new Date(event.getSource().get('v.value'));
                let lessdt = false;
                if (g1.getTime() > g2.getTime()){
                    console.log('Error');
                    currentDateInput.setCustomValidity("Session Date cannot be less then above Session Date");
                    lessdt = true;
                    if(sessioneditRecs[sNo].sessionDate == null){
                        currentDateInput.setCustomValidity("");
                        lessdt = false;
                    }
                }else{
                    currentDateInput.setCustomValidity("");
                }
                if (g3 != null && g3.getTime() < g2.getTime()){
                    console.log('Error');
                    currentDateInput.setCustomValidity("Session Date cannot be greater then below Session Date");
                    if(sessioneditRecs[sNo].sessionDate == null){
                        currentDateInput.setCustomValidity("");
                    }
                }else if(!lessdt){
                    currentDateInput.setCustomValidity("");
                }                
                
                currentDateInput.reportValidity();*/
            }else{
                /*debugger;
                //let sessioneditRecTemp = component.get("v.sessioneditRecTemp");
                let singleRec = component.get("v.singleRec");
                if(singleRec.sessionDate){
                    
                singleRec.sessionDate = component.get("v.currentdt");
                component.set("v.singleRec",singleRec);
                }*/
                
                
            }  /*else{
                // let isdateerror = false;
                // sessioneditRecs.forEach(function (q, idx){
                //     if(idx > sNo){
                //         if(sessioneditRecs[idx].sessionDate != null){
                //             let dt1= new Date(sessioneditRecs[sNo].sessionDate);
                //             let dt2= new Date(sessioneditRecs[idx].sessionDate); 
                //             if(dt1 > dt2){
                //                 isdateerror = true;                
                //             }
                //         }
                //     }
                // });
                
                g2 = new Date(event.getSource().get('v.value'));
                let lessdt = false;
                if (g1.getTime() > g2.getTime()){
                    console.log('Error');
                    currentDateInput.setCustomValidity("Session Date cannot be less then above Session Date");
                    lessdt = true;
                    if(sessioneditRecs[sNo].sessionDate == null){
                        currentDateInput.setCustomValidity("");
                        lessdt = false;
                        
                    }
                }else{
                    currentDateInput.setCustomValidity("");
                }
                if (g3 != null && g3.getTime() < g2.getTime()){
                    console.log('Error');
                    currentDateInput.setCustomValidity("Session Date cannot be greater then below Session Date");
                    
                    if(sessioneditRecs[sNo].sessionDate == null){
                        currentDateInput.setCustomValidity("");
                        
                    }
                }else if(!lessdt){
                    currentDateInput.setCustomValidity("");
                }
                currentDateInput.reportValidity();
            } */
            
            
        }
        
        //console.log(component.find(sNo));
        
        //Get the event using registerEvent name. 
        var cmpEvent = component.getEvent("sessionFormEvt"); 
        //Set event attribute value
        cmpEvent.setParams({"index" : sNo}); 
        cmpEvent.fire(); 
        
        
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
        
})