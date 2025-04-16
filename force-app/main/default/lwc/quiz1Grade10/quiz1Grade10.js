import {LightningElement, api, wire, track} from 'lwc';
//import {getRecord} from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import getApexRecord from '@salesforce/apex/quiz1Grade10.getApexRecord';
import saveSingle from '@salesforce/apex/quiz1Grade10.saveSingle';
import saveAllQA from '@salesforce/apex/quiz1Grade10.saveAllQA';
import submitAndCalculate from '@salesforce/apex/quiz1Grade10.submitAndCalculate';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';

export default class Quiz1Grade10 extends NavigationMixin(LightningElement) {
    //=======================================================//
    submitStatus = false;
    //=======================================================//
    batchNumber='';
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
    question01 = '1. What is the correct meaning of interest and aptitude?';
    initAnswer01 = '';
    @track q01_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) Interest - work someone does for money ; Aptitude - activities someone is good at'          
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) Interest - activities someone is good at ; Aptitude - activities someone likes'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) Interest - activities someone likes  ; Aptitude - activities someone is good at'
        },
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Interest - activities someone likes  ; Aptitude - work someone does for money' 
        },
        {
            optionName:'*',
            answer: false,
            optionValue:'Multiple answers selected'
        },
        {
            optionName:'nil',
            answer: false,
            optionValue:'No Answer'
        }
    ];
    //=======================================================//
    question02 = 'Which career would be a good fit for him?';
    initAnswer02 = '';
    @track q02_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) Photographer'          
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) Pilot'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) Accountant'
        },
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Beautician' 
        },
        {
            optionName:'*',
            answer: false,
            optionValue:'Multiple answers selected'
        },
        {
            optionName:'nil',
            answer: false,
            optionValue:'No Answer'
        }
    ];
    //=======================================================//
    question03 = '3. Select the correct option';
    initAnswer03 = '';
    @track q03_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) The only study options after Class 10 is Arts, Science and Commerce'          
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) A person can do a Diploma after 8th, 10th or 12th standard'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) An apprenticeship is the same as doing a part time job.'
        },
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Vocational Certificate courses teach different subjects such as History, Geography, Computers' 
        },
        {
            optionName:'*',
            answer: false,
            optionValue:'Multiple answers selected'
        },
        {
            optionName:'nil',
            answer: false,
            optionValue:'No Answer'
        }
    ];
    //=======================================================//
    question04 = '4. Select the correct option';
    initAnswer04 = '';
    @track q04_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) Vocational Certificate Courses are available for all careers'          
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) In diploma, you learn skills specific to a career'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) As an apprentice you work for free while you learn'
        },
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Arts, Science and Commerce are for 1 year' 
        },
        {
            optionName:'*',
            answer: false,
            optionValue:'Multiple answers selected'
        },
        {
            optionName:'nil',
            answer: false,
            optionValue:'No Answer'
        }
    ];
    //=======================================================//
    question05 = '5. Having a good career plan means';
    initAnswer05 = '';
    @track q05_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) Working in any job that you earn money'          
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) Studying any course to complete your graduation'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) Knowing your career choice and the course required for the career'
        },
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Choosing a popular career with high salary and respect' 
        },
        {
            optionName:'*',
            answer: false,
            optionValue:'Multiple answers selected'
        },
        {
            optionName:'nil',
            answer: false,
            optionValue:'No Answer'
        }
    ];
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

    //Standard JavaScript connectedCallback() method called on page load
    connectedCallback() 
    {
        this.getApexRecordSAF();

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
            //console.log('result : ' + JSON.stringify(result));
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

                if(record.Grade10_Quiz1_Submitted__c)this.freeze = true;
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
                    if(record.Grade10_Quiz1_Submitted__c !== undefined && record.Grade10_Quiz1_Submitted__c)
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
                    if(record.Grade10_Quiz1_Submitted__c !== undefined && record.Grade10_Quiz1_Submitted__c)
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
                    if(record.Grade10_Quiz1_Submitted__c !== undefined && record.Grade10_Quiz1_Submitted__c)
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
                    if(record.Grade10_Quiz1_Submitted__c !== undefined && record.Grade10_Quiz1_Submitted__c)
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
                    if(record.Grade10_Quiz1_Submitted__c !== undefined && record.Grade10_Quiz1_Submitted__c)
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
                    title: 'Quiz1-Grade 10',
                    message: 'Record fields received successfuly : Quiz1-Grade 10',
                    variant: 'success'
                });                
                this.dispatchEvent(event);
                */
            }while(false);
            this.flag = 'getApexRecordSAF';
            console.log('this.flag : ' + this.flag);
        }).catch(error => {
            this.isLoading = false;
            let rxError = 'Error while recieving record fields: Quiz1-Grade 10';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Quiz1-Grade 10',
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
            let rxError = 'Error while recieving record fields: Quiz1-Grade 10';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Quiz1-Grade 10',
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

    saveQ01(){
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
                title: 'Quiz1-Grade 10',
                message: 'Question01 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

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
                title : 'Quiz1-Grade 10',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }
    
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

        if (this.delayTimeOut01) {
            window.clearTimeout(this.delayTimeOut01);
        }

        this.delayTimeOut01 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            this.saveQ01();
        }, this.delay);

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

    saveQ02(){
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
                title: 'Quiz1-Grade 10',
                message: 'Question02 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

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
                title : 'Quiz1-Grade 10',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }
    
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

        if (this.delayTimeOut02) {
            window.clearTimeout(this.delayTimeOut02);
        }

        this.delayTimeOut02 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            this.saveQ02();
        }, this.delay);

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

    saveQ03(){
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
                title: 'Quiz1-Grade 10',
                message: 'Question03 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

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
                title : 'Quiz1-Grade 10',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }
    
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

        if (this.delayTimeOut03) {
            window.clearTimeout(this.delayTimeOut03);
        }

        this.delayTimeOut03 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            this.saveQ03();
        }, this.delay);

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

    saveQ04(){
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
                title: 'Quiz1-Grade 10',
                message: 'Question04 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

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
                title : 'Quiz1-Grade 10',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }
    
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

        if (this.delayTimeOut04) {
            window.clearTimeout(this.delayTimeOut04);
        }

        this.delayTimeOut04 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            this.saveQ04();
        }, this.delay);

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

    saveQ05(){
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
                title: 'Quiz1-Grade 10',
                message: 'Question05 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

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
                title : 'Quiz1-Grade 10',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }
    
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

        if (this.delayTimeOut05) {
            window.clearTimeout(this.delayTimeOut05);
        }

        this.delayTimeOut05 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            this.saveQ05();
        }, this.delay);

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
        
        return ('Please choose answers for questions: ' + rxError);
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
        this.restrictIndividualUpdate();
        //===================================================================================//
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
        if(q01Answer !== null || q02Answer !== null || q03Answer !== null || q04Answer !== null || q05Answer !== null)
        {
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
                ans : allQA
            }).then(result => {
                //console.log('result : ' + JSON.stringify(result));
                //===========================================================//
                this.safRecordId = result;
                this.reInitializeRecordSAF();
                this.isLoading = false;   //Turn OFF the spinner
                //===========================================================//
                /*
                const event = new ShowToastEvent({
                    title: 'Quiz1-Grade 10',
                    message: 'All answers upsert successful',
                    variant: 'success'
                });                
                this.dispatchEvent(event);
                */
            }).catch(error => {
                this.isLoading = false;   //Turn OFF the spinner
                let rxError = 'Error while upserting all answers';

                if (Array.isArray(error.body)) {
                    rxError = error.body.map(e => e.message).join(', ');
                } else if (typeof error.body.message === 'string') {
                    rxError = error.body.message;
                }
                //console.log('Print error : ' + rxError);

                const event = new ShowToastEvent({
                    title : 'Quiz1-Grade 10',
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

    handleSaveButton(event){
        let eventButton = event.target.dataset.name;

        if(eventButton === 'saveButton')
        {
            do{
                let returnStr = this.allQuestionsAttempted();
                if(returnStr != 'All available')
                {
                    const event = new ShowToastEvent({
                        title : 'Quiz1-Grade 10',
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
        if(this.safRecordId == null)
        {
            confirm('Please save the record before submit');
            return;
        }

        this.isLoading = true;   //Turn ON the spinner
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
            this.isLoading = false;   //Turn OFF the spinner
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Quiz1-Grade 10',
                message: 'Record submit successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */
        }).catch(error => {
            this.isLoading = false;   //Turn OFF the spinner
            let rxError = 'Error while submitting the record';
            console.log('error.body.message = ',error.body.message)
            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Quiz1-Grade 10',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });

        this.flag = 'submit';
        console.log('this.flag : ' + this.flag);
    }

    handleSubmitButton(event){
        let eventButton = event.target.dataset.name;

        if(eventButton === 'submitButton')
        {
            do{
                let returnStr = this.allQuestionsAttempted();
                if(returnStr != 'All available')
                {
                    const event = new ShowToastEvent({
                        title : 'Quiz1-Grade 10',
                        message : returnStr,
                        variant : 'error'
                    });
                    this.dispatchEvent(event);
                    break;
                }
                this.saveAll();
                this.showToastPopMessage('Student Data is saved','success');
                //this.submit(); 
                // delay of 1second is added so that record changes done by "this.saveAll();" appears in "this.submit();"
                setTimeout(() => {
                    this.submit();
                }, 1000);     
                // this.backNavigateToInternalPage();  
                // For above navigation to be successful, it is called from renderedCallback()    
            }while(false);
        }

        this.flag = 'handleSubmitButton';
        console.log('this.flag : ' + this.flag);
    }

    showToastPopMessage(messageParam,variantParam){
        const evt = new ShowToastEvent({
            title: 'Quiz 1 Data',
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
                name: 'Quiz_1_Summary__c'
            },
            state: {
                fem : encodeURI(this.fem),
                sch : encodeURI(this.sch),
                grd : encodeURI(this.grd),
                bid : encodeURI(this.bid),
                acid : encodeURI(this.acid)
            }
        });
    }
}