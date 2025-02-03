library(geoarrow)
# library(osmextract)

# osm_lines <- oe_read(
#   "data/us-pacific-latest.gpkg"#,
#   # layer = "lines"
# )
# 
# osm_lines |> 
#   tibble::as_tibble() |> 
#   arrow::write_parquet("data/us-pacific-latest.parquet")

system.time({
  tbl <- arrow::open_dataset(
      c(
        "data/us-pacific-latest.parquet",
        "data/geofabrik_canada-latest.parquet",
        "data/us-midwest-latest.parquet",
        "data/us-northeast-latest.parquet",
        "data/us-west-latest.parquet",
        "data/us-south-latest.parquet"
      )
    ) |> 
      dplyr::filter(stringr::str_detect(name, "Prince")) |>
      dplyr::slice_sample(n = 50) |>
      sf::st_as_sf()
})




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
