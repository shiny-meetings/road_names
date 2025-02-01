library(osmextract)
library(sf)
library(geoarrow)

# Read OSM data
osm_lines <- oe_read(here::here("data/geofabrik_canada-latest.osm.pbf"), 
                    layer = "lines")

geoarrow::write_geoparquet(osm_lines, here::here("data/canada_lines.parquet"))
