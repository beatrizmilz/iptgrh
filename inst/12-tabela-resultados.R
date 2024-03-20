devtools::load_all()
tabela_resultados_indice <- resultados_indice |>
  dplyr::select(sigla_comite, n_ugrhi, resultado, periodo_ref, comite) |>
  dplyr::mutate(resultado = round(resultado, 3)) |>
  tidyr::pivot_wider(
    names_from = "periodo_ref",
    values_from = "resultado"
  ) |>
  dplyr::select(-sigla_comite) |>
  dplyr::distinct() |>
  dplyr::rename(
    "CBH" = comite,
    "Número da UGRHI" = n_ugrhi
  )


usethis::use_data(tabela_resultados_indice, overwrite = TRUE)
