public with sharing class CoCSuggestionsController {
    @AuraEnabled
    public static CoCSuggestion getAccountInfoFromCoC(CoCDataRequest request){
        if(request == null){
            return new CocSuggestion();
        }
        
        UpdateCoCData updater = new UpdateCoCData(new KVKDataProviderV2());
        
        CoCProfile profile = updater.getCoCData(request.recordId, request.identifier, request.isBranch, request.isMainBranch);
        CoCSuggestion sugg = new CoCSuggestion();

        SObject originalRecord = SmartCompanyDataUtils.getSObjectRecordByFieldList(request.recordId, request.sObjectType, SmartCompanyDataUtils.retrieveFieldsFromMappingDetails(request.mappingDetail));
        
        DescribeUtils describeUtils = new DescribeUtils();

        for (MappingDetail__mdt mappingDetail : request.mappingDetail){
            CoCSuggestionsController.CoCSuggestionField suggestionField = new CoCSuggestionsController.CoCSuggestionField();
            suggestionField.fieldName = describeUtils.getFieldLabelBySObjectAndFieldname(request.sObjectType, mappingDetail.SalesforceField__c);
            suggestionField.fieldValueCurrent = String.valueOf(originalRecord.get(mappingDetail.SalesforceField__c)); 
            Object suggestedFieldValue = profile.getProfileInformationByFieldname(mappingDetail.SmartCompanyDataField__c); 
            suggestionField.fieldValueSuggested = suggestedFieldValue instanceOf String ? (String)suggestedFieldValue : String.valueOf(suggestedFieldValue);
            sugg.fields.add(suggestionField);
            System.debug(LoggingLevel.error, 'suggestion: ' + sugg);
        }
        
        return sugg;
    }

    public class CoCSuggestion{
        @AuraEnabled public String recordId;
        @AuraEnabled public List<CoCSuggestionsController.CoCSuggestionField> fields;

        public CoCSuggestion(){
            this.fields = new List<CoCSuggestionsController.CoCSuggestionField>();
        }
    }

    public class CoCSuggestionField {
        @AuraEnabled public String fieldName;
        @AuraEnabled public String fieldValueCurrent;
        @AuraEnabled public String fieldValueSuggested;
    }
}