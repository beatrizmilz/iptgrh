gerar_grafico_periodizacao <- function(dados, coluna_agrupar) {
  dados |>
    dplyr::select(
      -tidyselect::contains("online_gratuito"), -tidyselect::contains("nao_discriminacao"),
    ) |>
    dplyr::mutate(
      periodo_semestral = dplyr::case_when(
        mes_referencia %in% c(3, 4, 5, 6, 7, 8) ~ 1,
        mes_referencia %in% c(9, 10, 11, 12, 1, 2) ~ 2
      ),
      periodo_trimestral = dplyr::case_when(
        mes_referencia %in% c(3, 4, 5) ~ 1,
        mes_referencia %in% c(6, 7, 8) ~ 2,
        mes_referencia %in% c(9, 10, 11) ~ 3,
        mes_referencia %in% c(12, 1, 2) ~ 4
      ),
      periodo_anual = 1,
      sigla_comite = stringr::str_to_upper(sigla_comite)
    ) |>
    dplyr::rename(coluna_grupo = any_of(coluna_agrupar)) |>
    dplyr::group_by(coluna_grupo, sigla_comite) |>
    dplyr::summarise(dplyr::across(
      .cols = c(tidyselect::starts_with("ind_")),
      sd,
      na.rm = TRUE
    )) |>
    dplyr::ungroup() |>
    tidyr::pivot_longer(cols = tidyselect::starts_with("ind_")) |>
    dplyr::mutate(
      componente = stringr::str_remove(name, "ind_"),
      componente = stringr::str_extract(componente, ".*_0"),
      componente = stringr::str_remove(componente, "_0"),
      componente = stringr::str_to_title(componente),
      componente = dplyr::case_when(
        componente == "Processavel_maquina" ~ "Processável por máquina",
        componente == "Procedencia" ~ "Procedência",
        TRUE ~ componente
      )
    ) |>
    dplyr::group_by(componente) |>
    dplyr::mutate(qnt_componente = dplyr::n_distinct(name)) |>
    dplyr::ungroup() |>
    dplyr::group_by(coluna_grupo, sigla_comite, componente) |>
    dplyr::mutate(ordem = seq(1:dplyr::n())) |>
    dplyr::ungroup() |>
    dplyr::mutate(componente_label = glue::glue("{componente}\n({qnt_componente})")) |>
    dplyr::mutate(componente_label = forcats::fct_reorder(componente_label, -qnt_componente)) |>
    ggplot() +
    aes(x = ordem, y = sigla_comite) +
    geom_tile(aes(fill = value)) +
    facet_grid(vars(coluna_grupo),
      vars(componente_label),
      scales = "free_x",
      space = "free"
    ) +
    scale_fill_viridis_c() +
    scale_x_continuous(breaks = seq(1, 12, 1)) +
    theme_bw() +
    theme(
      axis.text.x = element_blank(),
      legend.position = "bottom"
    ) +
    labs(
      x = "Indicadores", y = "Sigla dos CBH",
      fill = "Desvio padrão dos indicadores"
    )
}
