import { LightningElement,track,wire  } from 'lwc';
import OnTime_Icon from "@salesforce/resourceUrl/sessionIconOnTime";
import Reschedule_Icon from "@salesforce/resourceUrl/sessionIconReschedule";
import Lateschedule_Icon from "@salesforce/resourceUrl/sessionIconLateSchedule";
import { getRecord } from 'lightning/uiRecordApi';
import { CurrentPageReference } from 'lightning/navigation';
import getPendingSessionData from '@salesforce/apex/SessionDetailController.getPendingSessionData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getdynamicpicklistval from '@salesforce/apex/SessionDetailController.getdynamicpicklistval';
import getBatch from '@salesforce/apex/SessionDetailController.getBatch';
import sessionSignOut from '@salesforce/apex/SessionDetailController.sessionSignOut';
import getSchoolList from '@salesforce/apex/SessionDetailController.getSchoolList';
import lstsessionRecords from '@salesforce/apex/SessionDetailController.lstsessionRecords';
import sessionStudentData  from '@salesforce/apex/SessionDetailController.getSessionStudent';
import saveLateSchedule  from '@salesforce/apex/SessionDetailController.saveLateSchedule';
import FORM_FACTOR from "@salesforce/client/formFactor";

import {NavigationMixin} from "lightning/navigation";
let options = [
    { "label": "No School Found", "value": "" }
];

export default class SessionDetail extends NavigationMixin(LightningElement) {
    indSessionId;
    indSessionLead;
    showIndividualStudent = false;
    OnTimeScheduleIcon = OnTime_Icon;
    reScheduleIcon = Reschedule_Icon;
    lateScheduleIcon = Lateschedule_Icon;
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
    @track indStudentData;
    isShowModalForLateSchedule = false;
    @track lateScheduleReasonOption;
    @track lateScheduleSessions;
    @track allSessions;
    onclickCancel(event){
        this.isShowModalForLateSchedule = false;
    }
    onclickOk(event){
        this.showLoading = true;
        this.isShowModalForLateSchedule = false;
        this.saveLateScheduleFunc();
    }
    saveLateScheduleFunc(){
        console.log(' this.flexibleSessions = ', this.flexibleSessions);
        const sessionsToUpdate = this.flexibleSessions.map(sess => {
            return {
                Id: sess.id,
                Late_Schedule__c: sess.reasonForLateSchedule,
                Scheduling_Type__c: sess.scheduleLate ? 'Late Schedule' : (sess.scheduleOnTime ? 'On Time' : null)
            };
        });
        saveLateSchedule({sessionList : sessionsToUpdate})
        .then((result)=>{
            this.showLoading = false;
            console.log('saveLateSchedule Result = ',result);
           
        })
        .catch((Error)=>{
            console.log('Error ='+Error);
            console.log('Error= '+JSON.stringify(Error));
        })
    }
    handleLateScheduleChange(event){
        const sessionId = event.target.dataset.id; // Get the session ID
        const newReason = event.detail.value; // Get the new selected reason value

        // Update lateScheduleSessions by finding the session with the matching ID and updating its reason
        this.flexibleSessions = this.flexibleSessions.map(session => {
            if (session.id === sessionId) {
                // Return updated session with the new reason
                return { ...session, reasonForLateSchedule: newReason,scheduleLate: true };
            }else{
                return { ...session,scheduleOnTime: true };
            }
            return session; // Return other sessions unchanged
        });
        console.log('Updated flexibleSessions:', this.flexibleSessions);
    }
    handleSave(event){
        this.flexibleSessions.forEach(session => {
            if(session.editedDateTime === true){
                const sessionDate = session.sessionDate;
                const startTime = session.startTime;

                // Combine session date and time into a single Date object
                const sessionDateTime = new Date(`${sessionDate}T${startTime}`);

                // Get the current date and time
                const now = new Date();

                // Calculate the difference in milliseconds
                const diffInMs = sessionDateTime - now;

                // Convert milliseconds to hours
                const diffInHours = diffInMs / (1000 * 60 * 60);
                
                if (diffInHours < 24 && diffInHours > 0) {
                    // Show popup and keep reason
                    console.log("Less than 24 hrs");
                } else if (diffInHours >= 24) {
                    // Do not show popup and remove session reason
                    session.lateSchedule = true;
                    console.log("More than 24 hrs");
                } else {
                    console.log("Session is already in the past");
                }
            }
        });
        console.log('handleSave = ',this.flexibleSessions)
        this.lateScheduleSessions = this.flexibleSessions.filter(session => session.lateSchedule === true);
        if (this.lateScheduleSessions.length > 0) {
            this.getdynamicpicklistvalFunc('Session__c','Late_Schedule__c');
            this.isShowModalForLateSchedule =  true;
        }

    }
    changeDateTime(event) {
        const sessionId = event.target.dataset.sessionId;
        const selectedValue = event.detail.value;
        console.log('event.detail.label =',event.detail.label)
        console.log('selectedValue = ',selectedValue);
        if(event.target.label === 'Date'){
            this.flexibleSessions = this.flexibleSessions.map(flxSession => {
                if (flxSession.id === sessionId) {
                    return { ...flxSession, sessionDate: selectedValue, editedDateTime:true };
                }
                return flxSession;
            });
        }if(event.target.label === 'Start Time'){
            this.flexibleSessions = this.flexibleSessions.map(flxSession => {
                if (flxSession.id === sessionId) {
                    return { ...flxSession, startTime: selectedValue, editedDateTime:true  };
                }
                return flxSession;
            });
        }
        
        
    }
    /*changeTime(event) {
        const sessionId = event.target.dataset.sessionId;
        const selectedValue = event.detail.value;

        // Update the corresponding student's attendance in the array
        this.flexibleSessions = this.flexibleSessions.map(flxSession => {
            if (flxSession.id === studentId) {
                return { ...flxSession, startTime: selectedValue, startTimeFormatted:selectedValue };
            }
            return student;
        });
    }*/
    get attendanceOptions() {
        return this.attendancePicklist || [];
    }
    @track attendancePicklist;
    
