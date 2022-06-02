public inherited sharing class MockCoCAccountRepository implements ICoCAccountRepository {
    Account acc;

    public MockCoCAccountRepository() {
    }

    public Account getAccountById(Id accountId) {
        return null;
    }

    public Database.SaveResult updateAccount(Account acc) {
        Database.SaveResult sr;
        if (acc.Name.equalsIgnoreCase('fail')) {
            sr = (Database.SaveResult) JSON.deserialize('{"success":false,"id":"0013000000abcde"}', Database.SaveResult.class);
        } else {
            sr = (Database.SaveResult) JSON.deserialize('{"success":true,"id":"0013000000abcde"}', Database.SaveResult.class);
        }
        return sr;
    }
}