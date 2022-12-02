public with sharing class KVKDataProviderV2 implements IDataProvider {
    private String endpoint;
    private String environment;
    private String apiKey;

    public KVKDataProviderV2() {
        Chamber_of_Commerce_Setting__mdt settings = Chamber_of_Commerce_Setting__mdt.getInstance('SmartCompanyData');
        this.endpoint = settings.Endpoint__c;
        this.environment = settings.Environment__c;
        this.apiKey = settings.Api_Key__c;
    }

    public List<CoCData> searchByTerm(String searchTerm) {
        List<CoCData> result = new List<CoCData>();
        Http http = new Http();
        HttpResponse resp = http.send(
            createRequest(endpoint, environment, 'searchv2', '?handelsnaam=' + searchTerm.replaceAll(' ', '+') + '&inclusiefInactieveRegistraties=true&aantal=100')
        );
        String body = resp.getBody();
        if(body != ''){
            KVKSearchResponse parsedResp = (KVKSearchResponse) JSON.deserialize(body, KVKSearchResponse.class);
            result.addAll(createCoCDataFromSearchResponse(parsedResp));
        }
        return result;
    }

    private List<CoCData> createCoCDataFromSearchResponse(KVKSearchResponse parsedResp) {
        List<CoCData> result = new List<CoCData>();
        if (parsedResp.totaal > 0) {
            for (KVKItem item : parsedResp.resultaten) {
                result.add(createCoCDataFromKVKItem(item));
            }
        }
        return result;
    }

    private CoCData createCoCDataFromKVKItem(KVKItem item) {
        CoCData cocData = new CoCData();
        cocData.identifier = item.kvkNummer;
        cocData.branchIdentifier = item.vestigingsnummer;
        cocData.isMainBranch = item.type.equalsIgnoreCase('hoofdvestiging');
        if (item.actief.equalsIgnoreCase('Ja')) {
            cocData.activeIcon = 'utility:check';
        } else {
            cocData.activeIcon = 'utility:clear';
        }
        if (item.type.equalsIgnoreCase('hoofdvestiging')) {
            cocData.mainIcon = 'utility:check';
        } else {
            cocData.mainIcon = 'utility:clear';
        }
        cocData.name = item.handelsnaam;
        if (item.straatnaam != null){
            cocData.street = item.straatnaam;
        }
        if (item.plaats != null){
            cocData.city = item.plaats;
        }
        if (item.postcode != null){
            cocData.postalCode = item.postcode;
        }
        if (item.huisnummer != null){
            cocData.houseNumber = String.valueOf(item.huisnummer);
        } 
        return cocData;
    }

    public CoCProfile getProfile(String identifier, Boolean isBranch, Boolean isMainBranch) {
        CoCProfile result;
        if (isBranch && !isMainBranch) {
            result = getEstablishmentProfile(identifier, isBranch, isMainBranch);
        } else {
            result = getBasicProfile(identifier, isBranch, isMainBranch);
        }
        return result;
    }

    private CoCProfile getBasicProfile(String identifier, Boolean isBranch, Boolean isMainBranch){
        String type = 'basic';
        String query = '/' + identifier;

        Http http = new Http();
        HttpResponse resp = http.send(createRequest(endpoint, environment, type, query));
        String body = resp.getBody();
    
        KVKBasic parsedResp = (KVKBasic) JSON.deserialize(body.replace('_embedded', 'embedded'), KVKBasic.class);
        return createCoCProfileFromKVKBasic(parsedResp);
    }

    private CoCProfile getEstablishmentProfile(String identifier, Boolean isBranch, Boolean isMainBranch){
        String type = 'establishment';
        String query = '/' + identifier;

        Http http = new Http();
        HttpResponse resp = http.send(createRequest(endpoint, environment, type, query));
        String body = resp.getBody();

        KVKVestiging parsedResp = (KVKVestiging) JSON.deserialize(body, KVKVestiging.class);
        return createCoCProfileFromKVKVestiging(parsedResp);
    }

    private CoCProfile createCoCProfileFromKVKBasic(KVKBasic kvkBasic){
        CoCProfile profile = new CoCProfile();
        profile.identifier = kvkBasic.kvkNummer;
        profile.branchidentifier = kvkBasic.embedded.hoofdvestiging.vestigingsnummer;
        if(kvkBasic.embedded.hoofdvestiging.adressen != null){
            profile.addressMap = new Map<String, CoCAddress>();
            for (KVKAdres kvkAdres : kvkBasic.embedded.hoofdvestiging.adressen) {
                CoCAddress cocAddress = new CoCAddress();
                cocAddress.city = kvkAdres.plaats;
                cocAddress.street = kvkAdres.straatnaam;
                if (kvkAdres.postcode.length() == 6) {
                    cocAddress.postalCode = kvkAdres.postcode.substring(0, 4) + ' ' + kvkAdres.postcode.substring(4, 6);
                }
                cocAddress.houseNumber = String.valueOf(kvkAdres.huisnummer);
                cocAddress.houseNumberAddition = kvkAdres.huisnummerToevoeging;
                cocAddress.country = kvkAdres.land;
                cocAddress.name = kvkAdres.type;
                if (kvkAdres.geoData != null && kvkAdres.geoData.addresseerbaarObjectId != '') {
                    cocAddress = insertBAGInformationInAddress(cocAddress, kvkAdres.geoData.addresseerbaarObjectId);
                }
                profile.addressMap.put(cocAddress.name, cocAddress);
            }
        }
        if(kvkBasic.embedded?.hoofdvestiging?.eersteHandelsnaam != null){
            profile.name = kvkBasic.embedded.hoofdvestiging.eersteHandelsnaam;
        }else{
            profile.name = kvkBasic.naam;
        }
        if (kvkBasic.handelsnamen != null) {
            profile.tradeNames = new List<String>();
            for (KVKHandelsnaam handelsnaam : kvkBasic.handelsnamen) {
                profile.tradeNames.add(handelsnaam.naam);
            }
        }
        profile.isBranch = kvkBasic.embedded.hoofdvestiging.indCommercieleVestiging.equalsIgnoreCase('Ja');
        profile.isMainBranch = kvkBasic.embedded.hoofdvestiging.indHoofdvestiging.equalsIgnoreCase('Ja');
        if(kvkBasic.materieleRegistratie?.datumEinde != null){
            profile.deregistrationDate = kvkBasic.materieleRegistratie.datumEinde;
        }
        profile.legalForm = kvkBasic.embedded.eigenaar.rechtsvorm;
        return profile;
    }

    private CoCProfile createCoCProfileFromKVKVestiging(KVKVestiging kvkVestiging){
        CoCProfile profile = new CoCProfile();
        profile.identifier = kvkVestiging.kvkNummer;
        profile.branchidentifier = kvkVestiging.vestigingsnummer;
        if(kvkVestiging.adressen != null){
            profile.addressMap = new Map<String, CoCAddress>();
            for (KVKAdres kvkAdres : kvkVestiging.adressen) {
                CoCAddress cocAddress = new CoCAddress();
                cocAddress.city = kvkAdres.plaats;
                cocAddress.street = kvkAdres.straatnaam;
                if (kvkAdres.postcode.length() == 6) {
                    cocAddress.postalCode = kvkAdres.postcode.substring(0, 4) + ' ' + kvkAdres.postcode.substring(4, 6);
                }
                cocAddress.houseNumber = String.valueOf(kvkAdres.huisnummer);
                cocAddress.houseNumberAddition = kvkAdres.huisnummerToevoeging;
                cocAddress.country = kvkAdres.land;
                cocAddress.name = kvkAdres.type;
                if (kvkAdres.geoData != null && kvkAdres.geoData.addresseerbaarObjectId != '') {
                    cocAddress = insertBAGInformationInAddress(cocAddress, kvkAdres.geoData.addresseerbaarObjectId);
                }
                profile.addressMap.put(cocAddress.name, cocAddress);
            }
        }
        profile.name = kvkVestiging.eersteHandelsnaam;
        if (kvkVestiging.handelsnamen != null) {
            profile.tradeNames = new List<String>();
            for (KVKHandelsnaam handelsnaam : kvkVestiging.handelsnamen) {
                profile.tradeNames.add(handelsnaam.naam);
            }
        }
        profile.isBranch = kvkVestiging.indCommercieleVestiging.equalsIgnoreCase('Ja');
        profile.isMainBranch = kvkVestiging.indHoofdvestiging.equalsIgnoreCase('Ja');
        if(kvkVestiging.materieleRegistratie.datumEinde != null){
            profile.deregistrationDate = kvkVestiging.materieleRegistratie.datumEinde;
        }
        return profile;
    }

    public CoCAddress insertBAGInformationInAddress(CoCAddress cocAddress, String bagId) {
        Http http = new Http();
        HttpResponse resp = http.send(createRequest(endpoint, environment, 'address', '?bagId=' + bagId));
        String body = resp.getBody();

        BAGResponse parsedResp = (BAGResponse) JSON.deserialize(body.replace('_embedded', 'embedded'), BAGResponse.class);

        if (parsedResp.embedded != null && parsedResp.embedded.adressen.size() > 0) {
            BAGAddress bagAddress = parsedResp.embedded.adressen.get(0);
            if (bagAddress.woonplaatsNaam != null) {
                cocAddress.city = bagAddress.woonplaatsNaam;
            }
        }
        return cocAddress;
    }

    private HttpRequest createRequest(String endpoint, String environment, String method, String query) {
        HttpRequest req = new HttpRequest();
        req.setHeader('x-org-id', UserInfo.getOrganizationId());
        req.setHeader('x-api-key', apiKey);
        req.setMethod('GET');
        req.setEndpoint(endpoint + environment + '/' + method + query);
        return req;
    }

    public class KVKSearchResponse {
        Integer aantal;
        Integer pagina;
        Integer totaal;
        List<KVKItem> resultaten;
    }

    public class KVKItem {
        String kvkNummer;
        String vestigingsnummer;
        String handelsnaam;
        String straatnaam;
        String postcode;
        String huisnummer;
        String plaats;
        String type;
        String actief;
    }

    public class KVKBasic{
        String kvkNummer;
        String indNonMailing;
        String naam;
        String formeleRegistratiedatum;
        KVKMaterieleRegistratie materieleRegistratie;
        Integer totaalWerkzamePersonen;
        List<KVKHandelsnaam> handelsnamen;
        List<KVKsbiActiviteit> sbiActiviteiten;
        KVKEmbeddedHoofdvestiging embedded;

    }

    public class KVKsbiActiviteit{
        String sbiCode;
        String sbiOmschrijving;
        String indHoofdActiviteit;
    }

    public class KVKEmbeddedHoofdvestiging{
        KVKVestiging hoofdvestiging;
        KVKEigenaar eigenaar;
    }

    public class KVKEigenaar{
        String rechtsvorm;
        String uitgebreideRechtsvorm;
    }

    public class KVKVestiging{
        String vestigingsnummer;
        String kvkNummer;
        String rsin;
        String formeleRegistratiedatum;
        KVKMaterieleRegistratie materieleRegistratie;
        String eersteHandelsnaam;
        String indHoofdvestiging;
        String indCommercieleVestiging;
        Integer totaalWerkzamePersonen;
        List<KVKHandelsnaam> handelsnamen;
        List<KVKAdres> adressen;
        List<String> websites;
        List<KVKsbiActiviteit> sbiActiviteiten;
    }

    public class KVKAdres{
        String type;
        String indAfgeschermd;
        String volledigAdres;
        String straatnaam;
        Integer huisnummer;
        String huisnummerToevoeging;
        String huisletter;
        String postcode;
        String plaats;
        String land;
        KVKAdresGeoData geoData;
    }

    public class KVKAdresGeoData{
        String addresseerbaarObjectId;
    }

    public class KVKHandelsnaam{
        String naam;
        Integer volgorde;
    }

    public class KVKMaterieleRegistratie{
        String datumAanvang;
        String datumEinde;
    }

    public class BAGResponse {
        public BAGInfo embedded;
    }

    public class BAGInfo {
        public List<BAGAddress> adressen;
    }

    public class BAGAddress {
        public String openbareRuimteNaam;
        public Integer huisnummer;
        public String postcode;
        public String woonplaatsNaam;
        public String huisletter;
        public String huisnummertoevoeging;
    }
}