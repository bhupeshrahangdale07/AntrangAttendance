({
    doInit: function(component,event,helper) {
        
        helper.handleDateChange(component,event,helper);
        // Set the attribute value.
        // You could also fire an event here instead.
        //alert('test');
    },
    
     handleChange : function(component,event,helper){
            component.set("v.showSaveCancelBtn",true);
         if(event.getSource().get('v.name') == 'SessionLink')
             component.set("v.latestLink",event.getSource().get('v.value'));
         
         if(event.getSource().get('v.name') == 'mode'){
             let singleRec = component.get("v.singleRec");
             if(singleRec.mode != 'Digital'){
                 singleRec.link = '';
                 component.set("v.singleRec",singleRec);
             }
         }
         
    },
    
    
   /* handledtChange : function(component,event,helper){
    debugger;
        let sessioneditRec = component.get("v.sessioneditRec");
        var sNo = component.get("v.sNo");
        if(sNo != 0 && sessioneditRec[sNo-1].sessionDate && !sessioneditRec[sNo-1].isAttendenceFound){
            helper.showMessageToast(component, event, helper, 'Please fill the form with proper data!', "warning");
        }
        
  },*/
    
    doValidityCheck : function(component,event,helper){
    //do validity check here
    return booleanValue;
  },
    
    
    
    handleDateChange : function(component,event,helper){
        let sessioneditRecs = component.get("v.sessioneditRec");
        var sNo = component.get("v.sNo");
        if(sNo != 0 && sessioneditRecs[sNo-1].sessionDate &&
           !sessioneditRecs[sNo-1].isAttendenceFound && sessioneditRecs[sNo].sessionDate && !sessioneditRecs[sNo].isParentSession){
            helper.showMessageToast(component, event, helper, 'Attedence is Pending for Session : '+sessioneditRecs[sNo-1].name+'!', "warning");
        }
        if(!sessioneditRecs[sNo].isParentSession){
            helper.handleDateChange(component,event,helper);
        }
         
    },
    
    onwrpEventUpdate: function (component, event, helper) {
        //console.log("--- onwrpEventUpdate: ");
        
        let sObject = event.getParam("sObject");
        if (sObject == "Contact") {
            let contactId = event.getParam("ContactId");
            let contactName = event.getParam("ContactName");
            let d = new Date();
            let yearToSub = d.getMonth() > 4 ? 1 : 2;
            let firstMay = d.getFullYear() - yearToSub +'-05-01';
            let nextYearApril = d.getFullYear() + yearToSub + '-04-30';
            if(contactId != undefined && contactId != null && contactId.length > 0){
                let singleRec = component.get("v.singleRec");
                singleRec.facilitatorId = contactId;
                singleRec.facilitatorName = contactName;
                component.set("v.singleRec",singleRec);
            }else{
                
            }
        }
        
    },
    
    handleClearFacilitator : function (component, event, helper) {
        let singleRec = component.get("v.singleRec");
                singleRec.facilitatorId = null;
        		singleRec.facilitatorName = null;
                component.set("v.singleRec",singleRec);
        
    }
    
   /* handleBlur: function (component,event,helper) {
        var allValid = component.find('sessionEdit').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        if (allValid) {
            component.set("v.isValidAll",true);
            //console.log('All form entries look valid. Ready to submit!');
        } else {
            component.set("v.isValidAll",false);
           // console.log('Please update the invalid form entries and try again.');
        }
        
    } */
   
})