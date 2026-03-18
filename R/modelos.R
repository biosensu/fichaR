#' Listar modelos do usuario
#'
#' @title Listar modelos do usuario
#' @description Retorna todos os modelos de ficha criados pelo usuario autenticado.
#' @return tibble com colunas \code{id}, \code{nome}, \code{descricao}, \code{grupo}, \code{created}
#' @examples
#' \dontrun{
#' ficharium_login("email@exemplo.com")
#' listar_modelos()
#' }
#' @export
listar_modelos <- function() {
  res <- .ficharium_erro(
    .ficharium_requisicao("GET", "modelos"),
    "Erro ao listar modelos"
  )

  tibble::tibble(
    id        = vapply(res, \(x) x$id       %||% NA_character_, character(1)),
    nome      = vapply(res, \(x) x$nome     %||% NA_character_, character(1)),
    descricao = vapply(res, \(x) x$descricao %||% NA_character_, character(1)),
    grupo     = vapply(res, \(x) x$grupo    %||% NA_character_, character(1)),
    created   = vapply(res, \(x) x$created  %||% NA_character_, character(1))
  )
}

#' Obter campos de um modelo
#'
#' @title Obter campos de um modelo
#' @description Retorna os campos de um modelo de ficha, consolidando metadados iniciais,
#'   campos principais e metadados finais.
#' @param modelo_id string com o ID do modelo
#' @return tibble com colunas \code{field_id}, \code{label}, \code{widget}, \code{tipo}, \code{r_tipo}, \code{secao}
#' @examples
#' \dontrun{
#' campos_modelo("abc123")
#' }
#' @export
campos_modelo <- function(modelo_id) {
  res <- .ficharium_erro(
    .ficharium_requisicao("GET", paste0("modelos/", modelo_id)),
    paste0("Modelo '", modelo_id, "' nao encontrado")
  )

  .extrair_campos <- function(lista, secao) {
    if (is.null(lista) || length(lista) == 0) return(list())
    lapply(lista, function(campo) {
      list(
        field_id = campo$id %||% NA_character_,
        label    = (campo$nome %||% campo$nome_widget) %||% NA_character_,
        widget   = campo$widget %||% campo$tipo %||% NA_character_,
        tipo     = campo$tipo %||% NA_character_,
        r_tipo   = .ficharium_tipo_para_r(campo$tipo %||% ""),
        secao    = secao
      )
    })
  }

  campos <- c(
    .extrair_campos(res$metadados_iniciais, "metadados_iniciais"),
    .extrair_campos(res$campos,             "campos"),
    .extrair_campos(res$metadados_finais,   "metadados_finais")
  )

  if (length(campos) == 0) {
    return(tibble::tibble(
      field_id = character(0), label = character(0), widget = character(0),
      tipo = character(0), r_tipo = character(0), secao = character(0)
    ))
  }

  tibble::tibble(
    field_id = vapply(campos, `[[`, character(1), "field_id"),
    label    = vapply(campos, `[[`, character(1), "label"),
    widget   = vapply(campos, `[[`, character(1), "widget"),
    tipo     = vapply(campos, `[[`, character(1), "tipo"),
    r_tipo   = vapply(campos, function(x) x$r_tipo %||% "character", character(1)),
    secao    = vapply(campos, `[[`, character(1), "secao")
  )
}

#' Expandir list-column de especies
#'
#' @title Expandir list-column de especies
#' @description Expande uma coluna de especies em tres colunas: nc, np e grupo.
#' @param df data.frame ou tibble com a coluna a expandir
#' @param coluna nome da coluna (padrao: \code{"especie"})
#' @return tibble com colunas adicionais \code{<coluna>_nc}, \code{<coluna>_np}, \code{<coluna>_grupo}
#' @examples
#' \dontrun{
#' fichas |> expandir_especies("especie")
#' }
#' @export
expandir_especies <- function(df, coluna = "especie") {
  df[[paste0(coluna, "_nc")]]    <- vapply(df[[coluna]], \(x) x$nc    %||% NA_character_, character(1))
  df[[paste0(coluna, "_np")]]    <- vapply(df[[coluna]], \(x) x$np    %||% NA_character_, character(1))
  df[[paste0(coluna, "_grupo")]] <- vapply(df[[coluna]], \(x) x$grupo %||% NA_character_, character(1))
  df[[coluna]] <- NULL
  df
}

#' Expandir list-column de coordenadas
#'
#' @title Expandir list-column de coordenadas
#' @description Expande uma coluna de coordenadas em latitude e longitude.
#' @param df data.frame ou tibble com a coluna a expandir
#' @param coluna nome da coluna (padrao: \code{"coordenadas"})
#' @return tibble com colunas adicionais \code{<coluna>_latitude} e \code{<coluna>_longitude}
#' @examples
#' \dontrun{
#' fichas |> expandir_coordenadas("coordenadas")
#' }
#' @export
expandir_coordenadas <- function(df, coluna = "coordenadas") {
  df[[paste0(coluna, "_latitude")]]  <- vapply(df[[coluna]], \(x) x$latitude  %||% NA_real_, numeric(1))
  df[[paste0(coluna, "_longitude")]] <- vapply(df[[coluna]], \(x) x$longitude %||% NA_real_, numeric(1))
  df[[coluna]] <- NULL
  df
}

#' Expandir list-column de ponto
#'
#' @title Expandir list-column de ponto
#' @description Expande uma coluna de ponto em nome, id, latitude e longitude.
#' @param df data.frame ou tibble com a coluna a expandir
#' @param coluna nome da coluna (padrao: \code{"ponto"})
#' @return tibble com colunas adicionais \code{<coluna>_nome}, \code{<coluna>_id},
#'   \code{<coluna>_latitude} e \code{<coluna>_longitude}
#' @examples
#' \dontrun{
#' fichas |> expandir_ponto("ponto")
#' }
#' @export
expandir_ponto <- function(df, coluna = "ponto") {
  df[[paste0(coluna, "_nome")]]      <- vapply(df[[coluna]], \(x) x$nome      %||% NA_character_, character(1))
  df[[paste0(coluna, "_id")]]        <- vapply(df[[coluna]], \(x) x$id        %||% NA_character_, character(1))
  df[[paste0(coluna, "_latitude")]]  <- vapply(df[[coluna]], \(x) x$latitude  %||% NA_real_,      numeric(1))
  df[[paste0(coluna, "_longitude")]] <- vapply(df[[coluna]], \(x) x$longitude %||% NA_real_,      numeric(1))
  df[[coluna]] <- NULL
  df
}
