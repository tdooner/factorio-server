#!/bin/bash
set -euo pipefail

tmpdir=$(mktemp -d -t test-kitchen.XXXX)
trap "rm -rf $tmpdir" EXIT

# remove the key headers and replace them so OpenSSL parses it correctly
echo $AWS_SSH_PRIVATE_KEY |
  sed -e 's/-----BEGIN RSA PRIVATE KEY----- //g' | \
  sed -e 's/ -----END RSA PRIVATE KEY-----//g' | \
  sed -n 'i\
-----BEGIN RSA PRIVATE KEY-----
;
p;
i\
-----END RSA PRIVATE KEY-----
' > $tmpdir/id_rsa

export AWS_SSH_KEY_PATH="$tmpdir/id_rsa"

chmod 0600 $AWS_SSH_KEY_PATH

bundle exec kitchen verify
