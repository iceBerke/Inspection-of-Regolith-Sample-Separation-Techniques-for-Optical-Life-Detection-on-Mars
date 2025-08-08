# Install required packages if missing
packages <- c("rcompanion", "rstatix", "ARTool", "emmeans")
install_if_missing <- function(p) {
  if (!requireNamespace(p, quietly = TRUE)) install.packages(p)
}
lapply(packages, install_if_missing)

# Load libraries
library(rcompanion)
library(rstatix)

# Define MGS-1 Incubation data vectors
mgs1_inc_v_5sec <- c(0.00, 0.00, 0.00, 0.00, 171.77, 167.00, 182.18, 140.90, 473.74, 473.74, 473.74, 473.74)
mgs1_inc_v_15sec <- rep(473.74, 12)
mgs1_inc_v_30sec <- rep(473.74, 12)
mgs1_inc_v_60sec <- rep(473.74, 16)
mgs1_inc_v_300sec <- c(52.64, 323.53, 30.56, 206.50, 58.10, 236.87, 32.51, 236.87, 17.55, 8.77, 0.00, 183.92, 195.68, 136.50, 145.28)
mgs1_inc_hs <- c(133.99, 129.79, 68.67, 86.86, 89.85, 94.52, 72.24, 87.71, 47.81, 83.49, 42.16, 54.11, 81.68, 115.93, 202.09, 124.70, 130.69, 163.36)

# Define MMS-2 Incubation data vectors
mms2_inc_v_5sec <- c(25.36, 11.62, 24.80, 29.37, 26.57, 178.68, 174.64, 174.36, 144.26)
mms2_inc_v_15sec <- c(134.89, 117.37, 177.13, 185.99, 107.20, 106.87, 100.91, 81.92, 158.43, 140.46, 123.37, 167.05)
mms2_inc_v_30sec <- c(38.86, 50.95, 18.60, 31.52, 84.91, 58.45, 183.25, 142.91, 119.15, 128.80, 117.79, 123.99, 83.07)
mms2_inc_v_60sec <- c(140.75, 144.30, 164.25, 184.79, 107.01, 130.44, 144.94, 187.15, 104.44, 89.61, 52.43, 62.00, 61.67)
mms2_inc_v_300sec <- c(43.25, 32.85, 64.90, 69.97, 63.98, 55.33, 50.16, 66.26, 62.12, 48.04, 35.52, 29.78, 28.70, 33.48, 29.06)
mms2_inc_hs <- c(59.89, 36.76, 42.68, 57.72, 84.13, 105.04, 92.34, 100.95, 117.02, 101.56, 103.75, 96.38, 90.49, 92.99, 93.48)

# Combine all values
value <- c(
  mgs1_inc_v_5sec, mgs1_inc_v_15sec, mgs1_inc_v_30sec, mgs1_inc_v_60sec, mgs1_inc_v_300sec, mgs1_inc_hs,
  mms2_inc_v_5sec, mms2_inc_v_15sec, mms2_inc_v_30sec, mms2_inc_v_60sec, mms2_inc_v_300sec, mms2_inc_hs
)

# Create factors
factorA <- factor(c(
  rep("V5", length(mgs1_inc_v_5sec)),
  rep("V15", length(mgs1_inc_v_15sec)),
  rep("V30", length(mgs1_inc_v_30sec)),
  rep("V60", length(mgs1_inc_v_60sec)),
  rep("V300", length(mgs1_inc_v_300sec)),
  rep("HS", length(mgs1_inc_hs)),
  
  rep("V5", length(mms2_inc_v_5sec)),
  rep("V15", length(mms2_inc_v_15sec)),
  rep("V30", length(mms2_inc_v_30sec)),
  rep("V60", length(mms2_inc_v_60sec)),
  rep("V300", length(mms2_inc_v_300sec)),
  rep("HS", length(mms2_inc_hs))
))

factorB <- factor(c(
  rep("MGS-1", length(mgs1_inc_v_5sec) + length(mgs1_inc_v_15sec) + length(mgs1_inc_v_30sec) +
        length(mgs1_inc_v_60sec) + length(mgs1_inc_v_300sec) + length(mgs1_inc_hs)),
  rep("MMS-2", length(mms2_inc_v_5sec) + length(mms2_inc_v_15sec) + length(mms2_inc_v_30sec) +
        length(mms2_inc_v_60sec) + length(mms2_inc_v_300sec) + length(mms2_inc_hs))
))

# Combine into data frame
df <- data.frame(value = value, factorA = factorA, factorB = factorB)

# Preview dataset
print(head(df))

# Run Scheirer-Ray-Hare test
srh_result <- scheirerRayHare(value ~ factorA + factorB, data = df)
print(srh_result)

# Convert SRH results to dataframe
srh_df <- as.data.frame(srh_result)

# Save SRH results
write.csv(srh_df, "bsub_motility_mgs_mms_SRH_results.csv", row.names = FALSE)

# Define significance alpha
alpha <- 0.05

# Extract p-values from last column of srh_df
p_values <- srh_df[, ncol(srh_df)]

# Extract p-values for factorA and factorB
p_factorA <- p_values[1]
p_factorB <- p_values[2]

print(paste("p-value Factor A:", p_factorA))
print(paste("p-value Factor B:", p_factorB))

# If FactorA significant, run Dunn's test for factorA
if (p_factorA <= alpha) {
  cat("FactorA is significant: p =", p_factorA, "\nRunning Dunn's post-hoc test for factorA...\n")
  dunn_factorA <- dunn_test(data = df, formula = value ~ factorA, p.adjust.method = "holm")
  print(dunn_factorA)
  write.csv(dunn_factorA, "bsub_motility_mgs_mms_Dunn_factorA.csv", row.names = FALSE)
} else {
  message("FactorA is not significant; skipping Dunn's test for factorA.")
}

# If FactorB significant, run Dunn's test for factorB
if (p_factorB <= alpha) {
  cat("FactorB is significant: p =", p_factorB, "\nRunning Dunn's post-hoc test for factorB...\n")
  dunn_factorB <- dunn_test(data = df, formula = value ~ factorB, p.adjust.method = "holm")
  print(dunn_factorB)
  write.csv(dunn_factorB, "bsub_motility_mgs_mms_Dunn_factorB.csv", row.names = FALSE)
} else {
  message("FactorB is not significant; skipping Dunn's test for factorB.")
}
