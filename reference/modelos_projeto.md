# Listar modelos de um projeto

Retorna os modelos associados a um projeto especifico.

## Usage

``` r
modelos_projeto(projeto_id)
```

## Arguments

- projeto_id:

  string com o ID do projeto

## Value

tibble com colunas `id`, `nome`, `descricao`, `grupo`

## Details

Listar modelos de um projeto

## Examples

``` r
if (FALSE) { # \dontrun{
modelos_projeto("proj123")
} # }
```
