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

scotland_gorlac_2001 <- sf::read_sf("Scotland_gorlac_2001/scotland_gorlac_2001.shp")
sf::st_write(scotland_gorlac_2001, db, "scotland_gorlac_2001")
DBI::dbDisconnect(db)
