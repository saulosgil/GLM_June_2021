
<!-- README.md is generated from README.Rmd. Please edit that file -->

# GLM\_June\_2021

O objetivo deste projeto é treinar a criação de modelos de regressão
linear e criar gráficos de dispersão que apresentem paramêtros
relacionados a qualidade do modelo.

Para criação das figuras e modelos foi utilizada a base de dados Howell1
do pacote Rethinking (McElreath, 2016), que contém dados sobre 544
indivíduos, incluindo altura (centímetros), peso (quilogramas), idade
(anos) e sexo (0 indicando feminino e 1 indicando masculino).

``` r
# Lendo os pacotes --------------------------------------------------------

library(rethinking)
library(ggplot2)
library(ggExtra)
```

Após filtrar a base de dados apenas com os dados pertencentes aos
indíviduos com idade igual ou maior que 18 anos (&gt;=18), foi criado um
gráfico de dispersão utilizando o ggplot2 (i.e., geom\_point e
geom\_smooth). Um objeto foi criado com o gráfico (p). Em seguida, foi
utilizada a função ggMarginal do pacote ggExtra para criar um gráfico de
dispersão com os histogramas em cada um dos eixos.

``` r
# Abrindo, criando um elemento (d) e visualizando a base ------------------

data("Howell1")

# Filtrando a idade (>18yr) -----------------------------------------------

d <- Howell1 |>
  dplyr::filter(age >= 18)
```

``` r
# Criando um grafico de dispersão -----------------------------------------

p <- d |>
  ggplot(mapping = aes(x = weight, y = height)) +
  geom_point(pch = 21, color = "white", fill = "black", size = 2, alpha = 0.8) +
  geom_smooth(method = "lm", color = "black", se = TRUE)+
  theme_bw(base_size = 12)


# Usando ggExtra para fazer grafico de dispersão com histograma -----------

ggMarginal(p, type = "histogram")
```

<img src="README_files/figure-gfm/Grafico-1.png" style="display: block; margin: auto;" />

Uma rápida inspeção visual do conjunto de dados revela uma relação
positiva entre altura e peso.A linha da regressão traçada pode ser
fitted usando a seguinte expressão:

lm(height \~ weight, data = d)),

o qual o resultado será:

``` r
mod1 <- lm(height ~ weight, data = d)

mod1
#> 
#> Call:
#> lm(formula = height ~ weight, data = d)
#> 
#> Coefficients:
#> (Intercept)       weight  
#>     113.879        0.905
```

O intercept (i.e., 113.879) representa a altura prevista quando o peso
está em 0 (o que não faz muito sentido neste caso), enquanto o slope
(i.e., 0.905) representa a mudança na altura quando o peso aumenta em
uma unidade (e.g., um quilograma).
