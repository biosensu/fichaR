# Listar fichas de um modelo em um projeto

Retorna todas as fichas de um modelo especifico dentro de um projeto,
com os dados de cada observacao expandidos em linhas individuais. Campos
complexos (especie, coordenada, ponto, lista) sao retornados como
list-columns.

## Usage

``` r
listar_fichas(projeto_id, modelo_id)
```

## Arguments

- projeto_id:

  string com o ID do projeto

- modelo_id:

  string com o ID do modelo

## Value

tibble onde cada linha e uma observacao (item de `dados`), com colunas
de metadados da ficha mais os campos do modelo.

## Details

Listar fichas de um modelo em um projeto

## Examples

``` r
if (FALSE) { # \dontrun{
fichas <- listar_fichas("proj123", "modelo456")
} # }
```
