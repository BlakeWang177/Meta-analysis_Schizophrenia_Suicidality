# Meta-analysis forest plot template using metafor
# Example subgroup: zuclopenthixol pharmacotherapy
#
# This script demonstrates how to:
#  1) Read aggregated effect estimates (HR/OR) from a CSV
#  2) Fit a random-effects meta-analysis using metafor::rma()
#  3) Produce a forest plot and save it as a PDF
#  4) Export summary statistics to a CSV
#
# Expected columns in the input CSV:
#   Study : character, study label
#   Effect: numeric, hazard ratio or odds ratio
#   CI_L  : numeric, lower bound of 95% CI
#   CI_U  : numeric, upper bound of 95% CI

library(dplyr)
library(metafor)
library(stringr)

## ---- Paths (relative to project root) --------------------------------------

# Set working directory to the project root (works inside RStudio)
if (requireNamespace("rstudioapi", quietly = TRUE) &&
    rstudioapi::isAvailable()) {
  
  this_path <- rstudioapi::getActiveDocumentContext()$path
  setwd(dirname(this_path))  # /code/
  setwd("..")                # project root
  
} else {
  message("rstudioapi not available; assuming working directory is project root.")
}

# Example data file for demonstration.
# Replace "example_input.csv" with your own aggregated dataset
# if you want to reproduce your project-specific analysis.
data_path <- "data/example_input.csv"

# Directory where figures and summary tables will be written
out_dir   <- "outputs"
if (!dir.exists("outputs")) dir.create("outputs")
if (!dir.exists("outputs/forest_plots")) dir.create("outputs/forest_plots")

# Name of subgroup for labeling outputs (e.g., a drug or risk-factor subgroup)
subgroup_name <- "zuclopenthixol"


## ---- 1. Read and prepare data ---------------------------------------------

dt <- read.csv(data_path, check.names = TRUE)

dt <- dt %>%
  mutate(
    yi  = log(Effect),
    sei = (log(CI_U) - log(CI_L)) / (2 * 1.96),
    vi  = sei^2
  ) %>%
  filter(is.finite(yi), is.finite(sei), sei > 0, Effect > 0)

if (nrow(dt) == 0) {
  stop("No valid rows after filtering. Please check Effect and CI columns.")
}


## ---- 2. Random-effects meta-analysis --------------------------------------

fit <- rma(yi = yi, sei = sei, data = dt, method = "REML")


## ---- 3. Forest plot --------------------------------------------------------

k            <- fit$k
slab_wrapped <- str_wrap(dt$Study, width = 32)

# x-axis limits on the log scale
alim_use <- log(c(0.5, 2))
xlim_use <- c(alim_use[1] - 0.8, alim_use[2] + 0.6)

# row positions for study labels
rows_pos <- seq(from = k, to = 1, by = -1) - 0.5

pdf(file.path(out_dir, paste0("forest_", subgroup_name, ".pdf")),
    width = 7, height = 5)

forest(
  fit,
  slab    = slab_wrapped,
  xlab    = "Hazard Ratio",
  cex     = 0.6,
  psize   = 0.9,
  at      = log(c(0.25, 0.5, 0.75, 1, 1.25, 1.5)),
  alim    = alim_use,
  atransf = exp,
  xlim    = xlim_use,
  ylim    = c(-2, k + 2.8),
  rows    = rows_pos
)

# Add prediction interval polygon
pr <- predict(fit)
addpoly(
  x      = pr$pred,
  ci.lb  = pr$pi.lb,
  ci.ub  = pr$pi.ub,
  row    = -1,
  atransf = exp,
  mlab   = "Prediction interval"
)

dev.off()


## ---- 4. Save summary statistics -------------------------------------------

results <- data.frame(
  k        = fit$k,
  Estimate = exp(fit$b),
  CI_lower = exp(fit$ci.lb),
  CI_upper = exp(fit$ci.ub),
  tau2     = fit$tau2,
  I2       = fit$I2,
  Q        = fit$QE,
  Q_df     = fit$k - 1,
  Q_p      = fit$QEp
)

write.csv(
  results,
  file.path(out_dir, paste0(subgroup_name, "_summary.csv")),
  row.names = FALSE
)
