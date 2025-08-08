# Install and load required packages if needed
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")

library(rstatix)
library(dplyr)

# Define your actual MGS-1 Incubation data vectors
mgs1_inc_v_5sec <- c(0.00, 0.00, 0.00, 0.00, 171.77, 167.00, 182.18, 140.90, 473.74, 473.74, 473.74, 473.74)
mgs1_inc_v_15sec <- c(473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74)
mgs1_inc_v_30sec <- c(473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74)
mgs1_inc_v_60sec <- c(473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74, 473.74)
mgs1_inc_v_300sec <- c(52.64, 323.53, 30.56, 206.50, 58.10, 236.87, 32.51, 236.87, 17.55, 8.77, 0.00, 183.92, 195.68, 136.50, 145.28)
mgs1_inc_hs <- c(133.99, 129.79, 68.67, 86.86, 89.85, 94.52, 72.24, 87.71, 47.81, 83.49, 42.16, 54.11, 81.68, 115.93, 202.09, 124.70, 130.69, 163.36)

# Combine the data into one vector and create a grouping factor
values <- c(mgs1_inc_v_5sec, mgs1_inc_v_15sec, mgs1_inc_v_30sec, mgs1_inc_v_60sec, mgs1_inc_v_300sec, mgs1_inc_hs)
groups <- factor(c(
  rep("5_sec", length(mgs1_inc_v_5sec)),
  rep("15_sec", length(mgs1_inc_v_15sec)),
  rep("30_sec", length(mgs1_inc_v_30sec)),
  rep("60_sec", length(mgs1_inc_v_60sec)),
  rep("300_sec", length(mgs1_inc_v_300sec)),
  rep("hs", length(mgs1_inc_hs))
), levels = c("5_sec", "15_sec", "30_sec", "60_sec", "300_sec", "hs"))

# Create a data frame
df <- data.frame(group = groups, value = values)

# Preview the data
print(df)

# Run Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ group)
print(kw_test)

# Save Kruskal-Wallis test results with rounded numeric values
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "motility_mgs1_incubation_kruskal_wallis_result.csv", row.names = FALSE)

# Post-hoc Dunn's test if Kruskal-Wallis is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis test is significant (p <= 0.05), conducting Dunn's test...\n")
  
  dunn_results <- dunn_test(df, value ~ group, p.adjust.method = "holm")
  print(dunn_results)
  
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "motility_mgs1_incubation_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis test is NOT significant (p > 0.05), skipping post-hoc.\n")
}
