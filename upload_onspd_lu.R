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

onspd <- readr::read_csv("data-raw/ONSPD_NOV_2023_UK.csv")
DBI::dbWriteTable(db, "onspd_nov_23_uk", onspd, row.names = FALSE)
DBI::dbDisconnect(db)


