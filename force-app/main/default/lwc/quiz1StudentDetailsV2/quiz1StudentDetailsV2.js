import {LightningElement, api, wire, track} from 'lwc';
//import {getRecord} from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import getBatchInfo from '@salesforce/apex/quiz1StudentDetails.getBatchInfo';
import searchStudentRecords from '@salesforce/apex/quiz1StudentDetails.searchStudentRecords';

export default class Quiz1StudentDetailsV2 extends NavigationMixin(LightningElement) {
    lng;
    isEnglish;
    searchLabel = '';
    msg = '';
    errorTitle = '';
    typ;
    fem = null;
    sch = null;
    grd = null;
    bid = null;
    acid = null;
    //=======================================================//
    flag = '';
    antarangImage = logo_01;
    isLoading = false;
    schoolName = null;
    batchName = null;
    batchNumber=null;
    //=======================================================//
    @track studentPresent = false;
    studentName = null;
    delayTimeOut06;
    studentSearchText = '';
    @track studentSearchResult = '';
    @track studentDisplay = [];
    @track showStudentList = false;
    submittedStudentMapKeys = [];
    batchTotalStudents = 0;
    countSubmittedStudents = 0;
    //=======================================================//
    rxStudentId = null;
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
            this.typ = decodeURI(rxCurrentPageReference.state.typ);
            this.lng = decodeURI(rxCurrentPageReference.state.lng);
            this.isEnglish = (this.lng == 'English') ? true : false;
        }

        this.flag = 'getCurrentPageReference';
        console.log('this.flag : ' + this.flag);
    }

    //Standard JavaScript connectedCallback() method called on page load
    connectedCallback() 
    {
        if(this.isEnglish){
            this.studentSearchResult = 'Please enter Student here';
            this.searchLabel = 'Search Student:';
            this.errorTitle = 'Error!';
            this.msg = 'A batch is required to search for student';
        }else{
            this.studentSearchResult = 'कृपया यहां छात्र दर्ज करें';
            this.searchLabel = 'छात्र खोजें:';
            this.errorTitle = 'गलती!';
            this.msg = 'छात्र की खोज के लिए एक बैच की आवश्यकता है';
        }

        this.getBatchInformation();

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

    getBatchInformation(){ 
        this.isLoading = true;      //Turn ON the spinner        
        getBatchInfo({
            batchId : this.bid
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            const batchWrapper = JSON.parse(JSON.stringify(result));
            if(batchWrapper.batchName !== undefined)this.batchName = batchWrapper.batchName;
            if(batchWrapper.batchNumber !== undefined)this.batchNumber = batchWrapper.batchNumber;
            if(batchWrapper.schoolName !== undefined)this.schoolName = batchWrapper.schoolName;

            this.isLoading = false;             //Turn OFF the spinner
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Quiz-1 : Student details',
                message: 'Batch information received',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'getBatchInformation';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            this.isLoading = false;         //Turn OFF the spinner
            let rxError;
            if(isEnglish){
                this.rxError = 'Error while receiving batch information';
            }else{
                this.rxError = 'बैच सूचना प्राप्त करते समय त्रुटि';
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
    }

    getApexRecordSAF(){
        this.isLoading = true;   //Turn ON the spinner
        getApexRecord({
            studentId : this.rxStudentId,
            grade : this.grd
        }).then(result => {
            console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            const singleRecordWrapper = JSON.parse(JSON.stringify(result));
            if(singleRecordWrapper.studentBarcode !== undefined)
            {
                this.studentBarcode = singleRecordWrapper.studentBarcode;
            }
            else this.studentBarcode = null;

            if(singleRecordWrapper.studentName !== undefined)this.studentName = singleRecordWrapper.studentName;
            //===========================================================//
            do{
                
                //===========================================================//
                this.isLoading = false;       ////Turn OFF the spinner
                //===========================================================//
                /*
                const event = new ShowToastEvent({
                    title: 'Quiz-1 : Student details',
                    message: 'Quiz-1 record fields received successfuly',
                    variant: 'success'
                });                
                this.dispatchEvent(event);
                */
            }while(false);
            this.flag = 'getApexRecordSAF';
            console.log('this.flag : ' + this.flag);
        }).catch(error => {
            this.isLoading = false;
            let rxError ;
            if(isEnglish){
                this.rxError = 'Error while recieving record fields: Quiz-1 : Student details';
            }else{
                this.rxError = 'रिकॉर्ड फ़ील्ड प्राप्त करते समय त्रुटि: प्रश्नावली-1: छात्र विवरण';
            }
            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title :  this.errorTitle,
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    searchStudent(){
        //console.log('this.studentSearchText = ' + this.studentSearchText);
        do{
            if(this.bid === undefined)
            {
                const event = new ShowToastEvent({
                    title : this.errorTitle,
                    message : this.msg,
                    variant : 'error'
                });
                this.dispatchEvent(event);
                break;
            }

            if(!this.studentSearchText)
            {
                //this.studentSearchText is blank do something
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
                //this.studentSearchText.length should be greater than 2 do something
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
                batchId : this.bid,
                grade : this.grd
            }).then(result => {
                //console.log('result : ' + JSON.stringify(result));
                //===========================================================//
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
                //===========================================================//
                /*
                const event = new ShowToastEvent({
                    title: 'Quiz-1 : Student details',
                    message: 'Student search successful',
                    variant: 'success'
                });                
                this.dispatchEvent(event);
                */
    
                this.flag = 'searchStudent';
                console.log('this.flag : ' + this.flag);
    
            }).catch(error => {
                let rxError;
                if(isEnglish){
                    this.rxError = 'Error while searching student';
                }else{
                    this.rxError = 'छात्र को खोजते समय त्रुटि';
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

        }while(false);
    }

    handleInputChangeStudent(event) {
        this.studentSearchText = event.detail.value.trim();
        //console.log('this.studentSearchText = ' + this.studentSearchText);

        if (this.delayTimeOut06) {
            window.clearTimeout(this.delayTimeOut06);
        }

        this.delayTimeOut06 = setTimeout(() => {
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
                let errorString = '';

                if(this.isEnglish){
                    this.errorString = 'You have already filled the data for this student. If you think this is a mistake fill the support form';
                }else{
                    this.errorString = 'आप इस छात्र का डेटा पहले ही भर चुके हैं. यदि आपको लगता है कि यह एक गलती है तो सहायता फ़ॉर्म भरें';
                }
               const event = new ShowToastEvent({
                   title: this.errorTitle,
                   message: this.errorString,
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
                this.nextNavigateToInternalPage();
                // this.getApexRecordSAF();
                // this.studentPresent = true;
           }
        }while(false);

        this.flag = 'handleClick';
        console.log('this.flag : ' + this.flag);
    }

    nextNavigateToInternalPage() {
        let nextPage = '';
        if(this.grd === 'Grade 9')
        {
            nextPage = 'Quiz1_Grade9_v2__c';
        }
        else if(this.grd === 'Grade 10')
        {
            nextPage = 'Quiz1_Grade10_V2__c';
        }

        // Use the basePath from the Summer '20 module to construct the URL
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: nextPage
            },
            state: {
                fem : encodeURI(this.fem),
                sch : encodeURI(this.sch),
                grd : encodeURI(this.grd),
                bid : encodeURI(this.bid),
                acid : encodeURI(this.acid),
                std : encodeURI(this.rxStudentId),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng) 
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