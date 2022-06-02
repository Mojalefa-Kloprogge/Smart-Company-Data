public inherited sharing class CoCAccountRepository implements ICoCAccountRepository {
    public Account getAccountById(Id accountId) {
        return [ SELECT  Id, Is_Branch__c, Branch_Number__c, Chamber_of_Commerce__c, Name, ShippingCity, 
                        ShippingStreet, ShippingPostalCode, Is_Main_Branch__c, BillingStreet, BillingPostalCode,
                        BillingCity, BillingCountry, Legal_form__c, Date_of_Termination_Chamber_of_Commerce__c
                FROM    Account
                WHERE   Id =: accountId];
    }

    public Database.SaveResult updateAccount(Account acc) {
        return Database.update(acc, false);
    }
}