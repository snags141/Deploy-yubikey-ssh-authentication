# Deploy-yubikey-ssh-authentication
A script to deploy Yubikey SSH authentication for CENTOS 7 / EPEL7 based systems. Works great for Amazon based EC2 images, however can be adapted for other operating systems

# Motivation
You can google how to set up yubikey ssh authentication all day long, just like I did for two days. But the information you find is always conflicting, and some guides miss steps that others may include, and vice-versa. This script was made with Amazon images in mind but should contain all the crucial steps required to get yubikey auth working for SSH.

# Contribution
Everyone is welcome to commit new versions for different OS'es. Manage to convert it to work with Ubuntu? Sweet, commit another script for others to use and further modify.

# How to use
Before executing with `sudo deployyubikeyssh.sh`, you will need to modify some crucial variables 

| Variable | Description | Example |
| --- | --- | --- |
| yubikey_users | Array containing the definition of local users and their associated yubikey ID's* (one or more yubikey can be assigned per user) | ("ec2-user:yubikeyid1:yubikeyid2" "user2:yubikeyid" "use3:yubikeyid" "user4:yubikeyid") |
| install_dir | By default, set to the home dir for the standard user account, as set by the Amazon Linux image (ec2-user). Change this to your main user or some other directory. May cause issues if not set to a user home folder or strange dir's, not tried with others. | "/home/ec2-user" |
| yubico_api_id | Enter your yubico API ID here** | 1234 |

# Gotchas; *as-in, I gotchu fam*
\**What is a yubikey id?*
1. Plug in your yubikey.
2. Open a text editor
3. tap your yubikey once
4. The first 12 characters are your yubikey ID

\*\**Where can I get an API ID?*
https://upgrade.yubico.com/getapikey

# Credits
@snags141

# License
GNU General Public License v3
