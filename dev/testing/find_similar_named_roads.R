library(geoarrow)

system.time({
  tbl <- arrow::open_dataset(
    c(
      "data/us-pacific.parquet",
      "data/geofabrik_canada.parquet",
      "data/us-midwest.parquet",
      "data/us-northeast.parquet",
      "data/us-west.parquet",
      "data/us-south.parquet"
    )
  ) |>
    dplyr::filter(stringr::str_detect(name, "Muldoon Road")) |>
    dplyr::slice_sample(n = 50) |>
    # dplyr::slice_head(n = 50) |>
    sf::st_as_sf()
})


# get_regional_road <- function(road, region){
#   file_name <- switch(region,
#     "US-Pacific" = "data/us-pacific.parquet",
#     "US-Midwest" = "data/us-midwest.parquet",
#     "US-Northeast" = "data/us-northeast.parquet",
#     "US-West" = "data/us-west.parquet",
#     "US-South" = "data/us-south.parquet",
#     "Canada" = "data/geofabrik_canada.parquet"
#   )
#   arrow::open_dataset(file_name) |> 
#     dplyr::filter(stringr::str_detect(name, road)) |>
#     dplyr::slice_sample(n = 2) |>
#     dplyr::select(name, highway, other_tags, geometry) |> 
#     sf::st_as_sf()
# }
# 
# get_six_roads <- function(road){
#   purrr::map_dfr(
#     c("US-Pacific", "US-Midwest", "US-Northeast", "US-West", "US-South", "Canada"),
#     ~ get_regional_road(road, .x)
#   )
# }
# 
# 
# get_six_roads("Prince")


library(leaflet)
leaflet(tbl) |> 
  # Add OpenStreetMap as base layer
  addTiles() |> 
  # Add the roads as lines
  addPolylines(
    color = "blue",          # line color
    weight = 2,             # line width
    opacity = 1,            # line opacity
    popup = ~name          # show road name on click
  ) %>%
  # Add labels that appear on hover
  addPolylines(
    label = ~name,
    labelOptions = labelOptions(
      noHide = FALSE,
      direction = "auto",
      style = list(
        "font-weight" = "normal",
        padding = "3px 8px"
      )
    )
  )
