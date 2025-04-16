import { LightningElement,track, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import searchStudentRecords from '@salesforce/apex/Quiz2Controller.searchStudentRecords';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import saveData from '@salesforce/apex/Quiz2Controller.saveData';
import getRecordApt from '@salesforce/apex/Quiz2Controller.getRecordApt';
import submitAndCalculate from '@salesforce/apex/Quiz2Controller.submitAndCalculate';
import getQuiz2Record from '@salesforce/apex/Quiz2Controller.getQuiz2Record';
import getAssesmentQuestion from '@salesforce/apex/AssesementQuestionController.getAssesmentQuestion';

export default class Quiz2FormV2 extends NavigationMixin(LightningElement) {
    isEnglish;
    yesLabel;
    noLabel;
    title = '';
    errorTitle = '';
    successTitle = '';
    successMsg = '';
    studentName='';
    lng;
    typ;
    //showForm = false;
    selectedBatchId = '';
    selectedGrade = '';
    logedInFacilitatorEmail = '';
    seletedSchoolName = '';
    selectedSchoolAccountId = '';
    selectedBatchCode='';
    selectedBatchNumber='';
    studentSearchComponentLabel = ''
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
    recordId='';
    showLoading = true;
    isShowModal=false;
    submitBtnHandler(event){
        this.showLoading = true;
        //TODO: Show Toast Message
        if(this.quiz21Value && this.quiz22Value && this.quiz23Value && this.quiz24Value && this.quiz25Value){
            this.saveFlag = true;
            //this.saveData();
            console.log('this.rxStudentId = ',this.rxStudentId);
            
            getQuiz2Record({
                studentId : this.rxStudentId,
                grade : this.selectedGrade,
                batchId : this.selectedBatchId,
            })
            .then(result => {
                debugger;
                this.showLoading = false;
                var errorTitle ;
                var rxError;
                console.log('result = '+result);
                if(result === 'found'){
                    if(this.isEnglish){
                        errorTitle = 'Error!';
                        rxError = 'Student data already submitted';
                    }else{
                        errorTitle = 'गलती!';
                        rxError = 'छात्र का डेटा पहले ही जमा किया जा चुका है';
                    }
                    const event = new ShowToastEvent({
                        title : errorTitle,
                        message : rxError,
                        variant : 'error'
                    });
                    this.dispatchEvent(event);
                    this.yesBackBtnHandler();
                }else{
                    this.saveData(); 
                }
            }).catch(error => {
                console.log(error);
                
                this.showLoading = false;
                let rxError;
                if(this.isEnglish){
                    this.errorTitle = 'Quiz 2';
                    this.rxError = 'Error while receiving student records';
                }else{
                    this.errorTitle = 'प्रश्नावली 2';
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

            // this.showToastPopMessage('Quiz 2 Data','Student Data is saved','success');
            // setTimeout(() => {
            //     this.backBtnNavigationHelper();
            // }, 1000);
        }else{
            this.saveFlag = false;
            let queNo = '';
            if(this.quiz21Value == '' || this.quiz21Value == null)
                queNo += ', ' + 'Q1';
            if(this.quiz22Value == '' || this.quiz22Value == null)
                queNo += ', ' + 'Q2';
            if(this.quiz23Value == '' || this.quiz23Value == null)
                queNo += ', ' + 'Q3';
            if(this.quiz24Value == '' || this.quiz24Value == null)
                queNo += ', ' + 'Q4';
            if(this.quiz25Value == '' || this.quiz25Value == null)
                queNo += ', ' + 'Q5';
            queNo = queNo.trim();
            if (queNo.startsWith(",")) {
                queNo = queNo.substring(1);
            }
            this.showLoading = false;
            if(this.isEnglish){
                // this.showToastPopMessage('Quiz2-Grade 9','Please choose answers for questions: ' + queNo,'error');
                this.showToastPopMessage(this.errorTitle,'Please choose answers for questions: ' + queNo,'error');
            }else{
                // this.showToastPopMessage('प्रश्नावली2-ग्रेड 9','कृपया प्रश्नों के उत्तर चुनें: '+ queNo,'error');
                this.showToastPopMessage('प्रश्नावली2','कृपया प्रश्नों के उत्तर चुनें: '+ queNo,'error');
            }
        }
    }
    connectedCallback(){
        if(this.isEnglish){
             this.studentSearchResult = 'Please enter Student here';
            this.yesLabel = 'Yes';
            this.noLabel = 'No';
            this.studentSearchComponentLabel = 'Type the first 4 letters of the student name and wait for the drop down to select the student';
        }else{
            this.studentSearchResult = 'कृपया यहां छात्र दर्ज करें';
            this.yesLabel = 'हाँ';
            this.noLabel = 'नहीं';
            this.studentSearchComponentLabel = 'छात्र के नाम के पहले 4 अक्षर टाइप करें और छात्र का चयन करने के लिए ड्रॉप डाउन की प्रतीक्षा करें';
        }
        this.delayTimeOut05 = setTimeout(() => {
            this.showLoading=false;
        }, 800);
        this.getAssesmentQuestionFunc();
    }
    assesmentQuestionAndLabel = [];
    question01;
    question02;
    question03;
    question04;
    question05;
    quiz22Options=[];
    quiz21Options=[];
    quiz23Options=[];
    quiz24Options=[];
    quiz25Options=[];
    //This method is called to get all questions
    getAssesmentQuestionFunc(){
        getAssesmentQuestion({
            objectName : 'Quiz - 2',
            formType : 'Form V2',
            grade : ''
        }).then(result => {
            console.log('getAssesmentQuestion Result = '+JSON.stringify(result));
            if(result){
                this.assesmentQuestionAndLabel = result;
                let que1 = this.getQuestionsAndOptions(1);
                if(que1){
                    this.question01 = que1.question;
                    this.quiz21Options = que1.options;
                }
                let que2 = this.getQuestionsAndOptions(2);
                if(que2){
                    this.question02 = que2.question;
                    this.quiz22Options = que2.options;
                }
                let que3 = this.getQuestionsAndOptions(3);
                if(que3){
                    this.question03 = que3.question;
                    this.quiz23Options = que3.options;
                }
                let que4 = this.getQuestionsAndOptions(4);
                if(que4){
                    this.question04 = que4.question;
                    this.quiz24Options= que4.options;
                }
                let que5 = this.getQuestionsAndOptions(5);
                if(que5){
                    this.question05 = que5.question;
                    this.quiz25Options = que5.options;
                }
                //this.getApexRecordSAF();
            }
            
        }).catch(error => {
            console.log('getAssesmentQuestion Error = ',error);
        });
    }
    getQuestionsAndOptions(seqNumber){
        let que = this.assesmentQuestionAndLabel.find(question => question.Sequence_Number__c === seqNumber);
        let question = '';
        let options = [];
        if(que){
            question = ((this.lng === 'Hindi') ? que.Question_Label_Hindi__c :que.Question_Label_English__c);
            if(que.Assessment_Question_Options__r){
                let optionNames = ['A', 'B', 'C', 'D', 'E','F','G','H','I'];
                let i=0;
                for (let opt of que.Assessment_Question_Options__r) {
                    let optionValue =  (this.lng === 'Hindi') ? opt.Option_Label_Hindi__c :opt.Option_Label_English__c;
                    let optionName = (opt.Option_Label_English__c === 'No Answer') ? 'nil' : (opt.Option_Label_English__c === 'Multiple answers selected') ? '*' : optionNames[i];
                    let option = {label:optionValue,value:optionName }
                    options.push(option);
                    i++;
                }
            }
        }
        return {question,options};
    }
    onclickBack(event){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'Quiz_2_Details_V2__c'
            },
            state:{
                fem : encodeURI(this.logedInFacilitatorEmail),
                sch : encodeURI(this.seletedSchoolName),
                grd : encodeURI(this.selectedGrade), 
                bid : encodeURI(this.selectedBatchId),
                acid : encodeURI(this.selectedSchoolAccountId),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng)  
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
                //this.showForm = true;
                if(this.saveFlag == false) this.showLoading = false;
                this.quiz21Value = result.Quiz_2_1__c;
                this.quiz22Value = result.Quiz_2_2__c;
                this.quiz23Value = result.Quiz_2_3__c;
                this.quiz24Value = result.Quiz_2_4__c;
                this.quiz25Value = result.Quiz_2_5__c;
                this.studentName = result.Student__r.Name;
                this.recordId = result.id;
                setTimeout(() => {
                    this.checkHandler('lightning-input.quiz2-1',this.quiz21Value);
                    this.checkHandler('lightning-input.quiz2-2',this.quiz22Value);
                    this.checkHandler('lightning-input.quiz2-3',this.quiz23Value);
                    this.checkHandler('lightning-input.quiz2-4',this.quiz24Value);
                    this.checkHandler('lightning-input.quiz2-5',this.quiz25Value);
                    
                }, 1000);
                if(this.saveFlag == true) this.marksCalculation();

            }
        }).catch(error => {
            //this.showForm = true;
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
        // clearTimeout(this.timeoutId);
        // this.timeoutId = setTimeout(this.saveData.bind(this,false), 5000); 
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
            grade: this.selectedGrade,
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? 'Form V2' : 'Form V1'
        }).then(result => {
           console.log('res = ',result);
           this.backBtnNavigationHelper();
            this.showToastPopMessage(this.successTitle,this.successMsg,'success');
            this.showLoading = false;
        //    if(result){
        //        this.getRecordAptFun();
        //    }
        }).catch(error => {
            console.log('error=', error);
            this.showToastPopMessage(this.errorTitle,error,'error');
        });
    }
    marksCalculation(){
         submitAndCalculate({
            recordIdCMD1 : this.recordId
        }).then(result => {
            console.log('res = ',result);
            this.backBtnNavigationHelper();
            this.showToastPopMessage(this.successTitle,this.successMsg,'success');
            this.showLoading = false;
        }).catch(error => {
            console.log('error=', error);
            this.showToastPopMessage(this.errorTitle,error,'error');
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
          this.typ = decodeURI(currentPageReference.state.typ);
          this.lng = decodeURI(currentPageReference.state.lng);
          this.isEnglish = (this.lng == 'English') ? true :  false;  
          this.rxBatch = this.selectedBatchId;
          this.rxGrade = this.selectedGrade;

          this.rxStudentId = decodeURI(currentPageReference.state.studentId);
          this.studentName = decodeURI(currentPageReference.state.stdName);

          if(this.selectedBatchId){
                getBatchCodeName({
                    batchId : this.selectedBatchId
                }).then(result => {
                    this.selectedBatchCode = result.Name;
                    this.selectedBatchNumber=result.Batch_Number__c;
                    // this.schoolName = result.School_Name__r.Name;        
                }).catch(error => {
                    console.log('error 123 = ', error);
                    if(this.isEnglish){
                        this.showToastPopMessage(this.errorTitle,error,'error')
                    }else{
                        this.showToastPopMessage(this.errorTitle,error,'error');
                    }
                });
            }
            if(this.isEnglish){
                this.title = 'Quiz- 2 Data';
                this.errorTitle = 'Error';
                this.successMsg ='Quiz 2 - Student data has been saved';
                this.successTitle = 'Success'
            }else{
                this.title = 'प्रश्नावली2 डेटा';
                this.errorTitle = 'गलती!';
                this.successMsg ='छात्र डेटा सहेजा गया है';
                this.successTitle = 'Success'
            }
       }
    }
    handleInputChangeStudent(event) {
        this.studentSearchText = event.detail.value.trim();
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
                if(this.isEnglish){
                    this.showToastPopMessage(this.errorTitle,'A batch is required to search for student','error');
                }else{
                    this.showToastPopMessage(this.errorTitle,'छात्र की खोज के लिए एक बैच की आवश्यकता है','error');
                }
                break;
            }

            if(!this.studentSearchText)
            {
                if(this.isEnglish){
                    this.studentSearchResult = 'Please enter Student here';
                }else{
                    this.studentSearchResult = 'कृपया यहां छात्र दर्ज करें';
                }
                //this.studentSearchResult = 'Please enter text here';
                this.studentDisplay = [];
                this.submittedStudentMapKeys = [];
                break;
            }
            else if(this.studentSearchText.length < 2) 
            {
                if(this.isEnglish){
                    this.studentSearchResult = 'Enter more than 1 character';
                }else{
                    this.studentSearchResult = '1 से अधिक वर्ण दर्ज करें';
                }
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
                    if(this.isEnglish){
                        this.studentSearchResult = 'Students(' + responseWrapper.batchTotalStudents + ')';
                    }else{
                        this.studentSearchResult = 'छात्र(' + responseWrapper.batchTotalStudents + ')';
                    }
                    this.studentDisplay = responseWrapper.gradeStudentList;
                }

                if(responseWrapper.submittedStudentMap !== undefined)
                {
                    this.submittedStudentMapKeys = Object.keys(responseWrapper.submittedStudentMap);
                }
                this.flag = 'searchStudent';
    
            }).catch(error => {
                let rxError = '';
                if(this.isEnglish){
                    this.rxError = 'Error while searching student';
                }else{
                    this.rxError = 'छात्र को खोजते समय त्रुटि';
                }
                if (Array.isArray(error.body)) {
                    rxError = error.body.map(e => e.message).join(', ');
                } else if (typeof error.body.message === 'string') {
                    rxError = error.body.message;
                }
                //console.log('Print error : ' + rxError);
                this.showToastPopMessage(this.errorTitle,this.rxError,'error')
              
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
                let errorString;
                if(this.isEnglish){
                    this.errorString = 'You have already filled the data for this student. If you think this is a mistake fill the support form';
                     this.showToastPopMessage('Error!',this.errorString,'error');
                }else{
                    this.errorString = 'आप इस छात्र का डेटा पहले ही भर चुके हैं. यदि आपको लगता है कि यह एक गलती है तो सहायता फ़ॉर्म भरें';
                    this.showToastPopMessage('गलती!',this.errorString,'error');
                }
                
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
                name: 'quiz2_summary_V2__c'
            },
            state:{
                fem : encodeURI(this.logedInFacilitatorEmail),
                sch : encodeURI(this.seletedSchoolName),
                grd : encodeURI(this.selectedGrade), 
                bid : encodeURI(this.selectedBatchId),
                acid : encodeURI(this.selectedSchoolAccountId),
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

    
    // get quiz22Options() {
    //     return [
    //         { label: 'Industry related to  working with nature, plants, and animals', value: 'A' },
    //         { label: 'Industry related to solving problems related to land ownership', value: 'B' },
    //         { label: 'Industry related studying the human body and treating human diseases', value: 'C' },
    //         { label: 'Industry related to making sure people live long and healthy lives', value: 'D' },
    //         { label: 'Multiple answers selected', value: '*' },
    //         { label: 'No Answer', value: 'NoAnswer' }
    //     ];
    // }
    // get quiz23Options() {
    //     return [
    //         { label: 'Education (Teacher, Architect, Chef)', value: 'A' },
    //         { label: 'Media and Entertainment (Actor, Photographer, Event Planner)', value: 'B' },
    //         { label: 'Healthcare (Plumber, Fashion Designer, Tour Guide)', value: 'C' },
    //         { label: 'Engineering & Trades (Beautician,Engineer,  Army)', value: 'D' },
    //         { label: 'Multiple answers selected', value: '*' },
    //         { label: 'No Answer', value: 'NoAnswer' }
    //     ];
    // }
    // get quiz24Options() {
    //     return [
    //         { label: 'Finance (Financial Analyst, Application Developer, Carpenter)', value: 'A' },
    //         { label: 'Industry Independent (Accountant, Office Administration, Beautician)', value: 'B' },
    //         { label: 'Wellness & Fitness (Nutritionist, Sportsperson, Coach)', value: 'C' },
    //         { label: 'Tourism & Hospitality (Tour Guide, Travel Agent, Hospital)', value: 'D' },
    //         { label: 'Multiple answers selected', value: '*' },
    //         { label: 'No Answer', value: 'NoAnswer' }
    //     ];
    // }
    // get quiz25Options() {
    //     return [
    //         { label: 'This tells which careers someone can and cannot take up', value: 'A' },
    //         { label: 'This helps plan for the career challenges someone might face', value: 'B' },
    //         { label: 'This tells what someone likes and is good at', value: 'C' },
    //         { label: 'This tells a list of different careers and their qualifications', value: 'D' },
    //         { label: 'Multiple answers selected', value: '*' },
    //         { label: 'No Answer', value: 'NoAnswer' }
    //     ];
    // }
}