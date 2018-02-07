#!/bin/bash

# Install yum-utils and alien:
echo "Install yum-utils and alien:"
sudo apt-get update -y
sudo apt-get install yum-utils alien -y

# Install the Ripple RPM repository:
echo "nstall the Ripple RPM repository:"
sudo rpm -Uvh https://mirrors.ripple.com/ripple-repo-el7.rpm

# Download the rippled software package:
echo "Download the rippled software package:"
sudo yumdownloader --enablerepo=ripple-stable --releasever=el7 rippled

# Verify the signature on the rippled software package:
echo "Verify the signature on the rippled software package:"
sudo rpm --import https://mirrors.ripple.com/rpm/RPM-GPG-KEY-ripple-release && rpm -K rippled*.rpm

# Install the rippled software package:
echo "Install the rippled software package:"
sudo alien -i --scripts rippled*.rpm && rm rippled*.rpm

# Configure the rippled service to start on system boot:
echo "Configure the rippled service to start on system boot:"
sudo systemctl enable rippled.service

# Generate a validator key pair:
echo "Generate a validator key pair:"
sudo /opt/ripple/bin/validator-keys create_keys

# Generate a validator token and edit your rippled.cfg file to add the [validator_token] value.
# sudo /opt/ripple/bin/validator-keys create_token --keyfile ~/.ripple/validator-keys.json
echo "Generate a validator token and edit your rippled.cfg file to add the [validator_token] value."
token=$(sudo /opt/ripple/bin/validator-keys create_token --keyfile ~/.ripple/validator-keys.json)
token=${token#*]}
sudo cp /etc/opt/ripple/rippled.cfg ~/rippled.cfg
sudo echo "[validator_token]" >> ~/rippled.cfg
sudo echo $token | tr " " "\n" >> ~/rippled.cfg
sudo cp ~/rippled.cfg /etc/opt/ripple/rippled.cfg 
sudo rm ~/rippled.cfg

