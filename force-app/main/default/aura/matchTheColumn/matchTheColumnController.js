({
    doInit : function(component, event, helper) {
    },
    
    onChange : function(component, event, helper) {
        debugger;
        var dropDown = component.get("v.templistA");
       	//alert(event.getSource().get("v.value"));
        var selecteddrop = event.getSource().get("v.value");
        var selecteddropName = event.getSource().get("v.name");
        /*for (var i = 0; i <= dropDown.length; i++) {
            if (dropDown[i].label2 == event.getSource().get("v.name")) {
                selecteddrop = dropDown[i].label2;
                break;
            }
        }*/
        
        for(var i=0;i<dropDown.length;i++){
            let tempOpt = dropDown[i].selectopt;
            if(selecteddropName != dropDown[i].label2){
              /*  
                console.log('Hi '+JSON.stringify(tempOpt));
                for(let j=0;j<tempOpt.length; j++){
                    if(selecteddrop == tempOpt[j].label)
                    tempOpt[j].disabled = true;
                    
                 //  if(selecteddrop != tempOpt[j].label && !tempOpt[j].selected)
                 //   tempOpt[j].disabled = false;
                }
               
                dropDown[i].selectopt = tempOpt; */
            }
            else if(selecteddropName == dropDown[i].label2){
                for(let j=0;j<tempOpt.length; j++){
                    if(selecteddrop == tempOpt[j].label)
                    tempOpt[j].selected = true;
                }
                dropDown[i].selectopt = tempOpt;
            }
            
            
        }
        console.log(dropDown);
        
        component.set("v.templistA",dropDown);
    }
})