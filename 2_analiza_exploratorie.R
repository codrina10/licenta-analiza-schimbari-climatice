###############################################################################
###                      Lucrare de licență - Curcă Maria Codrina           ###
###                        2. Analiza Exploratorie a Datelor (EDA)

### ultima actualizare: 2026-06-21
###############################################################################

options(scipen = 999)
library(tidyverse) 
library(naniar)
library(corrr)
library(readxl)
library(DataExplorer)
library(inspectdf)
library(janitor)
library(patchwork)
library(broom)
library(corrplot)

# Setare director de lucru
base_dir <- 'C:/Users/Codrina/Dropbox/curca_maria'
setwd(base_dir)

###############################################################################
##      Import setul de date finalizat in scriptul "1_data_import.R"
df_clean <- read_excel('df_clean.xlsx') |> ungroup()
glimpse(df_clean)
###############################################################################


###############################################################################
###          I. INFORMATII GENERALE DESPRE SETUL DE DATE
###############################################################################

# Structura generala a datelor: tipuri de variabile, valori lipsa, dimensiuni
temp <- DataExplorer::introduce(df_clean)
View(temp)

# Vizualizare grafica a structurii
plot_intro(temp)
png("fig_intro_structura_date.png", width = 20, height = 15, units = "cm", res = 300)
plot_intro(temp)
dev.off()



###############################################################################
###          II. ANALIZA VALORILOR LIPSA
###############################################################################

# Grafic cu procentul de valori lipsa pentru fiecare variabila
# Variabilele cu multe valori lipsa vor fi tratate cu atentie in analiza
plot_missing(df_clean)
png("fig_missing_valori.png", width = 20, height = 15, units = "cm", res = 300)
plot_missing(df_clean)
dev.off()

# Variante alternative cu pachetul inspectdf
inspect_na(df_clean) |>
  show_plot()
png("fig_missing_valori_inspectdf.png", width = 20, height = 15, units = "cm", res = 300)
print(inspect_na(df_clean) |> show_plot())
dev.off()


###############################################################################
###          III. DISTRIBUTIA VARIABILELOR CATEGORIALE
###############################################################################
# Frecventa valorilor pentru variabilele categoriale (world_region, country_name)
# Excludem 'year': desi e stocat ca numar, are ~76 de valori unice (1950-2025) si,
# daca ar fi inclus, ar produce un grafic ilizibil cu o bara pentru fiecare an
DataExplorer::plot_bar(df_clean |> select(-year))
png("fig_categoriale_bar.png", width = 20, height = 15, units = "cm", res = 300)
dev.off()

# Varianta alternativa - arata si variabila predominanta per coloana
inspect_imb(df_clean) |>
  show_plot()
png("fig_categoriale_imbalance.png", width = 20, height = 15, units = "cm", res = 300)
print(inspect_imb(df_clean) |> show_plot())
dev.off()

###############################################################################
###          IV. DISTRIBUTIA VARIABILELOR NUMERICE
###############################################################################

#anul ca tip caracter

glimpse(df_clean)

# Fig 4a - Temperatura
DataExplorer::plot_histogram(
  df_clean |> select(avg_temp, avg_temp_prev_year, diff_temp)
)

png("fig4a_histograma_temperatura.png", width = 20, height = 15, units = "cm", res = 300)
DataExplorer::plot_histogram(
  df_clean |> select(avg_temp, avg_temp_prev_year, diff_temp)
)
dev.off()

# Fig 4b - Emisii de CO2
DataExplorer::plot_histogram(
  df_clean |> select(
    annual_co2_emissions, annual_co2_emissions_per_capita,
    annual_co2_emissions_land_use, annual_co2_concentration,
    annual_co2_growth_pct
  )
)

png("fig4b_histograma_co2.png", width = 20, height = 15, units = "cm", res = 300)
DataExplorer::plot_histogram(
  df_clean |> select(
    annual_co2_emissions, annual_co2_emissions_per_capita,
    annual_co2_emissions_land_use, annual_co2_concentration,
    annual_co2_growth_pct
  )
)
dev.off()

# Fig 4c - Gaze cu efect de sera, economie si energie fosila
DataExplorer::plot_histogram(
  df_clean |> select(
    annual_ghg_emissions_co2eq, gdp_growth_annual_pct
  )
)

png("fig4c_histograma_ghg_economie.png", width = 20, height = 15, units = "cm", res = 300)
DataExplorer::plot_histogram(
  df_clean |> select(
    annual_ghg_emissions_co2eq, gdp_growth_annual_pct
  )
)
dev.off()

