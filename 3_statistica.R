###############################################################################
###                      Lucrare de licență - Curcă Maria Codrina           ###
###                                 3. Statistica
### ultima actualizare: 2026-06-22
###############################################################################

library(readxl)
base_dir <- 'C:/Users/Codrina/Dropbox/curca_maria/data_sets_licenta/toate'
setwd(base_dir)
df_clean <- read_excel('df_clean.xlsx')

library(tidyverse)
library(ggstatsplot)
install.packages("ggrepel")
library(ggrepel)

#install.packages("devtools")
library(devtools)
devtools::install_github("slowkow/ggrepel")

#######################################################################
###       RQ1: exista corelatie intre an si media temp?

##pt a vedea daca testul de corelatie folosit va fi parametric sau neparametric trebuie sa
#testam normalitatea distributiei celor 2 variabile
#ipoteza nula a testului de normalitate este ca distributia este normala

shapiro.test(sample(df_clean$avg_temp, 5000))
#pt ca p value esre mult sup pragul de 0.05 ip nula este respinsa, adica distr nu este normala
#in concluzie, vom folosi un test de corelatie neparametric


##  
##  H0: variabilele `year` si `avg_temp` nu sunt corelate
##
##
# parametric correlation coefficient
p_rq1 <- ggscatterstats(
  data = df_clean,
  x = year,
  y = avg_temp, 
  type = "np"
)

print(p_rq1)

ggsave("fig_rq1_an_vs_temp.png", plot = p_rq1,
       width = 20, height = 14, units = "cm", dpi = 300)
#p value este 6.29 * 10^-31, mult sub pragul de semnificatie de 0.05.
#rez ca ip nula va fi respinsa, cele doua sunt corelate
#marimea efectului (coef de corelatie spearman) indica intensitatea leg

effectsize::interpret_r(0.10)
#marimea ef de corelatie este 0.10, califacat de pachetul effectsize de int mica

# non-parametric correlation coefficient

p_rq1b <- ggscatterstats(
  data = df_clean,
  x = year,
  y = diff_temp, 
  type = "np"
)

print(p_rq1b)

ggsave("fig_rq1b_an_vs_diff_temp.png", plot = p_rq1b,
       width = 20, height = 14, units = "cm", dpi = 300)

###    RQ2: exista diferente intre regiune in privinta modificarii temp medii anuale?

p_rq2 <- ggbetweenstats(
  data = df_clean,
  x = world_region,
  y = diff_temp,
  plot.type = "boxviolin",
  type = "np"
)

print(p_rq2)

ggsave("fig_rq2_regiune_vs_diff_temp.png", plot = p_rq2,
       width = 20, height = 14, units = "cm", dpi = 300)

## p-value = 3.05e-03, sub pragul de semnificatie de 0.05, deci ipoteza nula este respinsa
# cele doua variabile sunt corelate statistic semnificativ
# coeficientul Spearman = 0.03, clasificat ca efect foarte mic
# concluzie: desi exista o corelatie semnificativa intre an si variatia temperaturii,
# intensitatea legaturii este neglijabila

#######################################################################
###       RQ3: exista corelatie intre emisiile anuale de CO2 si media temp?

shapiro.test(sample(df_clean$annual_co2_emissions, 5000))
# daca p < 0.05, distributia nu este normala > test neparametric
#p-value < 2.2e-16, deci distributia nu este normala si se foloseste testul neparametric Spearman

##
##  H0: variabilele `annual_co2_emissions` si `avg_temp` nu sunt corelate
##

p_rq3 <- ggscatterstats(
  data = df_clean,
  x = annual_co2_emissions,
  y = avg_temp,
  type = "np"
)

print(p_rq3)

ggsave("fig_rq3_co2_vs_temp.png", plot = p_rq3,
       width = 20, height = 14, units = "cm", dpi = 300)

