@IsTest
private class GetSObjectTypeInvocableTest {
    
    @IsTest static void testgetSObjectById(){
        Account a = new Account(Name = 'ACME');
        insert a;

        List<Id> idList = new List<Id>();
        idList.add(a.Id);

        Test.startTest();

        List<String> objectNameList = GetSObjectTypeInvocable.getSObjectById(idList);

        Test.stopTest();

        system.assertEquals(1, objectNameList.size(), 'There should be 1 ObjectName returned');
        system.assertEquals('Account', objectNameList.get(0), 'The Objectname should be Account');

    }
}
