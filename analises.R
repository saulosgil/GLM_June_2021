
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

# Fazendo predições e ajustes  --------------------------------------------

# Peso alvo - 43 kg

wght <- 43

# Fazendo gráfico com linhas referentes ao peso que queremos preve --------

d |>
  ggplot(mapping = aes(x = weight, y = height)) +
  geom_line(mapping = aes(y = predict(mod1)), size = 1) +
  geom_point(size = 2, alpha = .2) +
  geom_segment(
    x = wght,
    xend = wght,
    y = 0,
    yend = predict(mod1, newdata = data.frame(weight = wght)),
    linetype = 2,
    lwd = 0.5
  ) +
  geom_segment(
    x = 0,
    xend = wght,
    y = predict(mod1, newdata = data.frame(weight = wght)),
    yend = predict(mod1, newdata = data.frame(weight = wght)),
    linetype = 2,
    lwd = 0.5
  ) +
  theme_bw(base_size = 12)

# Aplicando a função predict ----------------------------------------------

d <-  d |>
  dplyr::mutate(
    pred_mod1 = predict(mod1),
    pred_mod1_2 = coef(mod1)[1] + coef(mod1)[2] * weight
  )

head(d)

# Aplicando a função glm para fazer uma regressão logística ---------------

mod2 <-
  glm(male ~ height,
      data = d,
      family = binomial(link = "logit"))


# Aplicado o modelo para predizer o sexo pela estatura usando a predict----
# e fitted ----------------------------------------------------------------

d <-
  d |>
  dplyr::mutate(
    pred_mod2 = predict(mod2),
    fitted_mod2 = fitted(mod2)
  )

# Selecionando e vendo o resultado ----------------------------------------

d |>
  dplyr::select(height, weight, male, pred_mod2, fitted_mod2) |>
  head()

# Pegando a função log_dotplot e criando um plot --------------------------

source("logit_dotplot.R")

logit_dotplot(d$height, d$male, xlab = "height", ylab = "p(male)")

# Calculando os residuos --------------------------------------------------

d <- d |>
  dplyr::mutate(
    res1 = residuals(mod1),
    res2 = height - pred_mod1
  )

d |>
  dplyr::select(height, weight, male, pred_mod1, res1, res2) |>
  head()

# Fazendo um plot dos residuos --------------------------------------------

d |>
  dplyr::slice_sample(prop = 0.5) |>
  ggplot(mapping = aes(x = weight,
                       y = height)) +
  geom_line(mapping = aes(y = pred_mod1), size = 1) +
  geom_point(mapping = aes(alpha = abs(res1),
                           size = abs(res1))) +
  guides(alpha = "none", size = "none") +
  geom_segment(mapping = aes(xend = weight,
                             yend = pred_mod1,
                             alpha = abs(res1))) +
  theme_bw(base_size = 12)

# Distribuição dos resíduos -----------------------------------------------

d |>
  ggplot(mapping = aes(x = res1)) +
  geom_histogram(mapping = aes(y = ..density..), bins = 20,
                 alpha = 0.6) +
  geom_line(aes(y = dnorm(res1, mean = 0, sd = sd(res1))),
            size = 1) +
  guides(fill = "none") +
  theme_bw(base_size = 12) +
  labs(x = "Residuals", y = "Density")







