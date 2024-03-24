devtools::load_all()


base_html_validacao <- baixar_arquivo_releases("base_html_validacao.rds")


# importar dados ----
atas_completo <- baixar_arquivo_releases("atas_completo.rds") |>
  tidyr::nest(atas = -c(data_coleta_dados, orgao, comite, n_ugrhi))


atas_agencia_completo <- baixar_arquivo_releases("atas_agencia_completo.rds") |>
  tidyr::nest(atas_agencia = -c(data_coleta_dados, orgao, comite, n_ugrhi))


documentos_completo <- baixar_arquivo_releases("documentos_completo.rds") |>
  dplyr::mutate(data_postagem = readr::parse_date(data_postagem, "%d/%m/%Y")) |>
  tidyr::nest(documentos = -c(data_coleta_dados, orgao, comite, n_ugrhi))

agenda_completo <- baixar_arquivo_releases("agenda_completo.rds") |>
  tidyr::nest(agenda = -c(data_coleta_dados, orgao, comite, n_ugrhi))

representantes_completo <- baixar_arquivo_releases("representantes_completo.rds") |>
  tidyr::nest(representantes = -c(data_coleta_dados, orgao, comite, n_ugrhi))


deliberacoes_completo <- baixar_arquivo_releases("deliberacoes_completo.rds") |>
  dplyr::mutate(data_postagem = readr::parse_date(data_postagem, "%d/%m/%Y")) |>
  tidyr::nest(deliberacoes = -c(data_coleta_dados, orgao, comite, n_ugrhi))

agenda_detalhada_completo <- baixar_arquivo_releases("agenda_detalhada_completo.rds") |>
  dplyr::rename(data_coleta_dados = data_download) |>
  tidyr::nest(agenda_detalhada = -c(data_coleta_dados, id_arquivo))


dados_completo <- dplyr::full_join(atas_completo, documentos_completo) |>
  dplyr::full_join(agenda_completo) |>
  dplyr::full_join(representantes_completo) |>
  dplyr::full_join(deliberacoes_completo) |>
  dplyr::full_join(atas_agencia_completo)


dados_aplicacao <- dados_completo |>
  dplyr::filter(orgao == "cbh") |>
  dplyr::mutate(ano_coleta_dados = lubridate::year(data_coleta_dados),
                mes_coleta_dados = lubridate::month(data_coleta_dados),
                data_coleta_dados = as.Date(data_coleta_dados)) |>
  dplyr::arrange(data_coleta_dados) |>
  dplyr::group_by(orgao, comite, n_ugrhi, mes_coleta_dados, ano_coleta_dados) |>
  dplyr::slice(1) |>
  dplyr::ungroup()


dplyr::glimpse(dados_aplicacao)


readr::write_rds(dados_aplicacao, "inst/indice/dados_aplicacao.rds")
