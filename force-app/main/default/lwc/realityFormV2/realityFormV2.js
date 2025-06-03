import { LightningElement,track, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import searchStudentRecords from '@salesforce/apex/RealityController.searchStudentRecords';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import saveData from '@salesforce/apex/RealityController.saveData';
import getRecordApt from '@salesforce/apex/RealityController.getRecordApt';
import getRealityRecord from '@salesforce/apex/RealityController.getRealityRecord';
import getRealityQuestion from '@salesforce/apex/AssesementQuestionController.getAssesmentQuestion';

export default class RealityFormV2 extends NavigationMixin(LightningElement)  {
    title = '';
    errorTitle = '';
    successTitle = '';
    successMsg = '';
    RealityQuestions = {'Self' : [], 'Family' : []};
    RealityAnswers = {'Q1' : '', 'Q2' : '', 'Q3' : '', 'Q4' : '', 'Q5' : '', 'Q6' : '', 'Q7' : '', 'Q8' : ''};
    lng;
    typ;
    yesLabel;
    noLabel;
    errorTitle;
    showForm = true;
    selectedBatchId = '';
    selectedGrade = '';
    logedInFacilitatorEmail = '';
    seletedSchoolName = '';
    selectedSchoolAccountId = '';
    selectedBatchCode='';
    selectedBatchNumber ='';
    studentSearchComponentLabel = 'Type the first 4 letters of the student name and wait for the drop down to select the student'
    studentName = '';
    recordId='';
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

    get selfForm(){
        return this.isEnglish ? 'Self Form' : 'स्वरुप';
    }

    get familyForm(){
        return this.isEnglish ? 'Family Form' : 'पारिवारिक स्वरूप';
    }    

    submitBtnHandler(event){
        //TODO: Show Toast Message
        this.showLoading = true;
        const errorsQuestions = Object.keys(this.RealityAnswers).filter(key => this.RealityAnswers[key] === '');
        if(errorsQuestions.length > 0){
            this.showLoading = false;
            if(this.isEnglish){
                //this.showToastPopMessage('Error!','Please fill all the mandatory(*) fields','error');
                //this.showToastPopMessage(this.errorTitle,'Please answer all the mandatory(*) question(s) : '+errorsQuestions.join(', '),'error');
                this.showToastPopMessage(this.errorTitle,'Please choose answers for questions: '+errorsQuestions.join(', '),'error');
            }else{
                // this.showToastPopMessage('गलती!','कृपया सभी अनिवार्य(*) फ़ील्ड भरें','error');
                this.showToastPopMessage(this.errorTitle,'कृपया सभी अनिवार्य(*) प्रश्नों के उत्तर दें : '+errorsQuestions.join(', '),'error');
            }
        }else{
            this.saveFlag = true;
            //this.saveData();
            getRealityRecord({
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
                    this.errorTitle = 'Reality';
                    this.rxError = 'Error while receiving student records';
                }else{
                    this.errorTitle = 'वास्तविकता';
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
        }
        
        
    }
    connectedCallback(){
        this.delayTimeOut05 = setTimeout(() => {
            this.showLoading=false;
        }, 800);
        this.getRealityQuestionFunc();
        if(this.isEnglish){
            this.studentSearchResult = 'Please enter Student here';
            this.studentSearchComponentLabel = 'Type the first 4 letters of the student name and wait for the drop down to select the student';
            this.yesLabel = 'Yes';
            this.noLabel = 'No';
        }else{
            this.studentSearchResult = 'कृपया यहां छात्र दर्ज करें';
            this.studentSearchComponentLabel = 'छात्र के नाम के पहले 4 अक्षर टाइप करें और छात्र का चयन करने के लिए ड्रॉप डाउन की प्रतीक्षा करें';
            this.yesLabel = 'हाँ';
            this.noLabel = 'नहीं';
        }
    }

    //This method is called to get all questions
    getRealityQuestionFunc(){
        getRealityQuestion({
            objectName : 'Self Awareness Realities',
            formType : 'Form V2',
            grade : ''
        }).then(result => {
            //let removedItem = result.shift();
            //this.RealityQuestions = result;

            var SelfQuestions = [];
            var FamilyQuestions = [];
            var RealityAnswer = {};//{'Q1' : '', 'Q2' : '', 'Q3' : '', 'Q4' : '', 'Q5' : '', 'Q6' : '', 'Q7' : '', 'Q8' : ''};
            result.forEach(function (currentItem, index){
                var key = 'Q'+(index+1);
                RealityAnswer[key] = '';

                if(currentItem.Sequence_Number__c <= 4){
                    SelfQuestions.push(currentItem);
                }else{
                    FamilyQuestions.push(currentItem);
                }
                

            });
            this.RealityQuestions.Self = SelfQuestions;
            this.RealityQuestions.Family = FamilyQuestions;
            this.RealityAnswers = RealityAnswer;

            // console.log('removedItem =',removedItem)
            // this.instructions = (this.isEnglish === true) ? removedItem.Question_Label_English__c : removedItem.Question_Label_Hindi__c;
            this.getRecordAptFun();
        }).catch(error => {
            console.log('getAssesmentQuestion Error = ',error);
        });
    }


    handleCheckBox(event){
        let className = 'lightning-input.\\3'+event.target.name.toString().split('').join(' ');
        let isChecked = this.checkHandler(className,event.target.dataset.value);
       
        // let existingIndex = this.interestCodeValue.findIndex(item => item.question === event.target.name);
        // if(isChecked) {
        //     let opt = {question : event.target.name, answer : event.target.dataset.value};
        //     if (existingIndex !== -1) {
        //         // If the entry already exists, update it
        //         this.interestCodeValue[existingIndex] = opt;
        //     } else {
        //         // If the entry doesn't exist, add it to the array
        //         this.interestCodeValue.push(opt);
        //     }
        // }

        let questionSequence = 'Q'+event.target.name;
        let selectedCheckboxSequence = event.target.dataset.value;
        this.RealityAnswers[questionSequence] = selectedCheckboxSequence;

         if(event.target.name == '1'){
             this.selfQue1Value = this.getOption(event.target.name, event.target.dataset.value); //event.target.dataset.value;
         }else if(event.target.name == '2'){
             this.selfQue2Value = this.getOption(event.target.name, event.target.dataset.value); //event.target.dataset.value;
         }else if(event.target.name == '3'){
             this.selfQue3Value = this.getOption(event.target.name, event.target.dataset.value); //event.target.dataset.value;
         }else if(event.target.name == '4'){
             this.selfQue4Value = this.getOption(event.target.name, event.target.dataset.value); //event.target.dataset.value;
         }else if(event.target.name == '5'){
             this.familyQue1Value = this.getOption(event.target.name, event.target.dataset.value); //event.target.dataset.value;
         }else if(event.target.name == '6'){
             this.familyQue2Value = this.getOption(event.target.name, event.target.dataset.value); //event.target.dataset.value;
         }else if(event.target.name == '7'){
             this.familyQue3Value = this.getOption(event.target.name, event.target.dataset.value); //event.target.dataset.value;
         }else if(event.target.name == '8'){
             this.familyQue4Value = this.getOption(event.target.name, event.target.dataset.value); //event.target.dataset.value;
         }

        //clearTimeout(this.timeoutId);
        // this.timeoutId = setTimeout(this.saveData.bind(this,false), 5000); 
    }

    getOption(questionNumber, value){
        if(questionNumber == '4'){
            switch (value) {
                case '1':
                    return 'A';
                case '2':
                    return 'B';
                case '3':
                    return 'C';
                case '4':
                    return '*';
                case '5':
                    return '';//'NoAnswer';
                default:
                    return '';
            }
        } else if(questionNumber == '8'){
            switch (value) {
                case '1':
                    return 'A';
                case '2':
                    return 'B';
                case '3':
                    return 'C';
                case '4':
                    return 'D';
                case '5':
                    return '*';
                case '6':
                    return '';//'NoAnswer';
                default:
                    return '';
            }
        } else{
            switch (value) {
                case '1':
                    return 'A';
                case '2':
                    return 'B';
                case '3':
                    return '*';
                case '4':
                    return '';//'NoAnswer';
                default:
                    return '';
            }
        }
    }

    getSequenceNumber(questionNumber, value){
        
        var returnVal = '';
        if(questionNumber == '4'){
            switch (value) {
                case 'A':
                    returnVal = '1';break;
                case 'B':
                    returnVal =  '2';break;
                case 'C':
                    returnVal =  '3';break;
                case '*':
                    returnVal =  '4';break;
                case 'NoAnswer':
                    returnVal =  '5';break;
                default:
                    returnVal =  '';break;
            }
        } else if(questionNumber == '8'){
            switch (value) {
                case 'A':
                    returnVal =  '1';break;
                case 'B':
                    returnVal =  '2';break;
                case 'C':
                    returnVal =  '3';break;
                case 'D':
                    returnVal =  '4';break;
                case '*':
                    returnVal =  '5';break;
                case 'NoAnswer':
                    returnVal =  '6';break;
                default:
                    returnVal =  '';break;
            }
        } else{
            switch (value) {
                case 'A':
                    returnVal =  '1'; break;
                case 'B':
                    returnVal =  '2'; break;
                case '*':
                    returnVal =  '3'; break;
                case 'NoAnswer':
                    returnVal =  '4'; break;
                default:
                    returnVal =  ''; break;
            }
        }

        var questionSequence = 'Q'+questionNumber;
        this.RealityAnswers[questionSequence] = returnVal;
        return returnVal;
    }

    onclickBack(event){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'Reality_Details_V2__c'
            },
            state:{
                fem : encodeURI(this.logedInFacilitatorEmail),
                sch : encodeURI(this.seletedSchoolName),
                grd : encodeURI(this.selectedGrade), 
                bid : encodeURI(this.selectedBatchId),
                acid : encodeURI(this.selectedSchoolAccountId) ,
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
            grade : this.selectedGrade,
            batchId : this.selectedBatchId
        }).then(result => {
            console.log('result = ',result)
            if(result){
                this.showForm = true;
                if(this.saveFlag == false) this.showLoading = false;
                this.selfQue1Value = result.Reality1_Self_1__c;
                this.selfQue2Value = result.Reality_2_Self_2__c;
                this.selfQue3Value = result.Reality_3_Self_3__c;
                this.selfQue4Value = result.Reality_4_Self_4__c;
                this.familyQue1Value = result.Reality_5_Family_1__c;
                this.familyQue2Value = result.Reality_6_Family_2__c;
                this.familyQue3Value = result.Reality_7_Family_3__c;
                this.familyQue4Value = result.Reality_8_Family_4__c;
                this.studentName = result.Student__r.Name;
                this.recordId = result.id;
                // setTimeout(() => {
                    // this.checkHandler('lightning-input.selfQue1',this.selfQue1Value);
                    // this.checkHandler('lightning-input.selfQue2',this.selfQue2Value);
                    // this.checkHandler('lightning-input.selfQue3',this.selfQue3Value);
                    // this.checkHandler('lightning-input.selfQue4',this.selfQue4Value);
                    // this.checkHandler('lightning-input.familyQue1',this.familyQue1Value);
                    // this.checkHandler('lightning-input.familyQue2',this.familyQue2Value);
                    // this.checkHandler('lightning-input.familyQue3',this.familyQue3Value);
                    // this.checkHandler('lightning-input.familyQue4',this.familyQue4Value);

                    setTimeout(() => {
                        for(var i=1;i<=8;i++){
                            let className = 'lightning-input.\\3'+i.toString().split('').join(' ');
                            this.populateAnswers(i, className);
                            
                        }
                    }, 1000);


                // }, 1000);
                if(this.saveFlag == true){
                    // this.marksCalculation();
                    setTimeout(() => {
                        this.backBtnNavigationHelper();
                    }, 500);
                } 
            }
        }).catch(error => {
            this.showForm = true;
            this.showLoading = false;
            console.log('error123=', error);
            //this.showToastPopMessage('Error!',error,'error')

        });
    }

    // marksCalculation(){
    //      submitAndCalculate({
    //         recordIdCMD1 : this.recordId
    //     }).then(result => {
    //         console.log('res = ',result);
    //          if(this.isEnglish){
    //             this.showToastPopMessage('Reality Data','Student Data is saved','success');
    //         }else{
    //             this.showToastPopMessage('वास्तविकता डेटा','छात्र डेटा सहेजा गया है','success');
    //         }

    //         setTimeout(() => {
    //             this.backBtnNavigationHelper();
    //         }, 1000);
           
    //         this.showLoading = false;
    //     }).catch(error => {
    //         console.log('error=', error);
    //         this.showToastPopMessage('Error!',error,'error')
    //     });
    // }

    populateAnswers(i, className){
        switch (i.toString()) {
            case '1':
                return this.checkHandler(className, this.getSequenceNumber(i.toString(), this.selfQue1Value));
            case '2':
                return this.checkHandler(className, this.getSequenceNumber(i.toString(), this.selfQue2Value));
            case '3':
                return this.checkHandler(className, this.getSequenceNumber(i.toString(), this.selfQue3Value));
            case '4':
                return this.checkHandler(className, this.getSequenceNumber(i.toString(), this.selfQue4Value));
            case '5':
                return this.checkHandler(className, this.getSequenceNumber(i.toString(), this.familyQue1Value));
            case '6':
                return this.checkHandler(className, this.getSequenceNumber(i.toString(), this.familyQue2Value));
            case '7':
                return this.checkHandler(className, this.getSequenceNumber(i.toString(), this.familyQue3Value));
            case '8':
                return this.checkHandler(className, this.getSequenceNumber(i.toString(), this.familyQue4Value));
            default:
                return '';
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
        saveData({
            batchId : this.selectedBatchId,
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
            grade : this.selectedGrade,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? 'Form V2' : 'Form V1',
            lng : this.lng,
        }).then(result => {
           if(result){

               this.getRecordAptFun();
                this.showToastPopMessage(this.successTitle,this.successMsg,'success');
                this.backBtnNavigationHelper();
           }
        }).catch(error => {
            console.log('error=', error);
            this.showToastPopMessage(this.errorTitle,error,'error')
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
          this.rxBatch = this.selectedBatchId;
          this.rxGrade = this.selectedGrade;
            this.rxStudentId = decodeURI(currentPageReference.state.studentId);

            this.studentName = decodeURI(currentPageReference.state.stdName);

            console.log('this.rxStudentId  =',this.rxStudentId )
            this.isEnglish = (this.lng == 'English') ? true : false;

          if(this.selectedBatchId){
                getBatchCodeName({
                    batchId : this.selectedBatchId
                }).then(result => {
                    this.selectedBatchCode = result.Name;
                    this.selectedBatchNumber = result.Batch_Number__c;
                    // this.schoolName = result.School_Name__r.Name;        
                }).catch(error => {
                    console.log('error 123 = ', error);
                    this.showToastPopMessage(this.errorTitle,error,'error')
                });
            }
            if(this.isEnglish){
                this.title = 'Reality';
                this.errorTitle = 'Error';
                this.successMsg ='Reality - Student data has been saved';
                this.successTitle = 'Success'
            }else{
                this.title = 'वास्तविकता';
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
                let rxError = 'Error while searching student';
                if(this.isEnglish){
                    rxError = 'Error while searching student';
                }else{
                    rxError = 'छात्र को खोजते समय त्रुटि';
                }

                if (Array.isArray(error.body)) {
                    rxError = error.body.map(e => e.message).join(', ');
                } else if (typeof error.body.message === 'string') {
                    rxError = error.body.message;
                }
                //console.log('Print error : ' + rxError);
                // this.showToastPopMessage('Error!',rxError,'error')
              
              if(this.isEnglish){
                    this.showToastPopMessage(this.errorTitle,rxError,'error')
                }else{
                    this.showToastPopMessage(this.errorTitle,rxError,'error')
                }   

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
                // let errorString = 'You have already filled the data for this student. If you think this is a mistake fill the support form';
                // this.showToastPopMessage('Error!',errorString,'error');

                let errorString = '';
                if(this.isEnglish){
                    errorString = 'You have already filled the data for this student. If you think this is a mistake fill the support form';
                    this.showToastPopMessage(this.errorTitle,errorString,'error');
                }else{
                    errorString = 'आप इस छात्र का डेटा पहले ही भर चुके हैं. यदि आपको लगता है कि यह एक गलती है तो सहायता फ़ॉर्म भरें';
                    this.showToastPopMessage(this.errorTitle,errorString,'error');
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
                name: 'Reality_Details_V2__c'
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