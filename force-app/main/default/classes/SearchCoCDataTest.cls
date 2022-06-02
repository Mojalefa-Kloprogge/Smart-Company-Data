@isTest
public inherited sharing class SearchCoCDataTest {
    @isTest
    public static void searchTest() {
        SearchCoCData searcher = new SearchCoCData(new MockDataProvider());
        List<CoCData> results = searcher.searchByTerm('testTerm');

        System.assertEquals(2, results.size(), 'Expected 2 but found: ' + results.size());
    }
}