public inherited sharing class SearchCoCData {
    private IDataProvider dataProvider;

    public SearchCoCData(IDataProvider dataProvider) {
        this.dataProvider = dataProvider;
    }

    public List<CoCData> searchByTerm(String term) {
        return dataProvider.searchByTerm(term);
    }
}