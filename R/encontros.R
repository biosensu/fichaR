#' Listar encontros ocasionais de um projeto
#'
#' @title Listar encontros ocasionais de um projeto
#' @description Retorna os encontros ocasionais de um projeto. Encontros
#'   ocasionais sao registros avulsos (fora de uma ficha), agrupados por grupo
#'   taxonomico, cada um com especie e local.
#' @param projeto_id string com o ID do projeto
#' @return tibble com colunas \code{id}, \code{grupo}, \code{especie_nc},
#'   \code{latitude}, \code{longitude}, \code{local_nome}, \code{n},
#'   \code{criador_nome}, \code{created}.
#' @examples
#' \dontrun{
#' encontros <- encontros_ocasionais("proj123")
#' }
#' @export
encontros_ocasionais <- function(projeto_id) {
  res <- .ficharium_erro(
    .ficharium_requisicao("GET", paste0("encontros_ocasionais/listar/", projeto_id)),
    paste0("Erro ao listar encontros ocasionais do projeto '", projeto_id, "'")
  )

  colunas <- c("id", "grupo", "especie_nc", "latitude", "longitude",
               "local_nome", "n", "criador_nome", "created")

  if (length(res) == 0) {
    vazio <- stats::setNames(
      lapply(colunas, function(col) if (col %in% c("latitude", "longitude", "n")) numeric(0) else character(0)),
      colunas
    )
    return(tibble::as_tibble(vazio))
  }

  .dados <- function(x) x$dados %||% list()
  .local <- function(x) .dados(x)$local %||% list()

  tibble::tibble(
    id           = vapply(res, function(x) x$id %||% NA_character_, character(1)),
    grupo        = vapply(res, function(x) x$grupo %||% NA_character_, character(1)),
    especie_nc   = vapply(res, function(x) (.dados(x)$especie$nc) %||% NA_character_, character(1)),
    latitude     = vapply(res, function(x) as.numeric(.local(x)$latitude %||% NA_real_), numeric(1)),
    longitude    = vapply(res, function(x) as.numeric(.local(x)$longitude %||% NA_real_), numeric(1)),
    local_nome   = vapply(res, function(x) .local(x)$nome %||% NA_character_, character(1)),
    n            = vapply(res, function(x) as.numeric(.dados(x)$n %||% NA_real_), numeric(1)),
    criador_nome = vapply(res, function(x) {
      cr <- x$criador
      if (is.list(cr)) cr$nome %||% NA_character_ else NA_character_
    }, character(1)),
    created      = vapply(res, function(x) x$created %||% NA_character_, character(1))
  )
}
