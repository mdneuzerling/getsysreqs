#' Generate an installation command for the system dependencies of the given packages
#'
#' @inherit get_sysreqs_json details
#'
#' @inheritParams get_sysreqs_json
#'
#' @return A character vector of required packages
#' @export
#'
#' @examples \dontrun{
#' apt_get_install("tidyverse", distribution = "centos")
#' apt_get_install(
#'   c("plumber", "rmarkdown"),
#'   distribution = "ubuntu",
#'   release = "20.04"
#' )
#' }
apt_get_install <- function(packages,
                            distribution = "ubuntu",
                            release = NULL) {
  sysreqs <- get_sysreqs(packages)
  paste(
    "apt-get update -qq",
    "&&",
    "apt-get -y --no-install-recommends install",
    paste(sysreqs, collapse = " ")
  )
}
