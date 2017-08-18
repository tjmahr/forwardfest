
# https://forecast-v3.weather.gov/documentation

tempfile <- tempfile()
curl::curl_download("https://api.weather.gov//alerts/active", tempfile)
active <- jsonlite::read_json(tempfile)

tempfile <- tempfile()
curl::curl_download("https://api.weather.gov//stations?states=WI", tempfile)
wi <- jsonlite::read_json(tempfile)

library(ggplot2)
library(purrr)
map <- purrr::map

active %>% map("id")
str(active, max.level = 1)
str(active$features, max.level = 1)

active$features[[1]] %>% str

id <- active$features %>% map_chr(pluck, "properties", "id")

active$features %>% map_chr(pluck, "properties", "instruction")

sevs <- active$features %>% map_chr(pluck, "properties", "severity")

feature <- active$features[[1]]
str(feature)

get_geometry <- function(feature) {
  id <- feature %>% pluck("properties", "id")
  sev <- feature %>% pluck("properties", "severity")
  geo <- feature %>%
    pluck("geometry", "coordinates", 1) %>%
    map_df(~ data.frame(x = .[[1]], y = .[[2]])) %>%
    tibble::add_column(id = id, sev = sev, .before = 1)
  geo
}

geos <- map_df(active$features, get_geometry) %>%
  dplyr::filter(dplyr::between(y, 25, 50))



usa <- map_data("usa") # we already did this, but we can do it again
ggplot() + geom_polygon(data = usa, aes(x=long, y = lat, group = group)) +
  coord_fixed(1.3)

ggplot() + geom_polygon(data = usa, aes(x=long, y = lat, group = group),
                        color = "blue", fill = NA) +
  coord_fixed(1.3) +
  geom_polygon(aes(x=x, y=y, group = id), data = geos)

station <- pluck(wi, 3, 1)
str(station)

get_geometry2 <- function(station) {
    id <- station %>% pluck("id")
    geo <- station %>%
      pluck("geometry", "coordinates")

    data.frame(x = geo[[1]], y = geo[[2]]) %>%
      tibble::add_column(id = id, .before = 1)
  }

stations <- map_df(pluck(wi, 3), get_geometry2)

ggplot() + geom_polygon(data = usa, aes(x=long, y = lat, group = group),
                        color = "blue", fill = NA) +
  # coord_fixed(1.3) +
  geom_point(aes(x=x, y=y, group = id), data = stations) +
  coord_map("azequalarea", orientation = c(90, 0, -100))


