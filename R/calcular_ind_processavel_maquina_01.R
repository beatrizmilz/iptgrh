calcular_ind_processavel_maquina_01 <- function(dados, coluna) {
  nome_coluna <- paste0("ind_processavel_maquina_01_", coluna)

  nomes_comites |>
    dplyr::left_join(dados, by = "n_ugrhi", suffix = c(".x", "")) |>
    dplyr::distinct(orgao, comite, n_ugrhi, site_coleta) |>
    dplyr::mutate(site_coleta = tidyr::replace_na(site_coleta, "")) |>
    dplyr::arrange(n_ugrhi) |>
    dplyr:::mutate("{nome_coluna}" := as.numeric(stringr::str_detect(site_coleta, paste0("/", coluna)))) |>
    dplyr::select(n_ugrhi, tidyselect::starts_with("ind_"))
}
