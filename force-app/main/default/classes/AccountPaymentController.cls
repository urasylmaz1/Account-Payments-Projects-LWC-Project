public with sharing class AccountPaymentController {

    // get list of accounts
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name FROM Account ORDER BY Name LIMIT 100];
    }

    // get list of payments for a selected account
    @AuraEnabled(cacheable=true)
    public static List<Payment__c> getPayments(Id accountId) {
        if (accountId == null) {
            return new List<Payment__c>();
        }
        return [
            SELECT Id, Name, Payment_Type__c, Amount__c, Due_Date__c, Notes__c
            FROM Payment__c
            WHERE Account__c = :accountId
            ORDER BY Due_Date__c ASC
        ];
    }

    // create new payment
    @AuraEnabled
    public static Payment__c createPayment(Payment__c payment) {
        if (payment == null) {
            throw new AuraHandledException('Payment record cannot be null.');
        }
        insert payment;
        return payment;
    }
}