library(rvest)

get_overall_ratings <- function(url) {
  rating_html <- xml2::read_html(url)
  get_overall_ratings_html(rating_html)
}

get_overall_ratings_html <- function(rating_html) {
  title <- rating_html %>%
    rvest::html_node(xpath = "/html/head/title") %>%
    rvest::html_text() %>%
    stringr::str_replace_all("\"", "") %>%
    stringr::str_replace_all(" [(]\\d+[)]$", "")

  ratings <- rating_html %>%
    rvest::html_table(header = FALSE, fill = TRUE) %>%
    purrr::pluck(1)

  ratings <- ratings[-1, ] %>%
    setNames(unlist(ratings[1, ])) %>%
    tidyr::separate(`#`, c("Season", "EpisodeNum")) %>%
    dplyr::select(-6)

  # convert c(10, 1, 3, 2) => c("10", "01", "03", "02")
  pad <- function(xs) {
    pattern <- paste0("%0", max(nchar(xs)), ".f")
    sprintf(pattern, as.numeric(xs))
  }

  ratings <- ratings %>%
    dplyr::mutate(
      Season = pad(Season),
      EpisodeNum = pad(EpisodeNum),
      SeasonEp = paste0(Season, "_", EpisodeNum)) %>%
    tibble::as_tibble()

  ratings <- ratings %>%
    arrange(SeasonEp) %>%
    group_by(Season) %>%
    mutate(SubEp = seq_along(Episode)) %>%
    ungroup() %>%
    mutate(TotalEp = seq_along(SeasonEp),
           UserVotes = readr::parse_guess(UserVotes),
           UserRating = as.numeric(UserRating)) %>%
    tibble::add_column(Series = title, .before = 0) %>%
    dplyr::select(Series, Episode, SeasonEp, Season, EpisodeNum,
                  SubEp, TotalEp, UserRating, UserVotes)

  ratings
}



# url <- "http://www.imdb.com/title/tt0944947/eprate"
# data <- get_overall_ratings(url)
# readr::write_csv(data, "got_avgs.csv")
# # readr::write_csv(data$episode_details, "got_eps.csv")
#
# # Parks and Rec
# url <- "http://www.imdb.com/title/tt1266020/eprate"
# data <- get_overall_ratings(url)
# readr::write_csv(data, "pnr_avgs.csv")
#
# # Simpsons
# url <- "http://www.imdb.com/title/tt0096697/eprate"
# data <- get_overall_ratings(url)
# readr::write_csv(data, "simp_avgs.csv")
