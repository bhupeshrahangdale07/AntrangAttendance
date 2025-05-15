import { LightningElement, wire, track } from 'lwc';
import sessionSignOut from '@salesforce/apex/SessionDetailController.sessionSignOut';
import sessionStudentData  from '@salesforce/apex/SessionDetailController.getSessionStudent';
import saveStudentAttendance  from '@salesforce/apex/SessionDetailController.saveStudentAttendance';
import getdynamicpicklistval  from '@salesforce/apex/SessionDetailController.getdynamicpicklistval';
import {NavigationMixin} from "lightning/navigation";
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningAlert from 'lightning/alert';

export default class SesssionParentAttendance extends NavigationMixin(LightningElement) {
    inactivityTimeout;
    @track sessionAttSubmitted;
    @track reason='';
    isShowModal=false;
    saveAttendance;
    showLoading;
    @track facEmailId;
    code;
    @track schoolId;
    @track grade;
    @track batch;
    @track sessionId;
    @track classAttendance;
     @track attendanceData;
     @track sessionName;
    @track sessionData;
    @track attendancePicklist;
    @track reasonOption;
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference){
        if (currentPageReference){
            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            this.code = rxCurrentPageReference.state.code ? decodeURI(rxCurrentPageReference.state.code) : null;
            this.facEmailId = rxCurrentPageReference.state.facilitorId ? decodeURI(rxCurrentPageReference.state.facilitorId) : null;
            this.schoolId = rxCurrentPageReference.state.schoolId ? decodeURI(rxCurrentPageReference.state.schoolId) : null;
            this.batch = rxCurrentPageReference.state.batch ? decodeURI(rxCurrentPageReference.state.batch) : null;
            this.grade = rxCurrentPageReference.state.grade ? decodeURI(rxCurrentPageReference.state.grade) : null;
            this.sessionId = rxCurrentPageReference.state.sessionId ? decodeURI(rxCurrentPageReference.state.sessionId) : null;
            console.log('code =',this.code)
            console.log('facEmailId = ',this.facEmailId) 
        }
    }

    // @wire(sessionStudentData, {batchId : this.batch, facilitatorId : this.facEmailId, sessionID : this.sessionId, selectedGrade : this.grade})
    //     studentData({error, data}){
    //        if(data){
    //         console.log('Data-'+JSON.stringify(data));
    //        }else if(error){
    //         console.log('error- '+JSON.stringify(error));
    //        }
    //     }

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
    handleReasonChange(event){
        this.reason = event.detail.value;
    }
    onclickCancel(event){
        this.reason = '';
        this.isShowModal = false;
    }
    onclickOk(event){
        if(this.reason === ''){
            this.showToastMessage('Please select reason','error');
        }else{
            this.saveStudentAttendanceFunc();
        }
        
    }
    getReasonPicklist(){
        
        getdynamicpicklistval({
            objectName : 'session__c',
            fieldName : 'Log_Reason__c'
        })
        .then(result => {
            console.log('result getdynamicpicklistval = ',result);
            this.reasonOption = result.filter(option => option.value !== '');
            
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
        this.startInactivityTimer();
        // Track user activity
        window.addEventListener('mousemove', this.resetTimer);
        window.addEventListener('keydown', this.resetTimer);
        window.addEventListener('click', this.resetTimer);
        window.addEventListener('scroll', this.resetTimer);
        window.addEventListener('touchstart', this.resetTimer);


        this.showLoading = true;
        window.addEventListener("beforeunload", this.handleTabClose);
        console.log('this.code = ',this.code);
        if(this.code == window.name){
            if(!this.code || !this.facEmailId){
                console.log('a');
                this.showToastMessage('Error While Login','error');
                this.backToLogin();
            }else{
                 this.sessionStudentDataFunc();
                // this.getPendingSessionFunc();
                // this.getdynamicpicklistvalFunc();
            }
            
        }else{
            console.log('b');
            this.showToastMessage('This form is already open in another tab!','error');
            this.backToLogin();
        }
        

    }
    get allSectionNames() {
        return this.attendanceData.map(student => student.studentId);
    }
    showAttendanceTable = false;
    sessionStudentDataFunc(){
        sessionStudentData({batchId : this.batch, facilitatorId : this.facEmailId, sessionID : this.sessionId, 
            selectedGrade : this.grade})
        .then((result)=>{
            console.log('result sessionStudentData = '+JSON.stringify(result));
            if(result.SessionData[0]) {
                this.sessionName = result.SessionData[0].Name;
                this.sessionAttSubmitted = result.SessionData[0].Attendance_Submitted__c;
            }
            this.classAttendance = result.parentPresented;
            this.attendancePicklist = result.attendancepicklist;
            this.attendanceData = result.studentdata;
            
            console.log('this.attendanceData.length =',this.attendanceData.length);
            if(this.attendanceData.length > 0){
                this.showAttendanceTable = true;
            }else{
                this.showAttendanceTable =  false;
            }
            this.showLoading = false;
            //this.sessionData = result.studentdata.sessiondata[0];
            //console.log('this.attendanceData  =',this.attendanceData );
        })
        .catch((Error)=>{
            console.log('Error ='+Error);
            console.log('Error= '+JSON.stringify(Error));
        })
    }
    get attendanceOptions() {
        return this.attendancePicklist || [];
    }
    disconnectedCallback() {
        window.removeEventListener('beforeunload', this.handleTabClose);

        this.clearInactivityTimer();

        // Remove listeners
        window.removeEventListener('mousemove', this.resetTimer);
        window.removeEventListener('keydown', this.resetTimer);
        window.removeEventListener('click', this.resetTimer);
        window.removeEventListener('scroll', this.resetTimer);
        window.removeEventListener('touchstart', this.resetTimer);

    }
    startInactivityTimer = () => {
        console.log('inactivityTimeout');
        this.inactivityTimeout = setTimeout(() => {
            LightningAlert.open({
                message: 'It has been half an hour since the last update. Please refresh the form to continue, or log out.',
                theme: 'warning', // Options: 'default', 'shade', 'inverse', 'alt-inverse', 'success', 'info', 'warning', 'error'
                label: 'Session Inactive', // Title of the alert
                variant: 'header' // Style variant
            }).then(() => {
                // Action after clicking OK
                location.reload(); // or use logout: window.location.href = '/secur/logout.jsp';
            });
        }, 30 * 60 * 1000); // 30 minutes
    };

    resetTimer = () => {
        clearTimeout(this.inactivityTimeout);
        this.startInactivityTimer();
    };

    clearInactivityTimer = () => {
        clearTimeout(this.inactivityTimeout);
    };

    handleTabClose = (event) => {
        this.sessionSignOutFunc();
        /*const nextUrl = event.target?.document?.activeElement?.baseURI || document.activeElement?.baseURI;
        if (!nextUrl || !nextUrl.startsWith(this.baseUrl)) {
            this.sessionSignOut();
        }*/

    };
    
    handleBackToScheduling(){
         let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'SessionDetail__c'
                },
                state: {
                facilitorId : encodeURI(this.facEmailId),
                code : encodeURI(this.code),
                schoolId : encodeURI(this.schoolId),
                batch : encodeURI(this.batch),
                grade : encodeURI(this.grade),
                back: true
            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }
    handleAttendanceChange(event) {
        const studentId = event.target.dataset.studentId;
        const selectedValue = event.detail.value;

        // Update the corresponding student's attendance in the array
        this.attendanceData = this.attendanceData.map(student => {
            if (student.studentId === studentId) {
                return { ...student, parentAttendance: selectedValue};
            }
            return student;
        });
    }
     handleWrongBatch(event) {
        const studentIdValue = event.target.dataset.studentId;
        const isChecked = event.target.checked;
        console.log('studentIdValue - ',studentIdValue);
        this.attendanceData = this.attendanceData.map(student => {
            if (student.studentId == studentIdValue) {
                return { ...student, stdWrongBatch: event.target.checked, stdAttendance:"", parentAttendance:""};
            }
            return student;
        });
        console.log(' this.attendanceData  =', this.attendanceData 
        )
        
    }
    handleParentAttendanceChange(event){
        const studentId = event.target.dataset.studentId;
        const selectedValue = event.detail.value;

        // Update the corresponding student's attendance in the array
        this.attendanceData = this.attendanceData.map(student => {
            if (student.studentId === studentId) {
                return { ...student, stdAttendance: selectedValue };
            }
            return student;
        });
    }
    saveStudentAttendanceFunc(){
        const dataToSend = this.attendanceData;
        console.log('dataToSend- '+JSON.stringify(dataToSend));

         saveStudentAttendance({
            studentAttendanceList : JSON.stringify(dataToSend),
            saveAttendance : this.saveAttendance,
            sessionId : this.sessionId,
            reason : this.reason
        })
        .then(result => {
            console.log('result saveStudentAttendance = ',result);
            if(result){
                this.showToastMessage('Attendance Saved','success');
                this.connectedCallback();
            }else{
                this.showToastMessage('Error While Save','error');
            }
            this.isShowModal = false;
             this.showLoading = false;
            //this.backToLogin();
            //this.showLoading = false;
            
        }).catch(error => {
            this.showToastMessage(error.body.message,'error');
            console.log(error.body.message);
            this.showLoading = false;
        });
    }
    validate() {
        let isValid = true;

        this.template.querySelectorAll('lightning-combobox').forEach(input => {
            if (!input.checkValidity()) {
                input.reportValidity();
                isValid = false;
            }
        });

        return isValid;
    }
    onclickSaveDraft(event){
        this.showLoading = true;
        this.saveAttendance = false;

        // Run validation first
        const isValid = this.validate();
        if (!isValid) {
            this.showLoading = false; // Hide loader if validation fails
            return;
        }

        this.saveStudentAttendanceFunc();
    }
    onclickSubmitAttendance(event){
        this.showLoading = true;
        const isValid = this.validate();
        if (!isValid) {
            this.showLoading = false; // Hide loader if validation fails
            return;
        }
        console.log('this.attendanceData = ',this.attendanceData);
        const presentCount = this.attendanceData.filter(
            student => student.parentAttendance === "Present"
        ).length;
        console.log('presentCount =',presentCount)
        if(presentCount == this.classAttendance){
            this.saveAttendance = true;
            this.saveStudentAttendanceFunc();
        }else{
            this.saveAttendance = true;
            this.getReasonPicklist();
            this.showLoading = false; 
            this.isShowModal = true;
        }
    }
     renderedCallback() {
        if (typeof window !== 'undefined') {
            const style = document.createElement('style');
            style.innerText =  `.slds-modal__container{
                    max-width: 60rem;
            }.slds-modal__content{
                padding: 40px 60px !Important;
            }.btnGrp button.slds-button.slds-button_brand {
                width: 20%;
            }.btnCancel button.slds-button.slds-button_brand {
                background-color: #1A1A1A;
            }.btnOk button.slds-button.slds-button_brand {
                background-color: #50A771;
            }lightning-accordion-section.slds-accordion__list-item {
                border: none;
            }.slds-accordion__summary-heading .slds-button:focus {
                box-shadow: none;
            }label.slds-form-element__label {
                font-size: 14px;
                margin-top: 12px;
                margin-bottom: 10px;
            }abbr.slds-required {
                display: none;
            }
            @media (max-width: 767px) {
                div.slds-modal__content{
                    padding: 30px !Important;
                }
            }`;
            this.template.querySelector('div').appendChild(style);
        }
    }
}