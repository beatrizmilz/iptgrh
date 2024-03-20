# Pacotes utilizados
library(ggplot2)
source("inst/mapas/tema_mapa.R", encoding = "UTF-8")
devtools::load_all()

resultados_indice_org <- resultados_indice |>
  dplyr::mutate(
    referencia_temporal = paste0(mes_referencia, "/", ano_referencia),
    data = paste0(ano_referencia, "-", mes_referencia, "-01"),
    data = as.Date(data),
    referencia_temporal_cat = forcats::fct_reorder(
      referencia_temporal, data
    ))


dados_mapa <- tese::sp_ugrhi |>
  dplyr::left_join(resultados_indice_org, by = c("codigo" = "n_ugrhi"))


mapa_resultado_indice <- dados_mapa |>
  ggplot() +
  geom_sf(aes(fill = resultado)) +
  labs(fill = "Resultado",
       x = "Longitude",
       y = "Latitude") +
  facet_wrap(~referencia_temporal_cat, ncol = 1) +
  scale_fill_viridis_c(
    name = "Resultado",
    breaks = seq(0, 1, 0.05),
    direction = -1
  ) +
  tema_gg +
  annotation_scale(location = "br", width_hint = 0.20) +
  annotation_north_arrow(
    location = "tr",
    which_north = "true",
    height = unit(1, "cm"),
    width = unit(1, "cm"),
    pad_x = unit(0.1, "in"),
    pad_y = unit(0.3, "in"),
    style = north_arrow_fancy_orienteering
  ) +
  theme(legend.spacing.x = unit(1.0, 'cm'))


ggsave(
  "inst/book/assets/img/04-ipt-grh/mapa_resultado_indice.jpeg",
  plot = mapa_resultado_indice,
  device = "jpeg",
  dpi = 600,
  width = 6,
  height = 9
)
