## Ateliers codons
## 05 - Manipulation de donnees perfectionnement
## 2023-09-26


# 📦 Load the packages -------------------------------------------------------

library(tidyverse)
library(palmerpenguins)
library(janitor)
library(gtExtras)
library(svglite)

# 🐧 Read the dataset --------------------------------------------------------

penguins <- palmerpenguins::penguins_raw

# 🔎 Explore the dataset ----------------------------------------------------

glimpse(penguins)

penguins |> 
  gt_plt_summary()

comments_long <- penguins |> 
  rowid_to_column() |> 
  mutate(comments = str_remove(Comments, ".$")) |> 
  separate(col = Comments,
           into = c("comment_1", "comment_2"), 
           sep = "[.]") |> 
  mutate(comment_2 = str_squish(comment_2)) |> 
  select(rowid, comment_1, comment_2) |> 
  pivot_longer(cols = -rowid, names_to = "comment_nb", values_to = "comment") |> 
  drop_na(Comment) |> 
  select(-comment_nb)

na_check <- penguins |> 
  rowid_to_column() |> 
  inner_join(comments_long) |>
  group_by(comment) |> 
  summarise(across(everything(), ~ sum(is.na(.)))) |> 
  select(comment, `Clutch Completion`:`Delta 13 C (o/oo)`)

# 🧹 Clean the dataset -------------------------------------------------------

d <- penguins |> 
  janitor::clean_names() |> 
  select(species, island, date_egg:sex) |> 
  mutate(species = str_remove_all(species, "[[:punct:]]"),
         species_short = word(species, 1, 1),
         species_latin = word(species, 3, 4),
         .before = species) |> 
  select(-species) |> 
  mutate(year = year(date_egg), .keep = "unused",
         sex = str_to_lower(sex)) |> 
  rename_with(~str_replace(.x, pattern = "culmen", replacement = "bill"),
              .cols = contains("culmen"))

# 📊 ️Summarise the dataset ---------------------------------------------------

d |> 
  count(species_short, island) |> 
  complete(species_short, island, fill = list(n = 0))

d |> 
  summarise(body_mass_g_avg = mean(body_mass_g, na.rm = TRUE),
            .by = species_short)

d |> 
  summarise(across(where(is.numeric), list(mean=mean, sd=sd), na.rm=TRUE),
            .by = species_short) |> 
  gt::gt()
