import { LightningElement, api, track, wire} from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import getStudentData from '@salesforce/apex/EndlineAssessmentController.getStudentDataV2';
import Resource from '@salesforce/resourceUrl/Standard_Icons';
import getEndlineRecord from '@salesforce/apex/EndlineAssessmentController.getEndlineRecord';

const COLS = [
    { label : 'Sr No', fieldName : 'serialNumber',type : 'number', class: ''},
    { label: 'Name',fieldName: 'Name',type: 'text',wrapText: true, class: 'slds-m-left_large'},
    { label: 'Add Assessment Data',fieldName: 'addAssessment',type: 'boolean',wrapText: true, class: 'slds-m-left_large'},
    { label: 'Submission',fieldName: 'intSubmitted',type: 'boolean',wrapText: true, class: 'slds-m-left_large'},
    
];
// const COLS = [
//     { label : 'Sr No', fieldName : 'serialNumber',type : 'number',cellAttributes: { alignment: 'center' },fixedWidth: 90 },
//     { label: 'Name',fieldName: 'Name',type: 'text',wrapText: true },
//     { label: 'Submission',fieldName: 'intSubmitted',type: 'boolean',wrapText: true },
//     { label: 'Action',fieldName: 'addAssessment',type: 'boolean',wrapText: true }
// ];

export default class EndlineCPAssesment_V2 extends NavigationMixin(LightningElement) {
    NEWICON = Resource+'/icons/utility-sprite/svg/symbols.svg#new';
    showLoading = true;
    @api grade = null;
    @api batchCode = null;
    @api batchId = null;
    @api schoolName = null;
    batchNumber = '';
    @api schoolId = null;
    @api facilatorEmail = null;
    @api acid = null;
    typ;
    lng;
    isEnglish;
    batchTotalStudents = 0;
    studentCompletedFormCount = 0;
    countSubmittedStudents = 0;
    @track rowData=[];
    @track tableData = [];

    @track rawData;
    @track searchKey = '';

    @track columns = COLS;

