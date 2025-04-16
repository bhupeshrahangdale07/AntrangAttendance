({
    
    handleChange : function(component,event,helper){
        component.set("v.showSaveCancelBtn",true);
        if(event.getSource().get('v.name') == 'SessionLink')
            component.set("v.latestLink",event.getSource().get('v.value'));
        
        /*if(component.get("v.singleRec.status") == 'Answered'){
            component.set("v.singleRec.isVisible",false);
        } else {
            component.set("v.singleRec.isVisible",true);
        }*/
        
        if(component.get("v.singleRec.counselingType") == 'In person' || component.get("v.singleRec.counselingType") == 'Digital'){
            component.set("v.singleRec.isParentVisible", false);
            component.set("v.singleRec.isPhoneFieldsVisible", true);
        } else if (component.get("v.singleRec.counselingType") == 'Phone counseling') {
            component.set("v.singleRec.isParentVisible", true);
            component.set("v.singleRec.isPhoneFieldsVisible", false);
        } else {
            component.set("v.singleRec.isParentVisible", true);
            component.set("v.singleRec.isPhoneFieldsVisible", true);
        }
    },
    
    handleForCounselingType : function(component, event, helper) {
        if(component.get("v.singleRec.counselingType") == 'In person'){
            component.set("v.singleRec.isParentVisible", false);
        }
    },
    
    handleComponentEvent: function(component,event,helper) { 
        var selecedValues = event.getParam("values"); 
        component.set("v.singleRec.reason", selecedValues); 
    },
    
    doInit : function(component, event, helper) {
        var singlerecd = component.get("v.singleRec");
        
        if(singlerecd.selectedReason != null && singlerecd.selectedReason != undefined){
            var data = singlerecd.selectedReason.split(';');
            
            var selecetdData = [];
            data.forEach(d => {
                selecetdData.push({d});
            });
                component.set("v.selectedOptions",selecetdData);
                
            }
            },
            })