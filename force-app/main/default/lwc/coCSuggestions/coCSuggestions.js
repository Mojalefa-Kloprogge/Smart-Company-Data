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
    @api accountId;
    @api identifier;
    @api isBranch;
    @api isMainBranch;
    data;
    error;
    columns = columns;

    connectedCallback() {
        let parameterObject = {
            accountId: this.accountId,
            identifier: this.identifier,
            isBranch: this.isBranch,
            isMainBranch: this.isMainBranch
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