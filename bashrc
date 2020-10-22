# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
  function smile_prompt
  {
    if [ "$?" -eq "0" ]; then
      SC="\[\033[32m\]:)"
    else
      SC="\[\033[31m\]:("
    fi
    PS1="\[\033[33m\]\u@\h \[\033[34m\]$PWD\[\033[00m\]\n$SC\[\033[00m\] "
  }
  PROMPT_COMMAND=smile_prompt
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W\$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# protect from myself!
alias rm='rm -I --one-file-system'

# Change the TERM environment variable (to get 256 colors)
if [ "x$DISPLAY" != "x" ]; then
    export HAS_256_COLORS=yes
    if [ "$TERM" = "xterm" ]; then
        export TERM=xterm-256color
    fi
else
    if [ "$TERM" = "screen" ] || [ "$TERM" = "xterm" ] || [ "$TERM" = "xterm-256color" ]; then
        export HAS_256_COLORS=yes
    fi
fi
if [ "$TERM" = "screen" ] && [ "$HAS_256_COLORS" = "yes" ]; then
    export TERM=screen-256color
fi

# set editor to vim
export EDITOR=vim

# reattach to screen, and set some variables inside the session
rescreen ()
{
  # check there's only 1 session available if no session was specified
  opensessions=$(screen -ls | grep -c Detached)
  if [ -z "$1" -a $opensessions -gt 1 ]; then
    screen -ls
    return 1
  fi

  # set the variable inside of the screen session
  if [ $1 ]; then
    SESSION="-S $1"
  fi
  screen $SESSION -X setenv DISPLAY $DISPLAY;

  # reconnect to the screen session (if $1 is not specified, connects to the only one)
  if [ $? -eq 0 ]; then
    screen $SESSION -X bindkey -k k1 stuff "export DISPLAY=$DISPLAY\015"
    screen $SESSION -X bindkey '^[[1;2P' stuff 'Sys.setenv(DISPLAY="$DISPLAY")\015'
    screen -D -r $1
  fi
}
