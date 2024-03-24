calcular_ind_completude_07_representantes <- function(dados) {
  numero_sigla <- ComitesBaciaSP::comites_sp |>
    dplyr::select(sigla_comite, n_ugrhi)

  dados |>
    dplyr::mutate(
      email_valido_comparacao = !stringr::str_detect(email, paste0(tese::emails_invalidos, collapse = "|")),
      email_valido_regex = testar_validade_email(email),
      email_valido = (email_valido_comparacao + email_valido_regex) == 2
    ) |>
    dplyr::count(n_ugrhi, email_valido) |>
    dplyr::group_by(n_ugrhi) |>
    dplyr::mutate(n_total = sum(n)) |>
    dplyr::mutate(
      porc = n / n_total,
      ind_completude_07_representantes = round(porc, 2)
    ) |>
    dplyr::filter(email_valido == TRUE) |>
    dplyr::full_join(numero_sigla) |>
    dplyr::mutate(
      ind_completude_07_representantes = tidyr::replace_na(ind_completude_07_representantes, replace = 0),
      ind_completude_07_representantes = as.numeric(ind_completude_07_representantes)
    ) |>
    dplyr::select(n_ugrhi, ind_completude_07_representantes) |>
    dplyr::ungroup() |>
    dplyr::select(n_ugrhi, tidyselect::starts_with("ind_"))
}
