# Não vou usar agora!
# calcular_ind_processavel_maquina_03 <- function(base, coluna) {
#   nome_coluna <- paste0("ind_processavel_maquina_03_", coluna)
#
#   base |>
#     dplyr::mutate(
#       formato_arquivo = tools::file_ext(url_link),
#       categoria_formato_arquivo = categorizar_formato_arquivo(formato_arquivo),
#       categoria_formato_arquivo = dplyr::case_when(
#         stringr::str_starts(url_link, "http") & categoria_formato_arquivo == "invalido" ~ "site_externo",
#         TRUE ~ categoria_formato_arquivo
#       ),
#       pontuacao = pontuar_categoria_arquivo(categoria_formato_arquivo)
#     ) |>
#     dplyr::group_by(orgao, comite, n_ugrhi) |>
#     dplyr::summarise(media = mean(pontuacao)) |>
#     dplyr::mutate("{nome_coluna}" := round((media + 1) / 2, 2)) |>
#     dplyr::ungroup() |>
#     dplyr::arrange(n_ugrhi) |>
#     dplyr::select(-media) |>
#     dplyr::select(n_ugrhi, tidyselect::starts_with("ind_"))
# }
#
#
# categorizar_formato_arquivo <- function(formato_arquivo) {
#   formato_arquivo <- formato_arquivo |> stringr::str_to_lower()
#   dplyr::case_when(
#     is.na(formato_arquivo) ~ "invalido",
#     formato_arquivo %in% c("doc", "docx", "rtf", "txt") ~ "texto",
#     formato_arquivo %in% c("pdf") ~ "pdf",
#     formato_arquivo %in% c("html", "htm", "mht") ~ "pagina_web",
#     formato_arquivo %in% c(
#       "jpg", "jpeg", "png", "ico",
#       "gif", "cdr", "dwg", "tiff"
#     ) ~ "imagem",
#     formato_arquivo %in% c("ppt", "pptx", "pps", "ppsx") ~ "apresentacao",
#     formato_arquivo %in% c("xls", "xlsx", "xlsb", "csv", "tsv") ~ "tabela",
#     formato_arquivo %in% c("zip", "rar", "7z") ~ "arquivo_compactado",
#     formato_arquivo %in% c("avi") ~ "video",
#     formato_arquivo %in% c("bat", "exe") ~ "executavel",
#     formato_arquivo %in% c("pd") ~ "invalido",
#     formato_arquivo %in% c("br") ~ "site_externo",
#     formato_arquivo %in% c("") ~ "invalido",
#     TRUE ~ "CATEGORIZAR"
#   )
# }
#
#
# pontuar_categoria_arquivo <- function(x) {
#   dplyr::case_when(
#     x %in% c("invalido", "executavel", "imagem") ~ -1,
#     x %in% c("apresentacao", "arquivo_compactado", "video", "site_externo") ~ 0,
#     x %in% c("tabela", "texto", "pdf", "pagina_web") ~ 1
#   )
# }
