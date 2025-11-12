# Load KenPom efficiency data for model validation (optional).
# Note: KP data is proprietary and not shared in this repo. 
# Users with access may export and place their CSV in data/raw/.

# Example file name convention: data/raw/kenpom_2020.csv
input_path <- here("data", "raw", paste0("kenpom_", szn, ".csv"))

if (file.exists(input_path)) {
  kenpom_data <- read_csv(input_path, show_col_types = FALSE) %>%
    rename(team = TeamName, season = Season) %>%
    select(season, team, AdjEM, AdjOE, AdjDE) %>%
    arrange(desc(AdjEM))
  
  write_csv(kenpom_data, here("data", "interim", paste0("kenpom_", szn, "_clean.csv")))

  message("KenPom data imported and saved to data/interim/")}
else {message("KenPom file not found. Skipping validation step.")
