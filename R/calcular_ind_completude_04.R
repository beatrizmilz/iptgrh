calcular_ind_completude_04 <- function(ano_calcular,
                                       mes_calcular) {
  base_html_validacao <- ler_arquivos_piggyback("base_html_validacao")


  numero_sigla <- ComitesBaciaSP::comites_sp |>
    dplyr::select(sigla_comite, n_ugrhi)


  html_validacao_filtrado <- base_html_validacao |>
    dplyr::filter(ano == ano_calcular, mes == mes_calcular) |>
    dplyr::arrange(data_extracao) |>
    dplyr::group_by(comite, tipo_info) |>
    dplyr::slice(1) |>
    dplyr::ungroup()


  ind_completude_04 <- html_validacao_filtrado |>
    dplyr::arrange(comite, tipo_info) |>
    dplyr::select(comite, tipo_info, html_valido) |>
    tidyr::pivot_wider(names_from = tipo_info, values_from = html_valido, names_prefix = "ind_completude_01_") |>
    dplyr::mutate(dplyr::across(.cols = tidyselect::starts_with("ind_completude_04_"), as.numeric)) |>
    dplyr::left_join(numero_sigla, c("comite" = "sigla_comite")) |>
    dplyr::relocate(n_ugrhi, .after = comite) |>
    dplyr::arrange(n_ugrhi) |>
    dplyr::select(n_ugrhi, tidyselect::starts_with("ind_")) |>
    dplyr::select(-tidyselect::contains("agencia"))

  ind_completude_04
}
