# Servers
#alias imbc='ssh -Y imb-slurmlogin-02'
#alias imbc_bak='ssh -Y imbc6'
#alias imbc_deb8='ssh -Y -p 22022 imb-slurmlogin'
#alias imbc4='ssh -Y imbc4'
#alias imbc5='ssh -Y imbc5'
alias hpc='ssh -Y hpclogin.imb.uni-mainz.de'
alias hpc1='ssh -Y hpc1'
alias hpc2='ssh -Y hpc2'
alias hpc3='ssh -Y hpc3'
alias hpcgpu='ssh -Y hpcgpu'
alias mogon='ssh -Y say@mil01.zdv.uni-mainz.de'
alias mogon2='ssh -Y say@miil01.zdv.uni-mainz.de'

# Dirs
alias projects='cd /fsimb/groups/imb-bioinfocf/projects'

# Tools
alias htop='htop -u say'
#alias squeue='squeue -u say'
alias sjob='scontrol show job'
alias sacct='sacct --format="JobID,JobName,Partition,Account,AllocCPUS,CPUTime,MaxRSS,State,ExitCode"'
alias view='vim'
alias dropbox='~/bin/dropbox/dropbox.py'
alias browsh='singularity exec ~/bin/browsh.simg /app/browsh'

# fix screen's DISPLAY var
function RESCREEN {
#	screen -S $1 -X setenv DISPLAY $DISPLAY
#	screen -S $1 -X bindkey -k k1 stuff "export DISPLAY=$DISPLAY\015"
#	screen -S $1 -X bindkey '^[[1;2P' stuff 'Sys.setenv(DISPLAY="$DISPLAY")\015'
#	screen -D -RR $1
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
    # could also bind keys inside of screen, in order to quickly update $DISPLAY with the right value
    screen $SESSION -X bindkey -k k1 stuff "export DISPLAY=$DISPLAY\015";
    screen $SESSION -X bindkey '^[[1;2P' stuff 'Sys.setenv(DISPLAY="$DISPLAY")\015';

    # re-attach
    screen -D -r $1
  fi
}
alias rescreen=RESCREEN

# Reserve some CPUs in one compute node and open an interactive shell
function HPC_NODE {
  
  local OPTIND opt wallclock partition threads mem jobname

  wallclock=7-0
  partition=bcflong
  threads=4
  mem=1G
  jobname=bash

  while getopts ":w:p:t:m:j:h" opt; do
    case "${opt}" in
      w)
        wallclock="${OPTARG}"
        ;;
      p)
        partition="${OPTARG}"
        ;;
      t)
        threads="${OPTARG}"
        ;;
      m)
        mem="${OPTARG}"
        ;;
      j)
        jobname="${OPTARG}"
        ;;
      h)
        echo "Call with: hpc_node [-w <7-0>] [-p <bcflong>] [-t <4>] [-m <1G>] [-j bash]" 1>&2
        return 0
        ;;
      :)
        echo "Invalid option: $OPTARG requires an argument" 1>&2
        echo "Call with: hpc_node [-w <7-0>] [-p <bcflong>] [-t <4>] [-m <1G>] [-j bash]" 1>&2
        return 1
        ;;
      *)
        echo "Call with: hpc_node [-w <7-0>] [-p <bcflong>] [-t <4>] [-m <1G>] [-j bash]" 1>&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND-1))

  srun --pty --time=$wallclock --partition=$partition --ntasks=$threads --nodes=1 --mem=$mem -J ${jobname} bash
}

alias hpc_node=HPC_NODE

# Write an sbatch header
function SBATCH_HEADER {

  local OPTIND opt wallclock partition threads mem jobname

  wallclock=1:00:00
  partition=bcflong
  threads=4
  mem=1G
  jobname=bash

  while getopts ":w:p:t:m:j:h" opt; do
    case "${opt}" in
      w)
        wallclock="${OPTARG}"
        ;;
      p)
        partition="${OPTARG}"
        ;;
      t)
        threads="${OPTARG}"
        ;;
      m)
        mem="${OPTARG}"
        ;;
      j)
        jobname="${OPTARG}"
        ;;
      h)
        echo "Call with: sbatch_header [-w <7-0>] [-p <bcflong>] [-t <4>] [-m <1G>] [-j bash]" 1>&2
        return 0
        ;;
      :)
        echo "Invalid option: $OPTARG requires an argument" 1>&2
        echo "Call with: sbatch_header [-w <7-0>] [-p <bcflong>] [-t <4>] [-m <1G>] [-j bash]" 1>&2
        return 1
        ;;
      *)
        echo "Call with: sbatch_header [-w <7-0>] [-p <bcflong>] [-t <4>] [-m <1G>] [-j bash]" 1>&2
        return 1
        ;;
    esac
  done
  shift $((OPTIND-1))

cat <<EOF
#!/bin/bash

#SBATCH --time=${wallclock}
#SBATCH --nodes=1
#SBATCH --ntasks=${threads}
#SBATCH --partition=${partition}
#SBATCH --mem=${mem}
#SBATCH -J ${jobname}

EOF
}

alias sbatch_header=SBATCH_HEADER
