#!/bin/bash
# Information steps:
# 1) chmod u+x restage-and-log.sh
# 2) ./restage-and-log.sh
# cf api https://api.eu-gb.bluemix.net UK
# cf api https://api.ng.bluemix.net US

user="thomas.suedbroecker.2@de.ibm.com"
# bluemix_api="https://api.eu-gb.bluemix.net"
bluemix_api="https://api.ng.bluemix.net"
organization_name="thomas.suedbroecker.2@de.ibm.com"
space_name="01_development"
application_name="OwnIoTCloud"

echo "--> Ensure to deploy into the right bluemix region"
echo "Insert your password:"
# How to input a password in bash shell
# http://stackoverflow.com/questions/3980668/how-to-get-a-password-from-a-shell-script-without-echoing
read -s password
# cd ..
cf login -a $bluemix_api -u $user -p $password -o $organization_name -s $space_name

echo "--> Starting restage and log CF $application_name"

echo "****** show existing apps *********"
cf apps
echo "******* restage to of CF app $application_name ********"
cf restage  $application_name
echo "******* start CF logging for $application_name********"
cf logs  $application_name
