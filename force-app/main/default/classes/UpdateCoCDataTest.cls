@IsTest
private class UpdateCoCDataTest {

    @IsTest static void testGetCoCData(){
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

        Test.startTest();
        
        CoCProfile result = new UpdateCoCData(new KVKDataProviderV2()).getCoCData(identifier, isBranch, isMainBranch);

        Test.stopTest();

        system.assertEquals((String)result.getProfileInformationByFieldname('identifier'), result.identifier, 'The Chamber Of Commerce numbers should match');
    }

    @IsTest static void testGetCoCDataUsingMockNoBranch(){
        String identifier = 'test';
        Boolean isBranch = false;
        Boolean isMainBranch = true;
        
        Test.startTest();
        
        CoCProfile result = new UpdateCoCData(new MockDataProvider()).getCoCData(identifier, isBranch, isMainBranch);

        Test.stopTest();

        system.assertEquals((String)result.getProfileInformationByFieldname('identifier'), result.identifier, 'The Chamber Of Commerce numbers should match');
    }

    @IsTest static void testGetCoCDataUsingMockIsBranch(){
        String identifier = 'test';
        Boolean isBranch = true;
        Boolean isMainBranch = false;
        
        Test.startTest();
        
        CoCProfile result = new UpdateCoCData(new MockDataProvider()).getCoCData(identifier, isBranch, isMainBranch);

        Test.stopTest();

        system.assertEquals((String)result.getProfileInformationByFieldname('identifier'), result.identifier, 'The Chamber Of Commerce numbers should match');
    }
    
}
