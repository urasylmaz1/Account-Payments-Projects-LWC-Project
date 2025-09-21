@isTest
public class AccountPaymentController_Test {

    @testSetup
    static void setupData() {
        // create a test account
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // create a test payment related to this account
        Payment__c pay = new Payment__c(
            Name = 'Test Payment',
            Payment_Type__c = 'Service',
            Amount__c = 100,
            Due_Date__c = Date.today().addDays(10),
            Account__c = acc.Id
        );
        insert pay;
    }

    @isTest
    static void testGetAccounts() {
        // call the method
        List<Account> accounts = AccountPaymentController.getAccounts();
        System.assertNotEquals(0, accounts.size(), 'Should return at least one Account');
    }

    @isTest
    static void testGetPaymentsByAccount() {
        // get the test account created in setup
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];

        // call the method
        List<Payment__c> payments = AccountPaymentController.getPayments(acc.Id);

        // assertions
        System.assertEquals(1, payments.size(), 'Should return 1 Payment for the test Account');
        System.assertEquals('Test Payment', payments[0].Name, 'Payment name should match');
    }

    @isTest
    static void testCreatePayment() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];

        // create a new payment via the controller
        Payment__c newPay = new Payment__c(
            Name = 'New Test Payment',
            Payment_Type__c = 'Product',
            Amount__c = 200,
            Due_Date__c = Date.today().addDays(15),
            Account__c = acc.Id
        );

        Test.startTest();
        Payment__c insertedPay = AccountPaymentController.createPayment(newPay);
        Test.stopTest();

        // assertions
        System.assertNotEquals(null, insertedPay.Id, 'Inserted Payment should have an Id');
        System.assertEquals('New Test Payment', insertedPay.Name, 'Payment name should match');
    }
}