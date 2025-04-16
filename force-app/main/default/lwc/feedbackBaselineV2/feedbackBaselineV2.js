import {LightningElement, api, wire, track} from 'lwc';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import SaveAllData from '@salesforce/apex/BaselineFeedbackController.SaveAllData';
import calculateForms from '@salesforce/apex/EndlineFuturePlanningController.calculateForms';
import getStudentRecord from '@salesforce/apex/BaselineFeedbackController.getStudentRecord';
import getAssesmentQuestion from '@salesforce/apex/AssesementQuestionController.getAssesmentQuestion';
import getStudentName from '@salesforce/apex/BaselineFeedbackController.getStudentName';
import getBaselineRecord from '@salesforce/apex/BaselineAssessmentController.getBaselineRecord';

export default class FeedbackBaselineV2 extends NavigationMixin(LightningElement) {
    lng;
    isEnglish;
    title = '';
    errorTitle = '';
    successTitle = '';
    successMsg = '';
    typ;

    selectedBatchNumber='';
    saveFlag = false;
    showForm = false;
    selectedBatchId = '';
    selectedGrade = '';
    logedInFacilitatorEmail = '';
    seletedSchoolName = '';
    selectedSchoolAccountId = '';
    selectedBatchCode='';
    studentId = '';
    showLoading = true;
    isShowModal=false;
    cdm1Id='';
    cdm2Id = '';
    cpId = '';
    csId = '';

    question_F1 = ''
    question_F2 = ''
    question_F3 = ''
    question_F4 = ''
    question_F5 = ''
    question_F6 = ''
    question_F7 = ''
    question_F8 = ''
    question_F9 = ''
    question_F10 = ''
    question_F11 = ''
    question_F12 = ''

    queF1Value = '';
    queF2Value = '';
    queF3Value = '';
    queF4Value = '';
    queF5Value = '';
    queF6Value = '';
    queF7Value = '';
    queF8Value = '';
    queF9Value = '';
    queF10Value = '';
    queF11Value = '';
    queF12Value = '';

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.selectedBatchId = decodeURI(currentPageReference.state.bid);
          this.selectedGrade = decodeURI(currentPageReference.state.grd);
          this.logedInFacilitatorEmail = decodeURI(currentPageReference.state.fem);
          this.seletedSchoolName = decodeURI(currentPageReference.state.sch);
          this.selectedSchoolAccountId = decodeURI(currentPageReference.state.acid); 
          this.studentId = decodeURI(currentPageReference.state.studentId);
          this.cdm1Id = decodeURI(currentPageReference.state.cdm1Id);
          this.cdm2Id = decodeURI(currentPageReference.state.cdm2Id);
          this.cpId = decodeURI(currentPageReference.state.cpId);
          this.csId = decodeURI(currentPageReference.state.csId);

            if(currentPageReference.state.studentName !== undefined){
                this.studentName = decodeURI(currentPageReference.state.studentName);
            }
          this.typ = decodeURI(currentPageReference.state.typ);
          this.lng = decodeURI(currentPageReference.state.lng);
          this.isEnglish = (this.lng == 'English') ? true : false;
          
            console.log('this.studentId = '+this.studentId);
            console.log('this.cdm1Id = '+this.cdm1Id);
            console.log('this.cpId = '+this.cpId);
            console.log('this.csId = '+this.csId);

          if(this.selectedBatchId){
                getBatchCodeName({
                    batchId : this.selectedBatchId
                }).then(result => {
                    this.selectedBatchCode = result.Name;
                    this.selectedBatchNumber = result.Batch_Number__c;
                    // this.schoolName = result.School_Name__r.Name;        
                }).catch(error => {
                    console.log('error 123 = ', error);
                    var err = error?.body?.message ? error?.body?.message : '';
                    this.showToastPopMessage(this.errorTitle,err , 'error');
                });
            }
            if(this.studentId){
                getStudentName({
                stuId : this.studentId
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
                this.title = 'Baseline Feedback Data';
                this.errorTitle = 'Error';
                this.successMsg ='Baseline Feedback - Student data has been saved';
                this.successTitle = 'Success'
            }else{
                this.title = 'बेसलाइन कार्यक्रम प्रतिक्रिया डेटा';
                this.errorTitle = 'गलती!';
                this.successMsg ='छात्र डेटा सहेजा गया है';
                this.successTitle = 'Success'
            }
        }
    }

