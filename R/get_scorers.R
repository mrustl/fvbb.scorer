#' Get Teams
#'
#' @param game_html xml2::read_html(game_link_full)  imported html with game stats
#' @return table with team players
#' @export
#'
#' @examples
#' \dontrun{
#' games_u11 <- get_links_game()[7,]
#' completed_games_u11 <- urls_completed_games(games_u11$links_url)
#' if(length(completed_games_u11)>0) get_teams(xml2::read_html(completed_games_u11[1])) 
#' }

get_teams <- function(game_html) {
  
  game_master_wide <- get_game_master(game_html)
  
  
  team_names <- game_html %>% rvest::html_nodes("b")
  
  team_names <- stringr::str_remove_all(team_names[!is.na(team_names %>% 
                                                            rvest::html_attr("style"))] %>% 
                                          rvest::html_text(), 
                                        ":")
  
  players <- game_html %>% rvest::html_nodes("div") %>% rvest::html_attr("style") 
  team_idx <- grepl("^width", players)
  
  teams <- game_html %>% rvest::html_nodes("div") 
  teams <- teams[team_idx] %>% rvest::html_text()
  
  team_1 <- tibble::tibble(team = team_names[1], 
                           name = unlist(strsplit(teams[1],split = ", ")),
                           type = dplyr::if_else(grepl("\\[C\\]", .data$name), "captain", "player")) %>%  
    dplyr::mutate(name = stringr::str_remove_all(.data$name, "\\[C\\]") %>% stringr::str_trim())
  
  team_2 <- tibble::tibble(team = team_names[2], 
                           name = unlist(strsplit(teams[2],split = ", ")),
                           type = dplyr::if_else(grepl("\\[C\\]", .data$name), "captain", "player")) %>%  
    dplyr::mutate(name = stringr::str_remove_all(.data$name, "\\[C\\]") %>% stringr::str_trim())
  
  cbind(game_master_wide[,"Spielnummer", drop = FALSE], 
        dplyr::bind_rows(team_1, team_2)) %>% tibble::as.tibble()
  
}

#' Get Game Master Data
#'
#' @param game_html xml2::read_html(game_link_full)  imported html with game stats
#' @return table with game master data
#' @export
#' @examples
#' \dontrun{
#' games_u11 <- get_links_game()[7,]
#' completed_games_u11 <- urls_completed_games(games_u11$links_url)
#' if(length(completed_games_u11)>0) get_game_master(xml2::read_html(completed_games_u11[1]))
#' }
#'  
get_game_master <- function(game_html) {
  
  game_tables <- game_html %>% rvest::html_table()
  
  
  
  game_master <- game_tables[[1]]
  
  colnames(game_master) <- c("key", "value")
  
  game_master$key <- gsub(pattern = ":", "", game_master$key)
  game_master <- game_master[game_master$key != "", ]
  
  game_master_wide <- tidyr::spread(data = game_master, key = "key", value = "value")
  
  game_master_wide$Spielnummer <- as.numeric(game_master_wide$Spielnummer)
  game_master_wide$Zuschauerzahl <- as.numeric(game_master_wide$Zuschauerzahl)
  
  game_master_wide
}


#' Get Scorers
#'
#' @param game_html xml2::read_html(game_link_full)  imported html with game stats
#'
#' @return table with scorers
#' @export
#' @importFrom xml2 read_html
#' @importFrom rvest html_table html_nodes html_attr html_text
#' @importFrom tidyr spread
#' @importFrom stringr str_remove_all str_extract
#' @importFrom dplyr left_join
#' @importFrom kwb.utils resolve
#' @examples
#' \dontrun{
#' games_u11 <- get_links_game()[7,]
#' completed_games_u11 <- urls_completed_games(games_u11$links_url)
#' if(length(completed_games_u11)>0) get_scorers(xml2::read_html(completed_games_u11[1]))
#' }
get_scorers <- function(game_html) {
  
  game_master_wide <- get_game_master(game_html)
  
  game_tables <-   game_html %>% rvest::html_table()
  
  game_stats <- game_tables[[2]]
  
  names(game_stats) <- c("time", "event", "score", "scorer", "team")
  
  
  rows_to_keep <- !grepl("H\u00E4lfte|Verl\u00E4ngerung", game_stats$time)
  
  game_stats <- game_stats[rows_to_keep,]
  
  game_stats$scorer_goal <- stringr::str_remove_all(game_stats$scorer, "\\(.*\\)") %>%  
    stringr::str_trim() 
  game_stats$scorer_assistant <- stringr::str_extract(game_stats$scorer,pattern = "\\(.*\\)") %>% 
    stringr::str_remove_all(pattern = "\\(|\\)") %>% 
    stringr::str_trim()
  
  game_stats$Spielnummer <- game_master_wide$Spielnummer
  
  dplyr::left_join(game_master_wide, game_stats, by = "Spielnummer") 
}



