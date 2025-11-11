library(tidyverse)
library(hoopR)
library(here)

# Load in the full college basketball season from the year 2020:
szn <- 2020
game_schedule <- load_mbb_schedule(seasons = szn)

# Clean the schedule by renaming team name columns and reducing the data to key variables:
game_schedule_clean <- game_schedule %>%
  rename(home_team = home_location, away_team = away_location) %>%
  select(id, season, date, home_team, away_team, home_score, away_score, 
         home_winner, neutral_site, conference_competition, notes_headline)

write_csv(game_schedule_clean, here("data", "interim", paste0("game_schedule_", szn, "_clean.csv")))
