#' Query parquet file to get similar road names
#'
#' @param road Road name
#' @param region North American region
#'
#' @returns sf dataframe
#' @export
get_regional_road <- function(road, region){
  file_name <- switch(region,
    "US-Pacific" = "data/us-pacific.parquet",
    "US-Midwest" = "data/us-midwest.parquet",
    "US-Northeast" = "data/us-northeast.parquet",
    "US-West" = "data/us-west.parquet",
    "US-South" = "data/us-south.parquet",
    "Canada" = "data/geofabrik_canada.parquet"
  )
  new_data <- arrow::open_dataset(file_name) |>
    dplyr::filter(stringr::str_detect(name, road)) |>
    dplyr::select(name, highway, geometry) |>
    dplyr::slice_head(n = 20) |>
    sf::st_as_sf() |> 
    dplyr::group_by(name, highway) |>
    dplyr::mutate(group_id = dplyr::cur_group_id()) |> 
    dplyr::ungroup() 
  
  sampled_group_ids <- sample(unique(new_data$group_id), 5)

  new_data |> 
    dplyr::filter(group_id %in% sampled_group_ids) |> 
    dplyr::arrange(group_id)
}

#' Get road linestrings from Canada by providing a road name
#'
#' @param road 
#'
#' @returns sf dataframe
#' @export
get_roads <- function(road){
  
  road <- tolower(road)
  road <- trimws(gsub("\\b(highway|road|street|avenue)\\b\\s*", "", road, ignore.case = TRUE))
  road <- tools::toTitleCase(road)
  
  purrr::map_dfr(
    # c("US-Pacific", "US-Midwest", "US-Northeast", "US-West", "US-South", "Canada"),
    "Canada",
    ~ get_regional_road(road, .x)
  )
}


#' Get average coordinates
#'
#' @param rd_geometry Road geometry
#'
#' @returns Vector of average X,Y coords
#' @export
get_avg_coords <- function(rd_geometry){
  road_coords <- sf::st_coordinates(rd_geometry)
  c(
    road_coords[, "X"] |> mean(),
    road_coords[, "Y"] |> mean()
  )
}

# create_section <- function(section_name, coords, zoom, pitch, bearing){
#   mapgl::on_section("map", section_name, {
#     mapgl::mapboxgl_proxy("map") |> 
#       mapgl::fly_to(center = coords,
#              zoom = zoom,
#              pitch = pitch,
#              bearing = bearing)
#   })
# }
