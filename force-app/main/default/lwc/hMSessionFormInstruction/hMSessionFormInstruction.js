import { LightningElement } from 'lwc';
export default class HMSessionFormInstruction extends LightningElement {
    renderedCallback() {
        if (typeof window !== 'undefined') {
            const style = document.createElement('style');
            style.innerText =  `.statusBtn button.slds-button.slds-button_brand {
                width: 85%;
            }@media (max-width: 767px) {
                div.statusBtn button.slds-button.slds-button_brand {
                    width: 85%;
                    font-size: 9px;
                    padding: 0px;
                }.sessionFormInstruction .slds-grid.slds-wrap.slds-gutters {
                    margin-bottom: 0px;
                }
                
            }`;
            this.template.querySelector('div').appendChild(style);
        }
    }
}