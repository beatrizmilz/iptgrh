devtools::load_all()

numero_sigla <- ComitesBaciaSP::comites_sp |>
  dplyr::select(sigla_comite, n_ugrhi, bacia_hidrografica)

todos_emails_comites <-
  baixar_arquivo_releases("infos_comite_completo.rds") |>
  dplyr::left_join(numero_sigla, relationship = "many-to-many") |>
  dplyr::mutate(email_limpo = email |>
                  stringr::str_remove("contato: ") |>
                  stringr::str_trim()) |>
  dplyr::distinct(sigla_comite, bacia_hidrografica, email_limpo, .keep_all = TRUE) |>
  dplyr::select(sigla_comite, bacia_hidrografica, email_limpo, n_ugrhi) |>
  tidyr::drop_na(n_ugrhi) |>
  dplyr::arrange(n_ugrhi)



emails_nao_respondidos <- todos_emails_comites |>
  dplyr::filter(!email_limpo %in% c(emails_cbh_validacao_manual$email))



# todos_emails_comites |>
#   readr::write_csv2("inst/indice/checagem_manual_emails/emails_11-06-2023.csv")

# enviar email

library(gmailr)


# AUTENTICACAO ------------------------------------------------------------
# Pegar as senhas no google cloud
# Use a função usethis::edit_r_environ() para adicionar as senhas abaixo no seu .Renviron


# configura o app
gm_auth_configure(
  path = "inst/indice/checagem_manual_emails/client_secret_185465654466-9mamud255u5sadjn4cveffp6cnvmlm3r.apps.googleusercontent.com.json"
  )

gm_auth()

# gmailr::gm_auth()

# gmailr::gm_deauth() # Caso seja necessário fazer logoff

# FUNCAO ------------------------------------------------------------------

enviar_email <- function(dados_comite){

  gm_message <- glue::glue(

    'Prezada equipe do CBH {dados_comite$bacia_hidrografica}, <br><br>
    Meu nome é <a href="http://lattes.cnpq.br/5150665880581477">Beatriz Milz</a>,
    sou doutoranda em
    <a href="http://www.iee.usp.br/?q=pt-br/programa-de-p%C3%B3s-gradua%C3%A7%C3%A3o-em-ci%C3%AAncia-ambiental">
    Ciência Ambiental no IEE/USP</a>, orientada pelo professor
    <a href="http://lattes.cnpq.br/6799067928413168">Dr. Pedro Roberto Jacobi</a>.<br><br>

    Estamos desenvolvendo uma pesquisa sobre transparência de informações na
    gestão de recursos hídricos usados para abastecimento público na
    Macrometrópole Paulista. <br><br>

    Encontramos o email <b>({dados_comite$email_limpo})</b> na página do
    comitê no SigRH (<a href="https://sigrh.sp.gov.br">https://sigrh.sp.gov.br</a>). <br>
    <b>Gostaríamos de saber se este é o endereço eletrônico correto do comitê, ou se devemos entrar
    em contato por outro email.</b>
<br><br>
Atenciosamente,<BR>
Beatriz Milz<br>
Doutoranda em Ciência Ambiental <br>
Universidade de São Paulo - Instituto de Energia e Ambiente
'
  )

  # Prepara a mensagem
  gm_rascunho <- gm_mime() %>%
    gm_to(dados_comite$email_limpo) %>%
    gm_cc("prjacobi@usp.br") |>
    gm_from("beatriz.milz@usp.br") %>%
    gm_subject(glue::glue('Contato CBH {stringr::str_to_upper(dados_comite$sigla_comite)} - Pesquisa IEE/USP')) %>%
    gm_html_body(gm_message)

  draft <- gm_create_draft(gm_rascunho)

  gm_send_draft(draft)
  # Envia a mensagem
  # gm_send_message()


  usethis::ui_done("Email enviado para: {dados_comite$sigla_comite}")


}



# enviar! -----------------------------------------------------------------

emails_nao_respondidos |>
  tibble::rowid_to_column() |>
  dplyr::group_split(rowid) |>
  purrr::map(enviar_email)




# safetymails <- atualizar_emails_safety()
#
#
# todos_emails_comites |>
#   dplyr::anti_join(safetymails, by = c("email_limpo" = "email")) |>
#   dplyr::pull(email_limpo) |>
#   writeLines(sep = "\n")
