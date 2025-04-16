import { LightningElement,track, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import searchStudentRecords from '@salesforce/apex/InterestDetailsHandler.searchStudentRecords';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import saveData from '@salesforce/apex/InterestDetailsHandler.saveData';
import getRecordApt from '@salesforce/apex/InterestDetailsHandler.getRecordApt';
import getStudentName from '@salesforce/apex/InterestDetailsHandler.getStudentName';
import getInterestRecord from '@salesforce/apex/idSummary.getInterestRecord';

export default class NgFormInterestStudentDetailsFormV2 extends NavigationMixin(LightningElement) {
    title = '';
    errorTitle = '';
    successTitle = '';
    successMsg = '';
    isEnglish;
    lng;
    typ;
    showForm = true;
    selectedBatchId = '';
    selectedGrade = '';
    logedInFacilitatorEmail = '';
    seletedSchoolName = '';
    selectedSchoolAccountId = '';
    selectedBatchCode='';
    studentName='';
    studentSearchComponentLabel = 'Type the first 4 letters of the student name and wait for the drop down to select the student'
    @track showStudentList = false;
    @track studentDisplay = [];
    @track studentSearchResult = '';
    studentSearchText = '';
    submittedStudentMapKeys = [];
    saveFlag = false;

    interestCode1Value='';
    interestCode2Value='';
    interestCode3Value='';
    showLoading = true;
    isShowModal=false;
    submitBtnHandler(event){
        //TODO: Show Toast Message
        console.log(this.interestCode1Value);
        if(this.interestCode1Value === '' || this.interestCode2Value == '' || this.interestCode3Value == '' || this.interestCode1Value === undefined || this.interestCode2Value === undefined || this.interestCode3Value === undefined){
            this.showToastPopMessage(this.errorTitle,'Please fill all the mandatory(*) fields','error');
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
                    this.cdm1NavigateToInternalPage();
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
        this.delayTimeOut05 = setTimeout(() => {
            this.showLoading=false;
        }, 800);
        this.getstudentData();
        this.showLoading = false;
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

    getRecordAptFun(){
        console.log('this.rxStudentId=',this.rxStudentId);
        getRecordApt({
            studentId : this.rxStudentId
        }).then(result => {
            console.log('awarenessData = '+result.Interest_1__c);
            if(result){
                console.log('$$$ getRecordApt: ',result);
                //this.showForm = true;
                this.showLoading = false;
                this.interestCode1Value = result.Interest_1__c;
                this.interestCode2Value = result.Interest_2__c;
                this.interestCode3Value = result.Interest_3__c; 
                //this.studentName = result.Student__r.Name;
                setTimeout(() => {
                    this.checkHandler('lightning-input.interestcode1',this.interestCode1Value);
                    this.checkHandler('lightning-input.interestcode2',this.interestCode2Value);
                    this.checkHandler('lightning-input.interestcode3',this.interestCode3Value);
                }, 1000);
            }
        }).catch(error => {
            //this.showForm = true;
            this.showLoading = false;
            console.log('error123=', error);
        });
    }
    interestCodeHandler(event){
        let interestCodeName = event.target.name;

        if(interestCodeName === 'interestcode1'){
            let isChecked = this.checkHandler('lightning-input.interestcode1',event.target.dataset.value);
            if(isChecked)this.interestCode1Value = event.target.dataset.value;
        }
        else if(interestCodeName === 'interestcode2'){
            let isChecked = this.checkHandler('lightning-input.interestcode2',event.target.dataset.value);
            if(isChecked)this.interestCode2Value = event.target.dataset.value;
        }
        else if(interestCodeName === 'interestcode3'){
            let isChecked = this.checkHandler('lightning-input.interestcode3',event.target.dataset.value);
            if(isChecked)this.interestCode3Value = event.target.dataset.value;
        }
        console.log('### interestCodeName',interestCodeName);
        //clearTimeout(this.timeoutId);
        //this.timeoutId = setTimeout(this.saveData.bind(this,false), 5000); 
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
    saveData(){
        var formType = '';
        if(this.typ == 'v2'){
            formType = 'Form V2';
        }else if(this.typ == 'v1'){
            formType = 'Form V1';
        }else{
            formType = '';
        }
        
        saveData({
            studentId : this.rxStudentId,
            apt1 : this.interestCode1Value,
            apt2 : this.interestCode2Value,
            apt3 : this.interestCode3Value,
            grade: this.selectedGrade,
            saveFlag : true,
            typ : formType, 
            lng : this.lng
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
       if(currentPageReference) {
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
            console.log('this.rxStudentId para = ',this.rxStudentId)
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
        this.studentSearchText = event.detail.value;
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
                this.showToastPopMessage(this.errorTitle,rxError,'error')            
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

    get interestCodeOptions() {
        return [
            { label: 'Doing (Realistic)', value: 'Realistic' },
            { label: 'Solving (Investigative)', value: 'Investigative' },
            { label: 'Creating (Artistic)', value: 'Artistic' },
            { label: 'Helping (Social)', value: 'Social' },
            { label: 'Leading (Enterprising)', value: 'Enterprising' },
            { label: 'Organising (Conventional)', value: 'Conventional' },
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }
}