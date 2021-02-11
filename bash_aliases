# Servers
alias hpc='ssh -Y hpclogin'
alias hpc1='ssh -Y hpc1'
alias hpc2='ssh -Y hpc2'
alias hpc3='ssh -Y hpc3'
alias hpcgpu='ssh -Y hpcgpu'
alias mogon='ssh -Y say@mil01.zdv.uni-mainz.de'
alias mogon2='ssh -Y say@miil01.zdv.uni-mainz.de'
alias rstudio_hpc='ssh -NL 8787:127.0.0.1:8787 say@hpcgpu.imb.uni-mainz.de & sleep 2; echo "remember to kill the background job to remove the tunnel!"; firefox http://127.0.0.1:8787'

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

  local OPTIND opt wallclock partition threads mem output jobname errmsg

  wallclock=1:00:00
  partition=bcflong
  threads=4
  mem=1G
  output=slurm_job.out
  jobname=bash
  
  errmsg="Call with: sbatch_header [-w <7-0>] [-p <bcflong>] [-t <4>] [-m <1G>] [-o slurm_job.out] [-j bash]"

  while getopts ":w:p:t:m:o:j:h" opt; do
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
      o)
        output="${OPTARG}"
        ;;
      j)
        jobname="${OPTARG}"
        ;;
      h)
        echo $errmsg 1>&2
        return 0
        ;;
      :)
        echo "Invalid option: $OPTARG requires an argument" 1>&2
        echo $errmsg 1>&2
        return 1
        ;;
      *)
        echo $errmsg 1>&2
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
#SBATCH --output=${output}
#SBATCH -J ${jobname}

set -Eeuo pipefail

trap 'catch \$? \$LINENO' ERR

catch() {
  curl -LX POST -d "{\"username\": \"${jobname}\", \"channel\": \"@sergisayolspuig\", \"text\": \"Error \$1 occurred on \$2 \"}" tinyurl.com/rwv7nxnv
}

# your script starts here

curl -LX POST -d "{\"username\": \"${jobname}\", \"channel\": \"@sergisayolspuig\", \"text\": \"Finished succesfully\"}" tinyurl.com/rwv7nxnv

EOF
}

alias sbatch_header=SBATCH_HEADER

# DF manipulation
function PDF2PNG {
  gs -dNOPAUSE -dBATCH -sDEVICE=pngalpha -r144 -sOutputFile="${1%.pdf}-%d.png" $1
}
alias pdf2png=PDF2PNG

function MERGEPDF {
  gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=out.pdf $@
}
alias mergepdf=MERGEPDF
