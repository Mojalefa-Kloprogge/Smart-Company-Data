public inherited sharing class UpdateCoCDataAction {
    @InvocableMethod(label='Update CoC Data' description='Updates the CoC data on an account based on the Id')
    public static List<UpdateCoCDataResult> UpdateCoCDataAction(List<UpdateCoCDataRequest> requests) {
        UpdateCoCData updater = new UpdateCoCData(new KVKDataProviderV2(), new CoCAccountRepository());
        List<UpdateCoCDataResult> resultList = new List<UpdateCoCDataResult>();

        UpdateCoCDataRequest request = requests.get(0);

        DataBase.SaveResult sr = updater.updateAccount(request.accountId, request.identifier, request.isBranch, request.isMainBranch);
        resultList.add(new UpdateCoCDataResult(sr.isSuccess(), sr.getErrors().toString()));
        return resultList;
    }

    public class UpdateCoCDataRequest {
        @InvocableVariable
        public Id accountId;
        @InvocableVariable
        public String identifier;
        @InvocableVariable
        public Boolean isBranch;
        @InvocableVariable
        public Boolean isMainBranch;
    }

    public class UpdateCoCDataResult {
        @InvocableVariable
        public String message;
        @InvocableVariable
        public Boolean isSuccess;

        public UpdateCoCDataResult(Boolean isSuccess, String message) {
            this.isSuccess = isSuccess;
            this.message = message;
        }
    }
}