    get allSectionNames() {
        return this.indStudentData.map(student => student.studentId);
    }
    sessionStudentDataFunc(){
        sessionStudentData({batchId : this.batch, facilitatorId : this.facEmailId, sessionID : this.indSessionId, 
            selectedGrade : this.grade})
        .then((result)=>{
            this.attendancePicklist = result.attendancepicklist;
            this.indStudentData = result.studentdata;
            console.log('this.indStudentData.length =',this.indStudentData.length);
            if(this.indStudentData.length > 0){
                this.showIndividualStudent = true;
            }else{
                this.showIndividualStudent =  false;
            }
            this.showLoading = false;
           
        })
        .catch((Error)=>{
            console.log('Error ='+Error);
            console.log('Error= '+JSON.stringify(Error));
        })
    }

    handleAttendanceClick(event){
        event.preventDefault();
        const sessionId = event.currentTarget.dataset.sessionId;
        let pageReference = {
                                 type: 'comm__namedPage',
                                attributes: {
                                    name: 'sesssionStudentAttendance__c'
                                 },
                                 state: {
                                    facilitorId : encodeURI(this.facEmailId),
                                    code : encodeURI(this.code),
                                    schoolId : encodeURI(this.schoolId),
                                    batch : encodeURI(this.batch),
                                    grade : encodeURI(this.grade),
                                    sessionId : encodeURI(sessionId)
                                 }
                             };
                             this[NavigationMixin.Navigate](pageReference);
        
    }
    handleParentAttendanceClick(event){
        event.preventDefault();
        const sessionId = event.currentTarget.dataset.sessionId;
        let pageReference = {
                                 type: 'comm__namedPage',
                                attributes: {
                                    name: 'SessionParentAttendance__c'
                                 },
                                 state: {
                                    facilitorId : encodeURI(this.facEmailId),
                                    code : encodeURI(this.code),
                                    schoolId : encodeURI(this.schoolId),
                                    batch : encodeURI(this.batch),
                                    grade : encodeURI(this.grade),
                                    sessionId : encodeURI(sessionId)
                                 }
                             };
                             this[NavigationMixin.Navigate](pageReference);
    }

