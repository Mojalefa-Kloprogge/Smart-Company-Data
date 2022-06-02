@isTest
public inherited sharing class KVKDataProviderV2Test {
    static final String searchResponse = '{"apiVersion": "2.0","meta": {},"data": {"itemsPerPage": 10,"startPage": 1,"totalItems": 2,"items": [{"kvkNumber": "68727720","branchNumber": "000037143557","rsin": "857567433","tradeNames": {"businessName": "Test NV Katrien","shortBusinessName": "Test NV Katrien","currentTradeNames": ["Test NV Katrien"],"currentStatutoryNames": ["Test NV Katrien"]},"hasEntryInBusinessRegister": true,"hasNonMailingIndication": true,"isLegalPerson": false,"isBranch": true,"isMainBranch": true,"addresses": [{"type": "vestigingsadres","street": "Rietdekkershof","houseNumber": "8","houseNumberAddition": "","postalCode": "9646AS","city": "Veendam","country": "Nederland"}]},{"kvkNumber": "68727720","rsin": "857567433","tradeNames": {"shortBusinessName": "Test NV Katrien","currentStatutoryNames": ["Test NV Katrien"]},"hasEntryInBusinessRegister": true,"hasNonMailingIndication": true,"isLegalPerson": true,"isBranch": false,"isMainBranch": false}]}}';
    static final String profileResponse = '{"apiVersion": "2.0","meta": {},"data": {"itemsPerPage": 1,"startPage": 1,"totalItems": 1,"items": [{"kvkNumber": "68750110","branchNumber": "000037178598", "rsin": "857587973","tradeNames": {"businessName": "Test BV Donald","shortBusinessName": "Test BV Donald","currentTradeNames": ["Test BV Donald"],"currentStatutoryNames": ["Test BV Donald"]},"legalForm": "Besloten vennootschap met gewone structuur","businessActivities": [{"sbiCode": "93127","sbiCodeDescription": "Auto- en motorsport","isMainSbi": true }],"hasEntryInBusinessRegister": true,"hasCommercialActivities": true,"hasNonMailingIndication": true,"isLegalPerson": false,"isBranch": true,"isMainBranch": true,"employees": 1,"foundationDate": "20170519","registrationDate": "20170519","addresses": [{"type": "vestigingsadres","bagId": "1234","street": "Hizzaarderlaan","houseNumber": "3","houseNumberAddition": "","postalCode": "8823SJ","city": "Lollum","country": "Nederland","gpsLatitude": 53.11730862530632,"gpsLongitude": 5.516337463740755,"rijksdriehoekX": 163645.584,"rijksdriehoekY": 570066.41,"rijksdriehoekZ": 0},{"type": "correspondentieadres","bagId": "","street": "Postbus","houseNumber": "200", "houseNumberAddition": "","postalCode": "1000AE","city": "Rommeldam","country": "Nederland"}]}]}}';
    static final String bagResponse = '{"_embedded": {"adressen": [{"openbareRuimteNaam": "Tuinbouwweg","korteNaam": "Tuinbouwweg","huisnummer": 2,"huisletter": "E","postcode": "2742KP","woonplaatsNaam": "Waddinxveen","nummeraanduidingIdentificatie": "0627200000249130","openbareRuimteIdentificatie": "0627300000000255","woonplaatsIdentificatie": "3051","adresseerbaarObjectIdentificatie": "0627010000031926","pandIdentificaties": ["0627100000021567"]}]}}';

    @isTest
    public static void testSearch() {
        List<HttpResponse> responses = new List<HttpResponse>();

        HttpResponse resp = new HttpResponse();
        resp.setStatusCode(200);
        resp.setBody(KVKDataProviderV2Test.searchResponse);

        responses.add(resp);

        HttpMock mock = new HttpMock(responses);
        Test.setMock(HttpCalloutMock.class, mock);

        List<CoCData> results;

        Test.startTest();
        KVKDataProviderV2 provider = new KVKDataProviderV2();
        results = provider.searchByTerm('testTerm');
        Test.stopTest();

        System.assertEquals(2, results.size(), 'Expected 2 results, found: ' + results.size());
    }

    @isTest
    public static void testGetProfile() {
        List<HttpResponse> responses = new List<HttpResponse>();

        HttpResponse resp = new HttpResponse();
        resp.setStatusCode(200);
        resp.setBody(KVKDataProviderV2Test.profileResponse);

        responses.add(resp);

        HttpResponse respBAG = new HttpResponse();
        respBAG.setStatusCode(200);
        respBAG.setBody(KVKDataProviderV2Test.bagResponse);

        responses.add(respBAG);

        HttpMock mock = new HttpMock(responses);
        Test.setMock(HttpCalloutMock.class, mock);

        CoCProfile result;

        Test.startTest();
        KVKDataProviderV2 provider = new KVKDataProviderV2();
        result = provider.getProfile('test', false, true);
        Test.stopTest();

        System.assertEquals('68750110', result.identifier, 'Expected 68750110, found: ' + result.identifier);
        System.assertEquals(
            'Hizzaarderlaan',
            result.addressMap.get('vestigingsadres').street,
            'Expected Hizzaarderlaan, found: ' + result.addressMap.get('vestigingsadres').street
        );
        System.assertEquals(
            'Waddinxveen',
            result.addressMap.get('vestigingsadres').city,
            'Expected Waddinxveen, found: ' + result.addressMap.get('vestigingsadres').city
        );
    }

    @isTest
    public static void testGetProfileBranch() {
        List<HttpResponse> responses = new List<HttpResponse>();

        HttpResponse resp = new HttpResponse();
        resp.setStatusCode(200);
        resp.setBody(KVKDataProviderV2Test.profileResponse);

        responses.add(resp);

        HttpResponse respBAG = new HttpResponse();
        respBAG.setStatusCode(200);
        respBAG.setBody(KVKDataProviderV2Test.bagResponse);

        responses.add(respBAG);

        HttpMock mock = new HttpMock(responses);
        Test.setMock(HttpCalloutMock.class, mock);

        CoCProfile result;

        Test.startTest();
        KVKDataProviderV2 provider = new KVKDataProviderV2();
        result = provider.getProfile('test', true, false);
        Test.stopTest();

        System.assertEquals('68750110', result.identifier, 'Expected 68750110, found: ' + result.identifier);
        System.assertEquals(
            'Hizzaarderlaan',
            result.addressMap.get('vestigingsadres').street,
            'Expected Hizzaarderlaan, found: ' + result.addressMap.get('vestigingsadres').street
        );
        System.assertEquals(
            'Waddinxveen',
            result.addressMap.get('vestigingsadres').city,
            'Expected Waddinxveen, found: ' + result.addressMap.get('vestigingsadres').city
        );
    }
}