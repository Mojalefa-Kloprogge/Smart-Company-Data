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

    public Account toAccount() {
        Account acc = new Account();
        return acc;
    }

    public Object getProfileInformationByFieldname(String fieldname) {
        if (fieldname.equals('identifier')) {
            return identifier;
        } else if (fieldname.equals('branchIdentifier')) {
            return branchIdentifier;
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
        } else {
            return null;
        }
        return null;
    }

    public Database.SaveResult updateRecord(SObject obj, List<MappingDetail__mdt> details){
        String street;
        String houseNumber;
        String houseNumberAddition;
        String mappedStreetField;

        for(MappingDetail__mdt md : details){
            String scdField = md.SmartCompanyDataField__c;
            switch on scdField {
                 when 'identifier' {
                    obj.put(md.SalesforceField__c, this.identifier);
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
                        mappedStreetField = md.SalesforceField__c;
                        street = this.addressMap.get('bezoekadres').street.toLowerCase().capitalize();
                    }
                } when 'houseNumber' {
                    if (this.addressMap.containskey('bezoekadres')) {
                        houseNumber = this.addressMap.get('bezoekadres').houseNumber.toLowerCase().capitalize();
                    }
                } when 'houseNumberAddition' {
                    if (this.addressMap.containskey('bezoekadres')) {
                        houseNumberAddition = this.addressMap.get('bezoekadres').houseNumberAddition.toLowerCase().capitalize();
                    }
                } when 'postalCode' {
                    if (this.addressMap.containskey('bezoekadres')) {
                        obj.put(md.SalesforceField__c, this.addressMap.get('bezoekadres').postalCode.toLowerCase().capitalize());
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
            if(String.isNotBlank(street)){ 
                String entireStreet = street;
                if(String.isNotBlank(houseNumber)){
                    entireStreet += ' ' + houseNumber;
                }
                if(String.isNotBlank(houseNumberAddition)){
                    entireStreet += ' ' + houseNumberAddition;
                }
                obj.put(mappedStreetField, entireStreet);
            }
        }
        Database.SaveResult res = Database.update(obj);
        return res;
    }

    public Date formatDate(String str) {
        return Date.newInstance(
            Integer.valueOf(str.substring(0, 4)),
            Integer.valueOf(str.substring(4, 6)),
            Integer.valueOf(str.substring(6, 8))
        );
    }
}