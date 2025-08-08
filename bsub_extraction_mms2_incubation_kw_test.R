# Load necessary packages
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")

library(rstatix)
library(dplyr)

# Define MMS-2 Incubation data (given vectors)
mms2_inc_v_5sec <- c(104.12, 12468.96)
mms2_inc_v_15sec <- c(2277.68, 1825.30, 4121.88)
mms2_inc_v_30sec <- c(545.36, 356.53, 23224.55)
mms2_inc_v_60sec <- c(1138.87, 18101.11, 1091.28)
mms2_inc_v_120sec <- c(230.95, 91.50, 173.21)
mms2_inc_v_300sec <- c(76.01, 107.14, 80.01)
mms2_inc_hs <- c(197.76, 48.63, 27.79)

# Combine the data into one vector
values <- c(
  mms2_inc_v_5sec, mms2_inc_v_15sec, mms2_inc_v_30sec, mms2_inc_v_60sec, 
  mms2_inc_v_120sec, mms2_inc_v_300sec, mms2_inc_hs
)

# Create grouping factor for time/treatment
groups <- factor(c(
  rep("5_sec", length(mms2_inc_v_5sec)),
  rep("15_sec", length(mms2_inc_v_15sec)),
  rep("30_sec", length(mms2_inc_v_30sec)),
  rep("60_sec", length(mms2_inc_v_60sec)),
  rep("120_sec", length(mms2_inc_v_120sec)),
  rep("300_sec", length(mms2_inc_v_300sec)),
  rep("hs", length(mms2_inc_hs))
),
levels = c("5_sec", "15_sec", "30_sec", "60_sec", "120_sec", "300_sec", "hs")
)

# Create data frame
df <- data.frame(group = groups, value = values)

# Preview data
print(df)

# Run Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ group)
print(kw_test)

# Save Kruskal-Wallis results with rounded values
kw_summary <- kw_test %>% mutate(across(where(is.numeric), ~ round(., 20)))
write.csv(kw_summary, "mms2_incubation_kruskal_wallis_result.csv", row.names = FALSE)

# Post-hoc Dunn's test if Kruskal-Wallis is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis test is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ group, p.adjust.method = "holm")
  print(dunn_results)
  
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "mms2_incubation_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis test is NOT significant (p > 0.05), skipping post-hoc.\n")
}
