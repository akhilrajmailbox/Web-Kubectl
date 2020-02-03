#!/bin/bash

function kubeauth() {
    if [[ ${AUTO_KUBERNETES_CONFIG} == "true" ]] ; then
        if [[ ! -z ${KUBERNETES_SERVICE_PORT} ]] && [[ ! -z ${KUBERNETES_SERVICE_HOST} ]] ; then
            echo -e "\nconfiguring KUBERNETES CONFIG with KUBERNETES_SERVICE_PORT=${KUBERNETES_SERVICE_PORT} and KUBERNETES_SERVICE_HOST=${KUBERNETES_SERVICE_HOST}"
            sed -i "s|^KUBERNETES_SERVICE_PORT=.*|KUBERNETES_SERVICE_PORT=${KUBERNETES_SERVICE_PORT}|g" /etc/environment
            sed -i "s|^KUBERNETES_SERVICE_HOST=.*|KUBERNETES_SERVICE_HOST=${KUBERNETES_SERVICE_HOST}|g" /etc/environment
        else
            echo -e "\n KUBERNETES_SERVICE_PORT or KUBERNETES_SERVICE_HOST missing...!"
            exit 1
        fi
    else
        echo "AUTO_KUBERNETES_CONFIG disbaled...!, you have to manually configure the Kube auth with KUBERNETES_SERVICE_PORT and KUBERNETES_SERVICE_HOST"
    fi
}

function config() {
    kubeauth
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
            su ${USERNAME} bash -c 'mkdir /home/${USERNAME}/.cache && touch /home/${USERNAME}/.cache/motd.legal-displayed'
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
