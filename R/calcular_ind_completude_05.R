calcular_ind_completude_05 <- function(dados, coluna) {

  nome_coluna <- paste0("ind_completude_05_", coluna)



  parc <- dados |>
    dplyr::count(orgao, comite, n_ugrhi) |>
    dplyr::arrange(n_ugrhi)

  nomes_comites |>
    dplyr::left_join(parc, by = "n_ugrhi") |>
    dplyr::mutate(n = tidyr::replace_na(n, 0)) |>
    dplyr::mutate("{nome_coluna}" := dplyr::if_else(n > 1, 1, 0)) |>
    dplyr::select(n_ugrhi, tidyselect::starts_with("ind_"))
}
