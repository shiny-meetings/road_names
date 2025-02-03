library(osmextract)

get_linestring_file <- function(file_string){
  oe_read(here::here(paste0("data/", file_string)), 
                      layer = "lines")
  print(paste0(file_string, " DONE"))
}

get_linestring_file("geofabrik_canada-latest.osm.pbf")
get_linestring_file("us-west-latest.osm.pbf")

purrr::walk(
  c(
    "us-midwest-latest.osm.pbf",
    "us-northeast-latest.osm.pbf",
    "us-pacific-latest.osm.pbf",
    "us-south-latest.osm.pbf"
  ),
  get_linestring_file
)
