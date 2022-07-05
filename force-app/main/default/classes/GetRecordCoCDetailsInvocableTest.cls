@IsTest
private class GetRecordCoCDetailsInvocableTest {
    
    @IsTest static void testGetRecordCoCDetails(){
        Account a = new Account();
        a.Name = 'ACME';
        a.BillingCity = 'City';
        a.BillingCountry = 'NL';
        a.BillingStreet = 'StreetName';
        a.BillingPostalCode = '1234AB';
        insert a;



        List<GetRecordCoCDetailsInvocable.InvocableCOCDataRequest> reqList = new List<GetRecordCoCDetailsInvocable.InvocableCOCDataRequest>();
        GetRecordCoCDetailsInvocable.InvocableCOCDataRequest req = new GetRecordCoCDetailsInvocable.InvocableCOCDataRequest();
        req.recordId = a.Id;
        req.sObjectType = 'Account';
        req.mappingDetail = new SCDTestDataFactory().mappingDetailAccount;

        reqList.add(req);

        Test.startTest();

        List<GetRecordCoCDetailsInvocable.CoCRecordDetails> details = GetRecordCoCDetailsInvocable.getRecordCoCDetails(reqList);

        Test.stopTest();

        system.assertEquals(1, details.size(), 'There should be 1 entry returned');
        system.assertEquals(null, details.get(0).isBranch, 'Since the fields are not mapped by default, isBranch should return null');
        system.assertEquals(null, details.get(0).isMainBranch, 'Since the fields are not mapped by default, isMainBranch should return null');
        system.assertEquals(null, details.get(0).identifier, 'Since the fields are not mapped by default, identifier should return null');
    }
}
