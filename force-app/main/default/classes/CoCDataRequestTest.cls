@IsTest
private class CoCDataRequestTest {
    
    @IsTest static void testSettersAndGetters(){
        SCDTestDataFactory tdf = new SCDTestDataFactory();
        String identifier = '1234567';
        Boolean isBranch = true;
        Boolean isMainBranch = false;
        String sObjectType = 'Account';
        String recordId = '1234567890';
        List<MappingDetail__mdt> mappingDetail = tdf.mappingDetailAccount;

        Test.startTest();

        CoCDataRequest request = new CoCDataRequest();
        request.identifier = identifier;
        request.isBranch = true;
        request.isMainBranch = false;
        request.sObjectType = sObjectType;
        request.recordId = recordId;
        request.mappingDetail = tdf.mappingDetailAccount;

        Test.stopTest();
        
        system.assertEquals(request.identifier, identifier, 'The Identifiers should match');
        system.assertEquals(request.isBranch, isBranch, 'The IsBranch should be true');
        system.assertEquals(request.isMainBranch, isMainBranch, 'The IsMainBranch should be false');
        system.assertEquals(request.sObjectType, sObjectType, 'The sObjectTypes should match');
        system.assertEquals(request.recordId, recordId, 'The recordIds should match');
        system.assertEquals(request.mappingDetail, tdf.mappingDetailAccount, 'the Mappingdetails should match');
    }
}