    //For Getting Params from the Url.  
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference){
        if (currentPageReference){
            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            this.grade = decodeURI(rxCurrentPageReference.state.grd);
            this.batchId = decodeURI(rxCurrentPageReference.state.bid);
            this.schoolId = decodeURI(rxCurrentPageReference.state.sch);
            this.facilatorEmail = decodeURI(rxCurrentPageReference.state.fem);
            this.acid = decodeURI(rxCurrentPageReference.state.acid);
            this.typ = decodeURI(rxCurrentPageReference.state.typ);
            this.lng = decodeURI(rxCurrentPageReference.state.lng);
            this.isEnglish = (this.lng == 'English') ? true : false;
            if(this.batchId){
                getBatchCodeName({ batchId : this.batchId })
                .then(result => {
                    this.batchNumber =  result.Batch_Number__c;
                    this.batchCode = result.Name;      
                }).catch(error => {
                    if(this.isEnglish){
                        this.showToastPopMessage('Error!',error,'error')
                    }else{
                        this.showToastPopMessage('गलती!','गलती','success');
                    } 
                });
            }
        }
    }

    connectedCallback() {
        this.showLoading = false;
        this.getStudentRecords();
    }

    getStudentRecords(){
        console.log('$$$ this.batchId', this.batchId);
        getStudentData({
            batchId : this.batchId,
            grade : this.grade,
            type : 'CP'
        })
        .then(result => {
            debugger;
            console.log('result getStudentDataV2: ' + JSON.stringify(result));
            const responseWrapper = JSON.parse(JSON.stringify(result));
            let submittedStudentList = [];
            
            if(responseWrapper.submittedStudentList !== undefined){
                this.countSubmittedStudents = responseWrapper.submittedStudentList.length;
                submittedStudentList = responseWrapper.submittedStudentList;
            }

            if(responseWrapper.gradeStudentList !== undefined){
                if(submittedStudentList.length > 0){
                    let ids = [];
                    let index = 0;
                    submittedStudentList.forEach(item => {
                        item.serialNumber = ++index;
                        item.intSubmitted = true;
                        ids.push(item.Id);
                    });
                    this.tableData = [...submittedStudentList];
                    console.log('$$$ tableData', this.tableData);
                    let totalStudents = responseWrapper.gradeStudentList;                 
                    totalStudents.forEach(item => {                       
                        if(!ids.includes(item.Id))
                        {
                            item.serialNumber = ++index;
                            item.intSubmitted = false;
                            this.tableData.push(item);
                        }
                    });
                    this.rawData = this.tableData && this.tableData.length > 0 ? this.tableData : undefined;
                    console.log('$$$ If Condition this.tableData: ' + JSON.stringify(this.tableData));
                }
                else{
                    this.tableData = responseWrapper.gradeStudentList;
                    let index = 0;
                    this.tableData.forEach(item => {
                        item.serialNumber = ++index;
                        item.intSubmitted = false;
                    });
                    this.rawData = this.tableData && this.tableData.length > 0 ? this.tableData : undefined;
                    console.log('$$$ Else Condition this.tableData: ' + JSON.stringify(this.tableData));
                }
            }

            if(responseWrapper.batchTotalStudents !== undefined)this.batchTotalStudents = responseWrapper.batchTotalStudents;
            if(responseWrapper.batchName !== undefined)this.batchName = responseWrapper.batchName;
            if(responseWrapper.batchNumber !== undefined)this.batchNumber = responseWrapper.batchNumber;
            if(responseWrapper.schoolName !== undefined)this.schoolName = responseWrapper.schoolName;
            this.showLoading = false;
        }).catch(error => {
            console.log('$$$ Error:', error);
            this.showLoading = false;
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while receiving student records';
            }else{
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

    handleSearchKeyChange(event) {
        debugger;
        this.searchKey = event.target.value.toLowerCase()?.trim();
        var dt = this.filteredContacts();
        this.tableData = dt && dt.length > 0 ? dt : undefined;
    }

    filteredContacts() {
        return this.rawData.filter(contact =>
            contact?.Name?.toLowerCase().includes(this.searchKey)
        );
    }

    addAssementHandler(event){
        /*debugger;
        console.log('Add Assement Button clicked !!!!');
        if(this.batchId && this.grade){
            let pageReference = {
                type: 'comm__namedPage',
                attributes: {
                    name: 'Career_Planning_A_Endline_V2__c'
                }, 
                state:{
                    fem : encodeURI(this.facilatorEmail),
                    sch : encodeURI(this.schoolId),
                    grd : encodeURI(this.grade), 
                    bid : encodeURI(this.batchId),
                    acid : encodeURI(this.acid),
                    typ : encodeURI(this.typ),
                    lng : encodeURI(this.lng),
                    studentId :  event.target.value
                }
            };
            this[NavigationMixin.Navigate](pageReference);
        }*/
        var studentId = encodeURI(event.target.value);
            getEndlineRecord({
                studentId : studentId,
                grade : this.grade,
                type:'CP',
                batchId : this.batchId,
            })
            .then(result => {
                this.showLoading = false;
                if(result === 'found'){
                    if(this.isEnglish){
                        const event = new ShowToastEvent({
                            title : 'Error!',
                            message : 'Student data already submitted',
                            variant : 'error'
                        });
                        this.dispatchEvent(event);
                        //this.showToastPopMessage('Error!','Student data already submitted','error')
                    }else{
                        const event = new ShowToastEvent({
                            title : 'गलती!',
                            message : 'छात्र का डेटा पहले ही जमा किया जा चुका है',
                            variant : 'error'
                        });
                        this.dispatchEvent(event);
                        //this.showToastPopMessage('गलती!','छात्र का डेटा पहले ही जमा किया जा चुका है','error');
                    }
                    location.reload();
                }else{
                    if(this.batchId && this.grade){
                        let pageReference = {
                            type: 'comm__namedPage',
                            attributes: {
                                name: 'Career_Planning_A_Endline_V2__c'
                            }, 
                            state:{
                                fem : encodeURI(this.facilatorEmail),
                                sch : encodeURI(this.schoolId),
                                grd : encodeURI(this.grade), 
                                bid : encodeURI(this.batchId),
                                acid : encodeURI(this.acid),
                                typ : encodeURI(this.typ),
                                lng : encodeURI(this.lng),
                                studentId :   studentId,
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
                    this.errorTitle = 'Endline Career Planning Assessment';
                    this.rxError = 'Error while receiving student records';
                }else{
                    this.errorTitle = 'एंडलाइन भविष्य की योजना मूल्यांकन';
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

    backBtnHandler(){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'endlinesublinks_V2__c'
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

    showToastPopMessage(title,messageParam,variantParam){
        const evt = new ShowToastEvent({
            title: title,
            message:messageParam,
            variant: variantParam,
        });
        this.dispatchEvent(evt);
    }
}