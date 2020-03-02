#' Get Links 
#'
#' @param url_saisonmanager base url to FVBB saisonmanager (default: default_saisonmanager_url())
#' @param select which type of info ("spielplan", "table, "scorer") to select (default: *, i.e. 
#' everything)
#' @return tibble with links to spielplaene, tables and scorers
#' @export
#' @importFrom xml2 read_html
#' @importFrom tibble tibble
#' @importFrom dplyr filter mutate 
#' @importFrom stringr str_extract_all str_remove_all str_trim
#' @importFrom rvest html_text html_attr
#' @importFrom rlang .data
#' @examples
#' \dontrun{
#' get_links(url_saisonmanager = "https://fvbb.saisonmanager.de")
#' }
get_links <- function(url_saisonmanager = default_saisonmanager_url(), 
                      select = "*") {
  
links <- xml2::read_html(url_saisonmanager) %>%  rvest::html_nodes("a") 


tibble::tibble(links_text = links %>% rvest::html_text() %>%  stringr::str_remove_all("\\n\\s+"),
               links_url = links %>%  rvest::html_attr("href")) %>% 
  dplyr::filter(!grepl("^index.php$|*.subMenu|impressum", .data$links_url)) %>% 
  dplyr::mutate(type = stringr::str_extract_all(.data$links_url, "\\?seite=.*&") %>%  
                  stringr::str_remove_all("\\?seite=|&") %>%  
                  stringr::str_trim(),
                links_url = sprintf("%s/%s", url_saisonmanager, .data$links_url)) %>% 
  
  dplyr::filter(grepl(select, .data$type))
}

#' Get Links To Games
#' @param url_saisonmanager base url to FVBB saisonmanager (default: default_saisonmanager_url())
#' @return tibble with links to games
#' @export
#'
#' @examples
#' \dontrun{
#' get_links_game()
#' }
get_links_game <- function(url_saisonmanager = default_saisonmanager_url()) {
  
  get_links(url_saisonmanager, select = "spielplan")
}

#' Get Links To Tables
#' @param url_saisonmanager base url to FVBB saisonmanager (default: default_saisonmanager_url())
#' @return tibble with links to tables
#' @export
#'
#' @examples
#' \dontrun{
#' get_links_table()
#' }
get_links_table <- function(url_saisonmanager = default_saisonmanager_url()) {
  
  get_links(url_saisonmanager, select = "table")
}

#' Get Links To Scorers
#' @param url_saisonmanager base url to FVBB saisonmanager (default: default_saisonmanager_url())
#' @return tibble with links to scorers
#' @export
#'
#' @examples
#' \dontrun{
#' get_links_scorer()
#' }
get_links_scorer <- function(url_saisonmanager = default_saisonmanager_url()) {
  
  get_links(url_saisonmanager, select = "scorer")
}