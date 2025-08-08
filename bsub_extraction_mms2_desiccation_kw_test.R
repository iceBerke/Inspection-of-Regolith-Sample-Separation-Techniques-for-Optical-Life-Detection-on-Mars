# Install required packages if not installed
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")

library(rstatix)
library(dplyr)

# Define MMS-2 Desiccation data vectors
mms2_ds_v_5sec <- c(76.42, 10.40, 49.49)
mms2_ds_v_15sec <- c(8.52, 9.54, 0.81)
mms2_ds_v_30sec <- c(10.14, 1.59, 6.00)
mms2_ds_v_60sec <- c(0.89, 5.48, 34.96)
mms2_ds_v_120sec <- c(5.12, 0.80)
mms2_ds_v_300sec <- c(1.00, 0.32, 0.91)
mms2_ds_hs <- c(19.01, 23.00, 13.93)

# Combine data into a single vector
values <- c(
  mms2_ds_v_5sec,
  mms2_ds_v_15sec,
  mms2_ds_v_30sec,
  mms2_ds_v_60sec,
  mms2_ds_v_120sec,
  mms2_ds_v_300sec,
  mms2_ds_hs
)

# Create a grouping factor for time/treatment
groups <- factor(c(
  rep("5_sec", length(mms2_ds_v_5sec)),
  rep("15_sec", length(mms2_ds_v_15sec)),
  rep("30_sec", length(mms2_ds_v_30sec)),
  rep("60_sec", length(mms2_ds_v_60sec)),
  rep("120_sec", length(mms2_ds_v_120sec)),
  rep("300_sec", length(mms2_ds_v_300sec)),
  rep("hs", length(mms2_ds_hs))
),
levels = c("5_sec", "15_sec", "30_sec", "60_sec", "120_sec", "300_sec", "hs")
)

# Create a data frame
df <- data.frame(group = groups, value = values)

# Preview the data
print(df)

# Run Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ group)
print(kw_test)

# Save Kruskal-Wallis test result with rounded numeric values
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "mms2_desiccation_kruskal_wallis_result.csv", row.names = FALSE)

# Post-hoc Dunn's test if Kruskal-Wallis is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis test is significant (p <= 0.05), conducting Dunn's post-hoc test...\n")
  dunn_results <- dunn_test(df, value ~ group, p.adjust.method = "holm")
  print(dunn_results)
  
  # Round numeric columns for clean saving
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "mms2_desiccation_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis test is NOT significant (p > 0.05), skipping post-hoc tests.\n")
}
