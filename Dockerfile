ARG USERID
FROM debian:10.5-slim
# Packages
RUN apt-get update && \
    apt-get upgrade && \
    apt-get install -y --no-recommends && \
    sudo build-essential openssh nano \
    python3 python3-dev golang-go \
    sqlite tmux git curl wget bc xxd jq \
    libx11-dev libxkbfile-dev libsecret-dev \
    && \
    curl -sL https://deb.nodesource.com/setup_current.x | sudo bash - && \
    npm -g --unsafe-perm install code-server
# User administration
RUN useradd user -m -u $USERID && \
    passwd -d user && \
    usermod -aG sudo user
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
    code-server --install-extension ms-vscode.cpptools \
    code-server --install-extension ms-vscode-remote.vscode-remote-extensionpack \
WORKDIR /home/user
ENTRYPOINT ["code-server","--bind-addr=0.0.0.0:8080","--cert=/home/user/certs/cert.pem","--cert-key=/home/user/certs/cert.key","/home/user/project"]
