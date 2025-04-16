({
    waitingTimeId: null,
    setStartTimeOnUI : function(component, event, helper) {
        component.set("v.ltngIsDisplayed",true);
        var currTime =component.get("v.ltngTimmer");
        var ss = currTime.split(":");
        var dt = new Date();
        dt.setHours(ss[0]);
        dt.setMinutes(ss[1]);
        dt.setSeconds(ss[2]);
        console.log("currTime " + currTime);
        var dt2 = new Date(dt.valueOf() - 1000);
        var temp = dt2.toTimeString().split(" ");
        var ts = temp[0].split(":");
        
        component.set("v.ltngTimmer",ts[0] + ":" + ts[1] + ":" + ts[2]);
        this.waitingTimeId =setTimeout($A.getCallback(() => this.setStartTimeOnUI(component)), 1000);
        
        if(ts[0]==0 && ts[1]==0 && ts[2]==0){
            window.clearTimeout(this.waitingTimeId);
            var parentEvent = $A.get("e.c:ParentTimerEvent");
            parentEvent.setParams({
                "totalDuration" : "00"
            });
            parentEvent.fire();
        } else {
            document.cookie = "pageNumber=" + component.get("v.pageNumber");
            document.cookie = "pageType=" + component.get("v.pageType");
            document.cookie = "spentTime=" + component.get("v.ltngTimmer");
        }
    },
    clearTimer: function(component, event, helper) {
        window.clearTimeout(this.waitingTimeId);
    }
})