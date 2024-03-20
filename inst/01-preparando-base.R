devtools::load_all()


base_html_validacao <- ler_arquivos_piggyback("base_html_validacao")


# importar dados ----
atas_completo <- ler_arquivos_piggyback("atas_completo") |>
  tidyr::nest(atas = -c(data_coleta_dados, orgao, comite, n_ugrhi))


atas_agencia_completo <- ler_arquivos_piggyback("atas_agencia_completo") |>
  tidyr::nest(atas_agencia = -c(data_coleta_dados, orgao, comite, n_ugrhi))


documentos_completo <- ler_arquivos_piggyback("documentos_completo") |>
  dplyr::mutate(data_postagem = readr::parse_date(data_postagem, "%d/%m/%Y")) |>
  tidyr::nest(documentos = -c(data_coleta_dados, orgao, comite, n_ugrhi))

agenda_completo <- ler_arquivos_piggyback("agenda_completo") |>
  tidyr::nest(agenda = -c(data_coleta_dados, orgao, comite, n_ugrhi))

representantes_completo <- ler_arquivos_piggyback("representantes_completo") |>
  tidyr::nest(representantes = -c(data_coleta_dados, orgao, comite, n_ugrhi))


deliberacoes_completo <- ler_arquivos_piggyback("deliberacoes_completo") |>
  dplyr::mutate(data_postagem = readr::parse_date(data_postagem, "%d/%m/%Y")) |>
  tidyr::nest(deliberacoes = -c(data_coleta_dados, orgao, comite, n_ugrhi))

agenda_detalhada_completo <- ler_arquivos_piggyback("agenda_detalhada_completo") |>
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
