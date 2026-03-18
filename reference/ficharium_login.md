# Login na API Ficharium

Autentica com email e senha e armazena o token JWT automaticamente.

## Usage

``` r
ficharium_login(email, senha = NULL, base_url = ficharium_base_url())
```

## Arguments

- email:

  string com o email do usuario

- senha:

  string com a senha. Se omitido, um prompt seguro e exibido.

- base_url:

  URL base da API (padrao: `ficharium_base_url()`)

## Value

lista com `token`, `nome`, `sobrenome`, `email`, `id`

## Details

Login na API Ficharium

## Examples

``` r
if (FALSE) { # \dontrun{
ficharium_login("usuario@exemplo.com")
} # }
```
