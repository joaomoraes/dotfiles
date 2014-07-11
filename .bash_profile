
export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function

# If running interactively, then:
if [ "$PS1" ]; then
	#Cores
	COLOR1="\[\033[0;37m\]"
	COLOR2="\[\033[0;37m\]"
	COLOR3="\[\033[0;34m\]"
	COLOR4="\[\033[0;33m\]"

	if [ "$UID" = "0" ]; then
	# I am root
		COLOR2="\[\033[1;31m\]"
	fi

	# EOP="\[\033\033\134\]"
	parse_git_branch() {
		git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
	}

	PS1="$COLOR3\u@\h $COLOR1/$COLOR2\W$COLOR1/ $COLOR4\$(parse_git_branch)$COLOR1\\$ $COLOR1$EOP"

	pathed_cd () {
		if [ "$1" == "" ]; then
			cd
		else
			cd "$1"
		fi
		pwd > ~/.cdpath
	}
	alias cd="pathed_cd"

	if [ -f ~/.cdpath ]; then
	  cd $(cat ~/.cdpath)
	fi
fi

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
