import { LightningElement,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class PaymentOptionsForFacilitator extends NavigationMixin(LightningElement) {

prf='';
fem='';
signOut(event){
    console.log('eee');
    // debugger
        let name = 'AntarangPaymentLogin';
        let value = '';
        let days = null;
        var expires;
        if (days) {
            const date = new Date();
            date.setTime(date.getTime() + (1 * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toGMTString();
        } else {
            expires = "";
        }
        document.cookie = name + "=" + value + expires + "; path=/";
        this.showToast('success','Sign out successfully');
        this.navigationFunction('LoginPage__c');
    }
    showToast(type,message){
        const evt = new ShowToastEvent({
            message: message,
            variant: type,
        });
        this.dispatchEvent(evt);
    }
    navigationFunction(pageApi){
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
    @wire(CurrentPageReference)
        getStateParameters(currentPageReference) {
            console.log('Enter');
            if (currentPageReference) {
                this.prf = decodeURI(currentPageReference.state.UserType);
                this.fem = decodeURI(currentPageReference.state.fem);
                console.log(this.prf)
            }
    }
    handleFixedPayClick(){
        console.log('User Type '+this.prf);
        if(this.prf=='Admin'){
            this.navigationFunction('GenrateInvoiceForm__c');
        }else if(this.prf=='Supervisor'){
            this.navigationFunction('Approve_Payout__c');
        }else if(this.prf=='Finance'){
            this.navigationFunction('Generate_payout_file_for_Finance__c');
        }

    }


    handleVariablePayClick(){
        if(this.prf=='Admin'){
            this.navigationFunction('AdminVariablePay__c');
        }else if(this.prf=='Supervisor'){
            this.navigationFunction('SupervisorVariablePay__c');
        }else if(this.prf=='Finance'){
            this.navigationFunction('FinanceVariablePay__c');
        }
    }


}