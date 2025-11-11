# The Big (What-If) Dance

**Authors:** Joseph Corritone, Travis Delgado, Owen Hom, Tyler Hooper  
**Last Updated:** November 2025

*Originally developed as part of a group project for STAT 479 (Sports Analytics) at UW-Madison*

## 🏀 Overview
**The Big (What-If) Dance** relives the 2020 college basketball season before it was ultimatley shut down due to the COVID-19 pandemic. The project's purpose is to answer the question: *How can statistical modeling and simulation explain the randomness of March Madness and identify the teams that were statistically most likely to advance in the unplayed 2020 tournament?*

## ⚙️ Workflow
1. **Identify team strength** using a Bradley-Terry model fit with all 2019-20 Division I game results.
2. **Adjust for home-court advantage** to better estimate underlying team ability.
3. **Build the 68-team tournament field** using Joe Lunardi's final bracket projection
4. **Run 5,000 Monte Carlo simulations** of the entire tournament.
5. **Summarize outcomes** by team and seed, considering championship odds, and likelihood of tournament success.

The result? A data-driven view of how the 2020 March Madness tournament may have played out, from dominant favorites (Kansas, Gonzaga, Dayton) to potential Cinderellas (East Tennessee State, Arizona State)

## 📊 Methods

**Data**
- Game-level results using the hoopR package.
- Team efficiency metrics from KenPom.com to validate team strengths.
- Joe Lunardi's final projection of the 68-team bracket in a CSV, structured to follow the simulations.

**Modeling**
- Bradley-Terry model that estimates latent strength (λ) of each Division I college basketball team in the 2019-20 season, with win probability: \[
    P(i \text{ beats } j) = \frac{e^{\lambda_i}}{e^{\lambda_i} + e^{\lambda_j}}
    \]
  - An extension using an "at_home" covariate to improve the model
  - Validation of latent strengths with KenPom's Adjusted Efficiency Margin (r = 0.97).
 
  **Simulation**
  - Use the projected bracket and essential functions to:
  1. Resolve the First Four.
  2. Progress round-by-round using win probabilities of each game from the Bradley-Terry model.
  3. Repeat 5,000 full runs through the tournament.
  4. Collect Results of Title, Final 4, etc. probabilities for each team.
 
## 📈 Key Findings

*For full detail, see 'results/' and 'figures/'*
- **Kansas emerges** as a clear favorite with a title probability more than double of any other team.
- **1-seeds outperform** historical title rates, reflecting how strong the top end teams were.
- **Cinderella watch**: East Tennessee State (11), Arizona State (10), and USC (10) emerge as most common double digit to make a deep tournament run.
  
## ⚠️ Limitations 

- Because the tournament bracket was never released, the unused bracket projection could reflect different paths for teams compared to the actual bracket.
- The model assumes a neutral site for all tournament games, but does not consider effects for games that are significantly closer to one school than another (ex: Wisconsin vs. Florida being played in Milwaukee.
    - Developing a 'distance_from_school' variable could provide greater context to tournament games.
- The model assumes the same health from all players and teams across the season. With teams facing adversity at different points of the year, teams actual strength in the tournament may not be perfectly represented by the Bradley-Terry latent strength.
