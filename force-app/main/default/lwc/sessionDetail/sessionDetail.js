import { LightningElement,track,wire  } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { CurrentPageReference } from 'lightning/navigation';
import getPendingSessionData from '@salesforce/apex/SessionDetailController.getPendingSessionData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getdynamicpicklistval from '@salesforce/apex/SessionDetailController.getdynamicpicklistval';
import getBatch from '@salesforce/apex/SessionDetailController.getBatch';
import sessionSignOut from '@salesforce/apex/SessionDetailController.sessionSignOut';
import getSchoolList from '@salesforce/apex/SessionDetailController.getSchoolList';
import lstsessionRecords from '@salesforce/apex/SessionDetailController.lstsessionRecords';
import {NavigationMixin} from "lightning/navigation";
let options = [
    { "label": "No School Found", "value": "" }
];

export default class SessionDetail extends NavigationMixin(LightningElement) {
    @track activeChildSession = [];
    @track hasParentSessions = false;
    @track hasParentSessions = false;
    @track hasStudentSessions = false;
    @track hasFlexibleSessions = false;
    @track hasCounselingSessions = false;
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
    CounsellingSessionStatusValue='';
    CounsellingSessionStatusClass='';
    ParentSessionStatusValue= '';
    ParentSessionStatusClass='';
    @track parentSessions = [];
    @track studentSessions = [];
    @track counselingSessions = [];
    @track flexibleSessions = [];

