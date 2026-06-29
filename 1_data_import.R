###############################################################################
###                      Lucrare de licență - Curcă Maria Codrina           ###
###                                     1. Import date
### ultima actualizare: 2026-03-14
library(tidyverse)
library(readxl)
library(janitor)

base_dir <- '/Users/marinfotache/Dropbox/licenta2026/curca_maria'
base_dir <- '/Users/marinfotache/Library/CloudStorage/Dropbox/licenta2026/curca_maria/data_sets_licenta/toate'
base_dir <- 'C:/Users/Codrina/Dropbox/curca_maria/data_sets_licenta/toate'
setwd(base_dir)

# temperaturile medii lunare, pe țări
df1_temperatures <- read_excel('monthly_temp.xlsx') |>
  clean_names() |>
  pivot_longer(cols = x2025:x1950, names_to = 'year', values_to = 'avg_temp') |>
  mutate(year = as.integer(str_remove(year, 'x'))) |>
  filter(!is.na(code)) |>
  rename(country_name_temp = entity)
glimpse(df1_temperatures)

# annual-co2-emissions-per-country
setwd(paste(base_dir, 'annual-co2-emissions-per-country', sep = '/')) 
df2_co2 <- read_csv('annual-co2-emissions-per-country.csv') |>
  clean_names() |>
  filter(!is.na(code)) |>
  rename(country_name_co2 = entity) |>
  mutate(year = as.integer(year))
glimpse(df2_co2)

# cereal-crop-yield-vs-fertilizer-application
setwd(paste(base_dir, 'cereal-crop-yield-vs-fertilizer-application', sep = '/')) 
df3_ccy_fertil <- read_csv('cereal-crop-yield-vs-fertilizer-application.csv') |>
  clean_names() |>
  filter(!is.na(code)) |>
  set_names(c('country_name_ccy', 'code', 'year', 'cereals', 'fertilizer_per_ha', 'world_region_ccy'))
glimpse(df3_ccy_fertil)

countries_and_regions <- df3_ccy_fertil |>
  group_by(code, country_name_ccy) |>
  summarise(world_region_ccy = max(world_region_ccy, na.rm = TRUE)) |>
  ungroup() |>
  filter(!is.na(code))

# co2-emissions-fossil-land
setwd(paste(base_dir, 'co2-emissions-fossil-land', sep = '/')) 
df4_co2_fossil_land <- read_csv('co2-emissions-fossil-land.csv') |>
  clean_names() |>
  filter(!is.na(code)) |>
  rename(country_name_co2_fl = entity,
         annual_co2_emissions_land_use = annual_co2_emissions_from_land_use_change)
glimpse(df4_co2_fossil_land)

# co2-emissions-per-capita
setwd(paste(base_dir, 'co-emissions-per-capita', sep = '/')) 
df5_co2_per_capita <- read_csv('co-emissions-per-capita.csv') |>
  clean_names() |>
  filter(!is.na(code)) |>
  rename(country_name_co2_pc = entity)
glimpse(df5_co2_per_capita)

# co2-long-term-concentration
setwd(paste(base_dir, 'co2-long-term-concentration', sep = '/')) 
df6_co2_concentration <- read_csv('co2-long-term-concentration.csv') |>
  clean_names() |>
  filter(!is.na(code)) |>
  rename(country_name_co2_conc = entity,
         annual_co2_concentration = annual_concentration_of_atmospheric_carbon_dioxide)
glimpse(df6_co2_concentration)

# fossil-fuel-primary-energy
setwd(paste(base_dir, 'fossil-fuel-primary-energy', sep = '/'))  
df7_fossil_fuel_energy <- read_csv('fossil-fuel-primary-energy.csv') |>
  clean_names() |>
  filter(!is.na(code)) |>
  rename(country_name_fossil = entity)
glimpse(df7_fossil_fuel_energy)

# ghg-emissions-by-world-region
setwd(paste(base_dir, 'ghg-emissions-by-world-region', sep = '/'))  
df8_ghg_region <- read_csv('ghg-emissions-by-world-region.csv') |>
  clean_names() |>
  filter(!is.na(code)) |>
  rename(region_name_ghg = entity,
         annual_ghg_emissions_co2eq = annual_greenhouse_gas_emissions_in_co2_equivalents)
