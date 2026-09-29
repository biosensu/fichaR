# Listar encontros ocasionais de um projeto

Retorna os encontros ocasionais de um projeto. Encontros ocasionais sao
registros avulsos (fora de uma ficha), agrupados por grupo taxonomico,
cada um com especie e local.

## Usage

``` r
encontros_ocasionais(projeto_id)
```

## Arguments

- projeto_id:

  string com o ID do projeto

## Value

tibble com colunas `id`, `grupo`, `especie_nc`, `latitude`, `longitude`,
`local_nome`, `n`, `criador_nome`, `created`.

## Details

Listar encontros ocasionais de um projeto

## Examples

``` r
if (FALSE) { # \dontrun{
encontros <- encontros_ocasionais("proj123")
} # }
```
