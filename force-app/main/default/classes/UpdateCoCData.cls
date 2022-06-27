public inherited sharing class UpdateCoCData {
    private IDataProvider dataProvider;
    private ICoCAccountRepository accountRepository;

    public UpdateCoCData(IDataProvider dataProvider, ICoCAccountRepository accountRepository) {
        this.dataProvider = dataProvider;
        this.accountRepository = accountRepository;
    }

    public DataBase.SaveResult updateAccount(Id accountId, String identifier, Boolean isBranch, Boolean isMainBranch) {
        Account acc = accountRepository.getAccountById(accountId);
        CoCProfile profile = dataProvider.getProfile(identifier, isBranch, isMainBranch);
        DataBase.SaveResult sr = accountRepository.updateAccount(profile.updateAccount(acc));
        return sr;
    }

    public CoCProfile getCoCData(Id accountId, String identifier, Boolean isBranch, Boolean isMainBranch){
        CoCProfile profile = dataProvider.getProfile(identifier, isBranch, isMainBranch);
        return profile;
    }
}