# Por enquanto, não irei usar.
# calcular_ind_processavel_maquina_02_representantes <- function(ano_calcular,
#                                                                mes_calcular,
#                                                                caminho = "../RelatoriosTransparenciaAguaSP/inst/dados_html/") {
#   caminho_mes_ano <-
#     glue::glue("{caminho}{ano_calcular}/{mes_calcular}/")
#
#   numero_sigla <- ComitesBaciaSP::comites_sp |>
#     dplyr::select(sigla_comite, n_ugrhi)
#
#   arquivos_representantes <- fs::dir_ls(caminho_mes_ano,
#     regexp = ".*representantes.*"
#   )
#
#   resultado <- arquivos_representantes |>
#     tibble::as_tibble() |>
#     dplyr::mutate(nome_arquivo = basename(value) |>
#       stringr::str_remove(".html$")) |>
#     tidyr::separate(
#       nome_arquivo,
#       sep = "-",
#       into =
#         c("sigla_comite", "pagina", "dia", "mes", "ano")
#     ) |>
#     dplyr::left_join(numero_sigla, by = "sigla_comite", relationship = "many-to-many") |>
#     dplyr::arrange(n_ugrhi, dia, mes, ano) |>
#     dplyr::group_by(n_ugrhi) |>
#     dplyr::slice(1) |>
#     dplyr::ungroup() |>
#     tidyr::drop_na(n_ugrhi) |>
#     dplyr::mutate(
#       detect_atualizacao = purrr::map_chr(value, parse_representante_download),
#       atualizacao_formato = dplyr::case_when(
#         detect_atualizacao != "0" ~ tools::file_ext(detect_atualizacao),
#         TRUE ~ "0"
#       ),
#       ind_processavel_maquina_02_representantes = dplyr::case_when(
#         atualizacao_formato == "0" ~ 0,
#         atualizacao_formato == "pdf" ~ 0.5,
#         atualizacao_formato %in% c("xls", "xlsx") ~ 0.75,
#         atualizacao_formato %in% c("csv", "tsv", "json", "xml") ~ 1,
#       )
#     ) |>
#     dplyr::select(sigla_comite, n_ugrhi, detect_atualizacao, ind_processavel_maquina_02_representantes) |>
#     dplyr::select(n_ugrhi, tidyselect::starts_with("ind_"))
# }
#
# parse_representante_download <- function(x) {
#
#   result <- x |>
#     xml2::read_html(encoding = "UTF-8") |>
#     rvest::html_nodes("div.col_right") |>
#     rvest::html_nodes("a") |>
#     rvest::html_attr("href")
#
#
#   # ATENÇÃO
#   # Pode ser que aqui tenhamos que aprimorar com o tempo.
#   result_sem_links_fixos <- result |>
#     stringr::str_remove("https://twitter.com/share") |>
#     stringr::str_remove("https://comiteat.sp.gov.br/o-comite/institucional/representantes/") |>
#     stringr::str_remove(".*url_to_share=.*")
#
#
#   result_final <- result_sem_links_fixos |>
#     purrr::discard(.p = ~ .x == "")
#
#   if (length(result_final) == 0) {
#     result_final <- "0"
#   }
#   result_final
# }
