import { LightningElement, track, wire, api } from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import getStudentRecords from '@salesforce/apex/ApptitudeController.getStudentRecords';
import aptitudeFormType from '@salesforce/apex/ApptitudeController.aptitudeFormType';
import Resource from '@salesforce/resourceUrl/Standard_Icons';
import getApptitudeRecord from '@salesforce/apex/ApptitudeController.getApptitudeRecord';

const COLS = [
    { label : 'Sr No', fieldName : 'serialNumber',type : 'number', class: ''},
    { label: 'Name',fieldName: 'Name',type: 'text',wrapText: true, class: 'slds-m-left_large'},
    { label: 'Add Assessment Data',fieldName: 'addAssessment',type: 'boolean',wrapText: true, class: 'slds-m-left_large'},
    { label: 'Submission',fieldName: 'intSubmitted',type: 'boolean',wrapText: true, class: 'slds-m-left_large'},
    
];

// const COLS = [
//     { label : 'Sr No', fieldName : 'serialNumber',type : 'number'},
//     { label: 'Name',fieldName: 'Name',type: 'text',wrapText: true },
//     { label: 'Submission',fieldName: 'intSubmitted',type: 'boolean',wrapText: true },
//     { label: 'Action',fieldName: 'addAssessment',type: 'boolean',wrapText: true }
// ];

export default class AptitudeAssesment_V2 extends NavigationMixin(LightningElement) {
    NEWICON = Resource+'/icons/utility-sprite/svg/symbols.svg#new';
lng;
    isEnglish;
    errorMsg;
    typ;
    totalStudentsOfBatchCount = 0;
    studentCompletedFormCount = 0;
    @api grade = null;
    @api batchCode = null;
    @api batchId = null;
    @api schoolName = null;
    batchNumber='';
    @api schoolId = null;
    @api facilatorEmail = null;
    @api acid = null;
    @track error;
    @track stuList ;
    rowOffset = 0;
    showLoading = true;
    @track columns = COLS;
    @track rowData=[];
    @track tableData=[];
    aptitudeForm;
    //  get getStudentCount(){
    //     if(this.totalStudentsOfBatchCount == 0 && this.studentCompletedFormCount == this.totalStudentsOfBatchCount) return true; else return false;
    // }
    @wire(CurrentPageReference)
    getCurrentPageRefxerence(currentPageReference) {
        if(currentPageReference) 
        {
            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            this.grade = decodeURI(rxCurrentPageReference.state.grd);
            this.batchId = decodeURI(rxCurrentPageReference.state.bid);
            this.cuurrValue =  decodeURI(this.grade);
            this.schoolId = decodeURI(rxCurrentPageReference.state.sch);
            this.facilatorEmail = decodeURI(rxCurrentPageReference.state.fem);
            this.acid = decodeURI(rxCurrentPageReference.state.acid);
            this.typ = decodeURI(rxCurrentPageReference.state.typ);
            this.lng = decodeURI(rxCurrentPageReference.state.lng);
            this.isEnglish = (this.lng == 'English') ? true : false;

            getBatchCodeName({
                batchId : decodeURI(rxCurrentPageReference.state.bid)
            }).then(result => {
                this.batchNumber = result.Batch_Number__c;
                this.batchCode = result.Name;
            }).catch(error => {
                console.log('error 123 = ', error);
            });
        }   
    }
    beforeUnloadHandler(ev) {
        console.log("beforeUnloadHandler called");
        return "";
    }
    disconnectedCallback() {
        window.removeEventListener("beforeunload", this.beforeUnloadHandler);
        console.log("disconnectedCallback executed");
    }
    connectedCallback() {
         window.addEventListener("beforeunload", this.beforeUnloadHandler);
        console.log("connectedCallback executed");

        if(this.isEnglish){
            this.errorMsg = 'Error';
        }else{
            this.errorMsg = 'गलती';
        }
        this.getStudentRecords();
        this.getAptitudeFormType();
        this.showLoading = false;
    }

    handleSearchKeyChange(event) {
        debugger;
        this.searchKey = event.target.value.toLowerCase()?.trim();
        var dt = this.filteredContacts();
        console.log('dt -==',dt);
        this.tableData = dt && dt.length > 0 ? dt : undefined;
    }

    filteredContacts() {
        return this.rowData.filter(contact =>
            contact?.Name?.toLowerCase().includes(this.searchKey)
        );
    }

