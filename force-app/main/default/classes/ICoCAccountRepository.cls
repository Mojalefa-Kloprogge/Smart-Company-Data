global interface ICoCAccountRepository {
    Account getAccountById(Id accountId);
    Database.SaveResult updateAccount(Account acc);
}