# --------------------------------------------------- #
# General use suggested .Rprofile for env setup
# Include additional functionality as required
# 2022-02-06
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
  repos                      = c(rspm = "https://rstudiopm.sladmin.com/sl-internal-plus-full-cran/1704/"),
  roxygen.comment            = "#' ",
  max.print                  = 250,         # default 1000 too verbose
  warn.length                = 8170,        # this is the max possible
  devtools.name              = "Stu Field",
  devtools.path              = Sys.getenv("R_LIBS_DEV"),
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
  local({
    .prompt_env <- new.env(parent = emptyenv())
    .prompt_env$id <- 0L
    emoji <- c(
      "\U0001f600", # smile
      "\U0001f973", # party face
      "\U0001f638", # cat grin
      "\U0001f308", # rainbow
      "\U0001f947", # gold medal
      "\U0001f389", # party popper
      "\U0001f38a", # confetti ball
      "\U0001F449"  # pointing finger
    )
    update_prompt <- function(...) {
      options(prompt = git_prompt())
    }
    git_prompt <- function() {
      if ( !dir.exists(".git") ) { # if outside git, iterate emoji
        .prompt_env$id <- .prompt_env$id %% length(emoji) + 1L
      }
      br <- tryCatch(
        system2("git", c("rev-parse", "--abbrev-ref", "HEAD"),
                stdout = TRUE, stderr = FALSE),
        warning = function(w) emoji[.prompt_env$id]
      )
      br <- paste0("\033[34m", br, "\033[39m")
      paste("\033[36m@", br, "\033[31m> \033[39m")
    }
    addTaskCallback(
      function(expr, value, ok, visible) {
        try(update_prompt(expr, value, ok, visible), silent = TRUE)
        return(TRUE)
      }, name = "prompt_callback"
    )
    invisible()
  })
}

# Special invisible commands
local({
  .customCommands <- new.env()
  .customCommands$devmode <- local({
    function(path = getOption("devtools.path")) {
      lib_paths <- .libPaths()
      path <- normalizePath(path, winslash = "/", mustWork = TRUE)
      on <- !(path %in% lib_paths)
      if (on) {
        message("Dev mode: ON")
        options(dev_path = path)
        .libPaths(c(path, lib_paths))
      } else {
        message("Dev mode: OFF")
        options(dev_path = NULL)
        .libPaths(setdiff(lib_paths, path))
      }
    }
  })

  .customCommands$.repo  <- c(CRAN = "https://cloud.r-project.org/") # mirror
  .customCommands$.check <- function(jenkins = TRUE, ...) {
    if (jenkins) {
      devtools::check(document = FALSE,
                      vignettes = FALSE,
                      env_vars = c(ON_JENKINS = "true",
                                   NOT_CRAN = "true",
                                   TZ = "America/Denver"), ...)
    } else {
      devtools::check(...)
    }
  }
  .customCommands$detach_custom <- function() {
    message("Detaching '.customCommands' from search path")
    detach(".customCommands", unload = TRUE, force = TRUE, character = TRUE)
  }
  attach(.customCommands)
})