glimpse(df8_ghg_region)

# import-of-environmentally-sound-technologies
setwd(paste(base_dir, 'import-of-environmentally-sound-technologies', sep = '/'))  
df9_env_tech_import <- read_csv('import-of-environmentally-sound-technologies.csv') |>
  clean_names() |>
  filter(!is.na(code)) |>
  rename(country_name_env_tech = entity,
         env_tech_import_usd = x17_7_1_amount_of_tracked_imported_environmentally_sound_technologies_current_united_states_dollars_dc_envtech_imp)
glimpse(df9_env_tech_import)

# index-of-cereal-production-yield-and-land-use
setwd(paste(base_dir, 'index-of-cereal-production-yield-and-land-use', sep = '/'))  
df10_cereal_index <- read_csv('index-of-cereal-production-yield-and-land-use.csv') |>
  clean_names() |>
  filter(!is.na(code)) |>
  rename(country_name_cereal_idx = entity,
         cereal_area_harvested_ha = cereals_00001717_area_harvested_005312_hectares,
         cereal_production_tonnes = cereals_00001717_production_005510_tonnes,
         cereal_yield_tonnes_per_ha = cereals_00001717_yield_005412_tonnes_per_hectare,
         population_historical = population_historical)
glimpse(df10_cereal_index)

# medium-high-level-implementation-of-sustainable-public-procurement
setwd(paste(base_dir, 'medium-high-level-implementation-of-sustainable-public-procurement', sep = '/'))  
df11_sustainable_procurement <- read_csv('medium-high-level-implementation-of-sustainable-public-procurement.csv') |>
  clean_names() |>
  filter(!is.na(code)) |>
  rename(country_name_procurement = entity,  
         implementation_level = x12_7_1_number_of_countries_implementing_sustainable_public_procurement_policies_and_action_plans_sg_scp_procn)
glimpse(df11_sustainable_procurement)

# stratospheric-ozone-concentration
setwd(paste(base_dir, 'stratospheric-ozone-concentration', sep = '/'))  
df12_ozone_concentration <- read_csv('stratospheric-ozone-concentration.csv') |>
  clean_names() |>
  filter(!is.na(code)) |>
  rename(entity_ozone = entity,
         min_daily_ozone_concentration = minimum_daily_concentration,
         mean_daily_ozone_concentration = mean_daily_concentration)
glimpse(df12_ozone_concentration)

# co2-gdp-growth
setwd(paste(base_dir, 'co2-gdp-growth', sep = '/'))
df13_co2_gdp <- read_csv('co2-gdp-growth.csv') |>
  clean_names() |>
  filter(!is.na(code)) |>
  rename(country_name_co2_gdp = entity,
         gdp_growth_annual_pct = gdp_growth_annual_percent,
         annual_co2_growth_pct = annual_co2_emissions_growth_percent)
glimpse(df13_co2_gdp)


# Carbon_Footprint_of_Bank_Loans
setwd(paste(base_dir, 'Carbon_Footprint_of_Bank_Loans', sep = '/'))
df14_bank_loans <- read_csv('Carbon_Footprint_of_Bank_Loans.csv') |>
  clean_names() |>
  pivot_longer(cols = starts_with('f'), names_to = 'year', values_to = 'carbon_footprint') |>
  mutate(year = as.integer(str_remove(year, 'f'))) |>
  filter(!is.na(iso3)) |>
  rename(country_name_bank = country,
         cts_full_desc = cts_full_descriptor)
glimpse(df14_bank_loans)


# Indicator_14_Expenditure_on_Environmental_Protection
setwd(paste(base_dir, 'Indicator_14_Expenditure_on_Environmental_Protection_-5612631162247205392', sep = '/'))
df15_env_expenditure <- read_csv('Indicator_14_Expenditure_on_Environmental_Protection_-5612631162247205392.csv') |>
  clean_names() |>
  pivot_longer(cols = matches('^x\\d{4}$'), names_to = 'year', values_to = 'expenditure') |>
  mutate(year = as.integer(str_remove(year, 'x'))) |>
  filter(!is.na(iso3)) |>
  rename(country_name_env_exp = country,
         cts_full_desc = cts_full_descriptor)
glimpse(df15_env_expenditure)


