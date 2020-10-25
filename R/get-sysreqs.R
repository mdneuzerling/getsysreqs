#' Query the public RStudio Package
#'
#' @details This queries the RStudio Package Manager API
#' (\url{https://packagemanager.rstudio.com/__api__/swagger/index.html}).
#' This API may change in the future.
#'
#' @param packages Character vector of packages. Alternatively, the file path of
#'   an `renv` lockfile, or directory containing `renv.lock`. In this case, the
#'   CRAN packages will be extracted from the lockfile and used as input.
#' @param distribution Character. Operating system or distribution of the target
#'   system. For example, "ubuntu" or "centos".
#' @param release Character. Release of the operating system, eg. "18.04". It's
#'   not clear what this defaults to, but it is likely to be the latest release.
#'
#' @return An httr response, parsed as a JSON
#'
#' @keywords internal
#'
#' @examples \dontrun{
#' get_sysreqs_json("tidyverse", distribution = "centos")
#' get_sysreqs_json(
#'   c("plumber", "rmarkdown"),
#'   distribution = "ubuntu",
#'   release = "20.04"
#' )
#' }
get_sysreqs_json <- function(packages,
                             distribution = "ubuntu",
                             release = NULL) {
  packages <- interpret_as_list_of_packages(packages)
  request <- paste0(
    "http://packagemanager.rstudio.com/__api__/repos/1/sysreqs?all=false",
    paste0("&pkgname=", packages, collapse = ""),
    "&distribution=", distribution
  )
  if (!is.null(release)) {
    request <- paste0(request, "&release=", release)
  }
  response <- httr::GET(request)
  status_code <- httr::status_code(response)
  if (status_code != 200) {
    error_message <- paste("Status code", status_code)
    if (httr::has_content(response)) {
      error_message <- paste0(error_message, ": ", httr::content(response, "text"))
    }
    stop(error_message)
  }
  jsonlite::fromJSON(httr::content(response, "text"))
}

#' Retrieve a list of system dependencies for the given packages
#'
#' @inherit get_sysreqs_json details
#'
#' @inheritParams get_sysreqs_json
#'
#' @return A character vector of required packages
#' @export
#'
#' @examples \dontrun{
#' get_sysreqs("tidyverse", distribution = "centos")
#' get_sysreqs(
#'   c("plumber", "rmarkdown"),
#'   distribution = "ubuntu",
#'   release = "20.04"
#' )
#' }
get_sysreqs <- function(packages,
                        distribution = "ubuntu",
                        release = NULL) {
  if (length(packages) == 0) {
    return(c())
  }
  content <- get_sysreqs_json(packages, distribution, release)
  required_packages <- content$requirements$requirements$packages
  unique(Reduce(c, required_packages))
}

#' Interpret argument as a list of packages
#'
#' The sysreqs functions take a variety of inputs: either a vector of packages,
#' a file path to an `renv` lockfile, or a path to a directory containing
#' `renv.lock`. This function determines what the intended input is, after
#' validating that the input is a character vector.
#'
#' @param packages
#'
#' @return A (possibly empty) character vector.
#'
#' @keywords internal
#'
interpret_as_list_of_packages <- function(packages) {
  if (!is.character(packages)) {
    stop("Must provide either a list of packages, or the location of an renv ",
         "lock file")
  }
  if (length(packages) != 1) {
    packages
  } else if (dir.exists(packages)) {
    extract_cran_packages(file.path(packages, "renv.lock"))
  } else if (file.exists(packages) && basename(packages) == "renv.lock") {
    extract_cran_packages(packages)
  } else {
    packages
  }
}
