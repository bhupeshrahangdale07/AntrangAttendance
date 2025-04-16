import { LightningElement,track, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import searchStudentRecords from '@salesforce/apex/RealityController.searchStudentRecords';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import saveData from '@salesforce/apex/RealityController.saveData';
import getRecordApt from '@salesforce/apex/RealityController.getRecordApt';
export default class RealityForm extends NavigationMixin(LightningElement)  {
    showForm = false;
    selectedBatchId = '';
    selectedGrade = '';
    logedInFacilitatorEmail = '';
    seletedSchoolName = '';
    selectedSchoolAccountId = '';
    selectedBatchCode='';
    selectedBatchNumber ='';
    studentSearchComponentLabel = 'Type the first 4 letters of the student name and wait for the drop down to select the student'
    studentName = '';
    @track showStudentList = false;
    @track studentDisplay = [];
    @track studentSearchResult = '';
    studentSearchText = '';
    submittedStudentMapKeys = [];
    saveFlag = false;

    selfQue1Value='';
    selfQue2Value='';
    selfQue3Value='';
    selfQue4Value='';
    familyQue1Value='';
    familyQue2Value='';
    familyQue3Value='';
    familyQue4Value='';

    showLoading = true;
    isShowModal=false;
    submitBtnHandler(event){
        //TODO: Show Toast Message
        if(this.selfQue1Value && this.selfQue2Value && this.selfQue3Value && this.selfQue4Value && this.familyQue1Value && this.familyQue2Value && this.familyQue3Value && this.familyQue4Value){
            this.saveFlag = true;
            this.saveData();
            this.showToastPopMessage('Reality Data','Student Data is saved','success');
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
                name: 'Reality_Details__c'
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
                this.selfQue1Value = result.Reality1_Self_1__c;
                this.selfQue2Value = result.Reality_2_Self_2__c;
                this.selfQue3Value = result.Reality_3_Self_3__c;
                this.selfQue4Value = result.Reality_4_Self_4__c;
                this.familyQue1Value = result.Reality_5_Family_1__c;
                this.familyQue2Value = result.Reality_6_Family_2__c;
                this.familyQue3Value = result.Reality_7_Family_3__c;
                this.familyQue4Value = result.Reality_8_Family_4__c;
                this.studentName = result.Student__r.Name;
                setTimeout(() => {
                    this.checkHandler('lightning-input.selfQue1',this.selfQue1Value);
                    this.checkHandler('lightning-input.selfQue2',this.selfQue2Value);
                    this.checkHandler('lightning-input.selfQue3',this.selfQue3Value);
                    this.checkHandler('lightning-input.selfQue4',this.selfQue4Value);
                    this.checkHandler('lightning-input.familyQue1',this.familyQue1Value);
                    this.checkHandler('lightning-input.familyQue2',this.familyQue2Value);
                    this.checkHandler('lightning-input.familyQue3',this.familyQue3Value);
                    this.checkHandler('lightning-input.familyQue4',this.familyQue4Value);
                }, 1000);
            }
        }).catch(error => {
            this.showForm = true;
            this.showLoading = false;
            console.log('error123=', error);
            //this.showToastPopMessage('Error!',error,'error')

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
    realityHandler(event){
        let realityName = event.target.name;
        let value = event.target.value;

        if(realityName === 'selfQue1'){
            let isChecked = this.checkHandler('lightning-input.selfQue1',event.target.dataset.value);
            if(isChecked)this.selfQue1Value = event.target.dataset.value;
        }
        else if(realityName === 'selfQue2'){
            let isChecked = this.checkHandler('lightning-input.selfQue2',event.target.dataset.value);
            if(isChecked)this.selfQue2Value = event.target.dataset.value;
        }
        else if(realityName === 'selfQue3'){
            let isChecked = this.checkHandler('lightning-input.selfQue3',event.target.dataset.value);
            if(isChecked)this.selfQue3Value = event.target.dataset.value;
        }
        else if(realityName === 'selfQue4'){
            let isChecked = this.checkHandler('lightning-input.selfQue4',event.target.dataset.value);
            if(isChecked)this.selfQue4Value = event.target.dataset.value;
        }
        else if(realityName === 'familyQue1'){
            let isChecked = this.checkHandler('lightning-input.familyQue1',event.target.dataset.value);
            if(isChecked)this.familyQue1Value = event.target.dataset.value;
        }
        else if(realityName === 'familyQue2'){
            let isChecked = this.checkHandler('lightning-input.familyQue2',event.target.dataset.value);
            if(isChecked)this.familyQue2Value = event.target.dataset.value;
        }
        else if(realityName === 'familyQue3'){
            let isChecked = this.checkHandler('lightning-input.familyQue3',event.target.dataset.value);
            if(isChecked)this.familyQue3Value = event.target.dataset.value;
        }
        else if(realityName === 'familyQue4'){
            let isChecked = this.checkHandler('lightning-input.familyQue4',event.target.dataset.value);
            if(isChecked)this.familyQue4Value = event.target.dataset.value;
        }
        clearTimeout(this.timeoutId);
        this.timeoutId = setTimeout(this.saveData.bind(this,false), 5000); 
    }
    saveData(){
        console.log(this.selfQue1Value);
        saveData({
            studentId : this.rxStudentId,
            self1 : this.selfQue1Value,
            self2 : this.selfQue2Value,
            self3 : this.selfQue3Value,
            self4 : this.selfQue4Value,
            family1 : this.familyQue1Value,
            family2 : this.familyQue2Value,
            family3 : this.familyQue3Value,
            family4 : this.familyQue4Value,
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
                    this.selectedBatchNumber = result.Batch_Number__c;
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
                name: 'Reality_Details__c'
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

    get realityOptions() {
        return [
            { label: 'Yes', value: 'A' },
            { label: 'No', value: 'B' },
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }
    get realitySelfFor4Options() {
        return [
            { label: 'Below 50%', value: 'A' },
            { label: '50-80%', value: 'B' },
            { label: 'Above 80%', value: 'C' },
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }
    get realityFamilyfor4Options() {
        return [
            { label: 'Below Rs 10000', value: 'A' },
            { label: 'Rs10000 - Rs20000', value: 'B' },
            { label: 'Above 20000', value: 'C' },
            { label: 'I do not know', value: 'D' },
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }
}