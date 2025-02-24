library(geoarrow)
library(DBI)
library(duckdb)
library(dplyr)

con <- dbConnect(duckdb::duckdb(), "data/roads.duckdb")

dbListTables(con)

foo <- tbl(con, "road_table") |>
  dplyr::filter(stringr::str_detect(name, "Prince")) |> 
  dplyr::select(name, highway, geometry) |>
  dplyr::collect()
  

jhoo <- foo |> 
  tidyr::unnest(cols = geometry)

sf::st_as_sf(foo)
