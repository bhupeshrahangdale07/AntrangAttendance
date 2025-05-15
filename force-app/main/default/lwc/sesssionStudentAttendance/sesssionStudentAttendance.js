import { LightningElement, wire, track } from 'lwc';
import sessionSignOut from '@salesforce/apex/SessionDetailController.sessionSignOut';
import sessionStudentData  from '@salesforce/apex/SessionDetailController.getSessionStudent';
import saveStudentAttendance  from '@salesforce/apex/SessionDetailController.saveStudentAttendance';
import getdynamicpicklistval  from '@salesforce/apex/SessionDetailController.getdynamicpicklistval';
import {NavigationMixin} from "lightning/navigation";
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SesssionStudentAttendance extends NavigationMixin(LightningElement) {
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
    @track isWrongBatchChecked = false;
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
            this.classAttendance = result.studentPresented;
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
    }
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
                grade : encodeURI(this.grade)
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
                return { ...student, stdAttendance: selectedValue };
            }
            return student;
        });
    }

    handleWrongBatch(event){
         //let checkboxes = this.template.querySelectorAll('[data-id="checkbox"]')
        this.isWrongBatchChecked = event.target.value;
        const studentIdValue = event.target.dataset.studentId;
        const selectedInptValue = event.target.value;
        this.attendanceData = this.attendanceData.map(student => {
            if (student.studentId === studentIdValue) {
                return { ...student, stdWrongBatch: selectedInptValue };
            }
            return student;
        });
        console.log('WrongBatch- '+event.target.value);
        console.log('WrongBatchId- '+studentIdValue);
        if(selectedInptValue){
            sessionAttSubmitted = true;
        }

    }
    saveStudentAttendanceFunc(){
        const dataToSend = this.attendanceData;
         saveStudentAttendance({
            studentAttendanceList : JSON.stringify(dataToSend),
            saveAttendance : this.saveAttendance,
            sessionId : this.sessionId,
            reason : this.reason
        })
        .then(result => {
            console.log('result saveStudentAttendance = ',result);
            if(result){
                this.showToastMessage('Student Attendance Saved','success');
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
    onclickSaveDraft(event){
        this.showLoading = true;
        this.saveAttendance = false;
        this.saveStudentAttendanceFunc();
    }
    onclickSubmitAttendance(event){
        this.showLoading = true;
        const presentCount = this.attendanceData.filter(
            student => student.stdAttendance === "Present"
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