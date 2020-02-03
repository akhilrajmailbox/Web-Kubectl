FROM ubuntu:16.04
MAINTAINER Akhil Raj <akhilrajmailbox@gmail.com>
RUN apt-get update && apt-get install zsh git curl locales ruby cowsay vim shellinabox openssh-server openssh-client libpam-google-authenticator -y \
    && gem install lolcat

ARG CONFIG_PATH=/etc/default/shellinabox
ARG SECURE_PORT=5688

RUN echo "auth required pam_google_authenticator.so" >> /etc/pam.d/sshd \
    && sed -i "s|^ChallengeResponseAuthentication.*|ChallengeResponseAuthentication yes|g" /etc/ssh/sshd_config \
    && sed -i "s|^UsePAM.*|UsePAM yes|g" /etc/ssh/sshd_config \
    && sed -i "s|^SHELLINABOX_PORT=.*|SHELLINABOX_PORT=$SECURE_PORT|g" $CONFIG_PATH \
    && sed -i "s|^SHELLINABOX_ARGS=.*|SHELLINABOX_ARGS='--no-beep -t -s /:SSH:localhost'|g" $CONFIG_PATH \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8

WORKDIR /tmp/
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x kubectl
RUN mv kubectl /usr/local/bin/

WORKDIR /etc/shellinabox/options-enabled/
RUN mv 00+Black\ on\ White.css 00_Black\ on\ White.css \
    && mv 00_White\ On\ Black.css 00+White\ On\ Black.css \
    && rm -rf /etc/update-motd.d/*

COPY Cowsay_Script /opt/Cowsay_Script
RUN chmod -R 777 /opt/Cowsay_Script
ADD cowsay.sh /opt/
RUN chmod 777 /opt/cowsay.sh

ADD entrypoint.sh /
RUN chmod 700 /entrypoint.sh

ENV LANG en_US.UTF-8
ENV USERNAME=""
ENV PASSWORD=""
WORKDIR /home/

ENTRYPOINT "/entrypoint.sh"