    connectedCallback(){
        if(this.studentId != null){
            this.getAssesmentQuestionFunc();
            this.getStudentRecordFun();
            this.delayTimeOut05 = setTimeout(() => {
                this.showLoading = false;
            }, 1500);
        }

    }

    //This method is called to get all questions
    getAssesmentQuestionFunc(){
        getAssesmentQuestion({
            objectName : 'Future Plannings Endline',
            formType : 'Form V2',
            grade : ''
        }).then(result => {
            console.log('getAssesmentQuestion Result = '+JSON.stringify(result));
            if(result){
                this.assesmentQuestionAndLabel = result;

                let queF1 = this.getQuestionsAndOptionsForF(71);
                if (queF1) {
                    this.question_F1 = queF1.question;
                    this.queF1Options = queF1.options;
                }

                let queF2 = this.getQuestionsAndOptionsForF(72);
                if (queF2) {
                    this.question_F2 = queF2.question;
                    this.queF2Options = queF2.options;
                }

                let queF3 = this.getQuestionsAndOptionsForF(73);
                if (queF3) {
                    this.question_F3 = queF3.question;
                    this.queF3Options = queF3.options;
                }

                let queF4 = this.getQuestionsAndOptionsForF(74);
                if (queF4) {
                    this.question_F4 = queF4.question;
                    this.queF4Options = queF4.options;
                }

                let queF5 = this.getQuestionsAndOptionsForF(75);
                if (queF5) {
                    this.question_F5 = queF5.question;
                    this.queF5Options = queF5.options;
                }

                let queF6 = this.getQuestionsAndOptionsForF(76);
                if (queF6) {
                    this.question_F6 = queF6.question;
                    this.queF6Options = queF6.options;
                }

                let queF7 = this.getQuestionsAndOptionsForF(77);
                if (queF7) {
                    this.question_F7 = queF7.question;
                    this.queF7Options = queF7.options;
                }

                let queF8 = this.getQuestionsAndOptionsForF(78);
                if (queF8) {
                    this.question_F8 = queF8.question;
                    this.queF8Options = queF8.options;
                }

                let queF9 = this.getQuestionsAndOptionsForF(79);
                if (queF9) {
                    this.question_F9 = queF9.question;
                    this.queF9Options = queF9.options;
                }

                let queF10 = this.getQuestionsAndOptionsForF(80);
                if (queF10) {
                    this.question_F10 = queF10.question;
                    this.queF10Options = queF10.options;
                }

                let queF11 = this.getQuestionsAndOptionsForF(81);
                if (queF11) {
                    this.question_F11 = queF11.question;
                    this.queF11Options = queF11.options;
                }

                let queF12 = this.getQuestionsAndOptionsForF(82);
                if (queF12) {
                    this.question_F12 = queF12.question;
                    this.queF12Options = queF12.options;
                }

            }
            
        }).catch(error => {
            console.log('getAssesmentQuestion Error = ',error);
        });
    }

