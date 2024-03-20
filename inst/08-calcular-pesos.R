devtools::load_all()

resultados_preliminares <- readr::read_rds(
  "inst/indice/aplicacoes_teste/resultados_preliminares_periodizacao.rds"
) |>
  dplyr::select(-c(ind_tempestividade_03_agenda,
                   ind_tempestividade_03_atas,
                   ind_tempestividade_02_documentos,
                   ind_tempestividade_02_deliberacoes))

base_preparando_indicadores <- resultados_preliminares |>
  tidyr::pivot_longer(
    cols = tidyselect::starts_with("ind_"),
    names_to = "indicador",
    values_to = "valor"
  ) |>
  dplyr::mutate(criterio = stringr::str_extract(indicador, "ind_.*_0") |>
                  stringr::str_remove("ind_") |>
                  stringr::str_remove("_0"),
                criterio = dplyr::case_when(
                  criterio == "procedencia" ~ "Procedência",
                  criterio == "processavel_maquina" ~ "Processável por máquina",
                  criterio == "tempestividade" ~ "Tempestividade",
                  criterio == "completude" ~ "Completude",
                  criterio == "online_gratuito" ~ "Online e gratuito",
                  criterio == "nao_discriminacao" ~ "Não discriminação",
                  TRUE ~ criterio
                ))

base_pesos_sumarizacao <- base_preparando_indicadores |>
  dplyr::group_by(indicador) |>
  dplyr::summarise(
    valor_min = min(valor),
    valor_max = max(valor),
    media = round(mean(valor), 1),
    desvio_padrao = round(sd(valor),1),
  ) |>
  dplyr::arrange(media, desvio_padrao)

usethis::use_data(base_pesos_sumarizacao, overwrite = TRUE)

pesos_indicadores <- base_preparando_indicadores |>
  dplyr::mutate(
    valor_invertido = 1 - valor
    ) |>
  dplyr::group_by(indicador) |>
  dplyr::summarise(
    valor_invertido_minimo = min(valor_invertido, na.rm = TRUE),
    valor_invertido_minimo_ajustado = ((valor_invertido_minimo + 1)/2),
    sumarizacao_valor = (valor_invertido_minimo_ajustado) ^ 2,
    desvio_padrao = sd(valor, na.rm = TRUE),
    desvio_padrao_ajustado = ((desvio_padrao + 1) / 2) ,
    peso = round((sumarizacao_valor * desvio_padrao_ajustado)*10)
  ) |>
  dplyr::mutate(
    soma_total_pesos = sum(peso),
    porc = round((peso/soma_total_pesos), 3),
    porc_format = scales::percent(porc, decimal.mark = ",")
  )


usethis::use_data(pesos_indicadores, overwrite = TRUE)