# Fig 4d - Agricultura (cereale si ingrasaminte)
DataExplorer::plot_histogram(
  df_clean |> select(
    cereals, fertilizer_per_ha, cereal_yield_tonnes_per_ha,
    cereal_area_harvested_ha, cereal_production_tonnes
  )
)

png("fig4d_histograma_agricultura.png", width = 20, height = 15, units = "cm", res = 300)
DataExplorer::plot_histogram(
  df_clean |> select(
    cereals, fertilizer_per_ha, cereal_yield_tonnes_per_ha,
    cereal_area_harvested_ha, cereal_production_tonnes
  )
)
dev.off()

# Fig 4e - Politici de mediu, comert si finantare
DataExplorer::plot_histogram(
  df_clean |> select(
    renewable_value, env_tax, expenditure, trade_value
  )
)

png("fig4e_histograma_politici_mediu.png", width = 20, height = 15, units = "cm", res = 300)
DataExplorer::plot_histogram(
  df_clean |> select(
    renewable_value, env_tax, expenditure, trade_value
  )
)
dev.off()

# Curbe de densitate pentru toate variabilele numerice
DataExplorer::plot_density(df_clean)
png("fig4f_densitate_toate_variabilele.png", width = 25, height = 20, units = "cm", res = 300)
DataExplorer::plot_density(df_clean)
dev.off()


###############################################################################
###          V. EVOLUTIA TEMPERATURII IN TIMP
###############################################################################

# Calculam media anuala a temperaturii la nivel global
df_temp_global <- df_clean |>
  group_by(year) |>
  summarise(
    avg_temp_overall = mean(avg_temp, na.rm = TRUE),
    avg_diff_temp_overall = mean(diff_temp, na.rm = TRUE)
  )

# Grafic lollipop - evolutia mediei anuale a temperaturii globale (1950-2025)
g_temp_global <- ggplot(df_temp_global, aes(x = year, y = avg_temp_overall)) +
  geom_segment(aes(x = year, xend = year, y = 0, yend = avg_temp_overall),
               color = "grey") +
  geom_point(size = 3, color = "#69b3a2") +
  theme_linedraw() +
  theme(legend.position = "none") +
  xlab("An") +
  ylab("Media temperaturilor la nivel global (°C)") +
  scale_y_continuous(breaks = seq(0, 55, by = 2)) +
  theme(axis.text.x = element_text(size = 9, angle = 60, hjust = 1)) +
  theme(axis.text.y = element_text(size = 9))

print(g_temp_global)
ggsave("fig1_evolutia_temp_globala.png",
       plot = g_temp_global,
       width = 20, height = 15, units = "cm", dpi = 300)

###############################################################################
###          VI. EVOLUTIA TEMPERATURII PE REGIUNI
###############################################################################

# Calculam media anuala a temperaturii pe fiecare regiune
df_temp_regiuni <- df_clean |>
  group_by(world_region, year) |>
  summarise(
    avg_temp_overall = mean(avg_temp, na.rm = TRUE),
    avg_diff_temp_overall = mean(diff_temp, na.rm = TRUE),
    .groups = "drop"
  )

# Grafic lollipop - evolutia temperaturii pe regiuni (cu facete)
g_temp_regiuni <- ggplot(df_temp_regiuni, aes(x = year, y = avg_temp_overall)) +
  geom_segment(aes(x = year, xend = year, y = 0, yend = avg_temp_overall),
               color = "grey") +
  geom_point(size = 2, color = "#69b3a2") +
  facet_wrap(~ world_region) +
  theme_linedraw() +
  theme(legend.position = "none") +
  xlab("An") +
  ylab("Media temperaturilor pe regiuni (°C)") +
  scale_y_continuous(breaks = seq(0, 55, by = 2)) +
  theme(axis.text.x = element_text(size = 9, angle = 60, hjust = 1)) +
  theme(axis.text.y = element_text(size = 9))

dev.new()
print(g_temp_regiuni)
ggsave("fig2_evolutia_temp_pe_regiuni.png",
       plot = g_temp_regiuni,
       width = 20, height = 15, units = "cm", dpi = 300)

###############################################################################
###          VII. CORELATII INTRE VARIABILELE NUMERICE
###############################################################################

# Selectam variabilele numerice relevante pentru analiza
df_corr <- df_clean |>
  select(
    avg_temp,
    annual_co2_emissions, annual_co2_emissions_per_capita,
    annual_co2_emissions_land_use, annual_co2_concentration,
    annual_co2_growth_pct, annual_ghg_emissions_co2eq,
    gdp_growth_annual_pct,
    fertilizer_per_ha, cereal_yield_tonnes_per_ha,
    renewable_value, env_tax, expenditure
  )

