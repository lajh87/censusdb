con <- DBI::dbConnect(
  odbc::odbc(), driver = "PostgreSQL ODBC Driver(Unicode)", 
  database = "census", uid = "lheley", host = "localhost", pwd = "lheley", 
  port = 5432, maxvarcharsize = 0
)

d <- "scotland_2001_oa"
f <- list.files(d)
files <- file.path(d, f)

for(file in files){
  print(glue::glue("{match(file, files)} of {length(files)}"))
  tbl_nm <- tools::file_path_sans_ext((strsplit(file, "/") |> unlist())[2])
  file_in <- readLines(file, n = 10)
  n <- which(stringr::str_detect(file_in, "60QA000001"))[1]
  v <- readr::read_csv(.x, col_names = FALSE, skip = n-1)
  DBI::dbWriteTable(con, tbl_nm, v, overwrite = TRUE)
}
