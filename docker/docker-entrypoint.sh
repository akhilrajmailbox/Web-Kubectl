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

function ssh_config() {
    kubeauth
    if [[ ! -z ${SSH_USERNAME} ]] && [[ ! -z ${SSH_PASSWORD} ]] ; then
        if ! getent group "${SSH_USERNAME}" >/dev/null; then
            groupadd --gid ${APP_ID} ${SSH_USERNAME}
        fi
        if ! id -u "${SSH_USERNAME}" >/dev/null 2>&1; then
            useradd ${SSH_USERNAME} -m -d /home/${SSH_USERNAME} --uid ${APP_ID} --gid ${APP_ID} --shell /bin/zsh
            chown -R :${SSH_USERNAME} /usr/local/bin/kub.sh /usr/local/bin/cowsay.sh /usr/local/bin/gauth /opt/cowsay
            su - "${SSH_USERNAME}" -c "wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh"
            su - "${SSH_USERNAME}" -c "echo 'RPS1=\"%w %\"' >> /home/${SSH_USERNAME}/.zshrc"
            su - "${SSH_USERNAME}" -c "echo 'source /usr/local/bin/cowsay.sh' >> /home/${SSH_USERNAME}/.zshrc"
            su - "${SSH_USERNAME}" -c "echo 'source /usr/local/bin/kub.sh' >> /home/${SSH_USERNAME}/.zshrc"
            su - "${SSH_USERNAME}" -c "mkdir /home/${SSH_USERNAME}/.cache && touch /home/${SSH_USERNAME}/.cache/motd.legal-displayed"
        fi
        echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd
    else
        echo -e "\n SSH_USERNAME or SSH_PASSWORD missing...!"
        exit 1
    fi
}

function gauth_config() {
    ssh_config
    if [[ ! -z ${SSH_USERNAME} ]] ; then
        if [[ ! -f /home/${SSH_USERNAME}/.google_authenticator ]] ; then
            echo "Configuring first time...!"
            su ${SSH_USERNAME} bash -c 'google-authenticator --time-based --force --disallow-reuse --no-rate-limit --window-size 17 --quiet'
        else
            echo "Already configured the credentials for user ${SSH_USERNAME}"
        fi
        gauth
    else
        echo -e "\n SSH_USERNAME is missing...!"
        exit 1
    fi
}

function run() {
    gauth_config
    /etc/init.d/ssh restart & wait
    /etc/init.d/shellinabox restart & wait
    tail -f /dev/null
}


run