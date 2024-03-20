emails_cbh_validacao_manual <-
  tibble::tibble(
    email = "colegiado.cbhsmt@gmail.com",
    status_resposta = "resposta_automatica",
    novo_email = "fundacao@agenciasmt.com.br",
    data_envio_email = "2023-06-11",
    data_resposta = "2023-06-11"
  ) |>
  tibble::add_row(email = "comitesmg@netsite.com.br",
                  status_resposta = "email_nao_encontrado",
                  data_envio_email = "2023-06-11",
                  data_resposta = "2023-06-11") |>
  tibble::add_row(email = "secretaria@cbhap.org",
                  status_resposta = "respondido",
                  data_envio_email = "2023-06-11",
                  data_resposta = "2023-06-12") |>
  tibble::add_row(email = "secretaria@cbhmp.org",
                  status_resposta = "respondido",
                  data_envio_email = "2023-06-11",
                  data_resposta = "2023-06-12") |>
  tibble::add_row(email = "comitemogi@gmail.com",
                  status_resposta = "respondido",
                  data_envio_email = "2023-06-11",
                  data_resposta = "2023-06-12") |>
  tibble::add_row(email = "contato.cbhpp@gmail.com",
                  status_resposta = "respondido",
                  data_envio_email = "2023-06-11",
                  data_resposta = "2023-06-12") |>
  tibble::add_row(email = "cbh-bt@uol.com.br",
                  status_resposta = "respondido",
                  data_envio_email = "2023-06-11",
                  data_resposta = "2023-06-12") |>
  tibble::add_row(email = "comitepardo@yahoo.com.br",
                  status_resposta = "respondido",
                  data_envio_email = "2023-06-11",
                  data_resposta = "2023-06-12") |>
  tibble::add_row(email = "comiterb@gmail.com",
                  status_resposta = "respondido",
                  data_envio_email = "2023-06-11",
                  data_resposta = "2023-06-12") |>
  tibble::add_row(email = "cbhalpa@gmail.com",
                  status_resposta = "respondido",
                  data_envio_email = "2023-06-11",
                  data_resposta = "2023-06-12") |>
  tibble::add_row(email = "comitetietebatalha@gmail.com",
                  status_resposta = "respondido",
                  data_envio_email = "2023-06-11",
                  data_resposta = "2023-06-12") |>
  tibble::add_row(email = "secretaria@cbhsmg.com",
                  status_resposta = "respondido",
                  data_envio_email = "2023-06-11",
                  data_resposta = "2023-06-12") |>
  tibble::add_row(email = "comiteat@sp.gov.br",
                  status_resposta = "respondido",
                  data_envio_email = "2023-06-11",
                  data_resposta = "2023-06-12") |>
  tibble::add_row(email = "cbh-ps@comiteps.sp.gov.br",
                  status_resposta = "respondido",
                  data_envio_email = "2023-06-11",
                  data_resposta = "2023-06-12") |>
  tibble::add_row(email = "se.pcj@comites.baciaspcj.org.br",
                  status_resposta = "respondido",
                  data_envio_email = "2023-06-11",
                  data_resposta = "2023-06-13") |>
  tibble::add_row(email = "cbh.bpg@gmail.com",
                  status_resposta = "respondido",
                  data_envio_email = "2023-06-20",
                  data_resposta = "2023-06-21") |>
  tibble::add_row(email = "comitesjd@gmail.com",
                  status_resposta = "respondido",
                  data_envio_email = "2023-06-20",
                  data_resposta = "2023-06-21") |>
  tibble::add_row(email = "cbhbs@cbhbs.com.br",
                  status_resposta = "respondido",
                  data_envio_email = "2023-06-20",
                  data_resposta = "2023-06-21") |>
  tibble::add_row(email = "colegiado.cbhsmt@gmail.com",
                  status_resposta = "respondido",
                  data_envio_email = "2023-06-11",
                  data_resposta = "2023-09-14",
                  novo_email = "secretario@agenciasmt.com.br")






#
# Prezados,
# Muito obrigada pelo retorno !
# Atenciosamente
# Beatriz


# TO DO:
# Duvida: existe alguma página externa ao SIGRH onde existem informações sendo disponibilizadas?

# atualizado em 17/09
usethis::use_data(emails_cbh_validacao_manual, overwrite = TRUE)

