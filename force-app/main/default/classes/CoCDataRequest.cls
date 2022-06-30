public class CoCDataRequest {
    @AuraEnabled public String recordId{get;set;}
    @AuraEnabled public String identifier{get;set;}
    @AuraEnabled public Boolean isBranch{get;set;}
    @AuraEnabled public Boolean isMainBranch{get;set;}
    @AuraEnabled public List<MappingDetail__mdt> mappingDetail{get;set;}
    @AuraEnabled public String sObjectType{get;set;}
}