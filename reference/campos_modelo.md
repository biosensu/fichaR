# Obter campos de um modelo

Retorna os campos de um modelo de ficha, consolidando metadados
iniciais, campos principais e metadados finais.

## Usage

``` r
campos_modelo(modelo_id)
```

## Arguments

- modelo_id:

  string com o ID do modelo

## Value

tibble com colunas `field_id`, `label`, `widget`, `tipo`, `r_tipo`,
`secao`

## Details

Obter campos de um modelo

## Examples

``` r
if (FALSE) { # \dontrun{
campos_modelo("abc123")
} # }
```
