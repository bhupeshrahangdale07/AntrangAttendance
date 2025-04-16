({
    /*init: function (component, event, helper) {
        debugger;
        var sURL = decodeURIComponent(window.location.href);
        console.log(sURL);
        if(sURL.includes('?')){
            var params = sURL.split('?')[1].split('&');
            if(params.length == 3){
                component.set("v.formLng",decodeURI(params[2].split('=')[1]));
                if(component.get("v.formLng") == 'English'){
                    console.log('$$$ English');
            		component.set("v.isEnglish",true);
                    component.set("v.searchPlaceHolder", "Select the Grade/Class from the drop down below");
                }else{
                    console.log('$$$ Hindi');
                    component.set("v.isEnglish",false);
                    component.set("v.searchPlaceHolder", "Select the Grade/Class from the drop down below");
                }
            }else if(params.length == 7){
                component.set("v.formLng",decodeURI(params[6].split('=')[1]));
                //console.log('v.formLng: '+decodeURI(params[6].split('=')[1]));
                console.log('v.formLng: '+component.get("v.formLng"));
				//v.isEnglish = (component.get("v.formLng") == 'English') ? true : false;
				if(component.get("v.formLng") == 'English'){
                    console.log('$$$ English');
            		component.set("v.isEnglish",true);
                    component.set("v.searchPlaceHolder", "Select the Grade/Class from the drop down below");
                }else{
                    console.log('$$$ Hindi');
                    component.set("v.isEnglish",false);
                    component.set("v.searchPlaceHolder", "नीचे ड्रॉप डाउन से ग्रेड/क्लास का चयन करें");
                }
                console.log('$$$ v.isEnglish: '+component.get("v.isEnglish"));
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
    }*/
    searchHandler: function (component, event, helper) {
        const searchString = event.target.value;
        if (searchString.length >= 2) {
            //component.set("v.inputValue", "");
            //Ensure that not many function execution happens if user keeps typing
            if (component.get("v.inputSearchFunction")) {
                clearTimeout(component.get("v.inputSearchFunction"));
            }
            
            var inputTimer = setTimeout(
                $A.getCallback(function () {
                    helper.searchRecords(component, searchString);
                }),
                1000
            );
            component.set("v.inputSearchFunction", inputTimer);
        } else {
            component.set("v.results", []);
            component.set("v.openDropDown", false);
        }
        
        let inputval = component.set("v.inputValue");
        if (inputval == undefined || inputval == null || inputval == "") {
            let objectApiName = component.get("v.objectApiName");
            
            if (objectApiName == "District_Master__c") {
                var compEvent = component.getEvent("StudentFeedbackSpecific");
                compEvent.setParams({ sObject: objectApiName, CityId: "" });
                compEvent.fire();
            }
            if (objectApiName == "Account") {
                //console.log(selectedId + ' --A-- ' + selectedValue);
                var compEvent = component.getEvent("StudentFeedbackSpecific");
                compEvent.setParams({ sObject: objectApiName, AccountId: "" });
                compEvent.fire();
            }
            if (objectApiName == "Contact") {
                //console.log(selectedId + ' --C-- ' + selectedValue);
                var compEvent = component.getEvent("StudentFeedbackSpecific");
                compEvent.setParams({ sObject: objectApiName, ContactId: "" });
                compEvent.fire();
            }
            if (objectApiName == "Batch__C") {
                //console.log(selectedId + ' --C-- ' + selectedValue);
                var compEvent = component.getEvent("StudentFeedbackSpecific");
                compEvent.setParams({ sObject: objectApiName, BatchId: "" });
                compEvent.fire();
            }
        }
    },
    
    optionClickHandler: function (component, event, helper) {
        const selectedId = event.target.closest("li").dataset.id;
        const selectedValue = event.target.closest("li").dataset.value;
        console.log(' selectedId' +selectedId);
        console.log(' selectedValue ' +selectedValue);
        component.set("v.inputValue", selectedValue);
        component.set("v.openDropDown", false);
        component.set("v.selectedOption", selectedId);
        
        let objectApiName = component.get("v.objectApiName");
        
        if (objectApiName == "District_Master__c") {
            var compEvent = component.getEvent("StudentFeedbackSpecific");
            compEvent.setParams({ sObject: objectApiName, CityId: selectedId });
            compEvent.fire();
        }
        if (objectApiName == "Account") {
            //console.log(selectedId + ' --A-- ' + selectedValue);
            var compEvent = component.getEvent("StudentFeedbackSpecific");
            compEvent.setParams({ sObject: objectApiName, AccountId: selectedId });
            compEvent.fire();
        }
        if (objectApiName == "Contact") {
            //console.log(selectedId + ' --C-- ' + selectedValue);
            var compEvent = component.getEvent("StudentFeedbackSpecific");
            compEvent.setParams({ sObject: objectApiName, ContactId: selectedId, ContactName: selectedValue});
            compEvent.fire();
        }
        
        if (objectApiName == "Batch__C") {
            //console.log(selectedId + ' --C-- ' + selectedValue);
            var compEvent = component.getEvent("StudentFeedbackSpecific");
            compEvent.setParams({ sObject: objectApiName, BatchId: selectedId });
            compEvent.fire();
        }
    },
    
    clearOption: function (component, event, helper) {
        component.set("v.results", []);
        component.set("v.openDropDown", false);
        component.set("v.inputValue", "");
        component.set("v.selectedOption", "");
        
        let inputval = component.set("v.inputValue");
        if (inputval == undefined || inputval == null || inputval == "") {
            let objectApiName = component.get("v.objectApiName");
            if (objectApiName == "District_Master__c") {
                var compEvent = component.getEvent("StudentFeedbackSpecific");
                compEvent.setParams({ sObject: objectApiName, CityId: "" });
                compEvent.fire();
            }
            if (objectApiName == "Account") {
                //console.log(selectedId + ' --A-- ' + selectedValue);
                var compEvent = component.getEvent("StudentFeedbackSpecific");
                compEvent.setParams({ sObject: objectApiName, AccountId: "" });
                compEvent.fire();
            }
            if (objectApiName == "Contact") {
                //console.log(selectedId + ' --C-- ' + selectedValue);
                var compEvent = component.getEvent("StudentFeedbackSpecific");
                compEvent.setParams({ sObject: objectApiName, ContactId: "" });
                compEvent.fire();
            }
            if (objectApiName == "Batch__C") {
                //console.log(selectedId + ' --C-- ' + selectedValue);
                var compEvent = component.getEvent("StudentFeedbackSpecific");
                compEvent.setParams({ sObject: objectApiName, BatchId: "" });
                compEvent.fire();
            }
        }
        
        component.set("v.inputValue", "");
        component.set("v.selectedOption", "");
    }
});