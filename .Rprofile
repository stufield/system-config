# --------------------------------------------------- #
# General use suggested .Rprofile for env setup
# Include additional functionality as required
# 2020-04-16
# Stu Field, Bioinformatics, SomaLogic, Inc.
# --------------------------------------------------- #

# ------------------------- #
## session options
# ------------------------- #
options(
  stringsAsFactors           = FALSE,
  showWarnCalls              = TRUE,
  warnPartialMatchArgs       = FALSE,
  warnPartialMatchDollar     = FALSE,
  warnPartialMatchAttr       = FALSE,
  showErrorCalls             = TRUE,
  roxygen.comment            = "#' ",
  max.print                  = 500,         # default 1000 too verbose
  warn.length                = 8170,        # this is the max possible
  devtools.name              = "Stu Field",
  devtools.path              = "~/R-dev",
  devtools.desc.author       = 'person("Stu", "Field", email = "sfield@somalogic.com", role = c("aut", "cre"))',
  devtools.desc.license      = "GPL-3",
  covr.gcov                  = Sys.which("gcov"),
  #repos                     = c(CRAN = "http://cran.rstudio.com"), # CRAN mirror
  repos                      = c(rspm_latest = "https://rstudiopm.sladmin.com/sl-internal-plus-full-cran/latest/"),
  reprex.si                  = TRUE,
  reprex.advertise           = TRUE,
  reprex.tidyverse_quiet     = TRUE,
  reprex.style               = FALSE,
  reprex.comment             = "#>",
  reprex.highlight.hl_style  = "anotherdark",
  reprex.highlight.font      = "Andale Mono Regular",
  reprex.highlight.font_size = 100,
  reprex.highlight.other     = "--line-numbers"
)
# ------------------------- #
## load packages immediately
# ------------------------- #
if ( interactive() ) {
  options(prompt = "\033[34m> \033[39m")
  suppressMessages(library(devtools))
  suppressMessages(library(usethis))
  suppressMessages(library(git2r))
  suppressMessages(library(reprex))
  #library(somaverse)               # One day!
  #library(kknn)                    # k-Nearest Neighbor
  #library(gplots)                  # plotting
  #library(fdrtool)                 # FDR correction
  #library(e1071)                   # Naive Bayes
  #library(glmnet)                  # Logistic Regression & Lasso
}

# Set up custom debugging environment
.customCommands <- new.env()
assign("bug", structure("", class = "debugger_class"), envir = .customCommands)
assign("print.debugger_class", function(debugger) {
  if ( !identical(as.character(getOption("error")), "rlang::entrace") ) {
    options(error = quote(rlang::entrace()),
            rlang__backtrace_on_error = "full")  # or "collapse"
    message(
      crayon::green(
        cli::symbol$tick,
        "debugging is now ON",
        cli::symbol$pointer,
        "option error set to rlang::entrace()"
        )
      )
  } else {
    options(error = NULL)
    message(
      crayon::red(
        cli::symbol$cross,
        "debugging is now OFF",
        cli::symbol$pointer,
        "option error set to NULL"
        )
      )
  }
}, envir = .customCommands)
assign("db", structure("", class = "detacher_class"), envir = .customCommands)
assign("print.detacher_class", function(detacher) {
  detach(".customCommands", unload = TRUE, force = TRUE, character = TRUE)
}, envir = .customCommands)
assign("restart", structure("", class = "restart_class"), envir = .customCommands)
assign("print.restart_class", function(rst) {
  if ( !is.null(tryCatch(usethis::proj_get(), error = function(e) NULL))) {
    rstudioapi::openProject(usethis::proj_get())
  } else {
    message(
      crayon::red(
        cli::symbol$cross,
        "Cannot restart from here -> not inside an RStudio project!"
        )
      )
  }
}, envir = .customCommands)
attach(.customCommands)
rm(.customCommands)
