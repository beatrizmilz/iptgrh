# carregar funcoes
devtools::load_all()
library(ggplot2)

# PARTE 1 - Calcular os indicadores ------------------------

mes_ano_aplicar <-
  readr::read_rds("inst/indice/dados_aplicacao.rds") |>
  dplyr::distinct(ano_coleta_dados, mes_coleta_dados) |>
  dplyr::mutate(data = glue::glue(
    "{ano_coleta_dados}-{mes_coleta_dados}-01") |>
     as.Date()) |>
  dplyr::arrange(data) |>
  dplyr::filter(data < "2022-03-01") |>
  tibble::rowid_to_column() |>
  dplyr::group_split(rowid)

resultados <- mes_ano_aplicar |>
  purrr::map(
    ~ calcular_indicadores_cbh(
      mes_calcular_indicadores = .x$mes_coleta_dados,
      ano_calcular_indicadores = .x$ano_coleta_dados
    ),
    .progress = TRUE
  )

resultados_preliminares <- resultados |>
  purrr::list_rbind() |>
  dplyr::mutate(dplyr::across(
    .cols = tidyselect::starts_with("ind_"),
    as.numeric
  ))

readr::write_rds(
  resultados_preliminares,
  "inst/indice/aplicacoes_teste/resultados_preliminares_periodizacao.rds"
)


# Parte 2 - Checagens ------------------------

resultados_preliminares <- readr::read_rds(
  "inst/indice/aplicacoes_teste/resultados_preliminares_periodizacao.rds"
  )

# checando se há NAs
resultados_com_na <- resultados_preliminares |>
  tidyr::pivot_longer(cols = tidyselect::starts_with("ind_")) |>
  dplyr::filter(is.na(value)) |>
  dplyr::arrange(name)

resultados_com_na |>
  dplyr::distinct(mes_referencia, ano_referencia, n_ugrhi, name)

# Sumarizações usando desvio padrão -------
# os indicadores igual a 0, nao ajuda na comparacao temporal do indice
resultados_preliminares |>
  dplyr::group_by(n_ugrhi) |>
  dplyr::summarise(dplyr::across(
    .cols = c(tidyselect::starts_with("ind_")),
    sd,
    na.rm = TRUE
  )) |> View()

# os indicadores iguais a 0, nao ajuda na comparacao entre ugrhis
resultados_preliminares |>
  dplyr::group_by(mes_referencia, ano_referencia) |>
  dplyr::summarise(dplyr::across(
    .cols = c(tidyselect::starts_with("ind_")),
    sd,
    na.rm = TRUE
  )) |> View()


# PARTE 3 - GRÁFICOS ----
# qual é o menor período que tem alguma variabilidade?

grafico_trimestral <-
  gerar_grafico_periodizacao(resultados_preliminares,
                             "periodo_trimestral")


ggplot2::ggsave(
  filename = here::here("inst", "tese", "imagens", "graficos", "indice", "grafico_periodizacao_trimestral.png"),
  plot = grafico_trimestral,
  dpi = 600,
  width = 8,
  height = 10
)



grafico_semestral <-
  gerar_grafico_periodizacao(resultados_preliminares,
                             "periodo_semestral")

ggplot2::ggsave(
  filename = here::here("inst", "tese", "imagens", "graficos", "indice", "grafico_periodizacao_semestral.png"),
  plot = grafico_semestral,
  dpi = 600,
  width = 8,
  height = 10
)

grafico_anual <- gerar_grafico_periodizacao(resultados_preliminares,
                                            "periodo_anual")



ggplot2::ggsave(
  filename = here::here("inst", "tese", "imagens", "graficos", "indice", "grafico_periodizacao_anual.png"),
  plot = grafico_anual,
  dpi = 600,
  width = 8,
  height = 10
)
# Decisão: aplicação semestral do índice.

# um dos componentes importantes de um indicador é que ele tenha variabilidade
# variabilidade do indicador em geral, entre ugrhis,
# e a variabilidade do indicador ao longo do tempo.


# semestral: balanço entre ter mais data-points e variabilidade.
