@IsTest
private class DescribeUtilsTest {
    
    @IsTest static void testGetFieldLabelBySObjectAndFieldname(){
        DescribeUtils utils = new DescribeUtils();

        Test.startTest();

        String accountNameFieldLabel = utils.getFieldLabelBySObjectAndFieldname('Account', 'Name');

        Test.stopTest();

        system.assertEquals('Account Name', accountNameFieldLabel, 'Labels should match');
    }

    @IsTest static void testGetFieldLabelBySObjectAndFieldnameInvalid(){
        DescribeUtils utils = new DescribeUtils();

        Test.startTest();

        String accountNameFieldLabel = utils.getFieldLabelBySObjectAndFieldname(null, 'Name');

        Test.stopTest();

        system.assertEquals(null, accountNameFieldLabel, 'Invalid input should return null');
    }
}
