connect_postgres <- function(
    db = "census", 
    host = "localhost", 
    port = 5432,
    user = "postgres", 
    password = Sys.getenv("postgre_pw")
){
  DBI::dbConnect(
    RPostgres::Postgres(),
    host   = host,
    db = db,
    user = user,
    password = password,
    port = port
  )
}

db <- connect_postgres()

# 2011 (UK)
df <- sf::read_sf("data-raw/infuse_oa_lyr_2011/infuse_oa_lyr_2011.shp")
DBI::dbWriteTable(db, "infuse_oa_lyr_2011", df)

df <- sf::read_sf("data-raw/infuse_lsoa_lyr_2011/infuse_lsoa_lyr_2011.shp")
DBI::dbWriteTable(db, "infuse_lsoa_lyr_2011", df)

## EW
df <- sf::read_sf("data-raw/infuse_msoa_lyr_2011/infuse_msoa_lyr_2011.shp")
DBI::dbWriteTable(db, "infuse_msoa_lyr_2011", df)

# 2021 (Eng/Wales)
df <- sf::read_sf("data-raw/EW_oa_2021/ew_oa_2021.shp")
DBI::dbWriteTable(db, "ew_oa_2021", df)

df <- sf::read_sf("data-raw/EW_lsoa_2021/ew_lsoa_2021.shp")
DBI::dbWriteTable(db, "ew_lsoa_2021", df)

df <- sf::read_sf("data-raw/EW_msoa_2021/ew_msoa_2021.shp")
DBI::dbWriteTable(db, "ew_msoa_2021", df)

DBI::dbDisconnect(db)
