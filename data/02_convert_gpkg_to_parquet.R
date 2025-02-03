library(geoarrow)
library(osmextract)

all_files <- list.files(
  path = "data/",
  pattern = "\\.gpkg$"
)

all_files <- sapply(all_files, 
       function(x){sub("\\.gpkg$", "", x)}, 
       USE.NAMES = FALSE)

  

convert_to_parquet <- function(filename){
  foo <- oe_read(paste0("data/", filename, ".gpkg")) |>
    tibble::as_tibble() 
  
  foo |> 
    arrow::write_parquet(paste0("data/", filename, ".parquet"))
  
  rm(foo)
}

lapply(
  all_files[2:6],
  convert_to_parquet
)
