# fichaR

Cliente R para o [Ficharium Cloud](https://ficharium.cloud). Permite
autenticar, listar projetos, modelos e fichas de campo, e acessar listas
de espécies consolidadas.

## Instalação

``` r
# via remotes (recomendado)
remotes::install_github("biosensu/fichaR")
```

## Autenticação

O token JWT é armazenado no `.Renviron` e reutilizado entre sessões.

``` r
library(fichaR)

# Login — abre prompt seguro de senha
ficharium_login("seu@email.com")
```

## Projetos

``` r
# listar todos os projetos do usuário
projetos <- listar_projetos()

# detalhes de um projeto
proj <- projeto(projetos$id[1])

# modelos e fichas de um projeto
modelos_projeto("proj_id")
fichas_projeto("proj_id")
```

## Modelos e campos

``` r
# modelos do usuário
modelos <- listar_modelos()

# campos de um modelo (com tipos R mapeados)
campos <- campos_modelo(modelos$id[1])
```

## Fichas de campo

``` r
# tibble com uma linha por observação
fichas <- listar_fichas("proj_id", "modelo_id")

# ficha específica (campos resolvidos para nomes)
ficha("ficha_id")
```

### Expandindo campos complexos

Campos de tipo `especie`, `coordenada` e `ponto` são retornados como
list-columns. Use as funções auxiliares para expandi-los:

``` r
fichas |> expandir_especies("Espécie")
fichas |> expandir_coordenadas("Coordenadas")
fichas |> expandir_ponto("Ponto amostral")
```

## Espécies

``` r
# lista consolidada de espécies registradas no projeto
especies <- listar_especies("proj_id")

# com filtro por nome
listar_especies("proj_id", busca = "Leopardus")
```

## Configuração avançada

Defina no `.Renviron` para sobrescrever os padrões:

    FICHARIUM_TOKEN=seu_token_jwt
    FICHARIUM_BASE_URL=https://api.ficharium.cloud

## Licença

MIT © Biosensu
