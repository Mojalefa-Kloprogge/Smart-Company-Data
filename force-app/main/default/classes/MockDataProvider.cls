public inherited sharing class MockDataProvider implements IDataProvider {
    public List<CoCData> searchByTerm(String searchTerm) {
        List<CoCData> resultList = new List<CoCData>();

        CoCData data1 = new CoCData();
        resultList.add(data1);

        CoCData data2 = new CoCData();
        resultList.add(data2);

        return resultList;
    }

    public CoCProfile getProfile(String identifier, Boolean isBranch, Boolean isMainBranch) {
        CoCProfile result = new CoCProfile();
        if (isBranch) {
            result.identifier = 'branch';
        } else {
            result.identifier = 'no-branch';
        }
        result.addressMap = new Map<String, CoCAddress>();

        CoCAddress address = new CoCAddress();
        address.city = 'Breda';
        address.country = 'Nederland';
        address.houseNumber = '7';
        address.street = 'Keizerstraat';
        address.postalCode = '4811 HL';

        result.addressMap.put('vestigingsadres', address);

        return result;
    }
}