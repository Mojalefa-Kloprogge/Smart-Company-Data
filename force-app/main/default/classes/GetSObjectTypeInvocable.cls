public with sharing class GetSObjectTypeInvocable {
    
    @InvocableMethod(label='Get SObjectType' description='Gets SObjectType based on the Id')
    public static List<String> getSObjectById(List<id> idList) {
        List<String> sObjectTypeList = new List<String>();
        for(Id id : idList){
           sObjectTypeList.add(SmartCompanyDataUtils.getSObjectById(id));
        }
        return sObjectTypeList;
    }

}
