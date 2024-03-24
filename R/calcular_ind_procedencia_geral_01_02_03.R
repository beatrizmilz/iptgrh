calcular_ind_completude_01_02_03 <- function(ano_calcular,
                                              mes_calcular) {


  numero_sigla <- ComitesBaciaSP::comites_sp |>
    dplyr::select(sigla_comite, n_ugrhi)

  infos_comite_completo <-
    baixar_arquivo_releases("infos_comite_completo.rds") |>
    dplyr::left_join(numero_sigla, relationship = "many-to-many")

  dados_filtrados <- infos_comite_completo |>
    dplyr::filter(ano == ano_calcular, mes == mes_calcular) |>
    dplyr::arrange(data_coleta) |>
    dplyr::group_by(ano, mes, sigla_comite) |>
    dplyr::slice(1) |>
    dplyr::ungroup() |>
    dplyr::mutate(
      email_limpo = email |>
        stringr::str_remove("contato: ") |>
        stringr::str_trim(),
      telefone_detect = telefone |>
        stringr::str_remove_all("-") |>
        stringr::str_remove_all("\\.") |>
        stringr::str_detect("[0-9]{8}"),
      endereco_detect = endereco |>
        stringr::str_to_lower() |>
        stringr::str_detect("rua|av|r\\.|pça|largo")
    )

  base_safety_emails <- atualizar_emails_safety() |>
    dplyr::mutate(safety_emails = dplyr::if_else(status == "INVALIDO", 0, 1))



  dados_arrumados <- dados_filtrados |>
    dplyr::left_join(base_safety_emails, by = c("email_limpo" = "email")) |>
    dplyr::left_join(emails_cbh_validacao_manual, by = c("email_limpo" = "email"),
                     relationship = "many-to-many") |>
    dplyr::mutate(
      email_check = teste_email_valido(email_limpo),
      email_detect = dplyr::case_when(
        !is.na(novo_email) ~ 0.5,
        status_resposta == "respondido" ~ 1,
        status_resposta == "email_nao_encontrado" ~ 0,
        status_resposta == "resposta_automatica" ~ 0,
        is.na(status_resposta) & status == "INVALIDO" ~ 0,
        is.na(status_resposta) & email_check == FALSE ~ 0,
        is.na(status_resposta) &  email_check == TRUE ~ 0.25,

        # CASO TENHA NOVAS CATEGORIAS, IR ADICIONANDO AS REGRAS AQUI!
      )
    ) |>
    dplyr::arrange(desc(data_resposta)) |>
    dplyr::group_by(ano, mes, sigla_comite) |>
    dplyr::slice(1) |>
    dplyr::ungroup()


  emails_faltantes <- dados_arrumados |>
    dplyr::filter(is.na(safety_emails)) |>
    tidyr::drop_na(n_ugrhi) |>
    dplyr::select(email_limpo)

  if (nrow(emails_faltantes) > 0) {
    usethis::ui_todo("Testar os seguintes emails no safetymails:")
    print(emails_faltantes$email_limpo |>
      writeLines(sep = "\n"))
  }

  emails_nao_respondidos <- dados_arrumados |>
    dplyr::filter(is.na(status_resposta)) |>
    tidyr::drop_na(n_ugrhi) |>
    dplyr::select(email_limpo)

  if (nrow(emails_nao_respondidos) > 0) {
    usethis::ui_todo("Checar se os seguintes emails foram respondidos:")
    print(emails_nao_respondidos$email_limpo |>
            writeLines(sep = "\n"))
  }



  dados_arrumados |>
    dplyr::transmute(
      n_ugrhi,
      ind_completude_01_geral = as.numeric(endereco_detect),
      ind_completude_02_geral = as.numeric(telefone_detect),
      ind_completude_03_geral = as.numeric(email_detect)
    ) |>
    dplyr::select(n_ugrhi, tidyselect::starts_with("ind_"))
}


atualizar_emails_safety <- function() {
  here::here("inst/indice/safety_emails/") |>
    fs::dir_ls(regexp = "CopyandPaste.*csv") |>
    purrr::map(readr::read_csv2) |>
    purrr::list_rbind() |>
    janitor::clean_names() |>
    dplyr::distinct(email, .keep_all = TRUE)
}
