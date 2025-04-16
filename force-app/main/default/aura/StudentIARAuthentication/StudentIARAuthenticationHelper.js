({    
    handleStartExam : function (component, event, helper) {
        var studentId = component.get("v.ContactId");
        
        if(studentId && component.get("v.SelectedLanguage") != '' && component.get("v.AccountId") != undefined) {
            var reqPage = '';
            if(component.get("v.isInterestPage")){
                reqPage = 'I';
            } else if(component.get("v.isAptitudePage")){
                reqPage = 'A';
            } else if(component.get("v.isRealityPage")){
                reqPage = 'R';
            }
            
            var address = window.location.origin+'/iar/s/wel-come?contactId='+studentId+'&len='+component.get('v.SelectedLanguage')+'&req='+reqPage;
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": address
            });                
            urlEvent.fire();     
        } else {
            if(component.get("v.SelectedLanguage") == ''){
                helper.showMessage(component, event, 'Language is required.', 'Error', 'error');
            } 
            if(studentId == undefined){
                helper.showMessage(component, event, 'Student is required.', 'Error', 'error');
            }
            if(component.get("v.AccountId") == undefined){
                helper.showMessage(component, event, 'School is required.', 'Error', 'error');
            }
        }
    },
    
    showMessage: function (component, event, message, title, severity) {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":severity
        });
        toastEvent.fire();
    },
})