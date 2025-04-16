import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import CONTACT_OBJECT from '@salesforce/schema/Contact';
import G9_WHATSAPP_NUMBER_FIELD from '@salesforce/schema/Contact.G9_Whatsapp_Number__c';
import G10_WHATSAPP_NUMBER_FIELD from '@salesforce/schema/Contact.G10_Whatsapp_Number__c';
import G11_WHATSAPP_NUMBER_FIELD from '@salesforce/schema/Contact.G11_Whatsapp_Number__c';
import G12_WHATSAPP_NUMBER_FIELD from '@salesforce/schema/Contact.G12_Whatsapp_Number__c';
import WHAT_ARE_YOU_CURRENTLY_STUDYING_FIELD from '@salesforce/schema/Contact.What_are_you_currently_studying__c'; 

import { getObjectInfo } from 'lightning/uiObjectInfoApi';

import LightningConfirm from 'lightning/confirm';

import getUnLinkedStudents from '@salesforce/apex/StudentLinkController.getUnLinkedStudents';
import saveLinkStudents from '@salesforce/apex/StudentLinkController.saveLinkStudents';
import updateLinkedStudents from '@salesforce/apex/StudentLinkController.updateLinkedStudents';

export default class StudentLinkForm extends NavigationMixin(LightningElement) {
    subTitle;
    pageSubHeader;
    colSubHeading;
    lng;
    typ;
    isEnglish;
    subTitle;
    grade = null;
    batchCode = null;
    batchId = null;
    schoolName = null;
    schoolId = null;
    facilatorEmail = null;
    acid = null;
    // schoolId = null;

    showLoading = true;
    isShowModal = false;

    contactObjectDetail = CONTACT_OBJECT;
    g9_whatsapp = G9_WHATSAPP_NUMBER_FIELD;
    g10_whatsapp = G10_WHATSAPP_NUMBER_FIELD;
    g11_whatsapp = G11_WHATSAPP_NUMBER_FIELD;
    g12_whatsapp = G12_WHATSAPP_NUMBER_FIELD;
    What_are_you_currently_studying = WHAT_ARE_YOU_CURRENTLY_STUDYING_FIELD;


    g9_whatsapp_Label = 'G9 Whatsapp Number';
    g10_whatsapp_Label = 'G10 Whatsapp Number';
    g11_whatsapp_Label = 'G11 Whatsapp Number';
    g12_whatsapp_Label = 'G12 Whatsapp Number';
    What_are_you_currently_studying_Label = 'What are you currently studying ?';

    get whatCurrStuInOptions() {

        var CurrStuInOptions = [
            // { label: 'Select', value: '' },
            { label: 'Class 11/12: Arts', value: 'Class 11/12: Arts' },
            { label: 'Class 11/12: Science', value: 'Class 11/12: Science' },
            { label: 'Class 11/12: Commerce', value: 'Class 11/12: Commerce' },
            { label: 'Diploma', value: 'Diploma' },
            { label: 'Apprenticeship', value: 'Apprenticeship' },
            { label: 'Vocational Certificate Course', value: 'Vocational Certificate Course' },
            { label: 'Other', value: 'Other' }
            // ,
            // { label: 'Multiple answers selected', value: '*' },
            // { label: 'No Answer', value: 'No' }
        ];

        if (!this.isEnglish) {
            CurrStuInOptions = [
                // { label: 'Select', value: '' },
                { label: 'कक्षा ११/१२: कला', value: 'Class 11/12: Arts' },
                { label: 'कक्षा ११/१२: विज्ञान', value: 'Class 11/12: Science' },
                { label: 'कक्षा ११/१२: वाणिज्य', value: 'Class 11/12: Commerce' },
                { label: 'डिप्लोमा', value: 'Diploma' },
                { label: 'अप्रेन्टस्शिप ', value: 'Apprenticeship' },
                { label: 'वोकेशनल सर्टिफिकेट कोर्स', value: 'Vocational Certificate Course' },
                { label: 'अन्य', value: 'Other' }
                // ,
                // { label: 'Multiple answers selected', value: '*' },
                // { label: 'No Answer', value: 'No' }
            ];
        }
        return CurrStuInOptions;
    }

    contacts_count;
    contacts;
    @track data;

    @track savedContacts;
    @track savedRawContacts;

    @track searchKey = '';
    @track selectedRows = [];

    @track showSelectedDocumentsScreen = false;
    @track showDefaultScreen = true;
    @track showSavedDocumentsScreen = false;

    @track displaySelectedRecords = []

