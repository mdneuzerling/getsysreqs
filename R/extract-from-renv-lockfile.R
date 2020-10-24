#' Extract vector of CRAN packages from renv lockfile
#'
#' @param renv_lock Character. Path to renv.lock.
#'
#' @return Character vector of packages.
#'
#' @keywords internal
#'
#' @export
#'
extract_cran_packages <- function(renv_lock) {
  if (!file.exists(renv_lock)) {
    stop("Could not find renv lockfile: ", renv_lock)
  }
  renv_packages <- jsonlite::fromJSON(renv_lock)$Packages
  packages <- lapply(renv_packages, function(x) {
    if (x$Source == "Repository" && x$Repository == "CRAN") x$Package else NULL
  })
  cran_packages <- Reduce(c, packages)
  if (is.null(cran_packages)) c() else cran_packages
}
