# --------------------------------------------------- #
# General use suggested .Rprofile for env setup
# Include additional functionality as required
# 2021-04-26
# Stu Field, Bioinformatics, SomaLogic, Inc.
# --------------------------------------------------- #

# ---------------- #
# session options
# ---------------- #
options(
  stringsAsFactors           = FALSE,
  showWarnCalls              = TRUE,
  showErrorCalls             = TRUE,
  warnPartialMatchArgs       = FALSE,
  warnPartialMatchDollar     = FALSE,
  warnPartialMatchAttr       = FALSE,
  repos                      = c(rspm = "https://rstudiopm.sladmin.com/sl-internal-plus-full-cran/1115/"),
  roxygen.comment            = "#' ",
  max.print                  = 250,         # default 1000 too verbose
  warn.length                = 8170,        # this is the max possible
  devtools.name              = "Stu Field",
  devtools.path              = "~/R-dev",
  devtools.desc.author       = "person('Stu', 'Field', email = 'sfield@somalogic.com', role = c('aut', 'cre'))",
  devtools.desc.license      = "MIT",
  covr.gcov                  = Sys.which("gcov"),
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

# -------------- #
# fancy prompt
# -------------- #
if ( interactive() ) {
  if ( requireNamespace("prompt", quietly = TRUE) ) {
    git_prompt <- function(...) {
      br <- paste0("\033[34m", prompt::git_branch(), "\033[39m")
      paste0("[", br, "]", " \033[31m> \033[39m")
    }
    prompt::set_prompt(git_prompt)
    rm(git_prompt)
  }
}

# Special invisible commands
local({
  .customCommands <- new.env()
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
  .customCommands$detach_custom <- function() {
    message("Detaching '.customCommands' from search path")
    detach(".customCommands", unload = TRUE, force = TRUE, character = TRUE)
  }
  attach(.customCommands)
})
