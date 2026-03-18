#' Listar fichas de um modelo em um projeto
#'
#' @title Listar fichas de um modelo em um projeto
#' @description Retorna todas as fichas de um modelo especifico dentro de um projeto,
#'   com os dados de cada observacao expandidos em linhas individuais.
#'   Campos complexos (especie, coordenada, ponto, lista) sao retornados como list-columns.
#' @param projeto_id string com o ID do projeto
#' @param modelo_id string com o ID do modelo
#' @return tibble onde cada linha e uma observacao (item de \code{dados}),
#'   com colunas de metadados da ficha mais os campos do modelo.
#' @examples
#' \dontrun{
#' fichas <- listar_fichas("proj123", "modelo456")
#' }
#' @export
listar_fichas <- function(projeto_id, modelo_id) {
  res <- .ficharium_erro(
    .ficharium_requisicao("GET", paste0("fichas/projeto/", projeto_id, "/modelo/", modelo_id)),
    paste0("Erro ao listar fichas do modelo '", modelo_id, "' no projeto '", projeto_id, "'")
  )

  if (length(res) == 0) {
    return(tibble::tibble(ficha_id = character(0), id_app = character(0),
                          created = character(0), updated = character(0)))
  }

  campos <- campos_modelo(modelo_id)

  # mapa field_id -> list(tipo, label)
  mapa <- stats::setNames(
    lapply(seq_len(nrow(campos)), function(i) list(tipo = campos$tipo[i], label = campos$label[i])),
    campos$field_id
  )

  linhas <- list()

  for (ficha in res) {
    ficha_id  <- ficha$id      %||% NA_character_
    id_app    <- ficha$id_app  %||% NA_character_
    created   <- ficha$created %||% NA_character_
    updated   <- ficha$updated %||% NA_character_

    # Converte bloco de metadados (objeto chaveado por field_id) em lista nomeada por label
    .converter_bloco <- function(bloco) {
      if (is.null(bloco) || length(bloco) == 0) return(list())
      out <- list()
      for (fid in names(bloco)) {
        info <- mapa[[fid]]
        if (is.null(info)) next
        tipo  <- info$tipo
        label <- info$label
        if (identical(tipo, "semvalor")) next
        out[[label]] <- .ficharium_converter_valor(bloco[[fid]], tipo)
      }
      out
    }

    meta_ini <- .converter_bloco(ficha$metadados_iniciais)
    meta_fin <- .converter_bloco(ficha$metadados_finais)

    dados <- ficha$dados
    if (is.null(dados) || length(dados) == 0) dados <- list(list())

    for (obs in dados) {
      obs_conv <- list()
      for (fid in names(obs)) {
        info <- mapa[[fid]]
        if (is.null(info)) next
        tipo  <- info$tipo
        label <- info$label
        if (identical(tipo, "semvalor")) next
        obs_conv[[label]] <- .ficharium_converter_valor(obs[[fid]], tipo)
      }

      linha <- c(
        list(ficha_id = ficha_id, id_app = id_app, created = created, updated = updated),
        meta_ini,
        obs_conv,
        meta_fin
      )
      linhas <- c(linhas, list(linha))
    }
  }

  if (length(linhas) == 0) {
    return(tibble::tibble(ficha_id = character(0), id_app = character(0),
                          created = character(0), updated = character(0)))
  }

  # Unir todas as colunas presentes
  todas_colunas <- unique(unlist(lapply(linhas, names)))

  colunas <- lapply(todas_colunas, function(col) {
    valores <- lapply(linhas, function(l) l[[col]] %||% NA)
    # list-column se qualquer valor for lista ou vetor com mais de 1 elemento
    if (any(vapply(valores, function(v) is.list(v) || length(v) > 1, logical(1)))) {
      valores
    } else {
      tryCatch(unlist(valores), error = function(e) valores)
    }
  })
  names(colunas) <- todas_colunas

  tibble::as_tibble(colunas)
}

#' Obter uma ficha especifica
#'
#' @title Obter uma ficha especifica
#' @description Retorna os dados completos de uma ficha, com os campos ja resolvidos
#'   para seus nomes (em vez de IDs).
#' @param ficha_id string com o ID da ficha
#' @return lista R com \code{id}, \code{id_app}, \code{modelo_nome}, \code{criador},
#'   \code{created}, \code{updated}, \code{metadados_iniciais}, \code{dados}, \code{metadados_finais}
#' @examples
#' \dontrun{
#' ficha("ficha789")
#' }
#' @export
ficha <- function(ficha_id) {
  .ficharium_erro(
    .ficharium_requisicao("GET", paste0("fichas/ficha/", ficha_id)),
    paste0("Ficha '", ficha_id, "' nao encontrada")
  )
}
