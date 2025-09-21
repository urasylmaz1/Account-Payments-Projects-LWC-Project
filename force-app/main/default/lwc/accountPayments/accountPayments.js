import { LightningElement, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountPaymentController.getAccounts';
import getPayments from '@salesforce/apex/AccountPaymentController.getPayments';
import createPayment from '@salesforce/apex/AccountPaymentController.createPayment';

export default class AccountPayments extends LightningElement {
    @track accounts = [];
    @track payments = [];
    @track selectedAccountId;
    @track newPayment = {};

    paymentTypes = [
        { label: 'Service', value: 'Service' },
        { label: 'Product', value: 'Product' },
        { label: 'Other', value: 'Other' }
    ];

    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
        } else if (error) {
            console.error(error);
        }
    }

    handleSelectAccount(event) {
        this.selectedAccountId = event.target.dataset.id;
        getPayments({ accountId: this.selectedAccountId })
            .then(result => {
                this.payments = result;
            })
            .catch(error => console.error(error));
    }

    handleChange(event) {
        const field = event.target.dataset.field;
        this.newPayment[field] = event.target.value;
    }

    handleCreatePayment() {
        this.newPayment.Account__c = this.selectedAccountId;
        createPayment({ payment: this.newPayment })
            .then(result => {
                this.payments = [...this.payments, result]; 
                this.newPayment = {}; // reset form
            })
            .catch(error => console.error(error));
    }

    // Getter to determine the CSS class for the selected account
    getAccountClass(accId) {
        return accId === this.selectedAccountId ? 'selected' : '';
    }
}
