# ============================================================
# TITLE: Test–Retest Reliability Simulation and Response Instability Analysis
# AUTHOR: Valentine Joseph Owan
# R VERSION: 4.5.2
# DATE: 2026
# ============================================================
#
# DESCRIPTION:
# This script reproduces a simulation study examining how respondent-level
# variation influences test–retest reliability estimates. It generates
# synthetic data, computes reliability indices, applies correction methods,
# produces figures, and exports all outputs automatically.
#
# OUTPUTS (AUTOMATICALLY GENERATED):
# - Data:
#   * results_summary.csv
#   * full_simulation_data.csv
#   * cleaned_data.csv
#   * group_summary.csv
#   * class_counts.csv
#
# - Figures:
#   * Figure1_RCI_Boxplot.png
#   * Figure2_Reliability.png
#   * Figure3_Scatter_Raw.png
#   * Figure4_Scatter_Adjusted.png
#
# - Reproducibility:
#   * session_info.txt
#
# USAGE:
# Run this script from top to bottom. All outputs will be saved automatically.
# ============================================================


# =========================
# START MESSAGE
# =========================
cat("Running simulation...\n")

# =========================
# 1. SETUP
# =========================
rm(list = ls())
set.seed(12345)

# Install packages if missing
packages <- c("ggplot2")
installed <- packages %in% installed.packages()
if (any(!installed)) install.packages(packages[!installed])

library(ggplot2)

# Create folders
dir.create("outputs", showWarnings = FALSE)
dir.create("outputs/figures", showWarnings = FALSE)

# =========================
# 2. SIMULATION PARAMETERS
# =========================
N <- 1000
r_target <- 0.80

# =========================
# 3. GENERATE TRUE SCORES
# =========================
T <- rnorm(N, 0, 1)

error_var <- (1 - r_target) / r_target
error_sd <- sqrt(error_var)

e1 <- rnorm(N, 0, error_sd)
e2 <- rnorm(N, 0, error_sd)

# =========================
# 4. ASSIGN GROUPS
# =========================
group <- sample(c("Consistent", "Biased", "Inconsistent"),
                N, replace = TRUE,
                prob = c(0.6, 0.2, 0.2))

# =========================
# 5. GENERATE OBSERVED SCORES
# =========================
X1 <- numeric(N)
X2 <- numeric(N)

for (i in 1:N) {
  
  if (group[i] == "Consistent") {
    X1[i] <- T[i] + e1[i]
    X2[i] <- T[i] + e2[i]
  }
  
  if (group[i] == "Biased") {
    b <- rnorm(1, 0.5, 0.2)
    X1[i] <- T[i] + b + e1[i]
    X2[i] <- T[i] + b + e2[i]
  }
  
  if (group[i] == "Inconsistent") {
    delta <- rnorm(1, 0, 1)
    X1[i] <- T[i] + e1[i]
    X2[i] <- T[i] + e2[i] + delta
  }
}

data <- data.frame(id = 1:N, group, T, X1, X2)

# =========================
# 6. RELIABILITY (RAW)
# =========================
r_raw <- cor(data$X1, data$X2)

# =========================
# 7. COMPUTE RCI
# =========================
SD1 <- sd(data$X1)
SE <- SD1 * sqrt(1 - r_raw)
S_diff <- sqrt(2) * SE

data$RCI <- (data$X2 - data$X1) / S_diff
data$abs_RCI <- abs(data$RCI)

data$class <- ifelse(data$abs_RCI <= 1.50, "Stable",
              ifelse(data$abs_RCI <= 1.96, "Marginal",
                     "Inconsistent"))

# =========================
# 8. EXCLUSION METHOD
# =========================
clean_data <- subset(data, class != "Inconsistent")
r_exclusion <- cor(clean_data$X1, clean_data$X2)

# =========================
# 9. WEIGHTING METHOD
# =========================
data$weight <- 1 / (1 + data$abs_RCI)

w_mean_x1 <- sum(data$weight * data$X1) / sum(data$weight)
w_mean_x2 <- sum(data$weight * data$X2) / sum(data$weight)

w_cov <- sum(data$weight * (data$X1 - w_mean_x1) * (data$X2 - w_mean_x2)) / sum(data$weight)

w_var_x1 <- sum(data$weight * (data$X1 - w_mean_x1)^2) / sum(data$weight)
w_var_x2 <- sum(data$weight * (data$X2 - w_mean_x2)^2) / sum(data$weight)

r_weighted <- w_cov / sqrt(w_var_x1 * w_var_x2)

# =========================
# 10. ADJUSTMENT METHOD
# =========================
data$X2_adj <- data$X1 + (data$X2 - data$X1) * (1 / (1 + data$abs_RCI))
r_adjusted <- cor(data$X1, data$X2_adj)

# =========================
# 11. RESULTS TABLE
# =========================
results <- data.frame(
  Method = c("Raw", "Exclusion", "Weighting", "Adjustment"),
  Correlation = c(r_raw, r_exclusion, r_weighted, r_adjusted)
)

print(results)

# =========================
# 12. EXPORT DATA
# =========================
write.csv(results, "outputs/results_summary.csv", row.names = FALSE)
write.csv(data, "outputs/full_simulation_data.csv", row.names = FALSE)
write.csv(clean_data, "outputs/cleaned_data.csv", row.names = FALSE)

group_summary <- aggregate(abs_RCI ~ group, data = data, mean)
write.csv(group_summary, "outputs/group_summary.csv", row.names = FALSE)

class_counts <- as.data.frame(table(data$class))
write.csv(class_counts, "outputs/class_counts.csv", row.names = FALSE)

# =========================
# 13. FIGURES (BEAUTIFUL + CLEAN)
# =========================

# Color palette
cols <- c("#2C7BB6", "#FDAE61", "#D7191C")

# Figure 1
p1 <- ggplot(data, aes(class, abs_RCI, fill = class)) +
  geom_boxplot(alpha = 0.85) +
  scale_fill_manual(values = cols) +
  geom_hline(yintercept = 1.50, linetype = "dashed") +
  geom_hline(yintercept = 1.96, linetype = "dashed") +
  theme_minimal(base_size = 15)

ggsave("outputs/figures/Figure1_RCI_Boxplot.png", p1, width = 8, height = 6, dpi = 300)

# Figure 2
p2 <- ggplot(results, aes(Method, Correlation, fill = Method)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = round(Correlation, 3)), vjust = -0.5) +
  ylim(0, 1) +
  theme_minimal(base_size = 15)

ggsave("outputs/figures/Figure2_Reliability.png", p2, width = 8, height = 6, dpi = 300)

# Figure 3
p3 <- ggplot(data, aes(X1, X2, color = group)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, formula = y ~ x) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  scale_color_manual(values = cols) +
  theme_minimal(base_size = 15)

ggsave("outputs/figures/Figure3_Scatter_Raw.png", p3, width = 8, height = 6, dpi = 300)

# Figure 4
p4 <- ggplot(data, aes(X1, X2_adj, color = group)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, formula = y ~ x) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  scale_color_manual(values = cols) +
  theme_minimal(base_size = 15)

ggsave("outputs/figures/Figure4_Scatter_Adjusted.png", p4, width = 8, height = 6, dpi = 300)

# =========================
# 14. SESSION INFO
# =========================
capture.output(sessionInfo(), file = "outputs/session_info.txt")

cat("Done. Outputs saved in 'outputs' folder.\n")