ARG ALPINE_VERSION=3.19
ARG ARCH=

FROM ${ARCH}alpine:${ALPINE_VERSION}
ARG VERSION=
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
LABEL \
    org.opencontainers.image.authors="paulo.alves.pereira@hey.com" \
    org.opencontainers.image.version=$VERSION \
    org.opencontainers.image.url="https://github.com/pap/devcontainer-base" \
    org.opencontainers.image.documentation="https://github.com/pap/devcontainer-base" \
    org.opencontainers.image.source="https://github.com/pap/devcontainer-base" \
    org.opencontainers.image.title="Base Dev container" \
    org.opencontainers.image.description="Base Alpine container for Visual Studio Code Remote Containers development"
ENV BASE_VERSION="${VERSION}"

# CA certificates
RUN apk add -q --update --progress --no-cache ca-certificates

# Timezone
RUN apk add -q --update --progress --no-cache tzdata
ENV TZ=

# Setup Git and SSH
RUN apk add -q --update --progress --no-cache git openssh-client

# Setup non root user with sudo access
RUN apk add -q --update --progress --no-cache sudo
WORKDIR /home/${USERNAME}
RUN adduser $USERNAME -s /bin/sh -D -u $USER_UID $USER_GID && \
    mkdir -p /etc/sudoers.d && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Setup shell for root and ${USERNAME}
RUN apk add -q --update --progress --no-cache zsh vim curl htop github-cli docker docker-cli-compose
ENTRYPOINT [ "/bin/zsh" ]
ENV EDITOR=vim \
    LANG=en_US.UTF-8 \
    TERM=xterm
RUN apk add -q --update --progress --no-cache shadow && \
    usermod --shell /bin/zsh root && \
    usermod --shell /bin/zsh ${USERNAME} && \
    apk del shadow
COPY --chown=${USER_UID}:${USER_GID} shell/.zshrc shell/.welcome.sh /home/${USERNAME}/
RUN cp /home/${USERNAME}/.zshrc /root/.zshrc && \
    cp /home/${USERNAME}/.welcome.sh /root/.welcome.sh && \
    sed -i "s/HOMEPATH/home\/${USERNAME}/" /home/${USERNAME}/.zshrc && \
    sed -i "s/HOMEPATH/root/" /root/.zshrc
RUN git clone --single-branch --depth 1 https://github.com/robbyrussell/oh-my-zsh.git /home/${USERNAME}/.oh-my-zsh && \
    chown -R ${USERNAME}:${USER_GID} /home/${USERNAME}/.oh-my-zsh && \
    chmod -R 700 /home/${USERNAME}/.oh-my-zsh && \
    cp -r /home/${USERNAME}/.oh-my-zsh /root/.oh-my-zsh && \
    chown -R root:root /root/.oh-my-zsh

ENV DOCKER_BUILDKIT=1
# All possible docker host groups
RUN G102=`getent group 102 | cut -d":" -f 1` && \
    G976=`getent group 976 | cut -d":" -f 1` && \
    G1000=`getent group 1000 | cut -d":" -f 1` && \
    if [ -z $G102 ]; then G102=docker102; addgroup --gid 102 $G102; fi && \
    if [ -z $G976 ]; then G976=docker976; addgroup --gid 976 $G976; fi && \
    if [ -z $G1000 ]; then G1000=docker1000; addgroup --gid 1000 $G1000; fi && \
    addgroup ${USERNAME} $G102 && \
    addgroup ${USERNAME} $G976 && \
    addgroup ${USERNAME} $G1000

# VSCode specific (speed up setup)
RUN apk add -q --update --progress --no-cache libstdc++

USER ${USERNAME}
