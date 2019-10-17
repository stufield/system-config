
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

### `.Rprofile`: Debugger mode

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

# Turn on debugger mode
bug

f(pi)       # automatically prints the stack trace as a tree

# Turn off debugger mode
bug
```

  - `rlang` <https://www.tidyverse.org/articles/2019/01/rlang-0-3-1/>

<details>

<summary>Session info</summary>

``` r
session_info()
#> ─ Session info ──────────────────────────────────────────────────────────
#>  setting  value                       
#>  version  R version 3.5.2 (2018-12-20)
#>  os       macOS Mojave 10.14.6        
#>  system   x86_64, darwin15.6.0        
#>  ui       X11                         
#>  language (EN)                        
#>  collate  en_US.UTF-8                 
#>  ctype    en_US.UTF-8                 
#>  tz       America/Denver              
#>  date     2019-10-17                  
#> 
#> ─ Packages ──────────────────────────────────────────────────────────────
#>  package     * version date       lib source        
#>  assertthat    0.2.0   2017-04-11 [1] CRAN (R 3.5.0)
#>  backports     1.1.3   2018-12-14 [1] CRAN (R 3.5.0)
#>  callr         3.1.1   2018-12-21 [1] CRAN (R 3.5.0)
#>  cli           1.1.0   2019-03-19 [1] RSPM (R 3.5.2)
#>  crayon        1.3.4   2017-09-16 [1] RSPM (R 3.5.2)
#>  desc          1.2.0   2018-05-01 [1] CRAN (R 3.5.0)
#>  devtools    * 2.0.2   2019-04-08 [1] RSPM (R 3.5.2)
#>  digest        0.6.18  2018-10-10 [1] CRAN (R 3.5.0)
#>  evaluate      0.13    2019-02-12 [1] CRAN (R 3.5.2)
#>  fs            1.3.1   2019-05-06 [1] CRAN (R 3.5.2)
#>  glue          1.3.1   2019-03-12 [1] CRAN (R 3.5.2)
#>  htmltools     0.3.6   2017-04-28 [1] CRAN (R 3.5.0)
#>  knitr         1.22    2019-03-08 [1] CRAN (R 3.5.2)
#>  magrittr      1.5     2014-11-22 [1] RSPM (R 3.5.2)
#>  memoise       1.1.0   2017-04-21 [1] CRAN (R 3.5.0)
#>  pkgbuild      1.0.2   2018-10-16 [1] CRAN (R 3.5.0)
#>  pkgload       1.0.2   2018-10-29 [1] CRAN (R 3.5.0)
#>  prettyunits   1.0.2   2015-07-13 [1] CRAN (R 3.5.0)
#>  processx      3.2.1   2018-12-05 [1] CRAN (R 3.5.0)
#>  ps            1.3.0   2018-12-21 [1] CRAN (R 3.5.0)
#>  R6            2.4.0   2019-02-14 [1] CRAN (R 3.5.2)
#>  Rcpp          1.0.1   2019-03-17 [1] RSPM (R 3.5.2)
#>  remotes       2.0.2   2018-10-30 [1] CRAN (R 3.5.0)
#>  rlang         0.4.0   2019-06-25 [1] RSPM (R 3.5.2)
#>  rmarkdown     1.11    2018-12-08 [1] CRAN (R 3.5.0)
#>  rprojroot     1.3-2   2018-01-03 [1] CRAN (R 3.5.0)
#>  sessioninfo   1.1.1   2018-11-05 [1] CRAN (R 3.5.0)
#>  stringi       1.4.3   2019-03-12 [1] CRAN (R 3.5.2)
#>  stringr       1.4.0   2019-02-10 [1] RSPM (R 3.5.2)
#>  testthat      2.2.0   2019-07-22 [1] CRAN (R 3.5.2)
#>  usethis     * 1.5.0   2019-04-07 [1] CRAN (R 3.5.2)
#>  withr         2.1.2   2018-03-15 [1] CRAN (R 3.5.0)
#>  xfun          0.5     2019-02-20 [1] CRAN (R 3.5.2)
#>  yaml          2.2.0   2018-07-25 [1] CRAN (R 3.5.0)
#> 
#> [1] /Users/sfield/r_libs
#> [2] /Library/Frameworks/R.framework/Versions/3.5/Resources/library
```

</details>

-----

Created on 2019-10-17 by
[Rmarkdown](https://github.com/rstudio/rmarkdown) (v1.11) and R version
3.5.2 (2018-12-20).
