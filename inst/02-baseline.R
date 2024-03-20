devtools::load_all()
library(ggplot2)
agenda_completo <- ler_arquivos_piggyback("agenda_completo")
atas_completo <- ler_arquivos_piggyback("atas_completo")
deliberacoes_completo <- ler_arquivos_piggyback("deliberacoes_completo")
documentos_completo <- ler_arquivos_piggyback("documentos_completo")

data_param <- 180

agenda_completo |>
  dplyr::select(data_reuniao, n_ugrhi) |>
  dplyr::distinct() |>
  dplyr::arrange(n_ugrhi, data_reuniao) |>
  dplyr::filter(data_reuniao >= as.Date("2022-01-01")) |>
  dplyr::group_by(n_ugrhi) |>
  dplyr::mutate(diferenca_datas = data_reuniao - dplyr::lag(data_reuniao)) |>
  dplyr::ungroup() |>
  tidyr::drop_na(diferenca_datas) |>
  dplyr::mutate(dentro_param = diferenca_datas <= data_param) |>
  dplyr::count(dentro_param) |>
  dplyr::mutate(porc = n/sum(n))

atas_completo |>
  dplyr::select(data_postagem, n_ugrhi) |>
  dplyr::distinct() |>
  dplyr::arrange(n_ugrhi, data_postagem) |>
  dplyr::filter(data_postagem >= as.Date("2022-01-01")) |>
  dplyr::group_by(n_ugrhi) |>
  dplyr::mutate(diferenca_datas = data_postagem - dplyr::lag(data_postagem)) |>
  dplyr::ungroup() |>
  tidyr::drop_na(diferenca_datas) |>
  dplyr::mutate(dentro_param = diferenca_datas <= data_param) |>
  dplyr::count(dentro_param) |>
  dplyr::mutate(porc = n/sum(n))


deliberacoes_completo |>
  dplyr::select(data_postagem, n_ugrhi) |>
  dplyr::distinct() |>
  dplyr::mutate(data_postagem = readr::parse_date(data_postagem, "%d/%m/%Y")) |>
  dplyr::arrange(n_ugrhi, data_postagem) |>
  dplyr::filter(data_postagem >= as.Date("2022-01-01")) |>
  dplyr::group_by(n_ugrhi) |>
  dplyr::mutate(diferenca_datas = data_postagem - dplyr::lag(data_postagem)) |>
  dplyr::ungroup() |>
  tidyr::drop_na(diferenca_datas) |>
  dplyr::mutate(dentro_param = diferenca_datas <= data_param) |>
  dplyr::count(dentro_param) |>
  dplyr::mutate(porc = n/sum(n))


documentos_completo |>
  dplyr::select(data_postagem, n_ugrhi) |>
  dplyr::distinct() |>
  dplyr::mutate(data_postagem = readr::parse_date(data_postagem, "%d/%m/%Y")) |>
  dplyr::arrange(n_ugrhi, data_postagem) |>
  dplyr::filter(data_postagem >= as.Date("2022-01-01")) |>
  dplyr::group_by(n_ugrhi) |>
  dplyr::mutate(diferenca_datas = data_postagem - dplyr::lag(data_postagem)) |>
  dplyr::ungroup() |>
  tidyr::drop_na(diferenca_datas) |>
  dplyr::mutate(dentro_param = diferenca_datas <= data_param) |>
  dplyr::count(dentro_param) |>
  dplyr::mutate(porc = n/sum(n))


# Decisão do baseline para tempestividade - agenda: 3 meses
# Decisão do baseline para tempestividade - outros: 6 meses
