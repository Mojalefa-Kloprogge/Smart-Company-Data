@isTest
public inherited sharing class KVKDataProviderV2Test {
    
    @isTest
    public static void testSearch() {
        List<HttpResponse> responses = new List<HttpResponse>();

        HttpResponse resp = new HttpResponse();
        resp.setStatusCode(200);
        resp.setBody(SCDTestDataFactory.SEARCH_RESPONSE);

        responses.add(resp);

        HttpMock mock = new HttpMock(responses);
        Test.setMock(HttpCalloutMock.class, mock);

        List<CoCData> results;

        Test.startTest();
        KVKDataProviderV2 provider = new KVKDataProviderV2();
        results = provider.searchByTerm('testTerm');
        Test.stopTest();

        System.assertEquals(4, results.size(), 'Expected 4 results, found: ' + results.size());
    }

    @isTest
    public static void testGetProfile() {
        List<HttpResponse> responses = new List<HttpResponse>();

        HttpResponse resp = new HttpResponse();
        resp.setStatusCode(200);
        resp.setBody(SCDTestDataFactory.PROFILE_RESPONSE);

        responses.add(resp);

        HttpResponse respBAG = new HttpResponse();
        respBAG.setStatusCode(200);
        respBAG.setBody(SCDTestDataFactory.BAG_RESPONSE);

        responses.add(respBAG);

        HttpMock mock = new HttpMock(responses);
        Test.setMock(HttpCalloutMock.class, mock);

        CoCProfile result;

        Test.startTest();
        KVKDataProviderV2 provider = new KVKDataProviderV2();
        result = provider.getProfile('test', false, true);
        Test.stopTest();

        System.assertEquals('78350980', result.identifier, 'Expected 78350980, found: ' + result.identifier);
        System.assertEquals(
            'Utrechtseweg',
            result.addressMap.get('bezoekadres').street,
            'Expected Utrechtseweg, found: ' + result.addressMap.get('bezoekadres').street
        );
        System.assertEquals(
            'De Bilt',
            result.addressMap.get('bezoekadres').city,
            'Expected De Bilt, found: ' + result.addressMap.get('bezoekadres').city
        );
    }

    @isTest
    public static void testGetProfileBranch() {
        List<HttpResponse> responses = new List<HttpResponse>();

        HttpResponse respBAG = new HttpResponse();
        respBAG.setStatusCode(200);
        respBAG.setBody(SCDTestDataFactory.BAG_RESPONSE);

        responses.add(respBAG);

        HttpMock mock = new HttpMock(responses);
        Test.setMock(HttpCalloutMock.class, mock);

        CoCProfile result;

        Test.startTest();
        KVKDataProviderV2 provider = new KVKDataProviderV2();
        result = provider.getProfile('test', true, false);
        Test.stopTest();

        System.assertEquals('78350980', result.identifier, 'Expected 78350980, found: ' + result.identifier);
        System.assertEquals(
            'Utrechtseweg',
            result.addressMap.get('bezoekadres').street,
            'Expected Utrechtseweg, found: ' + result.addressMap.get('bezoekadres').street
        );
        System.assertEquals(
            'De Bilt',
            result.addressMap.get('bezoekadres').city,
            'Expected De Bilt, found: ' + result.addressMap.get('bezoekadres').city
        );
    }
}