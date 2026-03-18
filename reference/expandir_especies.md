# Expandir list-column de especies

Expande uma coluna de especies em tres colunas: nc, np e grupo.

## Usage

``` r
expandir_especies(df, coluna = "especie")
```

## Arguments

- df:

  data.frame ou tibble com a coluna a expandir

- coluna:

  nome da coluna (padrao: `"especie"`)

## Value

tibble com colunas adicionais `<coluna>_nc`, `<coluna>_np`,
`<coluna>_grupo`

## Details

Expandir list-column de especies

## Examples

``` r
if (FALSE) { # \dontrun{
fichas |> expandir_especies("especie")
} # }
```
