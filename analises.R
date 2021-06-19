
# Lendo os pacotes --------------------------------------------------------

library(rethinking)
library(ggplot2)
library(ggExtra)


# Abrindo, criando um elemento (d) e visualizando a base ------------------

data("Howell1")

# Filtrando a idade (>18yr) -----------------------------------------------

d <- Howell1 |>
  dplyr::filter(age >= 18)

# Criando um grafico de dispersão -----------------------------------------

p <- d |>
  ggplot(mapping = aes(x = weight, y = height)) +
  geom_point(pch = 21, color = "white", fill = "black", size = 2, alpha = 0.8) +
  geom_smooth(method = "lm", color = "black", se = TRUE)+
  theme_bw(base_size = 12)


# Usando ggExtra para fazer grafico de dispersão com histograma -----------

ggMarginal(p, type = "histogram")


# Testando a relação entre as variaveis (lm) ------------------------------

mod1 <- lm(height ~ weight, data = d)

mod1











