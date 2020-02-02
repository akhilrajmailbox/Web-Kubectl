
```
apt-get update
apt install vim shellinabox openssh-server openssh-client libpam-google-authenticator -y

vim /etc/ssh/sshd_config
/etc/init.d/ssh restart
vim /etc/pam.d/sshd

adduser akhil
su akhil
yes | google-authenticator
```
