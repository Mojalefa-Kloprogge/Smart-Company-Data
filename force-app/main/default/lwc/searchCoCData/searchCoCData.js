import { LightningElement, track, api } from 'lwc';
import getCoCDataByTerm from '@salesforce/apex/SearchCoCDataComponentController.getCoCDataByTerm';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import placeHolder from '@salesforce/label/c.CoC_LWC_Placeholder';
import searchLabel from '@salesforce/label/c.CoC_LWC_Searchlabel';
import nameColLabel from '@salesforce/label/c.CoC_LWC_Col_Name';
import activeColLabel from '@salesforce/label/c.CoC_LWC_Col_Active';
import mainColLabel from '@salesforce/label/c.CoC_LWC_Col_Main';
import cocNumberColLabel from '@salesforce/label/c.CoC_LWC_Col_CoCNumber';
import streetColLabel from '@salesforce/label/c.CoC_LWC_Col_Street';
import numberColLabel from '@salesforce/label/c.CoC_LWC_Col_Number';
import extColLabel from '@salesforce/label/c.CoC_LWC_Col_Ext';
import postalCodeColLabel from '@salesforce/label/c.CoC_LWC_Col_Postalcode';
import cityColLabel from '@salesforce/label/c.CoC_LWC_Col_City';
import resultTitleLabel from '@salesforce/label/c.CoC_LWC_Results_Title';

const DELAY = 500;
const columnsInternal = [
    { label: nameColLabel, fieldName: 'name', initialWidth: 320, type: 'text', sortable: true, wrapText: true },
    { label: activeColLabel, initialWidth: 110, sortable: true, cellAttributes: { iconName: { fieldName: 'activeIcon' } } },
    { label: mainColLabel, initialWidth: 110, sortable: true, cellAttributes: { iconName: { fieldName: 'mainIcon' } } },
    { label: cocNumberColLabel, fieldName: 'identifier', initialWidth: 130, sortable: true },
    { label: streetColLabel, fieldName: 'street', type: 'text', wrapText: true },
    { label: numberColLabel, fieldName: 'houseNumber', type: 'text', wrapText: true },
    { label: extColLabel, fieldName: 'houseNumberAddition', type: 'text', wrapText: true },
    { label: postalCodeColLabel, fieldName: 'postalCode', type: 'text', wrapText: true },
    { label: cityColLabel, fieldName: 'city', type: 'text', wrapText: true },
];

export default class SearchCoCData extends LightningElement {
    @track sortData;
    @track columnsInternal = columnsInternal;
    @track sortDirection;
    @track sortBy;
    inputLabel = searchLabel;
    inputPlaceholder = placeHolder;
    cocData;
    dataFound;
    @api recordId;
    @api searchTerm = '';
    @api identifier;
    @api isBranch;
    @api isMainBranch;
    showSpinner = false;
    selectedCompany = null;

    label = { resultTitleLabel };

    connectedCallback() {
        this.showSpinner = true;
        this.dataFound = false;
        this.getResults();
    }

    handleSearchChange(event) {
        window.clearTimeout(this.delayTimeout);
        var term = event.target.value;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            this.clearResults();
            this.showSpinner = true;
            this.dataFound = false;
            this.searchTerm = term;
            this.getResults();
        }, DELAY);
    }

    getResults() {
        if (this.searchTerm) {
            getCoCDataByTerm({ term: this.searchTerm })
                .then(result => {
                    if (resultTitleLabel) {
                        this.dataFound = true;
                        this.showSpinner = false;
                        this.sortData = result;
                        this.cocData = JSON.stringify(result);
                    } else {
                        this.clearResults();
                        this.showSpinner = false;
                    }
                })
                .catch(error => {
                    this.showSpinner = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: error.body.message,
                            variant: 'warning',
                        }),
                    );
                });
        } else {
            this.clearResults();
            this.showSpinner = false;
        }
    }

    clearResults() {
        this.cocData = null;
        this.dataFound = false;
        this.sortData = null;
    }

    handleSortData(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortingData(this.sortBy, this.sortDirection, this.sortData);
    }

    sortingData(fieldname, direction, source) {
        let parseData = JSON.parse(JSON.stringify(source));
        let keyValue = a => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.sortData = parseData;
    }

    handleRowSelection(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedCompany = selectedRows[0];
        if (this.selectedCompany.isMainBranch || !this.selectedCompany.hasOwnProperty('branchIdentifier') || this.selectedCompany.branchIdentifier === null) {
            this.identifier = this.selectedCompany.identifier;
            this.isBranch = this.selectedCompany.isMainBranch;
        } else {
            this.identifier = this.selectedCompany.branchIdentifier;
            this.isBranch = true;
        }
        this.isMainBranch = this.selectedCompany.isMainBranch;
    }
}