import { api, LightningElement } from 'lwc';

export default class Cmd1Form5Datatable extends LightningElement {

    @api coloumsNamesList = [];
    @api coloumsDataList = [];

    tableColoums = ['Name','Form Submitted'];
    tableDataList = [
       
    ];
}