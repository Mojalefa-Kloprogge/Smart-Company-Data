public with sharing class SearchCoCDataComponentController {
    @AuraEnabled(cacheable=false)
    public static List<CoCData> getCoCDataByTerm(String term) {
        if (term != '') {
            SearchCoCData searcher = new SearchCoCData(new KVKDataProviderV2());
            return searcher.searchByTerm(term);
        } else
            return null;
    }
}