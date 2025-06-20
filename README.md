
# Bayesian Regression on US Depression & Voting Patterns

This project explores the relationship between county-level depression rates and voting behavior in the United States using both classical and Bayesian regression models.

## 📊 Dataset
- `USvotes.csv`: Includes features such as `per_gop` (Republican vote %), `Crude.Prevalence.Estimate` (depression %), and `race` (proportion White).
- Source: [Manually curated public dataset]

## 🔍 Analysis Performed
- Data exploration with `tidyverse`
- Linear and multiple regression modeling
- Bayesian modeling with `brms`
- Visualizations using `ggplot2` and posterior estimates

## 🧠 Key Tools & Libraries
- R, tidyverse, brms, bayesplot, ggplot2, broom

## 📈 Result Summary
We observed:
- A slight negative correlation between depression prevalence and Republican vote share.
- Race (White proportion) was positively associated with Republican votes.
- Bayesian inference provided clearer uncertainty estimates with credible intervals.

## 📂 Repository Structure