    @track colummnLabel = 'Whatsapp Number';
    @track columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: this.colummnLabel, fieldName: this.whatsappField?.fieldApiName }
    ];

    get whatsappField() {
        let field;
        if (this.grade == 'Grade 10') {
            field = this.g9_whatsapp;
        } else if (this.grade == 'Grade 11') {
            field = this.g10_whatsapp;
        } else if (this.grade == 'Grade 12') {
            field = this.g11_whatsapp;
        }
        return field;
    }

    get isGrade10() {
        return this.grade == 'Grade 10' ? true : false;
    }

    get isGrade11() {
        return this.grade == 'Grade 11' ? true : false;
    }

    get isGrade12() {
        return this.grade == 'Grade 12' ? true : false;
    }

    @track formTitle = 'Student Linking';
    @track tagLine = 'Unlinked Students Count: ';

    @track schoolNameLabel = 'School Name';
    @track gradeLabel = 'Grade';
    @track batchCodeLabel = 'Batch Code';

    doTransilation() {
        if (!this.isEnglish) {
            this.formTitle = 'Student Linking';
            this.tagLine = 'Unlinked Students Count: ';

            this.schoolNameLabel = 'स्कूल के नाम';
            this.gradeLabel = 'श्रेणी';
            this.batchCodeLabel = 'बैच कोड';
        }
    }

    @wire(CurrentPageReference)
    getCurrentPageRefxerence(currentPageReference) {
        if (currentPageReference) {
            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            this.grade = decodeURI(rxCurrentPageReference.state.grd);
            this.batchId = decodeURI(rxCurrentPageReference.state.bid);
            this.cuurrValue = decodeURI(this.grade);
            this.schoolId = decodeURI(rxCurrentPageReference.state.sch);
            this.facilatorEmail = decodeURI(rxCurrentPageReference.state.fem);
            this.acid = decodeURI(rxCurrentPageReference.state.acid);
            this.batchNumber = decodeURI(rxCurrentPageReference.state.batch);


            if (rxCurrentPageReference.state.typ !== undefined) this.typ = decodeURI(rxCurrentPageReference.state.typ);
            if (rxCurrentPageReference.state.lng !== undefined) this.lng = decodeURI(rxCurrentPageReference.state.lng);
            this.isEnglish = (!this.lng || this.lng == 'null' || this.lng == 'English') ? true : false;


        }

    }

    @wire(getObjectInfo, { objectApiName: CONTACT_OBJECT })
    wiredObjectInfo({ error, data }) {
        if (data) {
            // this.objectInfo = data;
            this.colummnLabel = data?.fields[this.whatsappField?.fieldApiName]?.label ? data?.fields[this.whatsappField?.fieldApiName]?.label : '';
            this.columns = [
                { label: 'Name', fieldName: 'Name' },
                { label: this.colummnLabel, fieldName: this.whatsappField?.fieldApiName }
            ];

            this.g9_whatsapp_Label = data?.fields[this.g9_whatsapp.fieldApiName]?.label ? data?.fields[this.g9_whatsapp.fieldApiName]?.label : '';
            this.g10_whatsapp_Label = data?.fields[this.g10_whatsapp.fieldApiName]?.label ? data?.fields[this.g10_whatsapp.fieldApiName]?.label : '';
            this.g11_whatsapp_Label = data?.fields[this.g11_whatsapp.fieldApiName]?.label ? data?.fields[this.g11_whatsapp.fieldApiName]?.label : '';
            this.g12_whatsapp_Label = data?.fields[this.g12_whatsapp.fieldApiName]?.label ? data?.fields[this.g12_whatsapp.fieldApiName]?.label : '';
            this.What_are_you_currently_studying_Label = data?.fields[this.What_are_you_currently_studying.fieldApiName]?.label ? data?.fields[this.What_are_you_currently_studying.fieldApiName]?.label : '';


        } else if (error) {
            // Handle error
        }
    }

    connectedCallback() {
        this.subTitle = 'Below is a list of students who are present in this school. Please select all the students who are in your current class, and have marked a "tick" on their student detail sheet.';
        this.pageSubHeader = 'Please fill the below fields for linked students using their Student Detail sheet.';
        this.colSubHeading = '*cell will turn yellow if number is edited';
        this.fetchunlinkedStudents();
        this.doTransilation();
    }

    fetchunlinkedStudents() {
        getUnLinkedStudents({
            batchId: this.batchId,
            grade: this.grade

        }).then(result => {

            this.batchCode = result?.batch?.Name;
            this.batchNumber = result?.batch?.Batch_Number__c;
            this.schoolName = result?.batch?.School_Name__r?.Name;

            var cnts = JSON.parse(JSON.stringify(result?.contacts));

            cnts.forEach(currentItem => {
                currentItem['isChecked'] = false;
            });

            this.contacts = cnts && cnts.length > 0 ? cnts : undefined;
            this.contacts_count = result?.contacts_count;

            this.showLoading = false;

            this.data = this.contacts && this.contacts.length > 0 ? this.contacts : undefined;
        }).catch(error => {
            // console.log('error 123 = ', JSON.stringify(error));
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: error?.body?.message,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);

            this.showLoading = false;
        });
    }

    handleSearchKeyChange(event) {
        this.assignSelectedIds();
        this.searchKey = event.target.value.toLowerCase()?.trim();
        var dt = this.filteredContacts();
        this.data = dt && dt.length > 0 ? dt : undefined;
    }

    filteredContacts() {
        return this.contacts.filter(contact =>
            contact?.Name?.toLowerCase().includes(this.searchKey) ||
            contact[this.whatsappField?.fieldApiName]?.toLowerCase().includes(this.searchKey)
        );
    }

    assignSelectedIds() {
        let selectedIds = [];
        let unselectedIds = [];
        // Get the currently selected rows
        let selectedRecords = this.template.querySelector("lightning-datatable")?.getSelectedRows();
        if (selectedRecords && selectedRecords.length > 0) {
            selectedIds = selectedRecords.map(record => record.Id);
        }

        let allIds = this.data?.map(record => record.Id);
        unselectedIds = allIds?.filter(id => !selectedIds.includes(id));

        // Update the selectedRows property
        // selectedIds = [...this.selectedRows];
        // this.selectedRows = Array.from(new Set(selectedIds));
        let allSelectedIds = Array.from(new Set([...this.selectedRows, ...selectedIds]));
        let finalIds = allSelectedIds?.filter(id => !unselectedIds?.includes(id));
        this.selectedRows = finalIds;
    }

    handleLink(event) {
        this.showLoading = true;
        this.assignSelectedIds();
        console.log(this.selectedRows);
        console.log(this.selectedRows.length);

        if (this.selectedRows && this.selectedRows.length > 0) {
            this.showSelectedDocumentsScreen = true;
            this.showDefaultScreen = false;
            
            let selectedRecords = this.contacts.filter(contact => this.selectedRows.includes(contact.Id));

            this.displaySelectedRecords = selectedRecords.sort((a, b) => {
                return a.Name.localeCompare(b.Name);
            });

            this.showLoading = false;
        } else {
            const toastEvent = new ShowToastEvent({
                title: 'Warning',
                message: 'Please select at least one student to link.',
                variant: 'warning'
            });
            this.dispatchEvent(toastEvent);
            this.showLoading = false;
        }

    }

    handleSubmitLink(event) {
        this.showLoading = true;
        saveLinkStudents({
            batchId: this.batchId,
            grade: this.grade,
            selectedContactIds: this.selectedRows

        }).then(result => {

            const toastEvent = new ShowToastEvent({
                title: 'Success',
                message: 'Student(s) Linked Successfully',
                variant: 'success'
            });
            this.dispatchEvent(toastEvent);

            let dt = JSON.parse(JSON.stringify(result));

            // dt.forEach(currentItem => {
            //     currentItem[this.What_are_you_currently_studying.fieldApiName] = currentItem[this.What_are_you_currently_studying.fieldApiName] ? currentItem[this.What_are_you_currently_studying.fieldApiName] :'';
            //     if (this.grade == 'Grade 10') {
            //         currentItem[this.g10_whatsapp.fieldApiName] = currentItem[this.g9_whatsapp.fieldApiName];
            //     } else if (this.grade == 'Grade 11') {
            //         currentItem[this.g11_whatsapp.fieldApiName] = currentItem[this.g10_whatsapp.fieldApiName];
            //     } else if (this.grade == 'Grade 12') {
            //         currentItem[this.g12_whatsapp.fieldApiName] = currentItem[this.g11_whatsapp.fieldApiName];
            //     }
            // });

            this.savedContacts = dt;
            this.savedRawContacts = JSON.parse(JSON.stringify(result));

            this.showSelectedDocumentsScreen = false;
            this.showDefaultScreen = false;
            this.showSavedDocumentsScreen = true;

            this.showLoading = false;
        }).catch(error => {
            // console.log('error 123 = ', JSON.stringify(error));
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: error?.body?.message,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
            this.showLoading = false;
        });
    }

    handleUpdateField(event) {
        var index = event.currentTarget.dataset.rowindex;
        var fieldApi = event.currentTarget.dataset.fieldapi;

        // if(this.savedContacts[index][fieldApi] != event.detail?.value?.trim() ){
        //     event.currentTarget.classList.add('updatedfield');
        // }

        event.target.value = event.detail?.value?.trim();
        this.savedContacts[index][fieldApi] = event.detail?.value?.trim();

        if((!this.savedRawContacts[index][fieldApi] && this.savedContacts[index][fieldApi] != '') || (this.savedRawContacts[index][fieldApi] && this.savedRawContacts[index][fieldApi] != this.savedContacts[index][fieldApi] ) ){
            if (!event.currentTarget.classList.contains("updatedfield")) {
                event.currentTarget.classList.add("updatedfield");
            }
        }else{
            if (event.currentTarget.classList.contains("updatedfield")) {
                event.currentTarget.classList.remove("updatedfield");
            }
        }

        // if(( this.savedRawContacts[index][fieldApi] == undefined && this.savedContacts[index][fieldApi] == '' )){
        //     if (event.currentTarget.classList.contains("updatedfield")) {
        //         event.currentTarget.classList.remove("updatedfield");
        //     }
        // }
    }

    async handleConfirmClick(event) {
        const result = await LightningConfirm.open({
            message: 'Are you sure you want to submit this form?',
            label: 'Confirm Form Submission'            
        });
        
        //Confirm has been closed
        //result is true if OK was clicked
        //and false if cancel was clicked

        if(result){
            // this.handleSubmitUpdate(event);
            this.handleUpdateLinkedStudents();
        }
    }

    handleSubmitUpdate(event) {
        const allValid = [
            ...this.template.querySelectorAll('lightning-input'), ...this.template.querySelectorAll('lightning-combobox')
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        if (allValid) {
            //alert('All form entries look valid. Ready to submit!');

            this.handleConfirmClick(event);
            // this.handleUpdateLinkedStudents();
        } else {
            // alert('Please update the invalid form entries and try again.');
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: 'Please update the invalid form entries and try again.',
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
        }
    }


    handleUpdateLinkedStudents(event) {
        this.showLoading = true;
        updateLinkedStudents({
            contacts: this.savedContacts
        }).then(result => {
            this.resetVariables();
            this.fetchunlinkedStudents();

            const toastEvent = new ShowToastEvent({
                title: 'Success',
                message: 'Student(s) updated Succesfully',
                variant: 'success'
            });
            this.dispatchEvent(toastEvent);

        }).catch(error => {
            // console.log('error 123 = ', JSON.stringify(error));
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                message: error?.body?.message,
                variant: 'error'
            });
            this.dispatchEvent(toastEvent);
            this.showLoading = false;
        });
    }

    resetVariables(event) {
        // this.savedContacts = [];

        this.showSelectedDocumentsScreen = false;
        this.showDefaultScreen = true;
        this.showSavedDocumentsScreen = false;

        this.contacts_count = undefined;
        this.contacts = undefined;
        this.data = undefined;

        this.savedContacts = undefined;
        this.savedRawContacts = undefined;

        this.searchKey = '';
        this.selectedRows = [];
        this.displaySelectedRecords = []
    }



    constructor() {
        super();
        window.addEventListener('beforeunload', (event) => {
            // Cancel the event as stated by the standard.

            if (this.showSavedDocumentsScreen) {
                event.preventDefault();
                // Chrome requires returnValue to be set.
                event.returnValue = 'sample value';
            }

        });

    }

    handleBackButton(event) {
        if (event.currentTarget.dataset.name == 'tempBackButton') {
            this.showSelectedDocumentsScreen = false;
            this.showDefaultScreen = true;
            this.searchKey = '';
            
            var dt = this.filteredContacts();
            this.data = dt && dt.length > 0 ? dt : undefined;

            return;
        } else {

            this[NavigationMixin.Navigate]({
                type: 'comm__namedPage',
                attributes: {
                    name: 'StudentDetailsV2__c'
                },
                state: {
                    bid: encodeURI(this.batchId),
                    grd: encodeURI(this.grade),
                    fem: encodeURI(this.facilatorEmail),
                    sch: encodeURI(this.schoolId),
                    acid: encodeURI(this.acid),
                    typ: encodeURI(this.typ),
                    lng: encodeURI(this.lng),
                    batch: encodeURI(this.batchNumber)
                }
            });
        }
    }
    renderedCallback() {
        const style = document.createElement('style');
        style.innerText = `.updatedfield input.slds-input {
            background-color: yellow;
        }
        
        .updatedfield button.slds-combobox__input.slds-input_faux {
            background-color: yellow;
        }
        
        .btnstyle button{
            padding: 4px 20px;
            font-size: 15px;
        }`;
        this.template.querySelector('div').appendChild(style);
    }

}