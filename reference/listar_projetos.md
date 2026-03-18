# Listar projetos do usuario

Retorna todos os projetos aos quais o usuario autenticado tem acesso.

## Usage

``` r
listar_projetos()
```

## Value

tibble com colunas `id`, `nome`, `descricao`, `fichas_na_nuvem`, `cargo`

## Details

Listar projetos do usuario

## Examples

``` r
if (FALSE) { # \dontrun{
ficharium_login("email@exemplo.com")
listar_projetos()
} # }
```
