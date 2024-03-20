calcular_ind_tempestividade_02_03 <- function(dados,
                                           col_data_atualizacao,
                                           col_nome) {

  nome_coluna_3_meses <- paste0("ind_tempestividade_02_", col_nome)
  nome_coluna_6_meses <- paste0("ind_tempestividade_03_", col_nome)

  nomes_comites |>
    dplyr::left_join(dados, by = "n_ugrhi") |>
    dplyr::rename(col_data_atualizacao = {{ col_data_atualizacao }}) |>
    dplyr::mutate(
      diferenca_data = data_coleta_dados - col_data_atualizacao,
      diferenca_3_meses = diferenca_data < 90,
      diferenca_6_meses = diferenca_data < 180,
    ) |>
  dplyr::mutate(diferenca_3_meses_2 = tidyr::replace_na(diferenca_3_meses, FALSE),
                diferenca_6_meses_2 = tidyr::replace_na(diferenca_6_meses, FALSE)) |>
    dplyr::group_by(n_ugrhi) |>
    dplyr::summarise(
      resultado_3_meses = sum(diferenca_3_meses, na.rm = TRUE),
      resultado_6_meses = sum(diferenca_6_meses, na.rm = TRUE),
     {{ nome_coluna_3_meses }} := dplyr::if_else(resultado_3_meses > 0, 1, 0),
     {{ nome_coluna_6_meses }} := dplyr::if_else(resultado_6_meses > 0, 1, 0)
    ) |>
    dplyr::select(-tidyselect::starts_with("resultado")) |>
    dplyr::select(n_ugrhi, tidyselect::starts_with("ind_"))
}
