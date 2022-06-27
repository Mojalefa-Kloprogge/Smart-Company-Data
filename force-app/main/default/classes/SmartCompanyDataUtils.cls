public with sharing class SmartCompanyDataUtils {
    public static String getSObjectById(ID id) {
        return Id.getSObjectType().getDescribe().getName();
    }

    public static SObject getSObjectRecordByFieldList(Id recordId, String sObjectType, List<String> fieldList){
        String query = 'SELECT Id ';
        for(String field : fieldList){        
            query += ', ' + field;
        }
        query += ' FROM ' + sObjectType;
        query += ' WHERE Id = \'' + String.escapeSingleQuotes(recordId) + '\'';
        List<SObject> sObjectList;
        try{
            sObjectList = Database.query(query);
        } catch (Exception e) {
            e.setMessage(Label.CoC_GetSObjectByFieldList_Error);
            throw e;
        }
        return sObjectList.get(0);
    }

    public static List<String> retrieveFieldsFromMappingDetails(List<MappingDetail__mdt> mappingDetails){
        List<String> fields = new List<String>();
        for(MappingDetail__mdt mappingDetail : mappingDetails){
            fields.add(mappingDetail.SalesforceField__c);
        }
        return fields;
    }
}
