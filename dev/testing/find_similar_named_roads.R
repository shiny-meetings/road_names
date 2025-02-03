library(duckplyr)

system.time({
  foo <- duckdbfs::open_dataset(here::here("data/geofabrik_canada-latest.gpkg")) |> 
    select(name, highway, geometry) 
})

# user  system elapsed 
# 1.11    0.21    0.88 

road_name <- "Ontario"
num_of_rows <- 5

system.time({
  foo2 <- foo |>  
    filter(stringr::str_detect(name, road_name)) |> 
    slice_sample(n = num_of_rows)
})
# user  system elapsed 
# 0.01    0.00    0.01 

foo2 |> 
  select(name, highway)

system.time({
  fooz <- foo2 |> 
    duckdbfs::to_sf()
})
# user  system elapsed 
# 12.83    9.34    7.50 

# library(ggplot2)
# ggplot(fooz) +
#   geom_sf()

library(leaflet)
leaflet(fooz) %>%
  # Add OpenStreetMap as base layer
  addTiles() %>%
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
