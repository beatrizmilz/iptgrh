#' Ler arquivos do Piggyback
#'
#'
#' @param arquivo Nome do arquivo para fazer download
#' @param caminho_download Caminho onde será feito o download do arquivo
#' @param repositorio Repositório do GitHub onde o release foi criado
#' @param tag_release Nome da tag do release onde o arquivo está armazenado
#'
#' @return Tibble
#' @export
ler_arquivo_piggyback <- function(arquivo,
                                  caminho_download = "data-raw/dados_completos_sigrh/",
                                  repositorio = "beatrizmilz/iptgrh_scraper",
                                  tag_release = "dados") {

  # Criar a pasta para fazer download
  fs::dir_create(caminho_download)

  # Cria o caminho do arquivo
  arquivo_baixar <- glue::glue("{caminho_download}{arquivo}")

  # Verifica o tamanho do arquivo (caso ele exista!)
  # Isso é útil caso o arquivo já tenha sido baixado
  tamanho_arquivo <- fs::file_size(arquivo_baixar)


  # Se o arquivo não existir, ou se o tamanho for 0,
  # prosseguir e baixar o arquivo
  if (tamanho_arquivo == 0 | is.na(tamanho_arquivo)) {
    piggyback::pb_download(
      repo = repositorio,
      tag = tag_release,
      file = arquivo,
      dest = caminho_download
    )
  }

  # Ler os dados
  readr::read_rds(arquivo_baixar)
}
