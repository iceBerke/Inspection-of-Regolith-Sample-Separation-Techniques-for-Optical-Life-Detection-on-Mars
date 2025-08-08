# Install required packages if missing
packages <- c("rcompanion", "rstatix")
install_if_missing <- function(p) {
  if (!requireNamespace(p, quietly = TRUE)) install.packages(p)
}
lapply(packages, install_if_missing)

# Load libraries
library(rcompanion)
library(rstatix)

# Define MMS-2 Incubation data vectors
mms2_inc_v_5sec <- c(25.36, 11.62, 24.80, 29.37, 26.57, 178.68, 174.64, 174.36, 144.26)
mms2_inc_v_15sec <- c(134.89, 117.37, 177.13, 185.99, 107.20, 106.87, 100.91, 81.92, 158.43, 140.46, 123.37, 167.05)
mms2_inc_v_30sec <- c(38.86, 50.95, 18.60, 31.52, 84.91, 58.45, 183.25, 142.91, 119.15, 128.80, 117.79, 123.99, 83.07)
mms2_inc_v_60sec <- c(140.75, 144.30, 164.25, 184.79, 107.01, 130.44, 144.94, 187.15, 104.44, 89.61, 52.43, 62.00, 61.67)
mms2_inc_v_120sec <- c(96.81, 86.04, 80.06, 66.87, 43.28, 41.38, 15.26, 11.52, 36.71, 67.11, 68.42, 47.68, 45.51)
mms2_inc_v_300sec <- c(43.25, 32.85, 64.90, 69.97, 63.98, 55.33, 50.16, 66.26, 62.12, 48.04, 35.52, 29.78, 28.70, 33.48, 29.06)
mms2_inc_hs <- c(59.89, 36.76, 42.68, 57.72, 84.13, 105.04, 92.34, 100.95, 117.02, 101.56, 103.75, 96.38, 90.49, 92.99, 93.48)

# Define MMS-2 Desiccation data vectors
mms2_des_v_5sec <- c(0.00, 0.00, 0.00, 0.00, 789.26, 393.59, 0.00, 0.00, 0.00, 288.94, 113.09, 0.00, 0.00)
mms2_des_v_15sec <- c(0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 1180.09, 0.00, 824.45)
mms2_des_v_30sec <- c(2432.45, 1912.08, 2589.81, 3388.28, 0.00, 0.00, 1260.09, 0.00, 0.00, 0.00, 0.00, 1771.09, 0.00, 0.00)
mms2_des_v_60sec <- c(0.00, 0.00, 0.00, 0.00, 0.00, 729.34, 832.48, 1084.42, 0.00, 0.00, 743.82, 457.02, 369.58, 783.05)
mms2_des_v_120sec <- c(0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00)
mms2_des_v_300sec <- c(9464.06, 4301.85, 11356.87, 10816.07, 0.00, 0.00, 4673.61, 0.00, 0.00,
                       3819.04, 0.00, 6429.94, 1585.60, 6692.82, 2021.70)
mms2_des_hs <- c(1210.48, 1928.08, 2058.36, 1206.48, 648.16, 0.00, 870.39, 923.14, 1582.53,
                 743.02, 0.00, 297.21, 591.53, 564.14)

# Combine all values
values <- c(
  mms2_inc_v_5sec, mms2_inc_v_15sec, mms2_inc_v_30sec, mms2_inc_v_60sec, mms2_inc_v_120sec,
  mms2_inc_v_300sec, mms2_inc_hs,
  mms2_des_v_5sec, mms2_des_v_15sec, mms2_des_v_30sec, mms2_des_v_60sec,
  mms2_des_v_120sec, mms2_des_v_300sec, mms2_des_hs
)

# Create factorA for treatment times including all levels from both datasets
factorA <- factor(c(
  rep("V5", length(mms2_inc_v_5sec)),
  rep("V15", length(mms2_inc_v_15sec)),
  rep("V30", length(mms2_inc_v_30sec)),
  rep("V60", length(mms2_inc_v_60sec)),
  rep("V120", length(mms2_inc_v_120sec)),
  rep("V300", length(mms2_inc_v_300sec)),
  rep("HS", length(mms2_inc_hs)),
  
  rep("V5", length(mms2_des_v_5sec)),
  rep("V15", length(mms2_des_v_15sec)),
  rep("V30", length(mms2_des_v_30sec)),
  rep("V60", length(mms2_des_v_60sec)),
  rep("V120", length(mms2_des_v_120sec)),
  rep("V300", length(mms2_des_v_300sec)),
  rep("HS", length(mms2_des_hs))
), levels = c("V5", "V15", "V30", "V60", "V120", "V300", "HS"))

# Create factorB to distinguish Incubation vs Desiccation
factorB <- factor(c(
  rep("Incubation", length(mms2_inc_v_5sec) + length(mms2_inc_v_15sec) + length(mms2_inc_v_30sec) +
        length(mms2_inc_v_60sec) + length(mms2_inc_v_120sec) + length(mms2_inc_v_300sec) + length(mms2_inc_hs)),
  rep("Desiccation", length(mms2_des_v_5sec) + length(mms2_des_v_15sec) + length(mms2_des_v_30sec) +
        length(mms2_des_v_60sec) + length(mms2_des_v_120sec) + length(mms2_des_v_300sec) + length(mms2_des_hs))
))

# Combine into data frame
df <- data.frame(value = values, factorA = factorA, factorB = factorB)

# Preview data
print(head(df))

# Run Scheirer-Ray-Hare test for factorA and factorB
srh_result <- scheirerRayHare(value ~ factorA + factorB, data = df)
print(srh_result)

# Convert SRH results to dataframe and save
srh_df <- as.data.frame(srh_result)
write.csv(srh_df, "bsub_motility_inc_des_SRH_results.csv", row.names = FALSE)

# Define significance cutoff
alpha <- 0.05

# Extract p-values from last column of srh_df
p_values <- srh_df[, ncol(srh_df)]

# Extract p-values for factorA and factorB
p_factorA <- p_values[1]
p_factorB <- p_values[2]

print(paste("p-value Factor A:", p_factorA))
print(paste("p-value Factor B:", p_factorB))

if (p_factorA <= alpha) {
  cat("FactorA (Treatment Time) is significant: p =", p_values[1], "\nRunning Dunn's post-hoc test for FactorA...\n")
  dunn_factorA <- dunn_test(data = df, formula = value ~ factorA, p.adjust.method = "holm")
  print(dunn_factorA)
  write.csv(dunn_factorA, "bsub_motility_inc_des_factorA_Dunn.csv", row.names = FALSE)
} else {
  message("FactorA (Treatment Time) is not significant; skipping Dunn's test for FactorA.")
}

if (p_factorB <= alpha) {
  cat("FactorB (Incubation vs Desiccation) is significant: p =", p_values[2], "\nRunning Dunn's post-hoc test for FactorB...\n")
  dunn_factorB <- dunn_test(data = df, formula = value ~ factorB, p.adjust.method = "holm")
  print(dunn_factorB)
  write.csv(dunn_factorB, "bsub_motility_inc_des_factorB_Dunn.csv", row.names = FALSE)
} else {
  message("FactorB (Incubation vs Desiccation) is not significant; skipping Dunn's test for FactorB.")
}