    handleSectionToggleChild(event){

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
            this.schoolId = rxCurrentPageReference.state.schoolId ? decodeURI(rxCurrentPageReference.state.schoolId) : null;
            this.batch = rxCurrentPageReference.state.batch ? decodeURI(rxCurrentPageReference.state.batch) : null;
            this.grade = rxCurrentPageReference.state.grade ? decodeURI(rxCurrentPageReference.state.grade) : null;
            const back = rxCurrentPageReference.state.back ? decodeURI(rxCurrentPageReference.state.back) : null;
            if(this.schoolId != null && this.batch != null && this.grade != null){
                this.getBatchFunc();
                this.hideModalBox();
                this.getSessionListFunc();
            }
            console.log('back = ',back);
            if(back === true){
                console.log('back1 = ',back);
                this.hideModalBox();
            }
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
        getSchoolList({facilitorId : this.facEmailId}).
            then((data) => {
                console.log('data = '+data);
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
                this.getdynamicpicklistvalFunc('Batch__c','Grade__c');
             
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
                    // alert('Time- '+session.startTimeFormatted);
                    session.startTimeFormatted = this.formatTimeToInput(session.startTime); 
                    //session.disableStartTimeNDate = session.isAttendenceFound || session.isNotLoggedInTrainerSession;
                    if(session.facilitatorId === this.facEmailId){
                        //session.disableStartTimeNDate = session.isAttendenceFound || session.isNotLoggedInTrainerSession;
                        session.disableStartTimeNDate = false;
                        session.isEditable = false;
                        
                    }else{
                        session.disableStartTimeNDate = true;
                        session.isEditable = true;
                    }
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
               
                
            }
            this.CounsellingSessionStatusValue= this.counselingSessions[0].status;
            this.CounsellingSessionStatusClass=this.counselingSessions[0].statusClassName;

            this.ParentSessionStatusValue= this.parentSessions[0].status;
            this.ParentSessionStatusClass=this.parentSessions[0].statusClassName;
            
            this.indSessionId = this.counselingSessions[0].id;
            this.indSessionLead = this.counselingSessions[0].sessionLead;

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
    getdynamicpicklistvalFunc(objName, fldName){
        getdynamicpicklistval({
            objectName : objName,
            fieldName : fldName
        })
        .then(result => {
            console.log(JSON.stringify(result));
            if(result){
                if(fldName === 'Grade__c')
                    this.gradeOption = result;
                if(fldName === 'Late_Schedule__c'){
                    this.lateScheduleReasonOption = result;
                }
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
                this.sessionStudentDataFunc();
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
                color: #fff;
            }.facNameInAccordion input{
                background-color: #F09F4D !important; text-align: center !important;
            }
            .sessionAccordion input{
                color: #49445C !important;
                border: 1px solid #49445C !important;
            }
            .sessionAccordion label.slds-form-element__label.slds-no-flex, .sessionAccordion label.slds-form-element__label {
                color: #49445C !important;
                margin-bottom: 20px;
            }.CompleteCls .slds-input, .CompleteCls button.slds-button.slds-button_brand{
                background-color:#92DB72 !important; text-align: center !important;
            }.ReadyforAttendanceCls .slds-input, .ReadyforAttendanceCls button.slds-button.slds-button_brand{
                background-color:#9ABBFF !important; text-align: center !important; overflow-wrap: break-word !important;
            }.ScheduledCls .slds-input, .ScheduledCls button.slds-button.slds-button_brand{
                background-color:#EEDA5E !important; text-align: center !important;
            }.UnscheduledCls .slds-input, .IncompleteCls .slds-input, .IncompleteCls button.slds-button.slds-button_brand, .UnscheduledCls button.slds-button.slds-button_brand{
                background-color:#E88775 !important; text-align: center !important;
            }button.slds-button.slds-button_brand {
                width: 12%;
                color: #000;
            }.pendingSessionModal .slds-modal__container{
                max-width: 60rem;
                min-width: 60rem;
            }.lateSchedulePopup .btnCancel button.slds-button.slds-button_brand {
                background-color: #1A1A1A;
                color: #fff;
            }.lateSchedulePopup .btnOk button.slds-button.slds-button_brand {
                background-color: #50A771;
                color: #fff;
            }.lateSchedulePopup .btnGrp button.slds-button.slds-button_brand {
                width: 20%;
            }
            @media (max-width: 767px) {
                lightning-button.completeButton button.slds-button.slds-button_brand, lightning-button.incompleteButton button.slds-button.slds-button_brand {
                    width: 30% !important;
                }
                lightning-button.saveButton button.slds-button.slds-button_brand {
                    width: 18%;
                    height: 35px;
                }
                button.slds-button.slds-button_brand{
                    width:50%;
                }
                .pendingSessionModal .slds-modal__container{
                    max-width: auto;
                    min-width: auto;
                }
                .ReadyforAttendanceCls .slds-input, .ReadyforAttendanceCls button.slds-button.slds-button_brand{
                    background-color:#9ABBFF !important; text-align: center !important; font-size: 10px !important; overflow-wrap: break-word !important;
                }
            }@media (max-width: 375px) {
                .classAttendanceLabel label.slds-form-element__label.slds-no-flex {
                    padding-bottom: 19px; 
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
        //let ampm = hours >= 12 ? 'PM' : 'AM';

        // Adjust hours for 12-hour format
        hours = hours % 12;
        hours = hours ? hours : 12; // the hour '0' should be '12'

        // Format minutes
        minutes = minutes < 10 ? '0' + minutes : minutes; // pad single digits
    if(FORM_FACTOR === "Small"){
            return `${hours}:${minutes}`;
    } else {
        return `${hours}:${minutes} ${ampm}`;
    }
        
    }
    
    handleSelectOption (event) {
      console.log('event.detail ='+event.detail);
      this.schoolId = event.detail;
      this.grade='';
      this.batch='';
    }

    value = '';

    get optionsHmAttended() {
        return [
            { label: 'Yes', value: 'Yes' },
            { label: 'No', value: 'No' },
        ];
    }
     get optionsSessionLead(){
        return [
            { label: 'Facilitator', value: 'Facilitator' },
            { label: 'PSO', value: 'PSO' },
            { label: 'School Teacher', value: 'School Teacher' },
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