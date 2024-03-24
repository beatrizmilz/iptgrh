separar_base_ind <- function(dados, coluna) {
  dados |>
    tidyr::unnest(validade_html) |>
    dplyr::filter(tipo_info == coluna) |>
    dplyr::select(data_coleta_dados:n_ugrhi, html_valido, .data[[coluna]]) |>
    tidyr::unnest(.data[[coluna]])
}


preparar_dados_ind <- function(ano_calcular,
                               mes_calcular) {
  dados_aplicacao <-
    readr::read_rds("inst/indice/dados_aplicacao.rds")


  base_html_validacao <- baixar_arquivo_releases("base_html_validacao.rds")

  numero_sigla <- ComitesBaciaSP::comites_sp |>
    dplyr::select(sigla_comite, n_ugrhi)

  base_validade_html <-  base_html_validacao |>
    dplyr::filter(ano == ano_calcular,
                  mes == mes_calcular,
                  tipo_info != "atas_agencia") |>
    dplyr::group_by(comite, tipo_info) |>
    dplyr::slice(1) |>
    dplyr::select(comite, tipo_info, html_valido) |>
    dplyr::ungroup() |>
    tidyr::nest(validade_html = -comite) |>
    dplyr::full_join(numero_sigla, by = c("comite" = "sigla_comite")) |>
    tidyr::drop_na(n_ugrhi) |>
    dplyr::rename(sigla_comite = comite)

  # filtrar os dados para o mes e ano
  dados_aplicacao |>
    dplyr::filter(
      ano_coleta_dados == ano_calcular,
      mes_coleta_dados == mes_calcular,
      orgao == "cbh"
    ) |>
    dplyr::left_join(base_validade_html)
}
