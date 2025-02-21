# Servers
alias hpc='ssh -L 8787:127.0.0.1:8787 -YC hpclogin'
alias hpc1='ssh -L 8787:127.0.0.1:8787 -YC hpc1'
#alias hpc1='hpc_node -w hpc1'
#alias hpc2='hpc_node -w hpc2'
#alias hpc3='hpc_node -w hpc3'
#alias hpcgpu='hpc_node -w hpcgpu'
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
alias view='vim -R'
alias browsh='singularity exec ~/bin/browsh.simg /app/browsh'

# Fun
alias weather='curl wttr.in'

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

  time=1-0
  partition=bcflong
  cpus=1
  mem=16G
  node=hpc1
  jobname=bash

  errmsg="Call with: hpc_node [-t <1-0>] [-p <bcflong>] [-c <1>] [-m <16G>] [-w hpc1] [-j bash]"

  while getopts ":t:p:c:m:w:j:h" opt; do
    case "${opt}" in
      t)
        time="${OPTARG}"
        ;;
      p)
        partition="${OPTARG}"
        ;;
      c)
        cpus="${OPTARG}"
        ;;
      m)
        mem="${OPTARG}"
        ;;
      w)
        node="${OPTARG}"
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

  srun --pty --x11 --time=$time --partition=$partition -c $cpus --nodes=1 --mem=$mem -w $node -J ${jobname} bash
}

alias hpc_node=HPC_NODE

# Write an sbatch header
function SBATCH_HEADER {

  local OPTIND opt wallclock partition threads mem output jobname errmsg

  time=1:00:00
  partition=bcfshort
  cpus=1
  mem=16G
  output=slurm_job.out
  jobname=bash

  errmsg="Call with: sbatch_header [-t <1:00:00>] [-p <bcfshort>] [-c <1>] [-m <16G>] [-o slurm_job.out] [-j bash]"

  while getopts ":w:p:t:m:o:j:h" opt; do
    case "${opt}" in
      t)
        time="${OPTARG}"
        ;;
      p)
        partition="${OPTARG}"
        ;;
      c)
        cpus="${OPTARG}"
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

#SBATCH --time=${time}
#SBATCH --nodes=1
#SBATCH --cpus-per-task=${cpus}
#SBATCH --partition=${partition}
#SBATCH --mem=${mem}
#SBATCH --output=${output}
#SBATCH --job-name=${jobname}

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

# PDF manipulation
function PDF2PNG {
  gs -dNOPAUSE -dBATCH -sDEVICE=pngalpha -r144 -sOutputFile="${1%.pdf}-%d.png" $1
}
alias pdf2png=PDF2PNG

function MERGEPDF {
  i=$(($# - 1))
  j=$#
  gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=${@:$i+1:$j} ${@:1:$i}
}
alias mergepdf=MERGEPDF

# R spin template
R_SPIN_TEMPLATE() {
  cat <<EOF
#' ---
#' title: "Title"
#' output:
#'   html_document:
#'     toc: true
#'     code_folding: hide
#'     theme: paper
#' ---
#' 
#' # Intro
#' Preamble
knitr::opts_chunk\$set(message=FALSE, warning=FALSE)
library(ggplot2)
library(plotly)
library(DT)
library(htmltools)
library(knitr)

DT_OPTIONS <- list(pageLength  =5,      # and then call \`DT::datatable(x, extensions="Buttons", options=DT_OPTIONS)\`
                   paging      =TRUE,
                   searching   =TRUE,
                   fixedColumns=TRUE,
                   autoWidth   =TRUE,
                   ordering    =TRUE,
                   dom         ="Blfrtip",
                   buttons     =c("copy", "csv", "excel"))
PROJECT <- "/project/folder"
CORES <- 8

setwd(PROJECT)
knitr::opts_knit\$set(root.dir=PROJECT)
options(mc.cores=CORES)
EOF
}
alias R_spin=R_SPIN_TEMPLATE
