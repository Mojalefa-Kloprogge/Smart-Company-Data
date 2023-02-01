@IsTest
private class CoCProfileTest {
    
    @IsTest 
    static void testGetProfileInformationByFieldname(){
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

        System.assertEquals(resultIdentifier, result.identifier, 'The Chamber Of Commerce numbers should match');
        System.assertEquals(resultName, result.name, 'The Business Name should be 2ManyDigits B.V.');
        System.assertEquals(resultRSIN, result.rsin, 'The RSIN number should match');
        System.assertEquals(resultLegalForm, result.legalForm, 'The LegalForm should match');
        System.assertEquals(resultBranchIdentifier, result.branchIdentifier, 'The branchIdentifier should match');
        System.assertEquals(resultCity, result.addressMap.get('bezoekadres').city.toLowerCase().capitalize(), 'The city should match');
        String resStreet = result.addressMap.get('bezoekadres').street + ' ' + result.addressMap.get('bezoekadres').houseNumber;
        if (result.addressMap.get('bezoekadres').houseNumberAddition != null) {
            resStreet += ' ' + result.addressMap.get('bezoekadres').houseNumberAddition;
        }
        System.assertEquals(resultStreet, resStreet, 'The Streets should match');
        System.assertEquals(resultPostalCode, result.addressMap.get('bezoekadres').postalCode, 'The postal codes should match');
        System.assertEquals(resultCountry, result.addressMap.get('bezoekadres').country, 'The countries should match');
        System.assertEquals(resultDeregistrationDate, result.deregistrationDate, 'The deregistrationDates should match');
        System.assertEquals(resultIsBranch, result.isBranch, 'Branch should match');
        System.assertEquals(resultIsMainBranch, result.isMainBranch, 'Main Branch should match');
        System.assertEquals(null, resultOther, 'Other values should be null');
    }

    @IsTest
    static void testUpdateRecord() {
        SCDTestDataFactory tdf = new SCDTestDataFactory();
        List<HttpResponse> responses = new List<HttpResponse>();
        List<MappingDetail__mdt> details = tdf.mappingDetailAccount;
        System.debug('mapping detail: ' + details);

        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;

        Database.SaveResult result;
        
        Map<String, CoCAddress> testAddressMap = new Map<String, CoCAddress>();
        CoCAddress visitingAddress = new CoCAddress();
        visitingAddress.street = 'Stadsplateau';
        visitingAddress.houseNumber = '27';
        visitingAddress.houseNumberAddition = '';
        visitingAddress.postalCode = '3521AZ';
        visitingAddress.city = 'Utrecht';
        visitingAddress.country = 'Nederland';
        visitingAddress.name = 'bezoekadres';
        visitingAddress.latitude = '';
        visitingAddress.longitude = '';

        testAddressMap.put('bezoekadres', visitingAddress);

        List<String> tradenamesList = new List<String>();
        tradenamesList.add('2ManyDigits B.V.');

        CoCProfile updater = new CoCProfile();
        updater.identifier = '78350980';
        updater.branchIdentifier = '000043327516';
        updater.rsin = '861360850';
        updater.name = '2ManyDigits B.V.';
        updater.isBranch = true;
        updater.isMainBranch = true;
        updater.legalForm = 'Besloten Vennootschap';
        updater.deregistrationDate = '20200619';
        updater.tradenames = tradenamesList;
        updater.addressMap = testAddressMap;

        Test.startTest();
        result = updater.updateRecord(acc, details);
        Test.stopTest();

        Account afterUpdateResult = [SELECT Id, Name, Chamber_of_Commerce__c, Branch_Identifier__c, is_Branch__c, is_Main_Branch__c, BillingAddress FROM Account WHERE Id =: acc.Id];

        System.assertEquals('78350980', afterUpdateResult.Chamber_of_Commerce__c, 'Excpected 78350980, but found: ' + afterUpdateResult.Chamber_of_Commerce__c);
        System.assertEquals('2ManyDigits B.V.', afterUpdateResult.Name, 'Excpected 2ManyDigits B.V., but found: ' + afterUpdateResult.Name);
        System.assertEquals('000043327516', afterUpdateResult.Branch_Identifier__c, 'Excpected 000043327516, but found: ' + afterUpdateResult.Branch_Identifier__c);
    }
}