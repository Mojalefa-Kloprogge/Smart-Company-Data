echo 'Creating Scratch Org'
sfdx force:org:create -f ./config/project-scratch-def.json -a SCD -s -d 30 -w 10
echo 'Push Sources'
sfdx force:source:push -f -w 10 -u SCD
echo 'Deploy test metadata'
sfdx force:source:deploy -p config/scratch-metadata -u SCD
#echo 'Assign Permission Set'
sfdx force:user:permset:assign -n SCD_Permissionset -u SCD
