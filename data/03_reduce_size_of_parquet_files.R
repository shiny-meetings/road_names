library(geoarrow)
library(dplyr)

all_pq_files <- list.files(
  path = "data/",
  pattern = "\\.parquet$",
  full.names = TRUE
)

save_smaller_sized_files <- function(file_path){
  new_file_path <- gsub("-latest", "", file_path)
  
  arrow::open_dataset(file_path) |>  
    filter(!is.na(name), !is.na(highway)) |> 
    select(name, highway, other_tags, geometry) |> 
    arrow::write_parquet(new_file_path,
                         compression = "gzip")
}


lapply(
  all_pq_files,
  \(x) save_smaller_sized_files(x)
)




