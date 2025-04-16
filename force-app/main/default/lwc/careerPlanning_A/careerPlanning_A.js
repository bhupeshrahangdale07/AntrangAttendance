import {LightningElement, api, wire, track} from 'lwc';
//import {getRecord} from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import getApexRecord from '@salesforce/apex/CareerPlanning_A.getApexRecord';
import saveSingle from '@salesforce/apex/CareerPlanning_A.saveSingle';
import saveQuestion09 from '@salesforce/apex/CareerPlanning_A.saveQuestion09';
import saveAllQA from '@salesforce/apex/CareerPlanning_A.saveAllQA';
import submitAndCalculate from '@salesforce/apex/CareerPlanning_A.submitAndCalculate';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';

export default class CareerPlanning_A extends NavigationMixin(LightningElement) {
    //=======================================================//
    rxStudentId = null;
    rxStudentGrade = null;    
    cdm1Id = null;
    cdm2Id = null;
    fem = null;
    sch = null;
    grd = null;
    bid = null;
    acid = null;
    batchNumber= null;
    //=======================================================//
    flag = '';
    antarangImage = logo_01;
    isLoading = true;
    studentName = null;
    //studentGrade = null;
    studentBarcode = null;
    @track freeze = true;
    cpRecordId = null;
    //=======================================================//
    delay = 5000;   //Delay = 5 sec
    delayTimeOut07;
    delayTimeOut08;
    delayTimeOut09;
    delayTimeOut10;
    //=======================================================//
    saveAllDone = false;
    submitDone = false;
    //=======================================================//
    question07 = '7. To choose an education pathway, I should (Mark ONLY one option)';
    initAnswer07 = '';
    @track q07_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) Take one which has less fees'          
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) Look at if matches my career and find out subjects being taught'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) Choose education streams which are popular amongst/chosen by most of the students'
        },
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Find out which colleges are closest to my home/place and that should be top-most priority when choosing a college i want to study' 
        },
        {
            optionName:'*',
            answer: false,
            optionValue:'Multiple answers selected'
        },
        {
            optionName:'nil',
            answer: false,
            optionValue:' No Answer'
        }
    ];
    //=======================================================//
    question08 = '8. Choose any ONE option that you are planning to take after Class 10 to reach your career (If you are in 11th or 12th right now, choose what you are currently studying)';
    initAnswer08 = '';
    @track q08_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) Class 11/12: Arts'          
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) Class 11/12: Science'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) Class 11/12: Commerce'
        },
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Diploma' 
        },
        {
            optionName:'E',
            answer: false,
            optionValue:'(e) Apprenticeship' 
        },
        {
            optionName:'F',
            answer: false,
            optionValue:'(f) Vocational Certificate Course' 
        },
        {
            optionName:'G',
            answer: false,
            optionValue:'(g) Work' 
        },
        {
            optionName:'H',
            answer: false,
            optionValue:'(h) I do not know' 
        },
        {
            optionName:'I',
            answer: false,
            optionValue:'(i) Nothing' 
        },
        {
            optionName:'J',
            answer: false,
            optionValue:'(j) I will not be completing 10th' 
        },
        {
            optionName:'K',
            answer: false,
            optionValue:'(k) Other' 
        },
        {
            optionName:'*',
            answer: false,
            optionValue:'Multiple answers selected'
        },
        {
            optionName:'nil',
            answer: false,
            optionValue:' No Answer'
        }
    ];
    //=======================================================//
    get q09PicklistOptions() {
        return [
            { label: ' ', value: '' },
            { label: 'Yes', value: 'A' },
            { label: 'No', value: 'B' },
            { label: 'I don\'t know', value: 'C' },
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'nil' },
        ];
    }

    question09 = '9. What can stop you from your chosen career? Answer either yes, no, or I don\'t know for every sentence.';
    initAnswer09 = [];
    @track q09_Options = [
        {
            optionName:'1', 
            answer: '',
            optionValue:'(a) I will get married before 22 years of age'          
        },
        {
            optionName:'2',
            answer: '',
            optionValue:'(b) I will need to start working in the next 3 years for supporting my family income'
        },
        {
            optionName:'3',
            answer: '',
            optionValue:'(c) I generally score below 50%'
        },
        {
            optionName:'4', 
            answer: '',
            optionValue:'(d) Although I score above 50%, my score generally does not exceed 80%'          
        },
        {
            optionName:'5',
            answer: '',
            optionValue:'(e) My family cannot afford to pay my education fees'
        },
        {
            optionName:'6',
            answer: '',
            optionValue:'(f) My family income is not high [below Rs.20000 per month]'
        },
        {
            optionName:'7',
            answer: '',
            optionValue:'(g) I may not be allowed to work late by my family'
        }
    ];
    //=======================================================//
    question10 = '10. How confident are you of overcoming the challenges that stop you from reaching your career?';
    initAnswer10 = '';
    @track q10_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) Not confident'          
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) Somewhat confident'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) Mostly confident'
        },
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Very confident' 
        },
        {
            optionName:'E',
            answer: false,
            optionValue:'(e) I do not have any of the above challenges' 
        },
        {
            optionName:'*',
            answer: false,
            optionValue:'Multiple answers selected'
        },
        {
            optionName:'nil',
            answer: false,
            optionValue:' No Answer'
        }
    ];
    //=======================================================//
    @wire(CurrentPageReference)
    getCurrentPageReference(currentPageReference) {
        if(currentPageReference) 
        {
            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            this.rxStudentId = rxCurrentPageReference.state.studentId;
            this.cdm1Id = rxCurrentPageReference.state.cdm1Id;
            this.cdm2Id = rxCurrentPageReference.state.cdm2Id;

            this.fem = decodeURI(rxCurrentPageReference.state.fem);
            this.sch = decodeURI(rxCurrentPageReference.state.sch);
            this.grd = decodeURI(rxCurrentPageReference.state.grd);
            this.bid = decodeURI(rxCurrentPageReference.state.bid);
            this.acid = decodeURI(rxCurrentPageReference.state.acid);
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

    connectedCallback() {

        this.getApexRecordCP();

        this.flag = 'connectedCallback';
        console.log('this.flag : ' + this.flag);
    }

    renderedCallback()
    {
        if(this.saveAllDone)
        {
            this.submit();   
            this.saveAllDone = false;
        }

        if(this.submitDone)
        {
            this.backNavigateToInternalPage();
            this.submitDone = false;
        }

        this.flag = 'renderedCallback';
        console.log('this.flag : ' + this.flag);
    }

    getApexRecordCP(){
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
                    //console.log('CP record does not exist');
                    this.freeze = false;
                    this.isLoading = false;
                    break;
                }

                const record = singleRecordWrapper.apexRecord;

                if(record.Form_Submitted__c)this.freeze = true;
                else this.freeze = false;

                this.cpRecordId = record.Id;
                
                //Place init for question07 here
                this.initAnswer07 = record.Q_7__c;

                let foundAns07 = false;
                for(let key in this.q07_Options){
                    if(this.q07_Options[key].optionName === record.Q_7__c)
                    {
                        this.q07_Options[key].answer = true;
                        foundAns07 = true;
                    }
                }

                if(!foundAns07)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q07_Options){
                            if(this.q07_Options[key].optionName === 'nil')
                            {
                                this.q07_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                } 
                //Place init for question08 here
                this.initAnswer08 = record.Q_8__c;

                let foundAns08 = false;
                for(let key in this.q08_Options){
                    if(this.q08_Options[key].optionName === record.Q_8__c)
                    {
                        this.q08_Options[key].answer = true;
                        foundAns08 = true;
                    }
                }

                if(!foundAns08)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q08_Options){
                            if(this.q08_Options[key].optionName === 'nil')
                            {
                                this.q08_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                } 
                //Place init for question09 here 
                if(record.Q_9_1__c === undefined)this.initAnswer09.push('');
                else this.initAnswer09.push(record.Q_9_1__c);

                if(record.Q_9_2__c === undefined)this.initAnswer09.push('');
                else this.initAnswer09.push(record.Q_9_2__c);

                if(record.Q_9_3__c === undefined)this.initAnswer09.push('');
                else this.initAnswer09.push(record.Q_9_3__c);

                if(record.Q_9_4__c === undefined)this.initAnswer09.push('');
                else this.initAnswer09.push(record.Q_9_4__c);

                if(record.Q_9_5__c === undefined)this.initAnswer09.push('');
                else this.initAnswer09.push(record.Q_9_5__c);

                if(record.Q_9_6__c === undefined)this.initAnswer09.push('');
                else this.initAnswer09.push(record.Q_9_6__c);

                if(record.Q_9_7__c === undefined)this.initAnswer09.push('');
                else this.initAnswer09.push(record.Q_9_7__c);

                let validAns = ['A','B','C','*'];
                let foundAns09 = [];
                for(let x = 0; x < this.initAnswer09.length; x++) { //this.initAnswer09.length is important here
                    if(this.initAnswer09[x] !== '' && validAns.includes(this.initAnswer09[x]))
                    {
                        this.q09_Options[x].answer = this.initAnswer09[x];
                        foundAns09[x] = true;
                    }
                    else 
                    {
                        foundAns09[x] = false;
                    }
                }

                if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                {
                    for(let x = 0; x < foundAns09.length; x++)
                    {
                        if(!foundAns09[x])
                        {
                            this.q09_Options[x].answer = 'nil';
                        }
                    }
                }
                //Place init for question10 here
                this.initAnswer10 = record.Q_10__c;

                let foundAns10 = false;
                for(let key in this.q10_Options){
                    if(this.q10_Options[key].optionName === record.Q_10__c)
                    {
                        this.q10_Options[key].answer = true;
                        foundAns10 = true;
                    }
                }

                if(!foundAns10)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q10_Options){
                            if(this.q10_Options[key].optionName === 'nil')
                            {
                                this.q10_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                } 
                //===========================================================//
                this.isLoading = false;
                //===========================================================//
                /*
                const event = new ShowToastEvent({
                    title: 'Career Planning-A',
                    message: 'Career Planning-A record fields received successfuly',
                    variant: 'success'
                });                
                this.dispatchEvent(event);
                */
            }while(false);
            this.flag = 'getApexRecordCP';
            console.log('this.flag : ' + this.flag);
        }).catch(error => {
            this.isLoading = false;
            let rxError = 'Error while recieving record fields: Career Planning-A';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Career Planning-A',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    } 

    reInitializeRecordCP(){
        getApexRecord({
            studentId : this.rxStudentId,
            grade : this.grd
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            const singleRecordWrapper = JSON.parse(JSON.stringify(result));
            //===========================================================//
            const record = singleRecordWrapper.apexRecord;

            if(record.Form_Submitted__c)this.freeze = true;
            else this.freeze = false;
            
            //Place init for question07 here
            this.initAnswer07 = record.Q_7__c;
            //Place init for question08 here
            this.initAnswer08 = record.Q_8__c;
            //Place init for question09 here 
            this.initAnswer09 = [];
            if(record.Q_9_1__c === undefined)this.initAnswer09.push('');
            else this.initAnswer09.push(record.Q_9_1__c);

            if(record.Q_9_2__c === undefined)this.initAnswer09.push('');
            else this.initAnswer09.push(record.Q_9_2__c);

            if(record.Q_9_3__c === undefined)this.initAnswer09.push('');
            else this.initAnswer09.push(record.Q_9_3__c);

            if(record.Q_9_4__c === undefined)this.initAnswer09.push('');
            else this.initAnswer09.push(record.Q_9_4__c);

            if(record.Q_9_5__c === undefined)this.initAnswer09.push('');
            else this.initAnswer09.push(record.Q_9_5__c);

            if(record.Q_9_6__c === undefined)this.initAnswer09.push('');
            else this.initAnswer09.push(record.Q_9_6__c);

            if(record.Q_9_7__c === undefined)this.initAnswer09.push('');
            else this.initAnswer09.push(record.Q_9_7__c);
            //Place init for question10 here
            this.initAnswer10 = record.Q_10__c;
            //===========================================================//
            this.flag = 'reInitializeRecordCP';
            console.log('this.flag : ' + this.flag);
        }).catch(error => {
            this.isLoading = false;
            let rxError = 'Error while recieving record fields: Career Planning-A';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Career Planning-A',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    q07GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q07_Options){
            if(this.q07_Options[key].answer)
            {
                if(this.q07_Options[key].optionName === 'nil')continue;
                finalAnswer = this.q07_Options[key].optionName;
                break;
            }
        }

        if(finalAnswer === this.initAnswer07)finalAnswer = 'return';
        // console.log('q07GetFinalAnswer : ' + finalAnswer);
        // console.log('initAnswer07 : ' + this.initAnswer07);
        return finalAnswer;
    }

    saveQ07(){
        const finalAnswer = this.q07GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question07, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question07, Please proceed');
        // }

        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

        saveSingle({
            recordIdCP : this.cpRecordId,
            studentId : this.rxStudentId,
            barCode : this.studentBarcode,
            qNo : '07',
            ans : {answer : finalAnswer}
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.cpRecordId = result;
            this.reInitializeRecordCP();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Planning-A',
                message: 'Question07 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQ07';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError = 'Error while upserting Question07 answer';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Career Planning-A',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }
    
    handleQ07(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);

        for(let key in this.q07_Options){
            if(this.q07_Options[key].optionName === targetId)
            {
                this.q07_Options[key].answer = targetValue;
            }
            else
            {
                this.q07_Options[key].answer = false;
            }
        }

        if (this.delayTimeOut07) {
            window.clearTimeout(this.delayTimeOut07);
        }

        this.delayTimeOut07 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            this.saveQ07();
        }, this.delay);

        this.flag = 'handleQ07';
        console.log('this.flag : ' + this.flag);
    }

    q08GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q08_Options){
            if(this.q08_Options[key].answer)
            {
                if(this.q08_Options[key].optionName === 'nil')continue;
                finalAnswer = this.q08_Options[key].optionName;
                break;
            }
        }

        if(finalAnswer === this.initAnswer08)finalAnswer = 'return';
        // console.log('q08GetFinalAnswer : ' + finalAnswer);
        // console.log('initAnswer08 : ' + this.initAnswer08);
        return finalAnswer;
    }

    saveQ08(){
        const finalAnswer = this.q08GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question08, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question08, Please proceed');
        // }

        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

        saveSingle({
            recordIdCP : this.cpRecordId,
            studentId : this.rxStudentId,
            barCode : this.studentBarcode,
            qNo : '08',
            ans : {answer : finalAnswer}
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.cpRecordId = result;
            this.reInitializeRecordCP();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Planning-A',
                message: 'Question08 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQ08';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError = 'Error while upserting Question08 answer';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Career Planning-A',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }
    
    handleQ08(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);

        for(let key in this.q08_Options){
            if(this.q08_Options[key].optionName === targetId)
            {
                this.q08_Options[key].answer = targetValue;
            }
            else
            {
                this.q08_Options[key].answer = false;
            }
        }

        if (this.delayTimeOut08) {
            window.clearTimeout(this.delayTimeOut08);
        }

        this.delayTimeOut08 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            this.saveQ08();
        }, this.delay);

        this.flag = 'handleQ08';
        console.log('this.flag : ' + this.flag);
    }

    q09GetFinalAnswer(){
        let finalAnswer = []; 

        for(let key in this.q09_Options){
            let ans = this.q09_Options[key].answer;
            if(ans === 'nil')ans = '';
            finalAnswer.push(ans);
        }

        let matchCount = 0;
        for(; matchCount < finalAnswer.length; matchCount++)
        {
            if(finalAnswer[matchCount] !== this.initAnswer09[matchCount])break;
        }

        if(matchCount === finalAnswer.length)
        {
            //console.log('No change in answer of Question09, Please return');
            return ['return'];
        }

        return finalAnswer;
    }

    saveQ09(){
        const finalAnswer = this.q09GetFinalAnswer();
        if(finalAnswer[0] === 'return')
        {
            // console.log('No change in answer of Question09, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question09, Please proceed');
        // }

        const q09Answer = {
            answer1 : finalAnswer[0],
            answer2 : finalAnswer[1],
            answer3 : finalAnswer[2],
            answer4 : finalAnswer[3],
            answer5 : finalAnswer[4],
            answer6 : finalAnswer[5],
            answer7 : finalAnswer[6]
        };

        saveQuestion09({
            recordIdCP : this.cpRecordId,
            studentId : this.rxStudentId,
            barCode : this.studentBarcode,
            ans : q09Answer
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.cpRecordId = result;
            this.reInitializeRecordCP();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Planning-A',
                message: 'Question09 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQ09';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError = 'Error while upserting Question09 answer';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Career Planning-A',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    handleQ09(event) {
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.value;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);

        for(let key in this.q09_Options){
            if(this.q09_Options[key].optionName === targetId)
            {
                this.q09_Options[key].answer = targetValue;
            }
        }

        if (this.delayTimeOut09) {
            window.clearTimeout(this.delayTimeOut09);
        }

        this.delayTimeOut09 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            this.saveQ09();
        }, this.delay);

        this.flag = 'handleQ09';
        console.log('this.flag : ' + this.flag);
    }

    q10GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q10_Options){
            if(this.q10_Options[key].answer)
            {
                if(this.q10_Options[key].optionName === 'nil')continue;
                finalAnswer = this.q10_Options[key].optionName;
                break;
            }
        }

        if(finalAnswer === this.initAnswer10)finalAnswer = 'return';
        // console.log('q10GetFinalAnswer : ' + finalAnswer);
        // console.log('initAnswer10 : ' + this.initAnswer10);
        return finalAnswer;
    }

    saveQ10(){
        const finalAnswer = this.q10GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question10, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question10, Please proceed');
        // }

        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

        saveSingle({
            recordIdCP : this.cpRecordId,
            studentId : this.rxStudentId,
            barCode : this.studentBarcode,
            qNo : '10',
            ans : {answer : finalAnswer}
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.cpRecordId = result;
            this.reInitializeRecordCP();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Planning-A',
                message: 'Question10 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQ10';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError = 'Error while upserting Question10 answer';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Career Planning-A',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }
    
    handleQ10(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);

        for(let key in this.q10_Options){
            if(this.q10_Options[key].optionName === targetId)
            {
                this.q10_Options[key].answer = targetValue;
            }
            else
            {
                this.q10_Options[key].answer = false;
            }
        }

        if (this.delayTimeOut10) {
            window.clearTimeout(this.delayTimeOut10);
        }

        this.delayTimeOut10 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            this.saveQ10();
        }, this.delay);

        this.flag = 'handleQ10';
        console.log('this.flag : ' + this.flag);
    }

    allQuestionsAttempted(){
        let rxError = '';
        //===============================================//
        let foundans07 = false;
        for(let key in this.q07_Options){
            if(this.q07_Options[key].answer)
            {
                foundans07 = true;
                break;
            }
        }
        if(!foundans07)
        {
            if(rxError !== '')rxError += ', ' + 'Q7';
            else rxError = 'Q7';
        }
        //===============================================//
        let foundans08 = false;
        for(let key in this.q08_Options){
            if(this.q08_Options[key].answer)
            {
                foundans08 = true;
                break;
            }
        }
        if(!foundans08)
        {
            if(rxError !== '')rxError += ', ' + 'Q8';
            else rxError = 'Q8';
        }
        //===============================================//
        let foundans09 = [];
        for(let x = 0; x < this.q09_Options.length ; x++)
        {
            if(this.q09_Options[x].answer === '')
            {
                foundans09[x] = false;
            }
            else foundans09[x] = true;
        }

        let foundans09All = true;
        for(let x = 0; x < foundans09.length ; x++)
        {
            if(!foundans09[x])
            {
                if(rxError !== '')rxError += ', ' + 'Q9.' + + (x+1);
                else rxError = 'Q9.' + (x+1);

                foundans09All = false;
            }
        }
        //===============================================//
        let foundans10 = false;
        for(let key in this.q10_Options){
            if(this.q10_Options[key].answer)
            {
                foundans10 = true;
                break;
            }
        }
        if(!foundans10)
        {
            if(rxError !== '')rxError += ', ' + 'Q10';
            else rxError = 'Q10';
        }
        //===============================================// 
        if(foundans07 && foundans08 && foundans09All && foundans10)
        {
            return 'All available';
        }
        
        return ('Please choose answers for questions: ' + rxError);
    }

    restrictIndividualUpdate(){
        if (this.delayTimeOut07) {
            window.clearTimeout(this.delayTimeOut07);
        }

        if (this.delayTimeOut08) {
            window.clearTimeout(this.delayTimeOut08);
        }

        if (this.delayTimeOut09) {
            window.clearTimeout(this.delayTimeOut09);
        }

        if (this.delayTimeOut10) {
            window.clearTimeout(this.delayTimeOut10);
        }
    }

    saveAll(){
        this.restrictIndividualUpdate();
        //===================================================================================//
        const q07FinalAnswer = this.q07GetFinalAnswer();
        let q07Answer = {};
        if(q07FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question07, Please return : saveAll()');
            q07Answer = null;
        }
        else 
        {
            // console.log('Change in answer of Question07, Please proceed : saveAll()');
            q07Answer.answer = q07FinalAnswer;
        }
        //===================================================================================//
        const q08FinalAnswer = this.q08GetFinalAnswer();
        let q08Answer = {};
        if(q08FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question08, Please return : saveAll()');
            q08Answer = null;
        }
        else 
        {
            // console.log('Change in answer of Question08, Please proceed : saveAll()');
            q08Answer.answer = q08FinalAnswer;
        }
        //===================================================================================//
        const q09FinalAnswer = this.q09GetFinalAnswer();
        let q09Answer = {};
        if(q09FinalAnswer[0] === 'return')
        {
            // console.log('No change in answer of Question09, Please return : saveAll()');
            q09Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question09, Please proceed : saveAll()');
            q09Answer.answer1 = q09FinalAnswer[0];
            q09Answer.answer2 = q09FinalAnswer[1];
            q09Answer.answer3 = q09FinalAnswer[2];
            q09Answer.answer4 = q09FinalAnswer[3];
            q09Answer.answer5 = q09FinalAnswer[4];
            q09Answer.answer6 = q09FinalAnswer[5];
            q09Answer.answer7 = q09FinalAnswer[6];
        }
        //===================================================================================//
        const q10FinalAnswer = this.q10GetFinalAnswer();
        let q10Answer = {};
        if(q10FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question10, Please return : saveAll()');
            q10Answer = null;
        }
        else 
        {
            // console.log('Change in answer of Question10, Please proceed : saveAll()');
            q10Answer.answer = q10FinalAnswer;
        }
        //===================================================================================//
        if(q07Answer !== null || q08Answer !== null || q09Answer !== null || q10Answer !== null)
        {
            this.isLoading = true;   //Turn ON the spinner

            const allQA = {
                q07 : q07Answer,  
                q08 : q08Answer,
                q09 : q09Answer,
                q10 : q10Answer
            };

            //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

            saveAllQA({
                recordIdCP : this.cpRecordId,
                studentId : this.rxStudentId,
                barCode : this.studentBarcode,
                ans : allQA
            }).then(result => {
                //console.log('result : ' + JSON.stringify(result));
                //===========================================================//
                this.cpRecordId = result;
                this.reInitializeRecordCP();
                this.saveAllDone = true;
                this.isLoading = false;   //Turn OFF the spinner
                //===========================================================//
                /*
                const event = new ShowToastEvent({
                    title: 'Career Planning-A',
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
                    title : 'Career Planning-A',
                    message : rxError,
                    variant : 'error'
                });
                this.dispatchEvent(event);
            });
        }else{
            this.submit();
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
                        title : 'Career Planning-A',
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

    handleBackButton(event){
        let eventButton = event.target.dataset.name;

        if(eventButton === 'backButton')
        {
            this.cdm2NavigateToInternalPage();
        }

        this.flag = 'handleBackButton';
        console.log('this.flag : ' + this.flag);
    }

    cdm2NavigateToInternalPage() {
        // Use the basePath from the Summer '20 module to construct the URL
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'CDM2__c'
            },
            state: {
                fem : encodeURI(this.fem),
                sch : encodeURI(this.sch),
                grd : encodeURI(this.grd),
                bid : encodeURI(this.bid),
                acid : encodeURI(this.acid),
                studentId : this.rxStudentId,
                cdm1Id : this.cdm1Id,
                cdm2Id : this.cdm2Id
            }
        });
    }

    submit(){   
        // this.cpRecordId = null;  //For temperary purpose delete afterwards
        if(this.cpRecordId == null)
        {
            confirm('Please save the record before submit');
            return;
        }

        this.isLoading = true;   //Turn ON the spinner
        submitAndCalculate({
            recordIdCP : this.cpRecordId,
            cdm1Id : this.cdm1Id,
            cdm2Id : this.cdm2Id
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            if(result === 'success')
            {
                this.reInitializeRecordCP();
            }
            this.submitDone = true;           
            this.isLoading = false;   //Turn OFF the spinner
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Planning-A',
                message: 'Record submit successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */
        }).catch(error => {
            this.isLoading = false;   //Turn OFF the spinner
            let rxError = 'Error while submitting the record';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Career Planning-A',
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
                        title : 'Career Planning-A',
                        message : returnStr,
                        variant : 'error'
                    });
                    this.dispatchEvent(event);
                    break;
                }
                this.saveAll();
                // this.submit();    
                // //this.backNavigateToInternalPage();  
                // //delay of 1second is added so that record changes are visible on next page 
                // setTimeout(() => {
                //     this.backNavigateToInternalPage();
                // }, 1000);        
            }while(false);
        }

        this.flag = 'handleSubmitButton';
        console.log('this.flag : ' + this.flag);
    }

    backNavigateToInternalPage() {
        // Use the basePath from the Summer '20 module to construct the URL
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'cdm1form5__c'
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