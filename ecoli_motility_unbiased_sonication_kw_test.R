## Kruskal-Wallis and Dunn’s Post-hoc Test
## Adapted for sonication data with unequal group sizes and non-normal distributions

# Install required packages if not already installed
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")

library(rstatix)
library(dplyr)

# Define your data
s_30sec <- c(7.61, 5.94, 7.77, 6.98, 3.45, 10.00, 7.41, 7.69, 14.29)
s_1min <- c(6.02, 5.81, 8.64, 17.14, 11.58, 21.57, 5.56, 5.33, 5.45, 4.17, 4.23, 6.33, 10.64, 10.87, 13.64, 8.82, 3.13, 4.26, 19.35, 11.11, 32.20, 34.33, 23.94, 25.30, 35.54, 33.33, 36.90)
s_2min <- c(62.31, 69.47, 52.67, 26.98, 11.86, 16.22, 36.07, 36.17, 48.33, 45.54, 14.08, 7.69, 5.75, 32.61, 33.96, 30.61, 22.22, 41.38, 44.44)
s_5min <- c(20.00, 12.93, 13.22, 12.71, 13.39, 19.38, 13.82, 12.24, 14.84, 12.57, 66.67, 47.42, 64.15, 65.31, 50.00, 54.39, 59.52, 26.91)
s_10min <- c(0.00, 1.05, 0.00, 0.00, 0.00, 0.00, 2.63, 0.00, 0.00, 8.54, 
             7.89, 6.82, 9.46, 0.00, 1.61, 0.80, 1.38, 1.50, 3.70, 0.59, 
             1.70, 1.17, 6.82, 4.35, 7.91, 3.61, 7.87, 4.71, 0.00, 0.00, 
             0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00)
s_30min <- c(70.27, 31.25, 44.12, 54.05, 27.03, 10.39, 6.67, 20.25, 79.41, 20.00, 46.67, 46.43, 46.43, 44.00, 55.56, 47.06, 47.37)
s_60min <- c(58.33, 42.86, 33.33, 6.00, 1.72, 1.64, 2.98, 4.97, 4.49)
s_120min <- c(7.94, 7.41, 3.77, 12.50, 15.00, 19.30)

# Combine into a data frame
values <- c(s_30sec, s_1min, s_2min, s_5min, s_10min, s_30min, s_60min, s_120min)
groups <- c(
  rep("30_sec", length(s_30sec)),
  rep("1_min", length(s_1min)),
  rep("2_min", length(s_2min)),
  rep("5_min", length(s_5min)),
  rep("10_min", length(s_10min)),
  rep("30_min", length(s_30min)),
  rep("60_min", length(s_60min)),
  rep("120_min", length(s_120min))
)

df <- data.frame(
  group = factor(groups, levels = c("30_sec", "1_min", "2_min", "5_min", "10_min", "30_min", "60_min", "120_min")),
  value = values
)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ group)
print(kw_test)

# Save Kruskal-Wallis result
kw_summary <- kw_test %>%
  mutate(across(where(is.numeric), ~ round(., 20)))  # Round numbers to 4 decimals

write.csv(kw_summary, "ecoli_sonication_kruskal_wallis_result.csv", row.names = FALSE)

# Post-hoc test: only if significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis test is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ group, p.adjust.method = "holm")
  print(dunn_results)
  
  dunn_results_rounded <- dunn_results %>%
    mutate(across(where(is.numeric), ~ round(., 20)))  # Round numbers nicely
  
  write.csv(dunn_results_rounded, "ecoli_sonication_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis test is NOT significant (p > 0.05), skipping post-hoc.\n")
}
