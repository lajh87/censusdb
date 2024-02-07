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

# 2011
df <- readr::read_csv("data-raw/WF01AUK_oa_v2/wf01auk_oa_v2.csv", col_names = FALSE)
names(df) <- c("area_of_usual_residence", "area_of_workplace", "persons")
DBI::dbWriteTable(db, "wf01auk_oa_v2", df, row.names = FALSE)

df <- readr::read_csv("data-raw/WF03UK_oa_v1/wf03uk_oa_v1.csv", col_names = FALSE)
names(df) <- c("area_of_usual_residence", "area_of_workplace", "persons")
DBI::dbWriteTable(db, "WF03UK_oa_v1", df, row.names = FALSE)

# 2021
df2 <- readr::read_csv("data-raw/ODWP01EW_OA_v1/ODWP01EW_OA.csv")
df2 <- df2 |> janitor::clean_names()
DBI::dbWriteTable(db, "ODWP01EW_OA", df2, row.names = FALSE)



DBI::dbDisconnect(db)
