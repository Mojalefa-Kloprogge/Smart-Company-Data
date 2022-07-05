@IsTest
private class SmartCompanyDataUtilsTest {
    
    @IsTest static void testGetSobjectById(){
        Account a = new Account(Name = 'ACME');
        insert a;

        Contact c = new Contact(LastName = 'lastname');
        insert c;

        Test.startTest();

        String objNameAccount = SmartCompanyDataUtils.getSObjectById(a.Id);
        String objNameContact = SmartCompanyDataUtils.getSObjectById(c.Id);

        Test.stopTest();

        system.assertEquals('Account', objNameAccount, 'The Sobject Name should be Account');
        system.assertEquals('Contact', objNameContact, 'The Sobject Name should be Contact');
    }

    @IsTest static void testGetSObjectRecordByFieldList(){
        Account a = new Account();
        a.Name = 'ACME';
        a.BillingCity = 'City';
        a.BillingCountry = 'NL';
        a.BillingPostalCode = '1234AB';
        insert a;

        Test.startTest();

        SObject obj = SmartCompanyDataUtils.getSObjectRecordByFieldList(a.Id, 'Account', new List<String>{'Name', 'BillingCity', 'BillingCountry', 'BillingPostalCode'});
        
        Test.stopTest();

        system.assertEquals(a.Id, (String)obj.get('Id'), 'The Ids should match');
        system.assertEquals(a.BillingCity, (String)obj.get('BillingCity'), 'The BillingCities should match');
        system.assertEquals(a.BillingCountry, (String)obj.get('BillingCountry'), 'The BillingCountries should match');
        system.assertEquals(a.BillingPostalCode, (String)obj.get('BillingPostalCode'), 'The BillingPostalCodes should match');
    }

    @IsTest static void testGetSObjectRecordByFieldListInvalid(){
        Account a = new Account();
        a.Name = 'ACME';
        a.BillingCity = 'City';
        a.BillingCountry = 'NL';
        a.BillingPostalCode = '1234AB';
        insert a;

        Test.startTest();
        String errMess;

        try{
            //Provide an invalid field on purpose
            SObject obj = SmartCompanyDataUtils.getSObjectRecordByFieldList(a.Id, 'Account', new List<String>{'Name', 'BillingCityXXX', 'BillingCountry', 'BillingPostalCode'});
        }catch(Exception e){
            errMess = e.getMessage();
        }
        Test.stopTest();

        system.assertEquals(Label.CoC_GetSObjectByFieldList_Error, errMess, 'The errorMessages should match');
    }

    @IsTest static void testRetrieveFieldsFromMappingDetails(){
        SCDTestDataFactory tdf = new SCDTestDataFactory();

        Test.startTest();

        List<String> fieldList = SmartCompanyDataUtils.retrieveFieldsFromMappingDetails(tdf.mappingDetailAccount);

        Test.stopTest();

        system.assertEquals(5, fieldList.size(), 'There should be 5 fields mapped for Account');
    }
}
