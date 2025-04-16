import { LightningElement,track, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import searchStudentRecords from '@salesforce/apex/Quiz2Controller.searchStudentRecords';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import saveData from '@salesforce/apex/Quiz2Controller.saveData';
import getRecordApt from '@salesforce/apex/Quiz2Controller.getRecordApt';
export default class Quiz2Form extends NavigationMixin(LightningElement) {
    studentName='';
    showForm = false;
    selectedBatchId = '';
    selectedGrade = '';
    logedInFacilitatorEmail = '';
    seletedSchoolName = '';
    selectedSchoolAccountId = '';
    selectedBatchCode='';
    selectedBatchNumber='';
    studentSearchComponentLabel = 'Type the first 4 letters of the student name and wait for the drop down to select the student'
    studentName = '';
    @track showStudentList = false;
    @track studentDisplay = [];
    @track studentSearchResult = '';
    studentSearchText = '';
    submittedStudentMapKeys = [];
    saveFlag = false;

    quiz21Value='';
    quiz22Value='';
    quiz23Value='';
    quiz24Value='';
    quiz25Value='';
    showLoading = true;
    isShowModal=false;
    submitBtnHandler(event){
        //TODO: Show Toast Message
        if(this.quiz21Value && this.quiz22Value && this.quiz23Value && this.quiz24Value && this.quiz25Value){
            this.saveFlag = true;
            this.saveData();
            this.showToastPopMessage('Quiz 2 Data','Student Data is saved','success');
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
                name: 'Quiz_2_Details__c'
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
                this.quiz21Value = result.Quiz_2_1__c;
                this.quiz22Value = result.Quiz_2_2__c;
                this.quiz23Value = result.Quiz_2_3__c;
                this.quiz24Value = result.Quiz_2_4__c;
                this.quiz25Value = result.Quiz_2_5__c;
                this.studentName = result.Student__r.Name;
                setTimeout(() => {
                    this.checkHandler('lightning-input.quiz2-1',this.quiz21Value);
                    this.checkHandler('lightning-input.quiz2-2',this.quiz22Value);
                    this.checkHandler('lightning-input.quiz2-3',this.quiz23Value);
                    this.checkHandler('lightning-input.quiz2-4',this.quiz24Value);
                    this.checkHandler('lightning-input.quiz2-5',this.quiz25Value);
                    
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
    quiz2Handler(event){
        let quiz2Name = event.target.name;
        let value = event.target.value;

        if(quiz2Name === 'quiz2-1'){
            let isChecked = this.checkHandler('lightning-input.quiz2-1',event.target.dataset.value);
            if(isChecked)this.quiz21Value = event.target.dataset.value;
        }else if(quiz2Name === 'quiz2-2'){
            let isChecked = this.checkHandler('lightning-input.quiz2-2',event.target.dataset.value);
            if(isChecked)this.quiz22Value = event.target.dataset.value;
        }else if(quiz2Name === 'quiz2-3'){
            let isChecked = this.checkHandler('lightning-input.quiz2-3',event.target.dataset.value);
            if(isChecked)this.quiz23Value = event.target.dataset.value;
        }else if(quiz2Name === 'quiz2-4'){
            let isChecked = this.checkHandler('lightning-input.quiz2-4',event.target.dataset.value);
            if(isChecked)this.quiz24Value = event.target.dataset.value;
        }else if(quiz2Name === 'quiz2-5'){
            let isChecked = this.checkHandler('lightning-input.quiz2-5',event.target.dataset.value);
            if(isChecked)this.quiz25Value = event.target.dataset.value;
        }
        clearTimeout(this.timeoutId);
        this.timeoutId = setTimeout(this.saveData.bind(this,false), 5000); 
    }
    saveData(){
        console.log(this.quiz21Value);
        console.log(this.quiz22Value);
            console.log(this.quiz23Value);
                console.log(this.quiz24Value);
                    console.log(this.quiz25Value);
        saveData({
            studentId : this.rxStudentId,
            q21:this.quiz21Value,
            q22:this.quiz22Value,
            q23:this.quiz23Value,
            q24:this.quiz24Value,
            q25:this.quiz25Value,
            saveFlag : this.saveFlag,
            grade: this.selectedGrade
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
                    this.selectedBatchNumber=result.Batch_Number__c;
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
                name: 'Quiz_2_Details__c'
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

    get quiz21Options() {
        return [
            { label: 'Industry related to planning trips, and outdoor activities.', value: 'A' },
            { label: 'Industry related to teaching and learning of different subjects', value: 'B' },
            { label: 'Industry related to make things look good and easy to use', value: 'C' },
            { label: 'Industry related to managing money and credit', value: 'D' },
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }
    get quiz22Options() {
        return [
            { label: 'Industry related to  working with nature, plants, and animals', value: 'A' },
            { label: 'Industry related to solving problems related to land ownership', value: 'B' },
            { label: 'Industry related studying the human body and treating human diseases', value: 'C' },
            { label: 'Industry related to making sure people live long and healthy lives', value: 'D' },
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }
    get quiz23Options() {
        return [
            { label: 'Education (Teacher, Architect, Chef)', value: 'A' },
            { label: 'Media and Entertainment (Actor, Photographer, Event Planner)', value: 'B' },
            { label: 'Healthcare (Plumber, Fashion Designer, Tour Guide)', value: 'C' },
            { label: 'Engineering & Trades (Beautician,Engineer,  Army)', value: 'D' },
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }
    get quiz24Options() {
        return [
            { label: 'Finance (Financial Analyst, Application Developer, Carpenter)', value: 'A' },
            { label: 'Industry Independent (Accountant, Office Administration, Beautician)', value: 'B' },
            { label: 'Wellness & Fitness (Nutritionist, Sportsperson, Coach)', value: 'C' },
            { label: 'Tourism & Hospitality (Tour Guide, Travel Agent, Hospital)', value: 'D' },
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }
    get quiz25Options() {
        return [
            { label: 'This tells which careers someone can and cannot take up', value: 'A' },
            { label: 'This helps plan for the career challenges someone might face', value: 'B' },
            { label: 'This tells what someone likes and is good at', value: 'C' },
            { label: 'This tells a list of different careers and their qualifications', value: 'D' },
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }
}