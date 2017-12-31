#!/bin/bash
set -e

echo "$private_key" > /tmp/id_rsa
chmod 400 /tmp/id_rsa

result=$(ssh -i /tmp/id_rsa -o StrictHostKeyChecking=no $ssh_user@$ssh_host "curl ifconfig.co/country" | grep "United States")

pushd vpn-status-repo/status

  if [ $result == "United States" ]; then
    if [ $(cat state) == 'off' ]; then
      echo 'on' > state
    fi
  else
    if [ $(cat state) == 'on' ]; then
      echo 'off' > state
    fi
  fi

  if [[ -n $(git status --porcelain) ]]; then
    git config --global user.name $git_user
    git config --global user.email $git_email
    git add .
    git commit -m "state change"
  fi

popd

shopt -s dotglob
cp -r vpn-status-repo/* output

