##!/bin/bash
# Check if sudo
if [ "$EUID" -ne 0 ]
        then echo "Please run with sudo"
        exit
fi
sshd_config="/etc/ssh/sshd_config"
install_dir="/home/ec2-user" # You may need to change this dir to another user home/user-writeable dir.
yubico_api_id="1234" # Change to your yubico API ID
declare -a yubikey_users=("ec2-user:yubikeyid1:yubikeyid2" "user2:yubikeyid" "use3:yubikeyid" "user4:yubikeyid")

echo "[+] Installing pam_yubico..."
yum -y install pam_yubico
echo "[+] Installing Dependencies..."
yum -y install git autoconf automake asciidoc libtool pam-devel libcurl-devel help2man
# echo "[+] Enabling Yubikey auth login"
# setsebool -P authlogin_yubikey 1      # Only required if you're using SELinux  
echo "[+] Adding mfa group"
groupadd mfa
for yubiuser in ${yubikey_users[@]}; do
        echo "*  Adding $yubiuser to mfa group"
        usermod -aG mfa ${yubiuser%%:*}
        echo "*  adding $yubiuser to yubikey map..."
        echo $yubiuser >> /etc/yubikey_mappings
done

echo "[+] Enabling ChallengeResponse..."
sed -ri -e 's!ChallengeResponseAuthentication no!ChallengeResponseAuthentication yes!g' $sshd_config
echo "[+] Adding mfa auth methods..."
echo "Match group mfa" >> /etc/ssh/sshd_config
echo "  AuthenticationMethods publickey,keyboard-interactive" >> $sshd_config
echo "[+] Cloning yubico-c-client..."
git clone https://github.com/Yubico/yubico-c-client.git $install_dir/yubico-c-client
echo "*  Unpacking..."
cd $install_dir/yubico-c-client
autoreconf --install
./configure
make check
make install
cd $install_dir
echo "[+] Cloning yubico-pam..."
git clone https://github.com/Yubico/yubico-pam.git $install_dir/yubico-pam
echo "*  Unpacking..."
cd $install_dir/yubico-pam
autoreconf --install
./configure --without-cr
make check
make install
cd $install_dir
mv /usr/local/lib/security/pam_yubico.so /lib64/security/

sed -i '1s/^/# yubikey\n /' /etc/pam.d/sshd
sed -i '2s/^/auth       sufficient   pam_yubico.so id=$yubico_api_id authfile=/etc/yubikey_mappings\n /' /etc/pam.d/sshd

service sshd restart
echo "[] Done"
