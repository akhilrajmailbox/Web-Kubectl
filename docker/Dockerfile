FROM ubuntu:16.04
LABEL maintainer="Akhil Raj <akhilrajmailbox@gmail.com>"

ARG CONFIG_PATH=/etc/default/shellinabox
ARG SECURE_PORT=5688

ENV APP_ID="10000"
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV AUTO_KUBERNETES_CONFIG="true"

COPY cowsay /opt/cowsay
COPY kub.sh /usr/local/bin/kub.sh
COPY cowsay.sh /usr/local/bin/cowsay.sh
COPY gauth /usr/local/bin/gauth
COPY docker-entrypoint.sh /bin/docker-entrypoint.sh

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository universe \
    && apt-get update \
    && apt-get install \
        zsh \
        git \
        curl \
        locales \
        ruby \
        cowsay \
        qrencode \
        shellinabox \
        openssh-server \
        openssh-client \
        libpam-google-authenticator -y \
    && gem install lolcat \
    && echo "auth required pam_google_authenticator.so" >> /etc/pam.d/sshd \
    # && sed -i "s|KbdInteractiveAuthentication.*|KbdInteractiveAuthentication yes|g" /etc/ssh/sshd_config \
    && sed -i "s|^ChallengeResponseAuthentication.*|ChallengeResponseAuthentication yes|g" /etc/ssh/sshd_config \
    && sed -i "s|^UsePAM.*|UsePAM yes|g" /etc/ssh/sshd_config \
    && sed -i "s|^SHELLINABOX_PORT=.*|SHELLINABOX_PORT=$SECURE_PORT|g" $CONFIG_PATH \
    && sed -i "s|^SHELLINABOX_ARGS=.*|SHELLINABOX_ARGS='--no-beep -t -s /:SSH:localhost'|g" $CONFIG_PATH \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 \
    && echo "KUBERNETES_SERVICE_PORT=someport" >> /etc/environment \
    && echo "KUBERNETES_SERVICE_HOST=somehost" >> /etc/environment \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x kubectl \
    && mv /etc/shellinabox/options-enabled/00+Black\ on\ White.css /etc/shellinabox/options-enabled/00_Black\ on\ White.css \
    && mv /etc/shellinabox/options-enabled/00_White\ On\ Black.css /etc/shellinabox/options-enabled/00+White\ On\ Black.css \
    && rm -rf /etc/update-motd.d/* \
    && mv kubectl /usr/local/bin/ \
    && rm -rf /var/lib/apt/lists/* \
    && chmod -R 750 /opt/cowsay \
    && chmod 750 /usr/local/bin/kub.sh /usr/local/bin/cowsay.sh /usr/local/bin/gauth \
    && chmod 700 /bin/docker-entrypoint.sh

EXPOSE 5688

ENTRYPOINT [ "/bin/docker-entrypoint.sh" ]