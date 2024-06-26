% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/baixar_arquivo_releases.R
\name{ler_arquivo_releases}
\alias{ler_arquivo_releases}
\title{Ler arquivo armazenado em um Release no GitHub}
\usage{
ler_arquivo_releases(
  arquivo,
  caminho_download = "data-raw/dados_completos_sigrh/",
  repositorio = "beatrizmilz/iptgrh_scraper",
  tag_release = "dados"
)
}
\arguments{
\item{arquivo}{Nome do arquivo para fazer download}

\item{caminho_download}{Caminho onde será feito o download do arquivo}

\item{repositorio}{Repositório do GitHub onde o release foi criado}

\item{tag_release}{Nome da tag do release onde o arquivo está armazenado}
}
\value{
Tibble
}
\description{
Ler arquivo armazenado em um Release no GitHub
}
