# carregar funcoes
devtools::load_all()


resultados_0722 <-
  calcular_indicadores_cbh(mes_calcular_indicadores = 07,
                           ano_calcular_indicadores = 2022)

resultados_0123 <-
  calcular_indicadores_cbh(mes_calcular_indicadores = 01,
                           ano_calcular_indicadores = 2023)

resultados_0723 <-
  calcular_indicadores_cbh(mes_calcular_indicadores = 07,
                           ano_calcular_indicadores = 2023)

resultados_indicadores <- dplyr::bind_rows(resultados_0722,
                                      resultados_0123,
                                      resultados_0723) |>
  dplyr::mutate(
    dplyr::across(tidyselect::starts_with("ind_"), as.numeric)
  )


# checando se há NAs
resultados_com_na <- resultados_indicadores |>
  tidyr::pivot_longer(cols = tidyselect::starts_with("ind_")) |>
  dplyr::filter(is.na(value)) |>
  dplyr::arrange(name)

resultados_com_na |>
  dplyr::distinct(mes_referencia, ano_referencia, n_ugrhi, bacia_hidrografica, name)

# O ideal é que não tenha nenhum NA.
# Revisar caso apareça!


usethis::use_data(resultados_indicadores, overwrite = TRUE)

# Subir para o drive

# googlesheets4::sheet_write(
#   data = resultados_0722,
#   sheet = "indice_07-22",
#   ss = "https://docs.google.com/spreadsheets/d/10zHp_l2f2qYJGtGarxFFxRmrmdWGto75Ps-i_UZ8QZ4/edit?usp=sharing"
# )
#
#
# googlesheets4::sheet_write(
#   data = resultados_0123,
#   sheet = "indice_01-23",
#   ss = "https://docs.google.com/spreadsheets/d/10zHp_l2f2qYJGtGarxFFxRmrmdWGto75Ps-i_UZ8QZ4/edit?usp=sharing"
# )
#
# googlesheets4::sheet_write(
#   data = resultados_0723,
#   sheet = "indice_07-23",
#   ss = "https://docs.google.com/spreadsheets/d/10zHp_l2f2qYJGtGarxFFxRmrmdWGto75Ps-i_UZ8QZ4/edit?usp=sharing"
# )

