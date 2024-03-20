devtools::load_all()

resultados_indice_parcial_sem_pesos <- resultados_indicadores |>
  dplyr::select(-c(ind_tempestividade_03_agenda,
                   ind_tempestividade_03_atas,
                   ind_tempestividade_02_documentos,
                   ind_tempestividade_02_deliberacoes)) |>
  dplyr::mutate(dplyr::across(tidyselect::starts_with("ind"), as.character)) |>
  tidyr::pivot_longer(cols = tidyselect::starts_with("ind"), names_to = "indicador", values_to = "valor_indicador") |>
  dplyr::mutate(valor_indicador = stringr::str_trim(valor_indicador),
                valor_indicador = dplyr::na_if(valor_indicador, "NA"),
                valor_indicador = dplyr::na_if(valor_indicador, "?") ,
                valor_indicador = as.numeric(valor_indicador),
                valor_indicador = tidyr::replace_na(valor_indicador, 0)
  )

pesos_resumido <- pesos_indicadores |>
  dplyr::select(indicador, peso)

resultados_indicadores_com_pesos <- resultados_indice_parcial_sem_pesos |>
  dplyr::left_join(pesos_resumido, by = "indicador") |>
  dplyr::mutate(valor_com_peso = valor_indicador * peso)



usethis::use_data(resultados_indicadores_com_pesos, overwrite = TRUE)


resultados_indice_parcial <- resultados_indicadores_com_pesos |>
  dplyr::group_by(mes_referencia,
                  ano_referencia,
                  bacia_hidrografica,
                  sigla_comite,
                  n_ugrhi) |>
  dplyr::summarise(
    soma = sum(valor_com_peso, na.rm = TRUE),
    valor_total = sum(peso, na.rm = TRUE),
    resultado = soma / valor_total,
    resultado = round(resultado, 3),
  ) |>
  dplyr::arrange(n_ugrhi) |>
  dplyr::ungroup() |>
  dplyr::select(-soma,-valor_total)



aguapei_e_peixe <- resultados_indice_parcial |>
  dplyr::filter(bacia_hidrografica == "Aquapeí e Peixe") |>
  dplyr::mutate(n_ugrhi = 21)

resultados_indice <- resultados_indice_parcial |>
  dplyr::bind_rows(aguapei_e_peixe) |>
  dplyr::mutate(
    data_ref = paste0(ano_referencia, "-", mes_referencia, "-01"),
    data_ref = lubridate::ymd(data_ref),
    periodo_ref = paste0(lubridate::month(data_ref, label = TRUE, abbr = FALSE, locale = "pt_BR"), "/", lubridate::year(data_ref)),
    comite = paste0(bacia_hidrografica, " - ", stringr::str_to_upper(sigla_comite))
  )



usethis::use_data(resultados_indice, overwrite = TRUE)
