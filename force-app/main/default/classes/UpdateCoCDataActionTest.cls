@isTest
public inherited sharing class UpdateCoCDataActionTest {
    static final String profileResponse = '{"apiVersion": "2.0","meta": {},"data": {"itemsPerPage": 1,"startPage": 1,"totalItems": 1,"items": [{"kvkNumber": "68750110","branchNumber": "000037178598", "rsin": "857587973","tradeNames": {"businessName": "Test BV Donald","shortBusinessName": "Test BV Donald","currentTradeNames": ["Test BV Donald"],"currentStatutoryNames": ["Test BV Donald"]},"legalForm": "Besloten vennootschap met gewone structuur","businessActivities": [{"sbiCode": "93127","sbiCodeDescription": "Auto- en motorsport","isMainSbi": true }],"hasEntryInBusinessRegister": true,"hasCommercialActivities": true,"hasNonMailingIndication": true,"isLegalPerson": false,"isBranch": true,"isMainBranch": true,"employees": 1,"foundationDate": "20170519","registrationDate": "20170519","addresses": [{"type": "vestigingsadres","bagId": "1234","street": "Hizzaarderlaan","houseNumber": "3","houseNumberAddition": "","postalCode": "8823SJ","city": "Lollum","country": "Nederland","gpsLatitude": 53.11730862530632,"gpsLongitude": 5.516337463740755,"rijksdriehoekX": 163645.584,"rijksdriehoekY": 570066.41,"rijksdriehoekZ": 0},{"type": "correspondentieadres","bagId": "","street": "Postbus","houseNumber": "200", "houseNumberAddition": "","postalCode": "1000AE","city": "Rommeldam","country": "Nederland"}]}]}}';
    static final String bagResponse = '{"_embedded": {"adressen": [{"openbareRuimteNaam": "Tuinbouwweg","korteNaam": "Tuinbouwweg","huisnummer": 2,"huisletter": "E","postcode": "2742KP","woonplaatsNaam": "Waddinxveen","nummeraanduidingIdentificatie": "0627200000249130","openbareRuimteIdentificatie": "0627300000000255","woonplaatsIdentificatie": "3051","adresseerbaarObjectIdentificatie": "0627010000031926","pandIdentificaties": ["0627100000021567"]}]}}';

    @isTest
    public static void actionTest() {
        List<HttpResponse> responses = new List<HttpResponse>();

        HttpResponse resp = new HttpResponse();
        resp.setStatusCode(200);
        resp.setBody(UpdateCoCDataActionTest.profileResponse);

        responses.add(resp);

        HttpResponse respBAG = new HttpResponse();
        respBAG.setStatusCode(200);
        respBAG.setBody(UpdateCoCDataActionTest.bagResponse);

        responses.add(respBAG);

        HttpMock mock = new HttpMock(responses);
        Test.setMock(HttpCalloutMock.class, mock);

        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;

        List<UpdateCoCDataAction.UpdateCoCDataRequest> reqList = new List<UpdateCoCDataAction.UpdateCoCDataRequest>();
        UpdateCoCDataAction.UpdateCoCDataRequest req = new UpdateCoCDataAction.UpdateCoCDataRequest();
        req.recordId = acc.Id;
        req.isBranch = false;
        req.identifier = '1234';
        reqList.add(req);

        List<UpdateCoCDataAction.UpdateCoCDataResult> result;

        Test.startTest();
        result = UpdateCoCDataAction.UpdateCoCDataAction(reqList);
        Test.stopTest();

        System.assertEquals(true, result.get(0).isSuccess, 'Expected true but found: ' + result.get(0));
    }
}