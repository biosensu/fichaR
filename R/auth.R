#' Obter token de autenticacao
#'
#' @title Obter token de autenticacao
#' @description Le o token JWT armazenado na variavel de ambiente \code{FICHARIUM_TOKEN}.
#' @return string com o token
#' @examples
#' \dontrun{
#' ficharium_token()
#' }
#' @export
ficharium_token <- function() {
  token <- Sys.getenv("FICHARIUM_TOKEN")
  if (nchar(token) == 0) {
    stop("Token nao encontrado. Use ficharium_login() ou defina FICHARIUM_TOKEN no .Renviron.", call. = FALSE)
  }
  token
}

#' Definir token de autenticacao
#'
#' @title Definir token de autenticacao
#' @description Salva o token JWT no \code{.Renviron} e define na sessao atual.
#' @param token string com o token JWT
#' @return invisivel
#' @examples
#' \dontrun{
#' ficharium_definir_token("meu_token_jwt")
#' }
#' @export
ficharium_definir_token <- function(token) {
  renviron <- file.path(Sys.getenv("HOME"), ".Renviron")

  linhas <- if (file.exists(renviron)) readLines(renviron, warn = FALSE) else character(0)
  linhas <- linhas[!grepl("^FICHARIUM_TOKEN=", linhas)]
  linhas <- c(linhas, paste0("FICHARIUM_TOKEN=", token))

  writeLines(linhas, renviron)
  Sys.setenv(FICHARIUM_TOKEN = token)
  invisible(token)
}

#' Login na API Ficharium
#'
#' @title Login na API Ficharium
#' @description Autentica com email e senha e armazena o token JWT automaticamente.
#' @param email string com o email do usuario
#' @param senha string com a senha. Se omitido, um prompt seguro e exibido.
#' @param base_url URL base da API (padrao: \code{ficharium_base_url()})
#' @return lista com \code{token}, \code{nome}, \code{sobrenome}, \code{email}, \code{id}
#' @examples
#' \dontrun{
#' ficharium_login("usuario@exemplo.com")
#' }
#' @export
ficharium_login <- function(email, senha = NULL, base_url = ficharium_base_url()) {
  if (is.null(senha)) {
    senha <- askpass::askpass(paste0("Senha Ficharium para ", email, ":"))
  }
  req <- httr2::request(base_url) |>
    httr2::req_url_path_append("usuario", "login") |>
    httr2::req_method("POST") |>
    httr2::req_body_json(list(email = email, senha = senha))

  resp <- httr2::req_error(req, is_error = \(r) FALSE) |> httr2::req_perform()
  status <- httr2::resp_status(resp)

  if (status >= 400) {
    msg <- tryCatch(
      httr2::resp_body_json(resp)$message %||% paste("Erro HTTP", status),
      error = function(e) paste("Erro HTTP", status)
    )
    stop(msg, call. = FALSE)
  }

  res <- httr2::resp_body_json(resp, simplifyVector = FALSE)
  ficharium_definir_token(res$token)

  message("Login realizado com sucesso. Bem-vindo, ", res$nome, "!")
  invisible(res)
}
