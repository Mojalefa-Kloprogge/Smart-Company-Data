@IsTest
private class CoCProfileTest {
    
    @IsTest static void testGetProfileInformationByFieldname(){
        String identifier = 'test';
        Boolean isBranch = false;
        Boolean isMainBranch = true;
        List<HttpResponse> responses = new List<HttpResponse>();

        HttpResponse respBAG = new HttpResponse();
        respBAG.setStatusCode(200);
        respBAG.setBody(SCDTestDataFactory.PROFILE_RESPONSE);

        responses.add(respBAG);

        HttpMock mock = new HttpMock(responses);
        Test.setMock(HttpCalloutMock.class, mock);

        KVKDataProviderV2 provider = new KVKDataProviderV2();
        CoCProfile result = provider.getProfile(identifier, isBranch, isMainBranch);

        Test.startTest();

        String resultIdentifier = (String)result.getProfileInformationByFieldname('identifier');
        String resultName = (String)result.getProfileInformationByFieldname('name');
        String resultRSIN = (String)result.getProfileInformationByFieldname('rsin');
        String resultLegalForm = (String)result.getProfileInformationByFieldname('legalForm');
        String resultBranchIdentifier = (String)result.getProfileInformationByFieldname('branchIdentifier');
        String resultCity = (String)result.getProfileInformationByFieldname('city');
        String resultStreet = (String)result.getProfileInformationByFieldname('street');
        String resultPostalCode = (String)result.getProfileInformationByFieldname('postalCode');
        String resultCountry = (String)result.getProfileInformationByFieldname('country');
        String resultDeregistrationDate = (String)result.getProfileInformationByFieldname('deregistrationdate');
        Boolean resultIsBranch = (Boolean)result.getProfileInformationByFieldname('isBranch');
        Boolean resultIsMainBranch = (Boolean)result.getProfileInformationByFieldname('isMainBranch');
        String resultOther = (String)result.getProfileInformationByFieldname('invalidFieldName');
        
        Test.stopTest();

        system.assertEquals(resultIdentifier, result.identifier, 'The Chamber Of Commerce numbers should match');
        system.assertEquals(resultName, result.name, 'The Business Name should be 2ManyDigits B.V.');
        system.assertEquals(resultRSIN, result.rsin, 'The RSIN number should match');
        system.assertEquals(resultLegalForm, result.legalForm, 'The LegalForm should match');
        system.assertEquals(resultBranchIdentifier, result.branchIdentifier, 'The branchIdentifier should match');
        system.assertEquals(resultCity, result.addressMap.get('bezoekadres').city.toLowerCase().capitalize(), 'The city should match');
        String resStreet = result.addressMap.get('bezoekadres').street + ' ' + result.addressMap.get('bezoekadres').houseNumber;
        if (result.addressMap.get('bezoekadres').houseNumberAddition != null) {
            resStreet += ' ' + result.addressMap.get('bezoekadres').houseNumberAddition;
        }
        system.assertEquals(resultStreet, resStreet, 'The Streets should match');
        system.assertEquals(resultPostalCode, result.addressMap.get('bezoekadres').postalCode, 'The postal codes should match');
        system.assertEquals(resultCountry, result.addressMap.get('bezoekadres').country, 'The countries should match');
        system.assertEquals(resultDeregistrationDate, result.deregistrationDate, 'The deregistrationDates should match');
        system.assertEquals(resultIsBranch, result.isBranch, 'Branch should match');
        system.assertEquals(resultIsMainBranch, result.isMainBranch, 'Main Branch should match');
        system.assertEquals(null, resultOther, 'Other values should be null');
    }
}
