import { LightningElement,track, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import searchStudentRecords from '@salesforce/apex/InterestDetailsHandler.searchStudentRecords';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import saveData from '@salesforce/apex/InterestDetailsHandler.saveData';
import getRecordApt from '@salesforce/apex/InterestDetailsHandler.getRecordApt';

export default class InterestStudentDetailsForm extends NavigationMixin(LightningElement) {
    showForm = false;
    selectedBatchId = '';
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

    interestCode1Value='';
    interestCode2Value='';
    interestCode3Value='';
    showLoading = true;
    isShowModal=false;
    submitBtnHandler(event){
        //TODO: Show Toast Message
        console.log(this.interestCode1Value);
        if(this.interestCode1Value === '' || this.interestCode2Value == '' || this.interestCode3Value == '' || this.interestCode1Value === undefined || this.interestCode2Value === undefined || this.interestCode3Value === undefined){
            this.showToastPopMessage('Error!','Please fill all the mandatory(*) fields','error');
        }else{
            this.saveFlag = true;
            this.saveData();
            this.showToastPopMessage('Interst Data','Student Data is saved','success');
            //this.backBtnNavigationHelper();
            setTimeout(() => {
                this.backBtnNavigationHelper();
            }, 1000);
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
                name: 'Interest_Data_Summary__c'
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
        console.log('this.rxStudentId=',this.rxStudentId);
        getRecordApt({
            studentId : this.rxStudentId
        }).then(result => {
            console.log('awarenessData = '+result.Interest_1__c);
            if(result){
                this.showForm = true;
                this.showLoading = false;
                this.interestCode1Value = result.Interest_1__c;
                this.interestCode2Value = result.Interest_2__c;
                this.interestCode3Value = result.Interest_3__c; 
                this.studentName = result.Student__r.Name;
                setTimeout(() => {
                    this.checkHandler('lightning-input.interestcode1',this.interestCode1Value);
                    this.checkHandler('lightning-input.interestcode2',this.interestCode2Value);
                    this.checkHandler('lightning-input.interestcode3',this.interestCode3Value);
                }, 1000);
            }
        }).catch(error => {
            this.showForm = true;
            this.showLoading = false;
            console.log('error123=', error);
        });
    }
    interestCodeHandler(event){
        let interestCodeName = event.target.name;

        if(interestCodeName === 'interestcode1'){
            let isChecked = this.checkHandler('lightning-input.interestcode1',event.target.dataset.value);
            if(isChecked)this.interestCode1Value = event.target.dataset.value;
        }
        else if(interestCodeName === 'interestcode2'){
            let isChecked = this.checkHandler('lightning-input.interestcode2',event.target.dataset.value);
            if(isChecked)this.interestCode2Value = event.target.dataset.value;
        }
        else if(interestCodeName === 'interestcode3'){
            let isChecked = this.checkHandler('lightning-input.interestcode3',event.target.dataset.value);
            if(isChecked)this.interestCode3Value = event.target.dataset.value;
        }
        console.log('### interestCodeName',interestCodeName);
        clearTimeout(this.timeoutId);
        this.timeoutId = setTimeout(this.saveData.bind(this,false), 5000); 
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
    saveData(){
        saveData({
            studentId : this.rxStudentId,
            apt1 : this.interestCode1Value,
            apt2 : this.interestCode2Value,
            apt3 : this.interestCode3Value,
            grade: this.selectedGrade,
            saveFlag : this.saveFlag
        }).then(result => {
           console.log('res = ',result);
        }).catch(error => {
            console.log('error=', error);
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
                    this.selectedBatchNumber = result.Batch_Number__c;
                    this.selectedBatchCode = result.Name;
                    // this.schoolName = result.School_Name__r.Name;        
                }).catch(error => {
                    console.log('error 123 = ', error);
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
                let errorString = 'You have already filled the data for this student. If you think this is a mistake fill the support form';
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
                name: 'Interest_Data_Summary__c'
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

    get interestCodeOptions() {
        return [
            { label: 'Realistic', value: 'Realistic' },
            { label: 'Investigative', value: 'Investigative' },
            { label: 'Artistic', value: 'Artistic' },
            { label: 'Social', value: 'Social' },
            { label: 'Enterprising', value: 'Enterprising' },
            { label: 'Conventional', value: 'Conventional' },
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }
}