# Indicator_13_Environmental_Taxes
setwd(paste(base_dir, 'Indicator_13_Environmental_Taxes_new_8733790761015447869', sep = '/'))
df16_env_taxes <- read_csv('Indicator_13_Environmental_Taxes_new_8733790761015447869.csv') |>
  clean_names() |>
  pivot_longer(cols = matches('^x\\d{4}$'), names_to = 'year', values_to = 'env_tax') |>
  mutate(year = as.integer(str_remove(year, 'x'))) |>
  filter(!is.na(iso3)) |>
  rename(country_name_env_tax = country,
         cts_full_desc = cts_full_descriptor)
glimpse(df16_env_taxes)


# Trade_in_Low_Carbon_Technology_Products
setwd(paste(base_dir, 'Trade_in_Low_Carbon_Technology_Products', sep = '/'))
df17_low_carbon_trade <- read_csv('Trade_in_Low_Carbon_Technology_Products.csv') |>
  clean_names() |>
  pivot_longer(cols = starts_with('f'), names_to = 'year', values_to = 'trade_value') |>
  mutate(year = as.integer(str_remove(year, 'f'))) |>
  filter(!is.na(iso3)) |>
  rename(country_name_trade = country,
         cts_full_desc = cts_full_descriptor)
glimpse(df17_low_carbon_trade)


# Renewable_Energy
setwd(paste(base_dir, 'Renewable_Energy', sep = '/'))
df18_renewable_energy <- read_csv('Renewable_Energy.csv') |>
  clean_names() |>
  pivot_longer(cols = starts_with('f'), names_to = 'year', values_to = 'renewable_value') |>
  mutate(year = as.integer(str_remove(year, 'f'))) |>
  filter(!is.na(iso3)) |>
  rename(country_name_renewable = country,
         cts_full_desc = cts_full_descriptor)
glimpse(df18_renewable_energy)


# domestic-forest-change-vs-imported-deforestation
setwd(paste(base_dir, 'domestic-forest-change-vs-imported-deforestation', sep = '/'))
df19_forest_change <- read_csv('domestic-forest-change-vs-imported-deforestation.csv') |>
  clean_names() |>
  filter(!is.na(code)) |>
  rename(country_name_forest = entity,
         annual_net_forest_change = annual_net_change_in_forest_area,
         world_region_forest = world_regions_according_to_owid)
glimpse(df19_forest_change)

# change-forest-area-share-total
setwd(paste(base_dir, 'change-forest-area-share-total', sep = '/'))
df20_forest_area_share <- read_csv('change-forest-area-share-total.csv') |>
  clean_names() |>
  filter(!is.na(code)) |>
  rename(country_name_forest_share = entity,
         conversion_share_forest = conversion_as_share_of_forest_area)
glimpse(df20_forest_area_share)

# Revenire la directorul de bază
setwd(base_dir)

df14_bank_loans_clean <- df14_bank_loans |>
  group_by(iso3, year) |>
  summarise(carbon_footprint = sum(carbon_footprint, na.rm = TRUE), .groups = "drop")

df15_env_expenditure_clean <- df15_env_expenditure |>
  filter(cts_full_desc =="Government and Public Sector Finance, Expenditure By Cofog, [Sector], Environmental Protection, Protection of Biodiversity and Landscape [2014 Manual]")|>
  group_by(iso3, year) |>
  summarise(expenditure = sum(expenditure, na.rm = TRUE), .groups = "drop")

df16_env_taxes_clean <- df16_env_taxes |>
  filter(cts_full_desc == "Environment, Climate Change, Government Policy, Taxes, Environmental Taxes") |>
  group_by(iso3, year) |>
  summarise(env_tax = sum(env_tax, na.rm = TRUE), .groups = "drop")

df17_low_carbon_trade_clean <- df17_low_carbon_trade |>
  filter(cts_full_desc == "Environment, Climate Change, Mitigation, Trade-Related, rade in Low Carbon Technology Products") |>
  group_by(iso3, year) |>
  summarise(trade_value = sum(trade_value, na.rm = TRUE), .groups = "drop")

df18_renewable_energy_clean <- df18_renewable_energy |>
  group_by(iso3, year) |>
  summarise(renewable_value = sum(renewable_value, na.rm = TRUE), .groups = "drop")

