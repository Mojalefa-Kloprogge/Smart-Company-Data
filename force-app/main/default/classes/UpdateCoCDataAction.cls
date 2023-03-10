public inherited sharing class UpdateCoCDataAction {
    /*@InvocableMethod(label='Update CoC Data' description='Updates the CoC data on an account based on the Id')
    global static List<UpdateCoCDataResult> UpdateCoCDataAction(List<UpdateCoCDataRequest> requests) {
        UpdateCoCData updater = new UpdateCoCData(new KVKDataProviderV2());
        List<UpdateCoCDataResult> resultList = new List<UpdateCoCDataResult>();

        UpdateCoCDataRequest request = requests.get(0);

        DataBase.SaveResult sr = updater.updateRecord(request.recordId, request.identifier, request.isBranch, request.isMainBranch, request.mappingDetail, request.sObjectType);
        Set<String> errorMessages = new Set<String>();
        for(Database.error error:sr.getErrors()){
            errorMessages.add(error.getMessage());
        }
        resultList.add(new UpdateCoCDataResult(sr.isSuccess(), String.join(new List<String>(errorMessages), ',')));
        return resultList;
    }*/

    @InvocableMethod(label='Update CoC Data' description='Updates the CoC data on an account based on the Id')
    public static List<String> UpdateCoCDataAction(List<UpdateCoCDataRequest> requests) {
        UpdateCoCData updater = new UpdateCoCData(new KVKDataProviderV2());
        List<String> resultList = new List<String>();

        UpdateCoCDataRequest request = requests.get(0);

        DataBase.SaveResult sr = updater.updateRecord(request.recordId, request.identifier, request.isBranch, request.isMainBranch, request.mappingDetail, request.sObjectType);
        Set<String> errorMessages = new Set<String>();
        for(Database.error error:sr.getErrors()){
            errorMessages.add(error.getMessage());
        }
        resultList.add(sr.isSuccess() + '|' + String.join(new List<String>(errorMessages), ','));
        return resultList;
    }

    public class UpdateCoCDataRequest {
        @InvocableVariable
        public Id recordId;
        @InvocableVariable
        public String identifier;
        @InvocableVariable
        public Boolean isBranch;
        @InvocableVariable
        public Boolean isMainBranch;
        @InvocableVariable
        public List<MappingDetail__mdt> mappingDetail;
        @InvocableVariable
        public String sObjectType;
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