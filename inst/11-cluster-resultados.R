devtools::load_all()
library(ggplot2)
# clusters dos cbh

# para fazer o cluster, primeiro precisamos sumarizar
# a base para que ela fique no nível de ugrhi
# motivo: queremos entender como as ugrhi se agrupam,
# não como as ugrhi-período se agrupam.

# segunda coisa: para sumarizar, precisamos definir as métricas
# a mais simples seria a média, MAS você pode considerar também
# outras medidas de posição e variabilidade
# exemplos: variância, minimo, maximo, q50

# a base será uma linha por ugrhi

base_cluster <- resultados_indice |>
  dplyr::mutate(sigla_comite = stringr::str_to_upper(sigla_comite)) |>
  dplyr::group_by(sigla_comite) |>
  dplyr::summarise(
    media = mean(resultado),
    mediana = median(resultado),
    desvio_padrao = sd(resultado),
    min = min(resultado),
    max = max(resultado)
  ) |>
  tibble::column_to_rownames("sigla_comite")

# terceira coisa: o n é pequeno. isso sugere que uma
# analise de cluster hierarquico pode ser mais interessante.
# é visualmente mais legal,
# é mais fácil de interpretar.

# matriz de distancias (tecnica - euclidiana)

matriz_de_distancias <- dist(base_cluster)

# hclust - cluster-hierarquico

cluster_hierarquico <- hclust(matriz_de_distancias)

tab_clusters <- cutree(cluster_hierarquico, k = 3) |>
  tibble::as_tibble(rownames = "sigla_comite") |>
  dplyr::rename(cluster = value) |>
  dplyr::left_join(orgaos_sigrh)


# o dendrograma é uma visualização do cluster hierarquico
dendograma <- factoextra::fviz_dend(cluster_hierarquico,
                      h = 0.3, # altura do corte, para definir o numero de grupos)
                      k_colors = viridis::viridis(3, end = 0.8))
ggsave(
  "inst/book/assets/img/04-ipt-grh/cluster_dendograma.jpeg",
  plot = dendograma,
  device = "jpeg",
  dpi = 600,
  width = 8,
  height = 6
)



# ideia
# fazer um mapa por grupo de cluster
# tirar estatisticas descritivas por grupo (media, etc)
# tentar entender o que deixa eles nos mesmos grupos
# e que tipo de ações poderíamos pensar para cada um


# E O CLUSTER CONSIDERANDO OS INDICADORES?
#
# resultados_indicadores |> names()
#
#
# base_cluster_indicadores <- resultados_indicadores |>
#   tidyr::pivot_longer(
#     cols = starts_with("ind_"),
#     names_to = "indicador",
#     values_to = "resultado"
#   ) |>
#   dplyr::mutate(sigla_comite = stringr::str_to_upper(sigla_comite),
#                 dimensao = stringr::str_extract(indicador, pattern = "ind_(.*)_0") |>
#                   stringr::str_remove("ind_") |>
#                   stringr::str_remove("_0$")) |>
#   dplyr::group_by(sigla_comite, dimensao) |>
#   dplyr::summarise(
#     media = mean(resultado),
#   #  mediana = median(resultado),
#     desvio_padrao = sd(resultado),
#   #  min = min(resultado),
#    # max = max(resultado)
#   ) |>
#   dplyr::ungroup() |>
#   tidyr::pivot_wider(
#     names_from = dimensao,
#     values_from = c(media,desvio_padrao)
#   ) |>
#   tibble::column_to_rownames("sigla_comite") |>
#   dplyr::select(where(~var(.x) != 0))
#
#
# matriz_de_distancias_indicadores <- dist(base_cluster_indicadores)
#
# # hclust - cluster-hierarquico
#
# cluster_hierarquico_indicadores <- hclust(matriz_de_distancias_indicadores)
#
# tab_clusters_indicadores <- cutree(cluster_hierarquico_indicadores, k = 4) |>
#   tibble::as_tibble(rownames = "sigla_comite") |>
#   dplyr::rename(cluster = value)
#
#
#
# # o dendrograma é uma visualização do cluster hierarquico
# dendograma_indicadores <- factoextra::fviz_dend(cluster_hierarquico_indicadores,
#                                     h = 0.6, # altura do corte, para definir o numero de grupos
# )
