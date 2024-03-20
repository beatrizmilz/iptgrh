devtools::load_all()

histograma_indice <- resultados_indice |>
  ggplot2::ggplot(ggplot2::aes(x = resultado)) +
  ggplot2::geom_histogram(binwidth = 0.05, color = "black", fill = "gray") +
  ggplot2::labs(
    title = "Histograma dos resultados do IPT-GRH",
    x = "Resultado",
    y = "Frequência"
  ) +
  ggplot2::theme_bw()  +
  ggplot2::scale_x_continuous(
    breaks = seq(0, 1, 0.05)
  )

ggplot2::ggsave(
  "inst/book/assets/img/04-ipt-grh/histograma_indice.jpeg",
  plot = histograma_indice,
  device = "jpeg",
  dpi = 600,
  width = 8,
  height = 6
)
