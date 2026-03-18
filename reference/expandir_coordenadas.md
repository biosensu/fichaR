# Expandir list-column de coordenadas

Expande uma coluna de coordenadas em latitude e longitude.

## Usage

``` r
expandir_coordenadas(df, coluna = "coordenadas")
```

## Arguments

- df:

  data.frame ou tibble com a coluna a expandir

- coluna:

  nome da coluna (padrao: `"coordenadas"`)

## Value

tibble com colunas adicionais `<coluna>_latitude` e `<coluna>_longitude`

## Details

Expandir list-column de coordenadas

## Examples

``` r
if (FALSE) { # \dontrun{
fichas |> expandir_coordenadas("coordenadas")
} # }
```
