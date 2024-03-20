devtools::load_all()
ind_resultados <- resultados_indicadores |>
  dplyr::select(tidyselect::starts_with("ind_")) |>
  # remove as colunas que tem variância igual a zero
  dplyr::select(where(~var(.x) != 0))


result_pca <- prcomp(ind_resultados)

scree_plot <- factoextra::fviz_eig(result_pca,
                     ylab = "Porcentagem das variâncias explicadas",
                     xlab = "Dimensões",
                     addlabels = TRUE)
ggplot2::ggsave(
  filename = "inst/tese/imagens/indice/diagnostico-pca-screeplot.jpeg",
  plot = scree_plot,
  device = "jpeg",
  dpi = 600,
  width = 8,
  height = 6
)

# ficou bom o scree plot!

# ver as variaveis importantes p/ cada dimensao
contrib_dim_1 <- factoextra::fviz_contrib(result_pca, "var", axes = 1, top = 5)
contrib_dim_2 <- factoextra::fviz_contrib(result_pca, "var", axes = 2, top = 5)
contrib_dim_3 <- factoextra::fviz_contrib(result_pca, "var", axes = 3, top = 5)

contribuicao_variaveis <- patchwork::wrap_plots(
  contrib_dim_1,
  contrib_dim_2,
  contrib_dim_3, ncol = 1
)

ggplot2::ggsave(
  filename = "inst/tese/imagens/indice/diagnostico-pca-contribuicao_variaveis.jpeg",
  plot = contribuicao_variaveis,
  device = "jpeg",
  dpi = 600,
  width = 10,
  height = 10
)


# colocar os dois!
pca_var <- factoextra::fviz_pca_var(result_pca,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping,
)



pca_var2 <- factoextra::fviz_pca_var(result_pca,
                         col.var = "contrib", # Color by contributions to the PC
                         gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                         select.var = list(cos2 = 0.05),
                         repel = TRUE     # Avoid text overlapping
)


pca_variaveis <- patchwork::wrap_plots(
  pca_var,
  pca_var2,
  ncol = 1
)+ patchwork::plot_annotation(tag_levels = 'I')

ggplot2::ggsave(
  filename = "inst/tese/imagens/indice/diagnostico-pca-var.jpeg",
  plot = pca_variaveis,
  device = "jpeg",
  dpi = 600,
  width = 8,
  height = 10
)


# interessante: mesmo na tempestividade tem uma certa
# multi dimensionalidade

# ideia: fazer isso por componente.
# pesquisar como fazer.
# factoextra::fviz_pca_var(result_pca,
#                          col.var = "contrib", # Color by contributions to the PC
#                          gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
#                          select.var = list(cos2 = 0.1),
#                          repel = TRUE     # Avoid text overlapping
# )



# está convergindo: remover a duplicacao de tempestividade
