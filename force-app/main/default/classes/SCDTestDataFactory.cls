@IsTest
public class SCDTestDataFactory {
    public static final String SEARCH_RESPONSE = '{"pagina":1,"aantal":100,"totaal":4,"resultaten":[{"kvkNummer":"78350980","vestigingsnummer":"000043327516","handelsnaam":"2ManyDigits B.V.","straatnaam":"Utrechtseweg","plaats":"De Bilt","type":"hoofdvestiging","actief":"Ja"},{"kvkNummer":"75459094","vestigingsnummer":"000043327516","handelsnaam":"2ManyDigits","straatnaam":"Utrechtseweg","plaats":"De Bilt","type":"hoofdvestiging","actief":"Nee"},{"kvkNummer":"78350980","handelsnaam":"2ManyDigits B.V.","type":"rechtspersoon","actief":"Ja"},{"kvkNummer":"71103155","vestigingsnummer":"000039317102","handelsnaam":"CRM Digits","straatnaam":"Rechterslaan","plaats":"Heilig Landstichting","type":"hoofdvestiging","actief":"Nee","vervallenNaam":"2manydigits"}]}';
    public static final String PROFILE_RESPONSE = '{"kvkNummer":"78350980","indNonMailing":"Ja","naam":"2ManyDigits B.V.","formeleRegistratiedatum":"20200623","materieleRegistratie":{"datumAanvang":"20200619"},"totaalWerkzamePersonen":3,"statutaireNaam":"2ManyDigits B.V.","handelsnamen":[{"naam":"2ManyDigits B.V.","volgorde":0}],"sbiActiviteiten":[{"sbiCode":"6202","sbiOmschrijving":"Advisering en ondersteuning op het gebied van informatietechnologie","indHoofdactiviteit":"Ja"},{"sbiCode":"6201","sbiOmschrijving":"Ontwikkelen, produceren en uitgeven van software","indHoofdactiviteit":"Nee"},{"sbiCode":"7810","sbiOmschrijving":"Arbeidsbemiddeling","indHoofdactiviteit":"Nee"}],"_embedded":{"hoofdvestiging":{"vestigingsnummer":"000043327516","kvkNummer":"78350980","formeleRegistratiedatum":"20200623","materieleRegistratie":{"datumAanvang":"20190801"},"eersteHandelsnaam":"2ManyDigits B.V.","indHoofdvestiging":"Ja","indCommercieleVestiging":"Ja","totaalWerkzamePersonen":3,"adressen":[{"type":"bezoekadres","indAfgeschermd":"Nee","volledigAdres":"Utrechtseweg 322 3731GD De Bilt","straatnaam":"Utrechtseweg","huisnummer":322,"postcode":"3731GD","plaats":"De Bilt","land":"Nederland"}],"websites":["www.2manydigits.com"]},"eigenaar":{"rsin":"861360850","rechtsvorm":"Besloten Vennootschap","uitgebreideRechtsvorm":"Besloten Vennootschap"}}}';
    public static final String BAG_RESPONSE = '{"vestigingsnummer":"000043327516","kvkNummer":"78350980","rsin":"861360850","indNonMailing":"Ja","formeleRegistratiedatum":"20200623","materieleRegistratie":{"datumAanvang":"20190801"},"eersteHandelsnaam":"2ManyDigits B.V.","indHoofdvestiging":"Ja","indCommercieleVestiging":"Ja","voltijdWerkzamePersonen":3,"totaalWerkzamePersonen":3,"deeltijdWerkzamePersonen":0,"handelsnamen":[{"naam":"2ManyDigits B.V.","volgorde":0}],"adressen":[{"type":"bezoekadres","indAfgeschermd":"Nee","volledigAdres":"Utrechtseweg 322 3731GD De Bilt","straatnaam":"Utrechtseweg","huisnummer":322,"postcode":"3731GD","plaats":"De Bilt","land":"Nederland"}],"websites":["www.2manydigits.com"],"sbiActiviteiten":[{"sbiCode":"6202","sbiOmschrijving":"Advisering en ondersteuning op het gebied van informatietechnologie","indHoofdactiviteit":"Ja"},{"sbiCode":"6201","sbiOmschrijving":"Ontwikkelen, produceren en uitgeven van software","indHoofdactiviteit":"Nee"},{"sbiCode":"7810","sbiOmschrijving":"Arbeidsbemiddeling","indHoofdactiviteit":"Nee"}]}';

    public List<MappingDetail__mdt> mappingDetailAccount;
    public List<MappingDetail__mdt> mappingDetailLead;
    public List<MappingDetail__mdt> mappingDetailContact;

    public SCDTestDataFactory() {
        this.setMappingRecords();
    }

    private void setMappingRecords(){
        Id accountMappingId;
        Id leadMappingId;
        Id contactMappingId;
        for(MappingConfiguration__mdt mc : [Select Id, ObjectName__c, MergeStreetAndHousenumber__c FROM MappingConfiguration__mdt]){
            switch on mc.ObjectName__c {
                when 'Account' {
                    accountMappingId = mc.Id;
                } when 'Contact' {
                    contactMappingId = mc.Id;
                } when 'Lead' {
                    leadMappingId = mc.Id;
                }
                when else {
                    //Do Nothing, PMD made me put in this fake statement
                    Boolean bool = false;
                }
            } 
        }
        this.mappingDetailAccount = [SELECT Id, SalesforceField__c, SmartCompanyDataField__c FROM MappingDetail__mdt WHERE MappingConfiguration__c =: accountMappingId];
        this.mappingDetailLead = [SELECT Id, SalesforceField__c, SmartCompanyDataField__c FROM MappingDetail__mdt WHERE MappingConfiguration__c =: leadMappingId];
        this.mappingDetailContact = [SELECT Id, SalesforceField__c, SmartCompanyDataField__c FROM MappingDetail__mdt WHERE MappingConfiguration__c =: contactMappingId];
        System.debug(LoggingLevel.Error, 'Account Mapping: ' + this.mappingDetailAccount);
        System.debug(LoggingLevel.Error, 'Lead Mapping: ' + this.mappingDetailLead);
        System.debug(LoggingLevel.Error, 'Contact Mapping: ' + this.mappingDetailContact);
    }
}
