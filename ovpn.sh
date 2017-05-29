#!/bin/bash

openvpnDir=/etc/openvpn
scriptsDir=$openvpnDir/easy-rsa
keysDir=$scriptsDir/keys

profileName=''

while [ -z $profileName ]; do
    read -p "Enter profile name: " profileName
done

caCertName=ca.crt
clientKeyName="${profileName}.key"
clientCertName="${profileName}.crt"
clientProfile="${profileName}.ovpn"

if [ ! -f $keysDir/$clientKeyName ]; then
    source $scriptsDir/vars

    $scriptsDir/build-key $keysDir/$profileName

    # Add the Certificate Authority
    echo '<ca>' >> $keysDir/$clientProfile
    cat $openvpnDir/ca.crt >> $keysDir/$clientProfile
    echo '</ca>' >> $keysDir/$clientProfile

    # Add the certificate
    echo '<cert>' >> $keysDir/$clientProfile
    cat $keysDir/$clientCertName >> $keysDir/$clientProfile
    echo '</cert>' >> $clientProfile

    # Add the key
    echo '<key>' >> $keysDir/$clientProfile
    cat $keysDir/$clientKeyName >> $keysDir/$clientProfile
    echo '</key>' >> $keysDir/$clientProfile
fi
