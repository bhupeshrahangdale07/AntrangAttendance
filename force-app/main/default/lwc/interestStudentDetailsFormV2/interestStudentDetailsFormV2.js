import { LightningElement,track, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import searchStudentRecords from '@salesforce/apex/InterestDetailsHandler.searchStudentRecords';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import saveDataForFormV2 from '@salesforce/apex/InterestDetailsHandler.saveDataForFormV2';
import getRecordApt from '@salesforce/apex/InterestDetailsHandler.getRecordApt';
import getAssesmentQuestion from '@salesforce/apex/AssesementQuestionController.getAssesmentQuestion';
import getStudentName from '@salesforce/apex/InterestDetailsHandler.getStudentName';
import getInterestRecord from '@salesforce/apex/idSummary.getInterestRecord';

export default class InterestStudentDetailsFormV2 extends NavigationMixin(LightningElement) {
    title = '';
    errorTitle = '';
    successTitle = '';
    successMsg = '';
    getAssesmentQuestion=[];
    isEnglish;
    lng;
    typ;
    yesLabel;
    noLabel;
    showForm = true;
    selectedBatchId = '';
    selectedGrade = '';
    logedInFacilitatorEmail = '';
    seletedSchoolName = '';
    selectedSchoolAccountId = '';
    selectedBatchCode='';
    studentName='';
    studentSearchComponentLabel = '';
    @track showStudentList = false;
    @track studentDisplay = [];
    @track studentSearchResult = '';
    studentSearchText = '';
    submittedStudentMapKeys = [];
    saveFlag = false;
    instructions='';
    showLoading = true;
    isShowModal=false;
    submitBtnHandler(event){
        //TODO: Show Toast Message
        this.showLoading=true;console.log('interestCodeValue = ',this.interestCodeValue)
        console.log('interestCodeValue = ',this.interestCodeValue);
        const hasEmptyAnswer = this.interestCodeValue.some(item => item.answer === '');
        console.log('hasEmptyAnswer = ',hasEmptyAnswer)
        var errorsQuestions = [];
        this.interestCodeValue.forEach(item => {
            if(item.answer === ''){
                errorsQuestions.push(item.question);
            }
        });

        if(hasEmptyAnswer){
            this.showLoading=false;
            this.saveFlag = false;
            if(this.isEnglish){
                //this.showToastPopMessage('Error!','Please fill all the mandatory(*) fields','error');
                this.showToastPopMessage(this.errorTitle,'Please answer all the mandatory(*) question(s) '+errorsQuestions.join(', '),'error');
            }else{
                // this.showToastPopMessage('गलती!','कृपया सभी अनिवार्य(*) फ़ील्ड भरें','error');
                this.showToastPopMessage('गलती!','कृपया सभी अनिवार्य (*) फ़ील्ड भरें'+errorsQuestions.join(', '),'error');
            }
        }else{
            this.saveFlag = true;
            //this.saveData();
            getInterestRecord({
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
            
        } 
    }
    connectedCallback(){
        this.delayTimeOut05 = setTimeout(() => {
            this.showLoading=false;
        }, 800);
        this.getAssesmentQuestionFunc();
        this.getstudentData();
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
        this.showLoading = false;
    }
    //This method is called to get all questions
    getAssesmentQuestionFunc(){
        getAssesmentQuestion({
            objectName : 'Interest',
            formType : 'Form V2',
            grade : ''
        }).then(result => {
            let removedItem = result.shift();
            this.getAssesmentQuestion = result;
            console.log('removedItem =',removedItem)
            this.instructions = (this.isEnglish === true) ? removedItem.Question_Label_English__c : removedItem.Question_Label_Hindi__c;
            
        }).catch(error => {
            console.log('getAssesmentQuestion Error = ',error);
        });
    }
    getstudentData(){
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
    onclickBack(event){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'InterestDataSummaryV2__c'
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
            //console.log('awarenessData = '+result['Interest_Test_1__c']);
            if(result){
                console.log('$$$ getRecordApt: ',result);
                //this.showForm = true;
                this.showLoading = false;
                
                    setTimeout(() => {
                        for(var i=1;i<=48;i++){
                        let className = 'lightning-input.\\3'+i.toString().split('').join(' ');
                        let ind = 'Interest_Test_'+i+'__c';
                        let dataValue = (result[ind] === 'A') ? 1 : (result[ind] === 'B') ? 2 : (result[ind] === '*') ? 3 : '';
                        let opt = {question : i, answer : dataValue};
                        this.interestCodeValue.push(opt);
                        this.checkHandler(className,dataValue);
                        }
                    }, 1000);
                
               
            }
        }).catch(error => {
            //this.showForm = true;
            this.showLoading = false;
            //console.log('error123=', error);
        });
    }
    interestCodeValue = [];
    interestCodeHandler(event){
        
        let interestCodeName = event.target.name;
        let className = 'lightning-input.\\3'+event.target.name.toString().split('').join(' ');
        let isChecked = this.checkHandler(className,event.target.dataset.value);
       
        let existingIndex = this.interestCodeValue.findIndex(item => item.question === event.target.name);
        if(isChecked) {
            let opt = {question : event.target.name, answer : event.target.dataset.value};
            if (existingIndex !== -1) {
                // If the entry already exists, update it
                this.interestCodeValue[existingIndex] = opt;
            } else {
                // If the entry doesn't exist, add it to the array
                this.interestCodeValue.push(opt);
            }
        }

       
        //clearTimeout(this.timeoutId);
        // this.timeoutId = setTimeout(this.saveData.bind(this,false), 5000); 
    }
   
    checkHandler(queString, dataValue){
        
        Array.from(this.template.querySelectorAll(queString))
            .forEach(element => {
                element.checked=false;
            });
            const checkbox1 = this.template.querySelector(queString+'[data-value="'+dataValue+'"]');
            console.log('checkbox1 = ',checkbox1)
            if(checkbox1){
                checkbox1.checked=true; 
                return true;
            }
    }
    calculateAnswer(j,k){
        let cal=0;
        for(var i=j;i<=k;i++){
            if(this.interestCodeValue[i].answer == 1)
            cal += this.interestCodeValue[i].answer == 1 ? 1 : 0;
        }
        return cal;
    }
    saveData(){
        console.log('interestCodeValue = ',this.interestCodeValue);
        let copyOfinterestCodeValue = [...this.interestCodeValue]
        const answerMapping = {
        '1': 'A',
        '2': 'B',
        '3': '*',
        4: '',
        };
        console.log('answerMapping = ',answerMapping[4]);
        copyOfinterestCodeValue = copyOfinterestCodeValue.map(item => {
            return {
            question: item.question,
            answer: (item.answer == '4') ? '' : answerMapping[item.answer] ,
            };
        });
        let interest1 = '';
        let interest2 = '';
        let interest3 = '';
        if(this.saveFlag == true){
            let Realistic = this.calculateAnswer(0,7);
            let Investigative = this.calculateAnswer(8,15);
            let Artistic = this.calculateAnswer(16,23);
            let Social = this.calculateAnswer(24,31);
            let Enterprising = this.calculateAnswer(32,39);
            let Conventional = this.calculateAnswer(40,47);
           console.log('Realistic = ',this.calculateAnswer(0,7))
            console.log('Investigative =', this.calculateAnswer(8,15))
            console.log('Artistic = ',this.calculateAnswer(16,23))
            console.log('Social = ',this.calculateAnswer(24,31))
            console.log('Enterprising = ',this.calculateAnswer(32,39))
            console.log('Conventional = ',this.calculateAnswer(40,47))
            const valuesObject = {
                Realistic,
                Investigative,
                Artistic,
                Social,
                Enterprising,
                Conventional
            };
            const valuesArray = Object.entries(valuesObject).map(([name, value]) => ({ name, value }));
            valuesArray.sort((a, b) => b.value - a.value);
            const top3MaxValues = valuesArray.slice(0, 3);
            console.log('top3MaxValues = ',top3MaxValues)
            if (top3MaxValues[0] !== undefined) {
                interest1 = (top3MaxValues[0].value != 0) ? top3MaxValues[0].name : '';
            }
            if (top3MaxValues[1] !== undefined) {
                interest2 = (top3MaxValues[1].value != 0) ? top3MaxValues[1].name : '';
            }
            if (top3MaxValues[2] !== undefined) {
                interest3 = (top3MaxValues[2].value != 0) ? top3MaxValues[2].name : '';
            }
            
        }
        saveDataForFormV2({
            studentId : this.rxStudentId,
            answerSet : JSON.stringify(copyOfinterestCodeValue),
            grade: this.selectedGrade,
            saveFlag : this.saveFlag,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? 'Form V2' : 'Form V1',
            lng : this.lng,
            interest1 : interest1,
            interest2 : interest2,
            interest3 : interest3
        }).then(result => {
           console.log('res = ',result);
            this.showToastPopMessage(this.successTitle,this.successMsg,'success');
            //this.backBtnNavigationHelper();
            setTimeout(() => {
                this.backBtnNavigationHelper();
            }, 1000);
        }).catch(error => {
            console.log('error=', error);
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
          //if(this.lng == 'English') this.isEnglish = true; else this.isEnglish = false;
          this.isEnglish = (this.lng == 'English') ? true : false;
          this.rxBatch = this.selectedBatchId;
          this.rxGrade = this.selectedGrade;
          this.rxStudentId = decodeURI(currentPageReference.state.studentId);
          this.getRecordAptFun();
          if(this.selectedBatchId){
                getBatchCodeName({
                    batchId : this.selectedBatchId
                }).then(result => {
                    this.selectedBatchNumber = result.Batch_Number__c;
                    this.selectedBatchCode = result.Name;
                    // this.schoolName = result.School_Name__r.Name;        
                }).catch(error => {
                    console.log('error 123 = ', error);
                });
            }
            if(this.isEnglish){
                this.title = 'Interest';
                this.errorTitle = 'Error';
                this.successMsg ='Interest - Student data has been saved';
                this.successTitle = 'Success'
            }else{
                this.title = 'आधारभूत करियर के निर्णय - 1 डेटा';
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
                    this.studentSearchResult = 'Enter atleast 4 characters of Student Name';
                }else{
                    this.studentSearchResult = 'छात्र नाम के कम से कम 4 अक्षर दर्ज करें';
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
                console.log('Print error : ' + rxError);
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
                name: 'interest_assessment_V2__c'
            },
            state:{
                fem : encodeURI(this.logedInFacilitatorEmail),
                sch : encodeURI(this.seletedSchoolName),
                grd : encodeURI(this.selectedGrade), 
                bid : encodeURI(this.selectedBatchId),
                acid : encodeURI(this.selectedSchoolAccountId),
                lng : encodeURI(this.lng),
                typ : encodeURI(this.typ) 
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