import { LightningElement, api, track } from 'lwc';

export default class MultiPickListGenericComponent extends LightningElement {

    @api receivedPickListValues; //Picklist values sent by parent component
    @api selectedValues; //Values that has been selected
    @api fieldApiName; //API Name which makes component to be generic
    @track pickListValues = [];
    @track fieldName;

    selectedPickListValues = [];

    initSelectedPickListValues = false;    //Added by Sunny

    connectedCallback() {
        //var i;                 //Changes by Sunny 
        let pickListValues = [];
        if (this.receivedPickListValues !== undefined) {
            this.receivedPickListValues.forEach(eachPicklistValue => {
                if(eachPicklistValue.hasOwnProperty('value')){
                    pickListValues.push(eachPicklistValue.value);
                    this.pickListValues = [...pickListValues];
                }
            });
        }

        //console.log('Multi: From connectedCallback()');
    }

    renderedCallback() {

        if(!this.initSelectedPickListValues)
        {   
            this.selectedPickListValues = [];
            //=======================================================//
            var i;
            if (this.receivedPickListValues !== null && this.receivedPickListValues !== undefined) {
                for (i = 0; i < this.receivedPickListValues.length; i++) {
                    if(this.selectedValues !== undefined && this.selectedValues.includes(this.receivedPickListValues[i].value)) {
                        if (this.template.querySelectorAll('.highlightRow')[i].style !== undefined) {
                            this.template.querySelectorAll('.highlightRow')[i].style = 'background-color: rgba(9, 106, 189, 0.85); color : white;cursor: pointer;';
                            this.selectedPickListValues.push(this.receivedPickListValues[i].value);
                        }
                    } else {
                        if (this.template.querySelectorAll('.highlightRow')[i].style !== undefined) {
                            this.template.querySelectorAll('.highlightRow')[i].style = 'background-color: white; cursor: pointer;';
                            this.template.querySelectorAll('.addOrRemoveCheck')[i].style = 'opacity :0;';
                        }
                    }
                }
            }
            //=======================================================//
            this.initSelectedPickListValues = true;
        }

        //console.log('Multi: From renderedCallback()');
    }

    @api
    preSelectedValuesDisplay(rxSelectedValues){
        this.selectedValues = rxSelectedValues;
        this.selectedPickListValues = [];

        var i;
        if (this.receivedPickListValues !== null && this.receivedPickListValues !== undefined) {
            for (i = 0; i < this.receivedPickListValues.length; i++) {
                if(this.selectedValues !== undefined && this.selectedValues.includes(this.receivedPickListValues[i].value)) {
                    if (this.template.querySelectorAll('.highlightRow')[i].style !== undefined) {
                        this.template.querySelectorAll('.highlightRow')[i].style = 'background-color: rgba(9, 106, 189, 0.85); color : white;cursor: pointer;';
                        this.selectedPickListValues.push(this.receivedPickListValues[i].value);
                    }
                } else {
                    if (this.template.querySelectorAll('.highlightRow')[i].style !== undefined) {
                        this.template.querySelectorAll('.highlightRow')[i].style = 'background-color: white; cursor: pointer;';
                        this.template.querySelectorAll('.addOrRemoveCheck')[i].style = 'opacity :0;';
                    }
                }
            }
        }    
    }

    handleSelection(event) {
        var item = event.currentTarget;
        var valueChoosen;
        //var options;               //Changes by Sunny
        var options = [];
        var i, j, k;
        let pickListValues = [];
        //let selectedPickListValues1 = [];      //Changes by Sunny 
        let found = false;
        if (item && item.dataset) {
            valueChoosen = item.dataset.value;
            //pickListValues = this.selectedPickListValues;   //Changes by Sunny
            pickListValues.push.apply(pickListValues,this.selectedPickListValues);
            //options = pickListValues;                     //Changes by Sunny
            options.push.apply(options,pickListValues);

            for (i = 0; i < options.length; i++) {
                if (options[i] === valueChoosen) {
                    found = true;
                    for (k = 0; k < this.receivedPickListValues.length; k++) {
                        if (this.receivedPickListValues[k].hasOwnProperty('value')) {
                            if (this.receivedPickListValues[k].value.indexOf(valueChoosen) > -1) {
                                this.template.querySelectorAll('.highlightRow')[k].style = 'background-color: white; cursor: pointer;';
                                this.template.querySelectorAll('.addOrRemoveCheck')[k].style = 'opacity :0;';
                            }
                        }
                    }
                    delete pickListValues[i];
                }
            }

            if (!found) {
                pickListValues.push(valueChoosen);
                for (i = 0; i < this.receivedPickListValues.length; i++) {
                    if (this.receivedPickListValues[i].hasOwnProperty('value')) {
                        if (this.receivedPickListValues[i].value.indexOf(valueChoosen) > -1) {
                            this.template.querySelectorAll('.highlightRow')[i].style = 'background-color: rgba(9, 106, 189, 0.85); color : white; cursor: pointer;';
                            this.template.querySelectorAll('.addOrRemoveCheck')[i].style = 'opacity :1;';
                        }
                    }
                }
            }
        }
        //this.selectedPickListValues = pickListValues;   //Changes by Sunny
        this.selectedPickListValues = [];
        for(let x=0; x < pickListValues.length; x++)
        {
            if(pickListValues[x] === undefined)continue;
            this.selectedPickListValues.push(pickListValues[x]);
        }
        
        const picklistEvent = new CustomEvent("multipicklistgenericevent", {
            detail: {fieldName: this.fieldApiName, value : this.selectedPickListValues}
        });

        this.dispatchEvent(picklistEvent);

        //console.log('From handleSelection()');
    }

}