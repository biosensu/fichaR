# Listar fichas de um projeto

Retorna todas as fichas de um projeto com metadados basicos. Nao inclui
os `dados` de cada observacao — use
[`listar_fichas()`](https://biosensu.github.io/fichaR/reference/listar_fichas.md)
para isso.

## Usage

``` r
fichas_projeto(projeto_id)
```

## Arguments

- projeto_id:

  string com o ID do projeto

## Value

tibble com colunas `id`, `modelo_id`, `modelo_nome`, `criador_nome`,
`created`, `updated`

## Details

Listar fichas de um projeto

## Examples

``` r
if (FALSE) { # \dontrun{
fichas_projeto("proj123")
} # }
```
