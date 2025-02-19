library(DBI)
library(duckdb)

# Create a persistent DuckDB database file
con <- dbConnect(duckdb::duckdb(), "data/roads.duckdb")

# List all Parquet files in the folder
parquet_files <- list.files(
  path = "data/",
  pattern = "\\.parquet$",
  full.names = TRUE
)

dbExecute(con, sprintf("CREATE TABLE road_table AS SELECT * FROM parquet_scan('%s')", parquet_files[1]))


# Append remaining files (if any)
for (file in parquet_files[-1]) {
  dbExecute(con, sprintf("INSERT INTO road_table SELECT * FROM parquet_scan('%s')", file))
}


# Query the stored data
result <- dbGetQuery(con, "SELECT COUNT(*) FROM road_table")
print(result)

# Disconnect when done
dbDisconnect(con, shutdown = TRUE)
