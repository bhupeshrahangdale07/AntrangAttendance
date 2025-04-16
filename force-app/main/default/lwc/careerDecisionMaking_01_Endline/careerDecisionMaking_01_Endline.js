import {LightningElement, api, wire, track} from 'lwc';
//import {getRecord} from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import getRecordCDM1 from '@salesforce/apex/careerDecisionMaking_01_Endline.getRecordCDM1';
import saveQuestion01 from '@salesforce/apex/careerDecisionMaking_01_Endline.saveQuestion01';
import saveQuestion02 from '@salesforce/apex/careerDecisionMaking_01_Endline.saveQuestion02';
import saveQuestion03 from '@salesforce/apex/careerDecisionMaking_01_Endline.saveQuestion03';
import saveQuestion04 from '@salesforce/apex/careerDecisionMaking_01_Endline.saveQuestion04';
import saveAllQA from '@salesforce/apex/careerDecisionMaking_01_Endline.saveAllQA';
import submitAndCalculate from '@salesforce/apex/careerDecisionMaking_01_Endline.submitAndCalculate';
import searchStudentRecords from '@salesforce/apex/careerDecisionMaking_01_Endline.searchStudentRecords';
import getBatchInfo from '@salesforce/apex/careerDecisionMaking_01_Endline.getBatchInfo';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';

