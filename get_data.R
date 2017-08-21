# devtools::install_github("rmhogervorst/imdb")

library(imdb)
imdb::imdbSeries("Game of Thrones")
//*[@id="tn15content"]/table[1]

library(rvest)
ep <- xml2::read_html("http://www.imdb.com/title/tt4283054/ratings")


get_review_data <- function(url) {
  review_html <- xml2::read_html(url)
  series <- review_html %>%
    rvest::html_node(xpath = '//*[@id="tn15title"]/h1/a') %>%
    rvest::html_text() %>%
    stringr::str_replace_all("\"", "")

  ep_title <- review_html %>%
    rvest::html_node(xpath = '//*[@id="tn15title"]/h1/span[1]/a') %>%
    rvest::html_text()

  review_html %>%
    rvest::html_table(header = TRUE, fill = TRUE) %>%
    purrr::pluck(1) %>%
    tibble::add_column(Series = series, Episode = ep_title,
                       # Average = weighted,
                       .before = 0) %>%
    tibble::as_tibble()
}

get_review_data(ep)
rating_html <- xml2::read_html("http://www.imdb.com/title/tt0944947/eprate")

get_scores <- function(url) {
  rating_html <- xml2::read_html(url)
  ratings <- rating_html %>%
    rvest::html_table(header = TRUE, fill = TRUE) %>%
    purrr::pluck(1) %>%
    dplyr::rename(SeasonEp = `#`) %>%
    tidyr::separate(`SeasonEp`, c("Season", "EpisodeNum"), remove = FALSE) %>%
    dplyr::select(SeasonEp:UserVotes) %>%
    tibble::as_tibble()

  html_nodes(rating_html, css = "#tn15content > table > tbody > tr > td > a") %>% html_text()
  html_nodes(rating_html, css = "#tn15content > table > tbody > tr > td > a")
  html_nodes(rating_html, css = "#tn15content > table > tbody > tr > td > a")



  to_do <- rating_html %>%
    html_nodes(css = "#tn15content > table:first-of-type > tr > td > a") %>%
    html_attr("href") %>%
    paste0("http://www.imdb.com", ., "ratings")

  test <- purrr::map(to_do, get_review_data)
  test <- get_review_data(to_do[1])
  to_do[1]
}