# Grafic de corelatii Spearman (neparametric) intre toate variabilele numerice
# Valorile aproape de 1 sau -1 indica corelatie puternica


corrplot(
  cor(df_clean |> select_if(is.numeric), method = "spearman", use = "pairwise.complete.obs"),
  method = "number",
  type = "upper",
  tl.cex = 0.50,
  number.cex = 0.50,
  title = "Matricea de corelatie Spearman"
)

png("fig7_matrice_corelatie_spearman.png", width = 25, height = 22, units = "cm", res = 300)
corrplot(
  cor(df_clean |> select_if(is.numeric), method = "spearman", use = "pairwise.complete.obs"),
  method = "number",
  type = "upper",
  tl.cex = 0.50,
  number.cex = 0.50,
  title = "Matricea de corelatie Spearman"
)
dev.off()


###############################################################################
###          VIII. ANALIZA EMISIILOR DE CO2 IN TIMP
###############################################################################

# Evolutia emisiilor medii anuale de CO2 la nivel global
df_co2_global <- df_clean |>
  group_by(year) |>
  summarise(
    avg_co2 = mean(annual_co2_emissions, na.rm = TRUE),
    avg_co2_per_capita = mean(annual_co2_emissions_per_capita, na.rm = TRUE),
    .groups = "drop"
  )

# Grafic emisii totale CO2
g_co2 <- ggplot(df_co2_global, aes(x = year, y = avg_co2)) +
  geom_line(color = "#E74C3C", linewidth = 1) +
  geom_point(color = "#E74C3C", size = 2) +
  theme_minimal() +
  xlab("An") +
  ylab("Emisii medii CO2 (tone)") +
  theme(axis.text.x = element_text(size = 9, angle = 60, hjust = 1))

dev.new()
print(g_co2)
ggsave("fig3_evolutia_emisiilor_co2.png",
       plot = g_co2,
       width = 20, height = 12, units = "cm", dpi = 300)

###############################################################################
###          IX. ANALIZA EMISIILOR DE CO2 PER CAPITA PE REGIUNI
###############################################################################

# Boxplot - distributia emisiilor CO2 per capita pe regiuni
g_co2_regiuni <- ggplot(df_clean, aes(x = world_region,
                                      y = annual_co2_emissions_per_capita,
                                      fill = world_region)) +
  geom_boxplot(outlier.size = 0.5, alpha = 0.7) +
  theme_minimal() +
  theme(legend.position = "none") +
  xlab("Regiune") +
  ylab("Emisii CO2 per capita") +
  theme(axis.text.x = element_text(size = 9, angle = 30, hjust = 1))

dev.new()
print(g_co2_regiuni)
ggsave("fig4_co2_per_capita_pe_regiuni.png",
       plot = g_co2_regiuni,
       width = 20, height = 12, units = "cm", dpi = 300)

###############################################################################
###          X. ANALIZA ENERGIEI REGENERABILE PE REGIUNI
###############################################################################

# Boxplot - distributia utilizarii energiei regenerabile pe regiuni
g_renew <- ggplot(df_clean |> filter(!is.na(renewable_value)),
                  aes(x = world_region, y = renewable_value, fill = world_region)) +
  geom_boxplot(outlier.size = 0.5, alpha = 0.7) +
  theme_minimal() +
  theme(legend.position = "none") +
  xlab("Regiune") +
  ylab("Valoare energie regenerabila") +
  theme(axis.text.x = element_text(size = 9, angle = 30, hjust = 1))

dev.new()
print(g_renew)
ggsave("fig5_energie_regenerabila_pe_regiuni.png",
       plot = g_renew,
       width = 20, height = 12, units = "cm", dpi = 300)

###############################################################################
###          XI. RELATIA DINTRE INGRASAMINTE SI RANDAMENTUL CEREALELOR
###############################################################################

# Scatter plot - relatia dintre utilizarea ingrasamintelor si randamentul cerealelor
# Confirma vizual RQ6
g_fertil <- ggplot(df_clean |> filter(!is.na(fertilizer_per_ha),
                                      !is.na(cereal_yield_tonnes_per_ha)),
                   aes(x = fertilizer_per_ha, y = cereal_yield_tonnes_per_ha)) +
  geom_point(alpha = 0.3, size = 1, color = "#2E75B6") +
  geom_smooth(method = "loess", color = "red", se = TRUE) +
  theme_minimal() +
  xlab("Ingrasaminte per hectar (kg)") +
  ylab("Randament cereale (tone/ha)")

dev.new()
print(g_fertil)
ggsave("fig6_ingrasaminte_vs_randament.png",
       plot = g_fertil,
       width = 20, height = 12, units = "cm", dpi = 300)
