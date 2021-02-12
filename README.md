
<!-- README.md is generated from README.Rmd. Please edit that file -->

# system\_config

A Stu specific repository of system level files:

  - ‘dot’ files
  - run command (`rc`) files
  - configuration files

-----

## File Summary

| File                | Configure                                 |
| ------------------- | ----------------------------------------- |
| `.Rprofile`         | Profile for R startup                     |
| `.Renviron`         | Config file for RStudio global variables  |
| `.gitconfig`        | Global config file for Git                |
| `.gitignore_global` | Global Git ignore file                    |
| `.zshrc`            | Config file for Z-shell                   |
| `.bash_functions`   | BASH function utilities                   |
| `.bashrc`           | Config file for Bourne Again Shell (BASH) |
| `.vimrc`            | Config file for VIM                       |

| Directory | Configure                                        |
| --------- | ------------------------------------------------ |
| `zsh`     | ZSH specific config \*.zsh files                 |
| `vim`     | VIM specific config files                        |
| `texmf`   | Config for `pdflatex`; particularly `stuTeX.tex` |

-----

### Debugger mode (`.Rprofile`)

Allows for user friendly simplified call stack traces with a simple
toggle:

``` r
f <- function(x) {
  x + g(x)
}

g <- function(y) {
  foo <- y * 2
  bar <- paste0(foo, h())
  bar - 100
}

h <- function() {
  stop("error here", call. = FALSE)
}

f(pi)       # not very informative

traceback() # traceback is ok

# Turn on de-bugger mode
bugger

f(pi)       # automatically prints the stack trace as a tree

# Turn off de-bugger mode
bugger
```

  - `rlang` <https://www.tidyverse.org/articles/2019/01/rlang-0-3-1/>

<details>

<summary>Session info</summary>

``` r
session_info()
#> ─ Session info ───────────────────────────────────────────────────────────────
#>  setting  value                       
#>  version  R version 3.6.3 (2020-02-29)
#>  os       macOS Catalina 10.15.7      
#>  system   x86_64, darwin15.6.0        
#>  ui       X11                         
#>  language (EN)                        
#>  collate  en_US.UTF-8                 
#>  ctype    en_US.UTF-8                 
#>  tz       America/Denver              
#>  date     2021-02-12                  
#> 
#> ─ Packages ───────────────────────────────────────────────────────────────────
#>  package     * version date       lib source        
#>  assertthat    0.2.1   2019-03-21 [1] CRAN (R 3.6.2)
#>  backports     1.1.8   2020-06-17 [1] RSPM (R 3.6.3)
#>  callr         3.4.3   2020-03-28 [1] RSPM (R 3.6.3)
#>  cli           2.0.2   2020-02-28 [1] RSPM (R 3.6.3)
#>  crayon        1.3.4   2017-09-16 [1] CRAN (R 3.6.2)
#>  desc          1.2.0   2018-05-01 [1] CRAN (R 3.6.2)
#>  devtools    * 2.3.0   2020-04-10 [1] RSPM (R 3.6.3)
#>  digest        0.6.25  2020-02-23 [1] RSPM (R 3.6.3)
#>  ellipsis      0.3.1   2020-05-15 [1] CRAN (R 3.6.3)
#>  evaluate      0.14    2019-05-28 [1] CRAN (R 3.6.2)
#>  fansi         0.4.1   2020-01-08 [1] CRAN (R 3.6.2)
#>  fs            1.4.1   2020-04-04 [1] RSPM (R 3.6.3)
#>  glue          1.4.2   2020-08-27 [1] CRAN (R 3.6.3)
#>  htmltools     0.4.0   2019-10-04 [1] CRAN (R 3.6.2)
#>  knitr         1.28    2020-02-06 [1] CRAN (R 3.6.2)
#>  magrittr      1.5     2014-11-22 [1] CRAN (R 3.6.2)
#>  memoise       1.1.0   2017-04-21 [1] CRAN (R 3.6.2)
#>  pkgbuild      1.0.6   2019-10-09 [1] CRAN (R 3.6.2)
#>  pkgload       1.0.2   2018-10-29 [1] CRAN (R 3.6.2)
#>  prettyunits   1.1.1   2020-01-24 [1] CRAN (R 3.6.2)
#>  processx      3.4.2   2020-02-09 [1] CRAN (R 3.6.2)
#>  ps            1.3.2   2020-02-13 [1] RSPM (R 3.6.3)
#>  R6            2.4.1   2019-11-12 [1] CRAN (R 3.6.2)
#>  Rcpp          1.0.4.6 2020-04-09 [1] RSPM (R 3.6.3)
#>  remotes       2.1.1   2020-02-15 [1] RSPM (R 3.6.2)
#>  rlang         0.4.6   2020-05-02 [1] RSPM (R 3.6.3)
#>  rmarkdown     2.1     2020-01-20 [1] CRAN (R 3.6.2)
#>  rprojroot     1.3-2   2018-01-03 [1] CRAN (R 3.6.2)
#>  sessioninfo   1.1.1   2018-11-05 [1] CRAN (R 3.6.2)
#>  stringi       1.4.6   2020-02-17 [1] RSPM (R 3.6.3)
#>  stringr       1.4.0   2019-02-10 [1] CRAN (R 3.6.2)
#>  testthat      2.3.2   2020-03-02 [1] RSPM (R 3.6.3)
#>  usethis     * 1.6.0   2020-04-09 [1] RSPM (R 3.6.3)
#>  withr         2.2.0   2020-04-20 [1] RSPM (R 3.6.3)
#>  xfun          0.13    2020-04-13 [1] RSPM (R 3.6.3)
#>  yaml          2.2.1   2020-02-01 [1] CRAN (R 3.6.2)
#> 
#> [1] /Users/sfield/r_libs
#> [2] /Library/Frameworks/R.framework/Versions/3.6/Resources/library
```

</details>

-----

Created on 2021-02-12 by
[Rmarkdown](https://github.com/rstudio/rmarkdown) (v2.1) and R version
3.6.3 (2020-02-29).
