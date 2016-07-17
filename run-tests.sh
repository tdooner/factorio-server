#!/bin/bash
set -euo pipefail

tmpdir=$(mktemp -d -t test-kitchen.XXXX)
trap "rm -rf $tmpdir" EXIT

# remove the key headers and replace them so OpenSSL parses it correctly
export AWS_SSH_KEY_PATH="$tmpdir/id_rsa"
echo '-----BEGIN RSA PRIVATE KEY-----' > $AWS_SSH_KEY_PATH
echo $AWS_SSH_PRIVATE_KEY |
  sed -e 's/"//g' | \
  sed -e 's/-----BEGIN RSA PRIVATE KEY----- //g' | \
  sed -e 's/ -----END RSA PRIVATE KEY-----//g' | \
  tr " " "\n" >> $tmpdir/id_rsa
echo '-----END RSA PRIVATE KEY-----' >> $AWS_SSH_KEY_PATH

chmod 0600 $AWS_SSH_KEY_PATH
openssl sha -sha256 $AWS_SSH_KEY_PATH

bundle exec kitchen test