# p-value = 2.23e-308, mult sub pragul de 0.05, deci ipoteza nula este respinsa
# cele doua variabile sunt corelate statistic semnificativ
# coeficientul Spearman = -0.44, indica o corelatie negativa moderata
# concluzie: tarile cu emisii mai mari de CO2 tind sa aiba temperaturi medii mai scazute
# acest rezultat aparent contraintuitiv se explica prin faptul ca tarile mari industrial
# sunt situate in zone geografice cu climate mai reci (emisfera nordica)

#######################################################################
###       RQ4: exista diferente intre regiuni in privinta emisiilor de CO2 per capita?

##
##  H0: nu exista diferente semnificative intre regiuni in privinta `annual_co2_emissions_per_capita`
##

p_rq4 <- ggbetweenstats(
  data = df_clean,
  x = world_region,
  y = annual_co2_emissions_per_capita,
  plot.type = "boxviolin",
  type = "np"
)

print(p_rq4)

ggsave("fig_rq4_regiune_vs_co2_per_capita.png", plot = p_rq4,
       width = 20, height = 14, units = "cm", dpi = 300)
 
# test Kruskal-Wallis: chi^2(5) = 5387.72, p = 2.23e-308
# p-value mult sub 0.05, deci ipoteza nula este respinsa
# exista diferente semnificative intre regiuni in privinta emisiilor de CO2 per capita
# marimea efectului epsilon^2 = 0.41, efect mare
# Europa are cea mai mare mediana (6.71), urmata de Asia (2.19) si America de Nord (1.82)
# Africa are cea mai mica mediana (0.23), ceea ce reflecta nivelul scazut de industrializare
# testele post-hoc Dunn confirma ca aproape toate perechile de regiuni difera semnificativ

#######################################################################
###       RQ5: exista corelatie intre concentratia atmosferica de CO2 si media temp?

shapiro.test(sample(df_clean$annual_co2_concentration[!is.na(df_clean$annual_co2_concentration)], 5000))

##
##  H0: variabilele `annual_co2_concentration` si `avg_temp` nu sunt corelate
##

p_rq5 <- ggscatterstats(
  data = df_clean,
  x = annual_co2_concentration,
  y = avg_temp,
  type = "np"
)
print(p_rq5)

ggsave("fig_rq5_co2_concentratie_vs_temp.png", plot = p_rq5,
       width = 20, height = 14, units = "cm", dpi = 300)

# p-value = 6.55e-28, mult sub pragul de 0.05, deci ipoteza nula este respinsa
# cele doua variabile sunt corelate statistic semnificativ
# coeficientul Spearman = 0.10, efect mic
# concluzie: exista o corelatie pozitiva slaba intre concentratia atmosferica de CO2
# si temperatura medie — pe masura ce concentratia creste, temperatura creste usor
# intensitatea redusa a efectului sugereaza ca temperatura medie este influentata
# si de alti factori in afara concentratiei de CO2

#######################################################################
###       RQ6: exista corelatie intre utilizarea ingrasamintelor si randamentul cerealelor?

shapiro.test(sample(df_clean$fertilizer_per_ha[!is.na(df_clean$fertilizer_per_ha)], 5000))

##
##  H0: variabilele `fertilizer_per_ha` si `cereal_yield_tonnes_per_ha` nu sunt corelate
##

p_rq6 <- ggscatterstats(
  data = df_clean,
  x = fertilizer_per_ha,
  y = cereal_yield_tonnes_per_ha,
  type = "np"
)

print(p_rq6)

ggsave("fig_rq6_ingrasaminte_vs_randament.png", plot = p_rq6,
       width = 20, height = 14, units = "cm", dpi = 300)

# p-value = 2.23e-308, mult sub pragul de semnificatie de 0.05, deci ipoteza nula este respinsa
# cele doua variabile sunt corelate statistic semnificativ
# coeficientul Spearman = 0.76, indica o corelatie pozitiva puternica
# concluzie: tarile care utilizeaza mai multe ingrasaminte per hectar obtin
# randamente mai mari la culturile de cereale
# aceasta este cea mai puternica corelatie identificata in studiu

