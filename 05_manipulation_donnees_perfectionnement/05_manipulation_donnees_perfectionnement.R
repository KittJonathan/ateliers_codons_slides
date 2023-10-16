## Ateliers codons
## 05 - Manipulation de donnees perfectionnement
## 2023-10-16


# ⬇️ Install the packages ----------------------------------------------------

# install.packages("tidyverse")
# install.packages("palmerpenguins")
# install.packages("janitor")
# install.packages("gtExtras")
# install.packages("svglite")

# 📦 Load the packages -------------------------------------------------------

library(tidyverse)
library(palmerpenguins)
library(janitor)
library(gtExtras)
# library(svglite)

# 🔎 Explore the dataset ----------------------------------------------------

glimpse(penguins_raw)

penguins_raw |> 
  gt_plt_summary()

# 🧹 Clean the dataset -------------------------------------------------------

penguins <- penguins_raw |>
  clean_names() |>   # case = "lower_camel" / "upper_camel" / "title" / "snake"
  select(where(~n_distinct(.) > 1)) |> 
  mutate(species = str_remove_all(string = species,
                                  pattern = "[[:punct:]]"),
         species_lat = word(species, 3, 4),
         .after = species,
         species = word(species, start = 1, end = 1),
         sex = str_to_lower(sex)) |> 
  rename_with(~str_replace(., "culmen", "bill")) |> 
  select(-c(contains("delta"), comments)) |> 
  mutate(across(c(where(is.character), sample_number), as.factor))

glimpse(penguins)
