import {LightningElement, api, wire, track} from 'lwc';
//import {getRecord} from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import getApexRecord from '@salesforce/apex/quiz1Grade9.getApexRecord';
import saveSingle from '@salesforce/apex/quiz1Grade9.saveSingle';
import saveAllQA from '@salesforce/apex/quiz1Grade9.saveAllQA';
import submitAndCalculate from '@salesforce/apex/quiz1Grade9.submitAndCalculate';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import getAssesmentQuestion from '@salesforce/apex/AssesementQuestionController.getAssesmentQuestion';

export default class Quiz1Grade9V2 extends NavigationMixin(LightningElement) {
    isEnglish;
    lng;
    yesLabel;
    noLabel;
    cmpTitle;
    errorTitle;
    typ;
    //=======================================================//
    submitStatus = false;
    batchNumber='';
    //=======================================================//
    fem = null;
    sch = null;
    grd = null;
    bid = null;
    acid = null;
    //=======================================================//
    flag = '';
    antarangImage = logo_01;
    isLoading = false;
    //=======================================================//
    rxStudentId = null;
    studentName = null;
    studentBarcode = null;
    @track freeze = true;
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
    question01 = '';
    initAnswer01 = '';
    @track q01_Options = [];
    //=======================================================//
    question02 = '';
    initAnswer02 = '';
    @track q02_Options = [];
    //=======================================================//
    question03 = '';
    initAnswer03 = '';
    @track q03_Options = [];
    //=======================================================//
    question04 = '';
    initAnswer04 = '';
    @track q04_Options = [];
    //=======================================================//
    question05 = '';
    initAnswer05 = '';
    @track q05_Options = [];
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
            getBatchCodeName({
                batchId : decodeURI(rxCurrentPageReference.state.bid)
            }).then(result => {
                this.batchCode = result.Name;
                this.batchNumber = result.Batch_Number__c;
            }).catch(error => {
                console.log('error 123 = ', error);
            });
        }

        this.flag = 'getCurrentPageReference';
        console.log('this.flag : ' + this.flag);
    }
    assesmentQuestionAndLabel = [];
    //This method is called to get all questions
    getAssesmentQuestionFunc(){
        getAssesmentQuestion({
            objectName : 'Quiz - 1',
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
                this.getApexRecordSAF();
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
                    let option = {optionName:optionName, answer: false,optionValue:optionValue }
                    options.push(option);
                    i++;
                }
            }
        }
        return {question,options};
    }
    //Standard JavaScript connectedCallback() method called on page load
    connectedCallback() 
    {
        this.isLoading =  true;
        if(this.isEnglish){
            this.yesLabel = 'Yes';
            this.noLabel = 'No';
            this.cmpTitle = 'Quiz1-Grade 9';
            this.errorTitle = 'Quiz1-Grade 9';
        }else{
            this.yesLabel = 'हाँ';
            this.noLabel = 'नहीं';
            this.cmpTitle = 'प्रश्नावली1-ग्रेड 9';
            this.errorTitle = 'प्रश्नावली1-ग्रेड 9';
        }
        this.getAssesmentQuestionFunc();
        //this.getApexRecordSAF();
        this.flag = 'connectedCallback';
        console.log('this.flag : ' + this.flag);
    }

    //This method is called after the triggered event is handled completely
    renderedCallback()
    {
        if(this.submitStatus)
        {
            this.backNavigateToInternalPage();
        }

        this.flag = 'renderedCallback';
        console.log('this.flag : ' + this.flag);
    }

    getApexRecordSAF(){
        this.isLoading = true;     //Turn ON the spinner
        getApexRecord({
            studentId : this.rxStudentId,
            grade : this.grd
        }).then(result => {
            console.log('result getApexRecordSAF: ' + JSON.stringify(result));
            //===========================================================//
            const singleRecordWrapper = JSON.parse(JSON.stringify(result));
            if(singleRecordWrapper.studentBarcode !== undefined)
            {
                this.studentBarcode = singleRecordWrapper.studentBarcode;
            }
            else this.studentBarcode = null;

            if(singleRecordWrapper.studentName !== undefined)this.studentName = singleRecordWrapper.studentName;
            //if(singleRecordWrapper.studentGrade !== undefined)this.studentGrade = singleRecordWrapper.studentGrade;
            //===========================================================//
            do{
                if(singleRecordWrapper.apexRecord === undefined || 
                    singleRecordWrapper.apexRecord === null)
                {
                    //console.log('SAF record does not exist');
                    this.freeze = false;
                    this.isLoading = false;
                    break;
                }

                const record = singleRecordWrapper.apexRecord;

                if(record.Grade9_Quiz1_Submitted__c)this.freeze = true;
                else this.freeze = false;

                this.safRecordId = record.Id;

                //Place init for question01 here
                this.initAnswer01 = record.Quiz_1_1__c;

                let foundAns01 = false;
                for(let key in this.q01_Options){
                    if(this.q01_Options[key].optionName === record.Quiz_1_1__c)
                    {
                        this.q01_Options[key].answer = true;
                        foundAns01 = true;
                    }
                }

                if(!foundAns01)
                {
                    if(record.Grade9_Quiz1_Submitted__c !== undefined && record.Grade9_Quiz1_Submitted__c)
                    {
                        for(let key in this.q01_Options){
                            if(this.q01_Options[key].optionName === 'nil')
                            {
                                this.q01_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                }
                //Place init for question02 here
                this.initAnswer02 = record.Quiz_1_2__c;

                let foundAns02 = false;
                for(let key in this.q02_Options){
                    if(this.q02_Options[key].optionName === record.Quiz_1_2__c)
                    {
                        this.q02_Options[key].answer = true;
                        foundAns02 = true;
                    }
                }

                if(!foundAns02)
                {
                    if(record.Grade9_Quiz1_Submitted__c !== undefined && record.Grade9_Quiz1_Submitted__c)
                    {
                        for(let key in this.q02_Options){
                            if(this.q02_Options[key].optionName === 'nil')
                            {
                                this.q02_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                }
                //Place init for question03 here
                this.initAnswer03 = record.Quiz_1_3__c;

                let foundAns03 = false;
                for(let key in this.q03_Options){
                    if(this.q03_Options[key].optionName === record.Quiz_1_3__c)
                    {
                        this.q03_Options[key].answer = true;
                        foundAns03 = true;
                    }
                }

                if(!foundAns03)
                {
                    if(record.Grade9_Quiz1_Submitted__c !== undefined && record.Grade9_Quiz1_Submitted__c)
                    {
                        for(let key in this.q03_Options){
                            if(this.q03_Options[key].optionName === 'nil')
                            {
                                this.q03_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                }
                //Place init for question04 here
                this.initAnswer04 = record.Quiz_1_4__c;

                let foundAns04 = false;
                for(let key in this.q04_Options){
                    if(this.q04_Options[key].optionName === record.Quiz_1_4__c)
                    {
                        this.q04_Options[key].answer = true;
                        foundAns04 = true;
                    }
                }

                if(!foundAns04)
                {
                    if(record.Grade9_Quiz1_Submitted__c !== undefined && record.Grade9_Quiz1_Submitted__c)
                    {
                        for(let key in this.q04_Options){
                            if(this.q04_Options[key].optionName === 'nil')
                            {
                                this.q04_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                }
                //Place init for question05 here
                this.initAnswer05 = record.Quiz_1_5__c;

                let foundAns05 = false;
                for(let key in this.q05_Options){
                    if(this.q05_Options[key].optionName === record.Quiz_1_5__c)
                    {
                        this.q05_Options[key].answer = true;
                        foundAns05 = true;
                    }
                }

                if(!foundAns05)
                {
                    if(record.Grade9_Quiz1_Submitted__c !== undefined && record.Grade9_Quiz1_Submitted__c)
                    {
                        for(let key in this.q05_Options){
                            if(this.q05_Options[key].optionName === 'nil')
                            {
                                this.q05_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                }
                //===========================================================//
                this.isLoading = false;    //Turn OFF the spinner
                //===========================================================//
                /*
                const event = new ShowToastEvent({
                    title: 'Quiz1-Grade 9',
                    message: 'Record fields received successfuly : Quiz1-Grade 9',
                    variant: 'success'
                });                
                this.dispatchEvent(event);
                */
            }while(false);
            this.flag = 'getApexRecordSAF';
            console.log('this.flag : ' + this.flag);
        }).catch(error => {
            this.isLoading = false;
            let rxError = '';
            if(this.isEnglish){
                this.rxError = 'Error while recieving record fields: Quiz1-Grade 9';
            }else{
                this.rxError = 'रिकॉर्ड फ़ील्ड प्राप्त करते समय त्रुटि: प्रश्नावली1-ग्रेड 9';
            }
            console.log('error = ',error)
            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : this.errorTitle,
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
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
            
            if(record.Grade9_Quiz1_Submitted__c)this.freeze = true;
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
            let rxError = '';
            if(this.isEnglish){
                this.rxError = 'Error while recieving record fields: Quiz1-Grade 9';
            }else{
                this.rxError = 'रिकॉर्ड फ़ील्ड प्राप्त करते समय त्रुटि: क्विज़1-ग्रेड 9';
            }

            if (Array.isArray(error.body)) {
                this.rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : this.errorTitle,
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    q01GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q01_Options){
            if(this.q01_Options[key].answer)
            {
                if(this.q01_Options[key].optionName === 'nil')continue;
                finalAnswer = this.q01_Options[key].optionName;
                break;
            }
        }

        if(finalAnswer === this.initAnswer01)finalAnswer = 'return';
        // console.log('q01GetFinalAnswer : ' + finalAnswer);
        // console.log('initAnswer01 : ' + this.initAnswer01);
        return finalAnswer;
    }

    /*saveQ01(){
        const finalAnswer = this.q01GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question01, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question01, Please proceed');
        // }

        saveSingle({
            recordIdSAF : this.safRecordId,
            studentId : this.rxStudentId,
            barCode : this.studentBarcode,
            qNo : '01',
            ans : {answer : finalAnswer}
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.safRecordId = result;
            this.reInitializeRecordSAF();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Quiz1-Grade 9',
                message: 'Question01 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            

            this.flag = 'saveQ01';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError = 'Error while upserting Question01 answer';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Quiz1-Grade 9',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }*/
    
    handleQ01(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);

        for(let key in this.q01_Options){
            if(this.q01_Options[key].optionName === targetId)
            {
                this.q01_Options[key].answer = targetValue;
            }
            else
            {
                this.q01_Options[key].answer = false;
            }
        }

        // if (this.delayTimeOut01) {
        //     window.clearTimeout(this.delayTimeOut01);
        // }

        // this.delayTimeOut01 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ01();
        // }, this.delay);

        this.flag = 'handleQ01';
        console.log('this.flag : ' + this.flag);
    }

    q02GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q02_Options){
            if(this.q02_Options[key].answer)
            {
                if(this.q02_Options[key].optionName === 'nil')continue;
                finalAnswer = this.q02_Options[key].optionName;
                break;
            }
        }

        if(finalAnswer === this.initAnswer02)finalAnswer = 'return';
        // console.log('q02GetFinalAnswer : ' + finalAnswer);
        // console.log('initAnswer02 : ' + this.initAnswer02);
        return finalAnswer;
    }

    /*saveQ02(){
        const finalAnswer = this.q02GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question02, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question02, Please proceed');
        // }

        saveSingle({
            recordIdSAF : this.safRecordId,
            studentId : this.rxStudentId,
            barCode : this.studentBarcode,
            qNo : '02',
            ans : {answer : finalAnswer}
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.safRecordId = result;
            this.reInitializeRecordSAF();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Quiz1-Grade 9',
                message: 'Question02 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            

            this.flag = 'saveQ02';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError = 'Error while upserting Question02 answer';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Quiz1-Grade 9',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }*/
    
    handleQ02(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);

        for(let key in this.q02_Options){
            if(this.q02_Options[key].optionName === targetId)
            {
                this.q02_Options[key].answer = targetValue;
            }
            else
            {
                this.q02_Options[key].answer = false;
            }
        }

        // if (this.delayTimeOut02) {
        //     window.clearTimeout(this.delayTimeOut02);
        // }

        // this.delayTimeOut02 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ02();
        // }, this.delay);

        this.flag = 'handleQ02';
        console.log('this.flag : ' + this.flag);
    }

    q03GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q03_Options){
            if(this.q03_Options[key].answer)
            {
                if(this.q03_Options[key].optionName === 'nil')continue;
                finalAnswer = this.q03_Options[key].optionName;
                break;
            }
        }

        if(finalAnswer === this.initAnswer03)finalAnswer = 'return';
        // console.log('q03GetFinalAnswer : ' + finalAnswer);
        // console.log('initAnswer03 : ' + this.initAnswer03);
        return finalAnswer;
    }

    /*saveQ03(){
        const finalAnswer = this.q03GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question03, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question03, Please proceed');
        // }

        saveSingle({
            recordIdSAF : this.safRecordId,
            studentId : this.rxStudentId,
            barCode : this.studentBarcode,
            qNo : '03',
            ans : {answer : finalAnswer}
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.safRecordId = result;
            this.reInitializeRecordSAF();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Quiz1-Grade 9',
                message: 'Question03 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            

            this.flag = 'saveQ03';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError = 'Error while upserting Question03 answer';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Quiz1-Grade 9',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }*/
    
    handleQ03(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);

        for(let key in this.q03_Options){
            if(this.q03_Options[key].optionName === targetId)
            {
                this.q03_Options[key].answer = targetValue;
            }
            else
            {
                this.q03_Options[key].answer = false;
            }
        }

        // if (this.delayTimeOut03) {
        //     window.clearTimeout(this.delayTimeOut03);
        // }

        // this.delayTimeOut03 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ03();
        // }, this.delay);

        this.flag = 'handleQ03';
        console.log('this.flag : ' + this.flag);
    }

    q04GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q04_Options){
            if(this.q04_Options[key].answer)
            {
                if(this.q04_Options[key].optionName === 'nil')continue;
                finalAnswer = this.q04_Options[key].optionName;
                break;
            }
        }

        if(finalAnswer === this.initAnswer04)finalAnswer = 'return';
        // console.log('q04GetFinalAnswer : ' + finalAnswer);
        // console.log('initAnswer04 : ' + this.initAnswer04);
        return finalAnswer;
    }

    /*saveQ04(){
        const finalAnswer = this.q04GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question04, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question04, Please proceed');
        // }

        saveSingle({
            recordIdSAF : this.safRecordId,
            studentId : this.rxStudentId,
            barCode : this.studentBarcode,
            qNo : '04',
            ans : {answer : finalAnswer}
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.safRecordId = result;
            this.reInitializeRecordSAF();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Quiz1-Grade 9',
                message: 'Question04 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            

            this.flag = 'saveQ04';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError = 'Error while upserting Question04 answer';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Quiz1-Grade 9',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }*/
    
    handleQ04(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);

        for(let key in this.q04_Options){
            if(this.q04_Options[key].optionName === targetId)
            {
                this.q04_Options[key].answer = targetValue;
            }
            else
            {
                this.q04_Options[key].answer = false;
            }
        }

        // if (this.delayTimeOut04) {
        //     window.clearTimeout(this.delayTimeOut04);
        // }

        // this.delayTimeOut04 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ04();
        // }, this.delay);

        this.flag = 'handleQ04';
        console.log('this.flag : ' + this.flag);
    }

    q05GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q05_Options){
            if(this.q05_Options[key].answer)
            {
                if(this.q05_Options[key].optionName === 'nil')continue;
                finalAnswer = this.q05_Options[key].optionName;
                break;
            }
        }

        if(finalAnswer === this.initAnswer05)finalAnswer = 'return';
        // console.log('q05GetFinalAnswer : ' + finalAnswer);
        // console.log('initAnswer05 : ' + this.initAnswer05);
        return finalAnswer;
    }

    /*saveQ05(){
        const finalAnswer = this.q05GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question05, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question05, Please proceed');
        // }

        saveSingle({
            recordIdSAF : this.safRecordId,
            studentId : this.rxStudentId,
            barCode : this.studentBarcode,
            qNo : '05',
            ans : {answer : finalAnswer}
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.safRecordId = result;
            this.reInitializeRecordSAF();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Quiz1-Grade 9',
                message: 'Question05 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            

            this.flag = 'saveQ05';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError = 'Error while upserting Question05 answer';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Quiz1-Grade 9',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }*/
    
    handleQ05(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);

        for(let key in this.q05_Options){
            if(this.q05_Options[key].optionName === targetId)
            {
                this.q05_Options[key].answer = targetValue;
            }
            else
            {
                this.q05_Options[key].answer = false;
            }
        }

        // if (this.delayTimeOut05) {
        //     window.clearTimeout(this.delayTimeOut05);
        // }

        // this.delayTimeOut05 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ05();
        // }, this.delay);

        this.flag = 'handleQ05';
        console.log('this.flag : ' + this.flag);
    }

    allQuestionsAttempted(){
        let rxError = '';
        //===============================================//
        let foundans01 = false;
        for(let key in this.q01_Options){
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
        }
        //===============================================//
        let foundans02 = false;
        for(let key in this.q02_Options){
            if(this.q02_Options[key].answer)
            {
                foundans02 = true;
                break;
            }
        }
        if(!foundans02)
        {
            if(rxError !== '')rxError += ', ' + 'Q2';
            else rxError = 'Q2';
        }
        //===============================================//
        let foundans03 = false;
        for(let key in this.q03_Options){
            if(this.q03_Options[key].answer)
            {
                foundans03 = true;
                break;
            }
        }
        if(!foundans03)
        {
            if(rxError !== '')rxError += ', ' + 'Q3';
            else rxError = 'Q3';
        }
        //===============================================//
        let foundans04 = false;
        for(let key in this.q04_Options){
            if(this.q04_Options[key].answer)
            {
                foundans04 = true;
                break;
            }
        }
        if(!foundans04)
        {
            if(rxError !== '')rxError += ', ' + 'Q4';
            else rxError = 'Q4';
        }
        //===============================================//
        let foundans05 = false;
        for(let key in this.q05_Options){
            if(this.q05_Options[key].answer)
            {
                foundans05 = true;
                break;
            }
        }
        if(!foundans05)
        {
            if(rxError !== '')rxError += ', ' + 'Q5';
            else rxError = 'Q5';
        }
        //===============================================//
        if(foundans01 && foundans02 && foundans03 && foundans04 && foundans05)
        {
            return 'All available';
        }
        this.isLoading = false;
        if(this.isEnglish){
            return ('Please choose answers for questions: ' + rxError);
        }else{
            return ('कृपया प्रश्नों के उत्तर चुनें: ' + rxError);
        }
    }

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

    saveAll(){
        
        const q01FinalAnswer = this.q01GetFinalAnswer();
        let q01Answer = {};
        if(q01FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question01, Please return : saveAll()');
            q01Answer = null;
        }
        else 
        {
            // console.log('Change in answer of Question01, Please proceed : saveAll()');
            q01Answer.answer = q01FinalAnswer;
        }
        //===================================================================================//
        const q02FinalAnswer = this.q02GetFinalAnswer();
        let q02Answer = {};
        if(q02FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question02, Please return : saveAll()');
            q02Answer = null;
        }
        else 
        {
            // console.log('Change in answer of Question02, Please proceed : saveAll()');
            q02Answer.answer = q02FinalAnswer;
        }
        //===================================================================================//
        const q03FinalAnswer = this.q03GetFinalAnswer();
        let q03Answer = {};
        if(q03FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question03, Please return : saveAll()');
            q03Answer = null;
        }
        else 
        {
            // console.log('Change in answer of Question03, Please proceed : saveAll()');
            q03Answer.answer = q03FinalAnswer;
        }
        //===================================================================================//
        const q04FinalAnswer = this.q04GetFinalAnswer();
        let q04Answer = {};
        if(q04FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question04, Please return : saveAll()');
            q04Answer = null;
        }
        else 
        {
            // console.log('Change in answer of Question04, Please proceed : saveAll()');
            q04Answer.answer = q04FinalAnswer;
        }
        //===================================================================================//
        const q05FinalAnswer = this.q05GetFinalAnswer();
        let q05Answer = {};
        if(q05FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question05, Please return : saveAll()');
            q05Answer = null;
        }
        else 
        {
            // console.log('Change in answer of Question05, Please proceed : saveAll()');
            q05Answer.answer = q05FinalAnswer;
        }
        //===================================================================================//
        // if(q01Answer !== null || q02Answer !== null || q03Answer !== null || q04Answer !== null || q05Answer !== null)
        // {
            this.isLoading = true;   //Turn ON the spinner

            const allQA = {
                q01 : q01Answer,  
                q02 : q02Answer,
                q03 : q03Answer,  
                q04 : q04Answer, 
                q05 : q05Answer
            };

            saveAllQA({
                recordIdSAF : this.safRecordId,
                studentId : this.rxStudentId,
                barCode : this.studentBarcode,
                ans : allQA,
                lng : this.lng,
                typ : (this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
            }).then(result => {
                debugger
                //console.log('result : ' + JSON.stringify(result));
                //===========================================================//
                this.safRecordId = result;
                this.reInitializeRecordSAF();
                console.log('saveAll')
                 this.submit();
                //this.isLoading = false;   //Turn OFF the spinner
                //===========================================================//
                /*
                const event = new ShowToastEvent({
                    title: 'Quiz1-Grade 9',
                    message: 'All answers upsert successful',
                    variant: 'success'
                });                
                this.dispatchEvent(event);
                */
            }).catch(error => {
                this.isLoading = false;   //Turn OFF the spinner
                let rxError = '';
                if(this.isEnglish){
                    this.rxError = 'Error while upserting all answers';
                }else{
                    this.rxError = 'सभी उत्तरों को सम्मिलित करते समय त्रुटि हुई';
                }

                if (Array.isArray(error.body)) {
                    rxError = error.body.map(e => e.message).join(', ');
                } else if (typeof error.body.message === 'string') {
                    rxError = error.body.message;
                }
                //console.log('Print error : ' + rxError);

                const event = new ShowToastEvent({
                    title : this.errorTitle,
                    message : rxError,
                    variant : 'error'
                });
                this.dispatchEvent(event);
            });
        //}
        //===================================================================================//
       
        this.flag = 'saveAllQA';
        console.log('this.flag : ' + this.flag);
    }

    handleSaveButton(event){
        let eventButton = event.target.dataset.name;

        if(eventButton === 'saveButton')
        {
            do{
                let returnStr = this.allQuestionsAttempted();
                if(returnStr != 'All available')
                {
                    const event = new ShowToastEvent({
                        title : this.errorTitle,
                        message : returnStr,
                        variant : 'error'
                    });
                    this.dispatchEvent(event);
                    break;
                }
                this.saveAll();            
            }while(false);
        }

        this.flag = 'handleSaveButton';
        console.log('this.flag : ' + this.flag);
    }

    submit(){   
        // if(this.safRecordId == null)
        // {
        //     confirm('Please save the record before submit');
        //     return;
        // }

        this.isLoading = true;   //Turn ON the spinner
        console.log(' this.safRecordId = ', this.safRecordId)
        submitAndCalculate({
            recordIdSAF : this.safRecordId
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            if(result === 'success')
            {
                //this.reInitializeRecordSAF();
                console.log('submit')
                this.submitStatus = true;
                 if(this.isEnglish){
                    this.showToastPopMessage('Data is saved for the student','success');
                }else{
                    this.showToastPopMessage('छात्र डेटा सहेजा गया है','success');
                }
            }
            this.backNavigateToInternalPage();           
            this.isLoading = false;   //Turn OFF the spinner
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Quiz1-Grade 9',
                message: 'Record submit successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */
        }).catch(error => {
            this.isLoading = false;   //Turn OFF the spinner
            let rxError = '';
            if(this.isEnglish){
                this.rxError = 'Error while submitting the record';
            }else{
                this.rxError = 'रिकॉर्ड सबमिट करते समय त्रुटि';
            }

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : this.errorTitle,
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });

        this.flag = 'submit';
        console.log('this.flag : ' + this.flag);
    }

    handleSubmitButton(event){
        this.isLoading = true;
        do{
            let returnStr = this.allQuestionsAttempted();
            if(returnStr != 'All available')
            {
                const event = new ShowToastEvent({
                    title : this.errorTitle,
                    message : returnStr,
                    variant : 'error'
                });
                this.dispatchEvent(event);
                break;
            }
            this.saveAll();            
        }while(false);

    }

    showToastPopMessage(messageParam,variantParam){
        const evt = new ShowToastEvent({
            title: this.cmpTitle,
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
}