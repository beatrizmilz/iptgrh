devtools::load_all()
library(tidyverse)

resultados_com_principio <- resultados_indicadores_com_pesos |>
  dplyr::mutate(
    principio = stringr::str_extract(indicador, "ind_.*_0") |>
      stringr::str_remove("ind_") |>
      stringr::str_remove("_0"),
    principio_format = dplyr::case_when(
      principio == "completude" ~ "Completude",
      principio == "nao_discriminacao" ~ "Não discriminação",
      principio == "online_gratuito" ~ "Online e gratuito",
      principio == "processavel_maquina" ~ "Processável por máquina",
      principio == "tempestividade" ~ "Tempestividade",
    ),
    principio_format = forcats::fct_relevel(
      principio_format,
      c(
        "Online e gratuito",
        "Não discriminação",
        "Completude",
        "Tempestividade",
        "Processável por máquina"
      ) |> rev())
  )


# Tabela
tab_resultados_principio <- resultados_com_principio |>
  dplyr::group_by(principio_format) |>
  dplyr::summarise(
    valor_min = min(valor_indicador),
    valor_max = max(valor_indicador),
    valor_medio = mean(valor_indicador),
    desvio_padrao = sd(valor_indicador),
    n_distinct = dplyr::n_distinct(valor_indicador)
  ) |>
  dplyr::arrange(valor_medio)

usethis::use_data(tab_resultados_principio, overwrite = TRUE)



# Gráfico

library(ggplot2)
# fig_resultados_por_principio <- resultados_com_principio |>
#   ggplot() +
#   aes(
#     y = principio_format, x = valor_indicador, color = principio
#   ) +
#   geom_jitter(
#     alpha = 0.5,
#     show.legend = FALSE
#   ) +
#   scale_color_brewer(
#     palette = "Set2"
#   ) +
#   theme_bw() +
#   labs(
#     x = "Valor do indicador",
#     y = "Princípio de dados abertos"
#   )
# ggsave(
#   "inst/book/assets/img/04-ipt-grh/fig-resultados-por-principio.jpeg",
#   plot = fig_resultados_por_principio,
#   device = "jpeg",
#   dpi = 600,
#   width = 8,
#   height = 6
# )

# tabela tempestividade

tbl_resultados_por_indicador_tempestividade <- resultados_com_principio |>
  dplyr::filter(principio == "tempestividade") |>
  dplyr::group_by(indicador) |>
  dplyr::summarise(
    valor_medio = mean(valor_indicador),
    desvio_padrao = sd(valor_indicador),
  ) |>
  dplyr::arrange(valor_medio)

usethis::use_data(tbl_resultados_por_indicador_tempestividade, overwrite = TRUE)


floor_dec <- function(x, level = 1){
  round(x - 5 * 10 ^ (-level - 1), level)
}



contagem_por_principio <- resultados_com_principio |>
  dplyr::mutate(
    valor_categorizado = dplyr::case_when(
      valor_indicador == 1 ~ 1,
      valor_indicador < 1 ~ floor_dec(valor_indicador, 1)
    ),
    valor_categoria = forcats::as_factor(valor_categorizado) |>
      forcats::fct_relevel(rev)
  ) |>
  dplyr::group_by(principio_format, indicador) |>
  dplyr::count(valor_categoria) |>
  dplyr::mutate(proporcao = (n / sum(n)) * 100) |>
  dplyr::ungroup()

# gráfico tempestividade

# Esse gráfico tá ruim
# já gastei tempo demais.
# pedir ajuda pro ju
fig_resultados_por_indicador_principios <- contagem_por_principio |>
  dplyr::filter(principio_format != "Online e gratuito",
                principio_format != "Não discriminação") |>
  #dplyr::mutate(indicador_fct = tidytext::reorder_within(indicador, proporcao, within = principio_format)) |>
  ggplot() +
  geom_col(aes(y = indicador, x = proporcao, fill = valor_categoria)) +
  scale_fill_viridis_d() +
  theme_bw() +
  labs(
    x = "Proporção (%)",
    y = "Indicador",
    fill = "Valor do indicador"
  ) +
  facet_wrap(~principio_format, ncol = 1, scales = "free_y")


ggsave(
  "inst/book/assets/img/04-ipt-grh/fig_resultados_por_indicador_principios.jpeg",
  plot = fig_resultados_por_indicador_principios,
  device = "jpeg",
  dpi = 600,
  width = 8,
  height = 10
)

