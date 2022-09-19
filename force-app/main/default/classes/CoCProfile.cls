public with sharing class CoCProfile {
    public String identifier;
    public String branchIdentifier;
    public String rsin;
    public String name;
    public Boolean isBranch;
    public Boolean isMainBranch;
    public String legalForm;
    public String deregistrationDate;

    public Map<String, CoCAddress> addressMap;
    public List<String> tradeNames;

    public Object getProfileInformationByFieldname(String fieldname) {
        if (fieldname.equals('identifier')) {
            return identifier;
        } else if (fieldname.equals('branchIdentifier')) {
            return branchIdentifier;
        } else if (fieldname.equals('tradenames')) {
            return String.join(this.tradeNames, ', ');	
        } else if (fieldname.equals('rsin')) {
            return rsin;
        } else if (fieldname.equals('name')) {
            return name;
        } else if (fieldname.equals('isBranch')) {
            return isBranch;
        } else if (fieldname.equals('isMainBranch')) {
            return isMainBranch;
        } else if (fieldname.equals('legalForm')) {
            return legalForm;
        } else if (fieldname.equals('city')) {
            if (this.addressMap.containskey('bezoekadres')) {
                return this.addressMap.get('bezoekadres').city.toLowerCase().capitalize();
            }
        } else if (fieldname.equals('street')) {
            if (this.addressMap.containskey('bezoekadres')) {
                String street;
                street = this.addressMap.get('bezoekadres').street + ' ' + this.addressMap.get('bezoekadres').houseNumber;
                    if (this.addressMap.get('bezoekadres').houseNumberAddition != null) {
                        street += ' ' + this.addressMap.get('bezoekadres').houseNumberAddition;
                    }
                return street;
            }
        } else if (fieldname.equals('postalCode')) {
            if (this.addressMap.containsKey('bezoekadres')) {
                return this.addressMap.get('bezoekadres').postalCode;
            }
        } else if (fieldname.equals('country')) {
            if (this.addressMap.containsKey('bezoekadres')) {
                return this.addressMap.get('bezoekadres').country;
            }
        } else if (fieldname.equals('deregistrationDate')) {
            return deregistrationDate;
        }
        return null;
    }

    public Database.SaveResult updateRecord(SObject obj, List<MappingDetail__mdt> details){

        for(MappingDetail__mdt md : details){
            String scdField = md.SmartCompanyDataField__c;
            switch on scdField {
                 when 'identifier' {
                    obj.put(md.SalesforceField__c, this.identifier);
                } when 'tradenames' {
                    obj.put(md.SalesforceField__c, String.join(this.tradeNames, ', '));
                } when 'branchIdentifier' {
                    obj.put(md.SalesforceField__c, this.branchIdentifier);
                } when 'rsin' {
                    obj.put(md.SalesforceField__c, this.rsin);
                } when 'name' {
                    obj.put(md.SalesforceField__c, this.name);
                } when 'isBranch' {
                    obj.put(md.SalesforceField__c, this.isBranch);
                } when 'isMainBranch' {
                    obj.put(md.SalesforceField__c, this.isMainBranch);
                } when 'legalForm' {                    
                    obj.put(md.SalesforceField__c, this.legalForm);
                } when 'deregistrationDate' {                  
                    obj.put(md.SalesforceField__c, this.deregistrationDate);
                } when 'street' {
                    if (this.addressMap.containskey('bezoekadres')) {
                        String street;
                        street = this.addressMap.get('bezoekadres').street + ' ' + this.addressMap.get('bezoekadres').houseNumber;
                            if (this.addressMap.get('bezoekadres').houseNumberAddition != null) {
                                street += ' ' + this.addressMap.get('bezoekadres').houseNumberAddition;
                            }
                        obj.put(md.SalesforceField__c, street);
                    }
                } when 'postalCode' {
                    if (this.addressMap.containskey('bezoekadres')) {
                        obj.put(md.SalesforceField__c, this.addressMap.get('bezoekadres').postalCode);
                    }
                } when 'country' {
                    if (this.addressMap.containskey('bezoekadres')) {
                        obj.put(md.SalesforceField__c, this.addressMap.get('bezoekadres').country.toLowerCase().capitalize());
                    }
                } when 'city' {
                    if (this.addressMap.containskey('bezoekadres'))  {
                        obj.put(md.SalesforceField__c, this.addressMap.get('bezoekadres').city.toLowerCase().capitalize());
                    } 
                } when else {}
            }
        }
        Database.SaveResult res = Database.update(obj);
        return res;
    }
}