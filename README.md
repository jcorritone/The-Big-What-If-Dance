# The Big (What-If) Dance

**Authors:** Joseph Corritone, Travis Delgado, Owen Hom, Tyler Hooper  
**Last Updated:** November 2025

*Originally developed as part of a group project for STAT 479 (Sports Analytics) at UW-Madison*

## 🏀 Overview
**The Big (What-If) Dance** relives the 2020 college basketball season before it was ultimately shut down due to the COVID-19 pandemic. The project's purpose is to answer the question: *How can statistical modeling and simulation explain the randomness of March Madness and identify the teams that were statistically most likely to advance in the unplayed 2020 tournament?*

## ⚙️ Workflow
1. **Identify team strength** using a Bradley-Terry model fit with all 2019-20 Division I game results.
2. **Adjust for home-court advantage** to better estimate underlying team ability.
3. **Build the 68-team tournament field** using Joe Lunardi's final bracket projection.
4. **Run 5,000 Monte Carlo simulations** of the entire tournament.
5. **Summarize outcomes** by team and seed, considering championship odds, and likelihood of tournament success.

The result: A data-driven view of how the 2020 March Madness tournament may have played out, from dominant favorites (Kansas, Gonzaga, Dayton) to potential Cinderellas (East Tennessee State, Arizona State).

## 📊 Methods

**Data**
- Game-level results using the [`hoopR`](https://github.com/andreweatherman/hoopR) package.  
- Team efficiency metrics from [KenPom.com](https://kenpom.com) to validate team strengths.  
- Joe Lunardi's final projection of the 68-team bracket (CSV structured to follow the simulation process).

**Modeling**
- Bradley-Terry model that estimates latent strength (λ) of each Division I college basketball team in the 2019-20 season, with win probability: \[
  P(i\ \text{beats}\ j)=\frac{e^{\lambda_i}}{e^{\lambda_i}+e^{\lambda_j}}
  \]
  - An extension using an `at_home` covariate to improve the model.
  - Validation of latent strengths with KenPom's Adjusted Efficiency Margin (r = 0.97).
 
  **Simulation**
  - Use the projected bracket and essential functions to:
  1. Resolve the First Four.
  2. Progress round-by-round using modeled win probabilities.
  3. Repeat 5,000 full tournament runs.
  4. Collect results of each team's advancement probabilities to each round.
 
## 📈 Key Findings

*For full detail, see `results/` and `figures/`.*

- **Kansas emerges** as a clear favorite with a title probability more than double that of any other team.
- **1-seeds outperform** historical title rates, reflecting how strong the 2020 top teams were.
- **Cinderella watch**: East Tennessee State (11), Arizona State (10), and USC (10) emerge as the most common double digit seeds to make a deep tournament run.
  
## ⚠️ Limitations 

- Because the official 2020 bracket was never released, Lunardi’s projection may not perfectly match the true tournament paths.
- The model assumes a neutral site for all tournament games, but does not account for location effects (ex: Wisconsin vs. Florida being played in Milwaukee).  
  - Developing a `distance_from_school` variable could provide greater context to tournament games.
- The model assumes constant team health and performance. Real-world factors like late-season injuries or momentum are not represented.
