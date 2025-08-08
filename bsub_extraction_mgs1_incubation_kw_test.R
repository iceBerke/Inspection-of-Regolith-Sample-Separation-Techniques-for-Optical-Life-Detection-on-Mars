# Install and load required packages if needed
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")

library(rstatix)
library(dplyr)

# Define your data vectors for MGS-1 Incubation
mgs1_inc_v_5sec <- c(20.58, 1.37, 1.70)
mgs1_inc_v_15sec <- c(0.56, 0.64, 0.92)
mgs1_inc_v_30sec <- c(2.07, 3.03, 2.52)
mgs1_inc_v_60sec <- c(0.72, 11.13, 4.23)
mgs1_inc_v_300sec <- c(240.06, 9.86)
mgs1_inc_hs <- c(36.62, 65.59, 115.28)

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
write.csv(kw_summary, "mgs1_incubation_kruskal_wallis_result.csv", row.names = FALSE)

# Post-hoc Dunn's test if Kruskal-Wallis is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis test is significant (p <= 0.05), conducting Dunn's test...\n")
  
  dunn_results <- dunn_test(df, value ~ group, p.adjust.method = "holm")
  print(dunn_results)
  
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "mgs1_incubation_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis test is NOT significant (p > 0.05), skipping post-hoc.\n")
}
