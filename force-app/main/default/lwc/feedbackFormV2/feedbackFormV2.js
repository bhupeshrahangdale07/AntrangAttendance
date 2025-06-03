import { LightningElement,track, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import searchStudentRecords from '@salesforce/apex/midProgramFeedbackController.searchStudentRecords';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import saveData from '@salesforce/apex/midProgramFeedbackController.saveData';
import getRecordApt from '@salesforce/apex/midProgramFeedbackController.getRecordApt';
import getAssesmentQuestion from '@salesforce/apex/AssesementQuestionController.getAssesmentQuestion';
import getStudentName from '@salesforce/apex/midProgramFeedbackController.getStudentName';
import getMidProgramFeedbackRecord from '@salesforce/apex/midProgramFeedbackController.getMidProgramFeedbackRecord';


export default class FeedbackFormV2 extends NavigationMixin(LightningElement) {
    title = '';
    errorTitle = '';
    successTitle = '';
    successMsg = '';
    lng;
    typ;
    isEnglish;
    errorTitle;
    cmpTitle;
    yesLabel;
    noLabel;
    showForm = true;
    selectedBatchId = '';
    selectedBatchNumber='';
    selectedGrade = '';
    logedInFacilitatorEmail = '';
    seletedSchoolName = '';
    selectedSchoolAccountId = '';
    selectedBatchCode='';
    studentName='';
    studentSearchComponentLabel;
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

    rxStudentId;
    
    submitBtnHandler(event){
        this.showLoading = true;
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
            //this.saveData();
            getMidProgramFeedbackRecord({
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
                    this.backBtnNavigationHelper();
                }else{
                    this.saveData(); 
                }
            }).catch(error => {
                console.log(error);
                
                this.showLoading = false;
                let rxError;
                if(this.isEnglish){
                    this.errorTitle = 'Mid Program Feedback';
                    this.rxError = 'Error while receiving student records';
                }else{
                    this.errorTitle = 'मध्य कार्यक्रम प्रतिक्रिया';
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
            
        }else{
            let queNo = '';
            if(this.feedback1Value == '' || this.feedback1Value == null)
                queNo += ', ' + 'Q1';
            if(this.feedback2Value == '' || this.feedback2Value == null)
                queNo += ', ' + 'Q2';
            if(this.feedback3Value == '' || this.feedback3Value == null)
                queNo += ', ' + 'Q3';
            if(this.feedback4Value == '' || this.feedback4Value == null)
                queNo += ', ' + 'Q4';
            if(this.feedback5Value == '' || this.feedback5Value == null)
                queNo += ', ' + 'Q5';
            if(this.feedback6Value == '' || this.feedback6Value == null)
                queNo += ', ' + 'Q6';
            if(this.feedback7Value == '' || this.feedback7Value == null)
                queNo += ', ' + 'Q7';
            queNo = queNo.trim();
            if (queNo.startsWith(",")) {
                queNo = queNo.substring(1);
            }
            this.showLoading = false;
            this.saveFlag = false;
            if(this.isEnglish){
                //this.showToastPopMessage(this.errorTitle,'Please answer all the mandatory(*) question(s) : ' + queNo,'error');
                this.showToastPopMessage(this.errorTitle,'Please choose answers for questions: ' + queNo,'error');
            }else{
                this.showToastPopMessage(this.errorTitle,'कृपया सभी अनिवार्य(*) प्रश्नों के उत्तर दें : '+ queNo,'error');
            }
        }
    }
    connectedCallback(){
        this.delayTimeOut05 = setTimeout(() => {
            this.showLoading=false;
        }, 800);
        if(this.isEnglish){
            this.studentSearchResult = 'Please enter Student here';
            this.yesLabel = 'Yes';
            this.noLabel = 'No';
            this.studentSearchComponentLabel = 'Type the first 4 letters of the student name and wait for the drop down to select the student';
            //this.errorTitle = 'Error!';
        }else{
            this.studentSearchResult = 'कृपया यहां छात्र दर्ज करें';
            this.yesLabel = 'हाँ';
            this.noLabel = 'नहीं';
            this.studentSearchComponentLabel = 'छात्र के नाम के पहले 4 अक्षर टाइप करें और छात्र का चयन करने के लिए ड्रॉप डाउन की प्रतीक्षा करें';
            //this.errorTitle = 'गलती!';
        }
        this.getAssesmentQuestionFunc();
    }
    assesmentQuestionAndLabel=[];
    question01 = '';
    question02 = '';
    question03 = '';
    question04 = '';
    question05 = '';
    question06 = '';
    question07 = '';
    q01_Options = [];
    q02_Options = [];
    q03_Options = [];
    q04_Options = [];
    q05_Options = [];
    q06_Options = [];
    q07_Options = [];
    //This method is called to get all questions
    getAssesmentQuestionFunc(){
        getAssesmentQuestion({
            objectName : 'Self Awareness & Feedback',
            formType : 'Form V2',
            grade : ''
        }).then(result => {
            console.log('getAssesmentQuestion Result = '+JSON.stringify(result));
            if(result){
                this.assesmentQuestionAndLabel = result;
                let que1 = this.getQuestionsAndOptions(1);
                if(que1){
                    this.question01 = que1.question;
                    this.q01_Options = que1.options;
                }
                let que2 = this.getQuestionsAndOptions(2);
                if(que2){
                    this.question02 = que2.question;
                    this.q02_Options = que2.options;
                }
                let que3 = this.getQuestionsAndOptions(3);
                if(que3){
                    this.question03 = que3.question;
                    this.q03_Options = que3.options;
                }
                let que4 = this.getQuestionsAndOptions(4);
                if(que4){
                    this.question04 = que4.question;
                    this.q04_Options = que4.options;
                }
                let que5 = this.getQuestionsAndOptions(5);
                if(que5){
                    this.question05 = que5.question;
                    this.q05_Options = que5.options;
                }
                let que6 = this.getQuestionsAndOptions(6);
                if(que6){
                    this.question06 = que6.question;
                    this.q06_Options = que6.options;
                }
                let que7 = this.getQuestionsAndOptions(7);
                if(que7){
                    this.question07 = que7.question;
                    this.q07_Options = que7.options;
                }
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
                let i=1;
                for (let opt of que.Assessment_Question_Options__r) {
                    let optionValue =  (this.lng === 'Hindi') ? opt.Option_Label_Hindi__c :opt.Option_Label_English__c;
                    let optionName = (opt.Option_Label_English__c === 'No Answer') ? 'NoAnswer' : (opt.Option_Label_English__c === 'Multiple answers selected') ? '*' :i ;
                    let option = {label:optionValue, value:optionName }
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
                name: 'Mid_Program_Feedback_V2__c'
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
            studentId : this.rxStudentId,
            batchId : this.selectedBatchId
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
                //this.studentName = result.Student__r.Name;
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
        // clearTimeout(this.timeoutId);
        // this.timeoutId = setTimeout(this.saveData.bind(this,false), 5000); 
    }
    saveData(){
        saveData({
            batchId : this.selectedBatchId,
            studentId : this.rxStudentId,
            fb1 : this.feedback1Value,
            fb2 : this.feedback2Value,
            fb3 : this.feedback3Value,
            fb4 : this.feedback4Value,
            fb5 : this.feedback5Value,
            fb6 : this.feedback6Value,
            fb7 : this.feedback7Value,
            saveFlag : this.saveFlag,
            grade : this.selectedGrade,
            lng:this.lng,
            typ:(this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
        }).then(result => {
           console.log('res = ',result);
           if(result){
                this.showToastPopMessage(this.successTitle,this.successMsg,'success');
                setTimeout(() => {
                    this.backBtnNavigationHelper();
                }, 1000);
                this.showLoading = false;
           }
        }).catch(error => {
            console.log('error=', error);
            this.showToastPopMessage(this.errorTitle,error,'error')
             this.showLoading = false;
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
          this.isEnglish = (this.lng == 'English') ? true : false;
          this.rxBatch = this.selectedBatchId;
          this.rxGrade = this.selectedGrade;

          this.rxStudentId = currentPageReference.state.studentId;

          if(this.rxStudentId && this.rxStudentId !== ''){
              this.getRecordAptFun();
          }

          if(this.selectedBatchId){
                getBatchCodeName({
                    batchId : this.selectedBatchId
                }).then(result => {
                    this.selectedBatchCode = result.Name;
                    this.selectedBatchNumber= result.Batch_Number__c;
                    // this.schoolName = result.School_Name__r.Name;        
                }).catch(error => {
                    console.log('error 123 = ', error);
                    this.showToastPopMessage(this.errorTitle,error,'error')
                });
            }
            if(this.rxStudentId){
                getStudentName({
                    stuId : this.rxStudentId
                }).then(result => {
                    if(result){
                        this.studentName = result.Name;
                    }
                }).catch(error => {
                    this.showLoading = false;
                    console.log('getStudentName error: ', error);
                });
            }
            if(this.isEnglish){
                this.title = 'Mid Program Feedback';
                this.errorTitle = 'Error';
                this.successMsg ='Mid Program Feedback - Student data has been saved';
                this.successTitle = 'Success'
            }else{
                this.title = 'मध्य कार्यक्रम प्रतिक्रिया';
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
                //this.studentSearchResult = 'Please enter text here';
                if(this.isEnglish){
                    this.studentSearchResult = 'Please enter Student here';
                }else{
                    this.studentSearchResult = 'कृपया यहां छात्र दर्ज करें';
                }
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
                let rxError;
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
                }else{
                    this.errorString = 'आप इस छात्र का डेटा पहले ही भर चुके हैं. यदि आपको लगता है कि यह एक गलती है तो सहायता फ़ॉर्म भरें';
                }
                this.showToastPopMessage(this.errorTitle,this.errorString,'error');
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
                name: 'Mid_Program_Feedback_V2__c'
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

}