###############################################################################
###                      Lucrare de licență - Curcă Maria Codrina           ###
###                                 4. Interogari SQL
### ultima actualizare: 2026-05-25
###############################################################################

install.packages('RPostgres')
library(RPostgres)

# conectare la baza de date
con <- dbConnect(
  RPostgres::Postgres(),
  dbname = "licenta",
  host = "localhost",
  port = 5432,
  user = "postgres",
  password = "postgres" 
)

#verificare conexiune
dbListTables(con)


#import df_clean
library(readxl)
df_clean <- read_excel('df_clean.xlsx')

#df_clean ca tabel in baza de date
dbWriteTable(con, "df_clean", df_clean, overwrite = TRUE)

#verificare creare tabel
dbListTables(con)

#coloane tabel
dbListFields(con, "df_clean")



# 1. Media temperaturii globale pe an
temp_global <- dbGetQuery(con, "
  SELECT year, 
         ROUND(AVG(avg_temp)::numeric, 2) AS media_temp_globala
  FROM df_clean
  GROUP BY year
  ORDER BY year
")
View(temp_global)

# 2. Media emisiilor de CO2 per capita pe regiune
co2_per_regiune <- dbGetQuery(con, "
  SELECT world_region,
         ROUND(AVG(annual_co2_emissions_per_capita)::numeric, 2) AS media_co2_per_capita,
         COUNT(DISTINCT country_name) AS nr_tari
  FROM df_clean
  WHERE annual_co2_emissions_per_capita IS NOT NULL
  GROUP BY world_region
  ORDER BY media_co2_per_capita DESC
")
View(co2_per_regiune)

# 3. Top 10 tari cu cele mai mari emisii de CO2 per capita (media 1950-2025)
top10_co2 <- dbGetQuery(con, "
  SELECT country_name,
         world_region,
         ROUND(AVG(annual_co2_emissions_per_capita)::numeric, 2) AS media_co2_per_capita
  FROM df_clean
  WHERE annual_co2_emissions_per_capita IS NOT NULL
  GROUP BY country_name, world_region
  ORDER BY media_co2_per_capita DESC
  LIMIT 10
")
View(top10_co2)

# 4. Evolutia concentratiei de CO2 pe decade
co2_decade <- dbGetQuery(con, "
  SELECT 
    (year / 10) * 10 AS decada,
    ROUND(AVG(annual_co2_concentration)::numeric, 2) AS media_concentratie_co2,
    ROUND(AVG(avg_temp)::numeric, 2) AS media_temperatura
  FROM df_clean
  WHERE annual_co2_concentration IS NOT NULL
  GROUP BY (year / 10) * 10
  ORDER BY decada
")
View(co2_decade)


# 5. Media taxelor ecologice si a emisiilor pe regiune, pentru anii recenti
politici_recente <- dbGetQuery(con, "
  SELECT world_region,
         ROUND(AVG(env_tax)::numeric, 2) AS media_taxe_ecologice,
         ROUND(AVG(expenditure)::numeric, 2) AS media_cheltuieli_mediu,
         ROUND(AVG(annual_co2_emissions_per_capita)::numeric, 2) AS media_co2_per_capita
  FROM df_clean
  WHERE year >= 2000
    AND env_tax IS NOT NULL
  GROUP BY world_region
  ORDER BY media_taxe_ecologice DESC
")
View(politici_recente)



###############################################################################
###                    VIZUALIZARE REZULTATE
###############################################################################

# INTEROGAREA 1 
g_sql1 <- ggplot(temp_global, aes(x = year, y = media_temp_globala)) +
  geom_line(color = "#2E75B6", linewidth = 1) +
  geom_point(color = "#2E75B6", size = 1.5) +
  theme_minimal() +
  xlab("An") +
  ylab("Media temperaturii globale (°C)") +
  labs(title = "Evolutia mediei temperaturii globale (1950-2025)") +
  theme(axis.text.x = element_text(size = 9, angle = 60, hjust = 1))

dev.new()
print(g_sql1)
ggsave("fig_sql1_evolutie_temp_globala.png", plot = g_sql1,
       width = 20, height = 12, units = "cm", dpi = 300)

###############################################################################

# INTEROGAREA 2 
g_sql2 <- ggplot(co2_per_regiune,
                 aes(x = reorder(world_region, media_co2_per_capita),
                     y = media_co2_per_capita,
                     fill = world_region)) +
  geom_col() +
  geom_text(aes(label = media_co2_per_capita),
            hjust = -0.1, size = 3.5) +
  coord_flip() +
  theme_minimal() +
  theme(legend.position = "none") +
  xlab("Regiune") +
  ylab("Media CO2 per capita") +
  labs(title = "Emisii medii de CO2 per capita pe regiuni (1950-2025)")

dev.new()
print(g_sql2)
ggsave("fig_sql2_co2_per_capita_regiuni.png", plot = g_sql2,
       width = 20, height = 12, units = "cm", dpi = 300)

###############################################################################

# INTEROGAREA 3 
g_sql3 <- ggplot(top10_co2,
                 aes(x = reorder(country_name, media_co2_per_capita),
                     y = media_co2_per_capita,
                     fill = world_region)) +
  geom_col() +
  geom_text(aes(label = media_co2_per_capita),
            hjust = -0.1, size = 3.5) +
  coord_flip() +
  theme_minimal() +
  xlab("Tara") +
  ylab("Media CO2 per capita") +
  labs(title = "Top 10 tari cu cele mai mari emisii de CO2 per capita",
       fill = "Regiune")

dev.new()
print(g_sql3)
ggsave("fig_sql3_top10_tari_co2.png", plot = g_sql3,
       width = 20, height = 12, units = "cm", dpi = 300)

###############################################################################

# INTEROGAREA 4 
g_sql4 <- ggplot(co2_decade, aes(x = decada)) +
  geom_line(aes(y = media_temperatura, color = "Temperatura medie (°C)"),
            linewidth = 1.2) +
  geom_line(aes(y = media_concentratie_co2 / 15, 
                color = "Concentratie CO2 (scalata)"),
            linewidth = 1.2, linetype = "dashed") +
  geom_point(aes(y = media_temperatura, color = "Temperatura medie (°C)"),
             size = 3) +
  geom_point(aes(y = media_concentratie_co2 / 15,
                 color = "Concentratie CO2 (scalata)"),
             size = 3) +
  scale_color_manual(values = c("Temperatura medie (°C)" = "#E74C3C",
                                "Concentratie CO2 (scalata)" = "#2E75B6")) +
  theme_minimal() +
  xlab("Decada") +
  ylab("Valoare") +
  labs(title = "Evolutia temperaturii si concentratiei CO2 pe decade",
       color = "Indicator") +
  theme(legend.position = "bottom")

dev.new()
print(g_sql4)
ggsave("fig_sql4_temp_si_co2_pe_decade.png", plot = g_sql4,
       width = 20, height = 12, units = "cm", dpi = 300)


###############################################################################

# INTEROGAREA 5

politici_long <- politici_recente |>
  pivot_longer(
    cols = c(media_taxe_ecologice, media_cheltuieli_mediu, media_co2_per_capita),
    names_to = "indicator",
    values_to = "valoare"
  ) |>
  mutate(indicator = case_when(
    indicator == "media_taxe_ecologice" ~ "Taxe ecologice",
    indicator == "media_cheltuieli_mediu" ~ "Cheltuieli mediu",
    indicator == "media_co2_per_capita" ~ "CO2 per capita"
  ))

g_sql5 <- ggplot(politici_long,
                 aes(x = reorder(world_region, valoare),
                     y = valoare,
                     fill = indicator)) +
  geom_col(position = "dodge") +
  coord_flip() +
  theme_minimal() +
  xlab("Regiune") +
  ylab("Valoare") +
  labs(title = "Politici de mediu si emisii CO2 pe regiuni (2000-2025)",
       fill = "Indicator") +
  theme(legend.position = "bottom")

dev.new()
print(g_sql5)
ggsave("fig_sql5_politici_mediu_regiuni.png", plot = g_sql5,
       width = 20, height = 12, units = "cm", dpi = 300)


dbDisconnect(con)