#######################################################################
###       RQ7: exista corelatie intre cresterea PIB si cresterea emisiilor de CO2?

shapiro.test(sample(df_clean$gdp_growth_annual_pct[!is.na(df_clean$gdp_growth_annual_pct)], 5000))

##
##  H0: variabilele `gdp_growth_annual_pct` si `annual_co2_growth_pct` nu sunt corelate
##

p_rq7 <- ggscatterstats(
  data = df_clean,
  x = gdp_growth_annual_pct,
  y = annual_co2_growth_pct,
  type = "np"
)

print(p_rq7)

ggsave("fig_rq7_pib_vs_co2_growth.png", plot = p_rq7,
       width = 20, height = 14, units = "cm", dpi = 300)

# p-value = 5.23e-212, mult sub pragul de semnificatie de 0.05, deci ipoteza nula este respinsa
# cele doua variabile sunt corelate statistic semnificativ
# coeficientul Spearman = 0.31, indica o corelatie pozitiva moderata
# concluzie: tarile cu o crestere economica mai rapida tind sa inregistreze
# si o crestere mai mare a emisiilor de CO2
# prezenta valorilor extreme sugereaza ca relatia nu este liniara si uniforma

#######################################################################
###       RQ8: exista diferente intre regiuni in privinta energiei regenerabile?

##
##  H0: nu exista diferente semnificative intre regiuni in privinta `renewable_value`
##

p_rq8 <- ggbetweenstats(
  data = df_clean,
  x = world_region,
  y = renewable_value,
  plot.type = "boxviolin",
  type = "np"
)

print(p_rq8)

ggsave("fig_rq8_regiune_vs_renewable.png", plot = p_rq8,
       width = 20, height = 14, units = "cm", dpi = 300)

# test Kruskal-Wallis: chi^2(5) = 1400.16, p = 1.27e-300
# p-value mult sub 0.05, deci ipoteza nula este respinsa
# exista diferente semnificative intre regiuni in privinta utilizarii energiei regenerabile
# marimea efectului epsilon^2 = 0.32, efect mare
# America de Sud are cea mai mare mediana (53584.73), urmata de Europa (43037.98) si Asia (33837.53)
# Africa are cea mai mica mediana (1701.71), reflectand accesul limitat la infrastructura verde


#######################################################################
###       RQ9: exista corelatie intre taxele ecologice si emisiile de CO2 per capita?

shapiro.test(sample(df_clean$env_tax[!is.na(df_clean$env_tax)], 
                    min(5000, sum(!is.na(df_clean$env_tax)))))

##
##  H0: variabilele `env_tax` si `annual_co2_emissions_per_capita` nu sunt corelate
##

p_rq9 <- ggscatterstats(
  data = df_clean,
  x = env_tax,
  y = annual_co2_emissions_per_capita,
  type = "np"
)

print(p_rq9)

ggsave("fig_rq9_env_tax_vs_co2_per_capita.png", plot = p_rq9,
       width = 20, height = 14, units = "cm", dpi = 300)

# p-value = 1.76e-28, mult sub pragul de semnificatie de 0.05, deci ipoteza nula este respinsa
# cele doua variabile sunt corelate statistic semnificativ
# coeficientul Spearman = 0.19, indica o corelatie pozitiva slaba
# concluzie: tarile cu taxe ecologice mai mari tind sa aiba emisii per capita
# usor mai ridicate, ceea ce poate parea contraintuitiv, insa se explica prin faptul ca
# tarile dezvoltate industrial platesc mai multe taxe ecologice si emit totodata
# mai mult CO2 per locuitor fata de tarile mai putin dezvoltate

#######################################################################
###    RQ10: exista corelatie intre cheltuielile de mediu si emisiile de CO2 per capita?

