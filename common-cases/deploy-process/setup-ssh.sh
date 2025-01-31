#!/bin/bash

# Create SSH directory if not exists
mkdir -p ~/.ssh

# Add private key
echo "${SSH_PRIVATE_KEY}" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# Add server to known hosts
ssh-keyscan -H $SSH_HOST >> ~/.ssh/known_hosts
