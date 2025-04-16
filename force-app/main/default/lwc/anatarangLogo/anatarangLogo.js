import { LightningElement, wire } from 'lwc';
import logo from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import { NavigationMixin } from 'lightning/navigation';
import { CurrentPageReference } from 'lightning/navigation';
import logUserExit from '@salesforce/apex/DataEntryLoginFormController.logUserExit';


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
        else if(this.pageName != 'LoginPage__c' || this.pageName != 'LoginPageV2__c'){
            var cookieString = "; " + document.cookie;
            var parts = (this.facilitatorformType !== 'undefined' && this.facilitatorformLanguage !== 'undefined') ? cookieString.split("; " + "AntarangLoginV2" + "=") : cookieString.split("; " + "AntarangLogin" + "=");
            var antarangCookie = decodeURIComponent(parts.pop().split(";").shift());
            console.log('antarangCookie',antarangCookie);
            if(antarangCookie != this.facilitatorEmail || antarangCookie == ''){
                let pageReference = {
                    type: 'comm__namedPage',
                    attributes: {
                        name: 'LoginPage__c'
                    }
                };
                //this[NavigationMixin.Navigate](pageReference);
                if(this.facilitatorformType !== 'undefined' && this.facilitatorformLanguage !== 'undefined') this.redirectPage('LoginPageV2__c');
                //else this.redirectPage('LoginPage__c');

            }
        }
        //get cookies ends 
        /*console.log("All cookies", document.cookie);
        window.addEventListener('beforeunnload',function(){
            document.cookie = "AntarangLoginV2=;"
        });*/
         window.addEventListener("beforeunload", this.handleTabClose);
        console.log("connectedCallback executed");
        console.log("beforeUnloadHandler called",document.cookie);

    }
    /*beforeUnloadHandler(ev) {
        document.cookie = "AntarangLoginV2=;"
        console.log("beforeUnloadHandler called",document.cookie);
        return "";
    }*/
    disconnectedCallback() {
        //window.removeEventListener("beforeunload", this.beforeUnloadHandler);
        //console.log("disconnectedCallback executed");
        window.removeEventListener('beforeunload', this.handleTabClose);
    }
     baseUrl = window.location.origin;
    handleTabClose = (event) => {
        const nextUrl = event.target?.document?.activeElement?.baseURI || document.activeElement?.baseURI;
        
        // Call Apex only if the user is leaving the base URL (not refreshing or navigating within it)
        //if (!nextUrl || !nextUrl.startsWith(this.baseUrl)) {
            logUserExit()
                .then(() => {
                    console.log('User exit logged successfully.');
                })
                .catch(error => {
                    console.error('Error logging user exit:', error);
                });
        //}
    };
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