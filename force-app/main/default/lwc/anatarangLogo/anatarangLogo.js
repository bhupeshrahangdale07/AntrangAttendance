import { LightningElement, wire } from 'lwc';
import logo from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import { NavigationMixin } from 'lightning/navigation';
import { CurrentPageReference } from 'lightning/navigation';

export default class AnatarangLogo extends NavigationMixin(LightningElement) {
    antarangImage = logo;
    facilitatorEmail='';
    facilitatorformType='';
    facilitatorformLanguage='';
    pageName='';
    connectedCallback(){
        //get cookies start
        console.log(this.pageName);
        if(this.pageName == 'LoginPage__c'){}
        else if(this.pageName == 'LoginPageV2__c'){}
        /*else if(this.pageName != 'LoginPage__c' || this.pageName != 'LoginPageV2__c'){
            var cookieString = "; " + document.cookie;
            var parts = (this.facilitatorformType !== 'undefined' && this.facilitatorformLanguage !== 'undefined') ? cookieString.split("; " + "AntarangLoginV2" + "=") : cookieString.split("; " + "AntarangLogin" + "=");
            var antarangCookie = decodeURIComponent(parts.pop().split(";").shift());
            console.log('antarangCookie',antarangCookie);
            if(antarangCookie != this.facilitatorEmail || antarangCookie == ''){
                if(this.facilitatorformType !== 'undefined' && this.facilitatorformLanguage !== 'undefined') this.redirectPage('LoginPageV2__c');
                else this.redirectPage('LoginPage__c');

            }
        }*/
        //get cookies ends 
    }
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        this.pageName=currentPageReference.attributes.name;
       if (currentPageReference) 
          this.facilitatorEmail = decodeURI(currentPageReference.state.fem);
          this.facilitatorformType = decodeURI(currentPageReference.state.typ);
          this.facilitatorformLanguage = decodeURI(currentPageReference.state.lng);
    }
    redirectPage(pageName){
        let pageReference = {
                    type: 'comm__namedPage',
                    attributes: {
                        name: pageName
                    }
                };
        this[NavigationMixin.Navigate](pageReference);
    }
    
}