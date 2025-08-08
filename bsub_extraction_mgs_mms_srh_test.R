# Install packages if not already installed
packages <- c("rcompanion", "rstatix", "ARTool", "emmeans")
install_if_missing <- function(p) {
  if (!requireNamespace(p, quietly = TRUE)) install.packages(p)
}
lapply(packages, install_if_missing)

# Load libraries
library(rcompanion)
library(rstatix)

# ----------------------------

# MGS-1 Incubation data
mgs1_inc_v_5sec <- c(20.58, 1.37, 1.70)
mgs1_inc_v_15sec <- c(0.56, 0.64, 0.92)
mgs1_inc_v_30sec <- c(2.07, 3.03, 2.52)
mgs1_inc_v_60sec <- c(0.72, 11.13, 4.23)
mgs1_inc_v_300sec <- c(240.06, 9.86)
mgs1_inc_hs <- c(36.62, 65.59, 115.28)

# MMS-2 Incubation data
mms2_inc_v_5sec <- c(104.12, 12468.96)
mms2_inc_v_15sec <- c(2277.68, 1825.30, 4121.88)
mms2_inc_v_30sec <- c(545.36, 356.53, 23224.55)
mms2_inc_v_60sec <- c(1138.87, 18101.11, 1091.28)
mms2_inc_v_300sec <- c(76.01, 107.14, 80.01)
mms2_inc_hs <- c(197.76, 48.63, 27.79)

# Combine groups into vectors of values
value <- c(
  mgs1_inc_v_5sec, mgs1_inc_v_15sec, mgs1_inc_v_30sec, mgs1_inc_v_60sec, mgs1_inc_v_300sec, mgs1_inc_hs,
  mms2_inc_v_5sec, mms2_inc_v_15sec, mms2_inc_v_30sec, mms2_inc_v_60sec, mms2_inc_v_300sec, mms2_inc_hs
)

# Create factors for treatment/time (factorA) and regolith/experiment (factorB)
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

df <- data.frame(value = value, factorA = factorA, factorB = factorB)

# Preview data
print(head(df))

# ----------------------------
# Run Scheirer-Ray-Hare test
srh_result <- scheirerRayHare(value ~ factorA + factorB, data = df)
print(srh_result)

# Convert SRH results to a data frame for easy handling
srh_df <- as.data.frame(srh_result)

# Save SRH results to CSV
write.csv(srh_df, "bsub_extraction_mgs_mms_SRH_results.csv", row.names = FALSE)

# Define significance cutoff
alpha <- 0.05

# Assume srh_df is your SRH summary, no colnames or partial colnames
# Extract p-values (last column)
p_values <- srh_df[, ncol(srh_df)]

# Extract factorA and factorB p-values:
p_factorA <- p_values[1]  # first row
p_factorB <- p_values[2]  # second row
print(p_factorA)
print(p_factorB)

if (p_factorA <= alpha) {
  cat("FactorA is significant: p =", p_factorA, "\n")
  dunn_factorA <- dunn_test(data = df, formula = value ~ factorA, p.adjust.method = "holm")
  print(dunn_factorA)
  write.csv(dunn_factorA, "bsub_extraction_mgs_mms_Dunn_factorA.csv", row.names = FALSE)
} else {
  message("FactorA is not significant; skipping Dunn's test for factorA.")
}

if (p_factorB <= alpha) {
  cat("FactorB is significant: p =", p_factorB, "\n")
  dunn_factorB <- dunn_test(data = df, formula = value ~ factorB, p.adjust.method = "holm")
  print(dunn_factorB)
  write.csv(dunn_factorB, "bsub_extraction_mgs_mms_Dunn_factorB.csv", row.names = FALSE)
} else {
  message("FactorB is not significant; skipping Dunn's test for factorB.")
}
