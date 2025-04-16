import {LightningElement, api, wire, track} from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
export default class Baselinepopup extends LightningElement {
    antarangImage = logo_01;
    @api fields ;
    @wire(CurrentPageReference)
    getCurrentPageRefxerence(currentPageReference) {
        if(currentPageReference) 
        {
            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            this.fields = rxCurrentPageReference.state.fields;
            console.log('this.fields ',this.fields)
        }

    }
    connectedCallback(){
        console.log('fields',this.fields);
    }
}