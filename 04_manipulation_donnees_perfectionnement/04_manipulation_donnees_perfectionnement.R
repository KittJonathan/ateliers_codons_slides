## Ateliers codons
## Parcours perfectionnement
## Manipulation de donnees
## Derniere version 2023-09-13

## Charger les packages ----

library(tidyverse)
library(palmerpenguins)

## Importer les donnees ----

## Apercu des donnees
head(penguins_raw)

## {read_csv} avance
read_csv("04_manipulation_donnees_perfectionnement/penguins_raw.csv",
         col_types = "ffffffffDdddifddc",
         col_select = c(3:5, 9:14))

## Importer les donnees ----

pen <- palmerpenguins::penguins_raw

## Package {janitor} : nettoyer les noms de colonnes ----

pen <- pen |> 
  janitor::clean_names()

## Package {gtExtras} : explorer les donnees ----

dplyr::glimpse(pen)

pen |> 
  gtExtras::gt_plt_summary()

## Package {select} : selectionner les colonnes ----

pen <- pen |> 
  dplyr::select(-stage, -region, -delta_15_n_o_oo, -delta_13_c_o_oo, -comments)


## Le package {dplyr} : mutate() ----

mutate(pen, note = ifelse(body_mass_g >= 5000, "heavy", "light"))

mutate(pen, id = dplyr::row_number())

pen |> 
  dplyr::mutate(dplyr::across(where(is.character), as.factor))

mutate(pen, species = stringr::str_to_lower(species))

pen |> 
  select(individual_id, culmen_length_mm, culmen_depth_mm) |> 
  filter(!is.na(culmen_length_mm)) |> 
  mutate(across(where(is.numeric),
                list(avg = mean, med = median)))

## Le package {dplyr} : summarise() ----

pen |> 
  filter(!is.na(culmen_depth_mm)) |> 
  summarise(across(is.numeric, mean))

pen |> 
  filter(!is.na(culmen_depth_mm)) |> 
  summarise(across(c("culmen_length_mm", "culmen_depth_mm"), mean))

pen |> 
  summarise(across(c("culmen_length_mm", "culmen_depth_mm"), ~ mean(.x, na.rm = TRUE)))

pen |> 
  summarise(across(c("culmen_length_mm", "culmen_depth_mm"),
                   list(avg = ~mean(., na.rm = TRUE),
                        max = ~max(., na.rm = TRUE))))

# Le package {dplyr} : *_join() ----

d1 <- pen |> 
  filter(!is.na(flipper_length_mm)) |> 
  tibble::rowid_to_column(var = "id") |> 
  slice(1:6) |> 
  select(id, flipper_length_mm)

d2 <- pen |> 
  filter(!is.na(flipper_length_mm)) |> 
  tibble::rowid_to_column(var = "id") |> 
  slice(5:10) |> 
  select(id, body_mass_g)

left_join(d1, d2)

right_join(d1, d2)

inner_join(d1, d2)

full_join(d1, d2)

## Le package {tidyr} : tidy data ----

## Format large :
## - variables et/ou observations étalées dans de nombreuses colonnes
## - certaines valeurs sont encodées dans les noms de colonnes

tibble(
  group = LETTERS[1:3],
  metric_x_22 = c(46, 2, 21),
  metric_y_22 = c(12, 35, 24),
  metric_x_23 = c(32, 16, 7),
  metric_y_23 = c(1, 42, 27),
)

## Format long : 
## - chaque ligne est une seule mesure
## - toutes les mesures sont stockées dans une seule colonne

tibble(
  group = rep(LETTERS[1:3], 4),
  year = rep(rep(c(2022, 2023), each = 3), times = 2),
  metric = rep(c("x", "y"), each = 6),
  value = c(46, 2, 21, 32, 16, 7,
            12, 35, 24, 1, 42, 27)
)

## Format tidy : 
## - une ligne = 1 observation, colonnes = variables
## - 1 valeur dans une cellule

tibble(
  group = rep(LETTERS[1:3], 2),
  year = rep(rep(c(2022, 2023), each = 3)),
  metric_x = c(10, 2, 13, 12, 16, 7),
  metric_y = c(32, 35, 10, 43, 42, 27)
)

## Le package {tidyr} - complete() ----

pen |> 
  count(species, island)

pen |> 
  count(species, island) |> 
  tidyr::complete(species, tidyr::nesting(island))

pen |> 
  count(species, island) |> 
  tidyr::complete(species, island)

pen |> 
  count(species, island) |> 
  tidyr::complete(species, island, fill = list(n = 0))

## Le package {tidyr} - pivot_*() ----

pen |> 
  group_by(species, island) |> 
  summarise(mean_mass = mean(body_mass_g, na.rm = T))

pen |> 
  group_by(species, island) |> 
  summarise(mean_mass = mean(body_mass_g, na.rm = T)) |> 
  tidyr::complete(species, island, fill = list(n = 0))

d3 <- pen |> 
  tibble::rowid_to_column(var = "ind_num") |> 
  dplyr::select(ind_num, species, island, body_mass_g) |> 
  dplyr::slice(1:10)
  
tidyr::pivot_wider(data = d3,
                   names_from = ind_num,
                   values_from = body_mass_g)
