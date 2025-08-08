# Install and load required packages if needed
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")

library(rstatix)
library(dplyr)

# Define your actual MMS-2 Incubation data vectors
mms2_inc_v_5sec <- c(25.36, 11.62, 24.80, 29.37, 26.57, 178.68, 174.64, 174.36, 144.26)
mms2_inc_v_15sec <- c(134.89, 117.37, 177.13, 185.99, 107.20, 106.87, 100.91, 81.92, 158.43, 140.46, 123.37, 167.05)
mms2_inc_v_30sec <- c(38.86, 50.95, 18.60, 31.52, 84.91, 58.45, 183.25, 142.91, 119.15, 128.80, 117.79, 123.99, 83.07)
mms2_inc_v_60sec <- c(140.75, 144.30, 164.25, 184.79, 107.01, 130.44, 144.94, 187.15, 104.44, 89.61, 52.43, 62.00, 61.67)
mms2_inc_v_120sec <- c(96.81, 86.04, 80.06, 66.87, 43.28, 41.38, 15.26, 11.52, 36.71, 67.11, 68.42, 47.68, 45.51)
mms2_inc_v_300sec <- c(43.25, 32.85, 64.90, 69.97, 63.98, 55.33, 50.16, 66.26, 62.12, 48.04, 35.52, 29.78, 28.70, 33.48, 29.06)
mms2_inc_hs <- c(59.89, 36.76, 42.68, 57.72, 84.13, 105.04, 92.34, 100.95, 117.02, 101.56, 103.75, 96.38, 90.49, 92.99, 93.48)

# Combine the data into one vector and create a grouping factor
values <- c(mms2_inc_v_5sec, mms2_inc_v_15sec, mms2_inc_v_30sec,
            mms2_inc_v_60sec, mms2_inc_v_120sec, mms2_inc_v_300sec, mms2_inc_hs)
groups <- factor(c(
  rep("5_sec", length(mms2_inc_v_5sec)),
  rep("15_sec", length(mms2_inc_v_15sec)),
  rep("30_sec", length(mms2_inc_v_30sec)),
  rep("60_sec", length(mms2_inc_v_60sec)),
  rep("120_sec", length(mms2_inc_v_120sec)),
  rep("300_sec", length(mms2_inc_v_300sec)),
  rep("hs", length(mms2_inc_hs))
), levels = c("5_sec", "15_sec", "30_sec", "60_sec", "120_sec", "300_sec", "hs"))

# Create a data frame
df <- data.frame(group = groups, value = values)

# Preview the data
print(df)

# Run Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ group)
print(kw_test)

# Save Kruskal-Wallis test results with rounded numeric values
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "motility_mms2_incubation_kruskal_wallis_result.csv", row.names = FALSE)

# Post-hoc Dunn's test if Kruskal-Wallis is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis test is significant (p <= 0.05), conducting Dunn's test...\n")
  
  dunn_results <- dunn_test(df, value ~ group, p.adjust.method = "holm")
  print(dunn_results)
  
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "motility_mms2_incubation_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis test is NOT significant (p > 0.05), skipping post-hoc.\n")
}
