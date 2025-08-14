#!/bin/bash

# The subshell spawned via $() inherits the shell environment attirubte that will return non-zero exit status in pipeline if occured
set -o pipefail

cert_gophish="/home/abhatta/SSL/DetectSSLExpiry/cert.pem"
certExpDate=$(openssl x509 -in "$cert_gophish" -text -noout | grep "Not After : " | awk -F ' : ' '{print $2}')

if  [[ $? == 1 ]] ; then
	exit
fi


systemDate=$( date -u +"%b %d %H:%M:%S %Y GMT" )
echo "This is cert expiry: $certExpDate" 
echo "This is current systemDate: $systemDate"

# Covert to standardized form
ts1=$( date -d "$certExpDate" +%s)
ts2=$( date -d "$systemDate" +%s)

if [ "$ts1" -gt "$ts2" ]; then
	echo "Certificate is fine"
else
	#Handle the expired certificate by calling command
	echo "Certificate is expired"
fi



