calcular_ind_tempestividade_01_representantes <- function(ano_calcular,
                                                       mes_calcular,
                                                       caminho = "../iptgrh_scraper/inst/dados_html/") {
  caminho_mes_ano <-
    glue::glue("{caminho}{ano_calcular}/{mes_calcular}/")

  numero_sigla <- ComitesBaciaSP::comites_sp |>
    dplyr::select(sigla_comite, n_ugrhi)

  arquivos_representantes <- fs::dir_ls(caminho_mes_ano,
    regexp = ".*representantes.*"
  )

  resultado <- arquivos_representantes |>
    tibble::as_tibble() |>
    dplyr::mutate(nome_arquivo = basename(value) |>
      stringr::str_remove(".html$")) |>
    tidyr::separate(
      nome_arquivo,
      sep = "-",
      into =
        c("sigla_comite", "pagina", "dia", "mes", "ano")
    ) |>
    dplyr::left_join(numero_sigla, by = "sigla_comite", relationship = "many-to-many") |>
    dplyr::arrange(n_ugrhi, dia, mes, ano) |>
    dplyr::group_by(n_ugrhi) |>
    dplyr::slice(1) |>
    dplyr::ungroup() |>
    dplyr::mutate(detect_atualizacao = purrr::map_lgl(value, parse_representante_atualizacao))


  resultado |>
    dplyr::mutate(
      ind_tempestividade_01_representantes = dplyr::case_when(
        is.na(detect_atualizacao) ~ 0,
        detect_atualizacao == FALSE ~ 0,
        detect_atualizacao == TRUE ~ 1
      )
    ) |>
    dplyr::select(sigla_comite, n_ugrhi, ind_tempestividade_01_representantes) |>
    dplyr::select(n_ugrhi, tidyselect::starts_with("ind_"))
}

parse_representante_atualizacao <- function(x) {
  result <- x |>
    xml2::read_html(encoding = "UTF-8") |>
    rvest::html_nodes("div.col_right") |>
    rvest::html_text() |>
    stringr::str_to_lower() |>
    stringr::str_detect("data|atualização|atualizacao|atualizado")

  # só será verdadeiro se não é nulo, e é verdadeiro
  result_final <- !is.null(result) && result
  result_final
}
