@IsTest
private class GetSObjectRecordByMappingInvocableTest {
    
    @IsTest static void testGetSObjectRecordByMappingInvocable(){
        Account a = new Account(Name = 'ACME');
        insert a;

        Test.startTest();
        
        List<SObjectRecordByMappingRequest> reqList = new List<SObjectRecordByMappingRequest>();
        SObjectRecordByMappingRequest req = new SObjectRecordByMappingRequest();
        req.recordId = a.Id;
        req.sObjectType = 'Account';
        req.mappingDetailList = new SCDTestDataFactory().mappingDetailAccount;

        reqList.add(req);

        List<SObject> objList = GetSObjectRecordByMappingInvocable.getSObjectRecordByMapping(reqList);

        Test.stopTest();

        system.assertEquals(1, objList.size(), 'There should be 1 record returned');
        Sobject obj = objList.get(0);
        system.assertEquals(a.Id, (String)obj.get('Id'), 'The Ids should match');
    }
}
