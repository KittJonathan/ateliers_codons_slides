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
  group_by(species_short) |> 
  summarise(body_mass_g_avg = mean(body_mass_g, na.rm = TRUE),
            flipper_length_mm_avg = mean(flipper_length_mm, na.rm = TRUE))

d |> 
  group_by(species_short) |> 
  summarise(
    across(
      .cols = c("body_mass_g", "flipper_length_mm"),
      .fns = ~ mean(.x, na.rm = TRUE),
      .names = "{.col}_avg"
    )
  )

d |> 
  group_by(species_short) |> 
  summarise(
    across(
      .cols = c("body_mass_g", "flipper_length_mm"),
      .fns = list(mean = ~mean(.x, na.rm = TRUE),
                  sd = ~sd(.x, na.rm = TRUE)),
      .names = "{.col}_{.fn}"
    )
  )

# ️Transform the dataset ---------------------------------------------------

d_long <- d |> 
  select(species_short, bill_length_mm:body_mass_g) |> 
  rowid_to_column(var = "penguin_id") |> 
  pivot_longer(cols = -c(penguin_id, species_short),
               names_to = "parameter",
               values_to = "value")

d_long |> 
  pivot_wider(id_cols = c(penguin_id, species_short),
              names_from = parameter,
              values_from = value)

# Joining datasets --------------------------------------------------------

d1 <- d |> 
  select(species_short, island, contains("bill")) |> 
  rowid_to_column() |> 
  slice(1:5)

d2 <- d |> 
  select(species_short, island, flipper_length_mm) |> 
  rowid_to_column() |> 
  slice(4:8)

left_join(d1, d2)
left_join(d2, d1)

right_join(d1, d2)
right_join(d2, d1)

inner_join(d1, d2)
inner_join(d2, d1)

anti_join(d1, d2)
anti_join(d2, d1)

semi_join(d1, d2)
semi_join(d2, d1)
