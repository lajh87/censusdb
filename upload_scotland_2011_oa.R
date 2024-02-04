d <- "data-raw/scotland_2011_oa_std/"
f <- list.files(d)

meta <- purrr::imap(f, ~{
  nm <- tools::file_path_sans_ext(.x)
  readr::read_csv(file.path(d, .x), col_names = FALSE, n_max = 3, show_col_types = FALSE) |>
    dplyr::rename(value = X1) |>
    dplyr::mutate(tbl = nm, .before = "value") |>
    dplyr::mutate(order = 1:dplyr::n())
}) |>
  dplyr::bind_rows() 
meta <- meta |> dplyr::select(tbl, value, order)
variables <- purrr::imap(f, ~{
  nm <- tools::file_path_sans_ext(.x)
  readr::read_csv(file.path(d, .x), col_names = FALSE, n_max = 1, show_col_types = FALSE, skip = 4) |>
    t() |>
    dplyr::as_tibble(.name_repair = "minimal") |>
    rlang::set_names("variable") |>
    dplyr::filter(!is.na(variable)) |>
    dplyr::mutate(order = 1:dplyr::n()) |>
    dplyr::mutate(tbl = nm, .before = variable)
}) |>
  dplyr::bind_rows() 


connect_postgres <- function(
    db = "scotland_2011_oa_std", 
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

DBI::dbWriteTable(db, "lu_meta", meta, row.names = FALSE, overwrite = TRUE)
DBI::dbWriteTable(db, "lu_variables", variables, row.names = FALSE, overwrite = TRUE)

purrr::map(f, ~{
  nm <- tools::file_path_sans_ext(.x)
  df <- readr::read_csv(file.path(d, .x), col_names = FALSE, skip = 5, show_col_types = FALSE) 
  DBI::dbWriteTable(db, nm, df, row.names = FALSE, overwrite =TRUE)
}, .progress = TRUE) 
