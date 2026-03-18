#' Listar projetos do usuario
#'
#' @title Listar projetos do usuario
#' @description Retorna todos os projetos aos quais o usuario autenticado tem acesso.
#' @return tibble com colunas \code{id}, \code{nome}, \code{descricao}, \code{fichas_na_nuvem}, \code{cargo}
#' @examples
#' \dontrun{
#' ficharium_login("email@exemplo.com")
#' listar_projetos()
#' }
#' @export
listar_projetos <- function() {
  res <- .ficharium_erro(
    .ficharium_requisicao("GET", "projetos"),
    "Erro ao listar projetos"
  )

  tibble::tibble(
    id             = vapply(res, \(x) x$id      %||% NA_character_, character(1)),
    nome           = vapply(res, \(x) x$nome    %||% NA_character_, character(1)),
    descricao      = vapply(res, \(x) x$descricao %||% NA_character_, character(1)),
    fichas_na_nuvem = vapply(res, \(x) {
      v <- x$fichas_na_nuvem
      if (is.null(v)) NA_integer_ else as.integer(v)
    }, integer(1)),
    cargo          = vapply(res, \(x) x$cargo   %||% NA_character_, character(1))
  )
}

#' Obter um projeto especifico
#'
#' @title Obter um projeto especifico
#' @description Retorna os detalhes completos de um projeto pelo seu ID.
#' @param id string com o ID do projeto
#' @return lista R com os campos do projeto
#' @examples
#' \dontrun{
#' projeto("abc123")
#' }
#' @export
projeto <- function(id) {
  .ficharium_erro(
    .ficharium_requisicao("GET", paste0("projetos/", id)),
    paste0("Projeto '", id, "' nao encontrado")
  )
}

#' Listar modelos de um projeto
#'
#' @title Listar modelos de um projeto
#' @description Retorna os modelos associados a um projeto especifico.
#' @param projeto_id string com o ID do projeto
#' @return tibble com colunas \code{id}, \code{nome}, \code{descricao}, \code{grupo}
#' @examples
#' \dontrun{
#' modelos_projeto("proj123")
#' }
#' @export
modelos_projeto <- function(projeto_id) {
  res <- .ficharium_erro(
    .ficharium_requisicao("GET", paste0("projetos/", projeto_id)),
    paste0("Projeto '", projeto_id, "' nao encontrado")
  )
  modelos <- res$modelos_usuario_do_projeto %||% list()

  tibble::tibble(
    id        = vapply(modelos, \(x) x$id        %||% NA_character_, character(1)),
    nome      = vapply(modelos, \(x) x$nome      %||% NA_character_, character(1)),
    descricao = vapply(modelos, \(x) x$descricao %||% NA_character_, character(1)),
    grupo     = vapply(modelos, \(x) x$grupo     %||% NA_character_, character(1))
  )
}

#' Listar fichas de um projeto
#'
#' @title Listar fichas de um projeto
#' @description Retorna todas as fichas de um projeto com metadados basicos.
#'   Nao inclui os \code{dados} de cada observacao — use \code{listar_fichas()} para isso.
#' @param projeto_id string com o ID do projeto
#' @return tibble com colunas \code{id}, \code{modelo_id}, \code{modelo_nome},
#'   \code{criador_nome}, \code{created}, \code{updated}
#' @examples
#' \dontrun{
#' fichas_projeto("proj123")
#' }
#' @export
fichas_projeto <- function(projeto_id) {
  res <- .ficharium_erro(
    .ficharium_requisicao("GET", paste0("fichas/", projeto_id)),
    paste0("Erro ao listar fichas do projeto '", projeto_id, "'")
  )

  tibble::tibble(
    id           = vapply(res, \(x) x$id                              %||% NA_character_, character(1)),
    modelo_id    = vapply(res, \(x) x$modelo$id                       %||% NA_character_, character(1)),
    modelo_nome  = vapply(res, \(x) x$modelo$nome                     %||% (x$modelo_bs %||% NA_character_), character(1)),
    criador_nome = vapply(res, \(x) x$criador$nome                    %||% NA_character_, character(1)),
    created      = vapply(res, \(x) x$created                         %||% NA_character_, character(1)),
    updated      = vapply(res, \(x) x$updated                         %||% NA_character_, character(1))
  )
}
