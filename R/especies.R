#' Listar especies registradas em um projeto
#'
#' @title Listar especies registradas em um projeto
#' @description Retorna a lista consolidada de especies registradas nas fichas de um projeto.
#'   O filtro por \code{busca} e aplicado localmente em R.
#' @param projeto_id string com o ID do projeto
#' @param busca string opcional para filtrar pelo nome cientifico (busca parcial, case-insensitive)
#' @return tibble com colunas \code{nc}, \code{grupo}, \code{total_registros}, \code{metodologias}
#' @examples
#' \dontrun{
#' listar_especies("proj123")
#' listar_especies("proj123", busca = "Leopardus")
#' }

#' @export
listar_especies <- function(projeto_id, busca = NULL) {
  res <- .ficharium_erro(
    .ficharium_requisicao("GET", paste0("fichas/", projeto_id, "/especies")),
    paste0("Erro ao listar especies do projeto '", projeto_id, "'")
  )

  df <- tibble::tibble(
    nc               = vapply(res, \(x) x$especie          %||% NA_character_, character(1)),
    grupo            = vapply(res, \(x) x$grupo            %||% NA_character_, character(1)),
    total_registros  = vapply(res, \(x) {
      v <- x$total_registros
      if (is.null(v)) NA_integer_ else as.integer(v)
    }, integer(1)),
    metodologias     = I(lapply(res, \(x) as.character(unlist(x$metodologias %||% list()))))
  )

  if (!is.null(busca) && nchar(busca) > 0) {
    df <- df[grepl(busca, df$nc, ignore.case = TRUE), ]
  }

  df
}
