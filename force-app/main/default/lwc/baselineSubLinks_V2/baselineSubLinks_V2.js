import { LightningElement, api, wire} from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import getSchoolDistrictData from '@salesforce/apex/BaselineController.getSchoolDistrictData';
export default class BaselineSubLinks_V2 extends NavigationMixin(LightningElement){
    showLoading = true;
    @api grade = null;
    @api batchCode = null;
    @api batchId = null;
    @api schoolName = null;
    batchNumber = '';
    @api schoolId = null;
    @api facilatorEmail = null;
    @api acid = null;
    typ;
    lng;
    isEnglish;
    schoolDistrictData;
    baselineForms;
    separatedArrayBaseline;
    baselineCDM1Button = false;
    baselineCDM2Button = false;
    careerPlanningButton = false;
    careerSkillsButton = false;
    planningForFutureButton = false;
    feedbackButton = false;

    //For Getting Params from the Url.  
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference){
        if (currentPageReference){
            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            this.grade = decodeURI(rxCurrentPageReference.state.grd);
            this.batchId = decodeURI(rxCurrentPageReference.state.bid);
            this.schoolId = decodeURI(rxCurrentPageReference.state.sch);
            this.facilatorEmail = decodeURI(rxCurrentPageReference.state.fem);
            this.acid = decodeURI(rxCurrentPageReference.state.acid);
            this.typ = decodeURI(rxCurrentPageReference.state.typ);
            this.lng = decodeURI(rxCurrentPageReference.state.lng);
            this.isEnglish = (this.lng == 'English') ? true : false;
            if(this.batchId){
                getBatchCodeName({ batchId : this.batchId })
                .then(result => {
                    this.batchNumber =  result.Batch_Number__c;
                    this.batchCode = result.Name;   
                }).catch(error => {
                    if(this.isEnglish){
                        this.showToastPopMessage('Error!',error,'error')
                    }else{
                        this.showToastPopMessage('गलती!','गलती','success');
                    } 
                });
            }
        }
    }

    connectedCallback() {
        window.name = JSON.stringify({ secretData: 'HiddenMessage123' });
        console.log('enter');
        const message = {
            recordId: "001xx000003NGSFAA4",
            name: "Burlington Textiles of America"
        };
        alert(JSON.stringify(message));
        this.buttonVisibility();
    }

    buttonVisibility(){
        getSchoolDistrictData({ schoolId : this.acid })
        .then(result => {
            this.schoolDistrictData = result; 
            console.log('$$$ this.schoolDistrictData: ', result);
            if(this.grade === 'Grade 9'){
                this.baselineForms = this.schoolDistrictData.Select_Forms_to_Show_in_Baseline_for_G9__c;
                if(this.baselineForms){
                    this.separatedArrayBaseline = this.baselineForms.split(';');
                    this.enableButtons();
                }else{
                    this.showToastPopMessage('No Baseline Form Selected','You can add baseline forms in District Records for Grade 9.','warning');
                }
            }else if(this.grade === 'Grade 10'){
                this.baselineForms = this.schoolDistrictData.Select_Forms_to_Show_in_Baseline_for_G10__c;
                if(this.baselineForms){
                    this.separatedArrayBaseline = this.baselineForms.split(';');
                    this.enableButtons();
                }else{
                    this.showToastPopMessage('No Baseline Form Selected','You can add baseline forms in District Records for Grade 10.','warning');
                }
            }else if(this.grade === 'Grade 11'){
                this.baselineForms = this.schoolDistrictData.Select_Forms_to_Show_in_Baseline_for_G11__c;
                if(this.baselineForms){
                    this.separatedArrayBaseline = this.baselineForms.split(';');
                    this.enableButtons();
                }else{
                    this.showToastPopMessage('No Baseline Form Selected','You can add baseline forms in District Records for Grade 11.','warning');
                }
            }else if(this.grade === 'Grade 12'){
                this.baselineForms = this.schoolDistrictData.Select_Forms_to_Show_in_Baseline_for_G12__c;
                if(this.baselineForms){
                    this.separatedArrayBaseline = this.baselineForms.split(';');
                    this.enableButtons();
                }else{
                    this.showToastPopMessage('No Baseline Form Selected','You can add baseline forms in District Records for Grade 12.','warning');
                }
            }
            this.showLoading = false;
        }).catch(error => {
            console.log('$$$ Error: ', error);
            this.showLoading = false; 
            if(this.isEnglish){
                this.showToastPopMessage('Error!',error,'error');
            }else{
                this.showToastPopMessage('गलती!','गलती','success');
            } 
        });
    }

    enableButtons(){
        if(this.separatedArrayBaseline.indexOf('CDM1') !== -1) {
            this.baselineCDM1Button = true;
        }
        if(this.separatedArrayBaseline.indexOf('CDM2') !== -1) {
            this.baselineCDM2Button = true;
        }
        if(this.separatedArrayBaseline.indexOf('CP') !== -1) {
            this.careerPlanningButton = true;
        }
        if(this.separatedArrayBaseline.indexOf('CS') !== -1) {
            this.careerSkillsButton = true;
        }
        if(this.separatedArrayBaseline.indexOf('PFF') !== -1) {
            this.planningForFutureButton = true;
        }
        if(this.separatedArrayBaseline.indexOf('Feedback') !== -1) {
            this.feedbackButton = true;
        }
    }

    baselineCDM1Handler(){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'baseline_cdm1_assesment_V2__c'
            },
            state:{
                fem : encodeURI(this.facilatorEmail),
                sch : encodeURI(this.schoolId),
                grd : encodeURI(this.grade), 
                bid : encodeURI(this.batchId),
                acid : encodeURI(this.acid),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng)  
            }
        };
       
        
        this[NavigationMixin.Navigate](pageReference);
    }

    baselineCDM2Handler(){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'baseline_cdm2_assesment_V2__c'
            },
            state:{
                fem : encodeURI(this.facilatorEmail),
                sch : encodeURI(this.schoolId),
                grd : encodeURI(this.grade), 
                bid : encodeURI(this.batchId),
                acid : encodeURI(this.acid),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng)  
            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }

    careerPlanningHandler(){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'baseline_cp_assesment_V2__c'
            },
            state:{
                fem : encodeURI(this.facilatorEmail),
                sch : encodeURI(this.schoolId),
                grd : encodeURI(this.grade), 
                bid : encodeURI(this.batchId),
                acid : encodeURI(this.acid),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng)  
            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }

    careerSkillsHandler(){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'baseline_cs_assesment_V2__c'
            },
            state:{
                fem : encodeURI(this.facilatorEmail),
                sch : encodeURI(this.schoolId),
                grd : encodeURI(this.grade), 
                bid : encodeURI(this.batchId),
                acid : encodeURI(this.acid),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng)  
            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }

    planningForFutureHandler(){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'baseline_pff_assesment_V2__c'
            },
            state:{
                fem : encodeURI(this.facilatorEmail),
                sch : encodeURI(this.schoolId),
                grd : encodeURI(this.grade), 
                bid : encodeURI(this.batchId),
                acid : encodeURI(this.acid),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng)  
            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }

    feedbackHandler(){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'baseline_mpf_assesment_V2__c'
            },
            state:{
                fem : encodeURI(this.facilatorEmail),
                sch : encodeURI(this.schoolId),
                grd : encodeURI(this.grade), 
                bid : encodeURI(this.batchId),
                acid : encodeURI(this.acid),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng)  
            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }

    backBtnHandler(){
        debugger;
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'DataEntryDetailPageV2__c'
            },
            state:{
                fem : encodeURI(this.facilatorEmail),
                sch : encodeURI(this.schoolId),
                grd : encodeURI(this.grade), 
                bid : encodeURI(this.batchId),
                acid : encodeURI(this.acid),
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
}