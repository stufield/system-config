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
  #suppressMessages(library(devtools))
  #suppressMessages(library(usethis))
  #suppressMessages(library(reprex))
  #library(somaverse)
  #library(glmnet)
}

# Set up custom debugging environment
.customCommands <- new.env()
.customCommands$bug <- structure("", class = "debugger_class")
.customCommands$print.debugger_class <- function(debugger) {
  if ( !identical(as.character(getOption("error")), "rlang::entrace") ) {
    options(error = quote(rlang::entrace()),
            rlang__backtrace_on_error = "full")  # or "collapse"
    message(
      crayon::green(
        cli::symbol$tick,
        "Enhanced debugging: ON",
        cli::symbol$arrow_right,
        "getOption('error') set to rlang::entrace()"
        )
      )
  } else {
    options(error = NULL)
    message(
      crayon::red(
        cli::symbol$cross,
        "Enhanced debugging: OFF",
        cli::symbol$arrow_right,
        "getOption('error') is NULL"
        )
      )
  }
}
.customCommands$dt <- structure("", class = "detacher_class")
.customCommands$print.detacher_class <- function(detacher) {
  message(
    crayon::green(cli::symbol$tick, "Detaching '.customCommands' from search path")
  )
  detach(".customCommands", unload = TRUE, force = TRUE, character = TRUE)
}
.customCommands$restart <- structure("", class = "restart_class")
.customCommands$print.restart_class <- function(rst) {
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
}

.customCommands$devmode <- local({
  .prompt <- NULL
  function(on = NULL, path = getOption("devtools.path")) {
    lib_paths <- .libPaths()
    path <- normalizePath(path, winslash = "/", mustWork = FALSE)
    if (is.null(on)) {
      on <- !(path %in% lib_paths)
    }
    if (on) {
      if (!file.exists(path)) {
        dir.create(path, recursive = TRUE, showWarnings = FALSE)
      }
      if (!file.exists(path)) {
        stop("Failed to create ", path, call. = FALSE)
      }
      message("Dev mode: ON")
      options(dev_path = path)
      if (is.null(.prompt)) {
        .prompt <<- getOption("prompt")
      }
      options(prompt = paste("d> "))
      .libPaths(c(path, lib_paths))
    } else {
      message("Dev mode: OFF")
      options(dev_path = NULL)
      if (!is.null(.prompt)) {
        options(prompt = .prompt)
      }
      .prompt <<- NULL
      .libPaths(setdiff(lib_paths, path))
    }
  }
})

attach(.customCommands)
rm(.customCommands)
