ler_arquivos_piggyback <- function(base,
                                   caminho_download = "data-raw/dados_completos_sigrh/") {

  # Cria o caminho do arquivo
  arquivo_baixar <- glue::glue("{caminho_download}{base}.rds")

  # Verifica o tamanho do arquivo.
  # Isso é útil caso o arquivo já tenha sido baixado
  tamanho_arquivo <- fs::file_size(arquivo_baixar)


  # Se o arquivo não existir, ou se o tamanho for 0,
  # prosseguir e baixar o arquivo
  if (tamanho_arquivo == 0 | is.na(tamanho_arquivo)) {
    piggyback::pb_download(
      repo = "beatrizmilz/iptgrh_scraper",
      tag = "dados",
      file = glue::glue("{base}.rds"),
      dest = caminho_download
    )
  }

  # Ler os dados
  readr::read_rds(arquivo_baixar)
}
