@IsTest
private class CoCSuggestionsControllerTest {
    
    @IsTest static void testGetSuggestions(){
        Account a = new Account(Name = 'ACME');
        insert a;

        CoCDataRequest request = new CoCDataRequest();
        request.identifier = 'test';
        request.isBranch = false;
        request.isMainBranch = true;
        request.mappingDetail = new SCDTestDataFactory().mappingDetailAccount;
        request.recordId = a.Id;
        request.sObjectType = 'Account';
        
        List<HttpResponse> responses = new List<HttpResponse>();

        HttpResponse respBAG = new HttpResponse();
        respBAG.setStatusCode(200);
        respBAG.setBody(SCDTestDataFactory.PROFILE_RESPONSE);

        responses.add(respBAG);

        HttpMock mock = new HttpMock(responses);
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();

        CoCSuggestionsController.CoCSuggestion sugg = CoCSuggestionsController.getAccountInfoFromCoC(request);
        
        Test.stopTest();

        for(CoCSuggestionsController.CoCSuggestionField fld : sugg.fields){
            if(fld.fieldName.equalsIgnoreCase('name')){
                system.assertEquals('2ManyDigits B.V.', fld.fieldValueSuggested);
            }else if(fld.fieldName.equalsIgnoreCase('Billing Country')){
                system.assertEquals('Nederland', fld.fieldValueSuggested);
            }
        }
    }

    @IsTest static void testGetSuggestionsInvalid(){
        Test.startTest();

        CoCSuggestionsController.CoCSuggestion sugg = CoCSuggestionsController.getAccountInfoFromCoC(null);
        
        Test.stopTest();

        system.assertEquals(0, sugg.fields.size(), 'there should be nothing returned');
    }
}
