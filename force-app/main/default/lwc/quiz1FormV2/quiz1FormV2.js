import {LightningElement, api, wire, track} from 'lwc';
//import {getRecord} from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import getApexRecord from '@salesforce/apex/quiz1Grade10.getApexRecord';
import saveSingle from '@salesforce/apex/quiz1Grade10.saveSingle';
import saveAllQA from '@salesforce/apex/Quiz1Controller.saveAllQA';
import submitAndCalculate from '@salesforce/apex/Quiz1Controller.submitAndCalculate';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import getAssesmentQuestion from '@salesforce/apex/AssesementQuestionController.getAssesmentQuestion';
import getStudentName from '@salesforce/apex/Quiz1Controller.getStudentName';
import getQuiz1Record from '@salesforce/apex/quiz1Summary.getQuiz1Record';

export default class Quiz1FormV2 extends NavigationMixin(LightningElement) {
    isEnglish;
    lng;
    typ;
    title = '';
    errorTitle = '';
    successTitle = '';
    successMsg = '';
    showForm;
    showLoading = true;
    getAssesmentQuestion=[];
    instructions = 'This form is used to fill the Quiz Data for Students. Make sure to fill the answers as selected by the student';
    questionNo = '';
    optionsSelected = [];
    q1ans = '';
    q2ans = '';
    q3ans = '';
    q4ans = '';
    q5ans = '';
    //=======================================================//
    batchNumber='';
    fem = null;
    sch = null;
    grd = null;
    bid = null;
    acid = null;
    //=======================================================//
    flag = '';
    //=======================================================//
    rxStudentId = null;
    studentName = null;
    studentBarcode = null;
    safRecordId = null;
    //=======================================================//
    delay = 5000;   //Delay = 5 sec
    delayTimeOut01;
    delayTimeOut02;
    delayTimeOut03;
    delayTimeOut04;
    delayTimeOut05;
    //=======================================================//
    isShowModal = false;
    //=======================================================//

    @wire(CurrentPageReference)
    getCurrentPageReference(currentPageReference) {
        if(currentPageReference) 
        {
            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            this.fem = decodeURI(rxCurrentPageReference.state.fem);
            this.sch = decodeURI(rxCurrentPageReference.state.sch);
            this.grd = decodeURI(rxCurrentPageReference.state.grd);
            this.bid = decodeURI(rxCurrentPageReference.state.bid);
            this.acid = decodeURI(rxCurrentPageReference.state.acid);
            this.rxStudentId = decodeURI(rxCurrentPageReference.state.std);
            this.typ = decodeURI(rxCurrentPageReference.state.typ);
            this.lng = decodeURI(rxCurrentPageReference.state.lng);
            this.isEnglish = (this.lng == 'English') ? true : false;
            this.rxStudentId = currentPageReference.state.studentId;

            if(this.bid){
                getBatchCodeName({
                    batchId : decodeURI(rxCurrentPageReference.state.bid)
                }).then(result => {
                    this.batchCode = result.Name;
                    this.batchNumber = result.Batch_Number__c;
                }).catch(error => {
                    console.log('getBatchCodeName error 123 = ', error);
                    this.showToastPopMessage(this.errorTitle,'Error occured in Batch Code Questions','error');
                });
            }
            if(this.rxStudentId){
                getStudentName({
                    studId : this.rxStudentId
                }).then(result => {
                    console.log('$$$ getStudentName: ', result);
                    this.studentName = result.Name;
                    this.studentBarcode = result.Bar_Code__c;
                }).catch(error => {
                    console.log('getStudentName error 123 = ', error);
                    this.showToastPopMessage(this.errorTitle,'Error occured in Student Name','error');

                });
            }
            if(this.isEnglish){
                this.title = 'Quiz 1 Data';
                this.errorTitle = 'Error';
                this.successMsg ='Quiz 1 - Student data has been saved';
                this.successTitle = 'Success'
            }else{
                this.title = 'Quiz 1 Data';
                this.errorTitle = 'गलती!';
                this.successMsg ='छात्र डेटा सहेजा गया है';
                this.successTitle = 'Success'
            }
        }
        this.flag = 'getCurrentPageReference';
    }

    //Standard JavaScript connectedCallback() method called on page load
    connectedCallback() {
        this.flag = 'connectedCallback';
        this.getAssesmentQuestionFunc();
        this.showLoading = false;
    }

