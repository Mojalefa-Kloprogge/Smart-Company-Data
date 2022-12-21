@isTest
public inherited sharing class UpdateCoCDataActionTest {
    
    @isTest
    public static void actionTest() {
        SCDTestDataFactory tdf = new SCDTestDataFactory();
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

        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;

        List<UpdateCoCDataAction.UpdateCoCDataRequest> reqList = new List<UpdateCoCDataAction.UpdateCoCDataRequest>();
        UpdateCoCDataAction.UpdateCoCDataRequest req = new UpdateCoCDataAction.UpdateCoCDataRequest();
        req.recordId = acc.Id;
        req.isBranch = false;
        req.identifier = '1234';
        req.mappingDetail = tdf.mappingDetailAccount;
        req.sObjectType = 'Account';
        reqList.add(req);

        //List<UpdateCoCDataAction.UpdateCoCDataResult> result;
        List<String> result;

        Test.startTest();
        result = UpdateCoCDataAction.UpdateCoCDataAction(reqList);
        Test.stopTest();

        //System.assertEquals(true, result.get(0).isSuccess, 'Expected true but found: ' + result.get(0).isSuccess);
        System.assert(result.get(0).startsWithIgnoreCase('true'), 'Expected true in the result but found: ' + result);
    }
}