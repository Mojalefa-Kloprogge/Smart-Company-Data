public with sharing class GetSObjectRecordByMappingInvocable {
    @InvocableMethod(label='Get fields of record' description='Gets fields based on the Id, Mtd')
    public static List<SObject> getSObjectRecordByMapping(List<SObjectRecordByMappingRequest> sObjByMappingList) {
        List<SObject> sObjectList = new List<SObject>();
        for(SObjectRecordByMappingRequest request : sObjByMappingList){
            List<String> fieldList = new List<String>();
            for(MappingDetail__mdt md : request.mappingDetailList){
                fieldList.add(md.SalesforceField__c);
            }
            sObjectList.add(SmartCompanyDataUtils.getSObjectRecordByFieldList(request.recordId, request.sObjectType, fieldList));
        }
        return sObjectList;
    }
    
}