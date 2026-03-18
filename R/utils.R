#' @importFrom httr2 request req_url_path_append req_auth_bearer_token
#' @importFrom httr2 req_user_agent req_method req_body_json req_url_query
#' @importFrom httr2 req_error req_perform resp_status resp_body_json
#' @importFrom tibble tibble as_tibble
#' @importFrom utils packageVersion
NULL

`%||%` <- function(x, y) if (!is.null(x) && length(x) > 0) x else y

#' @noRd
.ficharium_erro <- function(expr, contexto) {
  tryCatch(expr, error = function(e) stop(contexto, ": ", conditionMessage(e), call. = FALSE))
}

#' @noRd
ficharium_base_url <- function() {
  Sys.getenv("FICHARIUM_BASE_URL", unset = "https://api.ficharium.cloud")
}

#' @noRd
.ficharium_requisicao <- function(method, path, body = NULL, query = NULL) {
  req <- httr2::request(ficharium_base_url()) |>
    httr2::req_url_path_append(path) |>
    httr2::req_auth_bearer_token(ficharium_token()) |>
    httr2::req_user_agent(paste0("fichaR/", utils::packageVersion("fichaR"))) |>
    httr2::req_method(method)

  if (!is.null(body))  req <- httr2::req_body_json(req, body)
  if (!is.null(query)) {
    query <- query[!vapply(query, is.null, logical(1))]
    if (length(query) > 0) req <- do.call(httr2::req_url_query, c(list(req), query))
  }

  resp <- httr2::req_error(req, is_error = \(r) FALSE) |> httr2::req_perform()
  status <- httr2::resp_status(resp)

  if (status >= 400) {
    msg <- tryCatch(
      httr2::resp_body_json(resp)$message %||% paste("Erro HTTP", status),
      error = function(e) paste("Erro HTTP", status)
    )
    stop(msg, call. = FALSE)
  }

  httr2::resp_body_json(resp, simplifyVector = FALSE)
}

#' @noRd
.ficharium_tipo_para_r <- function(tipo) {
  switch(tipo,
    especie     = "list",
    inteiro     = "integer",
    decimal     = "numeric",
    data        = "Date",
    hora        = "hms",
    coordenada  = "list",
    porcentagem = "numeric",
    booleano    = "logical",
    select      = "character",
    texto       = "character",
    lista       = "list",
    ponto       = "list",
    duracao     = "numeric",
    semvalor    = NULL,
    "character"
  )
}

#' @noRd
.ficharium_converter_valor <- function(valor, tipo) {
  if (is.null(valor)) return(NULL)

  switch(tipo,
    especie = {
      if (is.list(valor)) {
        list(nc = valor$nc %||% NA_character_,
             np = valor$np %||% NA_character_,
             grupo = valor$grupo %||% NA_character_)
      } else {
        list(nc = as.character(valor), np = NA_character_, grupo = NA_character_)
      }
    },
    inteiro     = as.integer(valor),
    decimal     = as.numeric(valor),
    data        = as.Date(as.character(valor)),
    hora        = {
      v <- as.character(valor)
      partes <- strsplit(v, ":")[[1]]
      if (length(partes) >= 2) {
        h <- as.integer(partes[1])
        m <- as.integer(partes[2])
        s <- if (length(partes) >= 3) as.numeric(partes[3]) else 0
        hms::hms(seconds = s, minutes = m, hours = h)
      } else {
        hms::as_hms(NA)
      }
    },
    coordenada  = list(latitude  = valor$latitude  %||% NA_real_,
                       longitude = valor$longitude %||% NA_real_),
    porcentagem = as.numeric(valor),
    booleano    = as.logical(valor),
    select      = as.character(valor),
    texto       = as.character(valor),
    lista       = as.character(unlist(valor)),
    ponto       = list(nome      = valor$nome %||% NA_character_,
                       id        = valor$id   %||% NA_character_,
                       latitude  = valor$latitude  %||% NA_real_,
                       longitude = valor$longitude %||% NA_real_),
    duracao     = as.numeric(valor),
    semvalor    = NULL,
    as.character(valor)
  )
}