shapiro.test(sample(df_clean$expenditure[!is.na(df_clean$expenditure)], 
                    min(5000, sum(!is.na(df_clean$expenditure)))))

p_rq10 <- ggscatterstats(
  data = df_clean,
  x = expenditure,
  y = annual_co2_emissions_per_capita,
  type = "np"
)

print(p_rq10)

ggsave("fig_rq10_expenditure_vs_co2_per_capita.png", plot = p_rq10,
       width = 20, height = 14, units = "cm", dpi = 300)

# p-value = 3.73e-86, mult sub pragul de semnificatie de 0.05, deci ipoteza nula este respinsa
# cele doua variabile sunt corelate statistic semnificativ
# coeficientul Spearman = 0.36, indica o corelatie pozitiva moderata
# concluzie: tarile cu cheltuieli publice mai mari pentru protectia mediului
# tind sa aiba emisii per capita mai ridicate, similar cu RQ9
# acest rezultat aparent paradoxal se explica prin faptul ca tarile dezvoltate
# economic aloca mai multe resurse financiare pentru mediu, insa emit totodata
# mai mult CO2 per locuitor datorita nivelului ridicat de industrializare
# linia de tendinta descrescatoare spre dreapta sugereaza totusi ca la cheltuieli
# foarte mari efectul de reducere a emisiilor incepe sa se manifeste

######################################################################
###   RQ11: in ce masura concentratia de CO2 si emisiile din utilizarea terenurilor explica variatia temperaturii?


##
##  H0: Concentratia de CO2 și emisiile provenite din utilizarea terenurilor nu influenteaza temperatura medie anuala.
##

# Model 1
model_temp <- lm(avg_temp ~ annual_co2_concentration + annual_co2_emissions_land_use, data = df_clean)
summary(model_temp)

# ambii predictori sunt semnificativi statistic (p < 0.05)
# concentratia de CO2 (coef = 1.808e-02, p = 1.22e-14): cresterea concentratiei 
# atmosferice de CO2 este asociata cu o crestere usoara a temperaturii medii
# emisiile din utilizarea terenurilor (coef = 1.808e-09, p = 0.000374): au un efect
# pozitiv semnificativ, insa de amplitudine foarte mica
# R-squared = 0.0059 — modelul explica doar 0.59% din variatia temperaturii
# concluzie: desi ambii predictori sunt semnificativi statistic, puterea explicativa
# a modelului este foarte scazuta, ceea ce sugereaza ca temperatura medie este
# influentata de multi alti factori neincorporati in model

######################################################################
###   RQ12: Cum influenteaza cresterea economica (PIB) si utilizarea combustibililor fosili emisiile individuale?

##
##  H0: Cresterea PIB-ului și consumul de combustibili fosili nu explica variatia emisiilor de CO2 pe cap de locuitor.
##

# Model 2
model_emissions <- lm(annual_co2_emissions_per_capita ~ gdp_growth_annual_pct + fossil_fuels_t_wh, data = df_clean)
summary(model_emissions)

# ambii predictori sunt semnificativi statistic (p < 0.05)
# cresterea PIB (coef = -7.547e-02, p = 0.0046): efect negativ semnificativ —
# o crestere economica mai rapida este asociata cu emisii per capita usor mai mici
# consumul de combustibili fosili (coef = 2.957e-04, p = 3.34e-10): efect pozitiv
# semnificativ — tarile cu consum mai mare de fosile emit mai mult CO2 per capita
# R-squared = 0.0116 — modelul explica doar 1.16% din variatie
# concluzie: consumul de combustibili fosili are o influenta pozitiva semnificativa
# asupra emisiilor per capita, insa modelul are o putere explicativa redusa

######################################################################
###   RQ13: Cat de mult conteaza ingrasamintele fata de suprafata cultivata pentru productivitate?

