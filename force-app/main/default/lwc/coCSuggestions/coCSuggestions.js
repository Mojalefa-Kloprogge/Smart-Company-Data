import { LightningElement, api } from 'lwc';
//Apex methods
import getAccountInfoFromCoC from '@salesforce/apex/CoCSuggestionsController.getAccountInfoFromCoC';
//Custom labels
import lblFieldName from '@salesforce/label/c.CoCLWCColFIELDNAME';
import lblCurFieldValue from '@salesforce/label/c.CoCLWCColCURRENTVALUE';
import lblCoCFieldValue from '@salesforce/label/c.CoCLWCColCOCVALUE';
const columns = [
    { label: lblFieldName, fieldName: 'fieldName', type: 'text', wrapText: true },
    { label: lblCurFieldValue, fieldName: 'fieldValueCurrent', type: 'text', cellAttributes: {class: {fieldName: `format`},alignment: `left`} },
    { label: lblCoCFieldValue, fieldName: 'fieldValueSuggested', type: 'text', cellAttributes: {class: {fieldName: `format`},alignment: `left`}  }
];
export default class CoCSuggestions extends LightningElement {
    @api recordId;
    @api identifier;
    @api isBranch;
    @api sObjectType;
    @api isMainBranch;
    @api mappingDetail = [];
    data;
    error;
    columns = columns;

    connectedCallback() {
        let parameterObject = {
            recordId: this.recordId,
            identifier: this.identifier,
            isBranch: this.isBranch,
            mappingDetail: this.mappingDetail,
            isMainBranch: this.isMainBranch,
            sObjectType: this.sObjectType
        };
        getAccountInfoFromCoC({ request: parameterObject })
            .then((result) => {
                result.fields.forEach(ele => {
                    ele.format = ele.fieldValueCurrent !== ele.fieldValueSuggested ? 'slds-text-color_error' : 'slds-text-color_success';
                });
                this.data = result;
                console.log(JSON.stringify(result));
                this.error = undefined;
            })
            .catch((error) => {
                this.data = undefined;
                this.error = error;
            }
        );
    }
}