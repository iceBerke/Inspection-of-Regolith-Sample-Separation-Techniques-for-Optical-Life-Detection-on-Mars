# Install required packages if not already installed
if (!require("rstatix")) install.packages("rstatix")
if (!require("dplyr")) install.packages("dplyr")

library(rstatix)
library(dplyr)

# Define your new data vectors
v_5sec <- c(19.67, 19.84, 17.65, 14.95, 17.27, 18.92, 20.97, 24.07, 23.36, 20.71, 21.58, 21.90, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00)
v_15sec <- c(37.97, 35.82, 32.43, 20.63, 25.81, 27.42, 33.33, 29.70, 30.39, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00)
v_30sec <- c(45.78, 47.22, 42.86, 62.38, 60.23, 67.95, 53.26, 47.83, 52.44, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00)
v_60sec <- c(2.88, 0.71, 1.46, 6.33, 1.64, 6.35, 2.38, 2.27, 2.33, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 1.72, 0.00, 8.04, 5.13, 8.26, 0.00, 0.00, 0.00)
hs <- c(0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00,
        15.27, 10.00, 3.13, 18.00, 13.73, 7.41, 6.67, 5.00, 11.11, 14.52, 9.09,
        19.35, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00,
        0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00)

# Combine data into vectors and factor labels
values <- c(v_5sec, v_15sec, v_30sec, v_60sec, hs)
groups <- c(
  rep("5_sec", length(v_5sec)),
  rep("15_sec", length(v_15sec)),
  rep("30_sec", length(v_30sec)),
  rep("60_sec", length(v_60sec)),
  rep("hs", length(hs))
)

# Create the data frame
df <- data.frame(
  group = factor(groups, levels = c("5_sec", "15_sec", "30_sec", "60_sec", "hs")),
  value = values
)
print(df)

# Kruskal-Wallis test
kw_test <- kruskal_test(df, value ~ group)
print(kw_test)

# Save Kruskal-Wallis result with rounded numeric values
kw_summary <- kw_test %>%
  mutate(across(where(is.numeric), ~ round(., 20)))

write.csv(kw_summary, "ecoli_vortexing_hs_kruskal_wallis_result.csv", row.names = FALSE)

# Post-hoc Dunn’s test if Kruskal-Wallis is significant
if (kw_test$p <= 0.05) {
  cat("\nKruskal-Wallis test is significant (p <= 0.05), conducting Dunn's test...\n")
  dunn_results <- dunn_test(df, value ~ group, p.adjust.method = "holm")
  print(dunn_results)
  
  dunn_results_rounded <- dunn_results %>%
    mutate(across(where(is.numeric), ~ round(., 20)))
  
  write.csv(dunn_results_rounded, "ecoli_vortexing_hs_dunn_posthoc_results.csv", row.names = FALSE)
} else {
  cat("\nKruskal-Wallis test is NOT significant (p > 0.05), skipping post-hoc.\n")
}
