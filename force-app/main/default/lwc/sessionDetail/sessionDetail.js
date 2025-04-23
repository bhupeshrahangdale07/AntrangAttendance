import { LightningElement,track,wire  } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { CurrentPageReference } from 'lightning/navigation';
import getPendingSessionData from '@salesforce/apex/SessionDetailController.getPendingSessionData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getdynamicpicklistval from '@salesforce/apex/SessionDetailController.getdynamicpicklistval';
import getBatch from '@salesforce/apex/SessionDetailController.getBatch';
import sessionSignOut from '@salesforce/apex/SessionDetailController.sessionSignOut';
import getSchoolList from '@salesforce/apex/SessionDetailController.getSchoolList';
import {NavigationMixin} from "lightning/navigation";
let options = [
    { "label": "No School Found", "value": "" }
];

export default class SessionDetail extends NavigationMixin(LightningElement) {
    @track options = options;
    flagIndicatingDataHasBeenLoadedInVariables = false;
    grade;
    @track schoolId = '';
    @track isShowModal=true;
    facEmailId;
    showLoading = false;
    showLoadingModal = true;
    @track sessionList = [];
    showPendingSession;

    batchOption=[];
    gradeOption=[];
    grade;
    batch;
    code;
    activeSectionsMessage = '';
    activeSections = ['flexibleSession', 'studentSession','parentSession','individualCounsellingSession'];
    showParentSessionStatus=false;
    showCounsellingSessionStatus=false;

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;
        this.showParentSessionStatus = !openSections.includes('parentSession');
        this.showCounsellingSessionStatus = !openSections.includes('individualCounsellingSession');
        console.log('openSections = ',openSections);
        if (openSections.length === 0) {
            this.activeSectionsMessage = 'All sections are closed';
        } else {
            this.activeSectionsMessage =
                'Open sections: ' + openSections.join(', ');
        }
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference){
        if (currentPageReference){
            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            this.code = rxCurrentPageReference.state.code ? decodeURI(rxCurrentPageReference.state.code) : null;
            this.facEmailId = rxCurrentPageReference.state.facilitorId ? decodeURI(rxCurrentPageReference.state.facilitorId) : null;
            
        }
    }
    backToLogin(){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'SessionLogin__c'
            }
        });
    }
    handleSignOut(event){
        this.showLoading = true;
        this.sessionSignOutFunc();
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
    onClickPendingSession(event){
        
        //this.showLoading = true;
        event.preventDefault(); // prevent navigation
        const hrefValue = event.currentTarget.getAttribute('href');
        const decodedHref = hrefValue.replace(/&amp;/g, '&');
        const params = new URLSearchParams(decodedHref);
        this.schoolId = params.get('sId');
        console.log(' this.schoolId = ', this.schoolId);
        this.getSchoolListFunc();
        this.batch = params.get('bId');
        this.grade = params.get('grade');
        this.getBatchFunc();
        this.hideModalBox();
       
    }
    getSchoolListFunc(){
        getSchoolList({ }).
            then((data) => {
                if (data) {
                    var optionsLabel = data.map(acc => ({
                        label: acc.Name,
                        value: acc.Id
                    }));
                    console.log('optionsLabel = ',optionsLabel);
                    this.options = [...optionsLabel];
                    this.flagIndicatingDataHasBeenLoadedInVariables = true;
                    console.log('this.options = ',this.options);
                } else if (error) {
                    console.error('Error fetching accounts', error);
                }
            }).
            catch((error) => {

                this.showToastPopMessage(
                    `Something went wrong. Error - ${error}`,
                    "error"
                );

            });
    }
    handleSchoolChange(event) {
       this.schoolId = event.detail.recordId;
       this.grade = '';
       this.batch='';
       console.log('schoolId  ='+this.schoolId);
   }
    showModalBox() {  
        this.isShowModal = true;
    }
    showToastMessage(message,variant){
        const event = new ShowToastEvent({
                title : 'Session Detail',
                message : message,
                variant : variant
            });
            this.dispatchEvent(event);
    }
    hideModalBox() {  
        this.isShowModal = false;
        this.getSchoolListFunc();
    }
    connectedCallback() {
        this.showLoading = true;
        if (window.innerWidth < 768) {
            this.activeSections = [];
            this.showParentSessionStatus=true;
            this.showCounsellingSessionStatus=true;
        } else {
            this.activeSections = ['flexibleSession', 'studentSession','parentSession','individualCounsellingSession'];
            this.showParentSessionStatus=false;
            this.showCounsellingSessionStatus=false;
        }
        window.addEventListener("beforeunload", this.handleTabClose);
        if(this.code == window.name){
            if(!this.code || !this.facEmailId){
                console.log('a');
                this.showToastMessage('Error While Login','error');
                this.backToLogin();
            }else{
                this.showLoading = false;
                this.getPendingSessionFunc();
                this.getdynamicpicklistvalFunc();
            }
            
        }else{
            console.log('b');
            this.showToastMessage('Not allowing to work on multiple tab','error');
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
    onchangeGrade(event){
        this.grade = event.detail.value;
        this.getBatchFunc();
    }
    getBatchFunc(){
        getBatch({
            grade : this.grade,
            schoolId : this.schoolId
        })
        .then(result => {
            console.log('getBatch = ',JSON.stringify(result));
            if(result){
                this.batchOption = result;
            }
            
        }).catch(error => {
            this.showToastMessage(error.body.message,'error');
            console.log(error.body.message);
        });
    }
    onchangeBatch(event){
        this.batch = event.detail.value;
    }
    getdynamicpicklistvalFunc(){
        getdynamicpicklistval({
            objectName : 'Batch__c',
            fieldName : 'Grade__c'
        })
        .then(result => {
            console.log(JSON.stringify(result));
            if(result){
                this.gradeOption = result;
            }
            
        }).catch(error => {
            this.showToastMessage(error.body.message,'error');
            console.log(error.body.message);
        });
    }
    getPendingSessionFunc(){
        getPendingSessionData({
            stremail : this.facEmailId
        })
        .then(result => {
            console.log('result = '+result);
            this.showLoadingModal =  false;
            if(result){
                this.sessionList = Object.keys(result).map((key, index) => {
                    // Process batches into key-value pairs
                    let batches = Object.entries(result[key]).map(([batchKey, batchValue]) => {
                        return {
                            batchName: batchKey, // e.g., "Grade 9 - 27487"
                            batchDetails: batchValue // e.g., "sId=001C400000JISJEIA5&bId=a0oC4000000Uvk1IAC&grade=Grade 9"
                        };
                    });

                    return {
                        school: key,
                        batches: batches,
                        displayIndex: index + 1
                    };
                });
                console.log('this.sessionList ='+JSON.stringify(this.sessionList));
                console.log('a');
                this.showPendingSession = this.sessionList.length > 0;
                 console.log('b');
            }
            
        }).catch(error => {
            this.showLoadingModal =  false;
            this.showToastMessage(error.body.message,'error');
            console.log(error.body.message);
        });
    }
    renderedCallback() {
        if (typeof window !== 'undefined') {
            const style = document.createElement('style');
            style.innerText =  `.sessionAccordion h2.slds-accordion__summary-heading {
                color: #49445C;
                font-weight: bold;
                font-size: 18px;
            }
            .sessionAccordion svg.slds-button__icon.slds-button__icon_left.slds-icon.slds-icon-text-default.slds-icon_x-small{
                fill: #49445C;
                margin-right: 15px;
            }
            .sessionAccordion .slds-accordion__summary-heading .slds-button:focus {
                box-shadow: none;
            }.sessionAccordion lightning-accordion-section.slds-accordion__list-item {
                border: none;
            }.completeButton button.slds-button.slds-button_brand, .incompleteButton button.slds-button.slds-button_brand {
                width: 8%;
            }.saveButton button.slds-button.slds-button_brand {
                width: 7%;
                height: 38px;
            }
            @media (max-width: 767px) {
                lightning-button.completeButton button.slds-button.slds-button_brand, lightning-button.incompleteButton button.slds-button.slds-button_brand {
                    width: 30% !important;
                }
                lightning-button.saveButton button.slds-button.slds-button_brand {
                    width: 18%;
                    height: 35px;
                }
            }`;
            this.template.querySelector('div').appendChild(style);
        }
    }
    
    handleSelectOption (event) {
      console.log('event.detail ='+event.detail);
      this.schoolId = event.detail;
      this.grade='';
      this.batch='';
    }
    /*@wire(getSchoolList)
    wiredAccounts({ error, data }) {
        console.log('data = ',data);
        if (data) {
            var optionsLabel = data.map(acc => ({
                label: acc.Name,
                value: acc.Id
            }));
            console.log('optionsLabel = ',optionsLabel);
            this.options = [...optionsLabel];
            this.flagIndicatingDataHasBeenLoadedInVariables = true;
            console.log('this.options = ',this.options);
        } else if (error) {
            console.error('Error fetching accounts', error);
        }
    }*/

    
}