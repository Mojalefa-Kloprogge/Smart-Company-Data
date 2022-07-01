public inherited sharing class UpdateCoCData {
    private IDataProvider dataProvider;

    public UpdateCoCData(IDataProvider dataProvider) {
        this.dataProvider = dataProvider;
    }

    public DataBase.SaveResult updateRecord(Id recordId, String identifier, Boolean isBranch, Boolean isMainBranch, List<MappingDetail__mdt> mappingDetail, String sObjectType) {
        List<String> fieldList = SmartCompanyDataUtils.retrieveFieldsFromMappingDetails(mappingDetail);
        SObject originalRecord = SmartCompanyDataUtils.getSObjectRecordByFieldList(recordId, sObjectType, fieldList);
        CoCProfile profile = dataProvider.getProfile(identifier, isBranch, isMainBranch);
        DataBase.SaveResult sr = profile.updateRecord(originalRecord, mappingDetail);
        return sr;
    }

    public CoCProfile getCoCData(Id accountId, String identifier, Boolean isBranch, Boolean isMainBranch){
        CoCProfile profile = dataProvider.getProfile(identifier, isBranch, isMainBranch);
        return profile;
    }
}