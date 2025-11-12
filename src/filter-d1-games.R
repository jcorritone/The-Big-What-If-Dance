# Keep only Division I vs Division I games

library(tidyverse)
library(here)

szn <- 2020

# Paths
schedule_path <- here("data", "processed", paste0("schedule_", szn, "_standardized.csv"))
kenpom_path <- here("data", "processed", paste0("kenpom_", szn, "_standardized.csv"))
output_path <- here("data", "processed", paste0("schedule_", szn, "_d1only.csv"))
unmatched_output <- here("results", paste0("unmatched_teams_d1_", szn, ".csv"))

# Import Schedule
schedule <- read_csv(schedule_path, show_col_types = FALSE)

if (!file.exists(kenpom_path)) {
  message("KenPom data not found, skipping D1 filter.")}
else {
  kenpom <- read_csv(kenpom_path, show_col_types = FALSE)
  d1_teams <- kenpom$team
  
# Filter Division I games
  schedule_d1 <- schedule %>%
    filter(home_team_sc %in% d1_teams, away_team_sc %in% d1_teams)

  # Unmatched Check
  unmatched <- bind_rows(
    schedule_d1 %>% transmute(team = home_team_sc),
    schedule_d1 %>% transmute(team = away_team_sc)) %>%
  distinct() %>%
  anti_join(kenpom %>% select(team), by = "team")

  if (nrow(unmatched) > 0) {
    write_csv(unmatched, unmatched_output)
    message("Unmatched teams: ", unmatched_output, " (", nrow(unmatched), ")")}
  else {
    message("All D1 team names matched.")}

  write_csv(schedule_d1, output_path)
  message("Wrote Division I schedule: ", output_path)}