#' Create Table Scorer
#'
#' @param url_games single url to game as retrieved by get_links_game()
#'
#' @return scorer table
#' @export
#' @importFrom dplyr filter mutate arrange count desc
#' @importFrom data.table rbindlist
#' @importFrom tidyr pivot_longer
#' @importFrom stringr str_remove_all
#' @importFrom stringi stri_trans_general
#' @importFrom rlang .data
#' @importFrom parallel detectCores makePSOCKcluster parLapply 
#' @examples
#' \dontrun{
#' games_u11 <- get_links_game()[7,]
#' create_table_scorers(url_games = games_u11$links_url)
#' }
create_table_scorers <- function(url_games) {

  
  completed_games <- urls_completed_games(url_games)
  
  if(length(completed_games)>0) {

    cores <- parallel::detectCores()
    cl <- parallel::makePSOCKcluster(cores)
    
    team_players <- data.table::rbindlist(parallel::parLapply(cl, 
                                                              completed_games, 
                                                              function(url) get_teams(xml2::read_html(url))))
    team_players_stats <- team_players %>%  
      dplyr::count(.data$team, .data$name)  %>% 
      dplyr::mutate(team = stringi::stri_trans_general(.data$team, "Latin-ASCII"), 
                    name = stringi::stri_trans_general(.data$name, "Latin-ASCII")) %>% 
      dplyr::rename(scorer_name = .data$name, games = .data$n)
    
    table_scorers <- data.table::rbindlist(parallel::parLapply(cl,
                                                               completed_games, 
                                                               function(x) get_scorers(xml2::read_html(x))))
    parallel::stopCluster(cl)
    
    table_scorer_long <- tidyr::pivot_longer(table_scorers, 
                                             names_to = "score_type", 
                                             values_to = "scorer_name", 
                                             cols = c( "scorer_goal", "scorer_assistant"))
    
    table_scorer_long_tidy <- table_scorer_long %>%  
      dplyr::mutate(score_type = stringr::str_remove_all(.data$score_type, pattern = "scorer_")) %>% 
      dplyr::filter(!is.na(.data$scorer_name)) 
    
    
    
    table_scorer_long_tidy %>% 
      dplyr::filter(.data$event == "Tor") %>% 
      dplyr::count(.data$team, .data$scorer_name, .data$score_type) %>% 
      tidyr::pivot_wider(names_from = "score_type", values_from = "n", values_fill = list(n = 0)) %>% 
      dplyr::mutate(scores = .data$goal + .data$assistant) %>% 
      dplyr::mutate(team = stringi::stri_trans_general(.data$team, "Latin-ASCII"), 
                    scorer_name = stringi::stri_trans_general(.data$scorer_name, "Latin-ASCII")) %>% 
      dplyr::right_join(team_players_stats, by = c("team", "scorer_name")) %>% 
      dplyr::rename(name = .data$scorer_name) %>% 
      dplyr::mutate(spg = round(.data$scores / .data$games, 2)) %>% 
      dplyr::select(.data$team, .data$name, .data$games, 
                    .data$assistant, .data$goal, .data$scores, 
                    .data$spg) %>%  
      dplyr::arrange(dplyr::desc(.data$scores)) 
    
  } else {
    stop("No games completed yet") }
}

