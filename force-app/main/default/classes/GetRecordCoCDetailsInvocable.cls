public with sharing class GetRecordCoCDetailsInvocable {
    
    @InvocableMethod(label='Get Record COC Details' description='Get Record COC Details')
    public static List<CoCRecordDetails> getRecordCoCDetails(List<InvocableCOCDataRequest> requests) {
        List <CoCRecordDetails> detailList = new List <CoCRecordDetails>();

        for (InvocableCOCDataRequest request : requests) {
            CoCRecordDetails details = new CoCRecordDetails();
            SObject originalRecord = SmartCompanyDataUtils.getSObjectRecordByFieldList(request.recordId, request.sObjectType, SmartCompanyDataUtils.retrieveFieldsFromMappingDetails(request.mappingDetail));
            
            for (mappingDetail__mdt md : request.mappingDetail) {
                if (md.SmartCompanyDataField__c == 'identifier')    {
                    details.identifier = (String)originalRecord.get(md.SalesforceField__c);
                }   
                if(md.SmartCompanyDataField__c == 'isBranch')   {
                    details.isBranch = (Boolean)originalRecord.get(md.SalesforceField__c);
                }
                if(md.SmartCompanyDataField__c == 'isMainBranch')   {
                    details.isMainBranch = (Boolean)originalRecord.get(md.SalesforceField__c);
                }
            }
            detailList.add(details);
        }
        return detailList;
    }

    public class CoCRecordDetails{
        @InvocableVariable
        public String identifier;
        @InvocableVariable
        public Boolean isBranch;
        @InvocableVariable
        public Boolean isMainBranch;
        @InvocableVariable
        public String branchNumber;
    }

    public class InvocableCOCDataRequest{
        @InvocableVariable public String recordId;
        @InvocableVariable public String identifier;
        @InvocableVariable public Boolean isBranch;
        @InvocableVariable public Boolean isMainBranch;
        @InvocableVariable public List<MappingDetail__mdt> mappingDetail;
        @InvocableVariable public String sObjectType;
    }

}