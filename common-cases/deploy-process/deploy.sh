#!/bin/bash

# Connect to server and execute commands
ssh $USER@$SSH_HOST << 'EOF'
  cd $WORKDIR
  git pull origin main
  bash build.sh
  bash restart-pm2.sh
  echo "Deployment Successful! 🎉"
EOF
