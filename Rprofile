options(vimcom.verbose=1)
options(width=132)                # wide display with multiple monitors
options(stringsAsFactors=FALSE)
options(max.print=1000)
options(menu.graphics=FALSE)
options(editor="vim")
options(Ncpus=min(parallel::detectCores(), getOption("Ncpus", 4L))) # used in, at least, ?install.packages
options(mc.cores=gmin(parallel::detectCores(), getOption("Ncpus", 4L)))
options(prompt="R> ")
options(repos=c("CRAN"="http://cran.rstudio.org/"))

if(interactive()){
  # colorize R output
  if(grepl("256color",Sys.getenv("TERM")) & require(colorout)) {
    setOutputColors256(normal=40, number=214, string=85, const=35, stderr=45,
                       error=c(1, 0, 1), warn=c(1, 0, 100), verbose=F)
  }
  # adjusts the value of options("width") whenever the terminal is resized
  require(setwidth)
  # instead of the normal cairo device, for fast plotting over the network
  if(require(grDevices)) X11.options(type="nbcairo") 
}
