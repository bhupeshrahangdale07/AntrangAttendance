({    
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
            }else{
                component.set("v.cityId", '');
            }
        }
        
        if (sObject == "Account") {
            let accountId = event.getParam("AccountId");        
               
            if(accountId != undefined && accountId != null && accountId != ''){
                component.set("v.AccountId", accountId);
                //CUSTOMCODE : 1. Here First Change is DOne
                component.set(
                    "v.StudentWhareClause",
                    " AND G10_Batch_Code__r.School_Name__c = '" +
                    accountId +
                    "' ORDER BY NAME "
                );
                //till here.......
            }
            else
            {
                component.set("v.AccountId", null);
                component.set("v.StudentWhareClause",'');
            }
        }
        
        if (sObject == "Contact") {
            let contactId = event.getParam("ContactId");
            if(contactId != undefined && contactId != null && contactId != ''){
                 component.set("v.ContactId", contactId); 
            }else{
                component.set("v.ContactId", null);
            }
        }

    },
    handleLogin : function (component, event, helper) {        
    
        
		let cityId = component.get("v.cityId");
        let accountId = component.get("v.AccountId");
        let contactId = component.get("v.ContactId");
        var validity = false;

        if(cityId != undefined && cityId != null && cityId != '' &&  
            accountId != undefined && accountId != null && accountId != '' &&
            contactId != undefined && contactId != null && contactId != ''){
            validity = true;
        }  
        if(validity && component.get("v.SelectedLanguage") != ""){
            helper.handleStartExam(component, event, helper);            
        }else{
            helper.showMessage(component, event,"Please enter all details to proceed!", "ERROR", "error");
        }
        

    },
    // this function automatic call by aura:waiting event  
    spinnerDisplayHandler: function(component, event, helper) {        
        helper.showHideSpinner(component); 
    }
})