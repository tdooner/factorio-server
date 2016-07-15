#!/bin/bash
set -euo pipefail

ip=${1:-$(terraform output ip_address)}

rsync -a chef root@$ip:/etc/
echo "Running Chef-Solo..."
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
  root@$ip chef-solo -c /etc/chef/solo.rb -o 'recipe[factorio-cookbook]'
