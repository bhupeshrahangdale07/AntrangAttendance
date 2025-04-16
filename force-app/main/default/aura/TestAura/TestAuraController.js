({
    handleCreateContact: function(component, event) {
        var saveContactAction = component.get("c.createContact");
            saveContactAction.setParams({
                "contact": component.get("v.newContact")
            });
        
        // Configure the response handler for the action
        saveContactAction.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.message", "Contact created successfully");
            }
            else if (state === "ERROR") {
                console.log('Problem saving contact, response state: ' + state);
            }
            else {
                console.log('Unknown problem, response state: ' + state);
            }
        });

        // Send the request to create the new contact
        $A.enqueueAction(saveContactAction);
    },
})