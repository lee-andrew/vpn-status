#!/bin/bash
set -e

pushd vpn-status-repo/status

  state=$(cat state)
  message="VPN is $state"
  curl $discord_webhook -d "{\"content\":\"$message\"}"

  if [ $state == 'off' ]; then
    echo "$private_key" > /tmp/id_rsa
    chmod 400 /tmp/id_rsa
    $(ssh -i /tmp/id_rsa -o StrictHostKeyChecking=no $ssh_user@$ssh_host "$ssh_command")
  fi

popd
