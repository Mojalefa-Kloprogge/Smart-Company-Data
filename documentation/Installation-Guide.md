# SCD App installation guide

### Scratch org information

A scratch org can be created by running the create-scratch-org.sh script in the scripts/bash/ folder.
Run this command in your terminal: `sh scripts/bash/create-scratch-org.sh`

The scratch org contains:

**Scratch org metadata**
```
    Chamber of Commerce Setting
    Mapping Configuration
    Mapping Detail 
```
**Salesforce fields mapped to Custom Metadata Types**
```
    Identifier (chamber of commerce number)
    IsBranch (checkbox)
    IsMainBranch (checkbox)
    Tradenames (text area)
```
## Installing the app
To install the app in your org go to the following URL:

> https://MyDomainName.lightning.force.com/packagingSetupUI/ipLanding.app?apvId=04tB0000xx

Append the package version id ("04tB00...") right after the "apvId=" in the URL.

Fill in the required installation key:

***2ManyDigits***


**API Key**
Before any callout can be made you have to insert the API key in the Custom Metadata Type.

Setup > Click on 'Manage Records' at Chamber of Commerce Setting > SmartCompanyData > Edit > Insert api key in the corresponding field.