#!/bin/bash

sfdx force:package:version:create --package SmartCompanyDatav2 --path force-app --installationkey 2ManyDigits --wait 10

latestVersion=$(sfdx force:package:version:list -p 0Ho7T000000CaRHSA0 -o CreatedDate --concise | tail -1 | awk '{print $3}')

sfdx force:package:install --wait 10 --publishwait 10 --package $latestVersion --installationkey 2ManyDigits --noprompt

echo $ACC_LOGIN_URL > /tmp/acc-login.url
sfdx force:auth:sfdxurl:store -f /tmp/acc-login.url -a Acc
rm /tmp/acc-login.url

sfdx force:package:install --wait 10 --publishwait 10 --package $latestVersion --installationkey 2ManyDigits --noprompt -u Acc