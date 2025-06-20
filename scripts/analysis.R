install.packages("tidyverse")
install.packages("brms")
install.packages("bayesplot")
install.packages("broom")

library(tidyverse)
library(brms)       
library(bayesplot)  
library(broom)      

usvotes <- read_csv("D:/MSc Computer Science Data Science/Applied Statistical Modelling/main_assignment/USvotes.csv")

# View the first few rows
head(usvotes)

# See the column names
colnames(usvotes)
# Basic statistical summary of important columns
summary(usvotes %>% select(per_gop, Crude.Prevalence.Estimate, race))

# Scatter plot: Depression (%) vs Republican votes (%)
ggplot(usvotes, aes(x = Crude.Prevalence.Estimate, y = per_gop)) +
  geom_point(alpha = 0.5) +
  labs(title = "Republican Vote % vs Depression % by County",
       x = "Depression Prevalence (%)",
       y = "Republican Vote Percentage") +
  theme_minimal()

# Scatter plot: Race (white %) vs Republican votes (%)
ggplot(usvotes, aes(x = race, y = per_gop)) +
  geom_point(alpha = 0.5, color = "blue") +
  labs(title = "Republican Vote % vs Race (White %) by County",
       x = "Proportion White",
       y = "Republican Vote Percentage") +
  theme_minimal()

# Histogram of depression rates
ggplot(usvotes, aes(x = Crude.Prevalence.Estimate)) +
  geom_histogram(binwidth = 2, fill = "orange", color = "black") +
  labs(title = "Distribution of Depression Prevalence Across Counties",
       x = "Depression Prevalence (%)",
       y = "Count of Counties") +
  theme_minimal()

# Simple Linear Regression: Republican Vote % vs Depression %
model_simple <- lm(per_gop ~ Crude.Prevalence.Estimate, data = usvotes)

# Summary of the model
summary(model_simple)

# Multiple Regression: Republican Vote % vs Depression % + Race
model_multiple <- lm(per_gop ~ Crude.Prevalence.Estimate + race, data = usvotes)

# Summary of the multiple regression model
summary(model_multiple)

# Bayesian Regression: Republican Vote % vs Depression %
bayes_model_simple <- brm(
  formula = per_gop ~ Crude.Prevalence.Estimate,
  data = usvotes,
  family = gaussian(),
  chains = 4, 
  cores = 4, 
  iter = 2000,
  seed = 123
)

# Summary of Bayesian model
summary(bayes_model_simple)


# Bayesian Multiple Regression: Republican Vote % vs Depression % + Race
bayes_model_multiple <- brm(
  formula = per_gop ~ Crude.Prevalence.Estimate + race,
  data = usvotes,
  family = gaussian(),
  chains = 4,
  cores = 4,
  iter = 2000,
  seed = 123
)

# Summary of Bayesian multiple regression model
summary(bayes_model_multiple)

# Step 1: Extract posterior summaries
posterior_data <- as.data.frame(summary(bayes_model_multiple)$fixed)

# View what we have
print(posterior_data)

# Step 2: Create a dataframe for plotting
coef_data <- posterior_data %>%
  rownames_to_column(var = "term") %>%
  filter(term %in% c("Crude.Prevalence.Estimate", "race")) %>%
  mutate(
    term = recode(term,
                  "Crude.Prevalence.Estimate" = "Depression Prevalence",
                  "race" = "Race (Proportion White)")
  )

# Step 3: Now plot
library(ggplot2)

central_plot <- ggplot(coef_data, aes(x = Estimate, y = term)) +
  geom_point(size = 3) +
  geom_errorbarh(aes(xmin = `l-95% CI`, xmax = `u-95% CI`), height = 0.2) +
  labs(
    title = "Bayesian Estimates: Effect of Depression and Race on Republican Voting",
    x = "Posterior Mean Estimate (with 95% Credible Interval)",
    y = ""
  ) +
  theme_minimal()

# Step 4: Display plot
print(central_plot)

# Step 5: Optional: Save plot to a file
ggsave("central_figure.png", plot = central_plot, width = 8, height = 6, dpi = 300)

central_plot + 
  theme(
    axis.text.y = element_text(face = "bold", size = 12),
    axis.text.x = element_text(size = 12),
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5)
  )

central_plot + 
  geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
  theme(
    axis.text.y = element_text(face = "bold", size = 12),
    axis.text.x = element_text(size = 12),
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5)
  )

ggsave("central_figure.png", plot = central_plot, width = 8, height = 6, dpi = 300)

