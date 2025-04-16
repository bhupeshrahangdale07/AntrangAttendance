({
    callChildEvent : function(component, event, helper) {
        var minutes = event.getParam("totalDuration");
        var hours = "00";
        var rminutes = "00";
        var second = "00";
        if(String(minutes).includes(":")){
            rhours = minutes.split(":")[0];
            rminutes = minutes.split(":")[1];
            second = minutes.split(":")[2];
        } else {
            hours = (minutes / 60);
            var rhours = Math.floor(hours);
            var minutes = (hours - rhours) * 60;
            rminutes = Math.round(minutes);
        }
        component.set("v.ltngTimmer",rhours+":"+rminutes+":"+second);
        let usedTime = component.get("v.usedTime");
        if(usedTime != undefined && usedTime != null && usedTime == 0){
            helper.clearTimer(component, event, helper);
        }
        helper.setStartTimeOnUI(component, event, helper);
    },
    
    getMessage : function(component, event, helper) {
        //get method paramaters
        var params = event.getParam('arguments');
        if (params) {
            var param1 = params.btnAction;
            if(param1 == 'nextClicked') {
                debugger;
                component.set("v.nextclicked",true);
                helper.waitingTimeId =null;
                window.clearTimeout(helper.waitingTimeId);
            }
        }
    }
})