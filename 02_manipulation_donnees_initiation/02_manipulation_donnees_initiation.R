## Ateliers codons
## Parcours initiation
## Manipulation de donnees
## Derniere version 2023-09-15

## Installer et charger le {tidyverse} ----

# install.packages("tidyverse")
library(tidyverse)

# install.packages("readr")
# library(readr)

# install.packages("dplyr)
# library(dplyr)

## Importer les donnees ----

## Le package {readr} : read_*()
url <- "https://raw.githubusercontent.com/allisonhorst/palmerpenguins/main/inst/extdata/penguins.csv"

read_delim(file = url)
read_csv(file = url)

## Le package {palmerpenguins}
penguins <- palmerpenguins::penguins

## Nettoyer les donnees - dplyr::glimpse() ----

glimpse(penguins)

## Nettoyer les donnees - dplyr::select() ----

select(penguins, species)  ## conserver 1 colonne
select(penguins, -species)  ## supprimer 1 colonne
select(penguins, species, island, bill_length_mm)  ## conserver plusieurs colonnes
select(penguins, species:bill_length_mm)  ## conserver plusieurs colonnes

penguins[, c("species", "island", "bill_length_mm")]  ## R basique

penguins_selection <- select(penguins, species:bill_length_mm, flipper_length_mm, body_mass_g)

## selec(new = old) peut servir a renommer des colonnes
## rename(new = old)

select(penguins, starts_with("bill"))
select(penguins, ends_with("mm"))
select(penguins, contains("length"))

## Nettoyer les donnees - tidyr::drop_na() ----

## Le package {tidyr} : drop_na()
drop_na(penguins_selection, flipper_length_mm)
drop_na(penguins_selection)

penguins_no_na <- drop_na(penguins_selection)

## Le pipe - |> ----

## Version 1 : etape par etape
penguins <- palmerpenguins::penguins
penguins_selection <- select(penguins, species:bill_length_mm, flipper_length_mm, body_mass_g)
penguins_no_na <- drop_na(penguins_selection)

## Version 2 : imbriquer les operations
drop_na(select(penguins, species:bill_length_mm, flipper_length_mm, body_mass_g))

## Version 3 : enchainer les operations a l'aide du pipe |> 
penguins <- penguins |> 
  select(species:bill_length_mm, flipper_length_mm, body_mass_g) |> 
  drop_na()

## Nettoyer les donnees - dplyr::filter() ----

penguins |> 
  filter(species == "Adelie")

penguins[penguins$species == "Adelie", ]  ## R basique

penguins |> 
  filter(species == "Adelie", body_mass_g >= 4700)

penguins[penguins$species == "Adelie" & penguins$body_mass_g >= 4700, ]  ## R basique

penguins |> 
  filter(body_mass_g >= 4725, body_mass_g <= 4750)

penguins |> 
  filter(between(body_mass_g, 4725, 4750))

penguins |> 
  filter(species == "Adelie" | species == "Chinstrap")

penguins |> 
  filter(species %in% c("Adelie", "Chinstrap"))

penguins |> 
  filter(species != "Gentoo")

penguins |> 
  filter(!species %in% c("Adelie", "Chinstrap"))

palmerpenguins::penguins |> 
  drop_na(body_mass_g)

palmerpenguins::penguins |> 
  filter(!is.na(body_mass_g))

## Trier les donnees - dplyr::arrange() ----

penguins |> 
  arrange(body_mass_g)

penguins[order(penguins$body_mass_g), ]  ## R basique

penguins |> 
  arrange(-body_mass_g, -flipper_length_mm)

penguins |> 
  arrange(desc(body_mass_g), desc(flipper_length_mm))

penguins |> 
  arrange(-body_mass_g, -flipper_length_mm)

penguins |> 
  arrange(desc(body_mass_g), desc(flipper_length_mm))

## Le package {dplyr} : mutate() ----

## Creer de nouvelles variables (colonnes) : 
## - a partir de colonnes existantes

penguins |> 
  mutate(body_mass_kg = body_mass_g / 1000)

## R basique
head(transform(penguins, body_mass_kg = body_mass_g / 1000))

## - independamment des donnees

penguins |> 
  mutate(note = "A verifier !")

## Le package {dplyr} : summarise() ----

penguins |> 
  summarise(body_mass_g_mean = mean(body_mass_g))

## R basique
mean(penguins$body_mass_g)

penguins |> 
  summarise(n = n())

penguins |> 
  summarise(body_mass_g_mean = mean(body_mass_g),
            body_mass_g_median = median(body_mass_g))

## Le package {dplyr} : group_by() ----

penguins |> 
  group_by(species)

penguins |> 
  group_by(species, island)

penguins_groups <- penguins |> 
  group_by(species, island)

ungroup(penguins_groups)

penguins |> 
  group_by(species) |> 
  summarise(n = n(),
            body_mass_g_mean = mean(body_mass_g))

## Le package {dplyr} : distinct() et n_distinct() ----

penguins |> 
  distinct(species)

n_distinct(penguins$species)
length(unique(penguins$species))

## Le package {dplyr} : slice() ----

penguins |> 
  slice(50:55)

penguins |> 
  group_by(species) |> 
  slice(1)

penguins |> 
  slice_sample(n = 5)

penguins |> 
  group_by(species, island) |> 
  slice_sample(n = 1)

penguins |> 
  slice_sample(prop = 0.05)

penguins |> 
  slice_max(n = 5, order_by = body_mass_g)

penguins |> 
  slice_max(n = 5, order_by = body_mass_g, with_ties = FALSE)

penguins |> 
  slice_min(n = 5, order_by = body_mass_g)

penguins |> 
  group_by(species) |> 
  slice_max(n = 1, order_by = body_mass_g)

penguins |> 
  slice_max(prop = 0.01, order_by = body_mass_g)

## Le package {dplyr} : count() ----

count(penguins)

## R basique
nrow(penguins)

summarise(penguins, n = n())

penguins |> 
  count(species)

penguins |> 
  group_by(species) |> 
  summarise(n = n())

penguins |> 
  count(species, sort = TRUE)

penguins |> 
  add_count()

penguins |> 
  mutate(n = n())

penguins |> 
  add_count(species)

penguins |> 
  group_by(species) |> 
  mutate(n = n())
