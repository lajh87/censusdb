con <- DBI::dbConnect(
  odbc::odbc(), driver = "PostgreSQL ODBC Driver(Unicode)", 
  database = "scotland_2001_oa", uid = "lheley", host = "localhost", pwd = "lheley", 
  port = 5432, maxvarcharsize = 0
)

d <- "data-raw/scotland_2001_oa"
f <- list.files(d)
files <- file.path(d, f)


meta <- purrr::map(f, ~{
  first_col <- readr::read_csv(file.path(d,.x), n_max =10, skip = 0, col_names = FALSE,
                               show_col_types = FALSE) |>
    dplyr::select(1) |>
    dplyr::pull()
  
  first_row <- which(stringr::str_detect(first_col, "^SCOTLAND|^60QA000001|^60QA000002|^Scotland|^Aberdeen"))[1]
  
  dplyr::tibble(value = first_col[1:(first_row-1)]) |>
    dplyr::mutate(tbl = tools::file_path_sans_ext(.x), .before = "value") |>
    dplyr::filter(!is.na(value)) |>
    dplyr::mutate(order = 1:dplyr::n())
  
}, .progress = TRUE) |>
  dplyr::bind_rows() 

meta |> dplyr::filter(order>3) |>
  View()


for(file in files){
  print(glue::glue("{match(file, files)} of {length(files)}"))
  tbl_nm <- tools::file_path_sans_ext((strsplit(file, "/") |> unlist())[2])
  file_in <- readLines(file, n = 10)
  n <- which(stringr::str_detect(file_in, "60QA000001"))[1]
  v <- readr::read_csv(.x, col_names = FALSE, skip = n-1)
  DBI::dbWriteTable(con, tbl_nm, v, overwrite = TRUE)
}
