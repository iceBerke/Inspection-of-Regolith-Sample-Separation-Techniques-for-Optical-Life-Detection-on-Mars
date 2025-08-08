# Install and load required packages if needed
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")

library(rstatix)
library(dplyr)

# Define your actual MMS-2 Desiccation data vectors
mms2_des_v_5sec <- c(0.00, 0.00, 0.00, 0.00, 789.26, 393.59, 0.00, 0.00, 0.00, 288.94, 113.09, 0.00, 0.00)
mms2_des_v_15sec <- c(0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 1180.09, 0.00, 824.45)
mms2_des_v_30sec <- c(2432.45, 1912.08, 2589.81, 3388.28, 0.00, 0.00, 1260.09, 0.00, 0.00, 0.00, 0.00, 1771.09, 0.00, 0.00)
mms2_des_v_60sec <- c(0.00, 0.00, 0.00, 0.00, 0.00, 729.34, 832.48, 1084.42, 0.00, 0.00, 743.82, 457.02, 369.58, 783.05)
mms2_des_v_120sec <- c(0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00)
mms2_des_v_300sec <- c(9464.06, 4301.85, 11356.87, 10816.07, 0.00, 0.00, 4673.61, 0.00, 0.00,
                       3819.04, 0.00, 6429.94, 1585.60, 6692.82, 2021.70)
mms2_des_hs <- c(1210.48, 1928.08, 2058.36, 1206.48, 648.16, 0.00, 870.39, 923.14, 1582.53, 743.02, 0.00, 297.21, 591.53, 564.14)

# Combine the data into one vector and create a grouping factor
values <- c(mms2_des_v_5sec, mms2_des_v_15sec, mms2_des_v_30sec,
            mms2_des_v_60sec, mms2_des_v_120sec, mms2_des_v_300sec, mms2_des_hs)

groups <- factor(c(
  rep("5_sec", length(mms2_des_v_5sec)),
  rep("15_sec", length(mms2_des_v_15sec)),
  rep("30_sec", length(mms2_des_v_30sec)),
  rep("60_sec", length(mms2_des_v_60sec)),
  rep("120_sec", length(mms2_des_v_120sec)),
  rep("300_sec", length(mms2_des_v_300sec)),
  rep("hs", length(mms2_des_hs))
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
write.csv(kw_summary, "motility_mms2_desiccation_kruskal_wallis_result.csv", row.names = FALSE)

# Post-hoc Dunn's test if Kruskal-Wallis is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis test is significant (p <= 0.05), conducting Dunn's test...\n")
  
  dunn_results <- dunn_test(df, value ~ group, p.adjust.method = "holm")
  print(dunn_results)
  
  dunn_results_rounded <- dunn_results %>% mutate(across(where(is.numeric), ~ round(., 20)))
  write.csv(dunn_results_rounded, "motility_mms2_desiccation_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis test is NOT significant (p > 0.05), skipping post-hoc.\n")
}
