#!/bin/bash

function config() {
    if [[ ! -z ${USERNAME} ]] && [[ ! -z ${PASSWORD} ]] ; then
        useradd -m -d /home/${USERNAME} -s /bin/zsh ${USERNAME}
        echo "${USERNAME}:${PASSWORD}" | chpasswd
    else
        echo -e "\n USERNAME or PASSWORD missing...!"
        exit 1
    fi
    if [[ ! -f /home/${USERNAME}/.google_authenticator ]] ; then
        echo "Configuring first time...!"
        if [[ ! -z ${USERNAME} ]] && [[ ! -z ${PASSWORD} ]] ; then
            # useradd -m -d /home/${USERNAME} -s /bin/zsh ${USERNAME}
            # echo "${USERNAME}:${PASSWORD}" | chpasswd
            su ${USERNAME} bash -c 'yes | google-authenticator'
            su ${USERNAME} bash -c 'wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh'
            su ${USERNAME} bash -c 'echo "RPS1='"'%w %@'"'"' >> /home/${USERNAME}/.zshrc
            su ${USERNAME} bash -c 'echo "source /opt/cowsay.sh"' >> /home/${USERNAME}/.zshrc
        else
            echo -e "\n USERNAME or PASSWORD missing...!"
            exit 1
        fi
    else
        echo "Already configured the credentials for user ${USERNAME}"
    fi
}


function start() {
    /etc/init.d/ssh restart & wait
    /etc/init.d/shellinabox restart & wait
    tailf /entrypoint.sh
}


config && start
