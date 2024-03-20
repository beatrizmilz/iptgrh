calcular_ind_completude_06_representantes <- function(dados) {
  dados |>
    dplyr::mutate(
      nome_arrumado = dplyr::case_when(
        # Ir aumentando conforme vai adicionando
        nome %in% c("----", "à indicar",
                    "Sem indicação") ~ NA_character_,
        TRUE ~ nome
      )
    ) |>
    dplyr::group_by(n_ugrhi) |>
    dplyr::mutate(n_linhas = dplyr::n()) |>
    dplyr::group_by(n_ugrhi, n_linhas, data_coleta_dados) |>
    dplyr::summarise(
      quant_na_segmento_representante = sum(is.na(segmento_representante)),
      quant_na_organizacao_representante = sum(is.na(organizacao_representante)),
      quant_na_nome = sum(is.na(nome_arrumado)),
      quant_na_cargo = sum(is.na(cargo)),
    ) |>
    dplyr::mutate(
      soma_na = sum(
        quant_na_segmento_representante,
        quant_na_organizacao_representante,
        quant_na_nome,
        quant_na_cargo
      ),
      n_linhas = n_linhas,
      total_obs = n_linhas * 4,
      porc_na = soma_na / total_obs,
      ind_completude_06_representantes = round(1 - porc_na, 2)
    ) |>
    dplyr::select(n_ugrhi, ind_completude_06_representantes) |>
    dplyr::ungroup() |>
    dplyr::select(n_ugrhi, tidyselect::starts_with("ind_"))
}