    getQuestionsAndOptionsForF(seqNumber){
        let que = this.assesmentQuestionAndLabel.find(question => question.Sequence_Number__c === seqNumber);
        let question = '';
        let options = [];
        if(que){
            question = ((this.lng === 'Hindi') ? que.Question_Label_Hindi__c :que.Question_Label_English__c);
            if(que.Assessment_Question_Options__r){
                let optionNames = ['1', '2', '3', '4', '5'];
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

    getStudentRecordFun(){
        getStudentRecord({
            studentId : this.studentId
        }).then(result => {
            if(result){
                this.showForm = true;
                this.showLoading = false;
                this.futuerPlanningRecordId = result.Id;

                this.queF1Value = result.F_1__c;
                this.queF2Value = result.F_2__c;
                this.queF3Value = result.F_3__c;
                this.queF4Value = result.F_4__c;
                this.queF5Value = result.F_5__c;
                this.queF6Value = result.F_6__c;
                this.queF7Value = result.F_7__c;
                this.queF8Value = result.F_8__c;
                this.queF9Value = result.F_9__c;
                this.queF10Value = result.F_10__c;
                this.queF11Value = result.F_11__c;
                this.queF12Value = result.F_12__c;
                // console.log('result = ',result);
                // console.log('result?.Student__r?.Name =',result.Student__r.name)
                // this.studentName = result?.Student__r?.Name;

                setTimeout(() => {
                    this.checkHandler('lightning-input.queF1', this.queF1Value);
                    this.checkHandler('lightning-input.queF2', this.queF2Value);
                    this.checkHandler('lightning-input.queF3', this.queF3Value);
                    this.checkHandler('lightning-input.queF4', this.queF4Value);
                    this.checkHandler('lightning-input.queF5', this.queF5Value);
                    this.checkHandler('lightning-input.queF6', this.queF6Value);
                    this.checkHandler('lightning-input.queF7', this.queF7Value);
                    this.checkHandler('lightning-input.queF8', this.queF8Value);
                    this.checkHandler('lightning-input.queF9', this.queF9Value);
                    this.checkHandler('lightning-input.queF10', this.queF10Value);
                    this.checkHandler('lightning-input.queF11', this.queF11Value);
                    this.checkHandler('lightning-input.queF12', this.queF12Value);
                }, 1500);
            }
        }).catch(error => {
            this.showForm = true;
            this.showLoading = false;
            console.log('error123=', error);
            this.showToastPopMessage(this.errorTitle,error,'error');

        });
    }

    feedbackHandler(event){
        debugger;
        let feedbackName = event.target.name;
        let value = event.target.value;
        console.log(value);
        if(feedbackName === 'queF1') {
            let isChecked = this.checkHandler('lightning-input.queF1', event.target.dataset.value);
            if (isChecked) this.queF1Value = event.target.dataset.value;
        } else if(feedbackName === 'queF2') {
            let isChecked = this.checkHandler('lightning-input.queF2', event.target.dataset.value);
            if (isChecked) this.queF2Value = event.target.dataset.value;
        } else if(feedbackName === 'queF3') {
            let isChecked = this.checkHandler('lightning-input.queF3', event.target.dataset.value);
            if (isChecked) this.queF3Value = event.target.dataset.value;
        } else if(feedbackName === 'queF4') {
            let isChecked = this.checkHandler('lightning-input.queF4', event.target.dataset.value);
            if (isChecked) this.queF4Value = event.target.dataset.value;
        } else if(feedbackName === 'queF5') {
            let isChecked = this.checkHandler('lightning-input.queF5', event.target.dataset.value);
            if (isChecked) this.queF5Value = event.target.dataset.value;
        } else if(feedbackName === 'queF6') {
            let isChecked = this.checkHandler('lightning-input.queF6', event.target.dataset.value);
            if (isChecked) this.queF6Value = event.target.dataset.value;
        } else if(feedbackName === 'queF7') {
            let isChecked = this.checkHandler('lightning-input.queF7', event.target.dataset.value);
            if (isChecked) this.queF7Value = event.target.dataset.value;
        } else if(feedbackName === 'queF8') {
            let isChecked = this.checkHandler('lightning-input.queF8', event.target.dataset.value);
            if (isChecked) this.queF8Value = event.target.dataset.value;
        } else if(feedbackName === 'queF9') {
            let isChecked = this.checkHandler('lightning-input.queF9', event.target.dataset.value);
            if (isChecked) this.queF9Value = event.target.dataset.value;
        } else if(feedbackName === 'queF10') {
            let isChecked = this.checkHandler('lightning-input.queF10', event.target.dataset.value);
            if (isChecked) this.queF10Value = event.target.dataset.value;
        } else if(feedbackName === 'queF11') {
            let isChecked = this.checkHandler('lightning-input.queF11', event.target.dataset.value);
            if (isChecked) this.queF11Value = event.target.dataset.value;
        } else if(feedbackName === 'queF12') {
            let isChecked = this.checkHandler('lightning-input.queF12', event.target.dataset.value);
            if (isChecked) this.queF12Value = event.target.dataset.value;
        }
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

    //Button Handler Functionalities :
    backBtnHandler(event){
        console.log('dd');
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'baseline_mpf_assesment_V2__c'
            },
            state:{
                fem : encodeURI(this.logedInFacilitatorEmail),
                sch : encodeURI(this.seletedSchoolName),
                grd : encodeURI(this.selectedGrade), 
                bid : encodeURI(this.selectedBatchId),
                acid : encodeURI(this.selectedSchoolAccountId),
                studentId : encodeURI(this.studentId),
                studentName : encodeURI(this.studentName),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng)
            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }

    async SubmitBtnHandler(){
        if(this.queF1Value && this.queF2Value && this.queF3Value && this.queF4Value && this.queF5Value && this.queF6Value && this.queF7Value && this.queF8Value && this.queF9Value && this.queF10Value && this.queF11Value && this.queF12Value){
            //await this.SaveData();
            getBaselineRecord({
                studentId : this.studentId,
                grade : this.selectedGrade,
                type : 'FEEDBACK',
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
                    this.backBtnHandler();
                }else{
                    this.SaveData();
                }
            }).catch(error => {
                console.log(error);
                
                this.showLoading = false;
                let rxError;
                if(this.isEnglish){
                    this.errorTitle = 'Baseline CDM2 Assessment';
                    this.rxError = 'Error while receiving student records';
                }else{
                    this.errorTitle = 'बेसलाइन सीडीएम2 मूल्यांकन';
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
            let unansweredDFeedbackQuestions = [];

            // Repeat the above checks for queF1Value to queF12Value
            if (!this.queF1Value) {
                unansweredDFeedbackQuestions.push('Q.1');
            }
            if (!this.queF2Value) {
                unansweredDFeedbackQuestions.push('Q.2');
            }
            if (!this.queF3Value) {
                unansweredDFeedbackQuestions.push('Q.3');
            }
            if (!this.queF4Value) {
                unansweredDFeedbackQuestions.push('Q.4');
            }
            if (!this.queF5Value) {
                unansweredDFeedbackQuestions.push('Q.5');
            }
            if (!this.queF6Value) {
                unansweredDFeedbackQuestions.push('Q.6');
            }
            if (!this.queF7Value) {
                unansweredDFeedbackQuestions.push('Q.7');
            }
            if (!this.queF8Value) {
                unansweredDFeedbackQuestions.push('Q.8');
            }
            if (!this.queF9Value) {
                unansweredDFeedbackQuestions.push('Q.9');
            }
            if (!this.queF10Value) {
                unansweredDFeedbackQuestions.push('Q.10');
            }
            if (!this.queF11Value) {
                unansweredDFeedbackQuestions.push('Q.11');
            }
            if (!this.queF12Value) {
                unansweredDFeedbackQuestions.push('Q.12');
            }

            var rxError = '';
             if(this.isEnglish){
                if(unansweredDFeedbackQuestions.length > 0 ){
                    rxError = 'Please choose answers for questions: ' + unansweredDFeedbackQuestions.join(', ') ;
                }
            }else{
                if(unansweredDFeedbackQuestions.length > 0 ){
                     rxError = 'कृपया प्रश्नों के उत्तर चुनें: ' + unansweredDFeedbackQuestions.join(', ') ;
                } 
            }
             this.showToastPopMessage(this.errorTitle,rxError , 'error');
            // this.showToastPopMessage('Please fill all the mandatory(*) fields','error');
        }
    }

    SaveData(){
        this.isLoading = true;
        console.log('dddsss=',this.que18_1Value);
        var formType = {
            'lng' : this.lng, 
            'typ' : (this.typ == 'v2' || this.typ == 'Form V2') ? 'Form V2' : 'Form V1'
        };
        SaveAllData({
            studentId : this.studentId,  
            F1 : this.queF1Value,
            F2 : this.queF2Value,
            F3 : this.queF3Value,
            F4 : this.queF4Value,
            F5 : this.queF5Value,
            F6 : this.queF6Value,
            F7 : this.queF7Value,
            F8 : this.queF8Value,
            F9 : this.queF9Value,
            F10 : this.queF10Value,
            F11 : this.queF11Value,
            F12 :  this.queF12Value,
            saveFlag : true, //this.saveFlag,
            grade : this.selectedGrade,
            formType : JSON.stringify(formType),
            recordType:'Baseline'
        }).then(result => {
            console.log('result = ',result)
            this.futuerPlanningRecordId = result;
            //this.runCalculate();
            const event = new ShowToastEvent({
                title: this.successTitle,
                message: this.successMsg,
                variant: 'success'
            });                
            this.dispatchEvent(event);
            this.backBtnHandler();
        }).catch(error => {
            console.log('error=', error);
            var err = error?.body?.message ? error?.body?.message : '';
            this.showToastPopMessage(this.errorTitle,rxError , 'error');
            this.isLoading=false;
        });
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