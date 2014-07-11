
export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function


# Export variables
export EDITOR="sublime.sh"

# -----  ALiases  -----

# Git
alias gx='open -a GitX'
alias ck='git checkout'
alias br='git branch'
alias gs='git status'
alias gb='git branch -a'
alias gc='git commit -a'
alias dif='git diff --color'
alias gl='git pull'
alias gp='git push'
alias gst='git stash'
alias gstp='git stash pop'
alias dif='git diff --color'
alias committers='git log --raw | grep "^Author: " | sort | uniq -c'

#Ruby
alias rdc='rake db:create'
alias rdm='rake db:migrate'
alias rdd='rake db:drop'
alias rdcT='rake db:create RAILS_ENV=test'
alias rdmT='rake db:migrate RAILS_ENV=test'
alias rddT='rake db:drop RAILS_ENV=test'

function mrc(){
    echo 'rvm use '$1'@'$2' --create' > .rvmrc;
}

# Rails servers
alias rs0='rails s -p 3000'
alias rs1='rails s -p 3001'
alias rs2='rails s -p 3002'
alias rs31='rails s -p 3031'
alias rs99='rails s -p 3099'

alias be='bundle exec'

# Note: ~/.ssh/environment should not be used, as it
#       already has a different purpose in SSH.

env=~/.ssh/agent.env

# Note: Don't bother checking SSH_AGENT_PID. It's not used
#       by SSH itself, and it might even be incorrect
#       (for example, when using agent-forwarding over SSH).

agent_is_running() {
    if [ "$SSH_AUTH_SOCK" ]; then
        # ssh-add returns:
        #   0 = agent running, has keys
        #   1 = agent running, no keys
        #   2 = agent not running
        ssh-add -l >/dev/null 2>&1 || [ $? -eq 1 ]
    else
        false
    fi
}

agent_has_keys() {
    ssh-add -l >/dev/null 2>&1
}

agent_load_env() {
    . "$env" >/dev/null
}

agent_start() {
    (umask 077; ssh-agent >"$env")
    . "$env" >/dev/null
}

if ! agent_is_running; then
    agent_load_env
fi

if ! agent_is_running; then
    agent_start
    ssh-add
elif ! agent_has_keys; then
    ssh-add
fi

unset env
