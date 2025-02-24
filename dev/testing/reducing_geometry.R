library(geoarrow)
library(dplyr)
library(sf)

get_start_end_points <- function(linestring) {
  coords <- st_coordinates(linestring) # Extract coordinates
  start_point <- st_point(coords[1, ]) # First point
  end_point <- st_point(coords[nrow(coords), ]) # Last point
  return(st_sfc(start_point, end_point, crs = st_crs(linestring))) # Create an sfc object
}

up <- arrow::open_dataset("data/us-pacific.parquet") |> 
  sf::st_as_sf()


grouped_roads <- up |> filter(name == "Muldoon Road") |> 
  rowwise() |>
  mutate(geometry2 = list(get_start_end_points(geometry))) |>
  st_drop_geometry() |> 
  ungroup() |> 
  tidyr::unnest(geometry2)

arrow::open_dataset("https://github.com/shiny-meetings/road_names/blob/main/data/us-pacific.parquet")