df <- countries_and_regions |>
  filter(nchar(code) == 3) |>
  inner_join(df1_temperatures, by = "code") |>
  group_by(code, country_name = country_name_ccy, world_region = world_region_ccy, year) |>
  summarise(avg_temp = mean(avg_temp, na.rm = TRUE), .groups = "drop") |>
  ungroup() |>
  group_by(code, country_name, world_region) |>
  mutate(avg_temp_prev_year = lag(avg_temp, 1)) |>
  mutate(diff_temp = avg_temp -avg_temp_prev_year) |>
  
  inner_join(
    df2_co2 |>
      select(code, year, annual_co2_emissions),
    by = c("code", "year")
  ) |>
  
  left_join(
    df3_ccy_fertil |>
      select(code, year, cereals, fertilizer_per_ha),
    by = c("code", "year")
  ) |>

  left_join(
    df4_co2_fossil_land |>
      select(code, year, annual_co2_emissions_land_use),
    by = c("code", "year")
  ) |>
  
  left_join(
    df5_co2_per_capita |>
      select(code, year, annual_co2_emissions_per_capita),
    by = c("code", "year")
  ) |>
  
  left_join(
    df6_co2_concentration |>
      select(year, annual_co2_concentration) |>
      distinct(),
      by="year"
  ) |>
  
  left_join(
    df7_fossil_fuel_energy |>
      select(code, year, fossil_fuels_t_wh),
    by = c("code", "year")
  ) |>
  
  left_join(
    df8_ghg_region |>
      select(code, year, annual_ghg_emissions_co2eq),
    by = c("code", "year")
  ) |>
  
  left_join(
    df9_env_tech_import |>
      select(code, year, env_tech_import_usd),
    by = c("code", "year")
  ) |>
  
  left_join(
    df10_cereal_index |>
      select(code, year, cereal_area_harvested_ha, cereal_production_tonnes, cereal_yield_tonnes_per_ha),
    by = c("code", "year")
  ) |>
  
  left_join(
    df11_sustainable_procurement |>
      select(code, year, implementation_level),
    by = c("code", "year")
  ) |>
  
  #pt 12 ozonul e global, nu pe tara 
  
  left_join(
    df13_co2_gdp |>
      select(code, year, gdp_growth_annual_pct, annual_co2_growth_pct),
    by = c("code", "year")
  ) |>

  left_join(
    df14_bank_loans_clean |>
      select(code=iso3, year, carbon_footprint),
    by = c("code", "year")
  ) |>
  
  left_join(
    df15_env_expenditure_clean |>
      select(code=iso3, year, expenditure),
    by = c("code", "year")
  ) |>
  
  left_join(
    df16_env_taxes_clean |>
      select(code=iso3, year, env_tax),
     by =c("code", "year")
  ) |>
  
  left_join(
    df17_low_carbon_trade_clean |>
      select(code = iso3, year, trade_value),
      by = c("code", "year")
  ) |>
  
  left_join(
    df18_renewable_energy_clean |>
      select(code = iso3, year, renewable_value),
    by = c("code", "year")
  ) |>
  
  left_join(
    df19_forest_change |>
      select(code, year, annual_net_forest_change),
    by = c("code", "year")
  ) |>
    
  left_join(
    df20_forest_area_share |>
      select(code, year, conversion_share_forest),
    by = c("code", "year")
  )

glimpse(df)  

df <- df|>
  filter(year >= 1950, year <=2025)

df_clean <- df |>
  select(
    code, country_name, world_region, year,
    avg_temp, avg_temp_prev_year, diff_temp,
    annual_co2_emissions,
    annual_co2_emissions_per_capita,
    annual_co2_emissions_land_use,
    annual_co2_concentration,
    annual_co2_growth_pct,
    annual_ghg_emissions_co2eq,
    gdp_growth_annual_pct,
    fossil_fuels_t_wh,
    cereals, fertilizer_per_ha, cereal_yield_tonnes_per_ha,
    cereal_area_harvested_ha, cereal_production_tonnes,
    renewable_value, env_tax, expenditure, trade_value,
    carbon_footprint
  ) 

glimpse(df_clean)  
getwd()
setwd('C:/Users/Codrina/Dropbox/curca_maria/data_sets_licenta/toate')
rio::export(df_clean, file = 'df_clean.xlsx')
