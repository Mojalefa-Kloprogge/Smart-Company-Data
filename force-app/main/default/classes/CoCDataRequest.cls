public class CoCDataRequest {
    @AuraEnabled public String accountId{get;set;}
    @AuraEnabled public String identifier{get;set;}
    @AuraEnabled public Boolean isBranch{get;set;}
    @AuraEnabled public Boolean isMainBranch{get;set;}
}