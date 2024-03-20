devtools::load_all()
library(ggplot2)

dados_prep <- resultados_indice |>
  dplyr::arrange(bacia_hidrografica, data_ref) |>
  dplyr::group_by(bacia_hidrografica) |>
  dplyr::mutate(
    desvio_padrao = sd(resultado),
  ) |>
  dplyr::ungroup() |>
  dplyr::mutate(
        tercil_1 = quantile(desvio_padrao, probs = 0.33),
        tercil_2 = quantile(desvio_padrao, probs = 0.66),
    categoria = dplyr::case_when(
      desvio_padrao < tercil_1 ~ "1 - Baixa ou nenhuma variação",
      desvio_padrao < tercil_2 ~ "2 - Média variação",
      desvio_padrao >= tercil_2 ~ "3 - Alta variação",
    )
  )

dados_prep_tail <- dados_prep |>
  dplyr::group_by(bacia_hidrografica) |>
  dplyr::slice_tail(n = 1)

fig_resultados_temporal <- dados_prep |>
  ggplot(aes(x = data_ref, y = resultado, color = as.factor(n_ugrhi)))  +
  geom_line(linewidth = 1, show.legend = FALSE) +
  geom_point(show.legend = FALSE) +
  ggrepel::geom_text_repel(aes(label = n_ugrhi), data = dados_prep_tail,
                           hjust = "right",
                            nudge_x = 20,
                           show.legend = FALSE) +
  facet_wrap(~categoria, ncol = 1) +
  scale_color_viridis_d(begin = 0, end = 0.8) +
  scale_x_date(
               date_labels = "%m/%Y",
               breaks = unique(dados_prep$data_ref),
               limits = c(min(dados_prep$data_ref), max(dados_prep$data_ref) + 20))  +
  theme_bw() +
  labs (
    x = "Data de referência de aplicação",
    y = "Resultado do IPT-GRH"
  )


ggsave(
  "inst/book/assets/img/04-ipt-grh/fig_resultados_temporal.jpeg",
  plot = fig_resultados_temporal,
  device = "jpeg",
  dpi = 600,
  width = 8,
  height = 10
)


