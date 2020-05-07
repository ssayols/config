# Servers
alias imbc='ssh -Y say@slurmlogin.imb-mainz.de'
alias mogon='ssh -Y say@mogon.uni-mainz.de'

# Dirs
alias projects='cd /data/imb-bioinfocf/projects'

# Tools
alias htop='htop -u say'
alias squeue='squeue -u say'
alias vim='/data/imb-bioinfocf/common-tools/dependencies/vim/nvim-0.4.0-1012/squashfs-root/usr/bin/nvim'

# fix screen's DISPLAY var
function RESCREEN {
# screen -S $1 -X setenv DISPLAY $DISPLAY
# screen -S $1 -X bindkey -k k1 stuff "export DISPLAY=$DISPLAY\015"
# screen -S $1 -X bindkey '^[[1;2P' stuff 'Sys.setenv(DISPLAY="$DISPLAY")\015'
# screen -D -RR $1
  # check there's only 1 session available if no session was specified                                                                                                      opensessions=$(screen -ls | grep -c Detached)
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
    # could also bind keys inside of screen, in order to quickly update $DISPLAY with the right value
    screen $SESSION -X bindkey -k k1 stuff "export DISPLAY=$DISPLAY\015";
    screen $SESSION -X bindkey '^[[1;2P' stuff 'Sys.setenv(DISPLAY="$DISPLAY")\015';

    # re-attach
    screen -D -r $1
  fi
}
alias rescreen=RESCREEN


# Reserve some CPUs in one compute node and open an interactive shell
function IMBC_NODE {


  local OPTIND opt time partition cpus mem

  time="7-0"
  partition="bcflong"
  cpus="4"
  mem="1G"

  while getopts ":t:p:j:m:" opt; do
    case "${opt}" in
      t)
        time="${OPTARG}"
        ;;
      p)
        partition="${OPTARG}"
        ;;
      j)
        cpus="${OPTARG}"
        ;;
      m)
        mem="${OPTARG}"
        ;;
      :)
        echo "Invalid option: $OPTARG requires an argument" 1>&2
        echo "Call with: imbc_node [-t <7-0>] [-p <bcflong>] [-j <4>] [-m <1G>]" 1>&2
        return 1
        ;;
      *)
        echo "Call with: imbc_node [-t <7-0>] [-p <bcflong>] [-j <4>] [-m <1G>]" 1>&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND-1))

  echo "srun --pty --time=$time --partition=$partition --ntasks=1 --cpus-per-task=$cpus --mem-per-cpu=$mem bash"
}

alias imbc_node=IMBC_NODE

function PDF2PNG {
  gs -dNOPAUSE -dBATCH -sDEVICE=png16m -sOutputFile="${1%.pdf}-%d.png" $1
}
alias pdf2png=PDF2PNG

