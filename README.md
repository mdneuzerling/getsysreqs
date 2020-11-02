
# getsysreqs

<!-- badges: start -->
[![R-CMD-check](https://github.com/mdneuzerling/getsysreqs/workflows/R-CMD-check/badge.svg)](https://github.com/mdneuzerling/getsysreqs/actions)
<!-- badges: end -->

Determine system requirements from R packages using [the RStudio Package Manager](https://packagemanager.rstudio.com/__api__/swagger/index.html). Query with either a list of packages, or an `renv` lockfile. If using an `renv`  lockfile, only CRAN packages will be used.

## Installation

You can install the development version of `sysreqs` from Github with:

``` r
remotes::install_github("mdneuzerling/getsysreqs")
```

## Example

Determine system dependencies for both `plumber` and `rmarkdown` on an Ubuntu 20.04 system:

``` r
library(getsysreqs)
get_sysreqs(
  c("plumber", "rmarkdown"),
  distribution = "ubuntu",
  release = "20.04"
)

# [1] "libsodium-dev"        "libcurl4-openssl-dev" "libssl-dev"           "make"                
# [5] "libicu-dev"           "pandoc" 
```

Alternatively, pass the file path to an `renv` lockfile, or directory containing `renv.lock`.

## Inspiration

[The `sysreqs` package](https://github.com/r-hub/sysreqs) generates a list of system dependency installation commands from the DESCRIPTION file of an R package. `sysreqs` uses [https://sysreqs.r-hub.io/](https://sysreqs.r-hub.io/) rather than the Rstudio Package Manager.

## Warning

I whipped this up in a few hours without much care. If you wish to use this in a serious project, please think again.
