import { LightningElement, api, wire } from 'lwc';
import getCurrentBookForReader from '@salesforce/apex/CurrentBooksForReaderController.getCurrentBookForReader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


const columns = [
    { label: 'Book Name', fieldName: 'Name'},
    { label: 'Author', fieldName: 'Author__c'},
];

export default class CurrentBooksForReader extends LightningElement {
    @api recordId;
    books;
    error;

    columns = columns;

    @wire(getCurrentBookForReader, {readerId: '$recordId'}) 
    wiredBooks({ error, data }) {
        if (data) {
            this.books = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.books = undefined;
        }
    }

    handleClick() {
        this.showToast('Error', 'error', 'Refresh integration is not yet configured')
    }

    showToast(title, variant, message) {
        const event = new ShowToastEvent({
            title: title,
            variant: variant,
            message: message
        });
        this.dispatchEvent(event);
    }
}