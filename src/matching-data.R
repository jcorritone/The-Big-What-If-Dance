# Standardize team names in game_schedule and (optional) kenpom_data.

library(tidyverse)
library(stringr)
library(stringi)
library(here)

szn <- 2020

# Paths
schedule_path <- here("data", "interim", paste0("game_schedule_", szn, "_clean.csv"))
kenpom_path <- here("data", "interim", paste0("kenpom_", szn, "_clean.csv"))
schedule_output <- here("data", "processed", paste0("schedule_", szn, "_standardized.csv"))
kenpom_output <- here("data", "processed", paste0("kenpom_", szn, "_standardized.csv"))
unmatched_output <- here("results", paste0("unmatched_teams_", szn, ".csv"))

# Output Directories
dir.create(here("data", "processed"), recursive = TRUE, showWarnings = FALSE)
dir.create(here("results"), recursive = TRUE, showWarnings = FALSE)

# Load inputs
schedule <- read_csv(schedule_path, show_col_types = FALSE)

kenpom_exists <- file.exists(kenpom_path) 
if (kenpom_exists) {
  kenpom <- read_csv(kenpom_path, show_col_types = FALSE)}

# String cleaner to standardize common patterns
string_cleaner <- function(x) {
  x %>%
    str_squish() %>%
    str_replace_all("(?<!^)\\bSt\\.?\\b", "State") %>%
    str_replace_all("State\\.(?=\\s)", "State ") %>%
    str_replace("\\.$", "") %>%
    str_replace_all("[-–—]", " ") %>%
    str_replace_all("[()]", "") %>%
    str_replace_all("[’']", "") %>%
    stri_trans_general("Latin-ASCII") %>%
    str_squish()
}

# Apply string cleaner standardization:
schedule_sc <- schedule %>%
  mutate(home_team_sc = string_cleaner(home_team),
         away_team_sc = string_cleaner(away_team))

if (kenpom_exists) {
  kenpom_sc <- kenpom %>%
    mutate(team = string_cleaner(team))}

# Standardization helps, but some inconsistencies may remain. The following represent the 2020 inconsistencies:

if (kenpom_exists) {
  kenpom_to_schedule <- c(
    "American"                = "American University",
    "Cal Baptist"             = "California Baptist",
    "Connecticut"             = "UConn",
    "Detroit"                 = "Detroit Mercy",
    "FIU"                     = "Florida International",
    "Grambling State"         = "Grambling",
    "Houston Baptist"         = "Houston Christian",
    "Illinois Chicago"        = "UIC",
    "UMKC"                    = "Kansas City",
    "LIU"                     = "Long Island University",
    "Louisiana Monroe"        = "UL Monroe",
    "Loyola MD"               = "Loyola Maryland",
    "Massachusetts"           = "UMass",
    "McNeese State"           = "McNeese",
    "Miami FL"                = "Miami",
    "N.C. State"              = "NC State",
    "Nebraska Omaha"          = "Omaha",
    "Nicholls State"          = "Nicholls",
    "Mississippi"             = "Ole Miss",
    "Penn"                    = "Pennsylvania",
    "Sam Houston State"       = "Sam Houston",
    "Seattle"                 = "Seattle U",
    "Southeastern Louisiana"  = "SE Louisiana",
    "USC Upstate"             = "South Carolina Upstate",
    "Tennessee Martin"        = "UT Martin",
    "Texas A&M Corpus Chris"  = "Texas A&M Corpus Christi",
    "St. Francis NY"          = "St. Francis Brooklyn")}

# Fix remaining name changes to match schedule data
if (kenpom_exists) {
  kenpom_sc <- kenpom_sc %>%
    mutate(team = recode(team, !!!kenpom_to_schedule))}

# Unmatched Report (to determine if matching worked correctly)
if (kenpom_exists) {
  schedule_universe <- bind_rows(
    schedule_sc %>% transmute(team = home_team_sc),
    schedule_sc %>% transmute(team = away_team_sc)) %>%
  distinct()

  unmatched_from_kenpom <- kenpom_sc %>%
    anti_join(schedule_universe, by = "team") %>%
    transmute(source = "kenpom_not_in_schedule", team)

  unmatched_from_schedule <- schedule_universe %>%
    anti_join(kenpom_sc %>% select(team), by = "team") %>%
    transmute(source = "schedule_not_in_kenpom", team)

  unmatched <- bind_rows(unmatched_from_kenpom, unmatched_from_schedule) %>%
    arrange(source, team)

  if (nrow(unmatched) > 0) {
    write_csv(unmatched, unmatched_output)
    message("Unmatched Report: ", unmatched_output, " (", nrow(unmatched), " rows)")}
  else {
    message("No unmatched teams")}}
else {
  message("KenPom not present, skipped Unmatched Report")}

# Write Outputs
write_csv(schedule_sc, schedule_output)
message("Wrote standardized schedule: ", schedule_output)

if (kenpom_exists) {
  write_csv(kenpom_sc, kenpom_output)
  message("Wrote standardized KenPom: ", kenpom_output)}
