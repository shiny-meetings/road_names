library(geoarrow)

all_roads <- arrow::open_dataset("data/geofabrik_canada.parquet") |>
  dplyr::pull(name, as_vector = TRUE) |> 
  unique()

a_to_f_roads <- all_roads[substr(all_roads, 1, 1) >= "A" & substr(all_roads, 1, 1) <= "F"]

arrow::open_dataset("data/geofabrik_canada.parquet") |>
  dplyr::filter(name %in% a_to_f_roads) |> 
  arrow::write_parquet("data/canada.parquet")