    handleSectionToggleChild(event){
        console.log('handleSectionToggleChild')
        const openSections = event.detail.openSections;
        console.log('openSections = ',openSections[0])
        //this.activeChildSession = openSections;

        // Update isOpen property for each session dynamically
        /*this.flexibleSessions = this.flexibleSessions.map(session => {
            return {
                ...session,
                isOpen: Array.isArray(openSections)
                    ? openSections.includes(session.id)
                    : openSections === session.id
            };
        });
        this.studentSessions = this.studentSessions.map(session => {
            return {
                ...session,
                isOpen: Array.isArray(openSections)
                    ? openSections.includes(session.id)
                    : openSections === session.id
            };
        });
        this.parentSessions = this.parentSessions.map(session => {
            return {
                ...session,
                isOpen: Array.isArray(openSections)
                    ? openSections.includes(session.id)
                    : openSections === session.id
            };
        });
        this.counselingSessions = this.counselingSessions.map(session => {
            return {
                ...session,
                isOpen: Array.isArray(openSections)
                    ? openSections.includes(session.id)
                    : openSections === session.id
            };
        });*/
    }
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
        this.getSessionListFunc();
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
            this.activeChildSession = [];
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
    onchangeGrade(event){
        this.batch = '';
        this.grade = event.detail.value;
        this.getBatchFunc();
    }
    getBatchFunc(){
        getBatch({
            grade : this.grade,
            schoolId : this.schoolId,
            trainerId : this.facEmailId
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
        this.parentSessions = [];
        this.studentSessions = [];
        this.flexibleSessions = [];
        this.counselingSessions = [];
        this.getSessionListFunc();
    }
    getSessionListFunc(){
        lstsessionRecords({
            batchId : this.batch,
            loggedInTrainer : this.facEmailId
        })
        .then(result => {
            debugger
            const response = [...result]
            console.log(JSON.stringify(response));
            if(response){
                response.forEach(session => {
                    session.startTimeFormatted = this.formatTimeToInput(session.startTime); 
                    session.disableStartTimeNDate = session.isAttendenceFound || session.isNotLoggedInTrainerSession;
                    session.isOpen = true;
                    if (session.isParentSession) {
                        this.parentSessions.push(session);
                    }
                    if (session.isStudentSession) {
                        this.studentSessions.push(session);
                    }
                    if (session.isCounselingSession) {
                        this.counselingSessions.push(session);
                    }
                    if (session.isFlexibleSession) {
                        this.flexibleSessions.push(session);
                    }
                });
                this.hasParentSessions = this.parentSessions && this.parentSessions.length > 0;
                this.hasStudentSessions = this.studentSessions && this.studentSessions.length > 0;
                this.hasFlexibleSessions = this.flexibleSessions && this.flexibleSessions.length > 0;
                this.hasCounselingSessions = this.counselingSessions && this.counselingSessions.length > 0;
                if (window.innerWidth < 768) {
                    this.activeChildSession = [];
                }else{
                    this.activeChildSession = [
                        ...this.parentSessions.map(session => session.id),
                        ...this.studentSessions.map(session => session.id),
                        ...this.counselingSessions.map(session => session.id),
                        ...this.flexibleSessions.map(session => session.id)
                    ];
                }
                /*console.log('this.activeChildSession = ',this.activeChildSession);
                this.flexibleSessions = this.flexibleSessions.map(session => {
                    return {
                        ...session,
                        isOpen: Array.isArray(this.activeChildSession)
                            ? this.activeChildSession.includes(session.id)
                            : this.activeChildSession === session.id
                    };
                });
                this.parentSessions = this.parentSessions.map(session => {
                    return {
                        ...session,
                        isOpen: Array.isArray(this.activeChildSession)
                            ? this.activeChildSession.includes(session.id)
                            : this.activeChildSession === session.id
                    };
                });
                this.studentSessions = this.studentSessions.map(session => {
                    return {
                        ...session,
                        isOpen: Array.isArray(this.activeChildSession)
                            ? this.activeChildSession.includes(session.id)
                            : this.activeChildSession === session.id
                    };
                });
                this.counselingSessions = this.counselingSessions.map(session => {
                    return {
                        ...session,
                        isOpen: Array.isArray(this.activeChildSession)
                            ? this.activeChildSession.includes(session.id)
                            : this.activeChildSession === session.id
                    };
                });*/
                
                
            }
            this.CounsellingSessionStatusValue= this.counselingSessions[0].status;
            this.CounsellingSessionStatusClass=this.counselingSessions[0].statusClassName;

            this.ParentSessionStatusValue= this.parentSessions[0].status;
            this.ParentSessionStatusClass=this.parentSessions[0].statusClassName;

            console.log('Parent Sessions:', this.parentSessions);
            console.log('Student Sessions:', this.studentSessions);
            console.log('Counseling Sessions:', this.counselingSessions);
            console.log('Flexible Sessions:', this.flexibleSessions);
            console.log('activeChildSession:', this.activeChildSession);
            this.activeChildSession1 = [...this.activeChildSession];
            
        }).catch(error => {
            console.log(error);
             this.showToastMessage(error.body.message,'error');
        });
    }
    @track activeChildSession1 = [];
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
            }.facNameInAccordion input{
                background-color: #F09F4D !important;
            }
            .sessionAccordion input{
                color: #49445C !important;
                border: 1px solid #49445C !important;
            }
            .sessionAccordion label.slds-form-element__label.slds-no-flex, .sessionAccordion label.slds-form-element__label {
                color: #49445C !important;
                margin-bottom: 20px;
            }.CompleteCls .slds-input, .CompleteCls button.slds-button.slds-button_brand{
                background-color:#92DB72 !important;
            }.ReadyforAttendanceCls .slds-input, .ReadyforAttendanceCls button.slds-button.slds-button_brand{
                background-color:#9ABBFF !important;
            }.ScheduledCls .slds-input, .ScheduledCls button.slds-button.slds-button_brand{
                background-color:#EEDA5E !important;
            }.UnscheduledCls .slds-input, .IncompleteCls .slds-input, .IncompleteCls button.slds-button.slds-button_brand, .UnscheduledCls button.slds-button.slds-button_brand{
                background-color:#E88775 !important;
            }button.slds-button.slds-button_brand {
                width: 12%;
                color: #000;
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
    isSessionOpen(sessionId) {
        if (Array.isArray(this.activeChildSession)) {
            return this.activeChildSession.includes(sessionId);
        } else {
            return this.activeChildSession === sessionId;
        }
    }
    formatTimeToInput(s) {
        if (!s) return '';
        let time = new Date(s);
        let hours = time.getUTCHours();
        let minutes = time.getUTCMinutes();
        let ampm = hours >= 12 ? 'PM' : 'AM';

        // Adjust hours for 12-hour format
        hours = hours % 12;
        hours = hours ? hours : 12; // the hour '0' should be '12'

        // Format minutes
        minutes = minutes < 10 ? '0' + minutes : minutes; // pad single digits

        return `${hours}:${minutes} ${ampm}`;
    }
    
    handleSelectOption (event) {
      console.log('event.detail ='+event.detail);
      this.schoolId = event.detail;
      this.grade='';
      this.batch='';
    }

    value = '';

    get options() {
        return [
            { label: 'Yes', value: 'Yes' },
            { label: 'No', value: 'No' },
        ];
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