ler_arquivos_piggyback <- function(base) {

  arquivo_baixar <- glue::glue("data-raw/dados_completos_sigrh/{base}.rds")

  # arquivo_existe <- fs::file_exists(arquivo_baixar)

  tamanho_arquivo <- fs::file_size(arquivo_baixar)



  if (tamanho_arquivo == 0 | is.na(tamanho_arquivo)) {
    piggyback::pb_download(
      repo = "beatrizmilz/iptgrh_scraper",
      tag = "dados",
      file = glue::glue("{base}.rds"),
      dest = "data-raw/dados_completos_sigrh/"
    )
  }

  readr::read_rds(arquivo_baixar)
}
