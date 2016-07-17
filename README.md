# factorio-server

```bash
# get a CLOUDFLARE_EMAIL/CLOUDFLARE_TOKEN and DIGITALOCEAN_TOKEN

brew install terraform
ssh-keygen -f factorio_rsa
mv factorio_rsa ~/.ssh
mv factorio_rsa.pub ~/.ssh

terraform apply
```


## running tests
```
# create AWS IAM user with Ec2FullPermissions and maybe VPC readonly as well (?)
# create a keypair, save the private key for putting into travis
# put into travis environment variables:
#  1. AWS_ACCESS_KEY_ID
#  2. AWS_SECRET_ACCESS_KEY
#  3. AWS_SSH_KEY_ID
#  4. AWS_EC2_SUBNET_ID
#  5. AWS_SSH_PRIVATE_KEY
#     (this should be a quote-surrounded version of the private key downloded
#      before)
# install vagrant
bundle install
```
