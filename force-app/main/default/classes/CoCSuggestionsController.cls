public with sharing class CoCSuggestionsController {
    @AuraEnabled
    public static CoCSuggestion getAccountInfoFromCoC(CoCDataRequest request){
        if(request == null){
            return new CocSuggestion();
        }

        CoCAccountRepository accountRepository = new CoCAccountRepository();
        UpdateCoCData updater = new UpdateCoCData(new KVKDataProviderV2(), accountRepository);
        
        Account acc = updater.getCoCData(request.accountId, request.identifier, request.isBranch, request.isMainBranch);
        
        Account originalAccount = accountRepository.getAccountById(request.accountId);

        CoCSuggestion sugg = new CoCSuggestion();
        sugg.recordId = acc.Id;

        Schema.FieldSet cocFieldSet = Schema.SObjectType.Account.fieldSets.getMap().get('ChamberOfCommerceFields');

        for(Schema.FieldSetMember cocFSM: cocFieldSet.getFields()){
            CoCSuggestionsController.CoCSuggestionField suggestionField = new CoCSuggestionsController.CoCSuggestionField();
            String fieldName = cocFSM.getFieldPath();
            suggestionField.fieldName = cocFSM.getSObjectField().getDescribe().getLabel();
            suggestionField.fieldValueCurrent = cocFSM.getType() != Schema.DisplayType.STRING ? String.valueOf(originalAccount.get(fieldName)) : (String) originalAccount.get(fieldName);
            suggestionField.fieldValueSuggested = cocFSM.getType() != Schema.DisplayType.STRING ? String.valueOf(acc.get(fieldName)) : (String) acc.get(fieldName);
            sugg.fields.add(suggestionField);
        }

        for(CoCSuggestionsController.CoCSuggestionField field : sugg.fields){
            if(String.isNotBlank(field.fieldValueCurrent)){
                field.fieldValueCurrent = field.fieldValueCurrent.trim();
            }
            if(String.isNotBlank(field.fieldValueSuggested)){
                field.fieldValueSuggested = field.fieldValueSuggested.trim();
            }
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