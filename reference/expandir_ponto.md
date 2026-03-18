# Expandir list-column de ponto

Expande uma coluna de ponto em nome, id, latitude e longitude.

## Usage

``` r
expandir_ponto(df, coluna = "ponto")
```

## Arguments

- df:

  data.frame ou tibble com a coluna a expandir

- coluna:

  nome da coluna (padrao: `"ponto"`)

## Value

tibble com colunas adicionais `<coluna>_nome`, `<coluna>_id`,
`<coluna>_latitude` e `<coluna>_longitude`

## Details

Expandir list-column de ponto

## Examples

``` r
if (FALSE) { # \dontrun{
fichas |> expandir_ponto("ponto")
} # }
```
