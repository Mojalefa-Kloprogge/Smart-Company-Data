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
        return updateAccount(acc);
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

    public Account updateAccount(Account acc) {
        if (this.name != null) {
            acc.Name = this.name;
        }
        if (this.identifier != null) {
            acc.Chamber_of_Commerce__c = this.identifier;
        }
        if (this.branchIdentifier != null) {
            acc.Branch_Number__c = this.branchIdentifier;
        }
        if (this.isBranch != null) {
            acc.Is_Branch__c = this.isBranch;
        }
        if (this.isMainBranch != null) {
            acc.Is_Main_Branch__c = this.isMainBranch;
        }
        if (this.addressMap.containskey('bezoekadres')) {
            acc.BillingCity = this.addressMap.get('bezoekadres').city.toLowerCase().capitalize();
            acc.BillingStreet = this.addressMap.get('bezoekadres').street + ' ' + this.addressMap.get('bezoekadres').houseNumber;
            if (this.addressMap.get('bezoekadres').houseNumberAddition != null) {
                acc.BillingStreet += ' ' + this.addressMap.get('bezoekadres').houseNumberAddition;
            }
            acc.BillingPostalCode = this.addressMap.get('bezoekadres').postalCode;
            acc.BillingCountry = this.addressMap.get('bezoekadres').country;
        }
        if (this.legalForm != null) {
            acc.Legal_form__c = this.legalForm;
        }
        if (this.deregistrationDate != null && this.deregistrationDate.length() == 8) {
            acc.Date_of_Termination_Chamber_of_Commerce__c = formatDate(this.deregistrationDate);
        }
        acc.Last_Chamber_of_Commerce_Update__c = System.now();
        return acc;
    }

    public Date formatDate(String str) {
        return Date.newInstance(
            Integer.valueOf(str.substring(0, 4)),
            Integer.valueOf(str.substring(4, 6)),
            Integer.valueOf(str.substring(6, 8))
        );
    }


}