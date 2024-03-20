devtools::load_all()

ind_resultados <- resultados_indicadores |>
  dplyr::select(tidyselect::starts_with("ind_")) |>
  # remove as colunas que tem variância igual a zero
  dplyr::select(where(~var(.x) != 0))

# install.packages("ggcorrplot")

correlation_matrix <- cor(ind_resultados)

grafico_matriz_correlacao <-
  ggcorrplot::ggcorrplot(correlation_matrix,
                         tl.srt = 90,
                         legend.title = "Correlação")


ggplot2::ggsave(
  filename = "inst/tese/imagens/indice/diagnostico-matriz-correlacao.jpeg",
  plot = grafico_matriz_correlacao,
  device = "jpeg",
  dpi = 600,
  width = 10,
  height = 6
)

# p values

correlation_matrix_pvalues <- ggcorrplot::cor_pmat(ind_resultados)

diagnostico_correlacao_estat_significante <- correlation_matrix_pvalues |>
  tibble::as_tibble(rownames = "col") |>
  tidyr::pivot_longer(-col) |>
  dplyr::filter(value < 0.05, col != name) |>
  dplyr::rowwise() |>
  dplyr::mutate(pares = paste(sort(c(col, name)), collapse = " ")) |>
  dplyr::distinct(pares, .keep_all = TRUE) |>
  dplyr::mutate(
    componente_col_1 = stringr::str_extract(col, "ind_.*_0") |>
      stringr::str_remove("ind_") |>
      stringr::str_remove("_0"),
    componente_col_2 = stringr::str_extract(name, "ind_.*_0") |>
      stringr::str_remove("ind_") |>
      stringr::str_remove("_0"),
    componente_igual = componente_col_1 == componente_col_2,
    value = round(value, 2)
  ) |>
  dplyr::select(-pares) |>
  dplyr::rename(
    indicador_1 = col,
    indicador_2 = name,
    p_valor = value
  ) |>
  dplyr::arrange(p_valor)

usethis::use_data(diagnostico_correlacao_estat_significante,
                  overwrite = TRUE)


# a analise de correlacao e a PCA devem ser analisadas conjuntamente,
# antes de tomar decisao.


