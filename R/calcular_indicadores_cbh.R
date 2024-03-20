calcular_indicadores_cbh <- function(mes_calcular_indicadores,
                                     ano_calcular_indicadores) {
  dados_calcular <- preparar_dados_ind(
    ano_calcular = ano_calcular_indicadores,
    mes_calcular = mes_calcular_indicadores
  )

  # separar a base, deixar unnest

  dados_agenda <- separar_base_ind(dados_calcular, "agenda")
  dados_atas <- separar_base_ind(dados_calcular, "atas")
  dados_deliberacoes <- separar_base_ind(dados_calcular, "deliberacoes")
  dados_documentos <- separar_base_ind(dados_calcular, "documentos")
  dados_representantes <- separar_base_ind(dados_calcular, "representantes")


  # ind_online_gratuito_01_geral e ind_nao_discriminacao_01_geral ---------

  ind_geral_01_02 <- ComitesBaciaSP::comites_sp |>
    dplyr::select(n_ugrhi, bacia_hidrografica, sigla_comite) |>
    dplyr::mutate(
      ind_online_gratuito_01_geral = 1,
      ind_nao_discriminacao_01_geral = 1
    )


  # ind_completude_geral_01_02_03 -------------------------------

  ind_completude_geral_01_02_03 <- calcular_ind_completude_01_02_03(
    ano_calcular = ano_calcular_indicadores,
    mes_calcular = mes_calcular_indicadores
  )

  # TODO: Acompanhar respostas dos emails e ir adidionando em
  # "inst/indice/checagem_manual_emails/base_check_manual.R"

  # indice completude 04 --------

  ind_completude_04 <- calcular_ind_completude_04(
    ano_calcular = ano_calcular_indicadores,
    mes_calcular = mes_calcular_indicadores
  )

  # indice completude 05 ----------

  ind_completude_05_agenda <-
    calcular_ind_completude_05(dados_agenda, "agenda")

  ind_completude_05_atas <-
    calcular_ind_completude_05(dados_atas, "atas")

  ind_completude_05_deliberacoes <-
    calcular_ind_completude_05(dados_deliberacoes, "deliberacoes")

  ind_completude_05_documentos <-
    calcular_ind_completude_05(dados_documentos, "documentos")

  ind_completude_05_representantes <-
    calcular_ind_completude_05(dados_representantes, "representantes")

  # ind_processavel_maquina_01 ---

  ind_processavel_maquina_01_agenda <-
    calcular_ind_processavel_maquina_01(
      dados_agenda,
      "agenda"
    )

  ind_processavel_maquina_01_atas <-
    calcular_ind_processavel_maquina_01(dados_atas, "atas")

  ind_processavel_maquina_01_deliberacoes <-
    calcular_ind_processavel_maquina_01(dados_deliberacoes, "deliberacoes")

  ind_processavel_maquina_01_documentos <-
    calcular_ind_processavel_maquina_01(dados_documentos, "documentos")

  ind_processavel_maquina_01_representantes <-
    calcular_ind_processavel_maquina_01(dados_representantes, "representantes")

  # ind_processavel_maquina_02_representantes ------
  # apenas para página de representantes
  # checar as páginas retornadas

  # ind_processavel_maquina_02_representantes <-
  #   calcular_ind_processavel_maquina_02_representantes(
  #     ano_calcular = ano_calcular_indicadores,
  #     mes_calcular = mes_calcular_indicadores
  #   )


  # ind_completude_06_representantes ---

  ind_completude_06_representantes <- calcular_ind_completude_06_representantes(dados_representantes)

  # ind_completude_07_representantes----
  ind_completude_07_representantes <- calcular_ind_completude_07_representantes(dados_representantes)

  # ind_processavel_maquina_03 -----

  # formato bat - potencialmente perigoso.
  # encontramos arquivo com senha: http://www.sigrh.sp.gov.br/admin/pageitems/252/documents
  # não faz sentido penalizar os documentos

  # ind_processavel_maquina_03_atas <- calcular_ind_processavel_maquina_03(dados_atas, "atas")
  #
  # ind_processavel_maquina_03_deliberacoes <- calcular_ind_processavel_maquina_03(dados_deliberacoes, "deliberacoes")



  # ind_tempestividade_01_representantes ---

  ind_tempestividade_01_representantes <- calcular_ind_tempestividade_01_representantes(
    ano_calcular = ano_calcular_indicadores,
    mes_calcular = mes_calcular_indicadores
  )

  # ind_tempestividade_02_03 ------

  ind_tempestividade_02_03_agenda <-
    calcular_ind_tempestividade_02_03(dados_agenda,
      col_data_atualizacao = "data_reuniao",
      col_nome = "agenda"
    )

  ind_tempestividade_02_03_atas <-
    calcular_ind_tempestividade_02_03(dados_atas,
      col_data_atualizacao = "data_postagem",
      col_nome = "atas"
    )

  ind_tempestividade_02_03_deliberacoes <-
    calcular_ind_tempestividade_02_03(dados_deliberacoes,
      col_data_atualizacao = "data_postagem",
      col_nome = "deliberacoes"
    )

  ind_tempestividade_02_03_documentos <-
    calcular_ind_tempestividade_02_03(dados_documentos,
      col_data_atualizacao = "data_postagem",
      col_nome = "documentos"
    )




  # tabela unida dos indicadores
  dados_aplicados <- ind_geral_01_02 |>
    dplyr::full_join(ind_completude_geral_01_02_03, by = "n_ugrhi") |>
    dplyr::full_join(ind_completude_04, by = "n_ugrhi") |>
    dplyr::full_join(ind_completude_05_agenda, by = "n_ugrhi") |>
    dplyr::full_join(ind_completude_05_atas, by = "n_ugrhi") |>
    dplyr::full_join(ind_completude_05_deliberacoes, by = "n_ugrhi") |>
    dplyr::full_join(ind_completude_05_documentos, by = "n_ugrhi") |>
    dplyr::full_join(ind_completude_05_representantes, by = "n_ugrhi") |>
    dplyr::full_join(ind_processavel_maquina_01_agenda, by = "n_ugrhi") |>
    dplyr::full_join(ind_processavel_maquina_01_atas, by = "n_ugrhi") |>
    dplyr::full_join(ind_processavel_maquina_01_deliberacoes, by = "n_ugrhi") |>
    dplyr::full_join(ind_processavel_maquina_01_documentos, by = "n_ugrhi") |>
    dplyr::full_join(ind_processavel_maquina_01_representantes, by = "n_ugrhi") |>
#   dplyr::full_join(ind_processavel_maquina_02_representantes, by = "n_ugrhi") |>
    dplyr::full_join(ind_completude_06_representantes, by = "n_ugrhi") |>
    dplyr::full_join(ind_completude_07_representantes, by = "n_ugrhi") |>
   # dplyr::full_join(ind_processavel_maquina_03_atas, by = "n_ugrhi") |>
  #  dplyr::full_join(ind_processavel_maquina_03_deliberacoes, by = "n_ugrhi") |>
    dplyr::full_join(ind_tempestividade_02_03_agenda, by = "n_ugrhi") |>
    dplyr::full_join(ind_tempestividade_02_03_atas, by = "n_ugrhi") |>
    dplyr::full_join(ind_tempestividade_02_03_deliberacoes, by = "n_ugrhi") |>
    dplyr::full_join(ind_tempestividade_02_03_documentos, by = "n_ugrhi") |>
    dplyr::full_join(ind_tempestividade_01_representantes, by = "n_ugrhi") |>
    dplyr::select(-tidyselect::contains("agencia")) |>
    dplyr::filter(n_ugrhi != 21) |>
    dplyr::mutate(
      mes_referencia = mes_calcular_indicadores,
      ano_referencia = ano_calcular_indicadores, .before = tidyselect::everything()
    )


  dados_aplicados
}
