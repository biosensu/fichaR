# Obter uma ficha especifica

Retorna os dados completos de uma ficha, com os campos ja resolvidos
para seus nomes (em vez de IDs).

## Usage

``` r
ficha(ficha_id)
```

## Arguments

- ficha_id:

  string com o ID da ficha

## Value

lista R com `id`, `id_app`, `modelo_nome`, `criador`, `created`,
`updated`, `metadados_iniciais`, `dados`, `metadados_finais`

## Details

Obter uma ficha especifica

## Examples

``` r
if (FALSE) { # \dontrun{
ficha("ficha789")
} # }
```
