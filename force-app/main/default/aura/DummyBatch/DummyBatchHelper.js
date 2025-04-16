({
    /*openConfirm: function(component, event) {
        this.LightningConfirm.open({
            message: 'You want to create a Dummy Batch for it.',
            theme: 'warning',
            label: 'Please Confirm',
        }).then(function(result) {
            // result is true if clicked "OK"
            // result is false if clicked "Cancel"
            console.log('confirm result is', result);
            
            if(result){
                this.processDummyBatch(component, event);
            }else{
                $A.get("e.force:closeQuickAction").fire();
            }
            
        });
    },
    */
    processDummyBatch: function(component, event) {
        var action = component.get("c.cloneRecord");
        action.setParams({ recordId : component.get("v.recordId") });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                //alert(response.getReturnValue().substr(0,7));
                if(response.getReturnValue().substr(0,7) =="SUCCESS" ){
                    var updatedRecordId = response.getReturnValue().substr(7);
                    
                    console.log("response.getReturnValue(): ",response.getReturnValue());
                    console.log("updatedRecordId : ",updatedRecordId);
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "success",
                        "title": "Success!",
                        "message": "record is successfully cloned"
                    });
                    toastEvent.fire();
                    
                    
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": updatedRecordId,
                        "slideDevName": "related"
                    });
                    navEvt.fire();
                    
                    
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "warning",
                        "title": "Alert!",
                        "message": response.getReturnValue()
                    });
                    toastEvent.fire();
                }
                
                //$A.get("e.force:closeQuickAction").fire();
                
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "ERROR!",
                    "message": "The record is successfully Cloned."
                });
            }
            component.set("v.showSpinner",false);
            $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
    }
});