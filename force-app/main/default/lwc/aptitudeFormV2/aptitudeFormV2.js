import { LightningElement,track, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import searchStudentRecords from '@salesforce/apex/ApptitudeController.searchStudentRecords';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import saveDataForFormV2 from '@salesforce/apex/ApptitudeController.saveDataForFormV2';
import getRecordApt from '@salesforce/apex/ApptitudeController.getRecordApt';
import getAssesmentQuestion from '@salesforce/apex/AssesementQuestionController.getAssesmentQuestion';
import getStudentName from '@salesforce/apex/ApptitudeController.getStudentName';
import AptitudeQ43 from "@salesforce/resourceUrl/AptitudeQ43";  
import AptitudeQ42 from "@salesforce/resourceUrl/AptitudeQ42";
import AptitudeQ32 from "@salesforce/resourceUrl/AptitudeQ32";
import AptitudeQ31 from "@salesforce/resourceUrl/AptitudeQ31";
import AptitudeQ30 from "@salesforce/resourceUrl/AptitudeQ30";
import AptitudeQ29 from "@salesforce/resourceUrl/AptitudeQ29";
import AptitudeQ28 from "@salesforce/resourceUrl/AptitudeQ28";
import AptitudeQ27 from "@salesforce/resourceUrl/AptitudeQ27";
import AptitudeQ26 from "@salesforce/resourceUrl/AptitudeQ25";
import AptitudeQ25 from "@salesforce/resourceUrl/AptitudeQ26";
import AptitudeQ24 from "@salesforce/resourceUrl/AptitudeQ24";
import AptitudeQ23 from "@salesforce/resourceUrl/AptitudeQ23";
import AptitudeQ22 from "@salesforce/resourceUrl/AptitudeQ22";
import AptitudeQ21 from "@salesforce/resourceUrl/AptitudeQ21";
import AptitudeQ20 from "@salesforce/resourceUrl/AptitudeQ20";
import AptitudeQ19 from "@salesforce/resourceUrl/AptitudeQ19";
import AptitudeQ18 from "@salesforce/resourceUrl/AptitudeQ18";
import AptitudeQ17 from "@salesforce/resourceUrl/AptitudeQ17";
import AptitudeQ8 from "@salesforce/resourceUrl/AptitudeQ8";
import AptitudeQ7 from "@salesforce/resourceUrl/AptitudeQ7";
import AptitudeQ6 from "@salesforce/resourceUrl/AptitudeQ6";
import AptitudeQ5 from "@salesforce/resourceUrl/AptitudeQ5";
import AptitudeQ4 from "@salesforce/resourceUrl/AptitudeQ4";
import AptitudeQ3 from "@salesforce/resourceUrl/AptitudeQ3";
import AptitudeQ2 from "@salesforce/resourceUrl/AptitudeQ1";
import AptitudeQ1 from "@salesforce/resourceUrl/AptitudeQ2";
import getApptitudeRecord from '@salesforce/apex/ApptitudeController.getApptitudeRecord';

export default class AptitudeFormV2 extends NavigationMixin(LightningElement) {
    title = '';
    errorTitle = '';
    successTitle = '';
    successMsg = '';
    imageMapping = {1:AptitudeQ1,
                2:AptitudeQ2,
                3:AptitudeQ3,
                4:AptitudeQ4,
                5:AptitudeQ5,
                6:AptitudeQ6,
                7:AptitudeQ7,
                8:AptitudeQ8,
                17:AptitudeQ17,
                18:AptitudeQ18,
                19:AptitudeQ19,
                20:AptitudeQ20,
                21:AptitudeQ21,
                22:AptitudeQ22,
                23:AptitudeQ23,
                24:AptitudeQ24,
                25:AptitudeQ25,
                26:AptitudeQ26,
                27:AptitudeQ27,
                28:AptitudeQ28,
                29:AptitudeQ29,
                30:AptitudeQ30,
                31:AptitudeQ31,
                32:AptitudeQ32,
                42:AptitudeQ42,
                43:AptitudeQ43,
    }
    lng;
    isEnglish;
    yesLabel;
    noLabel;
    studentNameError;
    typ;
    showForm = true;
    selectedBatchId = '';
    selectedGrade = '';
    logedInFacilitatorEmail = '';
    seletedSchoolName = '';
    selectedSchoolAccountId = '';
    selectedBatchCode='';
    studentSearchComponentLabel = '';
    studentName = '';
    @track showStudentList = false;
    @track studentDisplay = [];
    @track studentSearchResult = '';
    studentSearchText = '';
    submittedStudentMapKeys = [];
    saveFlag = false;
    selectedBatchNumber='';
    isEnglish ;

    aptitude1Value='';
    aptitude2Value='';
    aptitude3Value='';
    showLoading = true;
    isShowModal=false;
    aptitudeCodeValue = [];
    submitBtnHandler(event){
        //TODO: Show Toast Message
        this.showLoading = true;
        console.log('aptitudeCodeValue = ',this.aptitudeCodeValue);
        const hasEmptyAnswer = this.aptitudeCodeValue.some(item => item.answer === '');

        var errorsQuestions = [];
        this.aptitudeCodeValue.forEach(item => {
            if(item.answer === ''){
                errorsQuestions.push(item.question);
            }
        });

        if(hasEmptyAnswer){
            this.saveFlag = false;
            this.showLoading = false;
            if(this.isEnglish){
                // this.showToastPopMessage('Error!','Please fill all the mandatory(*) fields','error');
                this.showToastPopMessage(this.errorTitle,'Please answer all the mandatory(*) question(s) '+errorsQuestions.join(', '),'error');
            }else{
                // this.showToastPopMessage('गलती!','कृपया सभी अनिवार्य(*) फ़ील्ड भरें','error');
                this.showToastPopMessage('गलती!','कृपया सभी अनिवार्य(*) प्रश्नों के उत्तर दें '+errorsQuestions.join(', '),'error');
            }
        }else{
            this.saveFlag = true;
            //this.saveData();
            getApptitudeRecord({
                studentId : this.rxStudentId,
                grade : this.selectedGrade,
                batchId : this.selectedBatchId,
            })
            .then(result => {
                this.showLoading = false;
                if(result === 'found'){
                    if(this.isEnglish){
                        const event = new ShowToastEvent({
                            title :'Error!',
                            message : 'Student data already submitted',
                            variant : 'error'
                        });
                        this.dispatchEvent(event);
                        //this.showToastPopMessage('Error!','Student data already submitted','error')
                    }else{
                        const event = new ShowToastEvent({
                            title :'गलती!',
                            message : 'छात्र का डेटा पहले ही जमा किया जा चुका है',
                            variant : 'error'
                        });
                        this.dispatchEvent(event);
                        //this.showToastPopMessage('गलती!','छात्र का डेटा पहले ही जमा किया जा चुका है','success');
                    }
                    this.backBtnNavigationHelper();
                }else{
                    if(this.selectedBatchId && this.selectedGrade){
                        this.saveData();
                    }
                }
            }).catch(error => {
                console.log(error);
                
                this.showLoading = false;
                let rxError;
                if(this.isEnglish){
                    this.errorTitle = 'योग्यता आंकड़ा';
                    this.rxError = 'Error while receiving student records';
                }else{
                    this.errorTitle = 'योग्यता आंकड़ा';
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
        setTimeout(() => {
            this.showLoading=false;
        }, 800);
        this.getAssesmentQuestionFunc();
        if(this.isEnglish){
            this.studentSearchResult = 'Please enter Student here';
            this.studentSearchComponentLabel = 'Type the first 4 letters of the student name and wait for the drop down to select the student';
            this.studentNameError = 'Enter atleast 4 characters of Student Name';
            this.yesLabel = 'Yes';
            this.noLabel = 'No';
        }else{
            this.studentSearchResult = 'कृपया यहां छात्र दर्ज करें';
            this.studentSearchComponentLabel = 'छात्र के नाम के पहले 4 अक्षर टाइप करें और छात्र का चयन करने के लिए ड्रॉप डाउन की प्रतीक्षा करें';
            this.studentNameError = 'छात्र नाम के कम से कम 4 अक्षर दर्ज करें';
            this.yesLabel = 'हाँ';
            this.noLabel = 'नहीं';
        }
    }
    //This method is called to get all questions
    getAssesmentQuestionFunc(){
        getAssesmentQuestion({
            objectName : 'Aptitude',
            formType : 'Form V2',
            grade : ''
        }).then(result => {
            
            if(result){
                for (let i = 0; i < result.length; i++) {
                    result[i]['imageSrc'] = this.imageMapping[i+1];
                }
                this.getAssesmentQuestion = result;
            }
            console.log('getAssesmentQuestion result = ',this.getAssesmentQuestion)
        }).catch(error => {
            console.log('getAssesmentQuestion Error = ',error);
        });
    }
    onclickBack(event){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'Apptitude_Details_V2__c'
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
        console.log('this.rxStudentId =',this.rxStudentId);
        getRecordApt({
            batchId : this.selectedBatchId,
            studentId : this.rxStudentId
        }).then(result => {
            console.log('result = '+JSON.stringify(result));
            // if(result){
            //     this.showForm = true;
            //     this.showLoading = false;
            //     this.aptitude1Value = result.Aptitude_1__c;
            //     this.aptitude2Value = result.Aptitude_2__c;
            //     this.aptitude3Value = result.Aptitude_3__c;
            //     //this.studentName = result.Student__r.Name;
            //     setTimeout(() => {
            //         this.checkHandler('lightning-input.Aptitude1',this.aptitude1Value);
            //         this.checkHandler('lightning-input.Aptitude2',this.aptitude2Value);
            //         this.checkHandler('lightning-input.Aptitude3',this.aptitude3Value);
            //     }, 1000);
            // }
            if(result){
                //this.showForm = true;
                this.showLoading = false;
                const fieldArray = [
                    'Spatial_Ability_Q_1__c',
                    'Spatial_Ability_Q_2__c',
                    'Spatial_Ability_Q_3__c',
                    'Spatial_Ability_Q_4__c',
                    'Spatial_Ability_Q_5__c',
                    'Spatial_Ability_Q_6__c',
                    'Spatial_Ability_Q_7__c',
                    'Spatial_Ability_Q_8__c',
                    'Numerical_1__c',
                    'Numerical_2__c',
                    'Numerical_3__c',
                    'Numerical_4__c',
                    'Numerical_5__c',
                    'Numerical_6__c',
                    'Numerical_7__c',
                    'Numerical_8__c',
                    'Mechanical_1__c',
                    'Mechanical_2__c',
                    'Mechanical_3__c',
                    'Mechanical_4__c',
                    'Mechanical_5__c',
                    'Mechanical_6__c',
                    'Mechanical_7__c',
                    'Mechanical_8__c',
                    'Abstract_Reasoning_Q_1__c',
                    'Abstract_Reasoning_Q_2__c',
                    'Abstract_Reasoning_Q_3__c',
                    'Abstract_Reasoning_Q_4__c',
                    'Abstract_Reasoning_Q_5__c',
                    'Abstract_Reasoning_Q_6__c',
                    'Abstract_Reasoning_Q_7__c',
                    'Abstract_Reasoning_Q_8__c',
                    'Verbal_1__c',
                    'Verbal_2__c',
                    'Verbal_3__c',
                    'Verbal_4__c',
                    'Verbal_5__c',
                    'Verbal_6__c',
                    'Verbal_7__c',
                    'Verbal_8__c',
                    'Creative_1__c',
                    'Creative_2__c',
                    'Creative_3__c',
                    'Creative_4__c',
                    'Creative_5__c',
                    'Creative_6__c',
                    'Creative_7__c',
                    'Creative_8__c',
                    ];
                    setTimeout(() => {
                        for(var i=1;i<=48;i++){
                        let className = 'lightning-input.\\3'+i.toString().split('').join(' ');
                        let ind = fieldArray[i-1];
                        console.log('ind = ',ind)
                        let dataValue = (result[ind] === 'A') ? 1 : (result[ind] === 'B') ? 2 : (result[ind] === 'C') ? 3 : (result[ind] === 'D') ? 4 : (result[ind] === '*') ? 5 : '';
                        let opt = {question : i, answer : dataValue};
                        this.aptitudeCodeValue.push(opt);
                        console.log('className = ',className)
                        console.log('dataValue = ',dataValue)
                        this.checkHandler(className,dataValue);
                        }
                    }, 1000);
                
               
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
    aptitudeCodeValue = [];
    aptitudeHandler(event){
        let aptitudeName = event.target.name;
        let className = 'lightning-input.\\3'+event.target.name.toString().split('').join(' ');
        let isChecked = this.checkHandler(className,event.target.dataset.value);
       
        let existingIndex = this.aptitudeCodeValue.findIndex(item => item.question === event.target.name);
        if(isChecked) {
            let opt = {question : event.target.name, answer : event.target.dataset.value};
            if (existingIndex !== -1) {
                // If the entry already exists, update it
                this.aptitudeCodeValue[existingIndex] = opt;
            } else {
                // If the entry doesn't exist, add it to the array
                this.aptitudeCodeValue.push(opt);
            }
        }

       
        // clearTimeout(this.timeoutId);
        // this.timeoutId = setTimeout(this.saveData.bind(this,false), 5000); 
    }
    saveData(){
        let copyOfaptitudeCodeValue = [...this.aptitudeCodeValue]
        const answerMapping = {
        '1': 'A',
        '2': 'B',
        '3': 'C',
        '4': 'D',
        '5': '*',
        6: ''
        };
        copyOfaptitudeCodeValue = copyOfaptitudeCodeValue.map(item => {
            return {
            question: item.question,
            answer: (item.answer == '6') ? '' : answerMapping[item.answer] ,
            };
        });
        console.log('copyOfaptitudeCodeValue = ',copyOfaptitudeCodeValue)
        saveDataForFormV2({
            studentId : this.rxStudentId,
            answerSet : JSON.stringify(copyOfaptitudeCodeValue),
            saveFlag : this.saveFlag,
            grade: this.selectedGrade,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? 'Form V2' : 'Form V1',
            lng : this.lng,
            batchId : this.selectedBatchId
        }).then(result => {
            console.log('enter')
           console.log('res = ',result);
           if(result == 'Insert' || result == 'Update' && this.saveFlag == true){
               this.showLoading = false;
                this.showToastPopMessage(this.successTitle,this.successMsg,'success');             
               //this.backBtnNavigationHelper();
                setTimeout(() => {
                    this.backBtnNavigationHelper();
                }, 1000);
           }
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
          this.isEnglish = (this.lng == 'English') ? true : false;

          this.rxBatch = this.selectedBatchId;
          this.rxGrade = this.selectedGrade;
          this.rxStudentId = decodeURI(currentPageReference.state.studentId);
          this.getRecordAptFun();
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
                this.title = 'Aptitude';
                this.errorTitle = 'Error';
                this.successMsg ='Aptitude - Student data has been saved';
                this.successTitle = 'Success'
            }else{
                this.title = 'योग्यता';
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
                let rxError = '';
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
                this.showToastPopMessage(this.errorTitle,rxError,'error');
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
                //let errorString = 'You have already filled the data for this student. If you think this is a mistake fill the support form';
                if(this.isEnglish){
                    this.showToastPopMessage(this.errorTitle,'You have already filled the data for this student. If you think this is a mistake fill the support form','error');
                }else{
                    this.showToastPopMessage(this.errorTitle,'आप इस छात्र का डेटा पहले ही भर चुके हैं. यदि आपको लगता है कि यह एक गलती है तो सहायता फ़ॉर्म भरें','error');
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
                console.log('this.rxStudentId = ',this.rxStudentId)
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
                name: 'aptitude_assessment_V2__c'
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

    get aptitudeOptions() {
        return [
            { label: 'Spatial', value: 'Spatial' },
            { label: 'Numerical', value: 'Numerical' },
            { label: 'Mechanical', value: 'Mechanical' },
            { label: 'Abstract', value: 'Abstract' },
            { label: 'Verbal', value: 'Verbal' },
            { label: 'Creative', value: 'Creative' },
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }
}