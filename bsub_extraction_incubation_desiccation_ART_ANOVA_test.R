# Check if packages are installed; install if missing, then load them
packages <- c("ARTool", "emmeans")

for (p in packages) {
  if (!requireNamespace(p, quietly = TRUE)) {
    install.packages(p)
  }
  library(p, character.only = TRUE)
}

# MMS-2 Incubation data (as before)
mms2_inc_v_5sec <- c(104.12, 12468.96)
mms2_inc_v_15sec <- c(2277.68, 1825.30, 4121.88)
mms2_inc_v_30sec <- c(545.36, 356.53, 23224.55)
mms2_inc_v_60sec <- c(1138.87, 18101.11, 1091.28)
mms2_inc_v_120sec <- c(230.95, 91.50, 173.21)
mms2_inc_v_300sec <- c(76.01, 107.14, 80.01)
mms2_inc_hs <- c(197.76, 48.63, 27.79)

# MMS-2 Desiccation data
mms2_ds_v_5sec <- c(76.42, 10.40, 49.49)
mms2_ds_v_15sec <- c(8.52, 9.54, 0.81)
mms2_ds_v_30sec <- c(10.14, 1.59, 6.00)
mms2_ds_v_60sec <- c(0.89, 5.48, 34.96)
mms2_ds_v_120sec <- c(5.12, 0.80)
mms2_ds_v_300sec <- c(1.00, 0.32, 0.91)
mms2_ds_hs <- c(19.01, 23.00, 13.93)

# Combine values
values <- c(
  mms2_inc_v_5sec, mms2_inc_v_15sec, mms2_inc_v_30sec, mms2_inc_v_60sec, mms2_inc_v_120sec, mms2_inc_v_300sec, mms2_inc_hs,
  mms2_ds_v_5sec, mms2_ds_v_15sec, mms2_ds_v_30sec, mms2_ds_v_60sec, mms2_ds_v_120sec, mms2_ds_v_300sec, mms2_ds_hs
)

factor_treatment <- factor(c(
  rep("V5", length(mms2_inc_v_5sec)),
  rep("V15", length(mms2_inc_v_15sec)),
  rep("V30", length(mms2_inc_v_30sec)),
  rep("V60", length(mms2_inc_v_60sec)),
  rep("V120", length(mms2_inc_v_120sec)),
  rep("V300", length(mms2_inc_v_300sec)),
  rep("HS", length(mms2_inc_hs)),
  
  rep("V5", length(mms2_ds_v_5sec)),
  rep("V15", length(mms2_ds_v_15sec)),
  rep("V30", length(mms2_ds_v_30sec)),
  rep("V60", length(mms2_ds_v_60sec)),
  rep("V120", length(mms2_ds_v_120sec)),
  rep("V300", length(mms2_ds_v_300sec)),
  rep("HS", length(mms2_ds_hs))
))

factor_condition <- factor(c(
  rep("Incubation", 
      sum(length(mms2_inc_v_5sec), length(mms2_inc_v_15sec), length(mms2_inc_v_30sec),
          length(mms2_inc_v_60sec), length(mms2_inc_v_120sec), length(mms2_inc_v_300sec), length(mms2_inc_hs))),
  rep("Desiccation", 
      sum(length(mms2_ds_v_5sec), length(mms2_ds_v_15sec), length(mms2_ds_v_30sec),
          length(mms2_ds_v_60sec), length(mms2_ds_v_120sec), length(mms2_ds_v_300sec), length(mms2_ds_hs)))
))

df <- data.frame(
  value = values,
  treatment = factor_treatment,
  condition = factor_condition
)

# Preview data
head(df)

# Run ART ANOVA with interaction between treatment and condition
art_model <- art(value ~ treatment * condition, data = df)

# Run ANOVA and save results in an object
anova_results <- anova(art_model)
print(anova_results)

# Convert ANOVA results summary to a data frame for easier manipulation
anova_df <- as.data.frame(anova_results)

# Save the ANOVA table as CSV
write.csv(anova_df, "bsub_extraction_incubation_desiccation_ART_ANOVA.csv", row.names = TRUE)

p_values <- c(
  treatment = anova_results["treatment", "Pr(>F)"],       # Replace with actual row & col names
  condition = anova_results["condition", "Pr(>F)"],
  interaction = anova_results["treatment:condition", "Pr(>F)"]
)
print(p_values)

# Set significance threshold
alpha <- 0.05

# 1. Pairwise comparisons for treatment, if significant
if (!is.na(p_values["treatment"]) && p_values["treatment"] <= alpha) {
  emmeans_treatment <- emmeans(artlm(art_model, "treatment"), pairwise ~ treatment, adjust = "holm")
  print(emmeans_treatment)
  # Save results to CSV; extract summary table for the pairwise contrasts
  write.csv(as.data.frame(emmeans_treatment$contrasts), "bsub_extraction_treatment_emmeans.csv", row.names = FALSE)
} else {
  message("No significant effect for treatment; skipping pairwise comparisons for treatment.")
}

# 2. Pairwise comparisons for condition, if significant
if (!is.na(p_values["condition"]) && p_values["condition"] <= alpha) {
  emmeans_condition <- emmeans(artlm(art_model, "condition"), pairwise ~ condition, adjust = "holm")
  print(emmeans_condition)
  write.csv(as.data.frame(emmeans_condition$contrasts), "bsub_extraction_condition_emmeans.csv", row.names = FALSE)
} else {
  message("No significant effect for condition; skipping pairwise comparisons for condition.")
}

# 3. Pairwise comparisons for interaction, if significant
if (!is.na(p_values["interaction"]) && p_values["interaction"] <= alpha) {
  emmeans_interaction <- emmeans(artlm(art_model, "treatment:condition"), pairwise ~ treatment * condition, adjust = "holm")
  print(emmeans_interaction)
  write.csv(as.data.frame(emmeans_interaction$contrasts), "bsub_extraction_interaction_emmeans.csv", row.names = FALSE)
} else {
  message("No significant interaction effect; skipping pairwise comparisons for interaction.")
}

