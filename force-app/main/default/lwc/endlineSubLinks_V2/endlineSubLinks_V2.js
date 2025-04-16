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
    endlineForms;
    separatedArrayEndline;
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
        this.buttonVisibility();
    }

    buttonVisibility(){
        getSchoolDistrictData({ schoolId : this.acid })
        .then(result => {
            this.schoolDistrictData = result; 
            if(this.grade === 'Grade 9'){
                this.endlineForms = this.schoolDistrictData.Select_Forms_to_Show_in_Endline_for_G9__c;
                if(this.endlineForms){
                    this.separatedArrayEndline = this.endlineForms.split(';');
                    this.enableButtons();
                }else{
                    this.showToastPopMessage('No Endline Form Selected','You can add endline forms in District Records for Grade 9.','warning');
                }
                this.enableButtons();
            }else if(this.grade === 'Grade 10'){
                this.endlineForms = this.schoolDistrictData.Select_Forms_to_Show_in_Endline_for_G10__c;
                if(this.endlineForms){
                    this.separatedArrayEndline = this.endlineForms.split(';');
                    this.enableButtons();
                }else{
                    this.showToastPopMessage('No Endline Form Selected','You can add endline forms in District Records for Grade 10.','warning');
                }
            }else if(this.grade === 'Grade 11'){
                this.endlineForms = this.schoolDistrictData.Select_Forms_to_Show_in_Endline_for_G11__c;
                if(this.endlineForms){
                    this.separatedArrayEndline = this.endlineForms.split(';');
                    this.enableButtons();
                }else{
                    this.showToastPopMessage('No Endline Form Selected','You can add endline forms in District Records for Grade 11.','warning');
                }
            }else if(this.grade === 'Grade 12'){
                this.endlineForms = this.schoolDistrictData.Select_Forms_to_Show_in_Endline_for_G12__c;
                if(this.endlineForms){
                    this.separatedArrayEndline = this.endlineForms.split(';');
                    this.enableButtons();
                }else{
                    this.showToastPopMessage('No Endline Form Selected','You can add endline forms in District Records for Grade 12.','warning');
                }
            }
            this.showLoading = false;
        }).catch(error => {
            console.log('$$$ Error: ', error);
            this.showLoading = false; 
            if(this.isEnglish){
                this.showToastPopMessage('Error!',error,'error')
            }else{
                this.showToastPopMessage('गलती!','गलती','success');
            } 
        });
    }

    enableButtons(){
        if(this.separatedArrayEndline.indexOf('CDM1') !== -1) {
            this.baselineCDM1Button = true;
        }
        if(this.separatedArrayEndline.indexOf('CDM2') !== -1) {
            this.baselineCDM2Button = true;
        }
        if(this.separatedArrayEndline.indexOf('CP') !== -1) {
            this.careerPlanningButton = true;
        }
        if(this.separatedArrayEndline.indexOf('CS') !== -1) {
            this.careerSkillsButton = true;
        }
        if(this.separatedArrayEndline.indexOf('PFF') !== -1) {
            this.planningForFutureButton = true;
        }
        if(this.separatedArrayEndline.indexOf('Feedback') !== -1) {
            this.feedbackButton = true;
        }
    }

    baselineCDM1Handler(){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'endline_cdm1_assesment_V2__c'
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
                name: 'endline_cdm2_assesment_V2__c'
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
                name: 'endline_cp_assesment_V2__c'
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
                name: 'endline_cs_assesment_V2__c'
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
                name: 'endline_pff_assesment_V2__c'
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
                name: 'endline_mpf_assesment_V2__c'
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