    getStudentRecords(){
        this.showLoading = true;
        getStudentRecords({
            batchId : this.batchId,
            grade : this.grade
        }).then(result => {
            const responseWrapper = JSON.parse(JSON.stringify(result));
            console.log('responseWrapper = ',responseWrapper)
            this.totalStudentsOfBatchCount = responseWrapper.batchTotalStudents;
            // this.studentCompletedFormCount = responseWrapper.studentList.length;
            let submittedStudentList = [];
            
            this.countSubmittedStudents = 0;
            if(responseWrapper.submittedStudentList !== undefined)
            {
                this.countSubmittedStudents = responseWrapper.submittedStudentList.length;
                submittedStudentList = responseWrapper.submittedStudentList;
            }

            this.tableData = [];
            if(responseWrapper.gradeStudentList !== undefined)
            {
                if(submittedStudentList.length > 0)
                {
                    let ids = [];
                    let index = 0;
                    submittedStudentList.forEach(item => {
                        item.serialNumber = ++index;
                        item.intSubmitted = true;
                        ids.push(item.Id);
                    });
                    this.tableData = [...submittedStudentList];

                    let totalStudents = responseWrapper.gradeStudentList;                 
                    totalStudents.forEach(item => {                       
                        if(!ids.includes(item.Id))
                        {
                            item.serialNumber = ++index;
                            item.intSubmitted = false;
                            this.tableData.push(item);
                        }
                    });
                    console.log('$$$ If Condition this.tableDatas: ' + JSON.stringify(this.tableData));
                    this.rowData = this.tableData && this.tableData.length > 0 ? this.tableData : undefined;
                }
                else{
                    this.tableData = responseWrapper.gradeStudentList;
                    let index = 0;
                    this.tableData.forEach(item => {
                        item.serialNumber = ++index;
                        item.intSubmitted = false;
                    });
                    this.rowData = this.tableData && this.tableData.length > 0 ? this.tableData : undefined;
                    console.log('$$$ Else Condition this.tableData: ' + JSON.stringify(this.tableData));
                }
            }

            if(responseWrapper.batchTotalStudents !== undefined)this.batchTotalStudents = responseWrapper.batchTotalStudents;
            if(responseWrapper.batchName !== undefined)this.batchName = responseWrapper.batchName;
            if(responseWrapper.batchNumber !== undefined)this.batchNumber = responseWrapper.batchNumber;
            if(responseWrapper.schoolName !== undefined)this.schoolName = responseWrapper.schoolName;
        }).catch(error => {
            console.log('error 123 = ', error);
            this.showLoading = false;
            const event = new ShowToastEvent({
                message : this.errorMsg,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    getAptitudeFormType(){
        aptitudeFormType({
            schoolId : this.acid
        }).then(result => {
            console.log('$$$ Aptitude Assessment getAptitudeFormType: ', result);
            this.aptitudeForm = result;
            if((this.aptitudeForm.Show_Aptitude_for_G9__c === 'Aptitude Questions' && this.grade ==='Grade 9') 
            || (this.aptitudeForm.Show_Aptitude_for_G10__c === 'Aptitude Questions' && this.grade ==='Grade 10')
            || (this.aptitudeForm.Show_Aptitude_for_G11__c === 'Aptitude Questions' && this.grade ==='Grade 11')
            || (this.aptitudeForm.Show_Aptitude_for_G12__c === 'Aptitude Questions' && this.grade ==='Grade 12')){
                console.log('$$$ Aptitude_Form_V2__c');
                this.aptitudeFormType = 'Aptitude_Form_V2__c';
            }else{
                console.log('$$$ ng_form_aptitude_data_student_details_V2__c');
                this.aptitudeFormType = 'ng_form_aptitude_data_student_details_V2__c';
            }
            }).catch(error => {
            this.showLoading = false;
            let rxError = 'Error while receiving student records';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Aptitude Assessment',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    backBtnHandler(event){
        debugger;
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'DataEntryDetailPageV2__c'
            },
            state:{
                fem : encodeURI(this.facilatorEmail),
                sch : encodeURI(this.schoolId),
                grd : encodeURI(this.grade), 
                bid : encodeURI(this.batchId),
                acid : encodeURI(this.acid),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng)  
            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }

    addAssementHandler(event){
        /*let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: this.aptitudeFormType
            },
            state:{
                fem : encodeURI(this.facilatorEmail),
                sch : encodeURI(this.schoolId),
                grd : encodeURI(this.grade), 
                bid : encodeURI(this.batchId),
                acid : encodeURI(this.acid),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng),
                studentId:  encodeURI(event.target.value)
            }
        };
        this[NavigationMixin.Navigate](pageReference);*/
        var studentId = encodeURI(event.target.value);
        getApptitudeRecord({
            studentId : studentId,
            grade : this.grade,
            batchId : this.batchId,
        })
        .then(result => {
            this.showLoading = false;
            if(result === 'found'){
                if(this.isEnglish){
                    const event = new ShowToastEvent({
                        title :'Error!',
                        message : 'Student data already submitted',
                        variant : 'error'
                    });
                    this.dispatchEvent(event);
                    //this.showToastPopMessage('Error!','Student data already submitted','error')
                }else{
                    const event = new ShowToastEvent({
                        title :'गलती!',
                        message : 'छात्र का डेटा पहले ही जमा किया जा चुका है',
                        variant : 'error'
                    });
                    this.dispatchEvent(event);
                    //this.showToastPopMessage('गलती!','छात्र का डेटा पहले ही जमा किया जा चुका है','success');
                }
                location.reload();
            }else{
                if(this.batchId && this.grade){
                    let pageReference = {
                        type: 'comm__namedPage',
                        attributes: {
                            name: this.aptitudeFormType
                        }, 
                        state:{
                            fem : encodeURI(this.facilatorEmail),
                            sch : encodeURI(this.schoolId),
                            grd : encodeURI(this.grade), 
                            bid : encodeURI(this.batchId),
                            acid : encodeURI(this.acid),
                            typ : encodeURI(this.typ),
                            lng : encodeURI(this.lng),
                            studentId :   studentId            
                        }
                    };
                    this[NavigationMixin.Navigate](pageReference);
                }
            }
        }).catch(error => {
            console.log(error);
            
            this.showLoading = false;
            let rxError;
            if(this.isEnglish){
                this.errorTitle = 'योग्यता आंकड़ा';
                this.rxError = 'Error while receiving student records';
            }else{
                this.errorTitle = 'योग्यता आंकड़ा';
                this.rxError = 'छात्र रिकॉर्ड प्राप्त करते समय त्रुटि';
            }
            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }

            const event = new ShowToastEvent({
                title : this.errorTitle,
                message : this.rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                  return primer(x[field]);
              }
            : function (x) {
                  return x[field];
              };

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.stuList];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.stuList = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;

        //Below logic is added by Sunny
        let index = 0;
        this.stuList.forEach(item => {
            item.rowNumber = ++index;
        });
    }
}