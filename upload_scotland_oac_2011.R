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

scot <- sf::read_sf("data-raw/scotland_oac_2011/scotland_oac_2011.shp")
sf::st_write(scot, db, "scotland_oac_2011")
DBI::dbDisconnect(db)
