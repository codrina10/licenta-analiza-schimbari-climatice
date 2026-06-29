Analiza Datelor legate de Schimbările Climatice folosind SQL și R
Lucrare de licență — Curcă Maria Codrina
Specializarea Informatică Economică, FEAA, Universitatea Alexandru Ioan Cuza, Iași
Acest repository conține scripturile R folosite pentru importul, curățarea, analiza exploratorie, analiza statistică și interogarea SQL a datelor legate de schimbările climatice (temperaturi, emisii de CO2, agricultură, politici de mediu) pentru perioada 1950-2025.
---
Structura proiectului
Script	Descriere
`1_data_import.R`	Import și combinare a 20 de seturi de date (temperaturi, CO2, agricultură, politici de mediu)
`2_eda.R`	Analiza exploratorie a datelor (EDA): valori lipsă, distribuții, corelații
`3_statistica.R`	Teste de corelație Spearman, Kruskal-Wallis, regresii liniare multiple
`4_interogari_sql.R`	Interogări SQL (PostgreSQL) și vizualizarea rezultatelor
---
1. Import date
Scriptul importă 20 de seturi de date publice (Our World in Data, FAO, UNSD), le curăță și le combină într-un singur set de date (`df_clean`), pe baza codului de țară și a anului.
---
2. Analiza Exploratorie a Datelor (EDA)
Structura generală a datelor
![Structura generala a datelor](figures/fig_intro_structura_date.png)
Valori lipsă
![Valori lipsa - DataExplorer](figures/fig_missing_valori.png)
![Valori lipsa - inspectdf](figures/fig_missing_valori_inspectdf.png)
Distribuția variabilelor categoriale
![Distributia variabilelor categoriale](figures/fig_categoriale_bar.png)
![Dezechilibru variabile categoriale](figures/fig_categoriale_imbalance.png)
Distribuția variabilelor numerice
Temperatură
![Histograma temperatura](figures/fig4a_histograma_temperatura.png)
Emisii de CO2
![Histograma CO2](figures/fig4b_histograma_co2.png)
Gaze cu efect de seră și economie
![Histograma GHG si economie](figures/fig4c_histograma_ghg_economie.png)
Agricultură
![Histograma agricultura](figures/fig4d_histograma_agricultura.png)
Politici de mediu
![Histograma politici de mediu](figures/fig4e_histograma_politici_mediu.png)
Curbe de densitate (toate variabilele)
![Densitate toate variabilele](figures/fig4f_densitate_toate_variabilele.png)
Evoluția temperaturii în timp
![Evolutia temperaturii globale](figures/fig1_evolutia_temp_globala.png)
![Evolutia temperaturii pe regiuni](figures/fig2_evolutia_temp_pe_regiuni.png)
Corelații între variabilele numerice
![Matrice corelatie Spearman](figures/fig7_matrice_corelatie_spearman.png)
Analiza emisiilor de CO2
![Evolutia emisiilor de CO2](figures/fig3_evolutia_emisiilor_co2.png)
![CO2 per capita pe regiuni](figures/fig4_co2_per_capita_pe_regiuni.png)
Energie regenerabilă pe regiuni
![Energie regenerabila pe regiuni](figures/fig5_energie_regenerabila_pe_regiuni.png)
Relația dintre îngrășăminte și randamentul cerealelor
![Ingrasaminte vs randament cereale](figures/fig6_ingrasaminte_vs_randament.png)
---
3. Statistică
Teste de corelație Spearman (RQ1, RQ3, RQ5-RQ7, RQ9-RQ10), teste Kruskal-Wallis (RQ2, RQ4, RQ8) și modele de regresie liniară multiplă (RQ11-RQ16).
RQ1: Corelație între an și media temperaturii
![RQ1 - an vs temperatura](figures/fig_rq1_an_vs_temp.png)
![RQ1b - an vs diferenta de temperatura](figures/fig_rq1b_an_vs_diff_temp.png)
RQ2: Diferențe între regiuni privind variația temperaturii medii anuale
![RQ2 - regiune vs diferenta de temperatura](figures/fig_rq2_regiune_vs_diff_temp.png)
RQ3: Corelație între emisiile anuale de CO2 și media temperaturii
![RQ3 - CO2 vs temperatura](figures/fig_rq3_co2_vs_temp.png)
RQ4: Diferențe între regiuni privind emisiile de CO2 per capita
![RQ4 - regiune vs CO2 per capita](figures/fig_rq4_regiune_vs_co2_per_capita.png)
RQ5: Corelație între concentrația atmosferică de CO2 și media temperaturii
![RQ5 - concentratie CO2 vs temperatura](figures/fig_rq5_co2_concentratie_vs_temp.png)
RQ6: Corelație între utilizarea îngrășămintelor și randamentul cerealelor
![RQ6 - ingrasaminte vs randament](figures/fig_rq6_ingrasaminte_vs_randament.png)
RQ7: Corelație între creșterea PIB și creșterea emisiilor de CO2
![RQ7 - PIB vs cresterea CO2](figures/fig_rq7_pib_vs_co2_growth.png)
RQ8: Diferențe între regiuni privind energia regenerabilă
![RQ8 - regiune vs energie regenerabila](figures/fig_rq8_regiune_vs_renewable.png)
RQ9: Corelație între taxele ecologice și emisiile de CO2 per capita
![RQ9 - taxe ecologice vs CO2 per capita](figures/fig_rq9_env_tax_vs_co2_per_capita.png)
RQ10: Corelație între cheltuielile de mediu și emisiile de CO2 per capita
![RQ10 - cheltuieli mediu vs CO2 per capita](figures/fig_rq10_expenditure_vs_co2_per_capita.png)
RQ11-RQ16: Modele de regresie liniară multiplă
Modelele de regresie (concentrație CO2 + utilizarea terenului asupra temperaturii, PIB + combustibili fosili asupra emisiilor per capita, îngrășăminte + suprafață cultivată asupra randamentului, politici de mediu asupra emisiilor totale, și modelele complete la nivel regional/de țară) sunt construite cu `lm()` și interpretate direct în comentariile scriptului `3_statistica.R`.
---
4. Interogări SQL
Interogări SQL (PostgreSQL) pentru agregări pe an, regiune și decadă, cu vizualizare în R.
Interogarea 1: Media temperaturii globale pe an
![Evolutia temperaturii globale](figures/fig_sql1_evolutie_temp_globala.png)
Interogarea 2: Media emisiilor de CO2 per capita pe regiune
![CO2 per capita pe regiuni](figures/fig_sql2_co2_per_capita_regiuni.png)
Interogarea 3: Top 10 țări cu cele mai mari emisii de CO2 per capita
![Top 10 tari CO2](figures/fig_sql3_top10_tari_co2.png)
Interogarea 4: Evoluția temperaturii și concentrației de CO2 pe decade
![Temperatura si CO2 pe decade](figures/fig_sql4_temp_si_co2_pe_decade.png)
Interogarea 5: Politici de mediu și emisii CO2 pe regiuni (2000-2025)
![Politici de mediu pe regiuni](figures/fig_sql6_politici_mediu_regiuni.png)
---
Tehnologii folosite
R: tidyverse, DataExplorer, inspectdf, corrplot, ggstatsplot, broom, RPostgres
Bază de date: PostgreSQL
Metode statistice: corelație Spearman, test Kruskal-Wallis, regresie liniară multiplă
