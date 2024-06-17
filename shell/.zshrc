ZSH=/HOMEPATH/.oh-my-zsh
ZSH_CUSTOM=$ZSH/custom
ZSH_THEME="avit"
ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"
plugins=(vscode git colorize docker docker-compose git-extras)
source $ZSH/oh-my-zsh.sh

# SSH key check
test -f ~/.ssh/id_ed25519
[ "$?" = 0 ] && SSHRSA_OK=yes
[ -z $SSHRSA_OK ] && >&2 echo "[WARNING] No id_ed25519 SSH private key found, SSH functionalities might not work"

# Timezone check
[ -z $TZ ] && >&2 echo "[WARNING] TZ environment variable not set, time might be wrong!"

# Docker check
test -S /var/run/docker.sock
[ "$?" = 0 ] && DOCKERSOCK_OK=yes
[ -z $DOCKERSOCK_OK ] && >&2 echo "[WARNING] Docker socket not found, docker will not be available"

# Fixing permission on Docker socket
if [ ! -z $DOCKERSOCK_OK ]; then
  DOCKERSOCK_USER=`stat -c "%u" /var/run/docker.sock`
  DOCKERSOCK_GROUP=`stat -c "%g" /var/run/docker.sock`
  if [ "$DOCKERSOCK_GROUP" != "1000" ] && [ "$DOCKERSOCK_GROUP" != "102" ] && [ "$DOCKERSOCK_GROUP" != "976" ]; then
    echo "Docker socket not owned by group IDs 1000, 102 or 976, changing its group to `id -g`"
    sudo chown $DOCKERSOCK_USER:`id -g` /var/run/docker.sock
    sudo chmod 770 /var/run/docker.sock
  fi
fi

echo
echo "Base version: $BASE_VERSION"
echo "Running as user `whoami`"
where code &> /dev/null && echo "VS code server `code -v | head -n 1`"
if [ ! -z $DOCKERSOCK_OK ]; then
  echo "Docker server `docker version --format {{.Server.Version}}` | client `docker version --format {{.Client.Version}}`"
  echo "Docker-Compose `docker-compose version --short`"
  alias alpine='docker run -it --rm alpine:3.19'
  alias dive='docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive'
fi
echo
[ -f ~/.zshrc-specific.sh ] && source ~/.zshrc-specific
[ -f ~/.welcome.sh ] && source ~/.welcome.sh
