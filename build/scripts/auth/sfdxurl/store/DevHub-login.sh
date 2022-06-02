#!/bin/bash

echo $SFDX_LOGIN_URL > /tmp/sfdx.url

sfdx force:auth:sfdxurl:store -f /tmp/sfdx.url -a DevHub --setdefaultdevhubusername

rm /tmp/sfdx.url