if [[ -n ${SSH_CLIENT} && -z ${TMUX} ]]; then
    tmux
fi
