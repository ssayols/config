# general options
options(stringsAsFactors=FALSE)
options(max.print=1000)
options(menu.graphics=FALSE)
options(Ncpus=min(parallel::detectCores(), getOption("Ncpus", 4L)))
options(mc.cores=min(parallel::detectCores(), getOption("Ncpus", 4L)))

# change repos (add BioC + non-secure server for Germany)
source("http://bioconductor.org/biocLite.R")
x=biocinstallRepos()
x["CRAN"]="http://cran.uni-muenster.de/"
options(repos=x)

# settings for interactive prompts
if(interactive()) {
  options(vimcom.verbose=1)         # vim-r-plugin verbose mode
  options(setWidthOnResize=TRUE)    # set new width when user resizes term
  options(width=132)                # wide display with multiple monitors
  options(editor="vim")
  options(prompt="R> ")
  options(continue="  ")

  # colorize R output with the colorout package
  if(grepl("256color", Sys.getenv("TERM")) && require(colorout)) {
    setOutputColors256(normal=40, number=214, string=85, const=35, stderr=45,
                       error=c(1, 0, 1), warn=c(1, 0, 100), verbose=FALSE)
  }
  # instead of the normal cairo device, for faster plotting over the network
  if(require(grDevices)) X11.options("type"="nbcairo")
}
