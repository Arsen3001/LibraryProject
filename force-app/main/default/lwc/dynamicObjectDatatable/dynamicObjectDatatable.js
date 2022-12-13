import { LightningElement, api, wire } from 'lwc';
import fetchRecs from '@salesforce/apex/DynamicObjectDatatableController.fetchRecs';

export default class DynamicObjectDatatable extends LightningElement {
    // @api ObjectName;
    // @api Fields;
    // @api TableColumns;
    // @api Title
    
    // listRecs;
    // columns;
    // error;

    listRecs;  
    initialListRecs;
    error;  
    columns;  
    items = []; 
    page = 1; 
    columns; 
    
 
    @api Fields;
    @api TableColumns;
    @api Title;
    @api ObjectName;
    @api ObjectIcon = 'standard:account';
    @api RecordPage;

    connectedCallback() {
this.columns = JSON.parse( this.TableColumns.replace( /([a-zA-Z0-9]+?):/g, '"$1":' ).replace( /'/g, '"' ) );
}

    get vals() { 
        return this.ObjectName + '-' + this.Fields; 
    }

    @wire(fetchRecs, { listValues: '$vals' })
        wiredRecs( { error, data } ) {
 
        if(data) {
            this.listRecs = data;
            this.error = undefined;
        } else {
            this.error = error;
            this.listRecs = undefined;
        }
    }
}