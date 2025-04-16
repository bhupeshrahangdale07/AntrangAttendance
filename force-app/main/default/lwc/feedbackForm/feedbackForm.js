import { LightningElement,track, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import searchStudentRecords from '@salesforce/apex/midProgramFeedbackController.searchStudentRecords';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import saveData from '@salesforce/apex/midProgramFeedbackController.saveData';
import getRecordApt from '@salesforce/apex/midProgramFeedbackController.getRecordApt';

export default class FeedbackForm extends NavigationMixin(LightningElement) {
    showForm = false;
    selectedBatchId = '';
    selectedBatchNumber='';
    selectedGrade = '';
    logedInFacilitatorEmail = '';
    seletedSchoolName = '';
    selectedSchoolAccountId = '';
    selectedBatchCode='';
    studentName='';
    studentSearchComponentLabel = 'Type the first 4 letters of the student name and wait for the drop down to select the student'
    studentName = '';
    @track showStudentList = false;
    @track studentDisplay = [];
    @track studentSearchResult = '';
    studentSearchText = '';
    submittedStudentMapKeys = [];
    saveFlag = false;

    feedback1Value='';
    feedback2Value='';
    feedback3Value='';
    feedback4Value='';
    feedback5Value='';
    feedback6Value='';
    feedback7Value='';
    showLoading = true;
    isShowModal=false;
    submitBtnHandler(event){
        //TODO: Show Toast Message

        // console.log(this.feedback1Value);
        // console.log(this.feedback2Value);
        // console.log(this.feedback3Value);
        // console.log(this.feedback4Value);
        // console.log(this.feedback5Value);
        // console.log(this.feedback6Value);
        // console.log(this.feedback7Value);
        if(this.feedback1Value && this.feedback2Value && this.feedback3Value && this.feedback4Value && this.feedback5Value && this.feedback6Value && this.feedback7Value){
            this.saveFlag = true;
            this.saveData();
            this.showToastPopMessage('Mid Program Feedback','Student Data is saved','success');
            setTimeout(() => {
                this.backBtnNavigationHelper();
            }, 1000);
        }else{
            this.showToastPopMessage('Error!','Please fill all the mandatory(*) fields','error');
        }
    }
    connectedCallback(){
        this.delayTimeOut05 = setTimeout(() => {
            this.showLoading=false;
        }, 800);
    }
    onclickBack(event){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'Mid_Program_Feedback__c'
            },
            state:{
                fem : encodeURI(this.logedInFacilitatorEmail),
                sch : encodeURI(this.seletedSchoolName),
                grd : encodeURI(this.selectedGrade), 
                bid : encodeURI(this.selectedBatchId),
                acid : encodeURI(this.selectedSchoolAccountId) 
            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }
    renderedCallback(){
        if(this.studentDisplay.length > 0)this.showStudentList = true;
        else
        {
            this.showStudentList = false;
        }

        this.flag = 'renderedCallback';
    }
    getRecordAptFun(){
        getRecordApt({
            studentId : this.rxStudentId
        }).then(result => {
            if(result){
                this.showForm = true;
                this.showLoading = false;
                this.feedback1Value = result.Feedback_1__c;
                this.feedback2Value = result.Feedback_2__c;
                this.feedback3Value = result.Feedback_3__c;
                this.feedback4Value = result.Feedback_4__c;
                this.feedback5Value = result.Feedback_5__c;
                this.feedback6Value = result.Feedback_6__c;
                this.feedback7Value = result.Feedback_7__c;
                this.studentName = result.Student__r.Name;
                setTimeout(() => {
                    this.checkHandler('lightning-input.Feedback1',this.feedback1Value);
                    this.checkHandler('lightning-input.Feedback2',this.feedback2Value);
                    this.checkHandler('lightning-input.Feedback3',this.feedback3Value);
                    this.checkHandler('lightning-input.Feedback4',this.feedback4Value);
                    this.checkHandler('lightning-input.Feedback5',this.feedback5Value);
                    this.checkHandler('lightning-input.Feedback6',this.feedback6Value);
                    this.checkHandler('lightning-input.Feedback7',this.feedback7Value);
                }, 1000);
            }
        }).catch(error => {
            this.showForm = true;
            this.showLoading = false;
            console.log('error123=', error);
            this.showToastPopMessage('Error!',error,'error')

        });
    }
    checkHandler(queString, dataValue){
        Array.from(this.template.querySelectorAll(queString))
            .forEach(element => {
                element.checked=false;
            });
            const checkbox1 = this.template.querySelector(queString+'[data-value="'+dataValue+'"]');
            if(checkbox1){
                checkbox1.checked=true; 
                return true;
            }
    }
    feedbackHandler(event){
        debugger;
        let feedbackName = event.target.name;
        let value = event.target.value;

        if(feedbackName === 'Feedback1'){
            let isChecked = this.checkHandler('lightning-input.Feedback1',event.target.dataset.value);
            if(isChecked)this.feedback1Value = event.target.dataset.value;
        }
        else if(feedbackName === 'Feedback2'){
            let isChecked = this.checkHandler('lightning-input.Feedback2',event.target.dataset.value);
            if(isChecked)this.feedback2Value = event.target.dataset.value;
        }
        else if(feedbackName === 'Feedback3'){
            let isChecked = this.checkHandler('lightning-input.Feedback3',event.target.dataset.value);
            if(isChecked)this.feedback3Value = event.target.dataset.value;
        }
        else if(feedbackName === 'Feedback4'){
            let isChecked = this.checkHandler('lightning-input.Feedback4',event.target.dataset.value);
            if(isChecked)this.feedback4Value = event.target.dataset.value;
        }
        else if(feedbackName === 'Feedback5'){
            let isChecked = this.checkHandler('lightning-input.Feedback5',event.target.dataset.value);
            if(isChecked)this.feedback5Value = event.target.dataset.value;
        }
        else if(feedbackName === 'Feedback6'){
            let isChecked = this.checkHandler('lightning-input.Feedback6',event.target.dataset.value);
            if(isChecked)this.feedback6Value = event.target.dataset.value;
        }
        else if(feedbackName === 'Feedback7'){
            let isChecked = this.checkHandler('lightning-input.Feedback7',event.target.dataset.value);
            if(isChecked)this.feedback7Value = event.target.dataset.value;
        }

        console.log('this.aptitude1Value',this.aptitude1Value);
        clearTimeout(this.timeoutId);
        this.timeoutId = setTimeout(this.saveData.bind(this,false), 5000); 
    }
    saveData(){
        saveData({
            studentId : this.rxStudentId,
            fb1 : this.feedback1Value,
            fb2 : this.feedback2Value,
            fb3 : this.feedback3Value,
            fb4 : this.feedback4Value,
            fb5 : this.feedback5Value,
            fb6 : this.feedback6Value,
            fb7 : this.feedback7Value,
            saveFlag : this.saveFlag,
            grade : this.selectedGrade
        }).then(result => {
           console.log('res = ',result);
        }).catch(error => {
            console.log('error=', error);
            this.showToastPopMessage('Error!',error,'error')
        });
    }
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.selectedBatchId = decodeURI(currentPageReference.state.bid);
          this.selectedGrade = decodeURI(currentPageReference.state.grd);
          this.logedInFacilitatorEmail = decodeURI(currentPageReference.state.fem);
          this.seletedSchoolName = decodeURI(currentPageReference.state.sch);
          this.selectedSchoolAccountId = decodeURI(currentPageReference.state.acid);

          this.rxBatch = this.selectedBatchId;
          this.rxGrade = this.selectedGrade;

          if(this.selectedBatchId){
                getBatchCodeName({
                    batchId : this.selectedBatchId
                }).then(result => {
                    this.selectedBatchCode = result.Name;
                    this.selectedBatchNumber= result.Batch_Number__c;
                    // this.schoolName = result.School_Name__r.Name;        
                }).catch(error => {
                    console.log('error 123 = ', error);
                    this.showToastPopMessage('Error!',error,'error')
                });
            }

       }
    }
    handleInputChangeStudent(event) {
        this.studentSearchText = event.detail.value;
        if (this.delayTimeOut05) {
            window.clearTimeout(this.delayTimeOut05);
        }

        this.delayTimeOut05 = setTimeout(() => {
            this.searchStudent();
        }, 1000);

        this.flag = 'handleInputChangeStudent';

    }

    searchStudent(){
        do{
            if(this.selectedBatchCode === undefined)
            {
                this.showToastPopMessage('Error!','A batch is required to search for student','error');
                break;
            }

            if(!this.studentSearchText)
            {
                //this.studentSearchResult = 'Please enter text here';
                this.studentDisplay = [];
                this.submittedStudentMapKeys = [];
                break;
            }
            else if(this.studentSearchText.length < 2) 
            {
                this.studentSearchResult = 'Enter atleast 4 characters of Student Name';
                this.studentDisplay = [];
                this.submittedStudentMapKeys = [];
                break;
            }

            searchStudentRecords({
                searchText : this.studentSearchText,
                batchId : this.selectedBatchId,
                grade : this.selectedGrade
            }).then(result => {
                const responseWrapper = JSON.parse(JSON.stringify(result));
                if(responseWrapper.gradeStudentList !== undefined)
                {
                    this.studentSearchResult = 'Students(' + responseWrapper.batchTotalStudents + ')';
                    this.studentDisplay = responseWrapper.gradeStudentList;
                }

                if(responseWrapper.submittedStudentMap !== undefined)
                {
                    this.submittedStudentMapKeys = Object.keys(responseWrapper.submittedStudentMap);
                }
                this.flag = 'searchStudent';
    
            }).catch(error => {
                let rxError = 'Error while searching student';
    
                if (Array.isArray(error.body)) {
                    rxError = error.body.map(e => e.message).join(', ');
                } else if (typeof error.body.message === 'string') {
                    rxError = error.body.message;
                }
                //console.log('Print error : ' + rxError);
                this.showToastPopMessage('Error!',rxError,'error')
              
            });

        }while(false);
    }

    handleClick(event){
        this.showLoading = true;
        let selectedStudent = event.currentTarget.dataset.id;
        do{
            if(this.submittedStudentMapKeys.length > 0 &&
                 this.submittedStudentMapKeys.includes(selectedStudent))
            {
                this.showLoading = false;
                let errorString = ' You have already filled the data for this student. If you think this is a mistake fill the support form';
                this.showToastPopMessage('Error!',errorString,'error');
                break;
            }

            this.rxStudentId = selectedStudent;

            for(let key in this.studentDisplay)
            {
                if(this.studentDisplay[key].Id === this.rxStudentId)
                {
                    this.studentName = this.studentDisplay[key].Name;
                }
            }

            if(this.rxStudentId !== undefined && this.rxStudentId !== null)
            {
                this.getRecordAptFun();
                this.studentPresent = true;
            }
        }while(false);

        this.flag = 'handleClick';
    }
    //Button Handler Functionalities :
    backBtnHandler(){
        this.isShowModal=true;
    }
    yesBackBtnHandler(){
        this.backBtnNavigationHelper();
    }
    noBackBtnHandler(){
        this.isShowModal=false;
    }
    

    backBtnNavigationHelper(event){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'Mid_Program_Feedback__c'
            },
            state:{
                fem : encodeURI(this.logedInFacilitatorEmail),
                sch : encodeURI(this.seletedSchoolName),
                grd : encodeURI(this.selectedGrade), 
                bid : encodeURI(this.selectedBatchId),
                acid : encodeURI(this.selectedSchoolAccountId) 
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

    get feedbackOptions() {
        return [
            { label: 'Strongly Disagree', value: '1' },
            { label: 'Disagree', value: '2' },
            { label: 'Neither Agree nor Disagree', value: '3' },
            { label: 'Agree', value: '4' },
            { label: 'Strongly Agree', value: '5' },
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }
}