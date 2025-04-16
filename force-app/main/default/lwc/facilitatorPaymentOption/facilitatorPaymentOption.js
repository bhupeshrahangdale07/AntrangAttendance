import { LightningElement, wire } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import {CurrentPageReference} from 'lightning/navigation';
export default class FacilitatorPaymentOption extends  NavigationMixin(LightningElement) {
    fem = '';
    userType = '';

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference){
          this.fem = decodeURI(currentPageReference.state.fem);
          this.userType = currentPageReference.state.userType ? decodeURI(currentPageReference.state.userType) : '';
        }
    }
    redirectPage(pageApi){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: pageApi
            },
            state:{
                fem : encodeURI(this.fem)
            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }
    handleGenrateClick(event){
        this.redirectPage('GenrateInvoiceForm__c');
    }
    handleConfirmClick(event){
        this.redirectPage('ConfirmPaymentForm__c');
    }
}