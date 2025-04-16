({
    // onMediumChange: function (component, event, helper) {
    //     if(component.get("v.cityId") != undefined && component.get("v.cityId") != null 
    //        && component.get("v.SchoolWhareClause") != undefined && component.get("v.SelectedMedium") != ''
    //        && component.get("v.SchoolWhareClause") != null){
            
    //         var existingWhereClause = component.get("v.SchoolWhareClause");
    //         var finalWhereClause = '';
    //         if(existingWhereClause.indexOf('Medium_Language_of_Instruction__c') != - 1){
    //             const firstStrArray = existingWhereClause.split('AND Medium_Language_of_Instruction__c =');
                
    //             if(firstStrArray.length > 1){
    //                 const secondStrArray = firstStrArray[1].split('ORDER BY Name');
    //                 finalWhereClause = firstStrArray[0] + " AND Medium_Language_of_Instruction__c = '" + component.get("v.SelectedMedium") + "' ORDER BY Name "  +secondStrArray[1];
    //             	component.set("v.SchoolWhareClause",finalWhereClause);
    //             }
    //         }else{
    //             component.set("v.SchoolWhareClause",
    //                 component.get("v.SchoolWhareClause")+
    //                 " AND Medium_Language_of_Instruction__c = '"+
    //                 component.get("v.SelectedMedium") +
    //                 "' ORDER BY Name");
    //         }      
    //     }
    // },
    
    // saveContact : function (component, event, helper) {
    //     if (helper.isValid(component)) {
    //     	helper.handleSaveContact(component, event, helper);
    //     }
    // },
    
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
                //1. Idr First Change Kia hai 
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

        console.log("validity :: "+validity);
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