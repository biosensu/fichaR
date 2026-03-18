# Listar modelos do usuario

Retorna todos os modelos de ficha criados pelo usuario autenticado.

## Usage

``` r
listar_modelos()
```

## Value

tibble com colunas `id`, `nome`, `descricao`, `grupo`, `created`

## Details

Listar modelos do usuario

## Examples

``` r
if (FALSE) { # \dontrun{
ficharium_login("email@exemplo.com")
listar_modelos()
} # }
```