export default class CareerDecisionMaking_01_Endline extends NavigationMixin(LightningElement) {
    //=========================================================//
    // tempVar = true;
    //=========================================================//
    batchNumber = null;
    fem = null;
    sch = null;
    grd = null;
    bid = null;
    acid = null;
    //=========================================================//
    //rxAccount = null;
    //rxGrade = null;
    //rxBatch = null;
    //rxGrade = null;
    schoolName = null;
    batchName = null;
    batchNumber = null;
    //rxRecordTypeCDM1 = null;
    rxStudentId = null;
    //=========================================================// 
    rxStudentBarcode = null;    
    rxRecordIdCMD1 = null;
    //=========================================================//
    flag = '';
    antarangImage = logo_01;
    isLoading = true;
    studentName = null;
    //studentGrade = null;
    //=========================================================//
    @track freeze = true;
    delayTimeOut01;
    delayTimeOut02;
    delayTimeOut03;
    delayTimeOut04;
    delay = 5000;   //Delay = 5 sec
    //=========================================================//
    @track studentPresent = false;
    delayTimeOut05;
    studentSearchText = '';
    @track studentSearchResult = 'Please enter text here';
    @track studentDisplay = [];
    @track showStudentList = false;
    submittedStudentMapKeys = [];
    //=========================================================//
    question01 = '1. A good career plan has the following steps (Tick ONLY 1 option)';
    initAnswer01 = '';
    @track q01_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) Complete education and start working'          
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) Choose a career that interests me and study to get there'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) Choosing a career based on interest and aptitude, taking the right course and start working'
        },
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Knowing interest, aptitude and reality, exploring careers, meeting experts from career streams, choosing a career and right educational course'
        },
        {
            optionName:'E',
            answer: false,
            optionValue:'(e) Looking at the career options which are most in demand or chaich can give you good salary, finding out the qualifications required to get into these careers, finding out the colleges which offer these couses and taking admission into these courses'
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
    //=========================================================//
    question02 = '2. Mark all the activities the student has selected for what they like/most interested in';
    initAnswer02 = [];
    // @track q02_Options = [
    //     {
    //         optionName01:'1A', 
    //         answer01: false,
    //         optionName02:'1B',
    //         answer02: false,
    //         optionValue:'(1) Working outside with machines, tools, paints, or animals [Realistic]'
    //     },
    //     {
    //         optionName01:'2A',
    //         answer01: false,
    //         optionName02:'2B',
    //         answer02: false,
    //         optionValue:'(2) Solving puzzles and do science experiments [Investigative]'
    //     },
    //     {
    //         optionName01:'3A',
    //         answer01: false,
    //         optionName02:'3B',
    //         answer02: false,
    //         optionValue:'(3) Writing stories/essays/poems, painting, singing, dancing, acting etc [Artistic]'
    //     },
    //     {
    //         optionName01:'4A',
    //         answer01: false,
    //         optionName02:'4B',
    //         answer02: false,
    //         optionValue:'(4) Teaching, talking with people and helping others [Social]'
    //     },
    //     {
    //         optionName01:'5A',
    //         answer01: false,
    //         optionName02:'5B',
    //         answer02: false,
    //         optionValue:'(5) Being a leader and would love to do my own business [Enterprising]'
    //     },
    //     {
    //         optionName01:'6A',
    //         answer01: false,
    //         optionName02:'6B',
    //         answer02: false,
    //         optionValue:'(6) Following rules and work in a desk/office job [Conventional]'
    //     },
    //     {
    //         optionName01:'7A',
    //         answer01: false,
    //         optionName02:'7B',
    //         answer02: false,
    //         optionValue:'(7) I am not sure what I am interested in/ I like'
    //     }/*,
    //     {
    //         optionName01:'*A',
    //         answer01: false,
    //         optionName02:'*B',
    //         answer02: false,
    //         optionValue:'(*)'
    //     }*/
    // ];

    @track q02_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) Working outside with machines, tools, paints, or animals [Realistic]'
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) Solving puzzles and do science experiments [Investigative]'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) Writing stories/essays/poems, painting, singing, dancing, acting etc [Artistic]'
        },
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Teaching, talking with people and helping others [Social]'
        },
        {
            optionName:'E',
            answer: false,
            optionValue:'(e) Being a leader and would love to do my own business [Enterprising]'
        },
        {
            optionName:'F',
            answer: false,
            optionValue:'(f) Following rules and work in a desk/office job [Conventional]'
        },
        {
            optionName:'G',
            answer: false,
            optionValue:'(g) I am not sure what I am interested in/ I like'
        },
        {
            optionName:'nil',
            answer: false,
            optionValue:'No Answer'
        }
    ];
    //=========================================================//
    question03 = '3. Mark all the activities the student has selected for what they good at/have aptitude';
    initAnswer03 = [];
    // @track q03_Options = [
    //     {
    //         optionName01:'1A', 
    //         answer01: false,
    //         optionName02:'1B',
    //         answer02: false,
    //         optionValue:'(1) Imagining how things may look like by looking at designs/patterns [spatial]'
    //     },
    //     {
    //         optionName01:'2A',
    //         answer01: false,
    //         optionName02:'2B',
    //         answer02: false,
    //         optionValue:'(2) Solving Math problems [Numerical]'
    //     },
    //     {
    //         optionName01:'3A',
    //         answer01: false,
    //         optionName02:'3B',
    //         answer02: false,
    //         optionValue:'(3) Working with machines and tools [Mechanical]'
    //     },
    //     {
    //         optionName01:'4A',
    //         answer01: false,
    //         optionName02:'4B',
    //         answer02: false,
    //         optionValue:'(4) Solving problems by thinking of why the problem happened [Abstract]'
    //     },
    //     {
    //         optionName01:'5A',
    //         answer01: false,
    //         optionName02:'5B',
    //         answer02: false,
    //         optionValue:'(5) Writing stories, poems or articles [Verbal]'
    //     },
    //     {
    //         optionName01:'6A',
    //         answer01: false,
    //         optionName02:'6B',
    //         answer02: false,
    //         optionValue:'(6) Using my imagination and coming up with new ideas or different ways of doing things [Creative]'
    //     },
    //     {
    //         optionName01:'7A',
    //         answer01: false,
    //         optionName02:'7B',
    //         answer02: false,
    //         optionValue:'(7) I am not sure what I am good at/my aptitude is'
    //     }/*,
    //     {
    //         optionName01:'*A',
    //         answer01: false,
    //         optionName02:'*B',
    //         answer02: false,
    //         optionValue:'(*)'
    //     }*/
    // ];
    @track q03_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) Imagining how things may look like by looking at designs/patterns [spatial]'
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) Solving Math problems [Numerical]'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) Working with machines and tools [Mechanical]'
        },
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Solving problems by thinking of why the problem happened [Abstract]'
        },
        {
            optionName:'E',
            answer: false,
            optionValue:'(e) Writing stories, poems or articles [Verbal]'
        },
        {
            optionName:'F',
            answer: false,
            optionValue:'(f) Using my imagination and coming up with new ideas or different ways of doing things [Creative]'
        },
        {
            optionName:'G',
            answer: false,
            optionValue:'(g) I am not sure what I am good at/my aptitude is'
        },
        {
            optionName:'nil',
            answer: false,
            optionValue:'No Answer'
        }
    ];
    //=========================================================//
    @track initMultiPickListValues = false;
    @track fieldValueFCC = '';
    @track arrFieldValueFCC = [];
    prevArrayFCC = [];

    @track fieldValueSCC = '';
    @track arrFieldValueSCC = [];
    prevArraySCC = [];

    question04 = '4. Mark all the careers that the student has chosen for themselves';
    initAnswer04 = {};

    pickListValues = [
        {apiName: 'nil', value: 'No Answer'},
        {apiName: 'Q4_1__c', value: 'I do not Know'},
        {apiName: 'Q4_2__c', value: 'Entrepreneur'},
        {apiName: 'Q4_3__c', value: 'Office Administrator'},
        {apiName: 'Q4_4__c', value: 'Salesperson'},
        {apiName: 'Q4_5__c', value: 'Accountant'},
        {apiName: 'Q4_6__c', value: 'Lawyer'},
        {apiName: 'Q4_7__c', value: 'Logistics Worker'},
        {apiName: 'Q4_8__c', value: 'Interior Designer'},
        {apiName: 'Q4_9__c', value: 'Architect'},
        {apiName: 'Q4_10__c', value: 'Graphic Designer'},
        {apiName: 'Q4_11__c', value: 'Animator'},
        {apiName: 'Q4_12__c', value: 'Fashion Designer'},
        {apiName: 'Q4_13__c', value: 'Performing Artist'},
        {apiName: 'Q4_14__c', value: 'Film Production Specialist'},
        {apiName: 'Q4_15__c', value: 'Content Developer'},
        {apiName: 'Q4_16__c', value: 'Advertising Professional'},
        {apiName: 'Q4_17__c', value: 'Event Planner'},
        {apiName: 'Q4_18__c', value: 'Banker'},
        {apiName: 'Q4_19__c', value: 'Microfinance Professional'},
        {apiName: 'Q4_20__c', value: 'Financial Advisor'},
        {apiName: 'Q4_21__c', value: 'Financial Analyst'},
        {apiName: 'Q4_22__c', value: 'Doctor'},
        {apiName: 'Q4_23__c', value: 'Nurse'},
        {apiName: 'Q4_24__c', value: 'Medical Lab Technician'},
        {apiName: 'Q4_25__c', value: 'Pharmacist'},
        {apiName: 'Q4_26__c', value: 'Physiotherapist'},
        {apiName: 'Q4_27__c', value: 'Healthcare Management Professional'},
        {apiName: 'Q4_28__c', value: 'Hospitality Services Professional'},
        {apiName: 'Q4_29__c', value: 'Chef'},
        {apiName: 'Q4_30__c', value: 'Travel Services Planner'},
        {apiName: 'Q4_31__c', value: 'Commerical Pilot'},
        {apiName: 'Q4_32__c', value: 'Beautician'},
        {apiName: 'Q4_33__c', value: 'Sportsperson'},
        {apiName: 'Q4_34__c', value: 'Coach/Trainer'},
        {apiName: 'Q4_35__c', value: 'Nutritionist/Dietician'},
        {apiName: 'Q4_36__c', value: 'Mental Health Counsellor'},
        {apiName: 'Q4_37__c', value: 'Teacher/Facilitator'},
        {apiName: 'Q4_38__c', value: 'Curriculum Designer'},
        {apiName: 'Q4_39__c', value: 'School Administrator'},
        {apiName: 'Q4_40__c', value: 'Military serviceperson'},
        {apiName: 'Q4_41__c', value: 'Government Service Professional'},
        {apiName: 'Q4_42__c', value: 'Social Worker'},
        {apiName: 'Q4_43__c', value: 'Environmentalist'},
        {apiName: 'Q4_44__c', value: 'Horticulturist'},
        {apiName: 'Q4_45__c', value: 'Urban Planner'},
        {apiName: 'Q4_46__c', value: 'Food Scientist'},
        {apiName: 'Q4_47__c', value: 'Artificial Intelligence Expert'},
        {apiName: 'Q4_48__c', value: 'Cyber Security Specialist'},
        {apiName: 'Q4_49__c', value: 'Application Developer'},
        {apiName: 'Q4_50__c', value: 'Data Analyst/ Scientist'},
        {apiName: 'Q4_51__c', value: 'Engineer'},
        {apiName: 'Q4_52__c', value: 'Tradesperson'},
        {apiName: 'Q4_53__c', value: 'Other'}
    ];
    //=========================================================//

    @wire(CurrentPageReference)
    getCurrentPageReference(currentPageReference) {
        if(currentPageReference) 
        {
            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            if(rxCurrentPageReference.state.studentId !== undefined)
            {
                this.rxStudentId = decodeURI(rxCurrentPageReference.state.studentId);
            }            
            // this.rxBatch = rxCurrentPageReference.state.batchId;
            // this.rxGrade = rxCurrentPageReference.state.grade;
            if(rxCurrentPageReference.state.fem !== undefined)this.fem = decodeURI(rxCurrentPageReference.state.fem);
            if(rxCurrentPageReference.state.sch !== undefined)this.sch = decodeURI(rxCurrentPageReference.state.sch);
            if(rxCurrentPageReference.state.grd !== undefined)this.grd = decodeURI(rxCurrentPageReference.state.grd);
            if(rxCurrentPageReference.state.bid !== undefined)this.bid = decodeURI(rxCurrentPageReference.state.bid);
            if(rxCurrentPageReference.state.acid !== undefined)this.acid = decodeURI(rxCurrentPageReference.state.acid);
            getBatchCodeName({
                batchId : decodeURI(rxCurrentPageReference.state.bid)
            }).then(result => {
                this.batchCode = result.Name;
                this.batchNumber = result.Batch_Number__c;
            }).catch(error => {
                console.log('error 123 = ', error);
            });
            //this.rxBatch = this.bid;
            //this.rxGrade = this.grd;
        }

        this.flag = 'getCurrentPageReference';
        console.log('this.flag : ' + this.flag);
    }

    //Standard JavaScript connectedCallback() method called on page load
    connectedCallback() 
    {
        this.getBatchInformation();

        if(this.rxStudentId !== undefined && this.rxStudentId !== null)
        {
            this.getApexRecordCDM1();
            this.studentPresent = true;
        }

        this.flag = 'connectedCallback';
        console.log('this.flag : ' + this.flag);
    }

    //This method is called after the triggered event is handled completely
    renderedCallback()
    {
        if(this.studentDisplay.length > 0)this.showStudentList = true;
        else
        {
            this.showStudentList = false;
        }

        this.flag = 'renderedCallback';
        console.log('this.flag : ' + this.flag);
    }

    getApexRecordCDM1(){

        getRecordCDM1({
            studentId : this.rxStudentId,
            grade : this.grd
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            const singleRecordWrapper = JSON.parse(JSON.stringify(result));
            if(singleRecordWrapper.studentBarcode !== undefined)
            {
                this.rxStudentBarcode = singleRecordWrapper.studentBarcode;
            }
            else this.rxStudentBarcode = null;
            
            if(singleRecordWrapper.studentName !== undefined)this.studentName = singleRecordWrapper.studentName;
            //if(singleRecordWrapper.studentGrade !== undefined)this.studentGrade = singleRecordWrapper.studentGrade;
            //===========================================================//
            do{
                if(singleRecordWrapper.recordCDM1 === undefined || 
                    singleRecordWrapper.recordCDM1 === null)
                {
                    //console.log('CDM1 record does not exist');

                    this.freeze = false;
                    this.isLoading = false;
                    break;
                }

                const record = singleRecordWrapper.recordCDM1;

                if(record.Form_Submitted__c)this.freeze = true;
                else this.freeze = false;

                this.rxRecordIdCMD1 = record.Id;
                
                //Place init for Question01 here
                this.initAnswer01 = record.Q_1__c;

                let foundAns1 = false;
                for(let key in this.q01_Options){
                    if(this.q01_Options[key].optionName === record.Q_1__c)
                    {
                        this.q01_Options[key].answer = true;
                        foundAns1 = true;
                    }
                }

                if(!foundAns1)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
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
                //Place init for Question02 here
                this.initAnswer02.push(record.Q_2_1__c);
                this.initAnswer02.push(record.Q_2_2__c);
                this.initAnswer02.push(record.Q_2_3__c);
                this.initAnswer02.push(record.Q_2_4__c);
                this.initAnswer02.push(record.Q_2_5__c);
                this.initAnswer02.push(record.Q_2_6__c);
                this.initAnswer02.push(record.Q_2_7__c);
                
                // for(let x = 0; x < this.initAnswer02.length; x++) {
                //     if(this.initAnswer02[x] === 'A')
                //     {
                //         this.q02_Options[x].answer01 = true;
                //     }
                //     else if(this.initAnswer02[x] === 'B')
                //     {
                //         this.q02_Options[x].answer02 = true;
                //     }
                //     else if(this.initAnswer02[x] === '*')
                //     {
                //         this.q02_Options[x].answer01 = true;
                //         this.q02_Options[x].answer02 = true;
                //     }
                // }

                let foundAns2 = false;
                for(let x = 0; x < this.initAnswer02.length; x++) { //this.initAnswer02.length is important here
                    if(this.initAnswer02[x] === this.q02_Options[x].optionName)
                    {
                        this.q02_Options[x].answer = true;
                        foundAns2 = true;
                    }
                }

                if(!foundAns2)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let x = 0; x < this.q02_Options.length; x++) {
                            if(this.q02_Options[x].optionName === 'nil')
                            {
                                this.q02_Options[x].answer = true;
                                break;
                            }
                        }
                    }
                }
                
                //Place init for Question03 here
                this.initAnswer03.push(record.Q3_1__c);
                this.initAnswer03.push(record.Q3_2__c);
                this.initAnswer03.push(record.Q3_3__c);
                this.initAnswer03.push(record.Q3_4__c);
                this.initAnswer03.push(record.Q3_5__c);
                this.initAnswer03.push(record.Q3_6__c);
                this.initAnswer03.push(record.Q3_7__c);

                // for(let x = 0; x < this.initAnswer03.length; x++) {
                //     if(this.initAnswer03[x] === 'A')
                //     {
                //         this.q03_Options[x].answer01 = true;
                //     }
                //     else if(this.initAnswer03[x] === 'B')
                //     {
                //         this.q03_Options[x].answer02 = true;
                //     }
                //     else if(this.initAnswer03[x] === '*')
                //     {
                //         this.q03_Options[x].answer01 = true;
                //         this.q03_Options[x].answer02 = true;
                //     }
                // }

                let foundAns3 = false;
                for(let x = 0; x < this.initAnswer03.length; x++) { //this.initAnswer02.length is important here
                    if(this.initAnswer03[x] === this.q03_Options[x].optionName)
                    {
                        this.q03_Options[x].answer = true;
                        foundAns3 = true;
                    }
                }

                if(!foundAns3)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let x = 0; x < this.q03_Options.length; x++) {
                            if(this.q03_Options[x].optionName === 'nil')
                            {
                                this.q03_Options[x].answer = true;
                                break;
                            }
                        }
                    }
                }

                //Place init for Question04 here
                const recordKeys = Object.keys(record);

                for(let x in this.pickListValues){
                    let key = this.pickListValues[x].apiName;
                    if(key === 'nil')continue;
                    if(recordKeys.includes(key))
                    {
                        this.initAnswer04[key] = record[key];
                    } 
                    else
                    {
                        this.initAnswer04[key] = '';
                    }
                }

                // for(let x = 0; x < this.pickListValues.length; x++)
                // {
                //     let key = this.pickListValues[x].apiName;
                //     if(recordKeys.includes(key) && (record[key] === '1' || record[key] === '*'))
                //     {
                //         this.arrFieldValueFCC.push(this.pickListValues[x].value);
                //         if(this.fieldValueFCC === '')
                //         {
                //             this.fieldValueFCC = this.pickListValues[x].value;
                //         }
                //         else
                //         {
                //             this.fieldValueFCC += ',' + this.pickListValues[x].value;
                //         }
                //     }

                //     if(recordKeys.includes(key) && (record[key] === '2' || record[key] === '*'))
                //     {
                //         this.arrFieldValueSCC.push(this.pickListValues[x].value);
                //         if(this.fieldValueSCC === '')
                //         {
                //             this.fieldValueSCC = this.pickListValues[x].value;
                //         }
                //         else
                //         {
                //             this.fieldValueSCC += ',' + this.pickListValues[x].value;
                //         }
                //     }
                // }
                for(let x = 0; x < this.pickListValues.length; x++)
                {
                    let key = this.pickListValues[x].apiName;
                    if(recordKeys.includes(key)

					&& (record[key] === '1' || record[key] === '2'))
                    {
                        this.arrFieldValueFCC.push(this.pickListValues[x].value);
                        if(this.fieldValueFCC === '')
                        {
                            this.fieldValueFCC = this.pickListValues[x].value;
                        }
                        else
                        {
                            this.fieldValueFCC += ',' + this.pickListValues[x].value;
                        }
                    }
				}

                if(this.arrFieldValueFCC.length == 0)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        this.arrFieldValueFCC.push(this.pickListValues[0].value);
                        this.fieldValueFCC = this.pickListValues[0].value;
                    }
                }

                if(this.arrFieldValueSCC.length == 0)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        this.arrFieldValueSCC.push(this.pickListValues[0].value);
                        this.fieldValueSCC = this.pickListValues[0].value;
                    }
                }

                this.isLoading = false;
                //===========================================================//
                /*
                const event = new ShowToastEvent({
                    title: 'Career Decision Making-1',
                    message: 'Career Decision Making-1 record fields received successfuly',
                    variant: 'success'
                });                
                this.dispatchEvent(event);
                */
            }while(false);
            this.flag = 'getApexRecordCDM1';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError = 'Error while recieving record fields: Career Decision Making-1';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Career Decision Making-1',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    reInitializeRecordCDM1(){
        getRecordCDM1({
            studentId : this.rxStudentId,
            grade : this.grd
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            const singleRecordWrapper = JSON.parse(JSON.stringify(result));
            //===========================================================//
            const record = singleRecordWrapper.recordCDM1;

            if(record.Form_Submitted__c)this.freeze = true;
            else this.freeze = false;
            
            //Place init for Question01 here
            this.initAnswer01 = record.Q_1__c;

            //Place init for Question02 here
            this.initAnswer02 = [];
            this.initAnswer02.push(record.Q_2_1__c);
            this.initAnswer02.push(record.Q_2_2__c);
            this.initAnswer02.push(record.Q_2_3__c);
            this.initAnswer02.push(record.Q_2_4__c);
            this.initAnswer02.push(record.Q_2_5__c);
            this.initAnswer02.push(record.Q_2_6__c);
            this.initAnswer02.push(record.Q_2_7__c);

            //Place init for Question03 here
            this.initAnswer03 = [];
            this.initAnswer03.push(record.Q3_1__c);
            this.initAnswer03.push(record.Q3_2__c);
            this.initAnswer03.push(record.Q3_3__c);
            this.initAnswer03.push(record.Q3_4__c);
            this.initAnswer03.push(record.Q3_5__c);
            this.initAnswer03.push(record.Q3_6__c);
            this.initAnswer03.push(record.Q3_7__c);

            //Place init for Question04 here
            const recordKeys = Object.keys(record);
            this.initAnswer04 = {};

            for(let x in this.pickListValues){
                let key = this.pickListValues[x].apiName;
                if(recordKeys.includes(key))
                {
                    this.initAnswer04[key] = record[key];
                } 
                else
                {
                    this.initAnswer04[key] = '';
                }
            }

            this.flag = 'reInitializeRecordCDM1';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError = 'Error while recieving record fields: Career Decision Making-1 (reInit)';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Career Decision Making-1',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    get freezeCareerChoiceComponent(){
        return !this.freeze;
    }

    get nowStudentPresent(){
        return !this.studentPresent;
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

        //this.rxRecordIdCMD1 = null; //For temperary purpose delete afterwards

        saveQuestion01({
            recordIdCMD1 : this.rxRecordIdCMD1,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : {answer : finalAnswer}
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD1 = result;
            this.reInitializeRecordCDM1();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-1',
                message: 'Question01 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion01';
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
                title : 'Career Decision Making-1',
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
        let finalAnswer = [];

        // for(let key in this.q02_Options){
        //     if(this.q02_Options[key].answer01 && this.q02_Options[key].answer02)
        //     {
        //         finalAnswer.push('*');
        //     }
        //     else if(this.q02_Options[key].answer01 && !this.q02_Options[key].answer02)
        //     {
        //         finalAnswer.push('A');
        //     }
        //     else if(!this.q02_Options[key].answer01 && this.q02_Options[key].answer02)
        //     {
        //         finalAnswer.push('B');
        //     }
        //     else
        //     {
        //         finalAnswer.push(undefined);
        //     }
        // }

        for(let key in this.q02_Options){
            if(this.q02_Options[key].optionName === 'nil')continue;
            
            if(this.q02_Options[key].answer)
            {
                finalAnswer.push(this.q02_Options[key].optionName);
            }
            else
            {
                finalAnswer.push(undefined);
            }
        }

        let matchCount = 0;
        for(; matchCount < finalAnswer.length; matchCount++)
        {
            if(finalAnswer[matchCount] !== this.initAnswer02[matchCount])break;
        }
        if(matchCount === finalAnswer.length)
        {
            //console.log('No change in answer of Question02, Please return');
            return ['return'];
        }

        return finalAnswer;
    }

    saveQ02(){
        const finalAnswer = this.q02GetFinalAnswer();
        if(finalAnswer[0] === 'return')
        {
            // console.log('No change in answer of Question02, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question02, Please proceed');
        // }

        const q02Answer = {
            answer_2_1 : finalAnswer[0],
            answer_2_2 : finalAnswer[1],
            answer_2_3 : finalAnswer[2],
            answer_2_4 : finalAnswer[3],
            answer_2_5 : finalAnswer[4],
            answer_2_6 : finalAnswer[5],
            answer_2_7 : finalAnswer[6]
        };

        //this.rxRecordIdCMD1 = null; //For temperary purpose delete afterwards

        saveQuestion02({
            recordIdCMD1 : this.rxRecordIdCMD1,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : q02Answer
        }).then(result => {
            console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD1 = result;
            this.reInitializeRecordCDM1();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-1',
                message: 'Question02 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion02';
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
                title : 'Career Decision Making-1',
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

        /*
        for(let key in this.q02_Options){
            if(this.q02_Options[key].optionName01 === targetId)
            {
                this.q02_Options[key].answer01 = targetValue;
            }
            else if(this.q02_Options[key].optionName02 === targetId)
            {
                this.q02_Options[key].answer02 = targetValue;
            }
        }*/

        if(targetId === 'nil')
        {
            for(let key in this.q02_Options){
                if(this.q02_Options[key].optionName === 'nil')
                {
                    this.q02_Options[key].answer = targetValue;
                }
                else
                {
                    this.q02_Options[key].answer = false;
                }
            }
        }
        else
        {
            for(let key in this.q02_Options){
                if(this.q02_Options[key].optionName === targetId)
                {
                    this.q02_Options[key].answer = targetValue;
                }
                else if(this.q02_Options[key].optionName === 'nil')
                {
                    this.q02_Options[key].answer = false;
                }
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
        let finalAnswer = [];

        // for(let key in this.q03_Options){
        //     if(this.q03_Options[key].answer01 && this.q03_Options[key].answer02)
        //     {
        //         finalAnswer.push('*');
        //     }
        //     else if(this.q03_Options[key].answer01 && !this.q03_Options[key].answer02)
        //     {
        //         finalAnswer.push('A');
        //     }
        //     else if(!this.q03_Options[key].answer01 && this.q03_Options[key].answer02)
        //     {
        //         finalAnswer.push('B');
        //     }
        //     else
        //     {
        //         finalAnswer.push(undefined);
        //     }
        // }

        for(let key in this.q03_Options){
            if(this.q03_Options[key].optionName === 'nil')continue;
            
            if(this.q03_Options[key].answer)
            {
                finalAnswer.push(this.q03_Options[key].optionName);
            }
            else
            {
                finalAnswer.push(undefined);
            }
        }

        let matchCount = 0;
        for(; matchCount < finalAnswer.length; matchCount++)
        {
            if(finalAnswer[matchCount] !== this.initAnswer03[matchCount])break;
        }
        if(matchCount === finalAnswer.length)
        {
            //console.log('No change in answer of Question03, Please return');
            return ['return'];
        }

        return finalAnswer;
    }

    saveQ03(){
        const finalAnswer = this.q03GetFinalAnswer();
        if(finalAnswer[0] === 'return')
        {
            // console.log('No change in answer of Question03, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question03, Please proceed');
        // }

        const q03Answer = {
            answer_3_1 : finalAnswer[0],
            answer_3_2 : finalAnswer[1],
            answer_3_3 : finalAnswer[2],
            answer_3_4 : finalAnswer[3],
            answer_3_5 : finalAnswer[4],
            answer_3_6 : finalAnswer[5],
            answer_3_7 : finalAnswer[6]
        };

        //this.rxRecordIdCMD1 = null; //For temperary purpose delete afterwards

        saveQuestion03({
            recordIdCMD1 : this.rxRecordIdCMD1,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : q03Answer
        }).then(result => {
            console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD1 = result;
            this.reInitializeRecordCDM1();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-1',
                message: 'Question03 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion03';
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
                title : 'Career Decision Making-1',
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
        /*
        for(let key in this.q03_Options){
            if(this.q03_Options[key].optionName01 === targetId)
            {
                this.q03_Options[key].answer01 = targetValue;
            }
            else if(this.q03_Options[key].optionName02 === targetId)
            {
                this.q03_Options[key].answer02 = targetValue;
            }
        }*/

        if(targetId === 'nil')
        {
            for(let key in this.q03_Options){
                if(this.q03_Options[key].optionName === 'nil')
                {
                    this.q03_Options[key].answer = targetValue;
                }
                else
                {
                    this.q03_Options[key].answer = false;
                }
            }
        }
        else
        {
            for(let key in this.q03_Options){
                if(this.q03_Options[key].optionName === targetId)
                {
                    this.q03_Options[key].answer = targetValue;
                }
                else if(this.q03_Options[key].optionName === 'nil')
                {
                    this.q03_Options[key].answer = false;
                }
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

    // q04GetFinalAnswer() {
    //     let finalAnswer = {};
    //     for(let key in this.pickListValues){

    //         if(this.pickListValues[key].apiName === 'nil')continue;

    //         let op1 = false, op2 = false;         
    //         if(this.arrFieldValueFCC.includes(this.pickListValues[key].value))
    //         {
    //             op1 = true;
    //         }

    //         if(this.arrFieldValueSCC.includes(this.pickListValues[key].value))
    //         {
    //             op2 = true;
    //         }

    //         if(op1 && op2)finalAnswer[this.pickListValues[key].apiName] = '*';
    //         else if(op1 && !op2)finalAnswer[this.pickListValues[key].apiName] = '1';
    //         else if(!op1 && op2)finalAnswer[this.pickListValues[key].apiName] = '2';
    //         else finalAnswer[this.pickListValues[key].apiName] = '';
    //     }

    //     let matchCount = 0;
    //     for(let key in finalAnswer)
    //     {
    //         if(finalAnswer[key] !== this.initAnswer04[key])break;
    //         matchCount++;
    //     }

    //     if(matchCount === Object.keys(finalAnswer).length)
    //     {
    //         //console.log('No change in answer of Question04, Please return');
    //         return {return : 'No change in answer'};
    //     }

    //     return finalAnswer;
    // }
    q04GetFinalAnswer() {
        let finalAnswer = {};
		let count = 0;
        for(let key in this.pickListValues){

            if(this.pickListValues[key].apiName === 'nil')continue;       
            if(this.arrFieldValueFCC.includes(this.pickListValues[key].value))
            {
                finalAnswer[this.pickListValues[key].apiName] = ++count;
            }
			else finalAnswer[this.pickListValues[key].apiName] = '';
        }
		
		if(count > 2)
		{
			for(let key in finalAnswer)
			{
				if(finalAnswer[key] > 1)finalAnswer[key] = 1;
			}
		}

        let matchCount = 0;
        for(let key in finalAnswer)
        {
            if(finalAnswer[key] !== this.initAnswer04[key])break;
            matchCount++;
        }

        if(matchCount === Object.keys(finalAnswer).length)
        {
            //console.log('No change in answer of Question04, Please return');
            return {return : 'No change in answer'};
        }

        return finalAnswer;
    }

    saveQ04(){
        const finalAnswer = this.q04GetFinalAnswer();
        if(finalAnswer.return !== undefined && finalAnswer.return === 'No change in answer')
        {
            // console.log('No change in answer of Question04, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question04, Please proceed');
        // }
        
        const q04Answer = {};
        for(let key in finalAnswer)
        {
            let str = key;
            str = str.replace("__c","");
            str = str.replace("Q","answer_");
            q04Answer[str] = finalAnswer[key];
        }

        saveQuestion04({
            recordIdCMD1 : this.rxRecordIdCMD1,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : q04Answer
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD1 = result;
            this.reInitializeRecordCDM1();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-1',
                message: 'Question04 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion04';
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
                title : 'Career Decision Making-1',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    multipicklistgenericevent(event){
        const pickListEvent = event.detail;
        // console.log('event.detail.fieldName : ' + pickListEvent.fieldName);
        // console.log('event.detail.value : ' + pickListEvent.value); 

        // this.template.querySelectorAll('c-multi-pick-list-generic-component').forEach(comp => {
        //     console.log('comp : ' + comp.fieldApiName);
        // });

        if(pickListEvent.fieldName === 'FirstCareerChoice__c')
        {
            let arr = []; 
            arr.push.apply(arr,pickListEvent.value);

            if(arr.includes('No Answer') && !this.prevArrayFCC.includes('No Answer'))
            {
                this.fieldValueFCC = ['No Answer'];       //This is mandatory 
                this.arrFieldValueFCC = ['No Answer'];
                //Below is call to method 'preSelectedValuesDisplay' from the component 'MultiPickListGenericComponent'
                this.template.querySelectorAll('c-multi-pick-list-generic-component').forEach(comp => {
                    if(comp.fieldApiName === 'FirstCareerChoice__c')
                    {
                        comp.preSelectedValuesDisplay(this.fieldValueFCC);
                    }
                });
            }
            else if(arr.includes('No Answer') && this.prevArrayFCC.includes('No Answer'))
            {
                let arrSorted = [];
                let i = 0;
                for(let x = 0; x < arr.length ; x++)
                {
                    if(arr[x] === 'No Answer')continue;
                    arrSorted[i++] = arr[x];
                }
                this.fieldValueFCC = arrSorted;       //This is mandatory 
                this.arrFieldValueFCC = arrSorted;
                //Below is call to method 'preSelectedValuesDisplay' from the component 'MultiPickListGenericComponent'
                this.template.querySelectorAll('c-multi-pick-list-generic-component').forEach(comp => {
                    if(comp.fieldApiName === 'FirstCareerChoice__c')
                    {
                        comp.preSelectedValuesDisplay(this.fieldValueFCC);
                    }
                });
            }
            else
            {
                this.fieldValueFCC = pickListEvent.value;       //This is mandatory 
                this.arrFieldValueFCC = pickListEvent.value;
            }
        }
        else if(pickListEvent.fieldName === 'SecondCareerChoice__c')
        {
            let arr = []; 
            arr.push.apply(arr,pickListEvent.value);

            if(arr.includes('No Answer') && !this.prevArraySCC.includes('No Answer'))
            {
                this.fieldValueSCC = ['No Answer'];       //This is mandatory 
                this.arrFieldValueSCC = ['No Answer'];
                //Below is call to method 'preSelectedValuesDisplay' from the component 'MultiPickListGenericComponent'
                this.template.querySelectorAll('c-multi-pick-list-generic-component').forEach(comp => {
                    if(comp.fieldApiName === 'SecondCareerChoice__c')
                    {
                        comp.preSelectedValuesDisplay(this.fieldValueSCC);
                    }
                });
            }
            else if(arr.includes('No Answer') && this.prevArraySCC.includes('No Answer'))
            {
                let arrSorted = [];
                let i = 0;
                for(let x = 0; x < arr.length ; x++)
                {
                    if(arr[x] === 'No Answer')continue;
                    arrSorted[i++] = arr[x];
                }
                this.fieldValueSCC = arrSorted;       //This is mandatory 
                this.arrFieldValueSCC = arrSorted;
                //Below is call to method 'preSelectedValuesDisplay' from the component 'MultiPickListGenericComponent'
                this.template.querySelectorAll('c-multi-pick-list-generic-component').forEach(comp => {
                    if(comp.fieldApiName === 'SecondCareerChoice__c')
                    {
                        comp.preSelectedValuesDisplay(this.fieldValueSCC);
                    }
                });
            }
            else
            {
                this.fieldValueSCC = pickListEvent.value;       //This is mandatory 
                this.arrFieldValueSCC = pickListEvent.value;
            }
        }

        if (this.delayTimeOut04) {
            window.clearTimeout(this.delayTimeOut04);
        }

        this.delayTimeOut04 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            this.saveQ04();
        }, this.delay);

        this.prevArrayFCC = [];
        this.prevArrayFCC = [...this.arrFieldValueFCC];
        this.prevArraySCC = [];
        this.prevArraySCC = [...this.arrFieldValueSCC];

        this.flag = 'multipicklistgenericevent';
        console.log('this.flag : ' + this.flag);
    }

    allQuestionsAttempted(){
        let rxError = '';
        //===============================================//
        let foundans1 = false;
        for(let key in this.q01_Options){
            if(this.q01_Options[key].answer)
            {
                foundans1 = true;
                break;
            }
        }
        if(!foundans1)
        {
            if(rxError !== '')rxError += ', ' + 'Q1';
            else rxError = 'Q1';
        }
        //===============================================//
        let foundans2 = false;
        for(let key in this.q02_Options){
            if(this.q02_Options[key].answer)
            {
                foundans2 = true;
                break;
            }
        }
        if(!foundans2)
        {
            if(rxError !== '')rxError += ', ' + 'Q2';
            else rxError = 'Q2';
        }
        //===============================================//
        let foundans3 = false;
        for(let key in this.q03_Options){
            if(this.q03_Options[key].answer)
            {
                foundans3 = true;
                break;
            }
        }
        if(!foundans3)
        {
            if(rxError !== '')rxError += ', ' + 'Q3';
            else rxError = 'Q3';
        }
        //===============================================//
        let foundans4FCC = false;
        if(this.arrFieldValueFCC.length > 0)foundans4FCC = true;
        else
        {
            if(rxError !== '')rxError += ', ' + 'Q4 First Career Choice';
            else rxError = 'Q4 First Career Choice';
        }

        // let foundans4SCC = false;
        // if(this.arrFieldValueSCC.length > 0)foundans4SCC = true;
        // else
        // {
        //     if(rxError !== '')rxError += ', ' + 'Q4 Second Career Choice';
        //     else rxError = 'Q4 Second Career Choice';
        // }
        //===============================================//
        if(foundans1 && foundans2 && foundans3 && foundans4FCC /*&& foundans4SCC*/)
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
        if(q02FinalAnswer[0] === 'return')
        {
            // console.log('No change in answer of Question02, Please return : saveAll()');
            q02Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question02, Please proceed : saveAll()');
            q02Answer.answer_2_1 = q02FinalAnswer[0];
            q02Answer.answer_2_2 = q02FinalAnswer[1];
            q02Answer.answer_2_3 = q02FinalAnswer[2];
            q02Answer.answer_2_4 = q02FinalAnswer[3];
            q02Answer.answer_2_5 = q02FinalAnswer[4];
            q02Answer.answer_2_6 = q02FinalAnswer[5];
            q02Answer.answer_2_7 = q02FinalAnswer[6];
        }
        //===================================================================================//
        const q03FinalAnswer = this.q03GetFinalAnswer();
        let q03Answer = {};
        if(q03FinalAnswer[0] === 'return')
        {
            // console.log('No change in answer of Question03, Please return : saveAll()');
            q03Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question03, Please proceed : saveAll()');
            q03Answer.answer_3_1 = q03FinalAnswer[0];
            q03Answer.answer_3_2 = q03FinalAnswer[1];
            q03Answer.answer_3_3 = q03FinalAnswer[2];
            q03Answer.answer_3_4 = q03FinalAnswer[3];
            q03Answer.answer_3_5 = q03FinalAnswer[4];
            q03Answer.answer_3_6 = q03FinalAnswer[5];
            q03Answer.answer_3_7 = q03FinalAnswer[6];
        }
        //===================================================================================//
        const q04FinalAnswer = this.q04GetFinalAnswer();
        let q04Answer = {};
        if(q04FinalAnswer.return !== undefined && q04FinalAnswer.return === 'No change in answer')
        {
            // console.log('No change in answer of Question04, Please return : saveAll()');
            q04Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question04, Please proceed : saveAll()');
            for(let key in q04FinalAnswer)
            {
                let str = key;
                str = str.replace("__c","");
                str = str.replace("Q","answer_");
                q04Answer[str] = q04FinalAnswer[key];
            }
        }
        //===================================================================================//
        if(q01Answer !== null || q02Answer !== null || q03Answer !== null || q04Answer !== null)
        {
            this.isLoading = true;   //Turn ON the spinner

            const allQA = {
                q01 : q01Answer,
                q02 : q02Answer,
                q03 : q03Answer,
                q04 : q04Answer
            };

            //this.rxRecordIdCMD1 = null; //For temperary purpose delete afterwards

            saveAllQA({
                recordIdCMD1 : this.rxRecordIdCMD1,
                studentId : this.rxStudentId,
                barCode : this.rxStudentBarcode,
                ans : allQA
            }).then(result => {
                //console.log('result : ' + JSON.stringify(result));
                //===========================================================//
                this.rxRecordIdCMD1 = result;
                this.reInitializeRecordCDM1();
                this.isLoading = false;   //Turn OFF the spinner
                //===========================================================//
                /*
                const event = new ShowToastEvent({
                    title: 'Career Decision Making-1',
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
                    title : 'Career Decision Making-1',
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
                        title : 'Career Decision Making-1',
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
        //this.rxRecordIdCMD1 = null; //For temperary purpose delete afterwards
        if(this.rxRecordIdCMD1 == null)
        {
            confirm('Please save the record before submit');
            return;
        }

        this.isLoading = true;   //Turn ON the spinner
        submitAndCalculate({
            recordIdCMD1 : this.rxRecordIdCMD1
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            if(result === 'success')
            {
                this.reInitializeRecordCDM1();           
            }           
            this.isLoading = false;   //Turn OFF the spinner
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-1',
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
                title : 'Career Decision Making-1',
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
                        title : 'Career Decision Making-1',
                        message : returnStr,
                        variant : 'error'
                    });
                    this.dispatchEvent(event);
                    break;
                }
                this.submit();            
            }while(false);
        }

        this.flag = 'handleSubmitButton';
        console.log('this.flag : ' + this.flag);
    }

    handleContinueButton(event){
        let eventButton = event.target.dataset.name;

        if(eventButton === 'continueButton')
        {
            if(this.freeze)
            {
                this.cdm2NavigateToInternalPage();
            }
            else
            {
                do{
                    let returnStr = this.allQuestionsAttempted();
                    if(returnStr !== 'All available')
                    {
                        const event = new ShowToastEvent({
                            title : 'Career Decision Making-1',
                            message : returnStr,
                            variant : 'error'
                        });
                        this.dispatchEvent(event);
                        break;
                    }
                    this.saveAll(); 
                    this.cdm2NavigateToInternalPage();                
                }while(false);
            }
        }

        this.flag = 'handleContinueButton';
        console.log('this.flag : ' + this.flag);
    }

    cdm2NavigateToInternalPage() {
        // Use the basePath from the Summer '20 module to construct the URL
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'CDM2_Endline__c'
            },
            state: {
                fem : encodeURI(this.fem),
                sch : encodeURI(this.sch),
                grd : encodeURI(this.grd),
                bid : encodeURI(this.bid),
                acid : encodeURI(this.acid),
                studentId : encodeURI(this.rxStudentId),
                cdm1Id : encodeURI(this.rxRecordIdCMD1)
            }
        });
    }

    handleBackButton(event){
        let eventButton = event.target.dataset.name;

        if(eventButton === 'backButton')
        {
            this.backNavigateToInternalPage();
        }

        this.flag = 'handleBackButton';
        console.log('this.flag : ' + this.flag);
    }

    backNavigateToInternalPage() {
        // Use the basePath from the Summer '20 module to construct the URL
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Endline_Summary__c'
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
    //==========================================================//
    getBatchInformation(){           
        getBatchInfo({
            batchId : this.bid
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            const batchWrapper = JSON.parse(JSON.stringify(result));
            if(batchWrapper.batchName !== undefined)this.batchName = batchWrapper.batchName;
            if(batchWrapper.batchNumber !== undefined)this.batchNumber = batchWrapper.batchNumber;
            if(batchWrapper.schoolName !== undefined)this.schoolName = batchWrapper.schoolName;
            this.isLoading = false;
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-1',
                message: 'Batch information received',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'getBatchInformation';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            this.isLoading = false;
            let rxError = 'Error while receiving batch information';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Career Decision Making-1',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    searchStudent(){
        //console.log('this.studentSearchText = ' + this.studentSearchText);
        do{
            if(this.bid === undefined || this.bid === null)
            {
                const event = new ShowToastEvent({
                    title : 'Career Decision Making-1',
                    message : 'A batch is required to search for student',
                    variant : 'error'
                });
                this.dispatchEvent(event);
                break;
            }

            if(!this.studentSearchText)
            {
                //this.studentSearchText is blank do something
                this.studentSearchResult = 'Please enter text here';
                this.studentDisplay = [];
                this.submittedStudentMapKeys = [];
                break;
            }
            else if(this.studentSearchText.length < 2) 
            {
                //this.studentSearchText.length should be greater than 2 do something
                this.studentSearchResult = 'Enter more than 1 character';
                this.studentDisplay = [];
                this.submittedStudentMapKeys = [];
                break;
            }
            
            searchStudentRecords({
                searchText : this.studentSearchText,
                batchId : this.bid,
                grade : this.grd
            }).then(result => {
                //console.log('result : ' + JSON.stringify(result));
                //===========================================================//
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
                //===========================================================//
                /*
                const event = new ShowToastEvent({
                    title: 'Career Decision Making-1',
                    message: 'Student search successful',
                    variant: 'success'
                });                
                this.dispatchEvent(event);
                */
    
                this.flag = 'searchStudent';
                console.log('this.flag : ' + this.flag);
    
            }).catch(error => {
                let rxError = 'Error while searching student';
    
                if (Array.isArray(error.body)) {
                    rxError = error.body.map(e => e.message).join(', ');
                } else if (typeof error.body.message === 'string') {
                    rxError = error.body.message;
                }
                //console.log('Print error : ' + rxError);
    
                const event = new ShowToastEvent({
                    title : 'Career Decision Making-1',
                    message : rxError,
                    variant : 'error'
                });
                this.dispatchEvent(event);
            });

        }while(false);
    }

    handleInputChangeStudent(event) {
        this.studentSearchText = event.detail.value;
        //console.log('this.studentSearchText = ' + this.studentSearchText);

        if (this.delayTimeOut05) {
            window.clearTimeout(this.delayTimeOut05);
        }

        this.delayTimeOut05 = setTimeout(() => {
            this.searchStudent();
        }, 1000);

        this.flag = 'handleInputChangeStudent';
        console.log('this.flag : ' + this.flag);
    }

    handleClick(event){
        //console.log('Onclick studentId : ' + event.currentTarget.dataset.id);
        //console.log('itemIndex : ' + event.currentTarget.dataset.index);

        let selectedStudent = event.currentTarget.dataset.id;

        do{
            if(this.submittedStudentMapKeys.length > 0 &&
                 this.submittedStudentMapKeys.includes(selectedStudent))
            {
                let errorString = 'You have already filled the data for this student. If you think this is a mistake fill the support form';
                const event = new ShowToastEvent({
                    title: 'Error!',
                    message: errorString,
                    variant: 'error'
                });                
                this.dispatchEvent(event);
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
                this.getApexRecordCDM1();
                this.studentPresent = true;
            }
        }while(false);

        this.flag = 'handleClick';
        console.log('this.flag : ' + this.flag);
    }
}