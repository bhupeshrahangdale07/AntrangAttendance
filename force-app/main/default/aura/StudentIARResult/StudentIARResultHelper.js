({
	showHideSpinner : function(component) {
        var showValue = component.get('v.show');
        
        if(showValue) {
            console.log('showValue'+showValue);
            var spinner = component.find("spinner");
            console.log('spinner'+spinner);
            $A.util.removeClass(spinner, "slds-hide");
        } else {
            console.log('showValue'+showValue);
            var spinner = component.find("spinner");
            console.log('spinner'+spinner);
            $A.util.addClass(spinner, "slds-hide");
        }
    },
    
    hidespinner: function(component) {
        window.setTimeout(
            function() {
                component.set("v.show",false);
            }, 1000
        );        
    },
    showspinner: function(component) {
        component.set("v.show",true);        
    },
})