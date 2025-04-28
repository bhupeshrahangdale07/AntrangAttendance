import { LightningElement, wire, track } from 'lwc';
import sessionSignOut from '@salesforce/apex/SessionDetailController.sessionSignOut';
import {NavigationMixin} from "lightning/navigation";
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SesssionStudentAttendance extends NavigationMixin(LightningElement) {
    @track facEmailId;
    code;
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference){
        if (currentPageReference){
            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            this.code = rxCurrentPageReference.state.code ? decodeURI(rxCurrentPageReference.state.code) : null;
            this.facEmailId = rxCurrentPageReference.state.facilitorId ? decodeURI(rxCurrentPageReference.state.facilitorId) : null;
            console.log('code =',this.code)
            console.log('facEmailId = ',this.facEmailId) 
        }
    }
    handleSignOut(event){
        this.sessionSignOutFunc();
    }
    showToastMessage(message,variant){
        const event = new ShowToastEvent({
                title : 'Session Detail',
                message : message,
                variant : variant
            });
            this.dispatchEvent(event);
    }
    sessionSignOutFunc(){
        
        sessionSignOut({
            strEmail : this.facEmailId
        })
        .then(result => {
            console.log('result sessionSignOut = ',result);
            if(result){
                this.showToastMessage('Sign Out Successfully','success');
                window.name=''; 
            }
            this.backToLogin();
            this.showLoading = false;
            
        }).catch(error => {
            this.showToastMessage(error.body.message,'error');
            console.log(error.body.message);
        });
    }
    backToLogin(){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'SessionLogin__c'
            }
        });
    }
    connectedCallback() {
       window.addEventListener("beforeunload", this.handleTabClose);
       console.log('this.code = ',this.code);
        if(this.code == window.name){
            if(!this.code || !this.facEmailId){
                console.log('a');
                this.showToastMessage('Error While Login','error');
                this.backToLogin();
            }else{
                // this.showLoading = false;
                // this.getPendingSessionFunc();
                // this.getdynamicpicklistvalFunc();
            }
            
        }else{
            console.log('b');
            this.showToastMessage('This form is already open in another tab!','error');
            this.backToLogin();
        }
    }
    disconnectedCallback() {
        window.removeEventListener('beforeunload', this.handleTabClose);
    }
    handleTabClose = (event) => {
        this.sessionSignOutFunc();
        /*const nextUrl = event.target?.document?.activeElement?.baseURI || document.activeElement?.baseURI;
        if (!nextUrl || !nextUrl.startsWith(this.baseUrl)) {
            this.sessionSignOut();
        }*/

    };
}