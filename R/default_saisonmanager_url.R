#' Default URL for FVBB Saisonmanager
#'
#' @return url to FVBB saionsmanager (default: "https://fvbb.saisonmanager.de")
#' @export
#'
#' @examples
#' default_saisonmanager_url()
default_saisonmanager_url <- function() {
  
  "https://fvbb.saisonmanager.de"
  
}

saisonmanager_urls <- function() {
  
  list("2021" = "https://fvbb.saisonmanager.de",
       "2020" = "https://fvbb.archiv1920.saisonmanager.de",
       "2019" = "https://fvbb.archiv1819.saisonmanager.de",
       "2018" = "https://fvbb.archiv1718.saisonmanager.de",
       "2017" = "https://fvbb.archiv1617.saisonmanager.de",
       "2016" = "https://fvbb.archiv1516.saisonmanager.de",
       "2015" = "https://fvbb.archiv1415.saisonmanager.de")
  
}
