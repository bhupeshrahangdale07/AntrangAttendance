import { LightningElement, wire } from 'lwc';
import logo from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import { NavigationMixin } from 'lightning/navigation';
import { CurrentPageReference } from 'lightning/navigation';
export default class FacilitatorPaymentLogo extends NavigationMixin(LightningElement) {
    antarangImage = logo;
    pageName='';
    connectedCallback(){
        //get cookies start
        //console.log(this.pageName);
        // if(this.pageName != 'LoginPage__c'){
        //     var cookieString = "; " + document.cookie;
        //     var parts = cookieString.split("; " + "AntarangPaymentLogin" + "=");
        //     var antarangCookie = decodeURIComponent(parts.pop().split(";").shift());
        //     //console.log('antarangCookie',antarangCookie);
        //     if(antarangCookie != this.facilitatorEmail || antarangCookie == ''){
        //         //console.log('dsdfd');
        //         let pageReference = {
        //             type: 'comm__namedPage',
        //             attributes: {
        //                 name: 'LoginPage__c'
        //             }
        //         };
        //         this[NavigationMixin.Navigate](pageReference);
        //     }
        // }
        //get cookies ends 
    }
    // @wire(CurrentPageReference)
    // getStateParameters(currentPageReference) {
    //     this.pageName=currentPageReference.attributes.name;
    //    if (currentPageReference) 
    //       this.facilitatorEmail = decodeURI(currentPageReference.state.fem);
    // }
}