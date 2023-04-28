# general options
options(stringsAsFactors=FALSE)
options(max.print=1000)
options(menu.graphics=FALSE)
options(Ncpus=min(parallel::detectCores(), getOption("Ncpus", 4L)))
options(mc.cores=min(parallel::detectCores(), getOption("Ncpus", 4L)))

grDevices::palette("Tableau")     # show palette colors with scales::show_col(palette())

# settings for interactive prompts
if(interactive()) {
  options(vimcom.verbose=1)         # vim-r-plugin verbose mode
  options(setWidthOnResize=TRUE)    # set new width when user resizes term
  options(width=132)                # wide display with multiple monitors
  options(editor="vim")
  options(prompt="R> ")
#  options(continue="  ")

  # colorize R output with the colorout package
  if(grepl("256color", Sys.getenv("TERM")) && require(colorout, quietly=TRUE)) {
    setOutputColors256(normal=40, number=214, string=85, const=35, stderr=45,
                       error=c(1, 0, 1), warn=c(1, 0, 100), verbose=FALSE)
  }
  # instead of the normal cairo device, for faster plotting over the network
  if(require(grDevices)) {
    X11.options("type"="dbcairo")  # requires compression in ssh (-C)
  }
}

# Some old versions of biomaRt may raise an error when using an Ensembl mirror if main site is irresponsive.
# See: https://github.com/grimbough/biomaRt/issues/31
setHook(packageEvent("biomaRt", "attach"), function(...) { httr::set_config(httr::config(ssl_verifypeer = FALSE)) })

# change default theme in ggplot2
setHook(packageEvent("ggplot2", "attach"), function(...) {
  ggplot2::theme_set(ggplot2::theme_bw())        # use theme_bw as default
  options(ggplot2.continuous.colour="viridis")   # use viridis for continuous colors
  options(ggplot2.continuous.fill = "viridis")
})

# OpenAI env variable with auth token
# Required to run James H. Wade's GPTtools (https://github.com/JamesHWade/gpttools)
Sys.setenv(OPENAI_API_KEY = "my-beautiful-key")

# in knitr documents, generate both the PNG and SVG version
knitr::opts_chunk$set(dev=c("png", "svg"))

