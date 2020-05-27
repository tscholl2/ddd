FROM alpine:3.11
# Packages
RUN apk update && \
    apk upgrade && \
    apk add bash sudo build-base openssl openssh nano \
    python python3 nodejs npm go \
    sqlite tmux git curl wget bc xxd jq \
    python3-dev postgresql postgresql-dev \
    mariadb mariadb-dev \
    libx11-dev libxkbfile-dev libsecret-dev \
    && \
    npm -g --unsafe-perm install code-server
# User administration
RUN adduser -D user -s /bin/bash && \
    passwd -d user && \
    echo "user ALL=(ALL) ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user && \
    visudo -c
USER user
# Setup stuff
RUN mkdir -p /home/user/certs && \
    openssl req -newkey rsa:2048 -nodes -x509 -days 10000 \
        -subj "/C=/ST=/L=/O=/OU=/CN=" \
        -keyout /home/user/certs/cert.key \
        -out /home/user/certs/cert.pem && \
    mkdir -p /home/user/project && \
    code-server --install-extension hoovercj.vscode-power-mode \
    code-server --install-extension ms-python.python \
    code-server --install-extension ms-vscode.Go \
    code-server --install-extension ms-azuretools.vscode-docker \
    code-server --install-extension ms-vscode.cpptools
WORKDIR /home/user
ENTRYPOINT ["code-server","--bind-addr=0.0.0.0:8080","--cert=/home/user/certs/cert.pem","--cert-key=/home/user/certs/cert.key","/home/user/project"]
