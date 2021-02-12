# --------------------------------------------------- #
# General use suggested .Rprofile for env setup
# Include additional functionality as required
# 2020-08-13
# Stu Field, Bioinformatics, SomaLogic, Inc.
# --------------------------------------------------- #

# ---------------- #
# session options
# ---------------- #
options(
  showWarnCalls              = TRUE,
  showErrorCalls             = TRUE,
  stringsAsFactors           = FALSE,
  warnPartialMatchArgs       = FALSE,
  warnPartialMatchDollar     = FALSE,
  warnPartialMatchAttr       = FALSE,
  roxygen.comment            = "#' ",
  max.print                  = 500,         # default 1000 too verbose
  warn.length                = 8170,        # this is the max possible
  devtools.name              = "Stu Field",
  devtools.path              = "~/R-dev",
  devtools.desc.author       = "person('Stu', 'Field', email = 'sfield@somalogic.com', role = c('aut', 'cre'))",
  devtools.desc.license      = "GPL-3",
  covr.gcov                  = Sys.which("gcov"),
  repos                      = c(rspm = "https://rstudiopm.sladmin.com/sl-internal-plus-full-cran/1005/"),
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
  if ( requireNamespace("prompt", quietly = TRUE) ) {
    git_prompt <- function(...) {
      br <- paste0("\033[34m", prompt::git_branch(), "\033[39m")
      paste0("[", br, "]", " \033[31m> \033[39m")
    }
    prompt::set_prompt(git_prompt)
    rm(git_prompt)
  }
  #suppressMessages(library(reprex))
  #suppressMessages(library(devtools))
  #suppressMessages(library(usethis))
  #library(somaverse)
  #library(glmnet)
}

local({
  # Set up custom debugging environment
  .customCommands <- new.env()
  .customCommands$bugger <- structure("", class = "bugger_class")
  .customCommands$print.bugger_class <- function(.bug) {
    if ( !identical(as.character(getOption("error")), "rlang::entrace") ) {
      options(error = quote(rlang::entrace()),
              rlang__backtrace_on_error = "full")  # or "collapse"
      message(
        "Enhanced debugging: ON >> getOption('error') set to rlang::entrace()"
      )
    } else {
      options(error = NULL)
      message("Enhanced debugging: OFF >> getOption('error') is NULL")
    }
  }

  .customCommands$detacher <- structure("", class = "detacher_class")
  .customCommands$print.detacher_class <- function(.dt) {
    message("Detaching '.customCommands' from search path")
    detach(".customCommands", unload = TRUE, force = TRUE, character = TRUE)
  }

  .customCommands$restart <- structure("", class = "restart_class")
  .customCommands$print.restart_class <- function(.rst) {
      rstudioapi::restartSession()
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

  .customCommands$.repo  <- c(CRAN = "http://cran.rstudio.com") # CRAN mirror
  .customCommands$.check <- function(jenkins = FALSE, ...) {
    if (jenkins)
      devtools::check(env_vars = c(ON_JENKINS = 'true', NOT_CRAN = 'true'), ...)
    else
      devtools::check()
  }
  attach(.customCommands)
})
