({  
    init : function(component, event, helper) {
		var queryString = window.location.search;
		var urlParams = new URLSearchParams(queryString);
		var facilitatorEmail = urlParams.get('fem')
        component.set('v.facilitatorEmail', decodeURI(facilitatorEmail));
        
        //var sURL = window.location.href;
        var batchId = urlParams.get('bid');
        component.set('v.batchId', decodeURI(batchId));
        
        var grd = urlParams.get('grd');
        console.log(grd);
        component.set('v.selectedGrade1', decodeURI(grd));
        
      	var sch = urlParams.get('sch');
        component.set('v.sch', decodeURI(sch));
        
        var acid = urlParams.get('acid');
        component.set('v.acid', decodeURI(acid));
        
        helper.myAction(component, event, helper);
        
    },
    // getCookie : function(){
    //     var cookieString = "; " + document.cookie;
    //     var parts = cookieString.split("; " + "AntarangLogin" + "=");
    //     var antarangCookie = decodeURIComponent(parts.pop().split(";").shift());
    //     if(antarangCookie != component.get('v.facilitatorEmail')){
    //         var navService = component.find("navService");
    //         let pageReference = {
    //             type: 'comm__namedPage',
    //             attributes: {
    //                 name: 'LoginPage__c'
    //             },
    //             state:{
    //                 fem : encodeURI(component.get('v.facilitatorEmail')),
    //                 sch : encodeURI(component.get('v.sch')),
    //                 grd : encodeURI(component.get('v.selectedGrade1')), 
    //                 bid : encodeURI(component.get('v.batchId')) ,
    //                 acid: encodeURI(component.get('v.acid'))
    //             }
    //         };
    //         navService.navigate(pageReference);
    //     }
    // },
    baselineHandler : function(component, event, helper){
        /*var url = window.location.href;
        url = url.replace('/studentdetails', '/baseline01');
        window.open(url,'_self');*/
        var navService = component.find("navService");
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'Baseline01__c'
            },
            state:{
                fem : encodeURI(component.get('v.facilitatorEmail')),
                sch : encodeURI(component.get('v.sch')),
                grd : encodeURI(component.get('v.selectedGrade1')), 
                bid : encodeURI(component.get('v.batchId')) ,
                acid: encodeURI(component.get('v.acid'))
            }
        };
        navService.navigate(pageReference);
    },
    handleBack : function(component, event, helper){
       /*var url = window.location.href;
        url = url.replace('/studentdetails', '/loginpage');
        window.open(url,'_self');*/
        var navService = component.find("navService");
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'DataEntryDetailPage__c'
            },
            state:{
                fem : encodeURI(component.get('v.facilitatorEmail')),
                sch : encodeURI(component.get('v.sch')),
                grd : encodeURI(component.get('v.selectedGrade1')), 
                bid : encodeURI(component.get('v.batchId')),
                acid: encodeURI(component.get('v.acid'))
            }
        };
        navService.navigate(pageReference); 
    }
})


/*for(var i = 0; i < window.location.search.substr(1).split("&").length; i++){
            for(var j = 0; j < window.location.search.substr(1).split("&").length; j++){
                if('batchId' == window.location.search.substr(1).split("&")[i].split("=")[j]){
                    batchId = window.location.search.substr(1).split("&")[i].split("=")[j+1];
                }
            }
        }
        
         location.search.substr(1).split("&").forEach(function (item) {
          var tmp = item.split("=");
          if (tmp[0] === 'batchId'){
          	batchId = decodeURIComponent(tmp[1]);
          }else if(tmp[0] === 'batchId'){
          	batchId = decodeURIComponent(tmp[1]);
          }else if(tmp[0] === 'batchId'){
          	batchId = decodeURIComponent(tmp[1]);
          } 
        });
        
        
        
        //var pageReference = component.get("v.pageReference");
        //alert('test'+pageReference.state.batchId);
        //console.log(component.get("v.pageReference").state.batchId);*/