    //This method is called after the triggered event is handled completely
    /*renderedCallback(){
        if(this.submitStatus){
            this.backNavigateToInternalPage();
        }
        this.flag = 'renderedCallback';
        console.log('this.flag : ' + this.flag);
    }*/

    //This method is called to get all questions
    getAssesmentQuestionFunc(){
        console.log('$$$ In getAssesmentQuestionFunc');
        if(this.grd){
            getAssesmentQuestion({
            objectName : 'Quiz - 1',
            formType : 'Form V2',
            grade : this.grd
            }).then(result => {
                this.showForm = true;
                this.getAssesmentQuestion = result;
            }).catch(error => {
                console.log('getAssesmentQuestion Error = ',error);
                this.showToastPopMessage(this.errorTitle,'Error occured in Assessment Questions','error');
            });
        }
    }

    handleQuestionOptions(event){
        debugger;
        this.questionNo = event.target.name;
        console.log('$$$ questionNo: ', this.questionNo);
        if(this.questionNo == '1'){
            //console.log('$$$ questionNo: ', this.questionNo);
            this.optionsSelected = event.target.dataset.value;
            //console.log('$$$ optionsSelected: ', this.optionsSelected);
            this.handleQue1(this.optionsSelected);
        }else if(this.questionNo == '2'){
            this.optionsSelected = event.target.dataset.value;
            this.handleQue2(this.optionsSelected);
        }else if(this.questionNo == '3'){
            this.optionsSelected = event.target.dataset.value;
            this.handleQue3(this.optionsSelected);
        }else if(this.questionNo == '4'){
            this.optionsSelected = event.target.dataset.value;
            this.handleQue4(this.optionsSelected);
        }else if(this.questionNo == '5'){
            this.optionsSelected = event.target.dataset.value;
            this.handleQue5(this.optionsSelected);
        }
        
        const groupId = event.target.dataset.groupId;
        const selectedValue = event.target.value;

        const checkboxes = this.template.querySelectorAll(`.checkbox-group[data-group-id="${groupId}"]`);
        checkboxes.forEach(checkbox => {
            checkbox.checked = checkbox.value === selectedValue;
        });
    }

    handleQue1(Que1OptionsSelected){
        this.q1ans = Que1OptionsSelected;
        console.log('$$$ Final Options selected for Q1: ', this.q1ans);
    }
    handleQue2(Que2OptionsSelected){
        this.q2ans = Que2OptionsSelected;
        console.log('$$$ Final Options selected for Q2: ', this.q2ans);
    }
    handleQue3(Que3OptionsSelected){
        this.q3ans = Que3OptionsSelected;
        console.log('$$$ Final Options selected for Q3: ', this.q3ans);
    }
    handleQue4(Que4OptionsSelected){
        this.q4ans = Que4OptionsSelected;
        console.log('$$$ Final Options selected for Q4: ', this.q4ans);
    }
    handleQue5(Que5OptionsSelected){
        this.q5ans = Que5OptionsSelected;
        console.log('$$$ Final Options selected for Q5: ', this.q5ans);
    }

