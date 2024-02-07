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


df <- readr::read_csv("data-raw/WF01AUK_oa_v2/wf01auk_oa_v2.csv", col_names = FALSE)
names(df) <- c("area_of_usual_residence", "area_of_workplace", "persons")

df2 <- readr::read_csv("data-raw/ODWP01EW_OA_v1/ODWP01EW_OA.csv")
df2 <- df2 |> janitor::clean_names()


db <- connect_postgres()
DBI::dbWriteTable(db, "wf01auk_oa_v2", df, row.names = FALSE)
DBI::dbWriteTable(db, "ODWP01EW_OA", df2, row.names = FALSE)

DBI::dbDisconnect(db)
