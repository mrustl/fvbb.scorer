
#' URLs of completed games
#'
#' @param url_games url with games for one group
#'
#' @return vector with urls of completed games
#' @export
#'
#' @examples
#' games_u11 <- get_links_game()[7,]
#' urls_completed_games(games_u11$links_url)
urls_completed_games <- function(url_games) {
  
  game_results_links <- xml2::read_html(url_games) %>% 
  rvest::html_nodes("td.center a")

is_over <- rvest::html_text(game_results_links) != ""

game_links <- game_results_links[is_over] %>%  rvest::html_attr("href") 
game_links_full <- sprintf("%s%s", default_saisonmanager_url(), game_links)

game_links_full
}
