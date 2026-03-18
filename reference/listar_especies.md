# Listar especies registradas em um projeto

Retorna a lista consolidada de especies registradas nas fichas de um
projeto. O filtro por `busca` e aplicado localmente em R.

## Usage

``` r
listar_especies(projeto_id, busca = NULL)
```

## Arguments

- projeto_id:

  string com o ID do projeto

- busca:

  string opcional para filtrar pelo nome cientifico (busca parcial,
  case-insensitive)

## Value

tibble com colunas `nc`, `grupo`, `total_registros`, `metodologias`

## Details

Listar especies registradas em um projeto

## Examples

``` r
if (FALSE) { # \dontrun{
listar_especies("proj123")
listar_especies("proj123", busca = "Leopardus")
} # }
```
