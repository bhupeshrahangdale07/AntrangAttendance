import { api, LightningElement, track, wire } from 'lwc';
//import checkFacilitatorEmail from '@salesforce/apex/Namespace.loginPageController.checkFacilitatorEmail';

export default class Login_Page extends LightningElement {
    
    handleEmailChange(event){
        let facilitatorEmail = event.detail.value;
        console.log('#facilitatorEmail'+event.detail.value);
        /*clearTimeout(this.timeoutId); // no-op if invalid id
        this.timeoutId = setTimeout(() => { console.log('setTimeout'); }, 500);*/
        
        checkFacilitatorEmail({ emailId: this.facilitatorEmail })
        .then(result => {
            this.contacts = result;
        })
        .catch(error => {
            this.error = error;
        });
    }
    handleLoginClick(){

    }
}