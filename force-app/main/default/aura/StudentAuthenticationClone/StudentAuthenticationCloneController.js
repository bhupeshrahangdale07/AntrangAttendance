({
    onMediumChange: function (component, event, helper) {
        if(component.get("v.cityId") != undefined && component.get("v.cityId") != null 
           && component.get("v.SchoolWhareClause") != undefined && component.get("v.SelectedMedium") != ''
           && component.get("v.SchoolWhareClause") != null){
            
            component.set("v.SchoolWhareClause",
				component.get("v.SchoolWhareClause")+
                " AND Medium_Language_of_Instruction__c = '"+
                component.get("v.SelectedMedium") +
                "' ORDER BY Name");
        }
    },
    
    saveContact : function (component, event, helper) {
        if (helper.isValid(component)) {
        	helper.handleSaveContact(component, event, helper);
        }
    },
    
	onwrpEventUpdate: function (component, event, helper) {
        let sObject = event.getParam("sObject");
        
        if (sObject == "District_Master__c") {
            let cityId = event.getParam("CityId");
            
            if(cityId != undefined && cityId != null && cityId != ''){
                component.set("v.cityId", cityId);
                component.set(
                    "v.SchoolWhareClause",
                    " AND District__c = '" +
                    cityId +"'" 
                );
            }
        }        
        
        if (sObject == "Account") {
            let accountId = event.getParam("AccountId");
            
            if(accountId != undefined && accountId != null && accountId != ''){
                component.set("v.AccountId", accountId);
                component.set(
                    "v.StudentWhareClause",
                    " AND Batch_Code__r.School_Name__c = '" +
                    accountId +
                    "' AND day_only(Batch_Code__r.Date_of_facilitation_starting__c) >= 2020-05-01 ORDER BY NAME"
                );
            }
        }
        
        let contactId;
        if (sObject == "Contact") {
            contactId = event.getParam("ContactId");
            component.set("v.ContactId", contactId);
        }
    },
    handleLogin : function (component, event, helper) {        
        helper.retrieveStudentData(component, event, helper);
    },
    // this function automatic call by aura:waiting event  
    spinnerDisplayHandler: function(component, event, helper) {        
        helper.showHideSpinner(component); 
    }
})