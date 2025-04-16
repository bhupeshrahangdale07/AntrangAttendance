({
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
        console.log(' selectedId : ' +selectedId);
        console.log(' selectedValue : ' +selectedValue);
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