    handleSubmitButton(event){
        debugger;
        console.log('$$$ In handleSubmitButton');
        let eventButton = event.target.dataset.name;
        if(eventButton === 'submitButton'){
            do{
                let returnStr = this.allQuestionsAttempted();
                if(returnStr != 'All available')
                {
                    this.showToastPopMessage(this.errorTitle,returnStr,'error');
                    break;
                }
                //this.saveAll();

                getQuiz1Record({
                    studentId : this.rxStudentId,
                    grade : this.grd,
                    batchId : this.bid,
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
                        this.backNavigateToInternalPage();
                    }else{
                        this.saveAll(); 
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

                //this.showToastPopMessage(this.title,'Student Data is saved','success');
                // delay of 1second is added so that record changes done by "this.saveAll();" appears in "this.submit();"
                /*setTimeout(() => {
                    this.submit();
                }, 1000); */    
                //this.backNavigateToInternalPage();  
                // For above navigation to be successful, it is called from renderedCallback()    
            }while(false);
        }
        this.flag = 'handleSubmitButton';
        console.log('this.flag : ' + this.flag);
    }

    allQuestionsAttempted(){
        debugger;
        console.log('$$$ In allQuestionsAttempted');
        let rxError = '';
        //===============================================//
        let foundans01 = false;
        /*for(let key in this.q01_Options){
            if(this.q01_Options[key].answer)
            {
                foundans01 = true;
                break;
            }
        }
        if(!foundans01)
        {
            if(rxError !== '')rxError += ', ' + 'Q1';
            else rxError = 'Q1';
        }*/
        /*if(this.q1ans.length > 0){
            foundans01 = true;
            //break;
        }else{
            if(rxError !== ''){
                rxError += ', ' + 'Q1';
            }else{
                rxError = 'Q1';
            }
        }*/
        if(this.q1ans != null && this.q1ans != ''){
            foundans01 = true;
            //break;
        }else{
            if(rxError !== ''){
                rxError += ', ' + 'Q1';
            }else{
                rxError = 'Q1';
            }
        }

        //===============================================//
        let foundans02 = false;
        if(this.q2ans != null && this.q2ans != ''){
            foundans02 = true;
            //break;
        }else{
            if(rxError !== ''){
                rxError += ', ' + 'Q2';
            }else{
                rxError = 'Q2';
            }
        }
        //===============================================//
        let foundans03 = false;
        if(this.q3ans != null && this.q3ans != ''){
            foundans03 = true;
            //break;
        }else{
            if(rxError !== ''){
                rxError += ', ' + 'Q3';
            }else{
                rxError = 'Q3';
            }
        }
        //===============================================//
        let foundans04 = false;
        if(this.q4ans != null && this.q4ans != ''){
            foundans04 = true;
            //break;
        }else{
            if(rxError !== ''){
                rxError += ', ' + 'Q4';
            }else{
                rxError = 'Q4';
            }
        }
        //===============================================//
        let foundans05 = false;
        if(this.q5ans != null && this.q5ans != ''){
            foundans05 = true;
            //break;
        }else{
            if(rxError !== ''){
                rxError += ', ' + 'Q5';
            }else{
                rxError = 'Q5';
            }
        }
        //===============================================//
        if(foundans01 && foundans02 && foundans03 && foundans04 && foundans05){
            return 'All available';
        }
        return ('Please choose answers for questions: ' + rxError);
    }
    
    saveAll(){
        debugger;
        console.log('$$$ In saveAll');
        //this.restrictIndividualUpdate();
        //===================================================================================//
        //let q01Answer = {};
        /*if(this.q1ans.length >0){
            this.q1ans.sort();
            console.log('$$$ this.q1ans: ', this.q1ans);
            q01Answer.answer = this.q1ans;
            console.log('$$$ q01Answer: ', q01Answer);
        }else{
            q01Answer = null;
        }*/
        /*if(this.q1ans != null && this.q1ans != undefined){
            q01Answer.answer = this.q1ans;
            console.log('$$$ q01Answer: ', q01Answer);
        }else{
            q01Answer = null;
        }
        //===================================================================================//
        let q02Answer = {};
        if(this.q2ans != null && this.q2ans != undefined){
            q02Answer.answer = this.q2ans;
        }else{
            q02Answer = null;
        }
        //===================================================================================//
        let q03Answer = {};
        if(this.q3ans != null && this.q3ans != undefined){
            q03Answer.answer = this.q3ans;
        }else{
            q03Answer = null;
        }
        //===================================================================================//
        let q04Answer = {};
        if(this.q4ans != null && this.q4ans != undefined){
            q04Answer.answer = this.q4ans;
        }else{
            q04Answer = null;
        }
        //===================================================================================//
        let q05Answer = {};
        if(this.q5ans != null && this.q5ans != undefined){
            q05Answer.answer = this.q5ans;
        }else{
            q05Answer = null;
        }*/
        //===================================================================================//
        if(this.q1ans != null && this.q1ans != '' && this.q2ans != null && this.q2ans != '' && this.q3ans != null && this.q3ans != '' && 
           this.q4ans != null && this.q4ans != '' && this.q5ans != null && this.q5ans != ''){
            this.showLoading = true;   //Turn ON the spinner
            debugger;
            saveAllQA({
                studentId : this.rxStudentId,
                q11:this.q1ans,
                q12:this.q2ans,
                q13:this.q3ans,
                q14:this.q4ans,
                q15:this.q5ans,
                grade : this.grd,
                lng : this.lng,
                typ : (this.typ == 'v2' || this.typ == 'Form V2') ? 'Form V2' : 'Form V1',
            }).then(result => {
                debugger;
                console.log('$$$ saveAllQA: ', result);
                this.showToastPopMessage(this.successTitle,this.successMsg,'success');
                this.backNavigateToInternalPage();
                this.showLoading = false;   //Turn OFF the spinner
                //===========================================================//
                /*
                const event = new ShowToastEvent({
                    title: 'Quiz1',
                    message: 'All answers upsert successful',
                    variant: 'success'
                });                
                this.dispatchEvent(event);
                */
            }).catch(error => {
                this.showLoading = false;   //Turn OFF the spinner
                let rxError = 'Error while upserting all answers';

                if (Array.isArray(error.body)) {
                    rxError = error.body.map(e => e.message).join(', ');
                } else if (typeof error.body.message === 'string') {
                    rxError = error.body.message;
                }
                //console.log('Print error : ' + rxError);

                const event = new ShowToastEvent({
                    title : this,errorTitle,
                    message : rxError,
                    variant : 'error'
                });
                this.dispatchEvent(event);
            });
        }
        //===================================================================================//
        this.flag = 'saveAllQA';
        console.log('this.flag : ' + this.flag);
    }

    

    showToastPopMessage(title,messageParam,variantParam){
        const evt = new ShowToastEvent({
            title: title,
            message:messageParam,
            variant: variantParam,
        });
        this.dispatchEvent(evt);
    }

    yesBackBtnHandler(){
        this.backNavigateToInternalPage();

        this.flag = 'yesBackBtnHandler';
        console.log('this.flag : ' + this.flag);
    }

    noBackBtnHandler(){
        this.isShowModal = false;

        this.flag = 'noBackBtnHandler';
        console.log('this.flag : ' + this.flag);
    }

    handleBackButton(event){
        let eventButton = event.target.dataset.name;

        if(eventButton === 'backButton')
        {
            //this.backNavigateToInternalPage();
            this.isShowModal = true;
        }

        this.flag = 'handleBackButton';
        console.log('this.flag : ' + this.flag);
    }

    backNavigateToInternalPage() {
        // Use the basePath from the Summer '20 module to construct the URL
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Quiz_1_Summary_V2__c'
            },
            state: {
                fem : encodeURI(this.fem),
                sch : encodeURI(this.sch),
                grd : encodeURI(this.grd),
                bid : encodeURI(this.bid),
                acid : encodeURI(this.acid),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng) 
            }
        });
    }

    //====================Not In Use=========================
    restrictIndividualUpdate(){
        if (this.delayTimeOut01) {
            window.clearTimeout(this.delayTimeOut01);
        }

        if (this.delayTimeOut02) {
            window.clearTimeout(this.delayTimeOut02);
        }

        if (this.delayTimeOut03) {
            window.clearTimeout(this.delayTimeOut03);
        }

        if (this.delayTimeOut04) {
            window.clearTimeout(this.delayTimeOut04);
        }

        if (this.delayTimeOut05) {
            window.clearTimeout(this.delayTimeOut05);
        }
    }

    reInitializeRecordSAF(){
        getApexRecord({
            studentId : this.rxStudentId,
            grade : this.grd
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            const singleRecordWrapper = JSON.parse(JSON.stringify(result));
            //===========================================================//
            const record = singleRecordWrapper.apexRecord;
            
            if(record.Grade10_Quiz1_Submitted__c)this.freeze = true;
            else this.freeze = false;

            //Place init for question01 here
            this.initAnswer01 = record.Quiz_1_1__c;
            //Place init for question02 here
            this.initAnswer02 = record.Quiz_1_2__c;
            //Place init for question03 here
            this.initAnswer03 = record.Quiz_1_3__c;
            //Place init for question04 here
            this.initAnswer04 = record.Quiz_1_4__c;
            //Place init for question05 here
            this.initAnswer05 = record.Quiz_1_5__c;
            //===========================================================//
            this.flag = 'reInitializeRecordSAF';
            console.log('this.flag : ' + this.flag);
        }).catch(error => {
            let rxError = 'Error while recieving record fields: Quiz1';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : this,errorTitle,
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    submit(){   
        if(this.safRecordId == null){
            confirm('Please save the record before submit');
            return;
        }

        this.showLoading = true;   //Turn ON the spinner
        submitAndCalculate({
            recordIdSAF : this.safRecordId
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            if(result === 'success')
            {
                //this.reInitializeRecordSAF();
                this.submitStatus = true;
            }           
            this.showLoading = false;   //Turn OFF the spinner
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Quiz1',
                message: 'Record submit successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */
        }).catch(error => {
            this.showLoading = false;   //Turn OFF the spinner
            let rxError = 'Error while submitting the record';
            console.log('error.body.message = ',error.body.message)
            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : this,errorTitle,
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });

        this.flag = 'submit';
        console.log('this.flag : ' + this.flag);
    }
}