##
##  H0: Cantitatea de ingrasaminte utilizata si suprafata recoltata nu au un efect semnificativ asupra randamentului culturilor de cereale.
##

# Model 3
model_agri <- lm(cereal_yield_tonnes_per_ha ~ fertilizer_per_ha + cereal_area_harvested_ha, data = df_clean)
summary(model_agri)

# fertilizer_per_ha este semnificativ (coef = 2.529e-02, p < 2e-16):
# fiecare unitate suplimentara de ingrasamant per hectar creste randamentul cu 0.025 tone/ha
# cereal_area_harvested_ha NU este semnificativ (p = 0.668):
# suprafata recoltata nu influenteaza semnificativ randamentul
# R-squared = 0.319 — modelul explica 31.9% din variatia randamentului
# concluzie: cantitatea de ingrasaminte este determinanta pentru productivitatea agricola,
# in timp ce suprafata cultivata nu are un efect semnificativ

######################################################################
###   RQ14: Taxele ecologice, cheltuielile de mediu si energia regenerabila reusesc sa reduca emisiile de CO2?

##
##  H0: Taxele ecologice, cheltuielile publice pentru mediu si energia regenerabila nu contribuie la reducerea emisiilor totale de CO2.
##

# Model 4
model_policy <- lm(annual_co2_emissions ~ env_tax + expenditure + renewable_value, data = df_clean)
summary(model_policy)

# toti trei predictorii sunt semnificativi statistic (p < 0.05)
# env_tax (coef = 6.137e-06, p < 2e-16): taxele ecologice mai mari sunt asociate
# cu emisii totale mai mari — similar explicatiei de la RQ9, tarile industrializate
# platesc mai multe taxe si emit mai mult
# expenditure (coef = -5.038e-05, p = 0.009): cheltuielile de mediu au efect negativ
# semnificativ — cresterile cheltuielilor sunt asociate cu reducerea emisiilor totale
# renewable_value (coef = 1037, p < 2e-16): energia regenerabila este asociata cu
# emisii totale mai mari — explicabil prin faptul ca tarile mari industrial adopta
# si energia verde dar emit totodata mult CO2
# R-squared = 0.904 — modelul explica 90.4% din variatia emisiilor totale
# acesta este cel mai puternic model din studiu
# concluzie: energia regenerabila si taxele ecologice sunt cei mai importanti
# predictori ai emisiilor totale de CO2


###   RQ15: In ce masura variabilele climatice, economice si agricole explica 
###         variatia temperaturii medii la nivel regional?
##
##  H0: Emisiile de CO2 per capita, cresterea PIB, suprafata recoltata, 
##      ingrasamintele, energia regenerabila, taxele ecologice, ch
##      de mediu si anul nu influenteaza semnificativ temp medie anuala,
##      pentru regiunea geografica.
## 
glimpse (df_clean)

options(scipen = 9)
model <- lm(avg_temp ~ annual_co2_emissions_per_capita + gdp_growth_annual_pct + cereal_area_harvested_ha 
            + fertilizer_per_ha + renewable_value + env_tax + expenditure + year + world_region, 
            data = df_clean)
summary(model)


###   RQ16: In ce masura variabilele climatice, economice si agricole explica 
###         variatia temperaturii medii la nivel de tara?
##
##  H0: Emisiile de CO2 per capita, cresterea PIB, suprafata recoltata, 
##      ingrasamintele, energia regenerabila, taxele ecologice, ch 
##      de mediu si anul nu influenteaza semnificativ temp medie anuala,
##      pentru fiecare tara.
##
                                       
options(scipen = 9)
model <- lm(avg_temp ~ annual_co2_emissions_per_capita + gdp_growth_annual_pct + cereal_area_harvested_ha 
            + fertilizer_per_ha + renewable_value + env_tax + expenditure + year + country_name, 
            data = df_clean)
summary(model)
min(df_clean$country_name)

