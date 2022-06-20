public with sharing class SObjectRecordByMappingRequest {
    @InvocableVariable public Id recordId;
    @InvocableVariable public String sObjectType;
    @InvocableVariable public List<MappingDetail__mdt> mappingDetailList;
}
