({
    doInit : function(component, event, helper) {
        debugger;
        var locURL = window.location.pathname;
        var str = locURL.split("/");
        var data = str[str.length - 1];
        component.set("v.currPage",data);
    }
})